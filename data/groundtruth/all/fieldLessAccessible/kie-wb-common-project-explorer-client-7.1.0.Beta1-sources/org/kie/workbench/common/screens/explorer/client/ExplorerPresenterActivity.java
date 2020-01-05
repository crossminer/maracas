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

package org.kie.workbench.common.screens.explorer.client;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import javax.annotation.Generated;
import javax.enterprise.context.Dependent;
import javax.inject.Inject;
import com.google.gwt.user.client.ui.InlineLabel;

import javax.annotation.PostConstruct;
import org.uberfire.client.mvp.UberView;

import javax.inject.Named;
import org.uberfire.client.mvp.AbstractWorkbenchScreenActivity;
import org.uberfire.client.mvp.PlaceManager;

import org.uberfire.workbench.model.Position;

import org.uberfire.mvp.PlaceRequest;

import org.uberfire.workbench.model.menu.Menus;

import com.google.gwt.user.client.ui.IsWidget;

@Dependent
@Generated("org.uberfire.annotations.processors.WorkbenchScreenProcessor")
@Named("org.kie.guvnor.explorer")
/*
 * WARNING! This class is generated. Do not modify.
 */
public class ExplorerPresenterActivity extends AbstractWorkbenchScreenActivity {

    @Inject
    private ExplorerPresenter realPresenter;

    @Inject
    //Constructor injection for testing
    public ExplorerPresenterActivity(final PlaceManager placeManager) {
        super( placeManager );
    }

    @PostConstruct
    public void init() {
        ((UberView) realPresenter.getView()).init( realPresenter );
    }

    @Override
    public void onStartup(final PlaceRequest place) {
        super.onStartup( place );
        realPresenter.onStartup( place );
    }

    @Override
    public String getTitle() {
        return realPresenter.getTitle();
    }

    @Override
    public IsWidget getWidget() {
        return realPresenter.getView();
    }


    @Override
    public Position getDefaultPosition() {
        return realPresenter.getDefaultPosition();
    }
    @Override
    public Menus getMenus() {
        return realPresenter.buildMenu();
    }

    @Override
    public String getIdentifier() {
        return "org.kie.guvnor.explorer";
    }
}
