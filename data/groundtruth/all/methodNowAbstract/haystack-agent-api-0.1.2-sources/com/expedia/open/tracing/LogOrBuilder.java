// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: span.proto

package com.expedia.open.tracing;

public interface LogOrBuilder extends
    // @@protoc_insertion_point(interface_extends:Log)
    com.google.protobuf.MessageOrBuilder {

  /**
   * <pre>
   * timestamp in microseconds since epoch
   * </pre>
   *
   * <code>optional int64 timestamp = 1;</code>
   */
  long getTimestamp();

  /**
   * <code>repeated .Tag fields = 2;</code>
   */
  java.util.List<com.expedia.open.tracing.Tag> 
      getFieldsList();
  /**
   * <code>repeated .Tag fields = 2;</code>
   */
  com.expedia.open.tracing.Tag getFields(int index);
  /**
   * <code>repeated .Tag fields = 2;</code>
   */
  int getFieldsCount();
  /**
   * <code>repeated .Tag fields = 2;</code>
   */
  java.util.List<? extends com.expedia.open.tracing.TagOrBuilder> 
      getFieldsOrBuilderList();
  /**
   * <code>repeated .Tag fields = 2;</code>
   */
  com.expedia.open.tracing.TagOrBuilder getFieldsOrBuilder(
      int index);
}
