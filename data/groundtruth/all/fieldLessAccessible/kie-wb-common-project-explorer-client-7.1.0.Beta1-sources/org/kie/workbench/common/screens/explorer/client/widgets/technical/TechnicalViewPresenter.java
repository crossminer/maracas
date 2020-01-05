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
package org.kie.workbench.common.screens.explorer.client.widgets.technical;

import javax.inject.Inject;

import org.jboss.errai.ioc.client.api.EntryPoint;
import org.kie.workbench.common.screens.explorer.client.widgets.BaseViewPresenter;

/**
 * Repository, Package, Folder and File explorer
 */
@EntryPoint
public class TechnicalViewPresenter
        extends BaseViewPresenter {

    protected TechnicalViewWidget view;

    @Inject
    public TechnicalViewPresenter( final TechnicalViewWidget view ) {
        super( view );
        this.view = view;
    }

    @Override
    protected boolean isViewVisible() {
        return activeOptions.isTechnicalViewActive();
    }
}
