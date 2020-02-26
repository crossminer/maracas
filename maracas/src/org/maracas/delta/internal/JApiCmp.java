package org.maracas.delta.internal;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.rascalmpl.interpreter.IEvaluatorContext;

import io.usethesource.vallang.IList;
import io.usethesource.vallang.ISet;
import io.usethesource.vallang.ISetWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.TypeStore;

public class JApiCmp {
	
	private final static String UNSTABLE_KEYWORDS = "config/unstable-keywords.properties";
			
	private final TypeStore typeStore;
	private final IValueFactory valueFactory;
	private IEvaluatorContext eval;
	private JApiCmpToRascal japicmpToRascal;
	
	public JApiCmp(IValueFactory valueFactory) {
		this.typeStore = new TypeStore();
		this.valueFactory = valueFactory;
	}
	
	public IList compareJapi(ISourceLocation oldJar, ISourceLocation newJar, IString oldVersion, IString newVersion, IList oldCP, IList newCP, IEvaluatorContext eval) {
		initializeJApiCmpToRascal(eval);
		return japicmpToRascal.compare(oldJar, newJar, oldVersion, newVersion, oldCP, newCP);
	}
	
	private void initializeJApiCmpToRascal(IEvaluatorContext eval) {
		this.eval = eval;
		this.japicmpToRascal = new JApiCmpToRascal(typeStore, valueFactory, eval);
	}
	
	public ISet readUnstableKeywords(IEvaluatorContext eval) {
		ISetWriter writer = valueFactory.setWriter();
		
		try (InputStream is = new FileInputStream(new File(UNSTABLE_KEYWORDS))) {
			Properties prop = new Properties();
			prop.load(is);
			String[] keywords = ((String) prop.get("keywords")).split(",");
			
			for (String k : keywords) {
				writer.append(valueFactory.string(k));
			}
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
		
		return writer.done();
	}
}
