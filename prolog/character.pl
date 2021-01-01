:- dynamic casted/3.

are([aindilis],human).
are([aindilis],wizard).

has(aindilis,specs,
    [
     currentHitPoints(19),
     armorClass(11),
     initiative(1),
     speed(30)
    ]).

has(aindilis,stats,
	 [
	  strength(10,0),
	  dexterity(13,1),
	  constitution(17,3),
	  intelligence(18,4),
	  wisdom(13,1),
	  charisma(12,1)
	 ]).

passiveWisdom(11).

are(List,levelNSpell(Level)) :-
	hasLevel(List,Level).

hasLevel([acidSplash,presidigitation,poisonSpray],0).
hasLevel([magicMissle,protectionFromGoodAndEvil,expiditousRetrreat,disquiseSelf],1).
hasLevel([shadowblade,dragonsBreath],2).

has(aindilis,spells,
	  [
	   acidSplash,
	   presidigitation,
	   poisonSpray
	  ]).

has(aindilis,spells,
	  [
	   magicMissle,
	   protectionFromGoodAndEvil,
	   expiditousRetrreat,
	   disquiseSelf
	  ]).

has(aindilis,spells,
    [
     dragonsBreath,
     shadowblade
    ]).

has(aindilis,skills,
    [
     acrobatics(1,dex),
     animal(3,handling,wis),
     arcana(6,int),
     athletics(0,str),
     deception(1,cha),
     history(4,int),
     insight(3,wis),
     intimidation(1,cha),
     investigation(4,int),
     medicine(1,wis),
     nature(4,int),
     perception(1,wis),
     performancec(1,cha),
     persuasion(1,cha),
     religion(4,int),
     sleight(1,of,hand,dex),
     stealth(1,dex),
     survival(3,wis)
    ]).

has(aindilis,spellDC,14).

has(aindilis,
    proficiency(weapon),
    [weapon,daggers,dart,slings,quarterstaff,light,crossbows]).

has(aindilis,
    proficiency,
    [alchemist]).

has(aindilis,
    proficiency(languages),
    [common,elvish]).

misc('can I ',[hear],
     perceptionCheck).

has(niv,property,[dumb,strong,good(cleaner)]).
has(mizet,property,[smartForGoblin]).

has(aindilis,gold,87).
has(aindilis,copper,50).

hasLevel(aindilis,2).

canCast(Agent,level(Level2),qty(Qty)) :-
	hasLevel(Agent,Level1),
	canCastAtLevel(level(Level1),List),
	member(qty(level(Level2),Qty),List),
	Level2 =< Level1.

canCastAtLevel(level(1),[qty(level(0),3),qty(level(1),2)]).
canCastAtLevel(level(2),[qty(level(0),3),qty(level(1),4),qty(level(2),2)]).
