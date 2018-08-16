module patl::PATLSyntax

import Prelude;


//-----------------------------------------------
// Syntax
//-----------------------------------------------

start syntax RuleSequence = patl: TransformationRule* rules;

syntax TransformationRule 
	= 	transRule: "(" { MetavariableDeclaration "," }+ vars ")" 
		"{" SourcePattern+ srcPatterns TargetPattern+ targPatterns "}";

syntax MetavariableDeclaration 
	= metavarDecl: Id name ":" Id oldType "-\>" Id newType; 

syntax SourcePattern = "-" StatementPattern pattern;

syntax TargetPattern = "+" StatementPattern pattern;

syntax StatementPattern 
	= assignment: Id metavariable "=" ExpressionPattern expressionPattern ";"
	| expression: ExpressionPattern expressionPattern ";";

syntax ExpressionPattern 
	= methodInvocation: FieldMethodAccess "(" {Id ","}* arguments ")"
	| constructor: "new" Id typ "(" {Id ","}* arguments ")"
	| fieldAccess: FieldMethodAccess;
	
syntax FieldMethodAccess = Id var NoSpace "." NoSpace Id fieldMethod;

lexical Id = [A-Za-z0-9$]+ !>> [A-Za-z0-9$];

layout Whitespace = [\t-\n\r\ ]* !>> [\t-\n\r\ ];
layout NoSpace = @manual;
