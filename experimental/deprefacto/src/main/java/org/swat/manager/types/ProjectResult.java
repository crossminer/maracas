package org.swat.manager.types;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;

public class ProjectResult {
	
	private URL url;
	private String name;
	private Date accessDate;
	
	public ProjectResult(String url, String name) throws MalformedURLException {
		this.url = new URL(url);
		this.name = normalizeName(name);
		this.accessDate = new Date();
	}
	
	public URL getUrl() {
		return url;
	}

	public void setUrl(String url) throws MalformedURLException {
		this.url = new URL(url);
	}
	
	public void setUrl(URL url) {
		this.url = url;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = normalizeName(name);;
	}

	public Date getAccessDate() {
		return accessDate;
	}

	public void setAccessDate(Date accessDate) {
		this.accessDate = accessDate;
	}
	
	private String normalizeName(String name) {
		return name.trim().replaceAll(" ", "-");
	}
}
