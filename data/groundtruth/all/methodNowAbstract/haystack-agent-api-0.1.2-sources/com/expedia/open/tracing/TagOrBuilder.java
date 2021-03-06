// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: span.proto

package com.expedia.open.tracing;

public interface TagOrBuilder extends
    // @@protoc_insertion_point(interface_extends:Tag)
    com.google.protobuf.MessageOrBuilder {

  /**
   * <pre>
   * name of the tag key
   * </pre>
   *
   * <code>optional string key = 1;</code>
   */
  java.lang.String getKey();
  /**
   * <pre>
   * name of the tag key
   * </pre>
   *
   * <code>optional string key = 1;</code>
   */
  com.google.protobuf.ByteString
      getKeyBytes();

  /**
   * <pre>
   * type of tag, namely string, double, bool, long and binary
   * </pre>
   *
   * <code>optional .Tag.TagType type = 2;</code>
   */
  int getTypeValue();
  /**
   * <pre>
   * type of tag, namely string, double, bool, long and binary
   * </pre>
   *
   * <code>optional .Tag.TagType type = 2;</code>
   */
  com.expedia.open.tracing.Tag.TagType getType();

  /**
   * <pre>
   * string value type
   * </pre>
   *
   * <code>optional string vStr = 3;</code>
   */
  java.lang.String getVStr();
  /**
   * <pre>
   * string value type
   * </pre>
   *
   * <code>optional string vStr = 3;</code>
   */
  com.google.protobuf.ByteString
      getVStrBytes();

  /**
   * <pre>
   * long value type
   * </pre>
   *
   * <code>optional int64 vLong = 4;</code>
   */
  long getVLong();

  /**
   * <pre>
   * double value type
   * </pre>
   *
   * <code>optional double vDouble = 5;</code>
   */
  double getVDouble();

  /**
   * <pre>
   * bool value type
   * </pre>
   *
   * <code>optional bool vBool = 6;</code>
   */
  boolean getVBool();

  /**
   * <pre>
   * byte array value type
   * </pre>
   *
   * <code>optional bytes vBytes = 7;</code>
   */
  com.google.protobuf.ByteString getVBytes();

  public com.expedia.open.tracing.Tag.MyvalueCase getMyvalueCase();
}
