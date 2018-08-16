module patl::PATLLoad

import Prelude;
import patl::PATLSyntax;
import patl::PATLAbstract;

RuleSequence parsePATL(str content) = parse(#RuleSequence, content, allowAmbiguity=false);
PATL implodePATL(str content) = implode(#PATL, parsePATL(content));