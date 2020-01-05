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

package org.eclipse.jetty.server;

import java.io.IOException;
import java.net.URLClassLoader;
import java.util.Collections;

import org.eclipse.jetty.util.TypeUtil;
import org.eclipse.jetty.util.component.ContainerLifeCycle;
import org.eclipse.jetty.util.component.Dumpable;

public class ClassLoaderDump implements Dumpable
{
    final ClassLoader _loader;

    public ClassLoaderDump(ClassLoader loader)
    {
        _loader = loader;
    }

    @Override
    public String dump()
    {
        return ContainerLifeCycle.dump(this);
    }

    @Override
    public void dump(Appendable out, String indent) throws IOException
    {
        if (_loader==null)
            out.append("No ClassLoader\n");
        else if (_loader instanceof Dumpable)
        {
            ContainerLifeCycle.dump(out,indent,Collections.singleton(_loader));
        }
        else if (_loader instanceof URLClassLoader)
        {
            out.append(String.valueOf(_loader)).append("\n");
            ClassLoader parent = _loader.getParent();
            if (parent==null)
                ContainerLifeCycle.dump(out,indent,TypeUtil.asList(((URLClassLoader)_loader).getURLs()));
            else if (parent == Server.class.getClassLoader())
                ContainerLifeCycle.dump(out,indent,TypeUtil.asList(((URLClassLoader)_loader).getURLs()),Collections.singleton(parent.toString()));
            else if (parent instanceof Dumpable)
                ContainerLifeCycle.dump(out,indent,TypeUtil.asList(((URLClassLoader)_loader).getURLs()),Collections.singleton(parent));
            else
                ContainerLifeCycle.dump(out,indent,TypeUtil.asList(((URLClassLoader)_loader).getURLs()),Collections.singleton(new ClassLoaderDump(parent)));
        }
        else
        {
            out.append(String.valueOf(_loader)).append("\n");
            ClassLoader parent = _loader.getParent();
            if (parent==Server.class.getClassLoader())
                ContainerLifeCycle.dump(out,indent,Collections.singleton(parent.toString()));
            else if (parent instanceof Dumpable)
                ContainerLifeCycle.dump(out,indent,Collections.singleton(parent));
            else if (parent!=null)
                ContainerLifeCycle.dump(out,indent,Collections.singleton(new ClassLoaderDump(parent)));
        }
    }
}
