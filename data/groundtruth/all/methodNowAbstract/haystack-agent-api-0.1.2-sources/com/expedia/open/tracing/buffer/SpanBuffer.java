// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: spanBuffer.proto

package com.expedia.open.tracing.buffer;

/**
 * <pre>
 * This entity represents a collection of spans that belong to one traceId
 * </pre>
 *
 * Protobuf type {@code SpanBuffer}
 */
public  final class SpanBuffer extends
    com.google.protobuf.GeneratedMessageV3 implements
    // @@protoc_insertion_point(message_implements:SpanBuffer)
    SpanBufferOrBuilder {
  // Use SpanBuffer.newBuilder() to construct.
  private SpanBuffer(com.google.protobuf.GeneratedMessageV3.Builder<?> builder) {
    super(builder);
  }
  private SpanBuffer() {
    traceId_ = "";
    childSpans_ = java.util.Collections.emptyList();
  }

  @java.lang.Override
  public final com.google.protobuf.UnknownFieldSet
  getUnknownFields() {
    return com.google.protobuf.UnknownFieldSet.getDefaultInstance();
  }
  private SpanBuffer(
      com.google.protobuf.CodedInputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    this();
    int mutable_bitField0_ = 0;
    try {
      boolean done = false;
      while (!done) {
        int tag = input.readTag();
        switch (tag) {
          case 0:
            done = true;
            break;
          default: {
            if (!input.skipField(tag)) {
              done = true;
            }
            break;
          }
          case 10: {
            java.lang.String s = input.readStringRequireUtf8();

            traceId_ = s;
            break;
          }
          case 18: {
            if (!((mutable_bitField0_ & 0x00000002) == 0x00000002)) {
              childSpans_ = new java.util.ArrayList<com.expedia.open.tracing.Span>();
              mutable_bitField0_ |= 0x00000002;
            }
            childSpans_.add(
                input.readMessage(com.expedia.open.tracing.Span.parser(), extensionRegistry));
            break;
          }
        }
      }
    } catch (com.google.protobuf.InvalidProtocolBufferException e) {
      throw e.setUnfinishedMessage(this);
    } catch (java.io.IOException e) {
      throw new com.google.protobuf.InvalidProtocolBufferException(
          e).setUnfinishedMessage(this);
    } finally {
      if (((mutable_bitField0_ & 0x00000002) == 0x00000002)) {
        childSpans_ = java.util.Collections.unmodifiableList(childSpans_);
      }
      makeExtensionsImmutable();
    }
  }
  public static final com.google.protobuf.Descriptors.Descriptor
      getDescriptor() {
    return com.expedia.open.tracing.buffer.SpanBufferOuterClass.internal_static_SpanBuffer_descriptor;
  }

  protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internalGetFieldAccessorTable() {
    return com.expedia.open.tracing.buffer.SpanBufferOuterClass.internal_static_SpanBuffer_fieldAccessorTable
        .ensureFieldAccessorsInitialized(
            com.expedia.open.tracing.buffer.SpanBuffer.class, com.expedia.open.tracing.buffer.SpanBuffer.Builder.class);
  }

  private int bitField0_;
  public static final int TRACEID_FIELD_NUMBER = 1;
  private volatile java.lang.Object traceId_;
  /**
   * <pre>
   * unique trace id
   * </pre>
   *
   * <code>optional string traceId = 1;</code>
   */
  public java.lang.String getTraceId() {
    java.lang.Object ref = traceId_;
    if (ref instanceof java.lang.String) {
      return (java.lang.String) ref;
    } else {
      com.google.protobuf.ByteString bs = 
          (com.google.protobuf.ByteString) ref;
      java.lang.String s = bs.toStringUtf8();
      traceId_ = s;
      return s;
    }
  }
  /**
   * <pre>
   * unique trace id
   * </pre>
   *
   * <code>optional string traceId = 1;</code>
   */
  public com.google.protobuf.ByteString
      getTraceIdBytes() {
    java.lang.Object ref = traceId_;
    if (ref instanceof java.lang.String) {
      com.google.protobuf.ByteString b = 
          com.google.protobuf.ByteString.copyFromUtf8(
              (java.lang.String) ref);
      traceId_ = b;
      return b;
    } else {
      return (com.google.protobuf.ByteString) ref;
    }
  }

  public static final int CHILDSPANS_FIELD_NUMBER = 2;
  private java.util.List<com.expedia.open.tracing.Span> childSpans_;
  /**
   * <pre>
   * list of child spans
   * </pre>
   *
   * <code>repeated .Span childSpans = 2;</code>
   */
  public java.util.List<com.expedia.open.tracing.Span> getChildSpansList() {
    return childSpans_;
  }
  /**
   * <pre>
   * list of child spans
   * </pre>
   *
   * <code>repeated .Span childSpans = 2;</code>
   */
  public java.util.List<? extends com.expedia.open.tracing.SpanOrBuilder> 
      getChildSpansOrBuilderList() {
    return childSpans_;
  }
  /**
   * <pre>
   * list of child spans
   * </pre>
   *
   * <code>repeated .Span childSpans = 2;</code>
   */
  public int getChildSpansCount() {
    return childSpans_.size();
  }
  /**
   * <pre>
   * list of child spans
   * </pre>
   *
   * <code>repeated .Span childSpans = 2;</code>
   */
  public com.expedia.open.tracing.Span getChildSpans(int index) {
    return childSpans_.get(index);
  }
  /**
   * <pre>
   * list of child spans
   * </pre>
   *
   * <code>repeated .Span childSpans = 2;</code>
   */
  public com.expedia.open.tracing.SpanOrBuilder getChildSpansOrBuilder(
      int index) {
    return childSpans_.get(index);
  }

  private byte memoizedIsInitialized = -1;
  public final boolean isInitialized() {
    byte isInitialized = memoizedIsInitialized;
    if (isInitialized == 1) return true;
    if (isInitialized == 0) return false;

    memoizedIsInitialized = 1;
    return true;
  }

  public void writeTo(com.google.protobuf.CodedOutputStream output)
                      throws java.io.IOException {
    if (!getTraceIdBytes().isEmpty()) {
      com.google.protobuf.GeneratedMessageV3.writeString(output, 1, traceId_);
    }
    for (int i = 0; i < childSpans_.size(); i++) {
      output.writeMessage(2, childSpans_.get(i));
    }
  }

  public int getSerializedSize() {
    int size = memoizedSize;
    if (size != -1) return size;

    size = 0;
    if (!getTraceIdBytes().isEmpty()) {
      size += com.google.protobuf.GeneratedMessageV3.computeStringSize(1, traceId_);
    }
    for (int i = 0; i < childSpans_.size(); i++) {
      size += com.google.protobuf.CodedOutputStream
        .computeMessageSize(2, childSpans_.get(i));
    }
    memoizedSize = size;
    return size;
  }

  private static final long serialVersionUID = 0L;
  @java.lang.Override
  public boolean equals(final java.lang.Object obj) {
    if (obj == this) {
     return true;
    }
    if (!(obj instanceof com.expedia.open.tracing.buffer.SpanBuffer)) {
      return super.equals(obj);
    }
    com.expedia.open.tracing.buffer.SpanBuffer other = (com.expedia.open.tracing.buffer.SpanBuffer) obj;

    boolean result = true;
    result = result && getTraceId()
        .equals(other.getTraceId());
    result = result && getChildSpansList()
        .equals(other.getChildSpansList());
    return result;
  }

  @java.lang.Override
  public int hashCode() {
    if (memoizedHashCode != 0) {
      return memoizedHashCode;
    }
    int hash = 41;
    hash = (19 * hash) + getDescriptorForType().hashCode();
    hash = (37 * hash) + TRACEID_FIELD_NUMBER;
    hash = (53 * hash) + getTraceId().hashCode();
    if (getChildSpansCount() > 0) {
      hash = (37 * hash) + CHILDSPANS_FIELD_NUMBER;
      hash = (53 * hash) + getChildSpansList().hashCode();
    }
    hash = (29 * hash) + unknownFields.hashCode();
    memoizedHashCode = hash;
    return hash;
  }

  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(
      com.google.protobuf.ByteString data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(
      com.google.protobuf.ByteString data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(byte[] data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(
      byte[] data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input, extensionRegistry);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseDelimitedFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseDelimitedFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input, extensionRegistry);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(
      com.google.protobuf.CodedInputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.buffer.SpanBuffer parseFrom(
      com.google.protobuf.CodedInputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input, extensionRegistry);
  }

  public Builder newBuilderForType() { return newBuilder(); }
  public static Builder newBuilder() {
    return DEFAULT_INSTANCE.toBuilder();
  }
  public static Builder newBuilder(com.expedia.open.tracing.buffer.SpanBuffer prototype) {
    return DEFAULT_INSTANCE.toBuilder().mergeFrom(prototype);
  }
  public Builder toBuilder() {
    return this == DEFAULT_INSTANCE
        ? new Builder() : new Builder().mergeFrom(this);
  }

  @java.lang.Override
  protected Builder newBuilderForType(
      com.google.protobuf.GeneratedMessageV3.BuilderParent parent) {
    Builder builder = new Builder(parent);
    return builder;
  }
  /**
   * <pre>
   * This entity represents a collection of spans that belong to one traceId
   * </pre>
   *
   * Protobuf type {@code SpanBuffer}
   */
  public static final class Builder extends
      com.google.protobuf.GeneratedMessageV3.Builder<Builder> implements
      // @@protoc_insertion_point(builder_implements:SpanBuffer)
      com.expedia.open.tracing.buffer.SpanBufferOrBuilder {
    public static final com.google.protobuf.Descriptors.Descriptor
        getDescriptor() {
      return com.expedia.open.tracing.buffer.SpanBufferOuterClass.internal_static_SpanBuffer_descriptor;
    }

    protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
        internalGetFieldAccessorTable() {
      return com.expedia.open.tracing.buffer.SpanBufferOuterClass.internal_static_SpanBuffer_fieldAccessorTable
          .ensureFieldAccessorsInitialized(
              com.expedia.open.tracing.buffer.SpanBuffer.class, com.expedia.open.tracing.buffer.SpanBuffer.Builder.class);
    }

    // Construct using com.expedia.open.tracing.buffer.SpanBuffer.newBuilder()
    private Builder() {
      maybeForceBuilderInitialization();
    }

    private Builder(
        com.google.protobuf.GeneratedMessageV3.BuilderParent parent) {
      super(parent);
      maybeForceBuilderInitialization();
    }
    private void maybeForceBuilderInitialization() {
      if (com.google.protobuf.GeneratedMessageV3
              .alwaysUseFieldBuilders) {
        getChildSpansFieldBuilder();
      }
    }
    public Builder clear() {
      super.clear();
      traceId_ = "";

      if (childSpansBuilder_ == null) {
        childSpans_ = java.util.Collections.emptyList();
        bitField0_ = (bitField0_ & ~0x00000002);
      } else {
        childSpansBuilder_.clear();
      }
      return this;
    }

    public com.google.protobuf.Descriptors.Descriptor
        getDescriptorForType() {
      return com.expedia.open.tracing.buffer.SpanBufferOuterClass.internal_static_SpanBuffer_descriptor;
    }

    public com.expedia.open.tracing.buffer.SpanBuffer getDefaultInstanceForType() {
      return com.expedia.open.tracing.buffer.SpanBuffer.getDefaultInstance();
    }

    public com.expedia.open.tracing.buffer.SpanBuffer build() {
      com.expedia.open.tracing.buffer.SpanBuffer result = buildPartial();
      if (!result.isInitialized()) {
        throw newUninitializedMessageException(result);
      }
      return result;
    }

    public com.expedia.open.tracing.buffer.SpanBuffer buildPartial() {
      com.expedia.open.tracing.buffer.SpanBuffer result = new com.expedia.open.tracing.buffer.SpanBuffer(this);
      int from_bitField0_ = bitField0_;
      int to_bitField0_ = 0;
      result.traceId_ = traceId_;
      if (childSpansBuilder_ == null) {
        if (((bitField0_ & 0x00000002) == 0x00000002)) {
          childSpans_ = java.util.Collections.unmodifiableList(childSpans_);
          bitField0_ = (bitField0_ & ~0x00000002);
        }
        result.childSpans_ = childSpans_;
      } else {
        result.childSpans_ = childSpansBuilder_.build();
      }
      result.bitField0_ = to_bitField0_;
      onBuilt();
      return result;
    }

    public Builder clone() {
      return (Builder) super.clone();
    }
    public Builder setField(
        com.google.protobuf.Descriptors.FieldDescriptor field,
        Object value) {
      return (Builder) super.setField(field, value);
    }
    public Builder clearField(
        com.google.protobuf.Descriptors.FieldDescriptor field) {
      return (Builder) super.clearField(field);
    }
    public Builder clearOneof(
        com.google.protobuf.Descriptors.OneofDescriptor oneof) {
      return (Builder) super.clearOneof(oneof);
    }
    public Builder setRepeatedField(
        com.google.protobuf.Descriptors.FieldDescriptor field,
        int index, Object value) {
      return (Builder) super.setRepeatedField(field, index, value);
    }
    public Builder addRepeatedField(
        com.google.protobuf.Descriptors.FieldDescriptor field,
        Object value) {
      return (Builder) super.addRepeatedField(field, value);
    }
    public Builder mergeFrom(com.google.protobuf.Message other) {
      if (other instanceof com.expedia.open.tracing.buffer.SpanBuffer) {
        return mergeFrom((com.expedia.open.tracing.buffer.SpanBuffer)other);
      } else {
        super.mergeFrom(other);
        return this;
      }
    }

    public Builder mergeFrom(com.expedia.open.tracing.buffer.SpanBuffer other) {
      if (other == com.expedia.open.tracing.buffer.SpanBuffer.getDefaultInstance()) return this;
      if (!other.getTraceId().isEmpty()) {
        traceId_ = other.traceId_;
        onChanged();
      }
      if (childSpansBuilder_ == null) {
        if (!other.childSpans_.isEmpty()) {
          if (childSpans_.isEmpty()) {
            childSpans_ = other.childSpans_;
            bitField0_ = (bitField0_ & ~0x00000002);
          } else {
            ensureChildSpansIsMutable();
            childSpans_.addAll(other.childSpans_);
          }
          onChanged();
        }
      } else {
        if (!other.childSpans_.isEmpty()) {
          if (childSpansBuilder_.isEmpty()) {
            childSpansBuilder_.dispose();
            childSpansBuilder_ = null;
            childSpans_ = other.childSpans_;
            bitField0_ = (bitField0_ & ~0x00000002);
            childSpansBuilder_ = 
              com.google.protobuf.GeneratedMessageV3.alwaysUseFieldBuilders ?
                 getChildSpansFieldBuilder() : null;
          } else {
            childSpansBuilder_.addAllMessages(other.childSpans_);
          }
        }
      }
      onChanged();
      return this;
    }

    public final boolean isInitialized() {
      return true;
    }

    public Builder mergeFrom(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws java.io.IOException {
      com.expedia.open.tracing.buffer.SpanBuffer parsedMessage = null;
      try {
        parsedMessage = PARSER.parsePartialFrom(input, extensionRegistry);
      } catch (com.google.protobuf.InvalidProtocolBufferException e) {
        parsedMessage = (com.expedia.open.tracing.buffer.SpanBuffer) e.getUnfinishedMessage();
        throw e.unwrapIOException();
      } finally {
        if (parsedMessage != null) {
          mergeFrom(parsedMessage);
        }
      }
      return this;
    }
    private int bitField0_;

    private java.lang.Object traceId_ = "";
    /**
     * <pre>
     * unique trace id
     * </pre>
     *
     * <code>optional string traceId = 1;</code>
     */
    public java.lang.String getTraceId() {
      java.lang.Object ref = traceId_;
      if (!(ref instanceof java.lang.String)) {
        com.google.protobuf.ByteString bs =
            (com.google.protobuf.ByteString) ref;
        java.lang.String s = bs.toStringUtf8();
        traceId_ = s;
        return s;
      } else {
        return (java.lang.String) ref;
      }
    }
    /**
     * <pre>
     * unique trace id
     * </pre>
     *
     * <code>optional string traceId = 1;</code>
     */
    public com.google.protobuf.ByteString
        getTraceIdBytes() {
      java.lang.Object ref = traceId_;
      if (ref instanceof String) {
        com.google.protobuf.ByteString b = 
            com.google.protobuf.ByteString.copyFromUtf8(
                (java.lang.String) ref);
        traceId_ = b;
        return b;
      } else {
        return (com.google.protobuf.ByteString) ref;
      }
    }
    /**
     * <pre>
     * unique trace id
     * </pre>
     *
     * <code>optional string traceId = 1;</code>
     */
    public Builder setTraceId(
        java.lang.String value) {
      if (value == null) {
    throw new NullPointerException();
  }
  
      traceId_ = value;
      onChanged();
      return this;
    }
    /**
     * <pre>
     * unique trace id
     * </pre>
     *
     * <code>optional string traceId = 1;</code>
     */
    public Builder clearTraceId() {
      
      traceId_ = getDefaultInstance().getTraceId();
      onChanged();
      return this;
    }
    /**
     * <pre>
     * unique trace id
     * </pre>
     *
     * <code>optional string traceId = 1;</code>
     */
    public Builder setTraceIdBytes(
        com.google.protobuf.ByteString value) {
      if (value == null) {
    throw new NullPointerException();
  }
  checkByteStringIsUtf8(value);
      
      traceId_ = value;
      onChanged();
      return this;
    }

    private java.util.List<com.expedia.open.tracing.Span> childSpans_ =
      java.util.Collections.emptyList();
    private void ensureChildSpansIsMutable() {
      if (!((bitField0_ & 0x00000002) == 0x00000002)) {
        childSpans_ = new java.util.ArrayList<com.expedia.open.tracing.Span>(childSpans_);
        bitField0_ |= 0x00000002;
       }
    }

    private com.google.protobuf.RepeatedFieldBuilderV3<
        com.expedia.open.tracing.Span, com.expedia.open.tracing.Span.Builder, com.expedia.open.tracing.SpanOrBuilder> childSpansBuilder_;

    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public java.util.List<com.expedia.open.tracing.Span> getChildSpansList() {
      if (childSpansBuilder_ == null) {
        return java.util.Collections.unmodifiableList(childSpans_);
      } else {
        return childSpansBuilder_.getMessageList();
      }
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public int getChildSpansCount() {
      if (childSpansBuilder_ == null) {
        return childSpans_.size();
      } else {
        return childSpansBuilder_.getCount();
      }
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public com.expedia.open.tracing.Span getChildSpans(int index) {
      if (childSpansBuilder_ == null) {
        return childSpans_.get(index);
      } else {
        return childSpansBuilder_.getMessage(index);
      }
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder setChildSpans(
        int index, com.expedia.open.tracing.Span value) {
      if (childSpansBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        ensureChildSpansIsMutable();
        childSpans_.set(index, value);
        onChanged();
      } else {
        childSpansBuilder_.setMessage(index, value);
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder setChildSpans(
        int index, com.expedia.open.tracing.Span.Builder builderForValue) {
      if (childSpansBuilder_ == null) {
        ensureChildSpansIsMutable();
        childSpans_.set(index, builderForValue.build());
        onChanged();
      } else {
        childSpansBuilder_.setMessage(index, builderForValue.build());
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder addChildSpans(com.expedia.open.tracing.Span value) {
      if (childSpansBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        ensureChildSpansIsMutable();
        childSpans_.add(value);
        onChanged();
      } else {
        childSpansBuilder_.addMessage(value);
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder addChildSpans(
        int index, com.expedia.open.tracing.Span value) {
      if (childSpansBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        ensureChildSpansIsMutable();
        childSpans_.add(index, value);
        onChanged();
      } else {
        childSpansBuilder_.addMessage(index, value);
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder addChildSpans(
        com.expedia.open.tracing.Span.Builder builderForValue) {
      if (childSpansBuilder_ == null) {
        ensureChildSpansIsMutable();
        childSpans_.add(builderForValue.build());
        onChanged();
      } else {
        childSpansBuilder_.addMessage(builderForValue.build());
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder addChildSpans(
        int index, com.expedia.open.tracing.Span.Builder builderForValue) {
      if (childSpansBuilder_ == null) {
        ensureChildSpansIsMutable();
        childSpans_.add(index, builderForValue.build());
        onChanged();
      } else {
        childSpansBuilder_.addMessage(index, builderForValue.build());
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder addAllChildSpans(
        java.lang.Iterable<? extends com.expedia.open.tracing.Span> values) {
      if (childSpansBuilder_ == null) {
        ensureChildSpansIsMutable();
        com.google.protobuf.AbstractMessageLite.Builder.addAll(
            values, childSpans_);
        onChanged();
      } else {
        childSpansBuilder_.addAllMessages(values);
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder clearChildSpans() {
      if (childSpansBuilder_ == null) {
        childSpans_ = java.util.Collections.emptyList();
        bitField0_ = (bitField0_ & ~0x00000002);
        onChanged();
      } else {
        childSpansBuilder_.clear();
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public Builder removeChildSpans(int index) {
      if (childSpansBuilder_ == null) {
        ensureChildSpansIsMutable();
        childSpans_.remove(index);
        onChanged();
      } else {
        childSpansBuilder_.remove(index);
      }
      return this;
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public com.expedia.open.tracing.Span.Builder getChildSpansBuilder(
        int index) {
      return getChildSpansFieldBuilder().getBuilder(index);
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public com.expedia.open.tracing.SpanOrBuilder getChildSpansOrBuilder(
        int index) {
      if (childSpansBuilder_ == null) {
        return childSpans_.get(index);  } else {
        return childSpansBuilder_.getMessageOrBuilder(index);
      }
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public java.util.List<? extends com.expedia.open.tracing.SpanOrBuilder> 
         getChildSpansOrBuilderList() {
      if (childSpansBuilder_ != null) {
        return childSpansBuilder_.getMessageOrBuilderList();
      } else {
        return java.util.Collections.unmodifiableList(childSpans_);
      }
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public com.expedia.open.tracing.Span.Builder addChildSpansBuilder() {
      return getChildSpansFieldBuilder().addBuilder(
          com.expedia.open.tracing.Span.getDefaultInstance());
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public com.expedia.open.tracing.Span.Builder addChildSpansBuilder(
        int index) {
      return getChildSpansFieldBuilder().addBuilder(
          index, com.expedia.open.tracing.Span.getDefaultInstance());
    }
    /**
     * <pre>
     * list of child spans
     * </pre>
     *
     * <code>repeated .Span childSpans = 2;</code>
     */
    public java.util.List<com.expedia.open.tracing.Span.Builder> 
         getChildSpansBuilderList() {
      return getChildSpansFieldBuilder().getBuilderList();
    }
    private com.google.protobuf.RepeatedFieldBuilderV3<
        com.expedia.open.tracing.Span, com.expedia.open.tracing.Span.Builder, com.expedia.open.tracing.SpanOrBuilder> 
        getChildSpansFieldBuilder() {
      if (childSpansBuilder_ == null) {
        childSpansBuilder_ = new com.google.protobuf.RepeatedFieldBuilderV3<
            com.expedia.open.tracing.Span, com.expedia.open.tracing.Span.Builder, com.expedia.open.tracing.SpanOrBuilder>(
                childSpans_,
                ((bitField0_ & 0x00000002) == 0x00000002),
                getParentForChildren(),
                isClean());
        childSpans_ = null;
      }
      return childSpansBuilder_;
    }
    public final Builder setUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return this;
    }

    public final Builder mergeUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return this;
    }


    // @@protoc_insertion_point(builder_scope:SpanBuffer)
  }

  // @@protoc_insertion_point(class_scope:SpanBuffer)
  private static final com.expedia.open.tracing.buffer.SpanBuffer DEFAULT_INSTANCE;
  static {
    DEFAULT_INSTANCE = new com.expedia.open.tracing.buffer.SpanBuffer();
  }

  public static com.expedia.open.tracing.buffer.SpanBuffer getDefaultInstance() {
    return DEFAULT_INSTANCE;
  }

  private static final com.google.protobuf.Parser<SpanBuffer>
      PARSER = new com.google.protobuf.AbstractParser<SpanBuffer>() {
    public SpanBuffer parsePartialFrom(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
        return new SpanBuffer(input, extensionRegistry);
    }
  };

  public static com.google.protobuf.Parser<SpanBuffer> parser() {
    return PARSER;
  }

  @java.lang.Override
  public com.google.protobuf.Parser<SpanBuffer> getParserForType() {
    return PARSER;
  }

  public com.expedia.open.tracing.buffer.SpanBuffer getDefaultInstanceForType() {
    return DEFAULT_INSTANCE;
  }

}

