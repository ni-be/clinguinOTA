% AGENT ENCODING WUMPUS
time(T) :- T = #max{T2 : ext_time(T2)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WORLD RULES
dir((DX, DY)) :- DX = -1..1, DY = -1..1, |DX|+|DY| == 1.
adjacent((X, Y), (X+DX, Y+DY)) :- holds(_,in(agent,(X,Y))), dir((DX, DY)). %X+DX = X', Y+DY = Y', DX != DY.

env(breeze). env(smell). env(sparkle).  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% initial location, based on first return from environment at time 0:
holds(0,in(agent,L)) :- holds(0, env(agent, L)). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REALITY CHECK AXIOMS / Occurence-Awareness Axioms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(T, F) :- observed(T, true, F).
-holds(T,F) :- observed(T, false,F).

:- holds(T,F), observed(T, false, F).
:- -holds(T,F), observed(T, true, F).

happened(T, F) :- observed(T, true, F). 
occurs(T, F) :- happened(T, F).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OBSERVE, explain Observations, update Knowledge base
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get new information from the Environment
%
% If the environment return E for location L 
% at time T, it is true.
% If an env(empty,L) is returned there is 
% nothing except possible walls in that room.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

observed(T, true, env(E,L)) :- eholds(T,env(E,L)), time(T).
observed(T, false,env(E,L)) :- eholds(T,env(empty,L)), 
                                holds(T,in(agent,L)), env(E), time(T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explain observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ASSUME a Pit or Wumpus to be at an adjacent location of the smell, that we have not yet visited. 
holds(T, assume(pit,L')):- holds(T,env(breeze,L)), adjacent(L,L'), not holds(K,in(agent,L')), T > K, ext_time(K).
holds(T, assume(wumpus,L')):- holds(T,env(smell,L)), adjacent(L,L'), not holds(K,in(agent,L')), T > K, ext_time(K).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update knowledge base
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


holds(T+1,F) :- holds(T+1,F), not -holds(T,F), time(T+1).
-holds(T+1,F) :- -holds(T+1,F), not holds(T,F), time(T+1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THINK: select an approriate Goal, G; Find a plan, to achieve G
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% IF EMPTY -> explore / move to new field if possible else move back
%%%%%%%%%%%%%%%%%%%%%%%

1 { goal(T,move,L,D): dir(D) } 1 :- holds(T, env(empty,L)), holds(T,in(agent,L)), time(T), not holds(T,carry_gold).

:- goal(T,move,(X,Y),(DX,DY)), 
   holds(T,env(wall,((X,Y),(X+DX,Y+DY)))), time(T),dir((DX,DY)).
  
:- goal(T,move,(X,Y),(DX,DY)), 
   holds(K,in(agent,(X+DX,Y+DY))), time(T), ext_time(K), T > K, dir((DX,DY)). 

% :- goal(T,move,(X,Y),(DX,DY)), 
%    holds(T,carry_gold(_)), 
%    not occurs(K,env(agent,(X+DX,Y+DY))), 
%    time(T), ext_time(K), T > K.
  
:- goal(T,move,_,_), holds(T,carry_gold(_)), distance(T,D), max_distance(T,MX), D > MX.

distance(T,D) :- D = XD+YD, occurs(0, env(agent,(X',Y'))), goal(T,move,(X,Y),(DX,DY)), 
                     XD = |(X+DX)-X'|, YD = |(Y+DY)-Y'|.

max_distance(T,D) :- D = XD+YD, occurs(0, env(agent,(X',Y'))), goal(T,move,(X,Y),(DX,DY)), 
                     XD = |X-X'|, YD = |Y-Y'|.

     
%:- goal(T,explore,L,D), holds(T,carry_gold(_)), time(T), ext_time(K), T > K, not holds(K, in(agent)) . 

 

% IF SPARKLE -> goal is to grab gold 
%%%%%%%%%%%%%%%%%%%%%%%
goal(T,grab_gold,L) :- holds(T,env(sparkle,L)), holds(T,in(agent,L)), time(T).

% IF EMPTY and Grabbed GOLD -> move along the know path to start. 
%%%%%%%%%%%%%%%%%%%%%%%

% goal(T,leave,(X,Y),(X',Y')) :- holds(T-1, carry_gold(_)), holds(K, in(agent,(X',Y'))), 
%                       holds(T,in(agent,(X,Y))), time(T), ext_time(K), T > K, adjacent((X,Y),(X',Y')). 



% IF BREEZE -> try to confirm PIT
%%%%%%%%%%%%%%%%%%%%%%%


% IF SMELL -> try to confirm WUMPUS
%%%%%%%%%%%%%%%%%%%%%%%


% IF PIT confirmed -> move arround
%%%%%%%%%%%%%%%%%%%%%%%


% IF Wumpus -> Kill it
%%%%%%%%%%%%%%%%%%%%%%%

% IF Grabbed GOLD + reached exit
goal(T,escaped) :- holds(T,in(agent,L)), holds(K, in(agent,L)), K == 0, T > K. 
:- goal(T,escaped).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACT : Exectute part of the plan: update knowledge base; Back to observe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IF EMPTY
%%%%%%%%%%%%%%%%%%%%%%
occurs(T,move(agent,(X,Y),(X+DX,Y+DY) )) :- goal(T,move,(X,Y),(DX,DY)). 


% IF SPARKLE
%%%%%%%%%%%%%%%%%%%%%%

occurs(T, grab_gold(agent,L)) :- goal(T, grab_gold,L). 

% IF CARRY GOLD
%%%%%%%%%%%%%%%%%%%%%%
% occurs(T,move(agent,L,L')) :- goal(T,leave,L,L').

% IF BREEZE
%%%%%%%%%%%%%%%%%%%%%%


% IF SMELL
%%%%%%%%%%%%%%%%%%%%%%



% UPDATE KNOWLEDGE
%%%%%%%%%%%%%%%%%%%%%%%

holds(T+1, in(agent,L)) :- occurs(T,move(agent,OL,L)).
holds(T+1, in(agent,L)) :- occurs(T,grab_gold(agent,L)).
holds(T+1, env(empty,L)) :- occurs(T,grab_gold(agent,L)).
-holds(T+1, env(sparkle,L)) :- occurs(T,grab_gold(agent,L)).

observed(T, true, carry_gold(L)) :- occurs(T,grab_gold(agent,L)).


