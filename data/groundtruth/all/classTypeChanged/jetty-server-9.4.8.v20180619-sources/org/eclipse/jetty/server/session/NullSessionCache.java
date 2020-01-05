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

package org.eclipse.jetty.server.session;

import javax.servlet.http.HttpServletRequest;

/**
 * NullSessionCache
 *
 * Does not actually cache any Session objects. Useful for testing. 
 * Also useful if you do not want to share Session objects with the same id between 
 * simultaneous requests: note that this means that context forwarding can't share 
 * the same id either.
 */
public class NullSessionCache extends AbstractSessionCache
{

    /**
     * @param handler
     */
    public NullSessionCache(SessionHandler handler)
    {
        super(handler);
        super.setEvictionPolicy(EVICT_ON_SESSION_EXIT);
    }

    /** 
     * @see org.eclipse.jetty.server.session.SessionCache#shutdown()
     */
    @Override
    public void shutdown()
    {
    }

    /** 
     * @see org.eclipse.jetty.server.session.AbstractSessionCache#newSession(org.eclipse.jetty.server.session.SessionData)
     */
    @Override
    public Session newSession(SessionData data)
    {
        return new Session(getSessionHandler(), data);
    }

    /** 
     * @see org.eclipse.jetty.server.session.AbstractSessionCache#newSession(javax.servlet.http.HttpServletRequest, org.eclipse.jetty.server.session.SessionData)
     */
    @Override
    public Session newSession(HttpServletRequest request, SessionData data)
    {
        return new Session(getSessionHandler(), request, data);
    }

    /** 
     * @see org.eclipse.jetty.server.session.AbstractSessionCache#doGet(java.lang.String)
     */
    @Override
    public Session doGet(String id)
    {
        //do not cache anything
        return null;
    }

    /** 
     * @see org.eclipse.jetty.server.session.AbstractSessionCache#doPutIfAbsent(java.lang.String, org.eclipse.jetty.server.session.Session)
     */
    @Override
    public Session doPutIfAbsent(String id, Session session)
    {
        //nothing was stored previously
        return null;
    }

    /** 
     * @see org.eclipse.jetty.server.session.AbstractSessionCache#doReplace(java.lang.String, org.eclipse.jetty.server.session.Session, org.eclipse.jetty.server.session.Session)
     */
    @Override
    public boolean doReplace(String id, Session oldValue, Session newValue)
    {
        //always accept new value
        return true;
    }

    /** 
     * @see org.eclipse.jetty.server.session.AbstractSessionCache#doDelete(java.lang.String)
     */
    @Override
    public Session doDelete(String id)
    {
        return null;
    }

    /** 
     * @see org.eclipse.jetty.server.session.AbstractSessionCache#setEvictionPolicy(int)
     */
    @Override
    public void setEvictionPolicy(int evictionTimeout)
    {
        LOG.warn("Ignoring eviction setting:"+evictionTimeout);
    }
    
    

}
