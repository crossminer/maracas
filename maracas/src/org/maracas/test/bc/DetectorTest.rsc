module org::maracas::\test::bc::DetectorTest

import lang::java::m3::AST;
import org::maracas::bc::BreakingChanges;
import org::maracas::bc::Detector;
import org::maracas::config::Options;
import org::maracas::Maracas;


loc api0 = |project://maracas/src/org/maracas/test/data/minimalbc.1.0.jar|;
loc api1 = |project://maracas/src/org/maracas/test/data/minimalbc.1.1.jar|;
loc client = |project://maracas/src/org/maracas/test/data/minimalbc-client.1.0.jar|;

public BreakingChanges fbc = fieldBreakingChanges(api0, api1);
public BreakingChanges mbc = methodBreakingChanges(api0, api1);
public BreakingChanges cbc = classBreakingChanges(api0, api1);

public set[Detection] fd = detections(client, fbc);
public set[Detection] md = detections(client, mbc);
public set[Detection] cd = detections(client, cbc);


//----------------------------------------------
// Changed access modifier tests
//----------------------------------------------
test bool fieldChangedAccessModifier() 
	= detection(
		|java+method:///client/ChangedAccessModifier/fieldChangedAccessModifier()|,
		|java+field:///p1/ChangedAccessModifier3/field3|,
		<\public(),\private(),1.0,MATCH_SIGNATURE>,
		changedAccessModifier())
	in fd;
    
test bool methodChangedAccessModifier() 
	= detection(
		|java+method:///client/ChangedAccessModifier/methodChangedAccessModifier()|,
	    |java+method:///p1/ChangedAccessModifier2/m1()|,
	    <\public(),\private(),1.0,MATCH_SIGNATURE>,
	    changedAccessModifier())
	in md;


//----------------------------------------------
// Changed final modifier tests
//----------------------------------------------
test bool fieldChangedFinalModifier() 
	= { detection(
		    |java+method:///client/ChangedFinalModifier/fieldChangedFinalModifier()|,
		    |java+field:///p1/ChangedFinalModifier3/field1|,
		    <\final(),\default(),1.0,MATCH_SIGNATURE>,
		    changedFinalModifier()),
		detection(
		    |java+method:///client/ChangedFinalModifier/fieldChangedFinalModifier()|,
		    |java+field:///p1/ChangedFinalModifier3/field2|,
		    <\default(),\final(),1.0,MATCH_SIGNATURE>,
		    changedFinalModifier()) }
    <= fd;

test bool methodChangedFinalModifier() 
	= { detection(
		    |java+method:///client/ChangedFinalModifier/methodChangedFinalModifier()|,
		    |java+method:///p1/ChangedFinalModifier2/m1()|,
		    <\default(),\final(),1.0,MATCH_SIGNATURE>,
		    changedFinalModifier()),
    	detection(
		    |java+method:///client/ChangedFinalModifier/methodChangedFinalModifier()|,
		    |java+method:///p1/ChangedFinalModifier2/m2()|,
		    <\final(),\default(),1.0,MATCH_SIGNATURE>,
		    changedFinalModifier()),
  		detection(
		    |java+method:///client/ChangedFinalModifier/methodChangedFinalModifier()|,
		    |java+method:///p1/ChangedFinalModifier2/m4()|,
		    <\default(),\final(),1.0,MATCH_SIGNATURE>,
		    changedFinalModifier()) }
	<= md;

test bool classChangedFinalModifier1() 
	= detection(
    	|java+field:///client/ChangedFinalModifier/classField|,
    	|java+class:///p1/ChangedFinalModifier1|,
    	<\default(),\final(),1.0,MATCH_SIGNATURE>,
    	changedFinalModifier())
    in cd;

test bool classChangedFinalModifier2() 
	= detection(
	    |java+method:///client/ChangedFinalModifier/classChangedFinalModifier()|,
	    |java+class:///p1/ChangedFinalModifier1|,
	    <\default(),\final(),1.0,MATCH_SIGNATURE>,
	    changedFinalModifier())
    in cd;
    

//----------------------------------------------
// Changed static modifier tests
//----------------------------------------------
test bool fieldChangedStaticModifier() 
	= { detection(
			|java+method:///client/ChangedStaticModifier/fieldChangedStaticModifier()|,
			|java+field:///p1/ChangedStaticModifier3/field1|,
			<\static(),\default(),1.0,MATCH_SIGNATURE>,
			changedStaticModifier()),
		detection(
			|java+method:///client/ChangedStaticModifier/fieldChangedStaticModifier()|,
			|java+field:///p1/ChangedStaticModifier3/field2|,
			<\default(),\static(),1.0,MATCH_SIGNATURE>,
			changedStaticModifier()) }
	<= fd;
    
test bool methodChangedStaticModifier() 
	= { detection(
			|java+method:///client/ChangedStaticModifier/methodChangedStaticModifier()|,
		    |java+method:///p1/ChangedStaticModifier2/m1()|,
		    <\default(),\static(),1.0,MATCH_SIGNATURE>,
		    changedStaticModifier()),
		detection(
			|java+method:///client/ChangedStaticModifier/methodChangedStaticModifier()|,
		    |java+method:///p1/ChangedStaticModifier2/m2()|,
		    <\static(),\default(),1.0,MATCH_SIGNATURE>,
		    changedStaticModifier()) }
	<= md;


//----------------------------------------------
// Changed abstract modifier tests
//----------------------------------------------
test bool methodChangedAbstractModifier() 
	= { detection(
		    |java+method:///client/ChangedAbstractModifier/methodChangedAccessModifier()|,
		    |java+method:///p1/ChangedAbstractModifier2/m2()|,
		    <\default(),\abstract(),1.0,MATCH_SIGNATURE>,
		    changedAbstractModifier()),
	  	detection(
		    |java+method:///client/ChangedAbstractModifier/methodChangedAccessModifier()|,
		    |java+method:///p1/ChangedAbstractModifier2/m1()|,
		    <\abstract(),\default(),1.0,MATCH_SIGNATURE>,
		    changedAbstractModifier()) }
    <= md;

test bool classChangedAbstractModifier() 
	= { detection(
			|java+field:///client/ChangedAbstractModifier/classField|,
		    |java+class:///p1/ChangedAbstractModifier1|,
		    <\default(),\abstract(),1.0,MATCH_SIGNATURE>,
		    changedAbstractModifier()),
		detection(
		    |java+method:///client/ChangedAbstractModifier/classChangedAccessModifier()|,
		    |java+class:///p1/ChangedAbstractModifier1|,
		    <\default(),\abstract(),1.0,MATCH_SIGNATURE>,
		    changedAbstractModifier()) }
    <= cd;