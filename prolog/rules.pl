are([wizard,warlock],characterClass).
are([abilityCheck,attackRoll,savingThrow],d20Rolls).

%% savingThrow() :-
%% 	true.

%% frame(wizard,
%%       [
%%        description-[val 'The wizard character class.'],
%%        isA-[val characterClass],
%%        %% toGetValue-[val defaultGetValue],
%%        %% format-[val single_Entry],
%%        %% datatype-[val manType],
%%        %% %% (i.e. the entry is a unit, representing a man.)
%%        %% inverse-[val wife],
%%        %% subSlotOf-[val spouse],
%%        %% makesSenseFor-[val any_woman],
%%        %% myTmeOfCreation-[val [1980-7-4,7:23:0]],
%%        %% myCreator-[val daveSmith]
%%        ]).

%% procedure([roll(Die),add(Modifier)],applyCircumstantialBonsuesAndPenalties,compareTotalToTarget).

%% abilityScore

%% modifies

%% advantage
%% disadvantage

%% isa(SpecificRule,specificRule),
%% isa(GeneralRule,generalRule),
%% contradictory([SpecificRule,GeneralRule]),
%% wins(SpecificRule).




%%  you can cast a level n spell as your n+m spell level where m >= 1,
%%  sometimes with an additional bonus

doThing(Item) :-
	view(Item).

roll(d(N),Value) :-
	view([n,N]),
	atom_number(N,O),
	view([o,O]),
	P is O + 1,
	random(1,P,Value).

rollN(d(N),Value) :-
	O is N + 1,
	random(1,O,Value).


hasD(Agent,Thing,Item) :-
	has(Agent,Thing,List),
	member(Item,List).


%% have a roll where we can feed actual physical roll values into the
%% system

can(cast(Agent,Spell)) :-
	findall(casted(Agent,Spell,DateTime,Level),
		(
		 casted(Agent,Spell,_,DateTime),
		 hasLevel(List,Level),
		 member(Spell,List)
		),
		SpellsCasted),
	view([spellsCasted,SpellsCasted]).
	%% length(SpellsCasted,NumberOfSpells),
	%% < NumberOfSpells

make(Agent,savingThrow(Agent,Skill)) :-
	true.

%% Need to make it so it generates the logic dynamically, and says:
%% "you need to roll a saving throw", and so on.  Then it runs the
%% code.

%% you can make a wisdom save

%% you can make a constitution check



%% bonus actions can precede actions

%% critical succeed their skill checks

%% arcana check

%% detect magic



%% make constituation saving throw

make(Agent,savingThrow(Type,SavingThrowValue)) :-
	hasD(Agent,stats,Term),
	Term =.. [Type,Value,Bonus],
	rollN(d(20),Roll),
	view([roll,Roll]),
	SavingThrowValue is Roll + Bonus,
	view([bonus,Bonus]).

make(Agent,check(Type,CheckValue)) :-
	hasD(Agent,skills,Term),
	Term =.. [Type,Modifier,Kind],
	view([modifier,Modifier]),
	rollN(d(20),Roll),
	view([roll,Roll]),
	CheckValue is Roll + Modifier.

getTypeValue(Agent,Type,Value) :-
	hasD(Agent,Type,Term),
	Term =.. [Value,_,_].
