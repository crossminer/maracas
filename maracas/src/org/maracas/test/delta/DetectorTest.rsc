module org::maracas::\test::delta::DetectorTest

import lang::java::m3::AST;
import org::maracas::delta::Delta;
import org::maracas::delta::Detector;
import org::maracas::config::Options;
import org::maracas::Maracas;
import Relation;

loc api0 = |project://maracas/src/org/maracas/test/data/minimalbc.1.0.jar|;
loc api1 = |project://maracas/src/org/maracas/test/data/minimalbc.1.1.jar|;
loc client = |project://maracas/src/org/maracas/test/data/minimalbc-client.1.0.jar|;

public Delta delta = delta(api0, api1);
public Delta fbc = fieldDelta(delta);
public Delta mbc = methodDelta(delta);
public Delta cbc = classDelta(delta);

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
    
    
//----------------------------------------------
// Deprecated tests
//----------------------------------------------
test bool fieldDeprecated() 
	= { detection(
		    |java+method:///client/Deprecated/fieldDeprecated()|,
		    |java+field:///p2/Deprecated3/field1|,
		    <|java+field:///p2/Deprecated3/field1|,|java+field:///p2/Deprecated3/field1|,1.0,MATCH_SIGNATURE>,
		    deprecated()),
		detection(
		    |java+method:///client/Deprecated/fieldDeprecated()|,
		    |java+field:///p2/Deprecated3/field3|,
		    <|java+field:///p2/Deprecated3/field3|,|java+field:///p2/Deprecated3/field3|,1.0,MATCH_SIGNATURE>,
		    deprecated()) }
	<= fd;
	
test bool methodDeprecated() 
	= { detection(
		    |java+method:///client/Deprecated/methodDeprecated()|,
		    |java+method:///p2/Deprecated2/m1()|,
		    <|java+method:///p2/Deprecated2/m1()|,|java+method:///p2/Deprecated2/m1()|,1.0,MATCH_SIGNATURE>,
		    deprecated()), 
		detection(
		    |java+method:///client/Deprecated/methodDeprecated()|,
		    |java+method:///p2/Deprecated2/m3()|,
		    <|java+method:///p2/Deprecated2/m3()|,|java+method:///p2/Deprecated2/m3()|,1.0,MATCH_SIGNATURE>,
		    deprecated()) }
    <= md;

test bool classDeprecated()
	= { detection(
			|java+method:///client/Deprecated/classDeprecated()|,
		    |java+class:///p2/Deprecated1|,
		    <|java+class:///p2/Deprecated1|,|java+class:///p2/Deprecated1|,1.0,MATCH_SIGNATURE>,
		    deprecated()),
		detection(
		    |java+field:///client/Deprecated/classField|,
		    |java+class:///p2/Deprecated1|,
		    <|java+class:///p2/Deprecated1|,|java+class:///p2/Deprecated1|,1.0,MATCH_SIGNATURE>,
		    deprecated()) }
	<= cd;
	
	
//----------------------------------------------
// Renamed tests
//----------------------------------------------
test bool methodRenamed() 
	= detection(
		|java+method:///client/Renamed/methodRenamed()|,
	    |java+method:///p2/Renamed2/m3(java.lang.String%5B%5D)|,
	    <|java+method:///p2/Renamed2/m3(java.lang.String%5B%5D)|,|java+method:///p2/Renamed2/m4(java.lang.String%5B%5D)|,0.9911504424778761,"levenshtein">,
	    renamed())
	in md;

test bool classRenamed() 
	= { detection(
		    |java+field:///client/Renamed/classField|,
		    |java+class:///p2/Renamed1|,
		    <|java+class:///p2/Renamed1|,|java+class:///p2/RenamedRenamed1|,0.8444444444444444,"levenshtein">,
		    renamed()),
		detection(
		    |java+method:///client/Renamed/classRenamed()|,
		    |java+class:///p2/Renamed1|,
		    <|java+class:///p2/Renamed1|,|java+class:///p2/RenamedRenamed1|,0.8444444444444444,"levenshtein">,
		    renamed()) } 
	<= cd;
	

