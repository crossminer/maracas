module mj::Syntax

import Prelude;


//-------------------------------------------------
// MJ (Middleweight Java) Syntax
//-------------------------------------------------

start syntax Program 
	= program: ClassDefinition* classDefs;

syntax ClassDefinition 
	= classDefinition: "class" Id class "extends" Id superClass "{"  
		FieldDefinition* fieldDefs
		ConstructorDefinition? constDefs
		MethodDefinition* methDefs
		"}";

syntax FieldDefinition = fieldDefinition: VariableDeclaration def ";";

syntax ConstructorDefinition 
	= constDef: Id class "(" {VariableDeclaration ","}* params ")" "{"
		"super" "(" {Id ","}* args ")" ";"
		Statement* statements
		"}";

syntax MethodDefinition 
	= methDef: ReturnType returnType Id meth"(" {VariableDeclaration ","}* params ")" "{"
		Statement* statements
		"}";

syntax ReturnType 
	= \type: Id
	| \void: "void";

syntax Expression 
	= null: "null"
	| variable: Id
	| fieldAccess: FieldMethodAccess
	| cast: "(" Id type ")" Id var
	| promotableExpression: PromotableExpression;

syntax PromotableExpression 
	= methInv: FieldMethodAccess "(" {Id ","}* args ")"
	| objCreation: "new" Id type "(" {Id ","}* args ")";

syntax Statement 
	= noop: ";"
	| promExp: PromotableExpression exp ";"
	| cond: "if" "(" Id cond ")" "{" Statement* ifBody "}" "else" "{" Statement* elseBody "}"
	| loop: "while" "(" Id cond ")" "{" Statement* body "}"
	| fieldAssign: FieldMethodAccess field "=" Expression val ";"
	| varDecl: VariableDeclaration ";"
	| varAssign: Id var "=" Expression val ";"
	| \return: "return" Expression val ";"
	| block: "{" Statement* statements "}";

syntax VariableDeclaration = varDecl: Id class Id var;

syntax FieldMethodAccess = Id NoSpace "." NoSpace Id;

lexical Id = [A-Za-z0-9$]* !>> [A-Za-z0-9$];

layout Whitespace = [\t-\n\r\ ]* !>> [\t-\n\r\ ];
layout NoSpace = @manual;