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
package org.apache.hadoop.hbase.io.hfile;

import org.apache.hadoop.hbase.classification.InterfaceAudience;
import org.apache.hadoop.hbase.io.HeapSize;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.hbase.util.ClassSize;

/**
 * Cache Key for use with implementations of {@link BlockCache}
 */
@InterfaceAudience.Private
public class BlockCacheKey implements HeapSize, java.io.Serializable {
  private static final long serialVersionUID = -5199992013113130534L;
  private final String hfileName;
  private final long offset;

  /**
   * Construct a new BlockCacheKey
   * @param hfileName The name of the HFile this block belongs to.
   * @param offset Offset of the block into the file
   */
  public BlockCacheKey(String hfileName, long offset) {
    this.hfileName = hfileName;
    this.offset = offset;
  }

  @Override
  public int hashCode() {
    return hfileName.hashCode() * 127 + (int) (offset ^ (offset >>> 32));
  }

  @Override
  public boolean equals(Object o) {
    if (o instanceof BlockCacheKey) {
      BlockCacheKey k = (BlockCacheKey) o;
      return offset == k.offset
          && (hfileName == null ? k.hfileName == null : hfileName
              .equals(k.hfileName));
    } else {
      return false;
    }
  }

  @Override
  public String toString() {
    return String.format("%s_%d", hfileName, offset);
  }

  public static final long FIXED_OVERHEAD = ClassSize.align(ClassSize.OBJECT +
          ClassSize.REFERENCE + // this.hfileName
          Bytes.SIZEOF_LONG);    // this.offset

  /**
   * Strings have two bytes per character due to default Java Unicode encoding
   * (hence length times 2).
   */
  @Override
  public long heapSize() {
    return ClassSize.align(FIXED_OVERHEAD + ClassSize.STRING +
            2 * hfileName.length());
  }

  // can't avoid this unfortunately
  /**
   * @return The hfileName portion of this cache key
   */
  public String getHfileName() {
    return hfileName;
  }

  public long getOffset() {
    return offset;
  }
}
