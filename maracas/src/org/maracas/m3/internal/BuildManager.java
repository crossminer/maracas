package org.maracas.m3.internal;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileVisitOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.maven.model.Build;
import org.apache.maven.model.Model;
import org.apache.maven.model.Plugin;
import org.apache.maven.model.Repository;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.apache.maven.model.io.xpp3.MavenXpp3Writer;
import org.codehaus.plexus.util.xml.pull.XmlPullParserException;
import org.rascalmpl.interpreter.IEvaluatorContext;

/**
 * This code has been extracted from
 * https://github.com/cwi-swat/rascal-java-build-manager
 * 
 * @author Jurgen Vinju, Davy Landman and Ashim Shahi
 */
public class BuildManager {
	
	private static final String MAVEN_CLASSPATH_TXT = "mavenClasspath.txt";
	private final String mavenExecutable;
	private Map<String, String> eclipseRepos = new HashMap<String, String>();
	private IEvaluatorContext ctx;
	
	public BuildManager(String mavenExecutable, IEvaluatorContext ctx) {
		assert mavenExecutable != null;
		this.mavenExecutable = mavenExecutable;
		this.ctx = ctx;
	}
	
	public void addEclipseRepositories(Map<String, String> repos) {
		eclipseRepos.putAll(repos);
	}
	
	/**
	 * Uses maven and Tycho to compute the classpaths of all projects residing the workdirectory
	 * @param workingDirectory
	 * @return
	 * @throws BuildException
	 */
	public Map<File,List<String>> getWorkspaceClasspath(File workingDirectory) throws BuildException {
		if (!pomExists(workingDirectory) && isEclipseProjectRoot(workingDirectory)) {
			generatePOMFile(workingDirectory, mavenExecutable);
		}
		
		if (pomExists(workingDirectory)) {
			return retrieveClasspath(workingDirectory, mavenExecutable);
		}
		else {
			return Collections.emptyMap();
		}
	}

	private boolean pomExists(File workingDirectory) {
		return pomFile(workingDirectory).exists();
	}

	private Map<File, List<String>> retrieveClasspath(File workingDirectory, String maven) throws BuildException {
		try {
			runMaven(workingDirectory, maven, false);
			return readMavenResults(workingDirectory);
		} 
		catch (IOException | InterruptedException e) {
			throw new BuildException("Retrieving classpath from maven failed unexpectedly.", e);
		}
	}

