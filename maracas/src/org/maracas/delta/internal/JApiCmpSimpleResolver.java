package org.maracas.delta.internal;

import java.io.File;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.rascalmpl.library.lang.java.m3.internal.M3Constants;

import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IValueFactory;
import japicmp.model.JApiAnnotation;
import japicmp.model.JApiBehavior;
import japicmp.model.JApiClass;
import japicmp.model.JApiClassType.ClassType;
import japicmp.model.JApiException;
import japicmp.model.JApiField;
import japicmp.model.JApiImplementedInterface;
import japicmp.model.JApiParameter;
import japicmp.util.OptionalHelper;

public class JApiCmpSimpleResolver implements JApiCmpResolver {

	//-----------------------------------------------
	// Fields
	//-----------------------------------------------
	
	private final IValueFactory valueFactory;
	private final Map<String, String> schemes;
	
	
	//-----------------------------------------------
	// Methods
	//-----------------------------------------------
	
	/**
	 * Builds a JApiCmpSimpleResolver object.
	 * 
	 * @param valueFactory: Rascal value factory
	 */
	public JApiCmpSimpleResolver(IValueFactory valueFactory) {
		this.valueFactory = valueFactory;
		this.schemes = initializeSchemes();
	}
	
	/**
	 * Initializes a map relating class type names to M3 schemes.
	 * 
	 * @return map with keys as strings and values as M3 schemes (also 
	 *         strings)
	 */
	private final Map<String, String> initializeSchemes() {
		Map<String, String> schemes = new HashMap<String, String>();
		schemes.put(ClassType.ANNOTATION.name(), M3Constants.INTERFACE_SCHEME);
		schemes.put(ClassType.CLASS.name(), M3Constants.CLASS_SCHEME);
		schemes.put(ClassType.ENUM.name(), M3Constants.ENUM_SCHEME);
		schemes.put(ClassType.INTERFACE.name(), M3Constants.INTERFACE_SCHEME);
		schemes.put(OptionalHelper.N_A, M3Constants.UNKNOWN_SCHEME);
		return schemes;
	}

	@Override
	public ISourceLocation resolve(JApiClass clas) {
		String scheme = schemes.get(clas.getClassType().getOldType());
		String path = qualifiedNameToPath(clas.getFullyQualifiedName());
		return buildSourceLocation(scheme, path);
	}
	
	@Override
	public ISourceLocation resolve(JApiImplementedInterface inter) {
		String scheme = M3Constants.INTERFACE_SCHEME;
		String path = qualifiedNameToPath(inter.getFullyQualifiedName());
		return buildSourceLocation(scheme, path);
	}
	
	@Override
	public ISourceLocation resolve(JApiAnnotation ann) {
		String scheme = M3Constants.INTERFACE_SCHEME;
		String path = qualifiedNameToPath(ann.getFullyQualifiedName());
		return buildSourceLocation(scheme, path);
	}
	
	@Override
	public ISourceLocation resolve(JApiException excep) {
		String scheme = M3Constants.CLASS_SCHEME;
		String path = qualifiedNameToPath(excep.getName());
		return buildSourceLocation(scheme, path);
	}
	
	@Override
	public ISourceLocation resolve(JApiField field) {
		String scheme = M3Constants.FIELD_SCHEME;
		String qualifName = concatQualifiedName(field.getjApiClass().getFullyQualifiedName(), field.getName());
		String path = qualifiedNameToPath(qualifName);
		return buildSourceLocation(scheme, path);
	}
	
	@Override
	public <T extends JApiBehavior> ISourceLocation resolve(T method) {
		String scheme = M3Constants.METHOD_SCHEME;
		String path = composeMethodPath(method.getjApiClass().getFullyQualifiedName(), method.getName(), method.getParameters());
		return buildSourceLocation(scheme, path);
	}
	
	@Override
	public ISourceLocation resolveType(JApiParameter param) {
		return resolveType(param.getType());
	}
	
	@Override
	public ISourceLocation resolveType(String type) {
		String path = qualifiedNameToPath(type);
		String scheme = (type.contains(".")) ? M3Constants.CLASS_SCHEME : M3Constants.PRIMITIVE_TYPE_SCHEME; // Check: CLASS is not always the case
		return buildSourceLocation(scheme, path);
	}
	
	@Override
	public ISourceLocation resolveSuperclass(String superclass) {
		String scheme = M3Constants.CLASS_SCHEME; // TODO: check interface cases
		String path = (superclass.isEmpty()) ? M3Constants.UNKNOWN_SCHEME : qualifiedNameToPath(superclass);
		return buildSourceLocation(scheme, path);
	}
	
	/**
	 * Builds a Vallang source location from a given schem and path. No 
	 * URI authority is considered. If there is aproblem during the 
	 * building process a runtime exception is thrown.
	 * 
	 * @param scheme: string representing the source location scheme
	 * @param path: string representing the source location path
	 * @return source location with the given scheme and path
	 */
	private ISourceLocation buildSourceLocation(String scheme, String path) {
		try {
			return valueFactory.sourceLocation(scheme, "", path);
		} 
		catch (URISyntaxException e) {
			throw new RuntimeException("Error while building the source location from: " + scheme + " - " + path);
		}
	}
	
	/**
	 * Transforms a qualified name in the form of <string>(.<string>)
	 * to a path in the form of <string>(/<string>).
	 * 
	 * @param qualifiedName: string in the form of <string>(.<string>)
	 * @return string representing a path in the form of <string>(/<string>)
	 */
	private String qualifiedNameToPath(String qualifiedName) {
		return qualifiedName.replace(".", File.separator);
	}
	
	/**
	 * Concats two strings as <root>.<name>.
	 * 
	 * @param root: root string
	 * @param name: added string
	 * @return concatenated string
	 */
	private String concatQualifiedName(String root, String name) {
		return root + "." + name;
	}
	
	/**
	 * Creates a method path given a root (i.e. qualified name), the method 
	 * name and a list of {@link japicmp.model.JApiParameter}. The resulting 
	 * path is a string in the form of <root>.<name>((<params>, ',')*)
	 * 
	 * @param root: root string
	 * @param methodName: string representing the method name
	 * @param params: list of JApiParameters
	 * @return string representing a path in the form of <root>.<name>((<params>, ',')*)
	 */
	private String composeMethodPath(String root, String methodName, List<JApiParameter> params) {
		String qualifName = concatQualifiedName(root, methodName);
		String path = qualifiedNameToPath(qualifName) + "(";
		
		for(JApiParameter p : params) {
			path += p.getType();
			
			if(params.indexOf(p) < params.size() - 1 ) {
				path += ",";
			} 
		}
		
		return path + ")";
	}
}
