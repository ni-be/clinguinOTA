% TODO 
% WHEN BREEZE AND GOLD SAME LOCATION

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
observed(T, true, env(safe,L )) :- holds(T,env(empty,L)), holds(T,in(agent,L)), not holds(T,env(exit,L)).
observed(T, true, env(safe,L')) :- holds(T,env(empty,L)), adjacent(L,L'),holds(T, in(agent,L)), not holds(T,env(wall,(L,L'))).
observed(T, true, env(safe,L )) :- holds(T,env(sparkle,L)), holds(T,in(agent,L)).

% right now have to add not holds(safe, L), otherwise constant recheck
observed(T, false, env(safe,L')):- holds(T,env(breeze,L)), adjacent(L,L'), holds(T,in(agent,L)), not holds(T,env(safe,L)).
observed(T, false, env(safe,L')):- holds(T,env(smell,L)), adjacent(L,L'), holds(T,in(agent,L)), not holds(T, env(safe,L)).

% ASSUME a Pit or Wumpus to be at an adjacent location of the smell, that we have not yet visited. 
observed(T, true, env(assume(pit),L'))  :- holds(T,env(breeze,L)), adjacent(L,L'), holds(T,in(agent,L)), 
                                           not holds(T, env(safe,L')), not holds(T, env(pit,L')), not holds(T, env(wall,(L,L'))).
                                          
observed(T, false, env(assume(pit),L'))  :- holds(T, in(agent,L)), holds(T,env(safe,L')), time(T), adjacent(L,L').
observed(T, true, env(safe,L')) :- holds(T,in(agent,L)), adjacent(L,L'), holds(T,env(breeze,L)), adjacent(L,WL), holds(T, env(pit,WL)), WL != L'. 

observed(T, true, env(assume(wumpus),L'))  :- holds(T,env(smell,L)), adjacent(L,L'), holds(T,in(agent,L)), not holds(T, env(safe,L')), 
                                              not holds(T,env(wumpus,L')), not holds(T, env(wall,(L,L'))).

observed(T, false, env(assume(wumpus),L'))  :- holds(T, in(agent,L)), holds(T,env(safe,L')), time(T), adjacent(L,L').
observed(T, true, env(safe,L')) :- holds(T,in(agent,L)), adjacent(L,L'), holds(T,env(smell,L)), adjacent(L,WL), holds(T, env(wumpus,WL)), WL != L'. 

% If 2 breezes are known and they share an adjacent that shared adjacent should be a pit
observed(T, true, env(pit,L)):- holds(T,env(breeze, B)), holds(T, env(breeze,B')), adjacent(B,L), adjacent(B',L), B != B', not holds(T,env(safe,L)).
observed(T, true, env(wumpus,L)):- holds(T,env(smell, B)), holds(T, env(smell,B')), adjacent(B,L), adjacent(B',L), B != B', not holds(T,env(safe,L)).

-holds(T,env(assume(pit),L)) :- holds(T,env(breeze, B)), holds(T, env(breeze,B')), adjacent(B,L), adjacent(B',L), B != B', holds(T-1, env(assume(pit), L)), holds(T,in(agent,B)).
-holds(T,env(assume(wumpus),L)) :- holds(T,env(smell, B)), holds(T, env(smell,B')), adjacent(B,L), adjacent(B',L), B != B', holds(T-1, env(assume(wumpus), L)), holds(T,in(agent,B)).


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Update knowledge base
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

holds(T,env(E,L)) :- holds(T-1,env(E,L)), not -holds(T,env(E,L)), time(T).
-holds(T,env(E,L)) :- -holds(T-1,env(E,L)), not holds(T,env(E,L)), time(T).

holds(T,env(E,L)) :- holds(T,in(E,L)).

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% THINK: select an approriate Goal, G
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % IF EMPTY -> explore / move to new field if possible else move back
% %%%%%%%%%%%%%%%%%%%%%%%



1{ goal(T,explore,(L,L')): adjacent(L,L')} 1:- holds(T,in(agent,L)), time(T), not holds(T, env(carry_gold,_)), not goal(T,move_back,_).
% 1{ goal(T,explore,(L,L')): adjacent(L,L'), not occurs(T-2, move(agent, L, L'))} 1:- holds(T,in(agent,L)), time(T), not holds(T, env(carry_gold,_)).

:- goal(T,explore,(L,L')), 
   holds(T,env(wall,(L,L'))), adjacent(L,L'), holds(T, in(agent,L)).

:- goal(T, explore,(L,L')), not holds(T,env(safe,L')).

:- goal(T,explore,(L,L')), 
    holds(T-1,in(agent,L')), adjacent(L,L'). %, goal(T-1, move_back,(L',L)). 


% IF SPARKLE -> goal is to grab gold 
%%%%%%%%%%%%%%%%%%%%%%%
goal(T,grab_gold,L) :- holds(T,env(sparkle,L)), holds(T,in(agent,L)).

% LEAVE ON KNOWN PATH 
%%%%%%%%%%%%%%%%%%%%%%%

1{ goal(T,leave,(L,L')): adjacent(L,L') } 1 :- holds(T, in(agent,L)), holds(T, env(carry_gold,_)). 

:- goal(T,leave,(L,L')), 
   holds(T,env(wall,(L,L'))), adjacent(L,L'), holds(T, in(agent,L)).

% when leaving go to those room the agent was already in. 
:- goal(T,leave,(L,L')), 
   not holds(_,in(agent,L')), adjacent(L,L'). 
   % need to add safe condition in there as well. 

% use manhatten distance to find back to exit

:- goal(T,leave,((X,Y),(X',Y'))), holds(T,env(exit,(EX,EY))), ND = |X' - EX| + |Y' - EY|, OD = | X-EX| + |Y-EY|, ND > OD.

%%%%%%%%%%%%%%%%%%%%%%%


goal(T, move_back,(L,BL)) :- holds(T,in(agent,L)), 
                             holds(T-1,in(agent,BL)), 
                             holds(T,env(safe,BL)), 
                             holds(T,env(assume(wumpus),L')),
                             not holds(T, env(wumpus,L')),
                             holds(T,env(smell,L)),  
                             adjacent(L,L'), adjacent(L,BL), time(T), L' != BL.

goal(T, move_back,(L,BL)) :- holds(T,in(agent,L)), 
                             holds(T-1,in(agent,BL)), 
                             holds(T,env(safe,BL)), 
                             holds(T,env(assume(pit),L')),
                             not holds(T, env(pit,L')),
                             holds(T, env(breeze,L)),  
                             adjacent(L,L'), adjacent(L,BL), time(T), L' != BL.

%%%%%%%%%%%%%%%%%%%%%%

% IF Grabbed GOLD + reached exit
goal(T,escaped(agent,L')) :- occurs(T,move(agent,_,L)),holds(T,env(exit,L')), holds(T, env(start,L)), holds(T, env(carry_gold,_)). 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% ACT : Exectute part of the plan: update knowledge base; Back to observe
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Move and Escpae
%%%%%%%%%%%%%%%%%%%%%%%
occurs(T,move(agent,L,L' )) :- goal(T,explore,(L,L')), not goal(T, grab_gold, L). 
occurs(T,move(agent,L,L'))  :- goal(T,leave,  (L,L')), not goal(T, grab_gold, L ).
occurs(T,escape(agent,L)) :- goal(T, escaped(agent,L)). 
occurs(T,move(agent,L,L')) :- goal(T,move_back,(L,L')).
occurs(T, move(agent,L,L')) :- goal(T,move_arround,(L,L')).  

% IF SPARKLE
%%%%%%%%%%%%%%%%%%%%%%
occurs(T, grab_gold(agent,L)) :- goal(T, grab_gold,L). 
holds(T, env(carry_gold,G)) :- occurs(T,grab_gold(agent,G)). 


% % UPDATE KNOWLEDGE not needed anymore, since location data will be updated in env. 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%holds(T, in(agent,L)) :- occurs(T,move(agent,OL,L)), time(T).
% %holds(T, in(agent,L)) :- occurs(T,grab_gold(agent,L)).
% %holds(T, env(empty,L)) :- occurs(T,grab_gold(agent,L)).
% %-holds(T, env(sparkle,L)) :- occurs(T,grab_gold(agent,L)).

% observed(T, true, carry_gold(L)) :- occurs(T,grab_gold(agent,L)).


