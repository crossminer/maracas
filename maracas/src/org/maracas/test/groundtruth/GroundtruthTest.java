package org.maracas.test.groundtruth;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.maven.model.Build;
import org.apache.maven.model.Model;
import org.apache.maven.model.Plugin;
import org.apache.maven.model.PluginExecution;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.codehaus.plexus.util.xml.pull.XmlPullParserException;
import org.hamcrest.CoreMatchers;
import org.junit.Before;
import org.junit.Test;
import org.maracas.groundtruth.internal.Groundtruth;
import org.rascalmpl.values.ValueFactoryFactory;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;

public class GroundtruthTest {

	private static final String MDP_KEY = "org.apache.maven.plugins:maven-dependency-plugin";
	
	private Groundtruth gt;
	private Path m2MvnDepPlug;
	private Path m2MvnDepPlugExtract;
	private Path m2MvnDepPlugJar;
	private Path m2MvnDepPlugPom;
	private Model m2MvnDepPlugModel;
	
	@Before
	public void setup() {
		gt = new Groundtruth(ValueFactoryFactory.getValueFactory());
		
		String homeDir = System.getProperty("user.home");
		String[] dirsMvnDepPlug = { homeDir, ".m2", "repository", "com", "javacodegeeks", "examples", "maven-dependency-plugin-example", "1.0.0-SNAPSHOT" };
		m2MvnDepPlug = Paths.get(buildPath(dirsMvnDepPlug));
		m2MvnDepPlugJar = m2MvnDepPlug.resolve("maven-dependency-plugin-example-1.0.0-SNAPSHOT.jar");
		
		String[] dirsMvnDepPlugExtract = { homeDir, "temp", "maracas", m2MvnDepPlugJar.getFileName().toString() };
		m2MvnDepPlugExtract = Paths.get(buildPath(dirsMvnDepPlugExtract));
		
		try {
			gt.extractJAR(m2MvnDepPlugJar, m2MvnDepPlugExtract);
			m2MvnDepPlugPom = gt.movePOM(m2MvnDepPlugExtract);
			m2MvnDepPlugModel = createPomModel(m2MvnDepPlugPom);
		} 
		catch (IOException | XmlPullParserException e) {
			fail("Test setup failer: " + e.getMessage());
		}
	}
	
	private String buildPath(String[] dirs) {
		String path = "";
		for (String dir : dirs) {
			path += dir + File.separator;
		}
		return path;
	}
	
	private Model createPomModel(Path pom) throws IOException, XmlPullParserException {
		// TODO: create new method in Groundtruth class
		try (Reader reader = new FileReader(pom.toAbsolutePath().toString())) {
			MavenXpp3Reader pomReader = new MavenXpp3Reader();

			Model model = pomReader.read(reader);
			reader.close();

			Build modelBuild = model.getBuild();
			if (modelBuild == null) {
				model.setBuild(new Build());
			}
			return model;
		}
	}
	
	@Test
	public void testMdpPluginExists() {
		boolean exists = m2MvnDepPlugModel.getBuild().getPluginsAsMap().containsKey(MDP_KEY);
		assertTrue("The " + MDP_KEY + " is part of the POM file.", exists);
	}
	
	@Test
	public void testMdpPluginModify() {
		try {
			Plugin plugin = gt.buildMdpPlugin(m2MvnDepPlugModel);
			gt.addPlugin(m2MvnDepPlugModel, plugin);
			
			Map<String, Plugin> plugins = m2MvnDepPlugModel.getBuild().getPluginsAsMap();
			if (plugins.containsKey(MDP_KEY)) {
				Plugin mergedPlug = plugins.get(MDP_KEY);
				
				List<PluginExecution> execs = mergedPlug.getExecutions();
				List<String> goals = new ArrayList<String>();
				execs.forEach(e -> {
					goals.addAll(e.getGoals());
				});
				
				assertThat(execs.size(), is(2));
				assertThat(goals, hasItem("build-classpath"));
				assertThat(goals, hasItem("unpack"));
			}
			else {
				fail("The " + MDP_KEY + " has been removed from the POM file.");
			}
		}
		catch(IOException | XmlPullParserException e) {
			fail(MDP_KEY + " build failed: " + e.getMessage());
		}
	}
}
