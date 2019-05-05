package org.maracas;

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

public class Maracas {
	private IValueFactory vf = ValueFactoryFactory.getValueFactory();
	private Evaluator evaluator = createRascalEvaluator(vf);
	private IRascalMonitor mon = new NullRascalMonitor();

	public void runAll(String libPath1, String libPath2, String clients, String report) {
		ISourceLocation loc1 = vf.sourceLocation(libPath1);
		ISourceLocation loc2 = vf.sourceLocation(libPath2);
		ISourceLocation locClients = vf.sourceLocation(clients);
		ISourceLocation locReport = vf.sourceLocation(report);

		evaluator.call("runAll", loc1, loc2, locClients, locReport, vf.bool(true), vf.bool(true));
	}

	private Evaluator createRascalEvaluator(IValueFactory vf) {
		GlobalEnvironment heap = new GlobalEnvironment();
		ModuleEnvironment module = new ModuleEnvironment("$maracas$", heap);
		PrintWriter stderr = new PrintWriter(System.err);
		PrintWriter stdout = new PrintWriter(System.out);
		Evaluator eval = new Evaluator(vf, stderr, stdout, module, heap);

		eval.addRascalSearchPathContributor(StandardLibraryContributor.getInstance());
		eval.addRascalSearchPath(vf.sourceLocation(Paths.get("src").toAbsolutePath().toString()));
		eval.doImport(mon, "org::maracas::RunAll");
		eval.doImport(mon, "org::maracas::Maracas");
		eval.doImport(mon, "org::maracas::bc::vis::Visualizer");

		return eval;
	}
}
