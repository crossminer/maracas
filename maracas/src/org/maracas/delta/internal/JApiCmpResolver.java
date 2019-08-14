package org.maracas.delta.internal;

import io.usethesource.vallang.ISourceLocation;
import japicmp.model.JApiAnnotation;
import japicmp.model.JApiBehavior;
import japicmp.model.JApiClass;
import japicmp.model.JApiException;
import japicmp.model.JApiField;
import japicmp.model.JApiImplementedInterface;
import japicmp.model.JApiParameter;

public interface JApiCmpResolver {

	ISourceLocation resolve(JApiClass clas);
	ISourceLocation resolve(JApiImplementedInterface inter);
	ISourceLocation resolve(JApiAnnotation ann);
	ISourceLocation resolve(JApiException excep);
	ISourceLocation resolve(JApiField field);
	<T extends JApiBehavior> ISourceLocation resolve(T method);
	ISourceLocation resolveType(JApiParameter param);
	ISourceLocation resolveType(String type);
	ISourceLocation resolveSuperclass(String superclass);
	
}
