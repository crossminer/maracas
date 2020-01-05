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
package org.apache.hadoop.hbase.mapred;

import java.io.IOException;

import org.apache.hadoop.fs.FileAlreadyExistsException;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.classification.InterfaceAudience;
import org.apache.hadoop.hbase.classification.InterfaceStability;
import org.apache.hadoop.hbase.client.BufferedMutator;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.InvalidJobConfException;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.RecordWriter;
import org.apache.hadoop.mapred.Reporter;
import org.apache.hadoop.util.Progressable;

/**
 * Convert Map/Reduce output and write it to an HBase table
 */
@InterfaceAudience.Public
@InterfaceStability.Stable
public class TableOutputFormat extends FileOutputFormat<ImmutableBytesWritable, Put> {

  /** JobConf parameter that specifies the output table */
  public static final String OUTPUT_TABLE = "hbase.mapred.outputtable";

  /**
   * Convert Reduce output (key, value) to (HStoreKey, KeyedDataArrayWritable)
   * and write to an HBase table.
   */
  protected static class TableRecordWriter implements RecordWriter<ImmutableBytesWritable, Put> {
    private BufferedMutator m_mutator;

    /**
     * Instantiate a TableRecordWriter with the HBase HClient for writing. Assumes control over the
     * lifecycle of {@code conn}.
     */
    public TableRecordWriter(final BufferedMutator mutator) throws IOException {
      this.m_mutator = mutator;
    }

    public void close(Reporter reporter) throws IOException {
      this.m_mutator.close();
    }

    public void write(ImmutableBytesWritable key, Put value) throws IOException {
      m_mutator.mutate(new Put(value));
    }
  }

  @Override
  public RecordWriter getRecordWriter(FileSystem ignored, JobConf job, String name,
      Progressable progress)
  throws IOException {
    // expecting exactly one path
    TableName tableName = TableName.valueOf(job.get(OUTPUT_TABLE));
    BufferedMutator mutator =  null;
    // Connection is not closed. Dies with JVM.  No possibility for cleanup.
    Connection connection = ConnectionFactory.createConnection(job);
    mutator = connection.getBufferedMutator(tableName);
    // Clear write buffer on fail is true by default so no need to reset it.
    return new TableRecordWriter(mutator);
  }

  @Override
  public void checkOutputSpecs(FileSystem ignored, JobConf job)
  throws FileAlreadyExistsException, InvalidJobConfException, IOException {
    String tableName = job.get(OUTPUT_TABLE);
    if (tableName == null) {
      throw new IOException("Must specify table name");
    }
  }
}
