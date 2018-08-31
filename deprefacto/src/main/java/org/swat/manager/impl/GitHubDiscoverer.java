package org.swat.manager.impl;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import java.util.Map;

import org.swat.manager.Discoverer;
import org.swat.manager.types.ProjectResult;
import org.swat.manager.util.RESTManager;

public class GitHubDiscoverer implements Discoverer {

	// Check GitHub API and update accordingly 
	private static final String GITHUB_REST_API = "https://api.github.com";
	private static final String GITHUB_SEARCH_REPOS = "/search/repositories";
	private static final String GITHUB_SEARCH_QUALIFIERS = "q";
	private static final String GITHUB_SEARCH_SORT = "sort";
	private static final String GITHUB_SEARCH_ORDER = "order";
	private static final String GITHUB_SEARCH_CONFIG = "/deprefacto/src/main/java/org/swat/manager/config/config-github.properties";
	
	
	/**
	 * Returns the first n repositories in GitHub with the configuration
	 * given in the GITHUB_SEARCH_CONFIG file.
	 */
	// TODO: continue here!
	public List<ProjectResult> getTopProjects(int n) {
		try {
			String search = GITHUB_REST_API + GITHUB_SEARCH_REPOS;
			URL url = new URL(search);
			Map<String, String> params = null;
			RESTManager.configConnection(url, RESTManager.GET_METHOD, params);
			return null;
		} 
		catch (MalformedURLException e) {
			e.printStackTrace();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<ProjectResult> getTopNProjects(int n) {
		return null;
	}
}
