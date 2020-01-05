/*
 * Copyright 2016 Red Hat, Inc. and/or its affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.kie.workbench.common.services.backend.validation.asset;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.inject.Named;

import com.google.common.base.Charsets;
import org.guvnor.common.services.project.builder.model.IncrementalBuildResults;
import org.guvnor.common.services.project.model.Project;
import org.guvnor.common.services.shared.message.Level;
import org.guvnor.common.services.shared.validation.model.ValidationMessage;
import org.kie.workbench.common.services.backend.builder.service.BuildInfo;
import org.kie.workbench.common.services.backend.builder.service.BuildInfoImpl;
import org.kie.workbench.common.services.backend.builder.service.BuildInfoService;
import org.kie.workbench.common.services.backend.builder.core.Builder;
import org.kie.workbench.common.services.backend.builder.core.LRUBuilderCache;
import org.kie.workbench.common.services.shared.project.KieProjectService;
import org.uberfire.backend.server.util.Paths;
import org.uberfire.backend.vfs.Path;
import org.uberfire.io.IOService;

@ApplicationScoped
public class ValidatorBuildService {

    private final static String ERROR_CLASS_NOT_FOUND = "Definition of class \"{0}\" was not found. Consequentially validation cannot be performed.\nPlease check the necessary external dependencies for this project are configured correctly.";

    private IOService ioService;
    private LRUBuilderCache builderCache;
    private KieProjectService projectService;
    private BuildInfoService buildInfoService;

    public ValidatorBuildService() {
        //CDI proxies
    }

    @Inject
    public ValidatorBuildService( final @Named("ioStrategy") IOService ioService,
                                  final LRUBuilderCache builderCache,
                                  final KieProjectService projectService,
                                  final BuildInfoService buildInfoService ) {
        this.ioService = ioService;
        this.builderCache = builderCache;
        this.projectService = projectService;
        this.buildInfoService = buildInfoService;
    }

    public List<ValidationMessage> validate( final Path resourcePath,
                                             final String content ) {
        InputStream inputStream = null;
        try {
            inputStream = new ByteArrayInputStream( content.getBytes( Charsets.UTF_8 ) );
            final List<ValidationMessage> results = doValidation( resourcePath,
                                                                  inputStream );
            return results;

        } catch ( NoProjectException e ) {
            return new ArrayList<>();
        } catch ( NoClassDefFoundError e ) {
            return error( MessageFormat.format( ERROR_CLASS_NOT_FOUND,
                                                e.getLocalizedMessage() ) );
        } catch ( Throwable e ) {
            return error( e.getLocalizedMessage() );
        } finally {
            if ( inputStream != null ) {
                try {
                    inputStream.close();
                } catch ( IOException e ) {
                }
            }
        }
    }

    public List<ValidationMessage> validate( final Path resourcePath ) {
        InputStream inputStream = null;
        try {
            inputStream = ioService.newInputStream( Paths.convert( resourcePath ) );
            final List<ValidationMessage> results = doValidation( resourcePath,
                                                                  inputStream );
            return results;

        } catch ( NoProjectException e ) {
            return new ArrayList<>();
        } catch ( NoClassDefFoundError e ) {
            return error( MessageFormat.format( ERROR_CLASS_NOT_FOUND,
                                                e.getLocalizedMessage() ) );
        } catch ( Throwable e ) {
            return error( e.getLocalizedMessage() );
        } finally {
            if ( inputStream != null ) {
                try {
                    inputStream.close();
                } catch ( IOException e ) {
                }
            }
        }
    }

    private List<ValidationMessage> doValidation( final Path resourcePath,
                                                  final InputStream inputStream ) throws NoProjectException {
        final ValidatorResultBuilder resultBuilder = new ValidatorResultBuilder();
        final Project project = project( resourcePath );
        final org.uberfire.java.nio.file.Path nioResourcePath = Paths.convert( resourcePath );

        //Incremental Build does not support Java classes
        if ( isIncrementalBuildPossible( resourcePath ) ) {
            //Build the Builder from the cache so it's "built" state can be preserved for re-use
            BuildInfo buildInfo = buildInfoService.getBuildInfo( project );
            final Builder clone = ( ( BuildInfoImpl ) buildInfo ).getBuilder().clone();
            //First delete resource otherwise if the resource already had errors following builder.build()
            //the incremental compilation will not report any additional errors and the resource will be
            //considered valid.
            clone.deleteResource( nioResourcePath );

            final IncrementalBuildResults incrementalBuildResults = clone.updateResource( nioResourcePath,
                                                                                          inputStream );
            resultBuilder.add( incrementalBuildResults.getAddedMessages() );

        } else {
            Builder builder = builderCache.assertBuilder( project( resourcePath ) );
            final Builder clone = builder.clone();
            resultBuilder.add( clone.build( nioResourcePath,
                                            inputStream ).getMessages() );
        }

        return resultBuilder.results();
    }

    private boolean isIncrementalBuildPossible( final Path resourcePath ) throws NoProjectException {
        final boolean isResource = getDestinationPath( resourcePath ).startsWith( "src/main/resources/" );
        return isResource;
    }

    private String getDestinationPath( final Path path ) throws NoProjectException {
        final int rootPathLength = project( path ).getRootPath().toURI().length() + 1;
        return path.toURI().substring( rootPathLength );
    }

    private Project project( final Path resourcePath ) throws NoProjectException {
        final Project project = projectService.resolveProject( resourcePath );

        if ( project == null ) {
            throw new NoProjectException();
        }

        return project;
    }

    private ArrayList<ValidationMessage> error( final String errorMessage ) {
        return new ArrayList<ValidationMessage>() {{
            add( new ValidationMessage( Level.ERROR, errorMessage ) );
        }};
    }
}
