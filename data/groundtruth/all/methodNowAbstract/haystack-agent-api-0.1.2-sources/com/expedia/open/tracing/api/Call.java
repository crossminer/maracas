// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: api/traceReader.proto

package com.expedia.open.tracing.api;

/**
 * Protobuf type {@code Call}
 */
public  final class Call extends
    com.google.protobuf.GeneratedMessageV3 implements
    // @@protoc_insertion_point(message_implements:Call)
    CallOrBuilder {
  // Use Call.newBuilder() to construct.
  private Call(com.google.protobuf.GeneratedMessageV3.Builder<?> builder) {
    super(builder);
  }
  private Call() {
    networkDelta_ = 0L;
  }

  @java.lang.Override
  public final com.google.protobuf.UnknownFieldSet
  getUnknownFields() {
    return com.google.protobuf.UnknownFieldSet.getDefaultInstance();
  }
  private Call(
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
            com.expedia.open.tracing.api.CallNode.Builder subBuilder = null;
            if (from_ != null) {
              subBuilder = from_.toBuilder();
            }
            from_ = input.readMessage(com.expedia.open.tracing.api.CallNode.parser(), extensionRegistry);
            if (subBuilder != null) {
              subBuilder.mergeFrom(from_);
              from_ = subBuilder.buildPartial();
            }

            break;
          }
          case 18: {
            com.expedia.open.tracing.api.CallNode.Builder subBuilder = null;
            if (to_ != null) {
              subBuilder = to_.toBuilder();
            }
            to_ = input.readMessage(com.expedia.open.tracing.api.CallNode.parser(), extensionRegistry);
            if (subBuilder != null) {
              subBuilder.mergeFrom(to_);
              to_ = subBuilder.buildPartial();
            }

            break;
          }
          case 24: {

            networkDelta_ = input.readInt64();
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
      makeExtensionsImmutable();
    }
  }
  public static final com.google.protobuf.Descriptors.Descriptor
      getDescriptor() {
    return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_Call_descriptor;
  }

  protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internalGetFieldAccessorTable() {
    return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_Call_fieldAccessorTable
        .ensureFieldAccessorsInitialized(
            com.expedia.open.tracing.api.Call.class, com.expedia.open.tracing.api.Call.Builder.class);
  }

  public static final int FROM_FIELD_NUMBER = 1;
  private com.expedia.open.tracing.api.CallNode from_;
  /**
   * <pre>
   * service node from which call was started
   * </pre>
   *
   * <code>optional .CallNode from = 1;</code>
   */
  public boolean hasFrom() {
    return from_ != null;
  }
  /**
   * <pre>
   * service node from which call was started
   * </pre>
   *
   * <code>optional .CallNode from = 1;</code>
   */
  public com.expedia.open.tracing.api.CallNode getFrom() {
    return from_ == null ? com.expedia.open.tracing.api.CallNode.getDefaultInstance() : from_;
  }
  /**
   * <pre>
   * service node from which call was started
   * </pre>
   *
   * <code>optional .CallNode from = 1;</code>
   */
  public com.expedia.open.tracing.api.CallNodeOrBuilder getFromOrBuilder() {
    return getFrom();
  }

  public static final int TO_FIELD_NUMBER = 2;
  private com.expedia.open.tracing.api.CallNode to_;
  /**
   * <pre>
   * service node to which call was terminated
   * </pre>
   *
   * <code>optional .CallNode to = 2;</code>
   */
  public boolean hasTo() {
    return to_ != null;
  }
  /**
   * <pre>
   * service node to which call was terminated
   * </pre>
   *
   * <code>optional .CallNode to = 2;</code>
   */
  public com.expedia.open.tracing.api.CallNode getTo() {
    return to_ == null ? com.expedia.open.tracing.api.CallNode.getDefaultInstance() : to_;
  }
  /**
   * <pre>
   * service node to which call was terminated
   * </pre>
   *
   * <code>optional .CallNode to = 2;</code>
   */
  public com.expedia.open.tracing.api.CallNodeOrBuilder getToOrBuilder() {
    return getTo();
  }

  public static final int NETWORKDELTA_FIELD_NUMBER = 3;
  private long networkDelta_;
  /**
   * <pre>
   * time delta in transit
   * </pre>
   *
   * <code>optional int64 networkDelta = 3;</code>
   */
  public long getNetworkDelta() {
    return networkDelta_;
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
    if (from_ != null) {
      output.writeMessage(1, getFrom());
    }
    if (to_ != null) {
      output.writeMessage(2, getTo());
    }
    if (networkDelta_ != 0L) {
      output.writeInt64(3, networkDelta_);
    }
  }

  public int getSerializedSize() {
    int size = memoizedSize;
    if (size != -1) return size;

    size = 0;
    if (from_ != null) {
      size += com.google.protobuf.CodedOutputStream
        .computeMessageSize(1, getFrom());
    }
    if (to_ != null) {
      size += com.google.protobuf.CodedOutputStream
        .computeMessageSize(2, getTo());
    }
    if (networkDelta_ != 0L) {
      size += com.google.protobuf.CodedOutputStream
        .computeInt64Size(3, networkDelta_);
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
    if (!(obj instanceof com.expedia.open.tracing.api.Call)) {
      return super.equals(obj);
    }
    com.expedia.open.tracing.api.Call other = (com.expedia.open.tracing.api.Call) obj;

    boolean result = true;
    result = result && (hasFrom() == other.hasFrom());
    if (hasFrom()) {
      result = result && getFrom()
          .equals(other.getFrom());
    }
    result = result && (hasTo() == other.hasTo());
    if (hasTo()) {
      result = result && getTo()
          .equals(other.getTo());
    }
    result = result && (getNetworkDelta()
        == other.getNetworkDelta());
    return result;
  }

  @java.lang.Override
  public int hashCode() {
    if (memoizedHashCode != 0) {
      return memoizedHashCode;
    }
    int hash = 41;
    hash = (19 * hash) + getDescriptorForType().hashCode();
    if (hasFrom()) {
      hash = (37 * hash) + FROM_FIELD_NUMBER;
      hash = (53 * hash) + getFrom().hashCode();
    }
    if (hasTo()) {
      hash = (37 * hash) + TO_FIELD_NUMBER;
      hash = (53 * hash) + getTo().hashCode();
    }
    hash = (37 * hash) + NETWORKDELTA_FIELD_NUMBER;
    hash = (53 * hash) + com.google.protobuf.Internal.hashLong(
        getNetworkDelta());
    hash = (29 * hash) + unknownFields.hashCode();
    memoizedHashCode = hash;
    return hash;
  }

  public static com.expedia.open.tracing.api.Call parseFrom(
      com.google.protobuf.ByteString data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static com.expedia.open.tracing.api.Call parseFrom(
      com.google.protobuf.ByteString data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.Call parseFrom(byte[] data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static com.expedia.open.tracing.api.Call parseFrom(
      byte[] data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.Call parseFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.api.Call parseFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.Call parseDelimitedFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.api.Call parseDelimitedFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.Call parseFrom(
      com.google.protobuf.CodedInputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.api.Call parseFrom(
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
  public static Builder newBuilder(com.expedia.open.tracing.api.Call prototype) {
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
   * Protobuf type {@code Call}
   */
  public static final class Builder extends
      com.google.protobuf.GeneratedMessageV3.Builder<Builder> implements
      // @@protoc_insertion_point(builder_implements:Call)
      com.expedia.open.tracing.api.CallOrBuilder {
    public static final com.google.protobuf.Descriptors.Descriptor
        getDescriptor() {
      return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_Call_descriptor;
    }

    protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
        internalGetFieldAccessorTable() {
      return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_Call_fieldAccessorTable
          .ensureFieldAccessorsInitialized(
              com.expedia.open.tracing.api.Call.class, com.expedia.open.tracing.api.Call.Builder.class);
    }

    // Construct using com.expedia.open.tracing.api.Call.newBuilder()
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
      }
    }
    public Builder clear() {
      super.clear();
      if (fromBuilder_ == null) {
        from_ = null;
      } else {
        from_ = null;
        fromBuilder_ = null;
      }
      if (toBuilder_ == null) {
        to_ = null;
      } else {
        to_ = null;
        toBuilder_ = null;
      }
      networkDelta_ = 0L;

      return this;
    }

    public com.google.protobuf.Descriptors.Descriptor
        getDescriptorForType() {
      return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_Call_descriptor;
    }

    public com.expedia.open.tracing.api.Call getDefaultInstanceForType() {
      return com.expedia.open.tracing.api.Call.getDefaultInstance();
    }

    public com.expedia.open.tracing.api.Call build() {
      com.expedia.open.tracing.api.Call result = buildPartial();
      if (!result.isInitialized()) {
        throw newUninitializedMessageException(result);
      }
      return result;
    }

    public com.expedia.open.tracing.api.Call buildPartial() {
      com.expedia.open.tracing.api.Call result = new com.expedia.open.tracing.api.Call(this);
      if (fromBuilder_ == null) {
        result.from_ = from_;
      } else {
        result.from_ = fromBuilder_.build();
      }
      if (toBuilder_ == null) {
        result.to_ = to_;
      } else {
        result.to_ = toBuilder_.build();
      }
      result.networkDelta_ = networkDelta_;
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
      if (other instanceof com.expedia.open.tracing.api.Call) {
        return mergeFrom((com.expedia.open.tracing.api.Call)other);
      } else {
        super.mergeFrom(other);
        return this;
      }
    }

    public Builder mergeFrom(com.expedia.open.tracing.api.Call other) {
      if (other == com.expedia.open.tracing.api.Call.getDefaultInstance()) return this;
      if (other.hasFrom()) {
        mergeFrom(other.getFrom());
      }
      if (other.hasTo()) {
        mergeTo(other.getTo());
      }
      if (other.getNetworkDelta() != 0L) {
        setNetworkDelta(other.getNetworkDelta());
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
      com.expedia.open.tracing.api.Call parsedMessage = null;
      try {
        parsedMessage = PARSER.parsePartialFrom(input, extensionRegistry);
      } catch (com.google.protobuf.InvalidProtocolBufferException e) {
        parsedMessage = (com.expedia.open.tracing.api.Call) e.getUnfinishedMessage();
        throw e.unwrapIOException();
      } finally {
        if (parsedMessage != null) {
          mergeFrom(parsedMessage);
        }
      }
      return this;
    }

    private com.expedia.open.tracing.api.CallNode from_ = null;
    private com.google.protobuf.SingleFieldBuilderV3<
        com.expedia.open.tracing.api.CallNode, com.expedia.open.tracing.api.CallNode.Builder, com.expedia.open.tracing.api.CallNodeOrBuilder> fromBuilder_;
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public boolean hasFrom() {
      return fromBuilder_ != null || from_ != null;
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public com.expedia.open.tracing.api.CallNode getFrom() {
      if (fromBuilder_ == null) {
        return from_ == null ? com.expedia.open.tracing.api.CallNode.getDefaultInstance() : from_;
      } else {
        return fromBuilder_.getMessage();
      }
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public Builder setFrom(com.expedia.open.tracing.api.CallNode value) {
      if (fromBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        from_ = value;
        onChanged();
      } else {
        fromBuilder_.setMessage(value);
      }

      return this;
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public Builder setFrom(
        com.expedia.open.tracing.api.CallNode.Builder builderForValue) {
      if (fromBuilder_ == null) {
        from_ = builderForValue.build();
        onChanged();
      } else {
        fromBuilder_.setMessage(builderForValue.build());
      }

      return this;
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public Builder mergeFrom(com.expedia.open.tracing.api.CallNode value) {
      if (fromBuilder_ == null) {
        if (from_ != null) {
          from_ =
            com.expedia.open.tracing.api.CallNode.newBuilder(from_).mergeFrom(value).buildPartial();
        } else {
          from_ = value;
        }
        onChanged();
      } else {
        fromBuilder_.mergeFrom(value);
      }

      return this;
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public Builder clearFrom() {
      if (fromBuilder_ == null) {
        from_ = null;
        onChanged();
      } else {
        from_ = null;
        fromBuilder_ = null;
      }

      return this;
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public com.expedia.open.tracing.api.CallNode.Builder getFromBuilder() {
      
      onChanged();
      return getFromFieldBuilder().getBuilder();
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    public com.expedia.open.tracing.api.CallNodeOrBuilder getFromOrBuilder() {
      if (fromBuilder_ != null) {
        return fromBuilder_.getMessageOrBuilder();
      } else {
        return from_ == null ?
            com.expedia.open.tracing.api.CallNode.getDefaultInstance() : from_;
      }
    }
    /**
     * <pre>
     * service node from which call was started
     * </pre>
     *
     * <code>optional .CallNode from = 1;</code>
     */
    private com.google.protobuf.SingleFieldBuilderV3<
        com.expedia.open.tracing.api.CallNode, com.expedia.open.tracing.api.CallNode.Builder, com.expedia.open.tracing.api.CallNodeOrBuilder> 
        getFromFieldBuilder() {
      if (fromBuilder_ == null) {
        fromBuilder_ = new com.google.protobuf.SingleFieldBuilderV3<
            com.expedia.open.tracing.api.CallNode, com.expedia.open.tracing.api.CallNode.Builder, com.expedia.open.tracing.api.CallNodeOrBuilder>(
                getFrom(),
                getParentForChildren(),
                isClean());
        from_ = null;
      }
      return fromBuilder_;
    }

    private com.expedia.open.tracing.api.CallNode to_ = null;
    private com.google.protobuf.SingleFieldBuilderV3<
        com.expedia.open.tracing.api.CallNode, com.expedia.open.tracing.api.CallNode.Builder, com.expedia.open.tracing.api.CallNodeOrBuilder> toBuilder_;
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public boolean hasTo() {
      return toBuilder_ != null || to_ != null;
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public com.expedia.open.tracing.api.CallNode getTo() {
      if (toBuilder_ == null) {
        return to_ == null ? com.expedia.open.tracing.api.CallNode.getDefaultInstance() : to_;
      } else {
        return toBuilder_.getMessage();
      }
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public Builder setTo(com.expedia.open.tracing.api.CallNode value) {
      if (toBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        to_ = value;
        onChanged();
      } else {
        toBuilder_.setMessage(value);
      }

      return this;
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public Builder setTo(
        com.expedia.open.tracing.api.CallNode.Builder builderForValue) {
      if (toBuilder_ == null) {
        to_ = builderForValue.build();
        onChanged();
      } else {
        toBuilder_.setMessage(builderForValue.build());
      }

      return this;
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public Builder mergeTo(com.expedia.open.tracing.api.CallNode value) {
      if (toBuilder_ == null) {
        if (to_ != null) {
          to_ =
            com.expedia.open.tracing.api.CallNode.newBuilder(to_).mergeFrom(value).buildPartial();
        } else {
          to_ = value;
        }
        onChanged();
      } else {
        toBuilder_.mergeFrom(value);
      }

      return this;
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public Builder clearTo() {
      if (toBuilder_ == null) {
        to_ = null;
        onChanged();
      } else {
        to_ = null;
        toBuilder_ = null;
      }

      return this;
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public com.expedia.open.tracing.api.CallNode.Builder getToBuilder() {
      
      onChanged();
      return getToFieldBuilder().getBuilder();
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    public com.expedia.open.tracing.api.CallNodeOrBuilder getToOrBuilder() {
      if (toBuilder_ != null) {
        return toBuilder_.getMessageOrBuilder();
      } else {
        return to_ == null ?
            com.expedia.open.tracing.api.CallNode.getDefaultInstance() : to_;
      }
    }
    /**
     * <pre>
     * service node to which call was terminated
     * </pre>
     *
     * <code>optional .CallNode to = 2;</code>
     */
    private com.google.protobuf.SingleFieldBuilderV3<
        com.expedia.open.tracing.api.CallNode, com.expedia.open.tracing.api.CallNode.Builder, com.expedia.open.tracing.api.CallNodeOrBuilder> 
        getToFieldBuilder() {
      if (toBuilder_ == null) {
        toBuilder_ = new com.google.protobuf.SingleFieldBuilderV3<
            com.expedia.open.tracing.api.CallNode, com.expedia.open.tracing.api.CallNode.Builder, com.expedia.open.tracing.api.CallNodeOrBuilder>(
                getTo(),
                getParentForChildren(),
                isClean());
        to_ = null;
      }
      return toBuilder_;
    }

    private long networkDelta_ ;
    /**
     * <pre>
     * time delta in transit
     * </pre>
     *
     * <code>optional int64 networkDelta = 3;</code>
     */
    public long getNetworkDelta() {
      return networkDelta_;
    }
    /**
     * <pre>
     * time delta in transit
     * </pre>
     *
     * <code>optional int64 networkDelta = 3;</code>
     */
    public Builder setNetworkDelta(long value) {
      
      networkDelta_ = value;
      onChanged();
      return this;
    }
    /**
     * <pre>
     * time delta in transit
     * </pre>
     *
     * <code>optional int64 networkDelta = 3;</code>
     */
    public Builder clearNetworkDelta() {
      
      networkDelta_ = 0L;
      onChanged();
      return this;
    }
    public final Builder setUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return this;
    }

    public final Builder mergeUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return this;
    }


    // @@protoc_insertion_point(builder_scope:Call)
  }

  // @@protoc_insertion_point(class_scope:Call)
  private static final com.expedia.open.tracing.api.Call DEFAULT_INSTANCE;
  static {
    DEFAULT_INSTANCE = new com.expedia.open.tracing.api.Call();
  }

  public static com.expedia.open.tracing.api.Call getDefaultInstance() {
    return DEFAULT_INSTANCE;
  }

  private static final com.google.protobuf.Parser<Call>
      PARSER = new com.google.protobuf.AbstractParser<Call>() {
    public Call parsePartialFrom(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
        return new Call(input, extensionRegistry);
    }
  };

  public static com.google.protobuf.Parser<Call> parser() {
    return PARSER;
  }

  @java.lang.Override
  public com.google.protobuf.Parser<Call> getParserForType() {
    return PARSER;
  }

  public com.expedia.open.tracing.api.Call getDefaultInstanceForType() {
    return DEFAULT_INSTANCE;
  }

}

