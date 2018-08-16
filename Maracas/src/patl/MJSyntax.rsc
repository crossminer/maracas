module patl::MJSyntax

import Prelude;


//-----------------------------------------------
// Syntax
//-----------------------------------------------

start syntax Program 
	= program: ClassDefinition* classDefinitions;

syntax ClassDefinition 
	= classDefinition: "class" Id class "extends" Id superClass "{"  
		FieldDefinition* fieldDefinitions
		ConstructorDefinition? constructorDefinition
		MethodDefinition* methodDefinitions
		"}";

syntax FieldDefinition = fieldDefinition: VariableDeclaration definition ";";

syntax ConstructorDefinition 
	= constructorDefinition: Id class "(" {VariableDeclaration ","}* parameters ")" "{"
		"super" "(" {Id ","}* arguments ")" ";"
		Statement* statements
		"}";

syntax MethodDefinition 
	= methodDefinition: ReturnType returnType Id method "(" {VariableDeclaration ","}* parameters ")" "{"
		Statement* statements
		"}";

syntax ReturnType 
	= \type: Id
	| \void: "void";

syntax Expression 
	= null: "null"
	| variable: Id
	| fieldAccess: FieldMethodAccess
	| cast: "(" Id type ")" Id variable
	| promotableExpression: PromotableExpression;

syntax PromotableExpression 
	= methodInvocation: FieldMethodAccess "(" {Id ","}* arguments ")"
	| objectCreation: "new" Id type "(" {Id ","}* arguments ")";

syntax Statement 
	= noop: ";"
	| promotableExpression: PromotableExpression expression ";"
	| conditional: "if" "(" Id condition ")" "{" Statement* ifBody "}" "else" "{" Statement* elseBody "}"
	| loop: "while" "(" Id condition ")" "{" Statement* body "}"
	| fieldAssignment: FieldMethodAccess field "=" Expression value ";"
	| variableDeclaration: VariableDeclaration ";"
	| variableAssignment: Id variable "=" Expression value
	| \return: "return" Expression value
	| block: "{" Statement* statements "}";

syntax VariableDeclaration = variableDeclaration: Id class Id variable;


lexical FieldMethodAccess = Id [.] Id;
lexical Id = [A-Za-z0-9$]* !>> [A-Za-z0-9$];