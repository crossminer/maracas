package org.maracas.test.delta.japicmp.delta.internal;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.rascalmpl.interpreter.IEvaluatorContext;

import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IListWriter;
import io.usethesource.vallang.IMap;
import io.usethesource.vallang.IMapWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import japicmp.cli.JApiCli.ClassPathMode;
import japicmp.cmp.JApiCmpArchive;
import japicmp.cmp.JarArchiveComparator;
import japicmp.cmp.JarArchiveComparatorOptions;
import japicmp.config.Options;
import japicmp.model.AccessModifier;
import japicmp.model.JApiClass;
import japicmp.model.JApiCompatibilityChange;
import japicmp.output.OutputFilter;
import japicmp.util.Optional;

public class JApiCmpResults {
	
	private final IValueFactory valueFactory;
	private final Map<String, IString> maracasChanges;
	
	public JApiCmpResults(IValueFactory valueFactory) {
		this.valueFactory = valueFactory;
		this.maracasChanges = initMaracasChanges();
	}
	
	// Crappy code. Replace with proper translation.
	private final Map<String, IString> initMaracasChanges() {
		HashMap<String, IString> changes = new HashMap<String, IString>();
		changes.put(JApiCompatibilityChange.ANNOTATION_DEPRECATED_ADDED.name(), valueFactory.string("annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true)"));
		changes.put(JApiCompatibilityChange.CLASS_LESS_ACCESSIBLE.name(), valueFactory.string("classLessAccessible(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CLASS_NO_LONGER_PUBLIC.name(), valueFactory.string("classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CLASS_NOW_ABSTRACT.name(), valueFactory.string("classNowAbstract(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CLASS_NOW_CHECKED_EXCEPTION.name(), valueFactory.string("classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CLASS_NOW_FINAL.name(), valueFactory.string("classNowFinal(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CLASS_REMOVED.name(), valueFactory.string("classRemoved(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CLASS_TYPE_CHANGED.name(), valueFactory.string("classTypeChanged(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CONSTRUCTOR_LESS_ACCESSIBLE.name(), valueFactory.string("constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.CONSTRUCTOR_REMOVED.name(), valueFactory.string("constructorRemoved(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_LESS_ACCESSIBLE.name(), valueFactory.string("fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_LESS_ACCESSIBLE_THAN_IN_SUPERCLASS.name(), valueFactory.string("fieldLessAccessibleThanInSuperclass(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_MORE_ACCESSIBLE.name(), valueFactory.string("fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_NO_LONGER_STATIC.name(), valueFactory.string("fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_NOW_FINAL.name(), valueFactory.string("fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_NOW_STATIC.name(), valueFactory.string("fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_REMOVED.name(), valueFactory.string("methodRemoved(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_REMOVED_IN_SUPERCLASS.name(), valueFactory.string("fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_STATIC_AND_OVERRIDES_STATIC.name(), valueFactory.string("fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.FIELD_TYPE_CHANGED.name(), valueFactory.string("fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.INTERFACE_ADDED.name(), valueFactory.string("interfaceAdded(binaryCompatibility=true,sourceCompatibility=true)"));
		changes.put(JApiCompatibilityChange.INTERFACE_REMOVED.name(), valueFactory.string("interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_ABSTRACT_ADDED_IN_IMPLEMENTED_INTERFACE.name(), valueFactory.string("methodAbstractAddedInImplementedInterface(binaryCompatibility=true,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_ABSTRACT_ADDED_IN_SUPERCLASS.name(), valueFactory.string("methodAbstractAddedInSuperclass(binaryCompatibility=true,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_ABSTRACT_ADDED_TO_CLASS.name(), valueFactory.string("methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_ABSTRACT_NOW_DEFAULT.name(), valueFactory.string("methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_ADDED_TO_INTERFACE.name(), valueFactory.string("methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_ADDED_TO_PUBLIC_CLASS.name(), valueFactory.string("methodAddedToPublicClass(binaryCompatibility=true,sourceCompatibility=true)"));
		changes.put(JApiCompatibilityChange.METHOD_IS_STATIC_AND_OVERRIDES_NOT_STATIC.name(), valueFactory.string("methodIsStaticAndOverridesNotStatic(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_LESS_ACCESSIBLE.name(), valueFactory.string("methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_LESS_ACCESSIBLE_THAN_IN_SUPERCLASS.name(), valueFactory.string("methodLessAccessibleThanInSuperclass(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_MORE_ACCESSIBLE.name(), valueFactory.string("methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_NEW_DEFAULT.name(), valueFactory.string("methodNewDefault(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_NO_LONGER_STATIC.name(), valueFactory.string("methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_NOW_ABSTRACT.name(), valueFactory.string("methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_NOW_FINAL.name(), valueFactory.string("methodNowFinal(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_NOW_STATIC.name(), valueFactory.string("methodNowStatic(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_NOW_THROWS_CHECKED_EXCEPTION.name(), valueFactory.string("methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_REMOVED.name(), valueFactory.string("methodRemoved(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_REMOVED_IN_SUPERCLASS.name(), valueFactory.string("methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.METHOD_RETURN_TYPE_CHANGED.name(), valueFactory.string("methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.SUPERCLASS_ADDED.name(), valueFactory.string("superclassAdded(binaryCompatibility=true,sourceCompatibility=true)"));
		changes.put(JApiCompatibilityChange.SUPERCLASS_MODIFIED_INCOMPATIBLE.name(), valueFactory.string("superclassModifiedIncompatible(binaryCompatibility=false,sourceCompatibility=false)"));
		changes.put(JApiCompatibilityChange.SUPERCLASS_REMOVED.name(), valueFactory.string("superclassRemoved(binaryCompatibility=false,sourceCompatibility=false)"));
		return changes;
	}
	
	private List<JApiClass> compare(String apiOld, String apiNew, IEvaluatorContext eval) {
		Options defaultOptions = getDefaultOptions();

		JarArchiveComparatorOptions options = JarArchiveComparatorOptions.of(defaultOptions);
		JarArchiveComparator comparator = new JarArchiveComparator(options);
		
		JApiCmpArchive oldAPI = new JApiCmpArchive(new File(apiOld), "0.0");
		JApiCmpArchive newAPI = new JApiCmpArchive(new File(apiNew), "1.0");
		
		List<JApiClass> delta = comparator.compare(oldAPI, newAPI);
		OutputFilter filter = new OutputFilter(defaultOptions);
		filter.filter(delta);
		
		return delta;
	}
	
	private Options getDefaultOptions() {
		Options defaultOptions = Options.newDefault();
		defaultOptions.setAccessModifier(AccessModifier.PROTECTED);
		defaultOptions.setOutputOnlyModifications(true);
		defaultOptions.setClassPathMode(ClassPathMode.TWO_SEPARATE_CLASSPATHS);
		defaultOptions.setIgnoreMissingClasses(true);
		
		String[] excl = { "(*.)?tests(.*)?", "(*.)?test(.*)?", 
				"@org.junit.After",
				"@org.junit.AfterClass",
				"@org.junit.Before",
				"@org.junit.BeforeClass",
				"@org.junit.Ignore",
				"@org.junit.Test",
				"@org.junit.runner.RunWith" };
		
		for (String e : excl) {
			defaultOptions.addExcludeFromArgument(Optional.of(e), false);
		}
		
		return defaultOptions;
	}
	
	
	public IInteger getNumClasses(IString apiOld, IString apiNew, IEvaluatorContext eval) {
		List<JApiClass> delta = compare(apiOld.getValue(), apiNew.getValue(), eval);
		return valueFactory.integer(delta.size());
	}
	
	// Crappy code. Replace with proper translation
	public IMap getChangesPerClassJApi(IString apiOld, IString apiNew, IEvaluatorContext eval) {
		List<JApiClass> delta = compare(apiOld.getValue(), apiNew.getValue(), eval);
		IMapWriter mw = valueFactory.mapWriter();
		
		delta.forEach(c -> {
			IString name = valueFactory.string("/" + c.getFullyQualifiedName().replace(".", "/"));
			IListWriter lw = valueFactory.listWriter();
			c.getCompatibilityChanges().forEach(cc -> lw.append(maracasChanges.get(cc.name())));
			IList changes = lw.done();
			
			mw.put(name, changes);
		});
		
		return mw.done();
	}
	
	public static void main(String[] args) {
		Options defaultOptions = Options.newDefault();
		defaultOptions.setAccessModifier(AccessModifier.PACKAGE_PROTECTED);
		defaultOptions.setOutputOnlyModifications(true);
		defaultOptions.setClassPathMode(ClassPathMode.TWO_SEPARATE_CLASSPATHS);
		defaultOptions.setIgnoreMissingClasses(true);

		JarArchiveComparatorOptions options = JarArchiveComparatorOptions.of(defaultOptions);
		JarArchiveComparator comparator = new JarArchiveComparator(options);
		
		JApiCmpArchive oldAPI = new JApiCmpArchive(new File("/Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-old.jar"), "0.0");
		JApiCmpArchive newAPI = new JApiCmpArchive(new File("/Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-new.jar"), "1.0");
		
		List<JApiClass> delta = comparator.compare(oldAPI, newAPI);
		OutputFilter filter = new OutputFilter(defaultOptions);
		filter.filter(delta);
	}
}
