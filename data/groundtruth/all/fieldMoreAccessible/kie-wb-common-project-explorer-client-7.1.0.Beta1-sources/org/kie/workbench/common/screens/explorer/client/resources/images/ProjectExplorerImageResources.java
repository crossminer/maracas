/*
 * Copyright 2012 Red Hat, Inc. and/or its affiliates.
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

package org.kie.workbench.common.screens.explorer.client.resources.images;

import com.google.gwt.core.client.GWT;
import com.google.gwt.resources.client.ClientBundle;
import com.google.gwt.resources.client.ImageResource;

public interface ProjectExplorerImageResources
        extends
        ClientBundle {

    public static final ProjectExplorerImageResources INSTANCE = GWT.create( ProjectExplorerImageResources.class );

    @Source("lock.png")
    ImageResource lock();
    
    @Source("lockowned.png")
    ImageResource lockOwned();
    
    @Source("lockempty.png")
    ImageResource lockEmpty();
}
