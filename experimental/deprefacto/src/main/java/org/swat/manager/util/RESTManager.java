package org.swat.manager.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public class RESTManager {
	
	public static final String GET_METHOD = "GET";
	public static final String POST_METHOD = "POST";
	public static final String PUT_METHOD = "PUT";
	public static final String DELETE_METHOD = "DELETE";
	
	public static HttpURLConnection configConnection(URL url, String method, Map<String, String> params) throws IOException {
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod(method);
		return con;
	}
	
	public static int getResponseCode(HttpURLConnection con) throws IOException {
		return con.getResponseCode();
	}
	
	public static boolean isConnected(HttpURLConnection con) throws IOException {
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
	
	public static String getResponse(HttpURLConnection con) throws IOException {
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
	public static void disconnect(HttpURLConnection con) {
		con.disconnect();
	}
}
