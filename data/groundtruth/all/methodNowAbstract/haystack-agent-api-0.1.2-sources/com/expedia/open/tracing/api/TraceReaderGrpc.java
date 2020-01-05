package com.expedia.open.tracing.api;

import static io.grpc.stub.ClientCalls.asyncUnaryCall;
import static io.grpc.stub.ClientCalls.asyncServerStreamingCall;
import static io.grpc.stub.ClientCalls.asyncClientStreamingCall;
import static io.grpc.stub.ClientCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ClientCalls.blockingUnaryCall;
import static io.grpc.stub.ClientCalls.blockingServerStreamingCall;
import static io.grpc.stub.ClientCalls.futureUnaryCall;
import static io.grpc.MethodDescriptor.generateFullMethodName;
import static io.grpc.stub.ServerCalls.asyncUnaryCall;
import static io.grpc.stub.ServerCalls.asyncServerStreamingCall;
import static io.grpc.stub.ServerCalls.asyncClientStreamingCall;
import static io.grpc.stub.ServerCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedStreamingCall;

/**
 * <pre>
 * service interface to search and get traces
 * </pre>
 */
@javax.annotation.Generated(
    value = "by gRPC proto compiler (version 1.0.1)",
    comments = "Source: api/traceReader.proto")
public class TraceReaderGrpc {

  private TraceReaderGrpc() {}

  public static final String SERVICE_NAME = "TraceReader";

