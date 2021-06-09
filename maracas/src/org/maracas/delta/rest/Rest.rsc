module org::maracas::delta::rest::Rest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::m3::Core;
import lang::java::m3::Core;
import Set;
import String;

data BreakingChangeInstance =
	instance(str typ, str decl, str path, int startLine, int endLine, bool source, bool binary)
	;

data BreakingChangeDetection =
	detection(str elem, str used, str src, str apiUse)
	;

// Easy endpoint for the REST API
list[BreakingChangeInstance] bcInstances(loc jar1Loc, loc jar2Loc, loc sourcesLoc) {
	list[APIEntity] delta = compareJars(jar1Loc, jar2Loc, "v1", "v2");
	M3 sources = createM3FromDirectory(sourcesLoc);
	
	list[BreakingChangeInstance] ret = [];
	for (<bc, decl> <- getChangedEntities(delta)) {
		if (bc.sourceCompatibility && bc.binaryCompatibility)
			continue;
			
		loc srcLoc = jarLocToSourceLoc(decl);
		set[loc] found = sources.declarations[srcLoc];
		int beginLine = -1;
		int endLine = -1;
		if (size(found) > 0) {
			srcLoc = getOneFrom(found);
			beginLine = srcLoc.begin.line;
			endLine = srcLoc.end.line;
		}
		
		ret += instance(
			bcName(bc),
			sourceLocationToJavaSignature(decl),
			srcLoc.path,
			beginLine,
			endLine,
			bc.sourceCompatibility,
			bc.binaryCompatibility);
	}
	
	return ret;
}

list[BreakingChangeDetection] detections(loc jar1Loc, loc jar2Loc, loc clientLoc, loc sourcesLoc) {
	list[APIEntity] delta = compareJars(jar1Loc, jar2Loc, "v1", "v2");
	M3 m3V1 = createM3(jar1Loc);
	M3 m3V2 = createM3(jar2Loc);
	M3 m3Client = createM3(clientLoc);
	set[Detection] ds = computeDetections(m3Client, m3V1, m3V2, delta);

	list[BreakingChangeDetection] res = [];
	for (Detection d <- ds) {
		res += detection(
			sourceLocationToJavaSignature(d.elem),
			sourceLocationToJavaSignature(d.used),
			sourceLocationToJavaSignature(d.src),
			apiUseName(d.use));
	}
	
	return res;
}

str apiUseName(APIUse::methodInvocation()) = "methodInvocation";
str apiUseName(APIUse::methodOverride()) = "methodOverride";
str apiUseName(APIUse::fieldAccess()) = "fieldAccess";
str apiUseName(APIUse::extends()) = "extends";
str apiUseName(APIUse::implements()) = "implements";
str apiUseName(APIUse::annotation()) = "annotation";
str apiUseName(APIUse::typeDependency()) = "typeDependency";
str apiUseName(APIUse::declaration()) = "declaration"; 

str bcName(CompatibilityChange::annotationDeprecatedAdded()) = "annotationDeprecatedAdded";
str bcName(CompatibilityChange::classRemoved()) = "classRemoved";
str bcName(CompatibilityChange::classNowAbstract()) = "classNowAbstract";
str bcName(CompatibilityChange::classNowFinal()) = "classNowFinal";
str bcName(CompatibilityChange::classNoLongerPublic()) = "classNoLongerPublic";
str bcName(CompatibilityChange::classTypeChanged()) = "classTypeChanged";
str bcName(CompatibilityChange::classNowCheckedException()) = "classNowCheckedException";
str bcName(CompatibilityChange::classLessAccessible()) = "classLessAccessible";
str bcName(CompatibilityChange::superclassRemoved()) = "superclassRemoved";
str bcName(CompatibilityChange::superclassAdded()) = "superclassAdded";
str bcName(CompatibilityChange::superclassModifiedIncompatible()) = "superclassModifiedIncompatible";
str bcName(CompatibilityChange::interfaceAdded()) = "interfaceAdded";
str bcName(CompatibilityChange::interfaceRemoved()) = "interfaceRemoved";
str bcName(CompatibilityChange::methodAbstractAddedInImplementedInterface()) = "methodAbstractAddedInImplementedInterface";
str bcName(CompatibilityChange::methodAbstractAddedInSuperclass()) = "methodAbstractAddedInSuperclass";
str bcName(CompatibilityChange::methodAbstractAddedToClass()) = "methodAbstractAddedToClass";
str bcName(CompatibilityChange::methodAbstractNowDefault()) = "methodAbstractNowDefault";
str bcName(CompatibilityChange::methodAddedToInterface()) = "methodAddedToInterface";
str bcName(CompatibilityChange::methodAddedToPublicClass()) = "methodAddedToPublicClass";
str bcName(CompatibilityChange::methodIsStaticAndOverridesNotStatic()) = "methodIsStaticAndOverridesNotStatic";
str bcName(CompatibilityChange::methodLessAccessible()) = "methodLessAccessible";
str bcName(CompatibilityChange::methodLessAccessibleThanInSuperclass()) = "methodLessAccessibleThanInSuperclass";
str bcName(CompatibilityChange::methodMoreAccessible()) = "methodMoreAccessible";
str bcName(CompatibilityChange::methodNewDefault()) = "methodNewDefault";
str bcName(CompatibilityChange::methodNoLongerStatic()) = "methodNoLongerStatic";
str bcName(CompatibilityChange::methodNoLongerThrowsCheckedException()) = "methodNoLongerThrowsCheckedException";
str bcName(CompatibilityChange::methodNowAbstract()) = "methodNowAbstract";
str bcName(CompatibilityChange::methodNowFinal()) = "methodNowFinal";
str bcName(CompatibilityChange::methodNowStatic()) = "methodNowStatic";
str bcName(CompatibilityChange::methodNowThrowsCheckedException()) = "methodNowThrowsCheckedException";
str bcName(CompatibilityChange::methodRemoved()) = "methodRemoved";
str bcName(CompatibilityChange::methodRemovedInSuperclass()) = "methodRemovedInSuperclass";
str bcName(CompatibilityChange::methodReturnTypeChanged()) = "methodReturnTypeChanged";
str bcName(CompatibilityChange::fieldLessAccessible()) = "fieldLessAccessible";
str bcName(CompatibilityChange::fieldLessAccessibleThanInSuperclass()) = "fieldLessAccessibleThanInSuperclass";
str bcName(CompatibilityChange::fieldMoreAccessible()) = "fieldMoreAccessible";
str bcName(CompatibilityChange::fieldNoLongerStatic()) = "fieldNoLongerStatic";
str bcName(CompatibilityChange::fieldNowFinal()) = "fieldNowFinal";
str bcName(CompatibilityChange::fieldNowStatic()) = "fieldNowStatic";
str bcName(CompatibilityChange::fieldRemoved()) = "fieldRemoved";
str bcName(CompatibilityChange::fieldRemovedInSuperclass()) = "fieldRemovedInSuperclass";
str bcName(CompatibilityChange::fieldStaticAndOverridesStatic()) = "fieldStaticAndOverridesStatic";
str bcName(CompatibilityChange::fieldTypeChanged()) = "fieldTypeChanged";
str bcName(CompatibilityChange::constructorRemoved()) = "constructorRemoved";
str bcName(CompatibilityChange::constructorLessAccessible()) = "constructorLessAccessible";

str sourceLocationToJavaSignature(loc l) {
	return substring(replaceAll(l.path, "/", "."), 1);
}
