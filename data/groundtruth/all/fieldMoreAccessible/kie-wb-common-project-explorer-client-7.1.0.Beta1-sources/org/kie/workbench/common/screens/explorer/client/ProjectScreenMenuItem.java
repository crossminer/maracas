package org.kie.workbench.common.screens.explorer.client;

import javax.enterprise.event.Observes;
import javax.inject.Inject;

import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import org.guvnor.common.services.project.context.ProjectContextChangeEvent;
import org.gwtbootstrap3.client.ui.Button;
import org.gwtbootstrap3.client.ui.constants.ButtonSize;
import org.kie.workbench.common.screens.explorer.client.resources.i18n.ProjectExplorerConstants;
import org.uberfire.client.mvp.PlaceManager;
import org.uberfire.workbench.model.menu.impl.BaseMenuCustom;

public class ProjectScreenMenuItem
        extends BaseMenuCustom {

    private PlaceManager placeManager;
    private Button view;

    public ProjectScreenMenuItem() {
    }

    @Inject
    public ProjectScreenMenuItem( final PlaceManager placeManager ) {
        this.placeManager = placeManager;
    }

    public void onProjectContextChanged( @Observes final ProjectContextChangeEvent event ) {
        this.setEnabled( (event.getProject() != null) );
    }

    @Override
    public Object build() {
        view = new Button();
        view.setSize( ButtonSize.SMALL );
        view.setText( ProjectExplorerConstants.INSTANCE.openProjectEditor() );
        view.addClickHandler( new ClickHandler() {
            @Override
            public void onClick( ClickEvent event ) {
                placeManager.goTo( "projectScreen" );
            }
        } );

        return view;
    }

    @Override
    public boolean isEnabled() {
        return view.isEnabled();
    }

}
