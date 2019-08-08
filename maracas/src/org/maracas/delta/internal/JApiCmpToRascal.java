package org.maracas.delta.internal;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.interpreter.env.ModuleEnvironment;
import org.rascalmpl.library.lang.java.m3.internal.LimitedTypeStore;
import org.rascalmpl.library.lang.java.m3.internal.TypeStoreWrapper;
import org.rascalmpl.values.ValueFactoryFactory;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IListWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.TypeStore;
import japicmp.cmp.JApiCmpArchive;
import japicmp.cmp.JarArchiveComparator;
import japicmp.cmp.JarArchiveComparatorOptions;
import japicmp.model.AbstractModifier;
import japicmp.model.AccessModifier;
import japicmp.model.BridgeModifier;
import japicmp.model.FinalModifier;
import japicmp.model.JApiChangeStatus;
import japicmp.model.JApiClass;
import japicmp.model.JApiClassType;
import japicmp.model.JApiModifier;
import japicmp.model.JApiModifierBase;
import japicmp.model.StaticModifier;
import japicmp.model.SyntheticModifier;
import javassist.CtClass;

public class JApiCmpToRascal {

	private final TypeStore typeStore;
	private final IValueFactory valueFactory;
	private JApiCmpBuilder builder;
	private Map<String, IConstructor> modifiers;
	
	public JApiCmpToRascal(TypeStore typeStore, IValueFactory valueFactory) {
		this.typeStore = typeStore;
		this.valueFactory = valueFactory;
		this.builder = new JApiCmpSimpleBuilder(typeStore, valueFactory);
		initializeModifiers();
	}
	
	private void initializeModifiers() {
		this.modifiers = new HashMap<String, IConstructor>();
		this.modifiers.put(AbstractModifier.ABSTRACT.name(), builder.buildModifierAbstractCons());
		this.modifiers.put(AbstractModifier.NON_ABSTRACT.name(), builder.buildModifierNonAbstractCons());
		this.modifiers.put(BridgeModifier.BRIDGE.name(), builder.buildModifierBridgeCons());
		this.modifiers.put(BridgeModifier.NON_BRIDGE.name(), builder.buildModifierNonBridgeCons());
		this.modifiers.put(FinalModifier.FINAL.name(), builder.buildModifierFinalCons());
		this.modifiers.put(FinalModifier.NON_FINAL.name(), builder.buildModifierNonFinalCons());
		this.modifiers.put(AccessModifier.PRIVATE.name(), builder.buildModifierPrivateCons());
		this.modifiers.put(AccessModifier.PUBLIC.name(), builder.buildModifierPublicCons());
		this.modifiers.put(AccessModifier.PROTECTED.name(), builder.buildModifierProtectedCons());
		this.modifiers.put(AccessModifier.PACKAGE_PROTECTED.name(), builder.buildModifierPackageProtectedCons());
		this.modifiers.put(StaticModifier.STATIC.name(), builder.buildModifierStaticCons());
		this.modifiers.put(StaticModifier.NON_STATIC.name(), builder.buildModifierNonStaticCons());
		this.modifiers.put(SyntheticModifier.SYNTHETIC.name(), builder.buildModifierSyntheticCons());
		this.modifiers.put(SyntheticModifier.NON_SYNTHETIC.name(), builder.buildModifierNonSyntheticCons());
	}
	
	public IList compare(ISourceLocation oldJar, ISourceLocation newJar, IString oldVersion, IString newVersion) {
		JarArchiveComparatorOptions options = new JarArchiveComparatorOptions();
		JarArchiveComparator comparator = new JarArchiveComparator(options);
		
		JApiCmpArchive oldAPI = new JApiCmpArchive(sourceLocationToFile(oldJar), oldVersion.getValue());
		JApiCmpArchive newAPI = new JApiCmpArchive(sourceLocationToFile(oldJar), newVersion.getValue());
		
		IListWriter result = valueFactory.listWriter();
		List<JApiClass> classes = comparator.compare(oldAPI, newAPI);
		classes.forEach(c -> {
			result.append(translate(c, builder));
		});
		return result.done();
	}
	
	private IValue translate(JApiClass clas, JApiCmpBuilder builder) {
		IString fullyQualifiedName = valueFactory.string(clas.getFullyQualifiedName());
		IConstructor classType = translate(clas.getClassType(), builder);
		
		IListWriter entities = valueFactory.listWriter();
		entities.append(translate(clas.getAbstractModifier(), builder));
		entities.append(translate(clas.getAccessModifier(), builder));
		entities.append(translate(clas.getFinalModifier(), builder));
		entities.append(translate(clas.getStaticModifier(), builder));
		entities.append(translate(clas.getSyntheticModifier(), builder));
		
		IListWriter compatibilityChanges = valueFactory.listWriter();
		
		JApiChange japiChange = new JApiChange(clas.getOldClass().get(), clas.getNewClass().get(), clas.getChangeStatus());
		IConstructor apiChange = translate(japiChange, builder);
				
		return builder.buildApiEntityClassCons(fullyQualifiedName, classType, entities.done(), compatibilityChanges.done(), apiChange);
	}

	private <T extends JApiModifierBase> IValue translate(JApiModifier<T> modifier, JApiCmpBuilder builder) {
		JApiChangeStatus changeStatus = modifier.getChangeStatus();
		IConstructor oldModifier = modifiers.get(modifier.getValueOld());
		IConstructor newModifier = modifiers.get(modifier.getValueNew());
		
		switch (changeStatus) {
		case MODIFIED: 
			return builder.buildApiChangeModifiedCons(builder.getModifierType(), oldModifier, newModifier);
		case NEW:
			return builder.buildApiChangeNewCons(builder.getModifierType(), newModifier);
		case REMOVED:
			return builder.buildApiChangeRemovedCons(builder.getModifierType(), oldModifier);
		case UNCHANGED:
			return builder.buildApiChangeUnchangedCons();
		default:
			throw new RuntimeException("The change status is not supported.");
		}
	}

	private IConstructor translate(JApiClassType classType, JApiCmpBuilder builder) {
		// TODO Auto-generated method stub
		return null;
	}

	private IConstructor translate(JApiChange apiChange, JApiCmpBuilder builder) {
		// TODO Auto-generated method stub
		return null;
	}
	
	private File sourceLocationToFile(ISourceLocation loc) {
		String path = loc.getPath();
		return new File(path);
	}
	
	public class JApiChange {
		private final CtClass oldClass;
		private final CtClass newClass;
		private final JApiChangeStatus changeStatus;
		
		public JApiChange(CtClass oldClass, CtClass newClass, JApiChangeStatus changeStatus) {
			this.oldClass = oldClass;
			this.newClass = newClass;
			this.changeStatus = changeStatus;
		}

		public CtClass getOldClass() {
			return oldClass;
		}

		public CtClass getNewClass() {
			return newClass;
		}

		public JApiChangeStatus getChangeStatus() {
			return changeStatus;
		}
	}
}
