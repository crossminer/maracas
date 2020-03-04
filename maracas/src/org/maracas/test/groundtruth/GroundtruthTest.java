package org.maracas.test.groundtruth;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
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
import org.codehaus.plexus.util.xml.Xpp3Dom;
import org.codehaus.plexus.util.xml.pull.XmlPullParserException;
import org.junit.Before;
import org.junit.Test;
import org.maracas.groundtruth.internal.Groundtruth;
import org.rascalmpl.values.ValueFactoryFactory;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;

/**
 * To run these tests perform the following steps:
 * 	1) Extract the projects located at src/org/maracas/test/data/groundtruth
 * 	2) In the terminal cd to each extracted project
 * 	3) Run mvn install to install the plugins in your local repo
 * 	4) Run the tests
 * @author Lina Ochoa
 *
 */
public class GroundtruthTest {

	private static final String USER_DIR = System.getProperty("user.home");
	private static final String MDP_KEY = "org.apache.maven.plugins:maven-dependency-plugin";
	private static final String BHM_KEY = "org.codehaus.mojo:build-helper-maven-plugin";
	private static final String MCP_KEY = "org.apache.maven.plugins:maven-compiler-plugin";
	
	private Groundtruth gt;
	private Model mdpModel;
	private Model bhmModel;
	private Model mcpModel;
	
	@Before
	public void setup() {
		gt = new Groundtruth(ValueFactoryFactory.getValueFactory());
		
		// 1. Create maven-dependency-plugin model
		String[] m2MdpDir = { USER_DIR, ".m2", "repository", "com", "javacodegeeks", "examples", "maven-dependency-plugin-example", "1.0.0-SNAPSHOT" };
		Path m2Mdp = Paths.get(buildPath(m2MdpDir));
		mdpModel = createModel(m2Mdp, "maven-dependency-plugin-example-1.0.0-SNAPSHOT.jar");

		// 2. Create build-helper-maven-plugin model
		String[] m2BhmDir = { USER_DIR, ".m2", "repository", "de", "tse", "jaxb-examples", "0.0.1-SNAPSHOT" };
		Path m2Bhm = Paths.get(buildPath(m2BhmDir));
		bhmModel = createModel(m2Bhm, "jaxb-examples-0.0.1-SNAPSHOT.jar");
		
		// 3. Create maven-compiler-plugin model
		String[] m2McpDir = { USER_DIR, ".m2", "repository", "com", "javacodegeeks", "examples", "maven-compiler-plugin-example", "1.0.0-SNAPSHOT" };
		Path m2Mcp = Paths.get(buildPath(m2McpDir));
		mcpModel = createModel(m2Mcp, "maven-compiler-plugin-example-1.0.0-SNAPSHOT.jar");
	}
	
	private String buildPath(String[] dirs) {
		String path = "";
		for (String dir : dirs) {
			path += dir + File.separator;
		}
		return path;
	}
	
	private Model createModel(Path m2, String jarName) {
		Path jar = m2.resolve(jarName);
		String[] extractDirs = { USER_DIR, "temp", "maracas", jar.getFileName().toString() };
		Path extract = Paths.get(buildPath(extractDirs));
		
		try {
			gt.extractJAR(jar, extract);
			Path pom = gt.movePOM(extract);
			return createModel(pom);
		} 
		catch (IOException | XmlPullParserException e) {
			fail("Test setup for " + jarName + " failer: " + e.getMessage());
		}
		
		return null;
	}
	
	private Model createModel(Path pom) throws IOException, XmlPullParserException {
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
		boolean exists = mdpModel.getBuild().getPluginsAsMap().containsKey(MDP_KEY);
		assertThat(exists, is(true));
	}
	
	@Test
	public void testBhmPluginExists() {
		boolean exists = bhmModel.getBuild().getPluginsAsMap().containsKey(BHM_KEY);
		assertThat(exists, is(true));
	}
	
	@Test
	public void testMcpPluginExists() {
		boolean exists = mcpModel.getBuild().getPluginsAsMap().containsKey(MCP_KEY);
		assertThat(exists, is(true));
	}
	
	@Test
	public void testMdpPluginModify() {
		try {
			Plugin plugin = gt.buildMdpPlugin(mdpModel);
			List<String> goals = getGoals(mdpModel, plugin, MDP_KEY);
			
			assertThat(goals.size(), is(2)); // 1 old version + 1 new version
			assertThat(goals, hasItem("build-classpath")); // In the old version
			assertThat(goals, hasItem("unpack")); // In the new version
		} 
		catch (XmlPullParserException | IOException e) {
			fail(BHM_KEY + " build failed: " + e.getMessage());
		} 
	}
	
	@Test
	public void testBhmPluginModify() {
		try {
			Plugin plugin = gt.buildBhmPlugin(bhmModel);
			List<String> goals = getGoals(bhmModel, plugin, BHM_KEY);
			
			assertThat(goals.size(), is(1)); // 0 old version + 1 new version
			assertThat(goals, hasItem("add-source")); // In the new version
		} 
		catch (XmlPullParserException | IOException e) {
			fail(BHM_KEY + " build failed: " + e.getMessage());
		} 
	}
	
	@Test
	public void testMcpPluginModify() {
		try {
			Plugin plugin = gt.buildMcpPlugin(mcpModel);
			Xpp3Dom config = (Xpp3Dom) plugin.getConfiguration();
			
			assertThat(config.getChildCount(), is(9)); // 8 old version + 1 new version
			assertThat(config.getChild("compilerVersion"), notNullValue()); // In the old version
			assertThat(config.getChild("compilerArguments"), notNullValue()); // In the new version
			assertThat(config.getChild("target").getValue(), is("1.8")); // 1.8 new value - 1.7 old value
		} 
		catch (XmlPullParserException | IOException e) {
			fail(BHM_KEY + " build failed: " + e.getMessage());
		} 
	}
	
	private List<String> getGoals(Model model, Plugin plugin, String key) {
		List<String> goals = new ArrayList<String>();
		gt.addPlugin(model, plugin);
		
		Map<String, Plugin> plugins = model.getBuild().getPluginsAsMap();
		if (plugins.containsKey(key)) {
			Plugin mergedPlug = plugins.get(key);
			
			List<PluginExecution> execs = mergedPlug.getExecutions();
			execs.forEach(e -> {
				goals.addAll(e.getGoals());
			});
		}
		else {
			fail("The " + key + " has been removed from the POM file.");
		}
		return goals;
	}
	
	// @After
	public void teardown() {
		String[] maracasDir = { USER_DIR, "temp", "maracas" };
		try {
			Files.walk(Paths.get(buildPath(maracasDir)))
				.map(Path::toFile)
				.forEach(File::delete);
		} 
		catch (IOException e) {
			fail("Could not delete maracas temp folder.");
		}
	}
}
