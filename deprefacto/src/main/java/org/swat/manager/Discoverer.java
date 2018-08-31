package org.swat.manager;

import java.util.List;

import org.swat.manager.types.ProjectResult;

public interface Discoverer {
	public List<ProjectResult> getTopNProjects(int n);
}
