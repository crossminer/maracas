module org::maracas::delta::rest::Rest

import org::maracas::delta::JApiCmp;
import org::maracas::m3::Core;
import lang::java::m3::Core;
import Set;
import String;

data BreakingChangeInstance =
	instance(str typ, str decl, str path, int startLine, int endLine, bool source, bool binary)
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
