/*
 * Copyright 2017 Red Hat, Inc. and/or its affiliates.
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

package org.kie.workbench.common.services.backend.builder.ala;

import java.util.Optional;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import org.guvnor.ala.config.Config;
import org.guvnor.ala.config.ProjectConfig;
import org.guvnor.ala.pipeline.BiFunctionConfigExecutor;
import org.guvnor.ala.source.Source;
import org.guvnor.common.services.project.model.Project;
import org.kie.workbench.common.services.backend.builder.ala.impl.LocalProjectImpl;
import org.kie.workbench.common.services.shared.project.KieProjectService;
import org.uberfire.backend.server.util.Paths;

/**
 * Executor for a LocalProjectConfig configuration.
 */
@ApplicationScoped
public class LocalProjectConfigExecutor
        implements BiFunctionConfigExecutor< Source, LocalProjectConfig, ProjectConfig > {

    private KieProjectService projectService;

    public LocalProjectConfigExecutor( ) {
        //Empty constructor for Weld proxying
    }

    @Inject
    public LocalProjectConfigExecutor( KieProjectService projectService ) {
        this.projectService = projectService;
    }

    /**
     * This executor mainly translates project configuration provided by the pipeline input into an internal format
     * convenient for the local build system.
     *
     * @param source the internal representation of the sources in the local build system.
     *
     * @param localProjectConfig the project configuration.
     *
     * @return the internal representation of the project in the local build system.
     */
    @Override
    public Optional< ProjectConfig > apply( Source source, LocalProjectConfig localProjectConfig ) {
        Project project = projectService.resolveProject( Paths.convert( source.getPath( ).resolve( "pom.xml" ) ) );
        return Optional.of( new LocalProjectImpl( project ) );
    }

    @Override
    public Class< ? extends Config > executeFor( ) {
        return LocalProjectConfig.class;
    }

    @Override
    public String outputId( ) {
        return "local-project";
    }
}