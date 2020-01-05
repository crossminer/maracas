/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 2012 Oracle and/or its affiliates. All rights reserved.
 *
 * The contents of this file are subject to the terms of either the GNU
 * General Public License Version 2 only ("GPL") or the Common Development
 * and Distribution License("CDDL") (collectively, the "License").  You
 * may not use this file except in compliance with the License.  You can
 * obtain a copy of the License at
 * https://glassfish.dev.java.net/public/CDDL+GPL_1_1.html
 * or packager/legal/LICENSE.txt.  See the License for the specific
 * language governing permissions and limitations under the License.
 *
 * When distributing the software, include this License Header Notice in each
 * file and include the License file at packager/legal/LICENSE.txt.
 *
 * GPL Classpath Exception:
 * Oracle designates this particular file as subject to the "Classpath"
 * exception as provided by Oracle in the GPL Version 2 section of the License
 * file that accompanied this code.
 *
 * Modifications:
 * If applicable, add the following below the License Header, with the fields
 * enclosed by brackets [] replaced by your own identifying information:
 * "Portions Copyright [year] [name of copyright owner]"
 *
 * Contributor(s):
 * If you wish your version of this file to be governed by only the CDDL or
 * only the GPL Version 2, indicate your decision by adding "[Contributor]
 * elects to include this software in this distribution under the [CDDL or GPL
 * Version 2] license."  If you don't indicate a single choice of license, a
 * recipient has the option to distribute your version of this file under
 * either the CDDL, the GPL Version 2 or to extend the choice of license to
 * its licensees as provided above.  However, if you add GPL Version 2 code
 * and therefore, elected the GPL Version 2 license, then the option applies
 * only if the new code is made subject to such option by the copyright
 * holder.
 */


package org.glassfish.admin.rest.adapter;

import com.sun.enterprise.admin.remote.writer.PayloadPartProvider;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import javax.ws.rs.core.MediaType;
import org.glassfish.admin.rest.provider.*;
import org.glassfish.admin.rest.readers.JsonParameterMapProvider;
import org.glassfish.admin.rest.readers.ParameterMapFormReader;
import org.glassfish.admin.rest.resources.admin.CommandResource;
import org.glassfish.hk2.api.ServiceLocator;
import org.glassfish.jersey.media.sse.OutboundEventWriter;

/**
 * Responsible for providing ReST resources for {@code asadmin} and {@code cadmin} communication.
 *
 * @author mmares
 * @author sanjeeb.sahoo@oracle.com
 */
public class RestCommandResourceProvider extends AbstractRestResourceProvider {


    public RestCommandResourceProvider() {
        super();
    }

    @Override
    public boolean enableModifAccessToInstances() {
        return true;
    }

    @Override
    public Map<String, MediaType> getMimeMappings() {
        if (mappings == null) {
            mappings = new HashMap<String, MediaType>();
            mappings.put("json", MediaType.APPLICATION_JSON_TYPE);
            mappings.put("txt", MediaType.TEXT_PLAIN_TYPE);
            mappings.put("multi", new MediaType("multipart", null));
            mappings.put("sse", new MediaType("text", "event-stream"));
        };

        return mappings;
    }

    @Override
    public Set<Class<?>> getResourceClasses(ServiceLocator habitat) {
        final Set<Class<?>> r = new HashSet<Class<?>>();
        r.add(CommandResource.class);
        //ActionReport - providers
        r.add(ActionReportJson2Provider.class);
        //CommandModel - providers
        r.add(CommandModelStaxProvider.class);
        //Parameters
        r.add(ParameterMapFormReader.class);
        r.add(JsonParameterMapProvider.class);
        r.add(PayloadPartProvider.class);
        //SSE data
        r.add(OutboundEventWriter.class);
        r.add(AdminCommandStateJsonProvider.class);
        //ProgressStatus
        r.add(ProgressStatusJsonProvider.class);
        r.add(ProgressStatusEventJsonProvider.class);
//        //Debuging filters
//        r.add(LoggingFilter.class);
        return r;
    }

    @Override
    public String getContextRoot() {
        return org.glassfish.admin.restconnector.Constants.REST_COMMAND_CONTEXT_ROOT;
    }
}