	/**
	 * now we read the magically constructed files and get the classpath information we need
     * first in the current directory, for single repository projects,
	 * then in the nested directory, for multiple repository projects
	 * @param workingDirectory
	 * @return
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	private Map<File, List<String>> readMavenResults(File workingDirectory) throws IOException, FileNotFoundException {
		Map<File,List<String>> result = new HashMap<>();
		
		readClassPathForFolder(workingDirectory, result);
		
		for (File folder : workingDirectory.listFiles()) {
			if (folder.isDirectory()) {
				readClassPathForFolder(folder, result);
			}
		}
		
		return result;
	}

	private void runMaven(File workingDirectory, String MAVEN_EXECUTABLE, boolean compile)
			throws IOException, InterruptedException, BuildException {
		ctx.getStdOut().println("WD: " + workingDirectory.getAbsolutePath());
		// Tycho does its magic here and writes a file into every subdirectory of workDirectory which is a maven project
		ProcessBuilder pb;
		if (compile) {
		    pb = new ProcessBuilder(MAVEN_EXECUTABLE, "compile", "dependency:build-classpath", "-Dmdep.outputFile=" + MAVEN_CLASSPATH_TXT);
		}
		else {
		    pb = new ProcessBuilder(MAVEN_EXECUTABLE, "dependency:build-classpath", "-Dmdep.outputFile=" + MAVEN_CLASSPATH_TXT);
		}
		
		ctx.getStdOut().println("ProcessBuilder initilized.");
		
		pb.directory(workingDirectory);
		//pb.inheritIO();
		
		ctx.getStdOut().println("Starting process.");
		
		Process process = pb.start();
		
		ctx.getStdOut().println("Starting process.");
		process.getErrorStream();

		boolean hadDependencyError = false;
		try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
		    String currentLine;
		    while ((currentLine = reader.readLine()) != null) {
		        if (currentLine.contains("Could not resolve dependencies")) {
		        	ctx.getStdOut().append("Has dependency error.");
		            hadDependencyError = true;
		        }
		        ctx.getStdOut().println(currentLine);
		        System.out.println(currentLine);
		    }
		    reader.close();
		}
		catch (IOException e) {
			ctx.getStdOut().println("BR exception.");
		}
		
		ctx.getStdOut().println("First flag.");
		
		if (process.waitFor() != 0) {
		    if (!compile && hadDependencyError) {
		    	ctx.getStdOut().println("Retrying with compile enabled.");
		        System.err.println("Retrying with compile enabled");
		        // we might be able to solve it with a compile since multi modules maven's tend to be depending on previously build modules
		        runMaven(workingDirectory, MAVEN_EXECUTABLE, true);
		    }
		    else {
		    	ctx.getStdOut().println("Retrieving classpath from maven failed because maven exited with a non-zero exit status.");
		        throw new BuildException("Retrieving classpath from maven failed because maven exited with a non-zero exit status");
		    }
		}
	}

	private void readClassPathForFolder(File folder, Map<File, List<String>> result) throws IOException, FileNotFoundException {
		File file = new File(folder, MAVEN_CLASSPATH_TXT);

		if (file.canRead()) {
		    String contents = new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);
			result.put(folder, Arrays.asList(contents.split(":")));	
		}
	}

	private void generatePOMFile(File workingDirectory, String MAVEN_EXECUTABLE) throws BuildException {
		File pomFile = pomFile(workingDirectory);
		
		if (!pomFile.exists()) {
			try {
				generatePOMwithMaven(workingDirectory, MAVEN_EXECUTABLE);
				rewritePOM(pomFile);
			} 
			catch (IOException | InterruptedException e) {
				throw new BuildException("Could not generate pom.xml file", e);
			}
		}
	}

	private void generatePOMwithMaven(File workingDirectory,
			String MAVEN_EXECUTABLE) throws InterruptedException, IOException,
			BuildException {
		String groupID = workingDirectory.getName();
		ProcessBuilder pb = new ProcessBuilder(MAVEN_EXECUTABLE, "org.eclipse.tycho:tycho-pomgenerator-plugin:generate-poms", "-DgroupId="+groupID);

		pb.directory(workingDirectory);
		pb.inheritIO();
		
		if (pb.start().waitFor() != 0) {
			throw new BuildException("Maven/Tycho generated non-zero exit value while generating pom");
		}
	}

	private File pomFile(File workingDirectory) {
		return new File(workingDirectory, "pom.xml");
	}

	public boolean isEclipseProjectRoot(File workingDirectory) {
		Path startingDir = Paths.get(workingDirectory.getAbsolutePath());
		String pattern = "{.project,.classpath,MANIFEST.MF}";
		
		Finder finder = new Finder(pattern);
		try {
			Set<FileVisitOption> options = Collections.emptySet();
			Files.walkFileTree(startingDir, options, Integer.MAX_VALUE, finder);
		} 
		catch (IOException e) {
			return false;
		}
		
		return finder.done();
	}

	private void rewritePOM(File pomFile) throws BuildException {
		try (Reader reader = new FileReader(pomFile)) {
			MavenXpp3Reader pomReader = new MavenXpp3Reader();
			
			Model model = pomReader.read(reader);
			reader.close();
			
			model.addRepository(createRepo("maven_central", "http://repo.maven.apache.org/maven2/", "default"));
			
			for (String id: eclipseRepos.keySet()) {
				model.addRepository(createRepo(id, eclipseRepos.get(id), "p2"));
			}
			
			Build modelBuild = model.getBuild();
			if (modelBuild == null) {
				model.setBuild(new Build());
			}
			
			model.getBuild().addPlugin(createPlugin("org.eclipse.tycho", "tycho-maven-plugin", "0.21.0", true));
			model.getBuild().addPlugin(createPlugin("org.eclipse.tycho", "target-platform-configuration", "0.21.0", false));
			model.getBuild().addPlugin(createPlugin("org.apache.maven.plugins", "maven-dependency-plugin", "2.8", false));
			
			MavenXpp3Writer pomWriter = new MavenXpp3Writer();
			pomWriter.write(new FileWriter(pomFile), model);
		} 
		catch (IOException | XmlPullParserException e) {
			throw new BuildException("POM rewriting (to add plugin dependencies, cause) failed unexpectedly", e);
		}
	}

	private Plugin createPlugin(String groupId, String artifactId, String version, boolean extension) {
		Plugin plugin = new Plugin();
		plugin.setGroupId(groupId);
		plugin.setArtifactId(artifactId);
		plugin.setVersion(version);
		
		if (extension) {
			plugin.setExtensions(true);
		}
		
		return plugin;
	}

	private Repository createRepo(String id, String url, String layout) {
		Repository repo = new Repository();
		repo.setId(id);
		repo.setUrl(url);
		repo.setLayout(layout);
		return repo;
	}
}
