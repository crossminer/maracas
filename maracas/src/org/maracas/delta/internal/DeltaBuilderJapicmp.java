package org.maracas.delta.internal;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.rascalmpl.library.lang.java.m3.internal.M3Constants;

import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.ITuple;
import japicmp.cmp.JApiCmpArchive;
import japicmp.cmp.JarArchiveComparator;
import japicmp.cmp.JarArchiveComparatorOptions;
import japicmp.model.AbstractModifier;
import japicmp.model.AccessModifier;
import japicmp.model.FinalModifier;
import japicmp.model.JApiChangeStatus;
import japicmp.model.JApiClass;
import japicmp.model.JApiClassType;
import japicmp.model.JApiModifier;
import japicmp.model.JApiModifierBase;
import japicmp.model.StaticModifier;
import japicmp.model.SyntheticModifier;

public class DeltaBuilderJapicmp extends Delta {

	private String oldAPIPath;
	private String newAPIPath;
	private String oldVersion;
	private String newVersion;
	private List<JApiClass> classes;
	private JApiElemVisitor visitor;
	private JApiConverter converter;
	
	public DeltaBuilderJapicmp(String oldAPIPath, String newAPIPath, String oldVersion, String newVersion) {
		super();
		this.oldAPIPath = oldAPIPath;
		this.newAPIPath = newAPIPath;
		this.oldVersion = oldVersion;
		this.newVersion = newVersion;
		this.classes = new ArrayList<JApiClass>();
		this.visitor = new JApiElemVisitor();
		this.converter = new JApiConverter();
		extract();
	}
	
	public void extract() {
		compareAPIs();
		extractChanges();
	}
	
	private void compareAPIs() {
		JarArchiveComparatorOptions options = new JarArchiveComparatorOptions();
		JarArchiveComparator comparator = new JarArchiveComparator(options);
		
		JApiCmpArchive oldAPI = new JApiCmpArchive(new File(oldAPIPath), oldVersion);
		JApiCmpArchive newAPI = new JApiCmpArchive(new File(newAPIPath), newVersion);
		
		classes = comparator.compare(oldAPI, newAPI);
	}

	private void extractChanges() {
		classes.forEach(c -> visitor.visit(c));
	}
	
	public static void main(String[] args) {
		String oldAPIPath = "/Users/ochoa/Desktop/bacata/guava-18.0.jar";
		String oldVersion = "18.0";
		String newAPIPath = "/Users/ochoa/Desktop/bacata/guava-19.0.jar";
		String newVersion = "19.0";
		
		DeltaBuilderJapicmp builder = new DeltaBuilderJapicmp(oldAPIPath, newAPIPath, oldVersion, newVersion);
		builder.extract();
	}
	
	public class JApiElemVisitor {
		
		public void visit(JApiClass elem) {
			JApiModifier<AbstractModifier> abstractModifier = elem.getAbstractModifier();
			JApiModifier<AccessModifier> accessModifier = elem.getAccessModifier();
			JApiModifier<FinalModifier> finalModifier = elem.getFinalModifier();
			JApiModifier<StaticModifier> staticModifier = elem.getStaticModifier();
			JApiModifier<SyntheticModifier> syntheticModifier = elem.getSyntheticModifier();
			
			//JApiClassType scheme = elem.getClassType().getOldType();
			ISourceLocation location = converter.createLocation(M3Constants.CLASS_SCHEME, elem.getFullyQualifiedName());
			addAbstractModifier(location, abstractModifier);
			addAccessModifier(location, accessModifier);
			addFinalModifier(location, finalModifier);
			addStaticModifier(location, staticModifier);
			addSyntheticModifier(location, syntheticModifier);
		}
		
		private void addType(ISourceLocation oldLocation, ISourceLocation newLocation) {
			
		}
		
		private void addAbstractModifier(ISourceLocation location, JApiModifier<AbstractModifier> modifier) {
			if (modifier.getChangeStatus() != JApiChangeStatus.UNCHANGED) {
				ITuple mapping = getModifierMapping(location, modifier);
				System.out.println(mapping);
				abstractModifiers.insert(mapping);
			}
		}
		
		private void addAccessModifier(ISourceLocation location, JApiModifier<AccessModifier> modifier) {
			if (modifier.getChangeStatus() != JApiChangeStatus.UNCHANGED) {
				ITuple mapping = getModifierMapping(location, modifier);
				System.out.println(mapping);
				accessModifiers.insert(mapping);
			}
		}
		
		private void addFinalModifier(ISourceLocation location, JApiModifier<FinalModifier> modifier) {
			if (modifier.getChangeStatus() != JApiChangeStatus.UNCHANGED) {
				ITuple mapping = getModifierMapping(location, modifier);
				System.out.println(mapping);
				finalModifiers.insert(mapping);
			}
		}
		
		private void addStaticModifier(ISourceLocation location, JApiModifier<StaticModifier> modifier) {
			if (modifier.getChangeStatus() != JApiChangeStatus.UNCHANGED) {
				ITuple mapping = getModifierMapping(location, modifier);
				System.out.println(mapping);
				staticModifiers.insert(mapping);
			}
		}
		
		private void addSyntheticModifier(ISourceLocation location, JApiModifier<SyntheticModifier> modifier) {
			if (modifier.getChangeStatus() != JApiChangeStatus.UNCHANGED) {
				ITuple mapping = getModifierMapping(location, modifier);
				System.out.println(mapping);
				syntheticModifiers.insert(mapping);
			}
		}
		
		private <T extends Enum<T> & JApiModifierBase> ITuple getModifierMapping(ISourceLocation location, JApiModifier<T> modifier) {
			IString from = converter.resolve(modifier.getOldModifier().get());
			IString to = converter.resolve(modifier.getNewModifier().get());
			return converter.createMapping(location, from, to);
		}
		
	}
}
