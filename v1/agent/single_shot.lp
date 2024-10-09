% AGENT ENCODING WUMPUS
current_time(T) :- T = #max{T2 : time(T2)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WORLD RULES
dir((DX, DY))               :- DX = -1..1, 
                               DY = -1..1, 
                               |DX|+|DY| == 1.
adjacent((X,Y),(X+DX,Y+DY)) :- agent_map((X,Y)), 
                               dir((DX, DY)). 
                               %X+DX = X', 
                               %Y+DY = Y', 
                               %DX != DY.

agent_map(L)           :- holds(T,in(agent,L)).
agent_map((X+DX,Y+DY)) :- holds(T,in(agent,(X,Y))),
                          dir((DX,DY)). 

env(breeze). env(smell). env(sparkle).  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% initial location, based on first return from environment at time 0:
%holds(T,in(agent,L)) :- holds(T, in(agent, L)), current_time(T). 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % REALITY CHECK AXIOMS / Occurence-Awareness Axioms
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(T, F)     :- observed(T, true, F).
-holds(T,F)     :- observed(T, false,F).

happened(T, F)  :- observed(T, true, F). 
occurs(T, F)    :- happened(T, F).

:- holds(T,F),  observed(T, false, F).
:- -holds(T,F), observed(T, true, F).

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explain observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Observed to be safe based on Agent location: 
observed(T, true, env(safe,L ))             :- holds(T,env(empty,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T,env(exit,L)).

observed(T, true, env(safe,L'))             :- holds(T,env(empty,L)), 
                                               holds(T, in(agent,L)), 
                                               not holds(T,env(wall,(L,L'))), 
                                               adjacent(L,L').

observed(T, true, env(safe,L ))             :- holds(T,env(sparkle,L)), 
                                               holds(T,in(agent,L)).


% Observed Safe to be true when on smell, and the adjacent wumpus is known, 
% than the adjacents from agent location are assumed to be safe

observed(T, true, env(safe,L'))             :- holds(T,in(agent,L)),  
                                               holds(T,env(smell,L)), 
                                               holds(T, env(wumpus,WL)),  
                                               not holds(T,env(wall,(L,L'))), 
                                               adjacent(L,L'), 
                                               adjacent(L,WL), 
                                               WL != L'.

observed(T, true, env(safe,L'))             :- holds(T,in(agent,L)), 
                                               holds(T,env(breeze,L)), 
                                               holds(T, env(pit,WL)), 
                                               adjacent(L,L'),
                                               adjacent(L,WL),  
                                               WL != L'. 

% Observed Wumpus related
%%%%%%%%%%%%%%%%%%%%%%%%% 
observed(T, false, env(safe,L'))            :- holds(T,env(smell,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T, env(safe,L)),
                                               adjacent(L,L'). 

observed(T, true, env(assume(wumpus),L'))   :- holds(T,env(smell,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T, env(safe,L')), 
                                               not holds(T,env(wumpus,L')), 
                                               not holds(T, env(wall,(L,L'))),
                                               adjacent(L,L').

observed(T, false, env(assume(wumpus),L'))  :- holds(T, in(agent,L)), 
                                               holds(T,env(safe,L')), time(T), 
                                               adjacent(L,L').


observed(T, true, env(wumpus,L))            :- holds(T,env(smell, B)), 
                                               holds(T, env(smell,B')), 
                                               holds(T,env(assume(wumpus),L)),  
                                               adjacent(B,L), adjacent(B',L), B != B', 
                                               not holds(T,env(safe,L)).
% Observe Pit Related
%%%%%%%%%%%%%%%%%%%%%%%
observed(T, false, env(safe,L'))            :- holds(T,env(breeze,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T,env(safe,L)),
                                               adjacent(L,L').

observed(T, true, env(assume(pit),L'))      :- holds(T,env(breeze,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T, env(safe,L')), 
                                               not holds(T, env(pit,L')), 
                                               not holds(T, env(wall,(L,L'))),
                                               adjacent(L,L').
                                         
observed(T, false, env(assume(pit),L'))     :- holds(T, in(agent,L)), 
                                               holds(T,env(safe,L')), 
                                               time(T), 
                                               adjacent(L,L').

observed(T, true, env(pit,L))               :- holds(T,env(breeze, B)), 
                                               holds(T, env(breeze,B')),
                                               not holds(T,env(safe,L)), 
                                               adjacent(B,L), 
                                               adjacent(B',L), 
                                               B != B'.

% DON'T Know what to do with it for now keep commented
%holds(T, env(safe,SL)) :- holds(T, env(wumpus,WL)), adjacent(WL,SL), holds(T,env(smell,AL)), adjacent(WL,AL), AL != SL, not holds(T,env(wall,(AL,SL))), agent_map(SL).

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Update knowledge base
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A location that was previous assumed to be a Pit or wumpus is safe, if the adjacent wumpus or pit was identified. 
holds(T, env(safe,SL))            :- -holds(T, env(assume(WP), SL)),  
                                     holds(T, env(WP,WL)), 
                                     not holds(T,env(wall,(WL,SL))),
                                     WL != SL, 
                                     adjacent(WL,SL),  
                                     agent_map(SL).

-holds(T+1,env(assume(wumpus),L)) :- holds(T,env(smell, S)),
                                     holds(T,env(wumpus,WL)),
                                     holds(T, env(assume(wumpus),L)),  
                                     adjacent(S,L), 
                                     adjacent(S,WL), 
                                     WL != L.
                                    
-holds(T+1,env(assume(wumpus),L)) :- holds(T,env(wumpus,L)), 
                                     holds(T, env(assume(wumpus),L)).
 
-holds(T+1,env(assume(pit),L))    :- holds(T,env(breeze, B)), 
                                     holds(T,env(pit,WL)),  
                                     holds(T, env(assume(pit),L)),
                                     adjacent(B,L), 
                                     adjacent(B,WL), 
                                     WL != L.

-holds(T+1,env(assume(pit),L))    :- holds(T,env(pit,L)), 
                                     holds(T, env(assume(pit),L)).


holds(T,env(E,L))                 :- holds(T-1,env(E,L)), 
                                     not -holds(T,env(E,L)), 
                                     time(T).

-holds(T,env(E,L))                :- -holds(T-1,env(E,L)), 
                                     not holds(T,env(E,L)), 
                                     time(T).


holds(T, env(carry_gold,G))       :- occurs(T,grab_gold(agent,G)). 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% THINK: select an approriate Goal, G
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % IF EMPTY -> explore / move to new field if possible else move back
% %%%%%%%%%%%%%%%%%%%%%%%

1{ goal(T,explore,(L,L')): adjacent(L,L'), holds(T, in(agent,L)), holds(T, env(safe,L')), not holds(T, env(wall,(L,L')))} 1:- time(T), not holds(T, env(carry_gold,_)), not goal(T,move_back,_), not goal(T,leave,_).

:- goal(T,explore,(L,L')), 
   holds(T,env(wall,(L,L'))), adjacent(L,L'), holds(T, in(agent,L)).

% :- goal(T, explore,(L,L')), not holds(T,env(safe,L')).

:- goal(T,explore,(L,L')), 
    holds(T-1,in(agent,L')), adjacent(L,L'). %, goal(T-1, move_back,(L',L)). 


% IF SPARKLE -> goal is to grab gold 
%%%%%%%%%%%%%%%%%%%%%%%
goal(T,grab_gold,L) :- holds(T,env(sparkle,L)), holds(T,in(agent,L)).

% LEAVE ON KNOWN PATH 
%%%%%%%%%%%%%%%%%%%%%%%

1{ goal(T,leave,(L,L')): adjacent(L,L'), holds(T,env(safe,L')) } 1 :- holds(T, in(agent,L)), holds(T, env(carry_gold,_)). 

:- goal(T,leave,(L,L')), 
   holds(T,env(wall,(L,L'))), 
   holds(T, in(agent,L)),
   adjacent(L,L').

% when leaving go to those room the agent was already in. 
%:- goal(T,leave,(L,L')), 
%   not holds(_,in(agent,L')), adjacent(L,L'). 
   % need to add safe condition in there as well. 

% use manhatten distance to find back to exit

:- goal(T,leave,((X,Y),(X',Y'))), 
   holds(T,env(exit,(EX,EY))), 
   ND = |X' - EX| + |Y' - EY|, 
   OD = | X-EX| + |Y-EY|, 
   ND > OD.

%%%%%%%%%%%%%%%%%%%%%%%


goal(T, move_back,(L,BL)) :- holds(T,in(agent,L)), 
                             holds(T-1,in(agent,BL)), 
                             holds(T,env(safe,BL)), 
                             holds(T,env(assume(wumpus),L')),
                             not holds(T, env(wumpus,L')),
                             not goal(T,leave,_),
                             holds(T,env(smell,L)),  
                             adjacent(L,L'), adjacent(L,BL), time(T), L' != BL.

goal(T, move_back,(L,BL)) :- holds(T,in(agent,L)), 
                             holds(T-1,in(agent,BL)), 
                             holds(T,env(safe,BL)), 
                             holds(T,env(assume(pit),L')),
                             not holds(T, env(pit,L')),
                             not goal(T, leave,_),
                             holds(T, env(breeze,L)),  
                             adjacent(L,L'), adjacent(L,BL), time(T), L' != BL.

%%%%%%%%%%%%%%%%%%%%%%

% IF Grabbed GOLD + reached exit
goal(T,escaped(agent,L')) :- occurs(T,move(agent,_,L)),
                             holds(T,env(exit,L')), 
                             holds(T, env(start,L)), 
                             holds(T, env(carry_gold,_)). 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% ACT : Exectute part of the plan: update knowledge base; Back to observe
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Move and Escpae
%%%%%%%%%%%%%%%%%%%%%%%
occurs(T,move(agent,L,L' ))         :- goal(T,explore,(L,L')), 
                                       not goal(T, grab_gold, L). 
occurs(T,move(agent,L,L'))          :- goal(T,leave,  (L,L')), 
                                       not goal(T, grab_gold, L ).
occurs(T,escape(agent,L))           :- goal(T, escaped(agent,L)). 
occurs(T,move(agent,L,L'))          :- goal(T,move_back,(L,L')).

% IF SPARKLE
%%%%%%%%%%%%%%%%%%%%%%
occurs(T, grab_gold(agent,L))       :- goal(T, grab_gold,L). 

