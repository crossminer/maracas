package org.maracas.delta.internal;

import io.usethesource.vallang.ISourceLocation;
import japicmp.model.JApiAnnotation;
import japicmp.model.JApiClass;
import japicmp.model.JApiConstructor;
import japicmp.model.JApiException;
import japicmp.model.JApiField;
import japicmp.model.JApiImplementedInterface;
import japicmp.model.JApiMethod;
import japicmp.model.JApiParameter;

public interface JApiCmpResolver {

	ISourceLocation resolve(JApiClass clas);
	ISourceLocation resolve(JApiImplementedInterface inter);
	ISourceLocation resolve(JApiAnnotation ann);
	ISourceLocation resolve(JApiException excep);
	ISourceLocation resolve(JApiField field);
	ISourceLocation resolve(JApiMethod method);
	ISourceLocation resolve(JApiConstructor cons);
	ISourceLocation resolveType(JApiParameter param);
	ISourceLocation resolveType(String type);
	ISourceLocation resolveSuperclass(String superclass);
	
}
