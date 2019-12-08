package org.maracas.groundtruth;

import java.io.PrintWriter;
import java.nio.file.Paths;

import org.rascalmpl.debug.IRascalMonitor;
import org.rascalmpl.interpreter.Evaluator;
import org.rascalmpl.interpreter.NullRascalMonitor;
import org.rascalmpl.interpreter.env.GlobalEnvironment;
import org.rascalmpl.interpreter.env.ModuleEnvironment;
import org.rascalmpl.interpreter.load.StandardLibraryContributor;
import org.rascalmpl.values.ValueFactoryFactory;

import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IValueFactory;

public class GroundtruthCli {

	private IValueFactory vf = ValueFactoryFactory.getValueFactory();
	private Evaluator evaluator = createRascalEvaluator(vf);
	private IRascalMonitor monitor = new NullRascalMonitor();
	
	public static void main(String[] args) {
		if (args.length != 3) {
			System.err.println("Usage: maracas <clientsCsv> <deltasDir> <mavenExec>");
			return;
		}
		
		GroundtruthCli cli = new GroundtruthCli();
		String clientsCsv = args[0];
		String deltasDir = args[1];
		String mavenExec = args[2];
		
		cli.runMavenGroundtruth(clientsCsv, deltasDir, mavenExec);
	}
	
	public void runMavenGroundtruth(String clientsCsv, String deltasDir, String mavenExec) {
		ISourceLocation clientsCsvLoc = vf.sourceLocation(clientsCsv);
		ISourceLocation deltasDirLoc = vf.sourceLocation(deltasDir);
		ISourceLocation mavenExecLoc = vf.sourceLocation(mavenExec);
		
		evaluator.call("runMavenGroundtruth", clientsCsvLoc, deltasDirLoc, mavenExecLoc);
	}
	
	private Evaluator createRascalEvaluator(IValueFactory vf) {
		GlobalEnvironment heap = new GlobalEnvironment();
		ModuleEnvironment module = new ModuleEnvironment("$maracas$", heap);
		PrintWriter stderr = new PrintWriter(System.err);
		PrintWriter stdout = new PrintWriter(System.out);
		Evaluator eval = new Evaluator(vf, stderr, stdout, module, heap);

		eval.addRascalSearchPathContributor(StandardLibraryContributor.getInstance());
		eval.addRascalSearchPath(vf.sourceLocation(Paths.get("src").toAbsolutePath().toString()));
		eval.doImport(monitor, "org::maracas::groundtruth::GroundtruthCli");
		
		return eval;
	}
}
