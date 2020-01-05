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

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.net.URI;
import java.nio.channels.SocketChannel;
import java.util.Locale;

import org.eclipse.jetty.util.component.ContainerLifeCycle;
import org.eclipse.jetty.util.log.Log;
import org.eclipse.jetty.util.log.Logger;
import org.eclipse.jetty.websocket.client.ClientUpgradeRequest;
import org.eclipse.jetty.websocket.client.WebSocketClient;
import org.eclipse.jetty.websocket.common.events.EventDriver;

/**
 * Internal Connection/Client Manager used to track active clients, their physical vs virtual connection information, and provide some means to create new
 * physical or virtual connections.
 */
public class ConnectionManager extends ContainerLifeCycle
{
    private class PhysicalConnect extends ConnectPromise
    {
        private SocketAddress bindAddress;

        public PhysicalConnect(WebSocketClient client, EventDriver driver, ClientUpgradeRequest request)
        {
            super(client,driver,request);
            this.bindAddress = client.getBindAddress();
        }

        @Override
        public void run()
        {
            SocketChannel channel = null;
            try
            {
                channel = SocketChannel.open();
                if (bindAddress != null)
                {
                    channel.bind(bindAddress);
                }

                URI wsUri = getRequest().getRequestURI();

                channel.socket().setTcpNoDelay(true); // disable nagle
                channel.configureBlocking(false); // async always

                InetSocketAddress address = toSocketAddress(wsUri);

                if (channel.connect(address))
                {
                    getSelector().accept(channel, this);
                }
                else
                {
                    getSelector().connect(channel, this);
                }
            }
            catch (Throwable t)
            {
                // close the socket channel
                if (channel != null)
                {
                    try
                    {
                        channel.close();
                    }
                    catch (IOException ignore)
                    {
                        LOG.ignore(ignore);
                    }
                }
                
                // notify the future
                failed(t);
            }
        }
    }

    private static final Logger LOG = Log.getLogger(ConnectionManager.class);

    public static InetSocketAddress toSocketAddress(URI uri)
    {
        if (!uri.isAbsolute())
        {
            throw new IllegalArgumentException("Cannot get InetSocketAddress of non-absolute URIs");
        }

        int port = uri.getPort();
        String scheme = uri.getScheme().toLowerCase(Locale.ENGLISH);
        if ("ws".equals(scheme))
        {
            if (port == (-1))
            {
                port = 80;
            }
        }
        else if ("wss".equals(scheme))
        {
            if (port == (-1))
            {
                port = 443;
            }
        }
        else
        {
            throw new IllegalArgumentException("Only support ws:// and wss:// URIs");
        }

        return new InetSocketAddress(uri.getHost(),port);
    }

    private final WebSocketClient client;
    private WebSocketClientSelectorManager selector;

    public ConnectionManager(WebSocketClient client)
    {
        this.client = client;
    }

    public ConnectPromise connect(WebSocketClient client, EventDriver driver, ClientUpgradeRequest request)
    {
        return new PhysicalConnect(client,driver,request);
    }

    @Override
    protected void doStart() throws Exception
    {
        selector = newWebSocketClientSelectorManager(client);
        selector.setSslContextFactory(client.getSslContextFactory());
        selector.setConnectTimeout(client.getConnectTimeout());
        addBean(selector);

        super.doStart();
    }

    @Override
    protected void doStop() throws Exception
    {
        super.doStop();
        removeBean(selector);
    }

    public WebSocketClientSelectorManager getSelector()
    {
        return selector;
    }

    /**
     * Factory method for new WebSocketClientSelectorManager (used by other projects like cometd)
     * 
     * @param client
     *            the client used to create the WebSocketClientSelectorManager
     * @return the new WebSocketClientSelectorManager
     */
    protected WebSocketClientSelectorManager newWebSocketClientSelectorManager(WebSocketClient client)
    {
        return new WebSocketClientSelectorManager(client);
    }
}
