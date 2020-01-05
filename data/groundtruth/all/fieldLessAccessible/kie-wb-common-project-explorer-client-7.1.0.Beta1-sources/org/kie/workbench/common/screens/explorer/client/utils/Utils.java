/*
 * Copyright 2013 Red Hat, Inc. and/or its affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.kie.workbench.common.screens.explorer.client.utils;

import org.guvnor.common.services.project.model.Package;
import org.guvnor.common.services.project.model.Project;
import org.guvnor.structure.organizationalunit.OrganizationalUnit;
import org.guvnor.structure.repositories.Repository;
import org.kie.workbench.common.screens.explorer.model.FolderItem;
import org.kie.workbench.common.screens.explorer.model.FolderItemType;
import org.uberfire.backend.vfs.Path;

/**
 * General utilities
 */
public class Utils {

    /**
     * A convenience method to compare two OrganizationalUnits avoiding cluttering code with null checks.
     * @param organizationalUnit
     * @param activeOrganizationalUnit
     * @return
     */
    public static boolean hasOrganizationalUnitChanged( final OrganizationalUnit organizationalUnit,
                                                        final OrganizationalUnit activeOrganizationalUnit ) {
        if ( organizationalUnit == null && activeOrganizationalUnit != null ) {
            return true;
        }
        if ( organizationalUnit != null && activeOrganizationalUnit == null ) {
            return true;
        }
        if ( organizationalUnit == null && activeOrganizationalUnit == null ) {
            return false;
        }
        return !organizationalUnit.equals( activeOrganizationalUnit );
    }

    /**
     * A convenience method to compare two Repositories avoiding cluttering code with null checks.
     * @param repository
     * @param activeRepository
     * @return
     */
    public static boolean hasRepositoryChanged( final Repository repository,
                                                final Repository activeRepository ) {
        if ( repository == null && activeRepository != null ) {
            return true;
        }
        if ( repository != null && activeRepository == null ) {
            return true;
        }
        if ( repository == null && activeRepository == null ) {
            return false;
        }
        return !repository.equals( activeRepository );
    }

    public static boolean hasBranchChanged( final String branch,
                                            final String activeBranch ) {
        if ( branch == null || activeBranch == null ) {
            return true;
        }
        return !branch.equals( activeBranch );
    }

    /**
     * A convenience method to compare two Projects avoiding cluttering code with null checks.
     * @param project
     * @param activeProject
     * @return
     */
    public static boolean hasProjectChanged( final Project project,
                                             final Project activeProject ) {
        if ( project == null && activeProject != null ) {
            return true;
        }
        if ( project != null && activeProject == null ) {
            return true;
        }
        if ( project == null && activeProject == null ) {
            return false;
        }
        return !project.equals( activeProject );
    }

    /**
     * A convenience method to compare two PAckages avoiding cluttering code with null checks.
     * @param pkg
     * @param activePackage
     * @return
     */
    public static boolean hasPackageChanged( final Package pkg,
                                             final Package activePackage ) {
        if ( pkg == null && activePackage != null ) {
            return true;
        }
        if ( pkg != null && activePackage == null ) {
            return true;
        }
        if ( pkg == null && activePackage == null ) {
            return false;
        }
        return !pkg.equals( activePackage );
    }

    public static boolean hasFolderItemChanged( final FolderItem item,
                                                final FolderItem activeItem ) {
        if ( item == null && activeItem != null ) {
            return true;
        }
        if ( item != null && activeItem == null ) {
            return true;
        }
        if ( item == null && activeItem == null ) {
            return false;
        }
        return !item.equals( activeItem );
    }

    /**
     * Make a Folder Item representing a File
     * @param path
     * @return
     */
    public static FolderItem makeFileItem( final Path path ) {
        return new FolderItem( path,
                               path.getFileName(),
                               FolderItemType.FILE);
    }

    /**
     * Make a Folder Item representing a Folder
     * @param path
     * @return
     */
    public static FolderItem makeFolderItem( final Path path ) {
        return new FolderItem( path,
                               path.getFileName(),
                               FolderItemType.FOLDER);
    }

    /**
     * Check whether the Project is contained within the Branch
     * @param branchRootPath
     * @param project
     * @return
     */
    public static boolean isInBranch( final Path branchRootPath,
                                      final Project project ) {
        if ( branchRootPath == null ) {
            return false;
        }

        if ( project == null ) {
            return false;
        }

        //Check Project path starts with the active repository path
        final Path projectRootPath = project.getRootPath();
        if ( Utils.isLeaf( projectRootPath,
                           branchRootPath ) ) {
            return true;
        }
        return false;
    }

