# Maracas

Maracas is a API migration tool developed at Centrum Winskunde & Informatica by the S.W.A.T. team.
Marcas stands for **M**igrating **AR**caic **A**PIs under certain **CAS**es.

## Dependencies

Maracas depends on `rascal` core library (version 0.11.1-SNAPSHOT unstable) for performing analysis tasks, and on the `java-string-similarity` (version 1.1.0) for text comparison.

## Getting Started

You can run Maracas from Eclipse.
To this aim you should previously:
1. Install Eclipse RCP and RAP.
2. Install the unstable version of Rascal plugin from its update site `https://update.rascal-mpl.org/unstable`. 
Click [here](https://www.rascal-mpl.org/developers/) for more information.
3. Download the `data` folder to your file system.

Once your environment is ready: 
1. Import `maracas` to your workspace.
2. Run the Rascal REPL. 
That is, right click on `maracas` project and click on **Rascal Console**. 
3. Define the following **loc** variables in the REPL (don't forget to change the absolute paths of the projects).
```
locApi1 = |file:///Users/your/path/APIMigration/data/MinimalBCs|;
locApi2 = |file:///Users/your/path/APIMigration/data/MinimalBCsNew|;
locClient = |file:///Users/your/path/APIMigration/data/MinimalClient|;
```

4. Create the **m3** models of the two version of the toy API and the client code that uses it.
```
import lang::java::m3::Core;
modelApi1 = createM3FromDirectory(locApi1);
modelApi2 = createM3FromDirectory(locApi2);
modelClient = createM3FromDirectory(locClient);
```

5. Identify the breaking changes introduced between the two versions of the API.
```
import org::swat::bc::BreakingChanges;
classBreakChanges = createClassBC(modelApi1, modelApi2);
methodBreakChanges = createMethodBC(modelApi1, modelApi2);
```

6. List the changes (detections) that the client needs to consider to migrate its code to the newest version of the API.
```
import org::swat::bc::Detector;
detections(modelClient, classBreakChanges);
detections(modelClient, methodBreakChanges);
```
