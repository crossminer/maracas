package org.swat.manager;

import java.util.List;

import org.swat.manager.types.ProjectResult;

public interface Downloader {
	public boolean downloadProject(ProjectResult project);
	public boolean downloadProjects(List<ProjectResult> projects);
}
