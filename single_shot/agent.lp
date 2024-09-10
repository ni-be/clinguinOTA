% AGENT ENCODING WUMPUS
current_time(T) :- T = #max{T2 : time(T2)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WORLD RULES
dir((DX, DY)) :- DX = -1..1, DY = -1..1, |DX|+|DY| == 1.
adjacent((X, Y), (X+DX, Y+DY)) :- holds(_,in(agent,(X,Y))), dir((DX, DY)). %X+DX = X', Y+DY = Y', DX != DY.

env(breeze). env(smell). env(sparkle).  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% initial location, based on first return from environment at time 0:
%holds(T,in(agent,L)) :- holds(T, in(agent, L)), current_time(T). 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % REALITY CHECK AXIOMS / Occurence-Awareness Axioms
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(T, F) :- observed(T, true, F).
-holds(T,F) :- observed(T, false,F).

:- holds(T,F), observed(T, false, F).
:- -holds(T,F), observed(T, true, F).

happened(T, F) :- observed(T, true, F). 
occurs(T, F) :- happened(T, F).

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% OBSERVE, explain Observations, update Knowledge base
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Get new information from the Environment
% %
% % If the environment return E for location L 
% % at time T, it is true.
% % If an env(empty,L) is returned there is 
% % nothing except possible walls in that room.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

observed(T, true, env(E,L)) :- envholds(T,env(E,L)), time(T).
observed(T, false,env(E,L)) :- envholds(T,env(empty,L)), 
                               holds(T,in(agent,L)), env(E), time(T).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Explain observations
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % %ASSUME SAFE
% % holds(T,know(safe,L)) :- holds(T,env(empty,L)), holds(T,in(agent,L)).
% % holds(T,know(safe,L')) :- holds(T,env(empty,L)), adjacent(L,L'),holds(T, in(agent,L)).
% % holds(T,know(safe,L)) :- holds(T,env(sparkle,L)), holds(T,in(agent,L)).
 
% % -holds(T, know(safe,L')):- holds(T,env(breeze,L)), adjacent(L,L'), holds(T,in(agent,L)).
% % -holds(T, know(safe,L')):- holds(T,env(smell,L)), adjacent(L,L'), holds(T,in(agent,L)).


% % % ASSUME a Pit or Wumpus to be at an adjacent location of the smell, that we have not yet visited. 
% % holds(T, assume(pit,L')):- holds(T,env(breeze,L)), adjacent(L,L'), holds(T,in(agent,L)).
% % holds(T, assume(wumpus,L')):- holds(T,env(smell,L)), adjacent(L,L'), holds(T,in(agent,L)).



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Update knowledge base
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


holds(T,env(E,L)) :- holds(T-1,env(E,L)), not -holds(T,env(E,L)), time(T).
-holds(T,env(E,L)) :- -holds(T-1,env(E,L)), not holds(T,env(E,L)), time(T).


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% THINK: select an approriate Goal, G; Find a plan, to achieve G
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % IF EMPTY -> explore / move to new field if possible else move back
% %%%%%%%%%%%%%%%%%%%%%%%

1{ goal(T,explore,(L,L')): adjacent(L,L')} 1:- holds(T,in(agent,L)), time(T).



:- goal(T,explore,(L,L')), 
   holds(T,env(wall,(L,L'))), adjacent(L,L'), holds(T, in(agent,L)).

:- goal(T,explore,(L,L')), 
   holds(T-1,in(agent,L')), adjacent(L,L'). %, -holds(T,know(safe,(X+DX,Y+DY))). 

% :- goal(T, explore, (_,_)), goal(T',grab_gold, _), T < T' . 

% % :- goal(T,explore,((X,Y),(DX,DY))), 
% %    holds(T,in(agent,(X+DX,Y+DY))), time(K), current_time(T), T > K, dir((DX,DY)), not holds(T-1,know(safe,(X+DX,Y+DY))). 


% % IF SPARKLE -> goal is to grab gold 
% %%%%%%%%%%%%%%%%%%%%%%%
goal(T,grab_gold,L) :- holds(T,env(sparkle,L)), holds(T,in(agent,L)).



% % IF EMPTY and Grabbed GOLD -> move along the know path to start. 
% %%%%%%%%%%%%%%%%%%%%%%%

% %1{ goal(T,leave,(L,D)): dir(D)}1 :- holds(T,in(agent,L)), holds(T, carry_gold(_)), time(T). 
% %:- goal(T,leave,((X,Y),(DX,DY))), 
% %   holds(T,env(wall,((X,Y),(X+DX,Y+DY)))), current_time(T),dir((DX,DY)).

% % IF BREEZE -> try to confirm PIT
% %%%%%%%%%%%%%%%%%%%%%%%


% % IF SMELL -> try to confirm WUMPUS
% %%%%%%%%%%%%%%%%%%%%%%%


% % IF PIT confirmed -> move arround
% %%%%%%%%%%%%%%%%%%%%%%%


% % IF Wumpus -> Kill it
% %%%%%%%%%%%%%%%%%%%%%%%

% % IF Grabbed GOLD + reached exit
% %goal(T,escaped) :- holds(T,in(agent,L)), holds(K, in(agent,L)), K == 0, T > K. 
% %:- goal(T,escaped).

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% ACT : Exectute part of the plan: update knowledge base; Back to observe
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % IF EMPTY
% %%%%%%%%%%%%%%%%%%%%%%
occurs(T,move(agent,L,L' )) :- goal(T,explore,(L,L')), not goal(T, grab_gold, L). 


% % IF SPARKLE
% %%%%%%%%%%%%%%%%%%%%%%

occurs(T, grab_gold(agent,L)) :- goal(T, grab_gold,L). 
%hold(T, in(carry_gold,G)) :- occurs(T,grab_gold,G). 

% % IF CARRY GOLD
% %%%%%%%%%%%%%%%%%%%%%%

% %occurs(T,move(agent,(X,Y),(X+DX,Y+DY)) ) :- goal(T,leave,((X,Y),(DX,DY))). 

% % IF BREEZE
% %%%%%%%%%%%%%%%%%%%%%%


% % IF SMELL
% %%%%%%%%%%%%%%%%%%%%%%



% % UPDATE KNOWLEDGE not needed anymore, since location data will be updated in env. 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%holds(T, in(agent,L)) :- occurs(T,move(agent,OL,L)), time(T).
% %holds(T, in(agent,L)) :- occurs(T,grab_gold(agent,L)).
% %holds(T, env(empty,L)) :- occurs(T,grab_gold(agent,L)).
% %-holds(T, env(sparkle,L)) :- occurs(T,grab_gold(agent,L)).

% observed(T, true, carry_gold(L)) :- occurs(T,grab_gold(agent,L)).


