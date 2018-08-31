package org.swat.manager.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesReader {

	private Properties prop;
	
	public PropertiesReader(String config) throws IOException {
		prop = new Properties();
		File file = new File(config);
		InputStream is = new FileInputStream(file);
		prop.load(is);
	}
	
	public String readProperty(String property) {
		return prop.getProperty(property);
	}
}
