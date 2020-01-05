// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: api/traceReader.proto

package com.expedia.open.tracing.api;

/**
 * <pre>
 * query for fetching values for given field
 * </pre>
 *
 * Protobuf type {@code FieldValuesRequest}
 */
public  final class FieldValuesRequest extends
    com.google.protobuf.GeneratedMessageV3 implements
    // @@protoc_insertion_point(message_implements:FieldValuesRequest)
    FieldValuesRequestOrBuilder {
  // Use FieldValuesRequest.newBuilder() to construct.
  private FieldValuesRequest(com.google.protobuf.GeneratedMessageV3.Builder<?> builder) {
    super(builder);
  }
  private FieldValuesRequest() {
    fieldName_ = "";
    filters_ = java.util.Collections.emptyList();
  }

  @java.lang.Override
  public final com.google.protobuf.UnknownFieldSet
  getUnknownFields() {
    return com.google.protobuf.UnknownFieldSet.getDefaultInstance();
  }
  private FieldValuesRequest(
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

            fieldName_ = s;
            break;
          }
          case 18: {
            if (!((mutable_bitField0_ & 0x00000002) == 0x00000002)) {
              filters_ = new java.util.ArrayList<com.expedia.open.tracing.api.Field>();
              mutable_bitField0_ |= 0x00000002;
            }
            filters_.add(
                input.readMessage(com.expedia.open.tracing.api.Field.parser(), extensionRegistry));
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
        filters_ = java.util.Collections.unmodifiableList(filters_);
      }
      makeExtensionsImmutable();
    }
  }
  public static final com.google.protobuf.Descriptors.Descriptor
      getDescriptor() {
    return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_FieldValuesRequest_descriptor;
  }

  protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internalGetFieldAccessorTable() {
    return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_FieldValuesRequest_fieldAccessorTable
        .ensureFieldAccessorsInitialized(
            com.expedia.open.tracing.api.FieldValuesRequest.class, com.expedia.open.tracing.api.FieldValuesRequest.Builder.class);
  }

  private int bitField0_;
  public static final int FIELDNAME_FIELD_NUMBER = 1;
  private volatile java.lang.Object fieldName_;
  /**
   * <pre>
   * name of field to query for
   * </pre>
   *
   * <code>optional string fieldName = 1;</code>
   */
  public java.lang.String getFieldName() {
    java.lang.Object ref = fieldName_;
    if (ref instanceof java.lang.String) {
      return (java.lang.String) ref;
    } else {
      com.google.protobuf.ByteString bs = 
          (com.google.protobuf.ByteString) ref;
      java.lang.String s = bs.toStringUtf8();
      fieldName_ = s;
      return s;
    }
  }
  /**
   * <pre>
   * name of field to query for
   * </pre>
   *
   * <code>optional string fieldName = 1;</code>
   */
  public com.google.protobuf.ByteString
      getFieldNameBytes() {
    java.lang.Object ref = fieldName_;
    if (ref instanceof java.lang.String) {
      com.google.protobuf.ByteString b = 
          com.google.protobuf.ByteString.copyFromUtf8(
              (java.lang.String) ref);
      fieldName_ = b;
      return b;
    } else {
      return (com.google.protobuf.ByteString) ref;
    }
  }

  public static final int FILTERS_FIELD_NUMBER = 2;
  private java.util.List<com.expedia.open.tracing.api.Field> filters_;
  /**
   * <pre>
   * provided fields to be used for filtering
   * </pre>
   *
   * <code>repeated .Field filters = 2;</code>
   */
  public java.util.List<com.expedia.open.tracing.api.Field> getFiltersList() {
    return filters_;
  }
  /**
   * <pre>
   * provided fields to be used for filtering
   * </pre>
   *
   * <code>repeated .Field filters = 2;</code>
   */
  public java.util.List<? extends com.expedia.open.tracing.api.FieldOrBuilder> 
      getFiltersOrBuilderList() {
    return filters_;
  }
  /**
   * <pre>
   * provided fields to be used for filtering
   * </pre>
   *
   * <code>repeated .Field filters = 2;</code>
   */
  public int getFiltersCount() {
    return filters_.size();
  }
  /**
   * <pre>
   * provided fields to be used for filtering
   * </pre>
   *
   * <code>repeated .Field filters = 2;</code>
   */
  public com.expedia.open.tracing.api.Field getFilters(int index) {
    return filters_.get(index);
  }
  /**
   * <pre>
   * provided fields to be used for filtering
   * </pre>
   *
   * <code>repeated .Field filters = 2;</code>
   */
  public com.expedia.open.tracing.api.FieldOrBuilder getFiltersOrBuilder(
      int index) {
    return filters_.get(index);
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
    if (!getFieldNameBytes().isEmpty()) {
      com.google.protobuf.GeneratedMessageV3.writeString(output, 1, fieldName_);
    }
    for (int i = 0; i < filters_.size(); i++) {
      output.writeMessage(2, filters_.get(i));
    }
  }

  public int getSerializedSize() {
    int size = memoizedSize;
    if (size != -1) return size;

    size = 0;
    if (!getFieldNameBytes().isEmpty()) {
      size += com.google.protobuf.GeneratedMessageV3.computeStringSize(1, fieldName_);
    }
    for (int i = 0; i < filters_.size(); i++) {
      size += com.google.protobuf.CodedOutputStream
        .computeMessageSize(2, filters_.get(i));
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
    if (!(obj instanceof com.expedia.open.tracing.api.FieldValuesRequest)) {
      return super.equals(obj);
    }
    com.expedia.open.tracing.api.FieldValuesRequest other = (com.expedia.open.tracing.api.FieldValuesRequest) obj;

    boolean result = true;
    result = result && getFieldName()
        .equals(other.getFieldName());
    result = result && getFiltersList()
        .equals(other.getFiltersList());
    return result;
  }

  @java.lang.Override
  public int hashCode() {
    if (memoizedHashCode != 0) {
      return memoizedHashCode;
    }
    int hash = 41;
    hash = (19 * hash) + getDescriptorForType().hashCode();
    hash = (37 * hash) + FIELDNAME_FIELD_NUMBER;
    hash = (53 * hash) + getFieldName().hashCode();
    if (getFiltersCount() > 0) {
      hash = (37 * hash) + FILTERS_FIELD_NUMBER;
      hash = (53 * hash) + getFiltersList().hashCode();
    }
    hash = (29 * hash) + unknownFields.hashCode();
    memoizedHashCode = hash;
    return hash;
  }

  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(
      com.google.protobuf.ByteString data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(
      com.google.protobuf.ByteString data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(byte[] data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(
      byte[] data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseDelimitedFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseDelimitedFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input, extensionRegistry);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(
      com.google.protobuf.CodedInputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static com.expedia.open.tracing.api.FieldValuesRequest parseFrom(
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
  public static Builder newBuilder(com.expedia.open.tracing.api.FieldValuesRequest prototype) {
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
   * query for fetching values for given field
   * </pre>
   *
   * Protobuf type {@code FieldValuesRequest}
   */
  public static final class Builder extends
      com.google.protobuf.GeneratedMessageV3.Builder<Builder> implements
      // @@protoc_insertion_point(builder_implements:FieldValuesRequest)
      com.expedia.open.tracing.api.FieldValuesRequestOrBuilder {
    public static final com.google.protobuf.Descriptors.Descriptor
        getDescriptor() {
      return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_FieldValuesRequest_descriptor;
    }

    protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
        internalGetFieldAccessorTable() {
      return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_FieldValuesRequest_fieldAccessorTable
          .ensureFieldAccessorsInitialized(
              com.expedia.open.tracing.api.FieldValuesRequest.class, com.expedia.open.tracing.api.FieldValuesRequest.Builder.class);
    }

    // Construct using com.expedia.open.tracing.api.FieldValuesRequest.newBuilder()
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
        getFiltersFieldBuilder();
      }
    }
    public Builder clear() {
      super.clear();
      fieldName_ = "";

      if (filtersBuilder_ == null) {
        filters_ = java.util.Collections.emptyList();
        bitField0_ = (bitField0_ & ~0x00000002);
      } else {
        filtersBuilder_.clear();
      }
      return this;
    }

    public com.google.protobuf.Descriptors.Descriptor
        getDescriptorForType() {
      return com.expedia.open.tracing.api.TraceReaderOuterClass.internal_static_FieldValuesRequest_descriptor;
    }

    public com.expedia.open.tracing.api.FieldValuesRequest getDefaultInstanceForType() {
      return com.expedia.open.tracing.api.FieldValuesRequest.getDefaultInstance();
    }

    public com.expedia.open.tracing.api.FieldValuesRequest build() {
      com.expedia.open.tracing.api.FieldValuesRequest result = buildPartial();
      if (!result.isInitialized()) {
        throw newUninitializedMessageException(result);
      }
      return result;
    }

    public com.expedia.open.tracing.api.FieldValuesRequest buildPartial() {
      com.expedia.open.tracing.api.FieldValuesRequest result = new com.expedia.open.tracing.api.FieldValuesRequest(this);
      int from_bitField0_ = bitField0_;
      int to_bitField0_ = 0;
      result.fieldName_ = fieldName_;
      if (filtersBuilder_ == null) {
        if (((bitField0_ & 0x00000002) == 0x00000002)) {
          filters_ = java.util.Collections.unmodifiableList(filters_);
          bitField0_ = (bitField0_ & ~0x00000002);
        }
        result.filters_ = filters_;
      } else {
        result.filters_ = filtersBuilder_.build();
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
      if (other instanceof com.expedia.open.tracing.api.FieldValuesRequest) {
        return mergeFrom((com.expedia.open.tracing.api.FieldValuesRequest)other);
      } else {
        super.mergeFrom(other);
        return this;
      }
    }

    public Builder mergeFrom(com.expedia.open.tracing.api.FieldValuesRequest other) {
      if (other == com.expedia.open.tracing.api.FieldValuesRequest.getDefaultInstance()) return this;
      if (!other.getFieldName().isEmpty()) {
        fieldName_ = other.fieldName_;
        onChanged();
      }
      if (filtersBuilder_ == null) {
        if (!other.filters_.isEmpty()) {
          if (filters_.isEmpty()) {
            filters_ = other.filters_;
            bitField0_ = (bitField0_ & ~0x00000002);
          } else {
            ensureFiltersIsMutable();
            filters_.addAll(other.filters_);
          }
          onChanged();
        }
      } else {
        if (!other.filters_.isEmpty()) {
          if (filtersBuilder_.isEmpty()) {
            filtersBuilder_.dispose();
            filtersBuilder_ = null;
            filters_ = other.filters_;
            bitField0_ = (bitField0_ & ~0x00000002);
            filtersBuilder_ = 
              com.google.protobuf.GeneratedMessageV3.alwaysUseFieldBuilders ?
                 getFiltersFieldBuilder() : null;
          } else {
            filtersBuilder_.addAllMessages(other.filters_);
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
      com.expedia.open.tracing.api.FieldValuesRequest parsedMessage = null;
      try {
        parsedMessage = PARSER.parsePartialFrom(input, extensionRegistry);
      } catch (com.google.protobuf.InvalidProtocolBufferException e) {
        parsedMessage = (com.expedia.open.tracing.api.FieldValuesRequest) e.getUnfinishedMessage();
        throw e.unwrapIOException();
      } finally {
        if (parsedMessage != null) {
          mergeFrom(parsedMessage);
        }
      }
      return this;
    }
    private int bitField0_;

    private java.lang.Object fieldName_ = "";
    /**
     * <pre>
     * name of field to query for
     * </pre>
     *
     * <code>optional string fieldName = 1;</code>
     */
    public java.lang.String getFieldName() {
      java.lang.Object ref = fieldName_;
      if (!(ref instanceof java.lang.String)) {
        com.google.protobuf.ByteString bs =
            (com.google.protobuf.ByteString) ref;
        java.lang.String s = bs.toStringUtf8();
        fieldName_ = s;
        return s;
      } else {
        return (java.lang.String) ref;
      }
    }
    /**
     * <pre>
     * name of field to query for
     * </pre>
     *
     * <code>optional string fieldName = 1;</code>
     */
    public com.google.protobuf.ByteString
        getFieldNameBytes() {
      java.lang.Object ref = fieldName_;
      if (ref instanceof String) {
        com.google.protobuf.ByteString b = 
            com.google.protobuf.ByteString.copyFromUtf8(
                (java.lang.String) ref);
        fieldName_ = b;
        return b;
      } else {
        return (com.google.protobuf.ByteString) ref;
      }
    }
    /**
     * <pre>
     * name of field to query for
     * </pre>
     *
     * <code>optional string fieldName = 1;</code>
     */
    public Builder setFieldName(
        java.lang.String value) {
      if (value == null) {
    throw new NullPointerException();
  }
  
      fieldName_ = value;
      onChanged();
      return this;
    }
    /**
     * <pre>
     * name of field to query for
     * </pre>
     *
     * <code>optional string fieldName = 1;</code>
     */
    public Builder clearFieldName() {
      
      fieldName_ = getDefaultInstance().getFieldName();
      onChanged();
      return this;
    }
    /**
     * <pre>
     * name of field to query for
     * </pre>
     *
     * <code>optional string fieldName = 1;</code>
     */
    public Builder setFieldNameBytes(
        com.google.protobuf.ByteString value) {
      if (value == null) {
    throw new NullPointerException();
  }
  checkByteStringIsUtf8(value);
      
      fieldName_ = value;
      onChanged();
      return this;
    }

    private java.util.List<com.expedia.open.tracing.api.Field> filters_ =
      java.util.Collections.emptyList();
    private void ensureFiltersIsMutable() {
      if (!((bitField0_ & 0x00000002) == 0x00000002)) {
        filters_ = new java.util.ArrayList<com.expedia.open.tracing.api.Field>(filters_);
        bitField0_ |= 0x00000002;
       }
    }

    private com.google.protobuf.RepeatedFieldBuilderV3<
        com.expedia.open.tracing.api.Field, com.expedia.open.tracing.api.Field.Builder, com.expedia.open.tracing.api.FieldOrBuilder> filtersBuilder_;

    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public java.util.List<com.expedia.open.tracing.api.Field> getFiltersList() {
      if (filtersBuilder_ == null) {
        return java.util.Collections.unmodifiableList(filters_);
      } else {
        return filtersBuilder_.getMessageList();
      }
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public int getFiltersCount() {
      if (filtersBuilder_ == null) {
        return filters_.size();
      } else {
        return filtersBuilder_.getCount();
      }
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public com.expedia.open.tracing.api.Field getFilters(int index) {
      if (filtersBuilder_ == null) {
        return filters_.get(index);
      } else {
        return filtersBuilder_.getMessage(index);
      }
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder setFilters(
        int index, com.expedia.open.tracing.api.Field value) {
      if (filtersBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        ensureFiltersIsMutable();
        filters_.set(index, value);
        onChanged();
      } else {
        filtersBuilder_.setMessage(index, value);
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder setFilters(
        int index, com.expedia.open.tracing.api.Field.Builder builderForValue) {
      if (filtersBuilder_ == null) {
        ensureFiltersIsMutable();
        filters_.set(index, builderForValue.build());
        onChanged();
      } else {
        filtersBuilder_.setMessage(index, builderForValue.build());
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder addFilters(com.expedia.open.tracing.api.Field value) {
      if (filtersBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        ensureFiltersIsMutable();
        filters_.add(value);
        onChanged();
      } else {
        filtersBuilder_.addMessage(value);
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder addFilters(
        int index, com.expedia.open.tracing.api.Field value) {
      if (filtersBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        ensureFiltersIsMutable();
        filters_.add(index, value);
        onChanged();
      } else {
        filtersBuilder_.addMessage(index, value);
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder addFilters(
        com.expedia.open.tracing.api.Field.Builder builderForValue) {
      if (filtersBuilder_ == null) {
        ensureFiltersIsMutable();
        filters_.add(builderForValue.build());
        onChanged();
      } else {
        filtersBuilder_.addMessage(builderForValue.build());
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder addFilters(
        int index, com.expedia.open.tracing.api.Field.Builder builderForValue) {
      if (filtersBuilder_ == null) {
        ensureFiltersIsMutable();
        filters_.add(index, builderForValue.build());
        onChanged();
      } else {
        filtersBuilder_.addMessage(index, builderForValue.build());
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder addAllFilters(
        java.lang.Iterable<? extends com.expedia.open.tracing.api.Field> values) {
      if (filtersBuilder_ == null) {
        ensureFiltersIsMutable();
        com.google.protobuf.AbstractMessageLite.Builder.addAll(
            values, filters_);
        onChanged();
      } else {
        filtersBuilder_.addAllMessages(values);
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder clearFilters() {
      if (filtersBuilder_ == null) {
        filters_ = java.util.Collections.emptyList();
        bitField0_ = (bitField0_ & ~0x00000002);
        onChanged();
      } else {
        filtersBuilder_.clear();
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public Builder removeFilters(int index) {
      if (filtersBuilder_ == null) {
        ensureFiltersIsMutable();
        filters_.remove(index);
        onChanged();
      } else {
        filtersBuilder_.remove(index);
      }
      return this;
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public com.expedia.open.tracing.api.Field.Builder getFiltersBuilder(
        int index) {
      return getFiltersFieldBuilder().getBuilder(index);
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public com.expedia.open.tracing.api.FieldOrBuilder getFiltersOrBuilder(
        int index) {
      if (filtersBuilder_ == null) {
        return filters_.get(index);  } else {
        return filtersBuilder_.getMessageOrBuilder(index);
      }
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public java.util.List<? extends com.expedia.open.tracing.api.FieldOrBuilder> 
         getFiltersOrBuilderList() {
      if (filtersBuilder_ != null) {
        return filtersBuilder_.getMessageOrBuilderList();
      } else {
        return java.util.Collections.unmodifiableList(filters_);
      }
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public com.expedia.open.tracing.api.Field.Builder addFiltersBuilder() {
      return getFiltersFieldBuilder().addBuilder(
          com.expedia.open.tracing.api.Field.getDefaultInstance());
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public com.expedia.open.tracing.api.Field.Builder addFiltersBuilder(
        int index) {
      return getFiltersFieldBuilder().addBuilder(
          index, com.expedia.open.tracing.api.Field.getDefaultInstance());
    }
    /**
     * <pre>
     * provided fields to be used for filtering
     * </pre>
     *
     * <code>repeated .Field filters = 2;</code>
     */
    public java.util.List<com.expedia.open.tracing.api.Field.Builder> 
         getFiltersBuilderList() {
      return getFiltersFieldBuilder().getBuilderList();
    }
    private com.google.protobuf.RepeatedFieldBuilderV3<
        com.expedia.open.tracing.api.Field, com.expedia.open.tracing.api.Field.Builder, com.expedia.open.tracing.api.FieldOrBuilder> 
        getFiltersFieldBuilder() {
      if (filtersBuilder_ == null) {
        filtersBuilder_ = new com.google.protobuf.RepeatedFieldBuilderV3<
            com.expedia.open.tracing.api.Field, com.expedia.open.tracing.api.Field.Builder, com.expedia.open.tracing.api.FieldOrBuilder>(
                filters_,
                ((bitField0_ & 0x00000002) == 0x00000002),
                getParentForChildren(),
                isClean());
        filters_ = null;
      }
      return filtersBuilder_;
    }
    public final Builder setUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return this;
    }

    public final Builder mergeUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return this;
    }


    // @@protoc_insertion_point(builder_scope:FieldValuesRequest)
  }

  // @@protoc_insertion_point(class_scope:FieldValuesRequest)
  private static final com.expedia.open.tracing.api.FieldValuesRequest DEFAULT_INSTANCE;
  static {
    DEFAULT_INSTANCE = new com.expedia.open.tracing.api.FieldValuesRequest();
  }

  public static com.expedia.open.tracing.api.FieldValuesRequest getDefaultInstance() {
    return DEFAULT_INSTANCE;
  }

  private static final com.google.protobuf.Parser<FieldValuesRequest>
      PARSER = new com.google.protobuf.AbstractParser<FieldValuesRequest>() {
    public FieldValuesRequest parsePartialFrom(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
        return new FieldValuesRequest(input, extensionRegistry);
    }
  };

  public static com.google.protobuf.Parser<FieldValuesRequest> parser() {
    return PARSER;
  }

  @java.lang.Override
  public com.google.protobuf.Parser<FieldValuesRequest> getParserForType() {
    return PARSER;
  }

  public com.expedia.open.tracing.api.FieldValuesRequest getDefaultInstanceForType() {
    return DEFAULT_INSTANCE;
  }

}

