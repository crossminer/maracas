//
//  ========================================================================
//  Copyright (c) 1995-2017 Mort Bay Consulting Pty. Ltd.
//  ------------------------------------------------------------------------
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Eclipse Public License v1.0
//  and Apache License v2.0 which accompanies this distribution.
//
//      The Eclipse Public License is available at
//      http://www.eclipse.org/legal/epl-v10.html
//
//      The Apache License v2.0 is available at
//      http://www.opensource.org/licenses/apache2.0.php
//
//  You may elect to redistribute this code under either of these licenses.
//  ========================================================================
//

package org.eclipse.jetty.websocket.client.io;

import java.net.InetSocketAddress;
import java.util.concurrent.Executor;
import java.util.concurrent.atomic.AtomicBoolean;

import org.eclipse.jetty.io.EndPoint;
import org.eclipse.jetty.websocket.api.BatchMode;
import org.eclipse.jetty.websocket.api.WebSocketPolicy;
import org.eclipse.jetty.websocket.api.WriteCallback;
import org.eclipse.jetty.websocket.api.extensions.Frame;
import org.eclipse.jetty.websocket.api.extensions.IncomingFrames;
import org.eclipse.jetty.websocket.client.masks.Masker;
import org.eclipse.jetty.websocket.common.WebSocketFrame;
import org.eclipse.jetty.websocket.common.io.AbstractWebSocketConnection;

/**
 * Client side WebSocket physical connection.
 */
public class WebSocketClientConnection extends AbstractWebSocketConnection
{
    private final ConnectPromise connectPromise;
    private final Masker masker;
    private final AtomicBoolean opened = new AtomicBoolean(false);

    public WebSocketClientConnection(EndPoint endp, Executor executor, ConnectPromise connectPromise, WebSocketPolicy policy)
    {
        super(endp,executor,connectPromise.getClient().getScheduler(),policy,connectPromise.getClient().getBufferPool());
        this.connectPromise = connectPromise;
        this.masker = connectPromise.getMasker();
        assert (this.masker != null);
    }

    @Override
    public InetSocketAddress getLocalAddress()
    {
        return getEndPoint().getLocalAddress();
    }

    @Override
    public InetSocketAddress getRemoteAddress()
    {
        return getEndPoint().getRemoteAddress();
    }

    @Override
    public void onOpen()
    {
        super.onOpen();
        boolean beenOpened = opened.getAndSet(true);
        if (!beenOpened)
        {
            connectPromise.succeeded();
        }
    }

    /**
     * Override to set the masker.
     */
    @Override
    public void outgoingFrame(Frame frame, WriteCallback callback, BatchMode batchMode)
    {
        if (frame instanceof WebSocketFrame)
        {
            masker.setMask((WebSocketFrame)frame);
        }
        super.outgoingFrame(frame,callback, batchMode);
    }

    @Override
    public void setNextIncomingFrames(IncomingFrames incoming)
    {
        getParser().setIncomingFramesHandler(incoming);
    }
}
