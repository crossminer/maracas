module org::maracas::\test::bc::BreakingChangesBuilderTest

import lang::java::m3::AST;
import org::maracas::bc::BreakingChanges;
import org::maracas::Maracas;


loc api0 = |project://maracas/src/org/maracas/test/data/minimalbc.1.0.jar|;
loc api1 = |project://maracas/src/org/maracas/test/data/minimalbc.1.1.jar|;

public BreakingChanges fbc = fieldBreakingChanges(api0, api1);
public BreakingChanges mbc = methodBreakingChanges(api0, api1);
public BreakingChanges cbc = classBreakingChanges(api0, api1);


test bool fieldChangedAccessModifier() 
	= fbc.changedAccessModifier == {
		<|java+field:///p1/ChangedAccessModifier3/field1|,<\private(),\protected(),1.0,"signature">>,
    	<|java+field:///p1/ChangedAccessModifier3/field2|,<\protected(),\public(),1.0,"signature">>,
    	<|java+field:///p1/ChangedAccessModifier3/field3|,<\public(),\private(),1.0,"signature">>
	};

test bool methodChangedAccessModifier() 
	= mbc.changedAccessModifier == {
		<|java+method:///p1/ChangedAccesModifier2/m1()|,<\public(),\private(),1.0,"signature">>,
    	<|java+method:///p1/ChangedAccesModifier2/m3()|,<\protected(),\public(),1.0,"signature">>,
    	<|java+method:///p1/ChangedAccesModifier2/m2()|,<\private(),\protected(),1.0,"signature">>,
    	<|java+constructor:///p1/ChangedAccesModifier1$Inner3/ChangedAccesModifier1$Inner3(p1.ChangedAccesModifier1)|,<\protected(),\public(),1.0,"signature">>,
    	<|java+constructor:///p1/ChangedAccesModifier1$Inner2/ChangedAccesModifier1$Inner2(p1.ChangedAccesModifier1)|,<\private(),\protected(),1.0,"signature">>,
    	<|java+constructor:///p1/ChangedAccesModifier1$Inner1/ChangedAccesModifier1$Inner1(p1.ChangedAccesModifier1)|,<\public(),\private(),1.0,"signature">>
	};

// FIXME: the jar M3 always identifies a public inner class. Is it an error, or just the compiler?
// java+constructor can be used
test bool classChangedAccessModifier() = cbc.changedAccessModifier == {};


test bool fieldChangedFinalModifier()
	= fbc.changedFinalModifier == {
		<|java+field:///p1/ChangedFinalModifier3/field1|,<\final(),\default(),1.0,"signature">>,
    	<|java+field:///p1/ChangedFinalModifier3/field2|,<\default(),\final(),1.0,"signature">>
	};

test bool methodChangedFinalModifier()
	= mbc.changedFinalModifier == {
		<|java+method:///p1/ChangedFinalModifier2/m1()|,<\default(),\final(),1.0,"signature">>,
    	<|java+method:///p1/ChangedFinalModifier2/m2()|,<\final(),\default(),1.0,"signature">>,
    	<|java+method:///p1/ChangedFinalModifier2/m3()|,<\final(),\default(),1.0,"signature">>,
    	<|java+method:///p1/ChangedFinalModifier2/m4()|,<\default(),\final(),1.0,"signature">>
    };

test bool classChangedFinalModifier()
	= cbc.changedFinalModifier == {
		<|java+class:///p1/ChangedFinalModifier1|,<\default(),\final(),1.0,"signature">>,
    	<|java+class:///p1/ChangedFinalModifier1$Inner1|,<\default(),\final(),1.0,"signature">>,
    	<|java+class:///p1/ChangedFinalModifier1$Inner2|,<\final(),\default(),1.0,"signature">>
	};


test bool fieldChangedStaticModifier()
	= fbc.changedStaticModifier == {
		<|java+field:///p1/ChangedStaticModifier3/field1|,<\static(),\default(),1.0,"signature">>,
    	<|java+field:///p1/ChangedStaticModifier3/field2|,<\default(),\static(),1.0,"signature">>
	};
	
test bool methodChangedStaticModifier()
	= mbc.changedStaticModifier == {
		<|java+method:///p1/ChangedStaticModifier2/m1()|,<\default(),\static(),1.0,"signature">>,
 		<|java+method:///p1/ChangedStaticModifier2/m3()|,<\static(),\default(),1.0,"signature">>,
 		<|java+method:///p1/ChangedStaticModifier2/m2()|,<\static(),\default(),1.0,"signature">>,
  		<|java+initializer:///p1/ChangedStaticModifier3/ChangedStaticModifier3$initializer|,<\static(),\default(),1.0,"signature">>
	};
	
// TODO: check if we should take it out from the adt.
// TODO: what happens with inner classes?
test bool classChangedStaticModifier()
	= cbc.changedStaticModifier == {};