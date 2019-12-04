package org.maracas.m3.internal;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.rascalmpl.interpreter.IEvaluatorContext;

import io.usethesource.vallang.IListWriter;
import io.usethesource.vallang.IMap;
import io.usethesource.vallang.IMapWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;

/**
 * This code has been extracted from
 * https://github.com/cwi-swat/rascal-java-build-manager
 * 
 * @author Jurgen Vinju and Michael Steindorfer
 */
public class ClassPaths {
	private final IValueFactory vf;
	
	public ClassPaths(IValueFactory vf) {
		this.vf = vf;
	}
	
	public IMap getClassPath(ISourceLocation directory, IMap dependencyUpdateSites, ISourceLocation mavenExecutable, 
			IEvaluatorContext ctx) throws UnsupportedOperationException, BuildException {
		assert directory.getScheme().equals("file");
		assert mavenExecutable.getScheme().equals("file");

		BuildManager bmw = new BuildManager(mavenExecutable.getPath(), ctx);
		HashMap<String, String> dependencies = new HashMap<String, String>();

		for (IValue id: dependencyUpdateSites) {
			dependencies.put(((IString) id).getValue(), ((ISourceLocation) dependencyUpdateSites.get(id)).getURI().toString());
		}

		bmw.addEclipseRepositories(dependencies);

		Map<File, List<String>> workspaceClasspath = bmw.getWorkspaceClasspath(new File(directory.getPath()));

		IMapWriter mw = vf.mapWriter();
		for (Entry<File, List<String>> e : workspaceClasspath.entrySet()) {
			IListWriter list = vf.listWriter();

			for (String jar : e.getValue()) {
				list.append(vf.sourceLocation(jar));
			}

			mw.put(vf.sourceLocation(e.getKey().getAbsolutePath()), list.done());
		}

		return mw.done();
	}
}
