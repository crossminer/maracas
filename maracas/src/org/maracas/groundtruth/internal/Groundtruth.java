package org.maracas.groundtruth.internal;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import org.apache.commons.compress.compressors.FileNameUtil;
import org.apache.maven.model.Build;
import org.apache.maven.model.Dependency;
import org.apache.maven.model.Model;
import org.apache.maven.model.Plugin;
import org.apache.maven.model.PluginExecution;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.apache.maven.model.io.xpp3.MavenXpp3Writer;
import org.codehaus.plexus.util.xml.Xpp3Dom;
import org.codehaus.plexus.util.xml.Xpp3DomBuilder;
import org.codehaus.plexus.util.xml.pull.XmlPullParserException;
import org.rascalmpl.interpreter.IEvaluatorContext;

import io.usethesource.vallang.IBool;
import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IListWriter;
import io.usethesource.vallang.IMapWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

public class Groundtruth {
	// Get mvn path from M2_HOME environment variable
	private final static String MAVEN = ((System.getenv("M2_HOME") == null) ? File.separator + "usr" : System.getenv("M2_HOME")) 
			+ File.separator + "bin" + File.separator + "mvn";
	
	private IValueFactory vf;
	private PrintWriter out;
	private TypeStore ts;
	private TypeFactory tf;
	private CompilerMessageToRascal compMsgToRascal;

	public Groundtruth(IValueFactory vf) {
		this.vf = vf;
		this.ts = new TypeStore();
		this.tf = TypeFactory.getInstance();
		this.compMsgToRascal = new CompilerMessageToRascal(vf);
	}

	public IBool upgradeClient(ISourceLocation clientJar, IString groupId, IString artifactId, IString v1, IString v2,
			IEvaluatorContext ctx) {
		out = ctx.getStdOut();
		boolean upgraded = upgradeClient(Paths.get(clientJar.getPath()), groupId.getValue(),
				artifactId.getValue(), v1.getValue(), v2.getValue());
		return vf.bool(upgraded);
	}
	
	public boolean upgradeClient(Path clientJar, String groupId, String artifactId, String v1, String v2) {
		try {
			// extractDest: <user-home-path>/temp/maracas/<client-jar-name.jar>
			String extractPath = System.getProperty("user.home") 
					+ File.separator 
					+ "temp" 
					+ File.separator 
					+ "maracas"
					+ File.separator 
					+ clientJar.getFileName().toString();
			
			Path extractDest = Paths.get(extractPath);

			// Step 1: extract the content of the client JAR locally
			extractJAR(clientJar, extractDest);
			out.println("Extracted " + clientJar.toAbsolutePath() + " to " + extractDest.toAbsolutePath());

			// Step 2: Move its pom.xml file to the root of the dest folder
			Path pomFile = movePOM(extractDest);
			out.println("Moved extracted pom.xml to " + pomFile.toAbsolutePath());

			// Step 3: Update the pom.xml file to enable compilation with
			// the updated version of the chosen library
			updatePOM(pomFile, groupId, artifactId, v1, v2);
			out.println("Updated POM file at " + pomFile.toAbsolutePath());
			return true;	
		} 
		catch (Exception e) {
			out.println(e.getMessage());
			e.printStackTrace(out);
		}

		return false;
	}
	
	public IList computeJavacErrors(ISourceLocation pomFile, IEvaluatorContext ctx) {
		out = ctx.getStdOut();
		List<CompilerMessage> msgs = computeJavacErrors(Paths.get(pomFile.getPath()));
		IListWriter res = vf.listWriter();

		for (CompilerMessage msg : msgs) {
			IConstructor msgCst = compMsgToRascal.javaToRascal(msg);
			res.append(msgCst);
		}

		return res.done();
	}
	
	public List<CompilerMessage> computeJavacErrors(Path pomFile) {
		try {
			return runMaven(pomFile);
		} 
		catch (IOException | InterruptedException e) {
			out.println(e.getMessage());
			e.printStackTrace(out);
		}
		return Collections.emptyList();
	}

