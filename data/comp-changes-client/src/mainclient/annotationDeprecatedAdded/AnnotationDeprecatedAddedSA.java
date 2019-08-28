package mainclient.annotationDeprecatedAdded;

import main.annotationDeprecatedAdded.AnnDeprAddedEmptyClass;
import main.annotationDeprecatedAdded.AnnDeprAddedFieldMethod;
import main.annotationDeprecatedAdded.AnnDeprAddedNonEmptyClass;

public class AnnotationDeprecatedAddedSA {

	AnnDeprAddedEmptyClass emptyClass;
	AnnDeprAddedNonEmptyClass nonEmptyClass;
	AnnDeprAddedFieldMethod nonDepClass;
	
	public void deprecatedClassEmpty() {
		AnnDeprAddedEmptyClass a = new AnnDeprAddedEmptyClass();
	}
	
	public void deprecatedClassNonEmpty() {
		AnnDeprAddedNonEmptyClass a = new AnnDeprAddedNonEmptyClass();
		int f = a.transField;
		a.transMethod();
	}

	public void deprecatedField() {
		AnnDeprAddedFieldMethod a = new AnnDeprAddedFieldMethod();
		int f = a.field;
	}
	
	public void deprecatedMethod() {
		AnnDeprAddedFieldMethod a = new AnnDeprAddedFieldMethod();
		int m = a.method();
	}
}
