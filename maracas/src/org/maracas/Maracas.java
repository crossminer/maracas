package org.maracas;

import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.maracas.data.Detection;
import org.rascalmpl.debug.IRascalMonitor;
import org.rascalmpl.interpreter.Evaluator;
import org.rascalmpl.interpreter.NullRascalMonitor;
import org.rascalmpl.interpreter.env.GlobalEnvironment;
import org.rascalmpl.interpreter.env.ModuleEnvironment;
import org.rascalmpl.interpreter.load.StandardLibraryContributor;
import org.rascalmpl.values.ValueFactoryFactory;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import io.usethesource.vallang.IBool;
import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.ISet;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.ITuple;
import io.usethesource.vallang.IValueFactory;

public class Maracas {
	private IValueFactory vf = ValueFactoryFactory.getValueFactory();
	private Evaluator evaluator = createRascalEvaluator(vf);
	private IRascalMonitor mon = new NullRascalMonitor();

	/**
	 * Run the full Maracas pipeline (build M3 models -> build Delta model
	 * -> build Detections model), cf. RunAll.rsc. Output of the analysis is
	 * serialized in {@code report}.
	 * 
	 * @param libPath1 Absolute path to the JAR of the 1st version of the library
	 * @param libPath2 Absolute path to the JAR of the 2nd version of the library
	 * @param clients  Absolute path to the directory containing all clients of
	 *                 libPath1
	 * @param report   Absolute path to the output directory where analysis results
	 *                 are serialized
	 */
	public void runAll(String libPath1, String libPath2, String clients, String report) {
		ISourceLocation loc1 = vf.sourceLocation(libPath1);
		ISourceLocation loc2 = vf.sourceLocation(libPath2);
		ISourceLocation locClients = vf.sourceLocation(clients);
		ISourceLocation locReport = vf.sourceLocation(report);

		evaluator.call("runAll", loc1, loc2, locClients, locReport, vf.bool(true), vf.bool(true));
	}

	/**
	 * Parses the analysis results to map to each client JAR of a library its
	 * detection models
	 * 
	 * @param Absolute path to the output directory where analysis results of
	 *        {@code runAll} were serialized.
	 * @return A Multimap associating to each client JAR the detections that were
	 *         found
	 */
	public Multimap<String, Detection> parseDetections(String report) {
		Multimap<String, Detection> result = ArrayListMultimap.create();
		ISourceLocation locReport = vf.sourceLocation(report);

		ISet allDetections = (ISet) evaluator.call("parseDetectionFiles", locReport);
		allDetections.forEach(e -> {
			// tuple[str, set[Detection]]
			ITuple t = (ITuple) e;
			String jar = ((IString) t.get(0)).toString();
			ISet detections = (ISet) t.get(1);

			detections.forEach(d -> {
				result.put(jar, Detection.fromRascalDetection((IConstructor) d));
			});
		});

		return result;
	}
	
	/**
	 * The method computes a M3 model from a JAR file and stores the model in a given 
	 * path.
	 * 
	 * @param pathJar: absolute path to the JAR file of the project
	 * @param pathM3: absolute path to the file where the M3 model should be stored 
	 *        (including the name of the file and its extension --.m3--)
	 * @return true if the M3 model was correctly computed and stored in the given 
	 *         location; false otherwise
	 */
	public boolean storeM3(String pathJar, String pathM3) {
		ISourceLocation locJar = vf.sourceLocation(pathJar);
		ISourceLocation locM3 = vf.sourceLocation(pathM3);
		
		IBool store = (IBool) evaluator.call("storeM3", locJar, locM3);
		return store.getValue();
	}

	/**
	 * The method computes a Delta model between the old and new M3 models of a 
	 * library. Then, it stores the model in a given path.
	 * 
	 * @param pathM3OldAPI: absolute path to the M3 model of the library old version
	 * @param pathM3NewAPI: absolute path to the M3 model of the library new version
	 * @param pathDelta: absolute path to the file where the Delta model should be 
	 *        stored (including the name of the file and its extension --.delta--)
	 * @return true if the Delta model was correctly computed and stored in the 
	 *         given location; false otherwise
	 */
	public boolean storeDelta(String pathM3OldAPI, String pathM3NewAPI, String pathDelta) {
		ISourceLocation locM3OldAPI = vf.sourceLocation(pathM3OldAPI);
		ISourceLocation locM3NewAPI = vf.sourceLocation(pathM3NewAPI);
		ISourceLocation locDelta = vf.sourceLocation(pathDelta);
		
		IBool store = (IBool) evaluator.call("storeDelta", locM3OldAPI, locM3NewAPI, locDelta);
		return store.getValue();
	}
	
	/**
	 * The method returns a list of Detections from a client M3 model and a library 
	 * Delta model.
	 * 
	 * @param pathM3Client: absolute path to the M3 model of a client project
	 * @param pathDelta: absolute path to the file where of the library Delta model
	 * @return list of Detections
	 */
	public List<Detection> getDetections(String pathM3Client, String pathDelta) {
		ISourceLocation locM3Client = vf.sourceLocation(pathM3Client);
		ISourceLocation locDelta = vf.sourceLocation(pathDelta);
		List<Detection> detections = new ArrayList<Detection>();
		
		ISet allDetections = (ISet) evaluator.call("getDetections", locM3Client, locDelta);
		allDetections.forEach(d -> {
			detections.add(Detection.fromRascalDetection((IConstructor) d));
		});
		return detections;
	}
	
	public static void main(String[] args) {
		if (args.length != 4) {
			System.err.println("Usage: maracas <lib1Jar> <lib2Jar> <clientsPath> <reportPath>");
			return;
		}

		Maracas m = new Maracas();
		String lib1 = args[0];
		String lib2 = args[1];
		String clients = args[2];
		String report = args[3];

		// Build BreakingChanges/Detections models in 'report'
		m.runAll(lib1, lib2, clients, report);

		// Parse the Detections models and build the Multimap
		Multimap<String, Detection> detections = m.parseDetections(report + "/detection");
		System.out.println(detections.size() + " usages found.");

		// Example usage: list usages of @Deprecated methods
		for (String client : detections.keySet()) {
			Collection<Detection> clientDetections = detections.get(client);

			clientDetections.stream().filter(d -> d.getType().equals(Detection.Type.DEPRECATED)).forEach(d -> {
				System.out.println(String.format("%s uses method %s which has been deprecated", d.getClientLocation(),
						d.getOldLibraryLocation()));
			});
		}
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
		
		return eval;
	}
}
