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

import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.annotation.PostConstruct;
import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.event.Observes;
import javax.inject.Inject;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.Widget;
import org.guvnor.common.services.project.model.Project;
import org.guvnor.structure.organizationalunit.OrganizationalUnit;
import org.guvnor.structure.repositories.Repository;
import org.kie.workbench.common.screens.explorer.client.widgets.BaseViewImpl;
import org.kie.workbench.common.screens.explorer.client.widgets.BaseViewPresenter;
import org.kie.workbench.common.screens.explorer.client.widgets.View;
import org.kie.workbench.common.screens.explorer.client.widgets.branches.BranchSelector;
import org.kie.workbench.common.screens.explorer.client.widgets.navigator.Explorer;
import org.kie.workbench.common.screens.explorer.client.widgets.navigator.NavigatorOptions;
import org.kie.workbench.common.screens.explorer.client.widgets.tagSelector.TagChangedEvent;
import org.kie.workbench.common.screens.explorer.client.widgets.tagSelector.TagSelector;
import org.kie.workbench.common.screens.explorer.model.FolderItem;
import org.kie.workbench.common.screens.explorer.model.FolderListing;
import org.uberfire.client.mvp.PlaceManager;
import org.uberfire.ext.widgets.common.client.common.BusyPopup;

/**
 * Technical View implementation
 */
@ApplicationScoped
public class TechnicalViewWidget
        extends BaseViewImpl
        implements View {

    private static TechnicalViewImplBinder uiBinder = GWT.create(TechnicalViewImplBinder.class);
    private final NavigatorOptions techOptions = new NavigatorOptions() {{
        showFiles(true);
        showHiddenFiles(false);
        showDirectories(true);
        allowUpLink(true);
        showItemAge(false);
        showItemMessage(false);
        showItemLastUpdater(false);
    }};

    @UiField
    Explorer explorer;

    @UiField(provided = true)
    @Inject
    TagSelector tagSelector;

    @Inject
    PlaceManager placeManager;
    private BaseViewPresenter presenter;

    @PostConstruct
    public void init() {
        //Cannot create and bind UI until after injection points have been initialized
        initWidget(uiBinder.createAndBindUi(this));
    }

    @Override
    public void init(final BaseViewPresenter presenter) {
        this.presenter = presenter;
        explorer.init(techOptions,
                      Explorer.NavType.BREADCRUMB,
                      presenter);

    }

    @Override
    public void setContent(final Project activeProject,
                           final FolderListing folderListing,
                           final Map<FolderItem, List<FolderItem>> siblings) {
        explorer.setupHeader(activeProject);

        tagSelector.loadContent(presenter.getActiveContentTags(),
                                presenter.getCurrentTag());

        explorer.loadContent(folderListing,
                             siblings);

    }

    @Override
    public void setItems(final FolderListing folderListing) {
        renderItems(folderListing);
    }

    @Override
    public void renderItems(FolderListing folderListing) {
        tagSelector.loadContent(presenter.getActiveContentTags(),
                                presenter.getCurrentTag());
        explorer.loadContent(folderListing);
    }

    @Override
    public void showHiddenFiles(final boolean show) {
        techOptions.showHiddenFiles(show);
    }

    @Override
    public void setNavType(Explorer.NavType navType) {
        explorer.setNavType(navType,
                            techOptions);
    }

    @Override
    public void hideTagFilter() {
        tagSelector.hide();
        if (presenter.getActiveContent() != null) {
            renderItems(presenter.getActiveContent());
        }
    }

    @Override
    public void showTagFilter() {
        tagSelector.show();
    }

    @Override
    public void hideHeaderNavigator() {
        explorer.hideHeaderNavigator();
    }

    @Override
    public void showHeaderNavigator() {
        explorer.showHeaderNavigator();
    }

    @Override
    public void showBusyIndicator(final String message) {
        BusyPopup.showMessage(message);
    }

    @Override
    public void hideBusyIndicator() {
        BusyPopup.close();
    }

    @Override
    public Explorer getExplorer() {
        return explorer;
    }

    public void onTagChanged(@Observes TagChangedEvent event) {

    }

    interface TechnicalViewImplBinder
            extends
            UiBinder<Widget, TechnicalViewWidget> {

    }
}
