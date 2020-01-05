/*
 * Copyright 2014 Red Hat, Inc. and/or its affiliates.
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

package org.kie.workbench.common.services.backend.service;

import java.util.List;
import javax.enterprise.event.Event;
import javax.inject.Inject;
import javax.inject.Named;

import org.guvnor.common.services.backend.exceptions.ExceptionUtilities;
import org.guvnor.common.services.backend.metadata.MetadataServerSideService;
import org.guvnor.common.services.shared.metadata.model.DiscussionRecord;
import org.guvnor.common.services.shared.metadata.model.Metadata;
import org.guvnor.common.services.shared.metadata.model.Overview;
import org.kie.workbench.common.services.backend.source.SourceServices;
import org.kie.workbench.common.services.shared.discussion.CommentAddedEvent;
import org.kie.workbench.common.services.shared.project.KieProject;
import org.kie.workbench.common.services.shared.project.KieProjectService;
import org.kie.workbench.common.services.shared.source.SourceGenerationFailedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uberfire.backend.server.util.Paths;
import org.uberfire.backend.vfs.Path;
import org.uberfire.ext.editor.commons.backend.version.PathResolver;
import org.uberfire.io.IOService;

public abstract class KieService<T> {

    protected static Logger logger = LoggerFactory.getLogger( KieService.class );

    @Inject
    protected MetadataServerSideService metadataService;

    @Inject
    protected SourceServices sourceServices;

    @Inject
    protected KieProjectService projectService;

    @Inject
    protected Event<CommentAddedEvent> commentAddedEvent;

    @Inject
    protected PathResolver pathResolver;

    @Inject
    @Named("ioStrategy")
    protected IOService ioService;

    public T loadContent( Path path ) {
        try {
            //If the path is a "dot File" attempt to load the associated "principle file"
            final org.uberfire.java.nio.file.Path ioPath = Paths.convert( path );
            if ( pathResolver.isDotFile( ioPath ) ) {
                org.uberfire.java.nio.file.Path ioPrincipleFilePath = pathResolver.resolveMainFilePath( ioPath );

                //If there is no corresponding "principle file" we have to load the dot-file.
                //See https://bugzilla.redhat.com/show_bug.cgi?id=1263713 which gives legitimate use-cases
                //where a dot-file exists but is not one of "our" dot-files!
                if ( !ioService.exists( ioPrincipleFilePath ) ) {
                    ioPrincipleFilePath = ioPath;
                }

                final Path principleFilePath = Paths.convert( ioPrincipleFilePath );
                return constructContent( principleFilePath,
                                         loadOverview( principleFilePath ) );
            } else {
                return constructContent( path,
                                         loadOverview( path ) );
            }
        } catch ( Exception e ) {
            throw ExceptionUtilities.handleException( e );
        }
    }

    protected abstract T constructContent( Path path,
                                           Overview overview );

    private Overview loadOverview( final Path path ) {
        final Overview overview = new Overview();

        try {
            // Some older versions in our example do not have metadata. This should be impossible in any kie-wb version
            overview.setMetadata( metadataService.getMetadata( path ) );
        } catch ( Exception e ) {
            logger.warn( "No metadata found for file: " + path.getFileName() + ", full path [" + path.toString() + "]" );
        }

        //Some resources are not within a Project (e.g. categories.xml) so don't assume we can set the project name
        final KieProject project = projectService.resolveProject( path );
        if ( project == null ) {
            logger.info( "File: " + path.getFileName() + ", full path [" + path.toString() + "] was not within a Project. Project Name cannot be set." );
        } else {
            overview.setProjectName( project.getProjectName() );
        }

        return overview;
    }

    public String getSource( final Path path )
            throws SourceGenerationFailedException {
        final org.uberfire.java.nio.file.Path convertedPath = Paths.convert( path );

        if ( sourceServices.hasServiceFor( convertedPath ) ) {
            return sourceServices.getServiceFor( convertedPath ).getSource( convertedPath );
        } else {
            return "";
        }
    }

    protected void fireMetadataSocialEvents( final Path path,
                                             final Metadata currentMetadata,
                                             final Metadata newMetadata ) {

        List<DiscussionRecord> newDiscussion = newMetadata != null ? newMetadata.getDiscussion() : null;
        List<DiscussionRecord> currentDiscussion = currentMetadata != null ? currentMetadata.getDiscussion() : null;

        if ( newDiscussion != null && newDiscussion.size() > 0 ) {
            for ( DiscussionRecord newRecord : newDiscussion ) {
                if ( newRecord != null && ( currentDiscussion == null || !currentDiscussion.contains( newRecord ) ) ) {
                    commentAddedEvent.fire( new CommentAddedEvent( newRecord.getAuthor(),
                                                                   path, newRecord.getNote(),
                                                                   newRecord.getTimestamp() ) );
                }
            }
        }
    }

}
