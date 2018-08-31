package org.swat.manager.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public class RESTManager {
	
	public HttpURLConnection configConnection(URL url, String method, Map<String, String> params) throws IOException {
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod(method);
		return con;
	}
	
	public int getResponseCode(HttpURLConnection con) throws IOException {
		return con.getResponseCode();
	}
	
	public boolean isConnected(HttpURLConnection con) throws IOException {
		int respCode = con.getResponseCode();
		
		// Only 2XX HTTP codes return true
		switch(respCode) {
		case HttpURLConnection.HTTP_ACCEPTED:
			return true;
		case HttpURLConnection.HTTP_CREATED:
			return true;
		case HttpURLConnection.HTTP_NO_CONTENT:
			return true;
		case HttpURLConnection.HTTP_NOT_AUTHORITATIVE:
			return true;
		case HttpURLConnection.HTTP_OK:
			return true;
		case HttpURLConnection.HTTP_PARTIAL:
			return true;
		case HttpURLConnection.HTTP_RESET:
			return true;
		default:
			return false;
		}
	}
	
	public String getResponse(HttpURLConnection con) throws IOException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
		StringBuffer content = new StringBuffer();
		String line;
		
		while((line = reader.readLine()) != null) {
			content.append(line);
		}
		reader.close();
		return content.toString();
	}
	
	// When you stop using a HttpURLConnection object you must invoke this method.
	public void disconnect(HttpURLConnection con) {
		con.disconnect();
	}
}
