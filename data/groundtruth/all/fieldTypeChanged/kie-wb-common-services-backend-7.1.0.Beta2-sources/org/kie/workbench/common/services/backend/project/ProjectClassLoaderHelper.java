/*
 * Copyright 2016 Red Hat, Inc. and/or its affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kie.workbench.common.services.backend.project;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.drools.compiler.kie.builder.impl.InternalKieModule;
import org.kie.api.builder.KieModule;
import org.kie.scanner.KieModuleMetaData;
import org.kie.workbench.common.services.backend.builder.service.BuildInfoService;
import org.kie.workbench.common.services.backend.builder.core.LRUProjectDependenciesClassLoaderCache;
import org.kie.workbench.common.services.shared.project.KieProject;

/**
 *
 */
@ApplicationScoped
public class ProjectClassLoaderHelper {

    @Inject
    private BuildInfoService buildInfoService;

    @Inject
    @Named("LRUProjectDependenciesClassLoaderCache")
    private LRUProjectDependenciesClassLoaderCache dependenciesClassLoaderCache;

    public ClassLoader getProjectClassLoader( KieProject project ) {

        final KieModule module = buildInfoService.getBuildInfo( project ).getKieModuleIgnoringErrors();
        ClassLoader dependenciesClassLoader = dependenciesClassLoaderCache.assertDependenciesClassLoader( project );
        ClassLoader projectClassLoader;
        if ( module instanceof InternalKieModule ) {
            //will always be an internal kie module
            InternalKieModule internalModule = (InternalKieModule) module;
            projectClassLoader = new MapClassLoader( internalModule.getClassesMap( true ), dependenciesClassLoader );
        } else {
            projectClassLoader = KieModuleMetaData.Factory.newKieModuleMetaData( module ).getClassLoader();
        }
        return projectClassLoader;
    }

}