//----------------------------------------------
// Moved tests
//----------------------------------------------
test bool methodMovedDueToRenamedClass() 
	= { detection(
		    |java+method:///client/Renamed/classRenamed()|,
		    |java+method:///p2/Renamed1/getF2()|,
		    <|java+method:///p2/Renamed1/getF2()|,|java+method:///p2/RenamedRenamed1/getF2()|,0.8372093023255813,"levenshtein">,
		    moved()),
		detection(
		    |java+method:///client/Renamed/classRenamed()|,
		    |java+method:///p2/Renamed1/isF3()|,
		    <|java+method:///p2/Renamed1/isF3()|,|java+method:///p2/RenamedRenamed1/isF3()|,0.8372093023255813,"levenshtein">,
		    moved()),
		detection(
		    |java+method:///client/Renamed/classRenamed()|,
		    |java+method:///p2/Renamed1/getF1()|,
		    <|java+method:///p2/Renamed1/getF1()|,|java+method:///p2/RenamedRenamed1/getF1()|,0.9705882352941176,"levenshtein">,
		    moved()) }
    <= md;

test bool methodMovedDueToMovedClass() 
	= { detection(
		    |java+method:///client/Moved/movedClass()|,
		    |java+method:///p2/Moved1/getF3()|,
		    <|java+method:///p2/Moved1/getF3()|,|java+method:///p2_1/Moved1/getF3()|,0.9444444444444444,"levenshtein">,
		    moved()),
		detection(
		    |java+method:///client/Moved/movedClass()|,
		    |java+method:///p2/Moved1/getF4()|,
		    <|java+method:///p2/Moved1/getF4()|,|java+method:///p2_1/Moved1/getF4()|,0.9444444444444444,"levenshtein">,
		    moved()),
		detection(
		    |java+method:///client/Moved/movedClass()|,
		    |java+method:///p2/Moved1/getF5()|,
		    <|java+method:///p2/Moved1/getF5()|,|java+method:///p2_1/Moved1/getF5()|,0.9444444444444444,"levenshtein">,
		    moved()),
		detection(
		    |java+method:///client/Moved/movedClass()|,
		    |java+method:///p2/Moved1/getF6()|,
		    <|java+method:///p2/Moved1/getF6()|,|java+method:///p2_1/Moved1/getF6()|,0.9444444444444444,"levenshtein">,
		    moved()) }
	<= md;
  
    
test bool classMoved() 
	= { detection(
		    |java+method:///client/Moved/movedClass()|,
		    |java+class:///p2/Moved1|,
		    <|java+class:///p2/Moved1|,|java+class:///p2_1/Moved1|,0.9484304932735426,"levenshtein">,
		    moved()),
		detection(
		    |java+field:///client/Moved/classField|,
		    |java+class:///p2/Moved1|,
		    <|java+class:///p2/Moved1|,|java+class:///p2_1/Moved1|,0.9484304932735426,"levenshtein">,
		    moved()) }
	<= cd;
	
	
//----------------------------------------------
// Removed tests
//----------------------------------------------
test bool methodRemovedClassConstructor() 
	= detection(
	    |java+method:///client/Removed/classRemoved()|,
	    |java+constructor:///p2/Removed1/Removed1(boolean,boolean,int,int)|,
	    <|java+constructor:///p2/Removed1/Removed1(boolean,boolean,int,int)|,|unknown:///|,1.0,MATCH_SIGNATURE>,
	    removed())
    in md;

test bool methodRemoved()
	= detection(
	    |java+method:///client/Removed/methodRemoved()|,
	    |java+method:///p2/Removed2/populateMatrices()|,
	    <|java+method:///p2/Removed2/populateMatrices()|,|unknown:///|,1.0,MATCH_SIGNATURE>,
	    removed())
    in md;

test bool classRemoved() 
	= { detection(
		    |java+method:///client/Removed/classRemoved()|,
		    |java+class:///p2/Removed1|,
		    <|java+class:///p2/Removed1|,|unknown:///|,1.0,MATCH_SIGNATURE>,
		    removed()),
		detection(
		    |java+field:///client/Removed/classField|,
		    |java+class:///p2/Removed1|,
		    <|java+class:///p2/Removed1|,|unknown:///|,1.0,MATCH_SIGNATURE>,
		    removed()) }
    <= cd;


