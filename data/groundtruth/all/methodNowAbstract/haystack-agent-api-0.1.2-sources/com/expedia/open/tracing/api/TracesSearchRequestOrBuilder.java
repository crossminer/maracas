// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: api/traceReader.proto

package com.expedia.open.tracing.api;

public interface TracesSearchRequestOrBuilder extends
    // @@protoc_insertion_point(interface_extends:TracesSearchRequest)
    com.google.protobuf.MessageOrBuilder {

  /**
   * <pre>
   * fields to filter traces
   * </pre>
   *
   * <code>repeated .Field fields = 1;</code>
   */
  java.util.List<com.expedia.open.tracing.api.Field> 
      getFieldsList();
  /**
   * <pre>
   * fields to filter traces
   * </pre>
   *
   * <code>repeated .Field fields = 1;</code>
   */
  com.expedia.open.tracing.api.Field getFields(int index);
  /**
   * <pre>
   * fields to filter traces
   * </pre>
   *
   * <code>repeated .Field fields = 1;</code>
   */
  int getFieldsCount();
  /**
   * <pre>
   * fields to filter traces
   * </pre>
   *
   * <code>repeated .Field fields = 1;</code>
   */
  java.util.List<? extends com.expedia.open.tracing.api.FieldOrBuilder> 
      getFieldsOrBuilderList();
  /**
   * <pre>
   * fields to filter traces
   * </pre>
   *
   * <code>repeated .Field fields = 1;</code>
   */
  com.expedia.open.tracing.api.FieldOrBuilder getFieldsOrBuilder(
      int index);

  /**
   * <pre>
   * search window start time in microseconds time from epoch
   * </pre>
   *
   * <code>optional int64 startTime = 2;</code>
   */
  long getStartTime();

  /**
   * <pre>
   * search window end time in microseconds time from epoch
   * </pre>
   *
   * <code>optional int64 endTime = 3;</code>
   */
  long getEndTime();

  /**
   * <pre>
   * limit on number of results to return
   * </pre>
   *
   * <code>optional int32 limit = 4;</code>
   */
  int getLimit();
}