	public void extractJAR(Path jar, Path dest) throws IOException {
		if (!dest.toFile().exists())
			dest.toFile().mkdirs();

		String destPath = dest.toAbsolutePath().toString();
		String jarName = jar.getFileName().toString();
		String jarSrcName = jarName.substring(0, jarName.lastIndexOf(".")) + "-sources.jar";
		Path jarSrc = jar.resolveSibling(jarSrcName);
		
		JarFile jarFile = new JarFile(jarSrc.toAbsolutePath().toString());
		Enumeration<JarEntry> enumEntries = jarFile.entries();

		while (enumEntries.hasMoreElements()) {
			JarEntry file = (JarEntry) enumEntries.nextElement();
			File f = new File(destPath + File.separator + file.getName());
			f.getParentFile().mkdirs();
			
			if (file.isDirectory()) {
				f.mkdir();
				continue;
			}

			InputStream is = jarFile.getInputStream(file);
			FileOutputStream fos = new FileOutputStream(f);
			while (is.available() > 0) {
				fos.write(is.read());
			}
			fos.close();
			is.close();
		}
		jarFile.close();
	}

	public Path movePOM(Path dest) throws IOException {
		// FIXME: This assumes there's one and only one pom.xml file...
		try (Stream<Path> walk = Files.walk(dest)) {
			Path oldPom = walk.filter(f -> f.getFileName().toString().equals("pom.xml")).findFirst().get();
			Path newPom = dest.resolve("pom.xml");

			return Files.copy(oldPom, newPom, StandardCopyOption.REPLACE_EXISTING);
		}
	}

	private void updatePOM(Path pomFile, String groupId, String artifactId, String v1, String v2)
			throws IOException, XmlPullParserException {
		try (Reader reader = new FileReader(pomFile.toAbsolutePath().toString())) {
			MavenXpp3Reader pomReader = new MavenXpp3Reader();

			Model model = pomReader.read(reader);
			reader.close();

			Build modelBuild = model.getBuild();
			if (modelBuild == null) {
				model.setBuild(new Build());
			}

			// Step 1: insert maven-dependency-plugin
			Plugin mdpPlugin = buildMdpPlugin(model);
			addPlugin(model, mdpPlugin);

			// Step 2: insert maven-compiler-plugin
			Plugin mcpPlugin = buildMcpPlugin();
			addPlugin(model, mcpPlugin);

			// Step 3: insert build-helper-maven-plugin
			Plugin bhmPlugin = buildBhmPlugin();
			addPlugin(model, bhmPlugin);

			// Step 4: increase version number for the library
			// FIXME: This assumes it exists...
			for (Dependency d : model.getDependencies()) {
				if (d.getGroupId().equals(groupId) && d.getArtifactId().equals(artifactId)) {
					out.println("Upgrading " + d + " to " + v2);
					d.setVersion(v2);
					break;
				}
			}

			MavenXpp3Writer pomWriter = new MavenXpp3Writer();
			pomWriter.write(new FileWriter(pomFile.toAbsolutePath().toString()), model);
		}
	}

	// FIXME: Ugly as fuck
	private List<CompilerMessage> runMaven(Path pomFile) throws IOException, InterruptedException {
		List<CompilerMessage> errors = new ArrayList<>();
		ProcessBuilder pb = new ProcessBuilder(MAVEN, "clean", "compile", "--fail-at-end");
		pb.directory(pomFile.getParent().toFile());

		Process process = pb.start();
		try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
			String currentLine = reader.readLine();

			Pattern errorPattern = Pattern.compile("\\[ERROR\\]\\s+(.+):\\[([0-9]+),([0-9]+)\\]\\s+(.+)");
			Pattern paramPattern = Pattern.compile("\\[ERROR\\]\\s+(.+):\\s+(.+)");

			boolean recording = false;
			while (currentLine != null) {
				if (currentLine.contains("Finished at:"))
					recording = true;

				if (currentLine.contains("Help 1")) {
					recording = false;
				}

				if (recording) {
					if (currentLine.startsWith("[ERROR] /")) {
						Matcher errorMatcher = errorPattern.matcher(currentLine);

						if (errorMatcher.matches()) {
							String path = errorMatcher.group(1);
							int line = Integer.parseInt(errorMatcher.group(2));
							int offset = Integer.parseInt(errorMatcher.group(3));
							String message = errorMatcher.group(4);
							Map<String, String> params = new HashMap<>();

							// Attempt to match other information
							currentLine = reader.readLine();
							while (currentLine != null && !currentLine.startsWith("[ERROR] /")) {
								Matcher paramMatcher = paramPattern.matcher(currentLine);

								if (paramMatcher.matches()) {
									String key = paramMatcher.group(1);
									String value = paramMatcher.group(2);
									params.put(key, value);
								} else if (!currentLine.contains("Help 1")) {
									message.concat(" " + currentLine);
								} else {
									break;
								}

								currentLine = reader.readLine();
							}

							errors.add(new CompilerMessage(path, line, offset, message, params));
							continue;
						} else {
							out.println("[2 Couldn't parse " + currentLine);
						}
					}
				}

				currentLine = reader.readLine();
			}
		}

