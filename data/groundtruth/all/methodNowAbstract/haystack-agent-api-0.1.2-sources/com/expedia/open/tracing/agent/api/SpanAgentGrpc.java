package com.expedia.open.tracing.agent.api;

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
 * service interface to push spans to haystack agent
 * </pre>
 */
@javax.annotation.Generated(
    value = "by gRPC proto compiler (version 1.0.1)",
    comments = "Source: agent/spanAgent.proto")
public class SpanAgentGrpc {

  private SpanAgentGrpc() {}

  public static final String SERVICE_NAME = "SpanAgent";

  // Static method descriptors that strictly reflect the proto.
  @io.grpc.ExperimentalApi("https://github.com/grpc/grpc-java/issues/1901")
  public static final io.grpc.MethodDescriptor<com.expedia.open.tracing.Span,
      com.expedia.open.tracing.agent.api.DispatchResult> METHOD_DISPATCH =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          generateFullMethodName(
              "SpanAgent", "dispatch"),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.Span.getDefaultInstance()),
          io.grpc.protobuf.ProtoUtils.marshaller(com.expedia.open.tracing.agent.api.DispatchResult.getDefaultInstance()));

  /**
   * Creates a new async stub that supports all call types for the service
   */
  public static SpanAgentStub newStub(io.grpc.Channel channel) {
    return new SpanAgentStub(channel);
  }

  /**
   * Creates a new blocking-style stub that supports unary and streaming output calls on the service
   */
  public static SpanAgentBlockingStub newBlockingStub(
      io.grpc.Channel channel) {
    return new SpanAgentBlockingStub(channel);
  }

  /**
   * Creates a new ListenableFuture-style stub that supports unary and streaming output calls on the service
   */
  public static SpanAgentFutureStub newFutureStub(
      io.grpc.Channel channel) {
    return new SpanAgentFutureStub(channel);
  }

  /**
   * <pre>
   * service interface to push spans to haystack agent
   * </pre>
   */
  public static abstract class SpanAgentImplBase implements io.grpc.BindableService {

    /**
     * <pre>
     * dispatch span to haystack agent
     * </pre>
     */
    public void dispatch(com.expedia.open.tracing.Span request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.agent.api.DispatchResult> responseObserver) {
      asyncUnimplementedUnaryCall(METHOD_DISPATCH, responseObserver);
    }

    @java.lang.Override public io.grpc.ServerServiceDefinition bindService() {
      return io.grpc.ServerServiceDefinition.builder(getServiceDescriptor())
          .addMethod(
            METHOD_DISPATCH,
            asyncUnaryCall(
              new MethodHandlers<
                com.expedia.open.tracing.Span,
                com.expedia.open.tracing.agent.api.DispatchResult>(
                  this, METHODID_DISPATCH)))
          .build();
    }
  }

  /**
   * <pre>
   * service interface to push spans to haystack agent
   * </pre>
   */
  public static final class SpanAgentStub extends io.grpc.stub.AbstractStub<SpanAgentStub> {
    private SpanAgentStub(io.grpc.Channel channel) {
      super(channel);
    }

    private SpanAgentStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected SpanAgentStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new SpanAgentStub(channel, callOptions);
    }

    /**
     * <pre>
     * dispatch span to haystack agent
     * </pre>
     */
    public void dispatch(com.expedia.open.tracing.Span request,
        io.grpc.stub.StreamObserver<com.expedia.open.tracing.agent.api.DispatchResult> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(METHOD_DISPATCH, getCallOptions()), request, responseObserver);
    }
  }

  /**
   * <pre>
   * service interface to push spans to haystack agent
   * </pre>
   */
  public static final class SpanAgentBlockingStub extends io.grpc.stub.AbstractStub<SpanAgentBlockingStub> {
    private SpanAgentBlockingStub(io.grpc.Channel channel) {
      super(channel);
    }

    private SpanAgentBlockingStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected SpanAgentBlockingStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new SpanAgentBlockingStub(channel, callOptions);
    }

    /**
     * <pre>
     * dispatch span to haystack agent
     * </pre>
     */
    public com.expedia.open.tracing.agent.api.DispatchResult dispatch(com.expedia.open.tracing.Span request) {
      return blockingUnaryCall(
          getChannel(), METHOD_DISPATCH, getCallOptions(), request);
    }
  }

  /**
   * <pre>
   * service interface to push spans to haystack agent
   * </pre>
   */
  public static final class SpanAgentFutureStub extends io.grpc.stub.AbstractStub<SpanAgentFutureStub> {
    private SpanAgentFutureStub(io.grpc.Channel channel) {
      super(channel);
    }

    private SpanAgentFutureStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected SpanAgentFutureStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new SpanAgentFutureStub(channel, callOptions);
    }

    /**
     * <pre>
     * dispatch span to haystack agent
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.expedia.open.tracing.agent.api.DispatchResult> dispatch(
        com.expedia.open.tracing.Span request) {
      return futureUnaryCall(
          getChannel().newCall(METHOD_DISPATCH, getCallOptions()), request);
    }
  }

  private static final int METHODID_DISPATCH = 0;

  private static class MethodHandlers<Req, Resp> implements
      io.grpc.stub.ServerCalls.UnaryMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ServerStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ClientStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.BidiStreamingMethod<Req, Resp> {
    private final SpanAgentImplBase serviceImpl;
    private final int methodId;

    public MethodHandlers(SpanAgentImplBase serviceImpl, int methodId) {
      this.serviceImpl = serviceImpl;
      this.methodId = methodId;
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public void invoke(Req request, io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_DISPATCH:
          serviceImpl.dispatch((com.expedia.open.tracing.Span) request,
              (io.grpc.stub.StreamObserver<com.expedia.open.tracing.agent.api.DispatchResult>) responseObserver);
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
        METHOD_DISPATCH);
  }

}
