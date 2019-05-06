# Maracas

Maracas is an API migration tool developed at Centrum Winskunde & Informatica by the SWAT team.
Maracas stands for **M**igrating **AR**caic **A**PIs under certain **CAS**es.

## Dependencies

Maracas depends on:
  -  [Rascal](https://github.com/usethesource/rascal) to parse and analyse source code and byte code (version 0.12.0-SNAPSHOT and up, get it from [this Eclipse update site](https:// https://update.rascal-mpl.org/unstable/))
  - `java-string-similarity` (version 1.1.0) for text comparison; and
  - `java-build-manager` (version 0.0.1) for extracting the classpath of Maven and OSGi-based Java projects during M3 models creation (get it from [here](https://github.com/cwi-swat/rascal-java-build-manager)).

## Running Maracas in Eclipse

### Ready, Set ... 

1. Install Eclipse RCP and RAP.
2. Install the unstable version of Rascal plugin from its update site `https://update.rascal-mpl.org/unstable`. 
Click [here](https://www.rascal-mpl.org/developers/) for more information.
3. Clone the Rascal project `java-build-manager` from [here](https://github.com/cwi-swat/rascal-java-build-manager) and import it into your workspace.

### Go!

Once your environment is ready: 

1. Import `maracas` to your workspace.

2. Include the project `java-build-manager` in your project's classpath.

3. Run the Rascal REPL. That is, right click on `maracas` and select **Rascal Console**. 

4. In the REPL (`>` denotes the REPL prompt):

    1. Import the `org::maracas::Maracas` module:
    ```import org::maracas::Maracas;```

    2. Define the following **loc** variables in the REPL (don't forget to change the absolute paths of the projects):
    ```
    > locApi1 = |file:///Users/your/path/myjar-0.1.0.jar|;
    > locApi2 = |file:///Users/your/path/myjar-0.2.0.jar|;
    > locClient = |file:///Users/your/path/client-of-myjar-0.1.0.jar|;
    ```

    3.  Build the breaking changes model between the two versions of the API.
    ```
    > cbc = classBreakingChanges(locApi1, locApi2);
    > mbc = methodBreakingChanges(locApi1, locApi2);
    > fbc = fieldBreakingChanges(locApi1, locApi2);
    ```

    4. List the changes (detections) that the client needs to consider to migrate its code to the newest version of the API.
    ```
    > classDetection = detections(locClient, cbc);
    > methodDetection = detections(locClient, mbc);
    > fieldDetection = detections(locClient, fbc);
    ```
    
    5. Optionally, output user-friendly breaking changes model in HTML:
    ```
    > import org::maracas::bc::vis::Visualizer;
    > writeHtml(|file:///Users/your/path/ClassBreakingChanges.html|, cbc);
    > writeHtml(|file:///Users/your/path/MethodBreakingChanges.html|, mbc);
    > writeHtml(|file:///Users/your/path/FieldBreakingChanges.html|, fbc);
    ```

## Running Maracas from plain Java

Alternatively, Maracas can be manipulated through a basic API.
See [Maracas.java](https://github.com/crossminer/maracas/blob/master/maracas/src/org/maracas/Maracas.java) for more details.