  // Static method descriptors that strictly reflect the proto.
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.api.TracesSearchRequest,
      com.expedia.open.tracing.api.TracesSearchResult> METHOD_SEARCH_TRACES =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "TraceReader", "searchTraces"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.TracesSearchRequest.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.TracesSearchResult.getDefaultInstance()));
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.api.TraceRequest,
      com.expedia.open.tracing.api.Trace> METHOD_GET_TRACE =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "TraceReader", "getTrace"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.TraceRequest.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.Trace.getDefaultInstance()));
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.api.TraceRequest,
      com.expedia.open.tracing.api.Trace> METHOD_GET_RAW_TRACE =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "TraceReader", "getRawTrace"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.TraceRequest.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.Trace.getDefaultInstance()));
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.api.SpanRequest,
      com.expedia.open.tracing.Span> METHOD_GET_RAW_SPAN =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "TraceReader", "getRawSpan"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.SpanRequest.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.Span.getDefaultInstance()));
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.api.Empty,
      com.expedia.open.tracing.api.FieldNames> METHOD_GET_FIELD_NAMES =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "TraceReader", "getFieldNames"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.Empty.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.FieldNames.getDefaultInstance()));
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.api.FieldValuesRequest,
      com.expedia.open.tracing.api.FieldValues> METHOD_GET_FIELD_VALUES =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "TraceReader", "getFieldValues"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.FieldValuesRequest.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.FieldValues.getDefaultInstance()));
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.api.TraceRequest,
      com.expedia.open.tracing.api.TraceCallGraph> METHOD_GET_TRACE_CALL_GRAPH =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "TraceReader", "getTraceCallGraph"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.TraceRequest.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.api.TraceCallGraph.getDefaultInstance()));

  /**
   * Creates a new async stub that supports all call types for the service
   */
  public static TraceReaderStub newStub(io.grpc.Channel channel) {
    return new TraceReaderStub(channel);
  }

  /**
   * Creates a new blocking-style stub that supports unary and streaming output calls on the service
   */
  public static TraceReaderBlockingStub newBlockingStub(
      io.grpc.Channel channel) {
    return new TraceReaderBlockingStub(channel);
  }

  /**
   * Creates a new ListenableFuture-style stub that supports unary and streaming output calls on the service
   */
  public static TraceReaderFutureStub newFutureStub(
      io.grpc.Channel channel) {
    return new TraceReaderFutureStub(channel);
  }

  /**
   * <pre>
   * service interface to search and get traces
   * </pre>
   */
  public static abstract class TraceReaderImplBase implements io.grpc.BindableService {

    /**
     * <pre>
     * search for traces based on filter fields and other criterias
     * </pre>
     */
    public void searchTraces(com.expedia.open.tracing.api.TracesSearchRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.TracesSearchResult> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_SEARCH_TRACES, responseObserver);
    }

    /**
     * <pre>
     * fetch a trace using traceId
     * </pre>
     */
    public void getTrace(com.expedia.open.tracing.api.TraceRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.Trace> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_GET_TRACE, responseObserver);
    }

    /**
     * <pre>
     * fetch a trace in raw un-transformed format using traceId
     * </pre>
     */
    public void getRawTrace(com.expedia.open.tracing.api.TraceRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.Trace> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_GET_RAW_TRACE, responseObserver);
    }

    /**
     * <pre>
     * fetch a span of a trace in raw un-transformed format using traceId and spanId
     * </pre>
     */
    public void getRawSpan(com.expedia.open.tracing.api.SpanRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.Span> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_GET_RAW_SPAN, responseObserver);
    }

    /**
     * <pre>
     * get all searchable Fields available in haystack system
     * </pre>
     */
    public void getFieldNames(com.expedia.open.tracing.api.Empty request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.FieldNames> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_GET_FIELD_NAMES, responseObserver);
    }

    /**
     * <pre>
     * get values for a given Field
     * </pre>
     */
    public void getFieldValues(com.expedia.open.tracing.api.FieldValuesRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.FieldValues> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_GET_FIELD_VALUES, responseObserver);
    }

    /**
     * <pre>
     * get graph of service calls made in the given traceId
     * </pre>
     */
    public void getTraceCallGraph(com.expedia.open.tracing.api.TraceRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.TraceCallGraph> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_GET_TRACE_CALL_GRAPH, responseObserver);
    }

    @java.lang.Override public io.grpc.ServerServiceDefinition bindService() {
      return io.grpc.ServerServiceDefinition.builder(getServiceDescriptor())
          .addMethod(
            METHOD_SEARCH_TRACES,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.api.TracesSearchRequest,
                com.expedia.open.tracing.api.TracesSearchResult>(
                  this, METHODID_SEARCH_TRACES)))
          .addMethod(
            METHOD_GET_TRACE,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.api.TraceRequest,
                com.expedia.open.tracing.api.Trace>(
                  this, METHODID_GET_TRACE)))
          .addMethod(
            METHOD_GET_RAW_TRACE,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.api.TraceRequest,
                com.expedia.open.tracing.api.Trace>(
                  this, METHODID_GET_RAW_TRACE)))
          .addMethod(
            METHOD_GET_RAW_SPAN,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.api.SpanRequest,
                com.expedia.open.tracing.Span>(
                  this, METHODID_GET_RAW_SPAN)))
          .addMethod(
            METHOD_GET_FIELD_NAMES,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.api.Empty,
                com.expedia.open.tracing.api.FieldNames>(
                  this, METHODID_GET_FIELD_NAMES)))
          .addMethod(
            METHOD_GET_FIELD_VALUES,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.api.FieldValuesRequest,
                com.expedia.open.tracing.api.FieldValues>(
                  this, METHODID_GET_FIELD_VALUES)))
          .addMethod(
            METHOD_GET_TRACE_CALL_GRAPH,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.api.TraceRequest,
                com.expedia.open.tracing.api.TraceCallGraph>(
                  this, METHODID_GET_TRACE_CALL_GRAPH)))
          .build();
    }
  }

  /**
   * <pre>
   * service interface to search and get traces
   * </pre>
   */
  public static final class TraceReaderStub extends io.grpc.stub.AbstractStub<TraceReaderStub> {
    private TraceReaderStub(io.grpc.Channel channel) {
      super(channel);
    }

    private TraceReaderStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected TraceReaderStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new TraceReaderStub(channel, callOptions);
    }

    /**
     * <pre>
     * search for traces based on filter fields and other criterias
     * </pre>
     */
    public void searchTraces(com.expedia.open.tracing.api.TracesSearchRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.TracesSearchResult> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_SEARCH_TRACES, getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * fetch a trace using traceId
     * </pre>
     */
    public void getTrace(com.expedia.open.tracing.api.TraceRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.Trace> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_GET_TRACE, getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * fetch a trace in raw un-transformed format using traceId
     * </pre>
     */
    public void getRawTrace(com.expedia.open.tracing.api.TraceRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.Trace> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_GET_RAW_TRACE, getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * fetch a span of a trace in raw un-transformed format using traceId and spanId
     * </pre>
     */
    public void getRawSpan(com.expedia.open.tracing.api.SpanRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.Span> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_GET_RAW_SPAN, getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * get all searchable Fields available in haystack system
     * </pre>
     */
    public void getFieldNames(com.expedia.open.tracing.api.Empty request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.FieldNames> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_GET_FIELD_NAMES, getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * get values for a given Field
     * </pre>
     */
    public void getFieldValues(com.expedia.open.tracing.api.FieldValuesRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.FieldValues> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_GET_FIELD_VALUES, getCallOptions()), request, responseObserver);
    }

    /**
     * <pre>
     * get graph of service calls made in the given traceId
     * </pre>
     */
    public void getTraceCallGraph(com.expedia.open.tracing.api.TraceRequest request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.TraceCallGraph> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_GET_TRACE_CALL_GRAPH, getCallOptions()), request, responseObserver);
    }
  }

  /**
   * <pre>
   * service interface to search and get traces
   * </pre>
   */
  public static final class TraceReaderBlockingStub extends io.grpc.stub.AbstractStub<TraceReaderBlockingStub> {
    private TraceReaderBlockingStub(io.grpc.Channel channel) {
      super(channel);
    }

    private TraceReaderBlockingStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected TraceReaderBlockingStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new TraceReaderBlockingStub(channel, callOptions);
    }

    /**
     * <pre>
     * search for traces based on filter fields and other criterias
     * </pre>
     */
    public com.expedia.open.tracing.api.TracesSearchResult searchTraces(com.expedia.open.tracing.api.TracesSearchRequest request) {
      return blockingUnaryCall(
          getChannel(), METHOD_SEARCH_TRACES, getCallOptions(), request);
    }

    /**
     * <pre>
     * fetch a trace using traceId
     * </pre>
     */
    public com.expedia.open.tracing.api.Trace getTrace(com.expedia.open.tracing.api.TraceRequest request) {
      return blockingUnaryCall(
          getChannel(), METHOD_GET_TRACE, getCallOptions(), request);
    }

    /**
     * <pre>
     * fetch a trace in raw un-transformed format using traceId
     * </pre>
     */
    public com.expedia.open.tracing.api.Trace getRawTrace(com.expedia.open.tracing.api.TraceRequest request) {
      return blockingUnaryCall(
          getChannel(), METHOD_GET_RAW_TRACE, getCallOptions(), request);
    }

    /**
     * <pre>
     * fetch a span of a trace in raw un-transformed format using traceId and spanId
     * </pre>
     */
    public com.expedia.open.tracing.Span getRawSpan(com.expedia.open.tracing.api.SpanRequest request) {
      return blockingUnaryCall(
          getChannel(), METHOD_GET_RAW_SPAN, getCallOptions(), request);
    }

    /**
     * <pre>
     * get all searchable Fields available in haystack system
     * </pre>
     */
    public com.expedia.open.tracing.api.FieldNames getFieldNames(com.expedia.open.tracing.api.Empty request) {
      return blockingUnaryCall(
          getChannel(), METHOD_GET_FIELD_NAMES, getCallOptions(), request);
    }

    /**
     * <pre>
     * get values for a given Field
     * </pre>
     */
    public com.expedia.open.tracing.api.FieldValues getFieldValues(com.expedia.open.tracing.api.FieldValuesRequest request) {
      return blockingUnaryCall(
          getChannel(), METHOD_GET_FIELD_VALUES, getCallOptions(), request);
    }

    /**
     * <pre>
     * get graph of service calls made in the given traceId
     * </pre>
     */
    public com.expedia.open.tracing.api.TraceCallGraph getTraceCallGraph(com.expedia.open.tracing.api.TraceRequest request) {
      return blockingUnaryCall(
          getChannel(), METHOD_GET_TRACE_CALL_GRAPH, getCallOptions(), request);
    }
  }

  /**
   * <pre>
   * service interface to search and get traces
   * </pre>
   */
  public static final class TraceReaderFutureStub extends io.grpc.stub.AbstractStub<TraceReaderFutureStub> {
    private TraceReaderFutureStub(io.grpc.Channel channel) {
      super(channel);
    }

    private TraceReaderFutureStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected TraceReaderFutureStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new TraceReaderFutureStub(channel, callOptions);
    }

    /**
     * <pre>
     * search for traces based on filter fields and other criterias
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.api.TracesSearchResult> searchTraces(
        com.expedia.open.tracing.api.TracesSearchRequest request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_SEARCH_TRACES, getCallOptions()), request);
    }

    /**
     * <pre>
     * fetch a trace using traceId
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.api.Trace> getTrace(
        com.expedia.open.tracing.api.TraceRequest request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_GET_TRACE, getCallOptions()), request);
    }

    /**
     * <pre>
     * fetch a trace in raw un-transformed format using traceId
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.api.Trace> getRawTrace(
        com.expedia.open.tracing.api.TraceRequest request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_GET_RAW_TRACE, getCallOptions()), request);
    }

    /**
     * <pre>
     * fetch a span of a trace in raw un-transformed format using traceId and spanId
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.Span> getRawSpan(
        com.expedia.open.tracing.api.SpanRequest request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_GET_RAW_SPAN, getCallOptions()), request);
    }

    /**
     * <pre>
     * get all searchable Fields available in haystack system
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.api.FieldNames> getFieldNames(
        com.expedia.open.tracing.api.Empty request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_GET_FIELD_NAMES, getCallOptions()), request);
    }

    /**
     * <pre>
     * get values for a given Field
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.api.FieldValues> getFieldValues(
        com.expedia.open.tracing.api.FieldValuesRequest request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_GET_FIELD_VALUES, getCallOptions()), request);
    }

    /**
     * <pre>
     * get graph of service calls made in the given traceId
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.api.TraceCallGraph> getTraceCallGraph(
        com.expedia.open.tracing.api.TraceRequest request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_GET_TRACE_CALL_GRAPH, getCallOptions()), request);
    }
  }

  private static final int METHODID_SEARCH_TRACES = 0;
  private static final int METHODID_GET_TRACE = 1;
  private static final int METHODID_GET_RAW_TRACE = 2;
  private static final int METHODID_GET_RAW_SPAN = 3;
  private static final int METHODID_GET_FIELD_NAMES = 4;
  private static final int METHODID_GET_FIELD_VALUES = 5;
  private static final int METHODID_GET_TRACE_CALL_GRAPH = 6;

  private static class MethodHandlers<Req, Resp> implements
      io.grpc.stub.ServerCalls.UnaryMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ServerStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ClientStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.BidiStreamingMethod<Req, Resp> {
    private final TraceReaderImplBase serviceImpl;
    private final int methodId;

    public MethodHandlers(TraceReaderImplBase serviceImpl, int methodId) {
      this.serviceImpl = serviceImpl;
      this.methodId = methodId;
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public void invoke(Req request, io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_SEARCH_TRACES:
          serviceImpl.searchTraces((com.expedia.open.tracing.api.TracesSearchRequest) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.TracesSearchResult>) responseObserver);
          break;
        case METHODID_GET_TRACE:
          serviceImpl.getTrace((com.expedia.open.tracing.api.TraceRequest) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.Trace>) responseObserver);
          break;
        case METHODID_GET_RAW_TRACE:
          serviceImpl.getRawTrace((com.expedia.open.tracing.api.TraceRequest) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.Trace>) responseObserver);
          break;
        case METHODID_GET_RAW_SPAN:
          serviceImpl.getRawSpan((com.expedia.open.tracing.api.SpanRequest) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.Span>) responseObserver);
          break;
        case METHODID_GET_FIELD_NAMES:
          serviceImpl.getFieldNames((com.expedia.open.tracing.api.Empty) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.FieldNames>) responseObserver);
          break;
        case METHODID_GET_FIELD_VALUES:
          serviceImpl.getFieldValues((com.expedia.open.tracing.api.FieldValuesRequest) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.FieldValues>) responseObserver);
          break;
        case METHODID_GET_TRACE_CALL_GRAPH:
          serviceImpl.getTraceCallGraph((com.expedia.open.tracing.api.TraceRequest) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.api.TraceCallGraph>) responseObserver);
          break;
        default:
          throw new AssertionError();
      }
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public io.grpc.stub.StreamObserver<Req> invoke(
        io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        default:
          throw new AssertionError();
      }
    }
  }

  public static io.grpc.ServiceDescriptor getServiceDescriptor() {
    return new io.grpc.ServiceDescriptor(SERVICE_NAME,
        METHOD_SEARCH_TRACES,
        METHOD_GET_TRACE,
        METHOD_GET_RAW_TRACE,
        METHOD_GET_RAW_SPAN,
        METHOD_GET_FIELD_NAMES,
        METHOD_GET_FIELD_VALUES,
        METHOD_GET_TRACE_CALL_GRAPH);
  }

}
