# Maracas

Maracas is a API migration tool developed at Centrum Winskunde & Informatica by the S.W.A.T. team.
Maracas stands for **M**igrating **AR**caic **A**PIs under certain **CAS**es.

## Dependencies

Maracas depends on:
- `rascal` core library (version 0.11.1-SNAPSHOT unstable) for performing analysis tasks;
- `java-string-similarity` (version 1.1.0) for text comparison; and
- `java-build-manager` (version 0.0.1) for extracting the classpath of Maven and OSGi-based Java projects during M3 models creation. 


## Ready, Set ... 

You can run Maracas from Eclipse.
To this aim you should previously:

1. Install Eclipse RCP and RAP.
2. Install the unstable version of Rascal plugin from its update site `https://update.rascal-mpl.org/unstable`. 
Click [here](https://www.rascal-mpl.org/developers/) for more information.
3. Clone the Rascal `java-build-manager` project from [GitHub](https://github.com/cwi-swat/rascal-java-build-manager) and import it to your workspace.
4. Download the `data` folder to your file system.


## Go!

Once your environment is ready: 

1. Import `maracas` to your workspace.

2. Modify your classpath so it includes the `java-build-manager` project.

3. Run the Rascal REPL. 
That is, right click on `maracas` project and click on **Rascal Console**. 

4. Import the `org::maracas::Maracas` module.
```
import org::maracas::Maracas;
```

5. Define the following **loc** variables in the REPL (don't forget to change the absolute paths of the projects).
```
locApi1 = |file:///Users/your/path/APIMigration/data/MinimalBCs|;
locApi2 = |file:///Users/your/path/APIMigration/data/MinimalBCsNew|;
locClient = |file:///Users/your/path/APIMigration/data/MinimalClient|;
```

6.  Identify the breaking changes introduced between the two versions of the API.
```
classBreakChanges = classBreakingChanges(locApi1, locApi2);
methodBreakChanges = methodBreakingChanges(locApi1, locApi2);
fieldBreakChanges = fieldBreakingChanges(locApi1, locApi2);
```

7. List the changes (detections) that the client needs to consider to migrate its code to the newest version of the API.
```
classDetection = detections(locClient, classBreakChanges);
methodDetection = detections(locClient, methodBreakChanges);
fieldDetection = detections(locClient, fieldBreakChanges);
```