		int status = process.waitFor();
		return errors;
	}

	public void addPlugin(Model model, Plugin plugin) {
		model.getBuild().removePlugin(plugin);
		model.getBuild().addPlugin(plugin);
	}
	
	private Plugin createPlugin(Model model, String groupId, String pluginId, String version) {
		Map<String, Plugin> plugins = model.getBuild().getPluginsAsMap();
		String key = groupId + ":" + pluginId;
		if (plugins.containsKey(key)) {
			return plugins.get(key);
		}
		else {
			Plugin mdp = new Plugin();
			mdp.setGroupId(groupId);
			mdp.setArtifactId(pluginId);
			mdp.setVersion(version);
			return mdp;
		}
	}
	
	private void addPluginExecution(Plugin plugin, String goal, String phase, Xpp3Dom config) {
		Map<String, PluginExecution> execs = plugin.getExecutionsAsMap();
		PluginExecution mdpExec = (!execs.containsKey(goal)) ? new PluginExecution() : execs.get(goal);
		addGoal(mdpExec, goal, phase);
		addExecConfiguration(mdpExec, config);
		plugin.addExecution(mdpExec);
	}
	
	private void addPluginExecution(Plugin plugin, String goal, String phase) {
		addPluginExecution(plugin, goal, phase, null);
	}
	
	private void addGoal(PluginExecution exec, String goal, String phase) {
		List<String> goals = exec.getGoals();
		
		if (goals.contains(goal)) {
			exec.removeGoal(goal);
		}
		exec.setId(goal);
		exec.setPhase(phase);
		exec.addGoal(goal);
	}
	
	private void addExecConfiguration(PluginExecution exec, Xpp3Dom config) {
		if (config != null) {
			Xpp3Dom execConfig = (Xpp3Dom) exec.getConfiguration();
			config = Xpp3Dom.mergeXpp3Dom(config, execConfig);
		}
		exec.setConfiguration(config);
	}
	
	public Plugin buildMdpPlugin(Model model)
			throws XmlPullParserException, IOException {
		String mdpArtifactId = "maven-dependency-plugin";
		Plugin mdp = createPlugin(model, "org.apache.maven.plugins", mdpArtifactId, "3.1.1");

		StringBuilder configString = new StringBuilder().append("<configuration><artifactItems><artifactItem>")
				.append("<groupId>" + model.getGroupId() + "</groupId>").append("<artifactId>" + model.getArtifactId() + "</artifactId>")
				.append("<version>" + model.getVersion() + "</version>").append("<classifier>sources</classifier>")
				.append("<overWrite>true</overWrite>")
				.append("<outputDirectory>${project.build.directory}/extracted-sources</outputDirectory>")
				.append("</artifactItem></artifactItems></configuration>");
		
		Xpp3Dom config = Xpp3DomBuilder.build(new StringReader(configString.toString()));
		addPluginExecution(mdp, "unpack", "process-sources", config);
		return mdp;
	}

	private Plugin buildBhmPlugin() throws XmlPullParserException, IOException {
		Plugin mdp = new Plugin();
		mdp.setGroupId("org.codehaus.mojo");
		mdp.setArtifactId("build-helper-maven-plugin");
		mdp.setVersion("3.0.0");

		PluginExecution mdpExec = new PluginExecution();
		mdpExec.setId("add-source");
		mdpExec.setPhase("generate-sources");
		mdpExec.addGoal("add-source");

		StringBuilder configString = new StringBuilder().append("<configuration><sources>")
				.append("<source>${project.build.directory}/extracted-sources</source>")
				.append("</sources></configuration>");

		Xpp3Dom config = Xpp3DomBuilder.build(new StringReader(configString.toString()));
		mdpExec.setConfiguration(config);

		mdp.addExecution(mdpExec);

		return mdp;
	}

	private Plugin buildMcpPlugin() throws XmlPullParserException, IOException {
		Plugin mcp = new Plugin();
		mcp.setGroupId("org.apache.maven.plugins");
		mcp.setArtifactId("maven-compiler-plugin");
		mcp.setVersion("3.8.1");

		StringBuilder configString = new StringBuilder().append("<configuration>").append("<source>1.8</source>")
				.append("<target>1.8</target>").append("<compilerArguments>").append("<deprecation/>")
				.append("<Xmaxerrs>0</Xmaxerrs>").append("</compilerArguments>").append("</configuration>");

		Xpp3Dom config = Xpp3DomBuilder.build(new StringReader(configString.toString()));
		mcp.setConfiguration(config);

		return mcp;
	}
}