    /**
     * Check whether the Package is contained within the Project
     * @param project
     * @param pkg
     * @return
     */
    public static boolean isInProject( final Project project,
                                       final Package pkg ) {
        if ( project == null ) {
            return false;
        }
        //Check Package path is within the active Project path
        final Path projectRootPath = project.getRootPath();
        final Path pkgMainSrcPath = pkg.getPackageMainSrcPath();
        final Path pkgTestSrcPath = pkg.getPackageTestSrcPath();
        final Path pkgMainResourcesPath = pkg.getPackageMainResourcesPath();
        final Path pkgTestResourcesPath = pkg.getPackageTestResourcesPath();

        if ( Utils.isSibling( pkgMainSrcPath,
                              projectRootPath ) ) {
            return true;
        }
        if ( Utils.isSibling( pkgTestSrcPath,
                              projectRootPath ) ) {
            return true;
        }
        if ( Utils.isSibling( pkgMainResourcesPath,
                              projectRootPath ) ) {
            return true;
        }
        if ( Utils.isSibling( pkgTestResourcesPath,
                              projectRootPath ) ) {
            return true;
        }
        return false;
    }

    public static boolean isInFolderItem( final FolderItem folderItem,
                                          final Path resource ) {
        if ( folderItem == null || folderItem.getItem() == null ) {
            return false;
        }
        if ( !folderItem.getType().equals( FolderItemType.FOLDER ) ) {
            return false;
        }
        if ( folderItem.getItem() instanceof Path ) {
            return isLeaf( resource, (Path) folderItem.getItem() );
        } else if ( folderItem.getItem() instanceof Package ) {
            return isInPackage( (Package) folderItem.getItem(), resource );
        }
        return false;
    }

    /**
     * Check whether the Resource is contained within the Package
     * @param pkg
     * @param resource
     * @return
     */
    public static boolean isInPackage( final Package pkg,
                                       final Path resource ) {
        if ( pkg == null ) {
            return false;
        }
        //Check resource path starts with the active folder list path
        final Path pkgMainSrcPath = pkg.getPackageMainSrcPath();
        final Path pkgTestSrcPath = pkg.getPackageTestSrcPath();
        final Path pkgMainResourcesPath = pkg.getPackageMainResourcesPath();
        final Path pkgTestResourcesPath = pkg.getPackageTestResourcesPath();

        if ( Utils.isLeaf( resource,
                           pkgMainSrcPath ) ) {
            return true;
        }
        if ( Utils.isLeaf( resource,
                           pkgTestSrcPath ) ) {
            return true;
        }
        if ( Utils.isLeaf( resource,
                           pkgMainResourcesPath ) ) {
            return true;
        }
        if ( Utils.isLeaf( resource,
                           pkgTestResourcesPath ) ) {
            return true;
        }
        return false;
    }

    /**
     * Check whether the child is the immediate leaf of the parent. This method is really dirty as it depends
     * upon String manipulation to determine whether the child is the immediate leaf of the parent. This was originally
     * performed server-side using NIO2 Path semantics however problems occur when trying to determine whether a Path
     * is a file or folder when the Path does not exist.
     * @param child
     * @param parent
     * @return
     */
    public static boolean isLeaf( final Path child,
                                  final Path parent ) {
        final String childUri = child.toURI();
        final String parentUri = parent.toURI();
        if ( childUri.startsWith( parentUri ) ) {
            //If there are no additional path separators the resource must be within the active folder listing
            final String leafUri = childUri.replace( parentUri,
                                                     "" );
            return leafUri.indexOf( "/",
                                    1 ) == -1;
        }
        return false;
    }

    /**
     * Check whether the child is a sibling of the parent. This method is really dirty as it depends
     * upon String manipulation to determine whether the child is the immediate leaf of the parent.
     * @param child
     * @param parent
     * @return
     */
    public static boolean isSibling( final Path child,
                                     final Path parent ) {
        final String childUri = child.toURI();
        final String parentUri = parent.toURI();
        return childUri.startsWith( parentUri );
    }

    /**
     * Strip the file extension from a full filename
     * @param fileName
     * @return
     */
    public static String getBaseFileName( final String fileName, final String suffix ) {
        final int suffixIndex = fileName.lastIndexOf( "." + suffix );
        return ( suffixIndex > 0 ? fileName.substring( 0,
                                                    suffixIndex ) : fileName );
    }

}
