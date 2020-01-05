/**
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.hadoop.hbase.mapreduce.replication;

import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.hbase.*;
import org.apache.hadoop.hbase.client.HConnectable;
import org.apache.hadoop.hbase.client.HConnection;
import org.apache.hadoop.hbase.client.HConnectionManager;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.client.Table;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.mapreduce.TableInputFormat;
import org.apache.hadoop.hbase.mapreduce.TableMapReduceUtil;
import org.apache.hadoop.hbase.mapreduce.TableMapper;
import org.apache.hadoop.hbase.mapreduce.TableSplit;
import org.apache.hadoop.hbase.replication.ReplicationException;
import org.apache.hadoop.hbase.replication.ReplicationFactory;
import org.apache.hadoop.hbase.replication.ReplicationPeerZKImpl;
import org.apache.hadoop.hbase.replication.ReplicationPeerConfig;
import org.apache.hadoop.hbase.replication.ReplicationPeers;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.hbase.util.Pair;
import org.apache.hadoop.hbase.zookeeper.ZooKeeperWatcher;
import org.apache.hadoop.hbase.zookeeper.ZKUtil;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.output.NullOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

/**
 * This map-only job compares the data from a local table with a remote one.
 * Every cell is compared and must have exactly the same keys (even timestamp)
 * as well as same value. It is possible to restrict the job by time range and
 * families. The peer id that's provided must match the one given when the
 * replication stream was setup.
 * <p>
 * Two counters are provided, Verifier.Counters.GOODROWS and BADROWS. The reason
 * for a why a row is different is shown in the map's log.
 */
public class VerifyReplication extends Configured implements Tool {

  private static final Log LOG =
      LogFactory.getLog(VerifyReplication.class);

  public final static String NAME = "verifyrep";
  static long startTime = 0;
  static long endTime = Long.MAX_VALUE;
  static int versions = -1;
  static String tableName = null;
  static String families = null;
  static String peerId = null;

