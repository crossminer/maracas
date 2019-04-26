module org::maracas::\test::bc::BreakingChangesBuilderTest

import lang::java::m3::AST;
import lang::java::m3::TypeSymbol;
import org::maracas::bc::BreakingChanges;
import org::maracas::bc::BreakingChangesBuilder;
import org::maracas::config::Options;
import org::maracas::Maracas;
import Set;
import IO;


loc api0 = |project://maracas/src/org/maracas/test/data/minimalbc.1.0.jar|;
loc api1 = |project://maracas/src/org/maracas/test/data/minimalbc.1.1.jar|;

public BreakingChanges fbc = fieldBreakingChanges(api0, api1);
public BreakingChanges mbc = methodBreakingChanges(api0, api1);
public BreakingChanges cbc = classBreakingChanges(api0, api1);

test bool fieldChangedAccessModifier() 
	= fbc.changedAccessModifier == {
		<|java+field:///p1/ChangedAccessModifier3/field1|,<\private(),\protected(),1.0,MATCH_SIGNATURE>>,
    	<|java+field:///p1/ChangedAccessModifier3/field2|,<\protected(),\public(),1.0,MATCH_SIGNATURE>>,
    	<|java+field:///p1/ChangedAccessModifier3/field3|,<\public(),\private(),1.0,MATCH_SIGNATURE>>
	};

test bool methodChangedAccessModifier() 
	= mbc.changedAccessModifier == {
		<|java+method:///p1/ChangedAccesModifier2/m1()|,<\public(),\private(),1.0,MATCH_SIGNATURE>>,
    	<|java+method:///p1/ChangedAccesModifier2/m3()|,<\protected(),\public(),1.0,MATCH_SIGNATURE>>,
    	<|java+method:///p1/ChangedAccesModifier2/m2()|,<\private(),\protected(),1.0,MATCH_SIGNATURE>>,
    	<|java+constructor:///p1/ChangedAccesModifier1$Inner3/ChangedAccesModifier1$Inner3(p1.ChangedAccesModifier1)|,<\protected(),\public(),1.0,MATCH_SIGNATURE>>,
    	<|java+constructor:///p1/ChangedAccesModifier1$Inner2/ChangedAccesModifier1$Inner2(p1.ChangedAccesModifier1)|,<\private(),\protected(),1.0,MATCH_SIGNATURE>>,
    	<|java+constructor:///p1/ChangedAccesModifier1$Inner1/ChangedAccesModifier1$Inner1(p1.ChangedAccesModifier1)|,<\public(),\private(),1.0,MATCH_SIGNATURE>>
	};

// FIXME: the jar M3 always identifies a public inner class. Is it an error, or just the compiler?
// java+constructor can be used
test bool classChangedAccessModifier() { 
	return cbc.changedAccessModifier == {
		<|java+class:///p1/ChangedAccesModifier1$Inner1|,<\public(),\defaultAccess(),1.0,MATCH_SIGNATURE>>,
  		<|java+class:///p1/ChangedAccesModifier1$Inner2|,<\defaultAccess(),\public(),1.0,MATCH_SIGNATURE>>
	};
}

test bool fieldChangedFinalModifier()
	= fbc.changedFinalModifier == {
		<|java+field:///p1/ChangedFinalModifier3/field1|,<\final(),\default(),1.0,MATCH_SIGNATURE>>,
    	<|java+field:///p1/ChangedFinalModifier3/field2|,<\default(),\final(),1.0,MATCH_SIGNATURE>>
	};

test bool methodChangedFinalModifier()
	= mbc.changedFinalModifier == {
		<|java+method:///p1/ChangedFinalModifier2/m1()|,<\default(),\final(),1.0,MATCH_SIGNATURE>>,
    	<|java+method:///p1/ChangedFinalModifier2/m2()|,<\final(),\default(),1.0,MATCH_SIGNATURE>>,
    	<|java+method:///p1/ChangedFinalModifier2/m3()|,<\final(),\default(),1.0,MATCH_SIGNATURE>>,
    	<|java+method:///p1/ChangedFinalModifier2/m4()|,<\default(),\final(),1.0,MATCH_SIGNATURE>>
    };

