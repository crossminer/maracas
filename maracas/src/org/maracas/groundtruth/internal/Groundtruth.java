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
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

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
	public final static String MAVEN = "/usr/bin/mvn";

	private IValueFactory vf;
	private PrintWriter out;

	public Groundtruth(IValueFactory vf) {
		this.vf = vf;
	}

	public IList recordErrors(ISourceLocation clientJar, IString groupId, IString artifactId, IString v1, IString v2,
			IEvaluatorContext ctx) {
		out = ctx.getStdOut();

		List<CompilationMessage> msgs = recordErrors(Paths.get(clientJar.getPath()), groupId.getValue(),
				artifactId.getValue(), v1.getValue(), v2.getValue());
		IListWriter res = vf.listWriter();
		TypeStore ts = new TypeStore();
		TypeFactory tf = TypeFactory.getInstance();

		for (CompilationMessage msg : msgs) {
			Type compilerMessage = tf.abstractDataType(ts, "CompilerMessage");
			Type msgCstTyp = tf.constructor(ts, compilerMessage, "message");
			ISourceLocation rscPath = vf.sourceLocation(msg.path);
			IInteger rscLine = vf.integer(msg.line);
			IInteger rscColumn = vf.integer(msg.column);
			IString rscMessage = vf.string(msg.message);
			IMapWriter rscParams = vf.mapWriter();

			for (String k : msg.parameters.keySet())
				rscParams.put(vf.string(k), vf.string(msg.parameters.get(k)));

			IConstructor msgCst = vf.constructor(msgCstTyp, rscPath, rscLine, rscColumn, rscMessage, rscParams.done());
			res.append(msgCst);
		}

		return res.done();
	}

	public List<CompilationMessage> recordErrors(Path clientJar, String groupId, String artifactId, String v1,
			String v2) {
		try {
			Path extractDest = Paths.get(clientJar.getFileName().toString());

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

			// Step 4: Run Maven and record the output
			return runMaven(pomFile);
		} catch (Exception e) {
			out.println(e.getMessage());
			e.printStackTrace(out);
		}

		return Collections.emptyList();
	}

	private void extractJAR(Path jar, Path dest) throws IOException {
		if (!dest.toFile().exists())
			dest.toFile().mkdir();

		String destPath = dest.toAbsolutePath().toString();
		JarFile jarFile = new JarFile(jar.toAbsolutePath().toString());
		Enumeration<JarEntry> enumEntries = jarFile.entries();

		while (enumEntries.hasMoreElements()) {
			JarEntry file = (JarEntry) enumEntries.nextElement();
			File f = new File(destPath + File.separator + file.getName());

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

	private Path movePOM(Path dest) throws IOException {
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
			Plugin mdpPlugin = buildMdpPlugin(model.getGroupId(), model.getArtifactId(), model.getVersion());
			model.getBuild().removePlugin(mdpPlugin);
			model.getBuild().addPlugin(mdpPlugin);

			// Step 2: insert build-helper-maven-plugin
			Plugin bhmPlugin = buildBhmPlugin();
			model.getBuild().removePlugin(bhmPlugin);
			model.getBuild().addPlugin(bhmPlugin);

			// Step 3: increase version number for the library
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
	private List<CompilationMessage> runMaven(Path pomFile) throws IOException, InterruptedException {
		List<CompilationMessage> errors = new ArrayList<>();
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

							errors.add(new CompilationMessage(path, line, offset, message, params));
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

	private Plugin buildMdpPlugin(String groupId, String artifactId, String version)
			throws XmlPullParserException, IOException {
		Plugin mdp = new Plugin();
		mdp.setGroupId("org.apache.maven.plugins");
		mdp.setArtifactId("maven-dependency-plugin");
		mdp.setVersion("3.1.1");

		PluginExecution mdpExec = new PluginExecution();
		mdpExec.setId("unpack");
		mdpExec.setPhase("process-sources");
		mdpExec.addGoal("unpack");

		StringBuilder configString = new StringBuilder().append("<configuration><artifactItems><artifactItem>")
				.append("<groupId>" + groupId + "</groupId>").append("<artifactId>" + artifactId + "</artifactId>")
				.append("<version>" + version + "</version>").append("<classifier>sources</classifier>")
				.append("<overWrite>true</overWrite>")
				.append("<outputDirectory>${project.build.directory}/extracted-sources</outputDirectory>")
				.append("</artifactItem></artifactItems></configuration>");

		Xpp3Dom config = Xpp3DomBuilder.build(new StringReader(configString.toString()));
		mdpExec.setConfiguration(config);

		mdp.addExecution(mdpExec);

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
}