  /**
   * Map-only comparator for 2 tables
   */
  public static class Verifier
      extends TableMapper<ImmutableBytesWritable, Put> {

    public static enum Counters {
      GOODROWS, BADROWS, ONLY_IN_SOURCE_TABLE_ROWS, ONLY_IN_PEER_TABLE_ROWS, CONTENT_DIFFERENT_ROWS}

    private ResultScanner replicatedScanner;
    private Result currentCompareRowInPeerTable;
    private Table replicatedTable;

    /**
     * Map method that compares every scanned row with the equivalent from
     * a distant cluster.
     * @param row  The current table row key.
     * @param value  The columns.
     * @param context  The current context.
     * @throws IOException When something is broken with the data.
     */
    @Override
    public void map(ImmutableBytesWritable row, final Result value,
                    Context context)
        throws IOException {
      if (replicatedScanner == null) {
        Configuration conf = context.getConfiguration();
        final Scan scan = new Scan();
        scan.setCaching(conf.getInt(TableInputFormat.SCAN_CACHEDROWS, 1));
        long startTime = conf.getLong(NAME + ".startTime", 0);
        long endTime = conf.getLong(NAME + ".endTime", Long.MAX_VALUE);
        String families = conf.get(NAME + ".families", null);
        if(families != null) {
          String[] fams = families.split(",");
          for(String fam : fams) {
            scan.addFamily(Bytes.toBytes(fam));
          }
        }
        scan.setTimeRange(startTime, endTime);
        if (versions >= 0) {
          scan.setMaxVersions(versions);
        }

        final TableSplit tableSplit = (TableSplit)(context.getInputSplit());
        HConnectionManager.execute(new HConnectable<Void>(conf) {
          @Override
          public Void connect(HConnection conn) throws IOException {
            String zkClusterKey = conf.get(NAME + ".peerQuorumAddress");
            Configuration peerConf = HBaseConfiguration.create(conf);
            ZKUtil.applyClusterKeyToConf(peerConf, zkClusterKey);

            TableName tableName = TableName.valueOf(conf.get(NAME + ".tableName"));
            replicatedTable = new HTable(peerConf, tableName);
            scan.setStartRow(value.getRow());
            scan.setStopRow(tableSplit.getEndRow());
            replicatedScanner = replicatedTable.getScanner(scan);
            return null;
          }
        });
        currentCompareRowInPeerTable = replicatedScanner.next();
      }
      while (true) {
        if (currentCompareRowInPeerTable == null) {
          // reach the region end of peer table, row only in source table
          logFailRowAndIncreaseCounter(context, Counters.ONLY_IN_SOURCE_TABLE_ROWS, value);
          break;
        }
        int rowCmpRet = Bytes.compareTo(value.getRow(), currentCompareRowInPeerTable.getRow());
        if (rowCmpRet == 0) {
          // rowkey is same, need to compare the content of the row
          try {
            Result.compareResults(value, currentCompareRowInPeerTable);
            context.getCounter(Counters.GOODROWS).increment(1);
          } catch (Exception e) {
            logFailRowAndIncreaseCounter(context, Counters.CONTENT_DIFFERENT_ROWS, value);
            LOG.error("Exception while comparing row : " + e);
          }
          currentCompareRowInPeerTable = replicatedScanner.next();
          break;
        } else if (rowCmpRet < 0) {
          // row only exists in source table
          logFailRowAndIncreaseCounter(context, Counters.ONLY_IN_SOURCE_TABLE_ROWS, value);
          break;
        } else {
          // row only exists in peer table
          logFailRowAndIncreaseCounter(context, Counters.ONLY_IN_PEER_TABLE_ROWS,
            currentCompareRowInPeerTable);
          currentCompareRowInPeerTable = replicatedScanner.next();
        }
      }
    }

    private void logFailRowAndIncreaseCounter(Context context, Counters counter, Result row) {
      context.getCounter(counter).increment(1);
      context.getCounter(Counters.BADROWS).increment(1);
      LOG.error(counter.toString() + ", rowkey=" + Bytes.toString(row.getRow()));
    }

    @Override
    protected void cleanup(Context context) {
      if (replicatedScanner != null) {
        try {
          while (currentCompareRowInPeerTable != null) {
            logFailRowAndIncreaseCounter(context, Counters.ONLY_IN_PEER_TABLE_ROWS,
              currentCompareRowInPeerTable);
            currentCompareRowInPeerTable = replicatedScanner.next();
          }
        } catch (Exception e) {
          LOG.error("fail to scan peer table in cleanup", e);
        } finally {
          replicatedScanner.close();
          replicatedScanner = null;
        }
      }
      if (replicatedTable != null) {
        TableName tableName = replicatedTable.getName();
        try {
          replicatedTable.close();
        } catch (IOException ioe) {
          LOG.warn("Exception closing " + tableName, ioe);
        }
      }
    }
  }

  private static String getPeerQuorumAddress(final Configuration conf) throws IOException {
    ZooKeeperWatcher localZKW = null;
    ReplicationPeerZKImpl peer = null;
    try {
      localZKW = new ZooKeeperWatcher(conf, "VerifyReplication",
          new Abortable() {
            @Override public void abort(String why, Throwable e) {}
            @Override public boolean isAborted() {return false;}
          });

      ReplicationPeers rp = ReplicationFactory.getReplicationPeers(localZKW, conf, localZKW);
      rp.init();

      Pair<ReplicationPeerConfig, Configuration> pair = rp.getPeerConf(peerId);
      if (pair == null) {
        throw new IOException("Couldn't get peer conf!");
      }
      Configuration peerConf = rp.getPeerConf(peerId).getSecond();
      return ZKUtil.getZooKeeperClusterKey(peerConf);
    } catch (ReplicationException e) {
      throw new IOException(
          "An error occured while trying to connect to the remove peer cluster", e);
    } finally {
      if (peer != null) {
        peer.close();
      }
      if (localZKW != null) {
        localZKW.close();
      }
    }
  }