test bool classChangedFinalModifier()
	= cbc.changedFinalModifier == {
		<|java+class:///p1/ChangedFinalModifier1|,<\default(),\final(),1.0,MATCH_SIGNATURE>>,
    	<|java+class:///p1/ChangedFinalModifier1$Inner1|,<\default(),\final(),1.0,MATCH_SIGNATURE>>,
    	<|java+class:///p1/ChangedFinalModifier1$Inner2|,<\final(),\default(),1.0,MATCH_SIGNATURE>>
	};


test bool fieldChangedStaticModifier()
	= fbc.changedStaticModifier == {
		<|java+field:///p1/ChangedStaticModifier3/field1|,<\static(),\default(),1.0,MATCH_SIGNATURE>>,
    	<|java+field:///p1/ChangedStaticModifier3/field2|,<\default(),\static(),1.0,MATCH_SIGNATURE>>
	};
	
test bool methodChangedStaticModifier()
	= mbc.changedStaticModifier == {
		<|java+method:///p1/ChangedStaticModifier2/m1()|,<\default(),\static(),1.0,MATCH_SIGNATURE>>,
		<|java+method:///p1/ChangedStaticModifier2/m2()|,<\static(),\default(),1.0,MATCH_SIGNATURE>>,
 		<|java+method:///p1/ChangedStaticModifier2/m3()|,<\static(),\default(),1.0,MATCH_SIGNATURE>>,
 		<|java+method:///p1/ChangedStaticModifier2/m4()|,<\default(),\static(),1.0,MATCH_SIGNATURE>>,
  		<|java+initializer:///p1/ChangedStaticModifier3/ChangedStaticModifier3$initializer|,<\static(),\default(),1.0,MATCH_SIGNATURE>>
	};
	
// TODO: add nested classes.
test bool classChangedStaticModifier()
	= cbc.changedStaticModifier == {};


test bool changedParamList1() {
	meth = |java+method:///p3/ChangeParamList/m2(int%5B%5D%5B%5D)|;
	list[TypeSymbol] from = [ 
		TypeSymbol::\array(TypeSymbol::\int(), 2)
	];
	list[TypeSymbol] to = [
		TypeSymbol::\array(TypeSymbol::\int(), 2),
		TypeSymbol::\class(|java+class:///java/lang/String|, []),
   		TypeSymbol::\int()
   	];
    return changedParamList(meth, from, to);
}

test bool changedParamList2() {
	meth = |java+method:///p3/ChangeParamList/m3(java.lang.String,int,boolean)|;
	list[TypeSymbol] from = [
		TypeSymbol::\class(|java+class:///java/lang/String|, []),
    	TypeSymbol::\int(),
    	TypeSymbol::\boolean() 
    ];
	list[TypeSymbol] to = [
		TypeSymbol::\int(),
    	TypeSymbol::\boolean(),
    	TypeSymbol::\class(|java+class:///java/lang/String|,[]) 
    ];
    return changedParamList(meth, from, to);
}

bool changedParamList(loc meth, list[TypeSymbol] from, list[TypeSymbol] to) {
	if (mbc.changedParamList[meth] != {}) {
		tuple[list[TypeSymbol] from, list[TypeSymbol] to, real conf, str meth] mapping 
			= getOneFrom(mbc.changedParamList[meth]);
    	return (from == mapping.from) && (to == mapping.to);
	}
	else {
		return false;
	}
}  


test bool methodRenamed() {
	renamed = mbc.renamed.mapping <0,1>;
	return renamed == {
		<|java+method:///p2/Renamed2/m3(java.lang.String%5B%5D)|,|java+method:///p2/Renamed2/m4(java.lang.String%5B%5D)|>
	};
}

test bool classRenamed() {
	renamed = cbc.renamed.mapping <0,1>;
	return renamed == {
		<|java+class:///p2/Renamed1|,|java+class:///p2/RenamedRenamed1|>
	};
}


test bool methodMoved() {
	moved = mbc.moved.mapping <0,1>;
	return moved >= {
		<|java+method:///p2/Moved1/m1()|,|java+method:///p2_1/Moved1/m1()|>,
		<|java+method:///p2/Moved1/m2()|,|java+method:///p2_1/Moved1/m2()|>,
		<|java+method:///p2/Moved1/m3()|,|java+method:///p2_1/Moved1/m3()|>,
		<|java+method:///p2/Moved1/m4()|,|java+method:///p2_1/Moved1/m4()|>
	};
}
    
test bool classMoved() {
	moved = cbc.moved.mapping <0,1>;
	return moved == {
		<|java+class:///p2/Moved1|,|java+class:///p2_1/Moved1|>
	};
}