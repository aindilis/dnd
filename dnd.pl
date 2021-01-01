:- dynamic prolog_files/2, prolog_files/3, md/2, possible/1.

:- multifile genlsDirectlyList/2.
:- discontiguous are/2, isa/2.

:- ensure_loaded('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

%% :- prolog_include('/var/lib/myfrdcsa/codebases/minor/dnd/prolog/multifile-and-dynamic-directives.pl').

:- prolog_use_module(library(julian)).
:- prolog_use_module(library(regex)).
:- prolog_use_module(library(sha)).

:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/dates/frdcsa/sys/flp/autoload/dates.pl').
:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/frdcsa/sys/flp/autoload/profile.pl').
:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/counter2.pl').
%% :- prolog_consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/projects/microtheories/microtheory.pl').
:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/cyclone/frdcsa/sys/flp/autoload/kbs.pl').

:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/dnd/prolog/rules.pl').
:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/dnd/prolog/character.pl').
:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/dnd/prolog/story.pl').
:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/dnd/prolog/event_log.pl').

flpFlag(not(debug)).

viewIf(Item) :-
 	(   flpFlag(debug) -> 
	    view(Item) ;
	    true).

testDnD :-
	true.
	
:- log_message('DONE LOADING DND.').
formalogModuleLoaded(dnd).