  /**
   * Sets up the actual job.
   *
   * @param conf  The current configuration.
   * @param args  The command line parameters.
   * @return The newly created job.
   * @throws java.io.IOException When setting up the job fails.
   */
  public static Job createSubmittableJob(Configuration conf, String[] args)
  throws IOException {
    if (!doCommandLine(args)) {
      return null;
    }
    if (!conf.getBoolean(HConstants.REPLICATION_ENABLE_KEY,
        HConstants.REPLICATION_ENABLE_DEFAULT)) {
      throw new IOException("Replication needs to be enabled to verify it.");
    }
    conf.set(NAME+".peerId", peerId);
    conf.set(NAME+".tableName", tableName);
    conf.setLong(NAME+".startTime", startTime);
    conf.setLong(NAME+".endTime", endTime);
    if (families != null) {
      conf.set(NAME+".families", families);
    }

    String peerQuorumAddress = getPeerQuorumAddress(conf);
    conf.set(NAME + ".peerQuorumAddress", peerQuorumAddress);
    LOG.info("Peer Quorum Address: " + peerQuorumAddress);

    Job job = new Job(conf, NAME + "_" + tableName);
    job.setJarByClass(VerifyReplication.class);

    Scan scan = new Scan();
    scan.setTimeRange(startTime, endTime);
    if (versions >= 0) {
      scan.setMaxVersions(versions);
    }
    if(families != null) {
      String[] fams = families.split(",");
      for(String fam : fams) {
        scan.addFamily(Bytes.toBytes(fam));
      }
    }
    TableMapReduceUtil.initTableMapperJob(tableName, scan,
        Verifier.class, null, null, job);

    // Obtain the auth token from peer cluster
    TableMapReduceUtil.initCredentialsForCluster(job, peerQuorumAddress);

    job.setOutputFormatClass(NullOutputFormat.class);
    job.setNumReduceTasks(0);
    return job;
  }

  private static boolean doCommandLine(final String[] args) {
    if (args.length < 2) {
      printUsage(null);
      return false;
    }
    try {
      for (int i = 0; i < args.length; i++) {
        String cmd = args[i];
        if (cmd.equals("-h") || cmd.startsWith("--h")) {
          printUsage(null);
          return false;
        }

        final String startTimeArgKey = "--starttime=";
        if (cmd.startsWith(startTimeArgKey)) {
          startTime = Long.parseLong(cmd.substring(startTimeArgKey.length()));
          continue;
        }

        final String endTimeArgKey = "--endtime=";
        if (cmd.startsWith(endTimeArgKey)) {
          endTime = Long.parseLong(cmd.substring(endTimeArgKey.length()));
          continue;
        }

        final String versionsArgKey = "--versions=";
        if (cmd.startsWith(versionsArgKey)) {
          versions = Integer.parseInt(cmd.substring(versionsArgKey.length()));
          continue;
        }

        final String familiesArgKey = "--families=";
        if (cmd.startsWith(familiesArgKey)) {
          families = cmd.substring(familiesArgKey.length());
          continue;
        }

        if (i == args.length-2) {
          peerId = cmd;
        }

        if (i == args.length-1) {
          tableName = cmd;
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
      printUsage("Can't start because " + e.getMessage());
      return false;
    }
    return true;
  }

  /*
   * @param errorMsg Error message.  Can be null.
   */
  private static void printUsage(final String errorMsg) {
    if (errorMsg != null && errorMsg.length() > 0) {
      System.err.println("ERROR: " + errorMsg);
    }
    System.err.println("Usage: verifyrep [--starttime=X]" +
        " [--stoptime=Y] [--families=A] <peerid> <tablename>");
    System.err.println();
    System.err.println("Options:");
    System.err.println(" starttime    beginning of the time range");
    System.err.println("              without endtime means from starttime to forever");
    System.err.println(" endtime      end of the time range");
    System.err.println(" versions     number of cell versions to verify");
    System.err.println(" families     comma-separated list of families to copy");
    System.err.println();
    System.err.println("Args:");
    System.err.println(" peerid       Id of the peer used for verification, must match the one given for replication");
    System.err.println(" tablename    Name of the table to verify");
    System.err.println();
    System.err.println("Examples:");
    System.err.println(" To verify the data replicated from TestTable for a 1 hour window with peer #5 ");
    System.err.println(" $ bin/hbase " +
        "org.apache.hadoop.hbase.mapreduce.replication.VerifyReplication" +
        " --starttime=1265875194289 --endtime=1265878794289 5 TestTable ");
  }

  @Override
  public int run(String[] args) throws Exception {
    Configuration conf = this.getConf();
    Job job = createSubmittableJob(conf, args);
    if (job != null) {
      return job.waitForCompletion(true) ? 0 : 1;
    } 
    return 1;
  }

  /**
   * Main entry point.
   *
   * @param args  The command line parameters.
   * @throws Exception When running the job fails.
   */
  public static void main(String[] args) throws Exception {
    int res = ToolRunner.run(HBaseConfiguration.create(), new VerifyReplication(), args);
    System.exit(res);
  }
}
