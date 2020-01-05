/**
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

package org.apache.hadoop.hbase.replication.regionserver;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.hbase.classification.InterfaceAudience;
import org.apache.hadoop.hbase.CompatibilitySingletonFactory;
import org.apache.hadoop.hbase.HBaseInterfaceAudience;
import org.apache.hadoop.hbase.util.EnvironmentEdgeManager;

/**
 * This class is for maintaining the various replication statistics for a source and publishing them
 * through the metrics interfaces.
 */
@InterfaceAudience.LimitedPrivate(HBaseInterfaceAudience.REPLICATION)
public class MetricsSource {

  public static final Log LOG = LogFactory.getLog(MetricsSource.class);

  private long lastTimestamp = 0;
  private int lastQueueSize = 0;
  private String id;

  private final MetricsReplicationSourceSource singleSourceSource;
  private final MetricsReplicationSourceSource globalSourceSource;

  /**
   * Constructor used to register the metrics
   *
   * @param id Name of the source this class is monitoring
   */
  public MetricsSource(String id) {
    this.id = id;
    singleSourceSource =
        CompatibilitySingletonFactory.getInstance(MetricsReplicationSourceFactory.class)
            .getSource(id);
    globalSourceSource = CompatibilitySingletonFactory.getInstance(MetricsReplicationSourceFactory.class).getGlobalSource();
  }

  /**
   * Set the age of the last edit that was shipped
   *
   * @param timestamp write time of the edit
   */
  public void setAgeOfLastShippedOp(long timestamp) {
    long age = EnvironmentEdgeManager.currentTime() - timestamp;
    singleSourceSource.setLastShippedAge(age);
    globalSourceSource.setLastShippedAge(Math.max(age, globalSourceSource.getLastShippedAge()));
    this.lastTimestamp = timestamp;
  }

  /**
   * Convenience method to use the last given timestamp to refresh the age of the last edit. Used
   * when replication fails and need to keep that metric accurate.
   */
  public void refreshAgeOfLastShippedOp() {
    if (this.lastTimestamp > 0) {
      setAgeOfLastShippedOp(this.lastTimestamp);
    }
  }

  /**
   * Set the size of the log queue
   *
   * @param size the size.
   */
  public void setSizeOfLogQueue(int size) {
    singleSourceSource.setSizeOfLogQueue(size);
    globalSourceSource.incrSizeOfLogQueue(size - lastQueueSize);
    lastQueueSize = size;
  }

  /**
   * Add on the the number of log edits read
   *
   * @param delta the number of log edits read.
   */
  private void incrLogEditsRead(long delta) {
    singleSourceSource.incrLogReadInEdits(delta);
    globalSourceSource.incrLogReadInEdits(delta);
  }

  /** Increment the number of log edits read by one. */
  public void incrLogEditsRead() {
    incrLogEditsRead(1);
  }

  /**
   * Add on the number of log edits filtered
   *
   * @param delta the number filtered.
   */
  public void incrLogEditsFiltered(long delta) {
    singleSourceSource.incrLogEditsFiltered(delta);
    globalSourceSource.incrLogEditsFiltered(delta);
  }

  /** The number of log edits filtered out. */
  public void incrLogEditsFiltered() {
    incrLogEditsFiltered(1);
  }

  /**
   * Convience method to apply changes to metrics do to shipping a batch of logs.
   *
   * @param batchSize the size of the batch that was shipped to sinks.
   */
  public void shipBatch(long batchSize, int sizeInKB) {
    singleSourceSource.incrBatchesShipped(1);
    globalSourceSource.incrBatchesShipped(1);

    singleSourceSource.incrOpsShipped(batchSize);
    globalSourceSource.incrOpsShipped(batchSize);

    singleSourceSource.incrShippedKBs(sizeInKB);
    globalSourceSource.incrShippedKBs(sizeInKB);
  }

  /** increase the byte number read by source from log file */
  public void incrLogReadInBytes(long readInBytes) {
    singleSourceSource.incrLogReadInBytes(readInBytes);
    globalSourceSource.incrLogReadInBytes(readInBytes);
  }

  /** Removes all metrics about this Source. */
  public void clear() {
    singleSourceSource.clear();
    globalSourceSource.decrSizeOfLogQueue(lastQueueSize);
    lastQueueSize = 0;
  }

  /**
   * Get AgeOfLastShippedOp
   * @return AgeOfLastShippedOp
   */
  public Long getAgeOfLastShippedOp() {
    return singleSourceSource.getLastShippedAge();
  }

  /**
   * Get the sizeOfLogQueue
   * @return sizeOfLogQueue
   */
  public int getSizeOfLogQueue() {
    return this.lastQueueSize;
  }

  /**
   * Get the timeStampsOfLastShippedOp
   * @return lastTimestampForAge
   */
  public long getTimeStampOfLastShippedOp() {
    return lastTimestamp;
  }

  /**
   * Get the slave peer ID
   * @return peerID
   */
  public String getPeerID() {
    return id;
  }

  public void incrUnknownFileLengthForClosedWAL() {
    singleSourceSource.incrUnknownFileLengthForClosedWAL();
    globalSourceSource.incrUnknownFileLengthForClosedWAL();
  }

  public void incrUncleanlyClosedWALs() {
    singleSourceSource.incrUncleanlyClosedWALs();
    globalSourceSource.incrUncleanlyClosedWALs();
  }

  public void incrBytesSkippedInUncleanlyClosedWALs(final long bytes) {
    singleSourceSource.incrBytesSkippedInUncleanlyClosedWALs(bytes);
    globalSourceSource.incrBytesSkippedInUncleanlyClosedWALs(bytes);
  }

  public void incrRestartedWALReading() {
    singleSourceSource.incrRestartedWALReading();
    globalSourceSource.incrRestartedWALReading();
  }

  public void incrRepeatedFileBytes(final long bytes) {
    singleSourceSource.incrRepeatedFileBytes(bytes);
    globalSourceSource.incrRepeatedFileBytes(bytes);
  }

  public void incrCompletedWAL() {
    singleSourceSource.incrCompletedWAL();
    globalSourceSource.incrCompletedWAL();
  }

  public void incrCompletedRecoveryQueue() {
    singleSourceSource.incrCompletedRecoveryQueue();
    globalSourceSource.incrCompletedRecoveryQueue();
  }
}
