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
% agent_map((0..5,0..5)).
agent_map(L)           :- holds(T,in(agent,L)).
agent_map((X+DX,Y+DY)) :- holds(T,in(agent,(X,Y))),
                          dir((DX,DY)). 

env(breeze). env(smell). env(sparkle).  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% initial location, based on first return from environment at time 0:
%holds(T,in(agent,L)) :- holds(T, in(agent, L)), current_time(T). 

holds(0, env(arrow,1)).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % REALITY CHECK AXIOMS / Occurence-Awareness Axioms
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(T, F)     :- observed(T, true, F).
-holds(T,F)     :- observed(T, false,F).

happened(T, F)  :- observed(T, true, F). 
%occurs(T, F)    :- happened(T, F).

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
                                               holds(T, env(pit,PL)), 
                                               not holds(T,env(wall,(L,L'))), 
                                               adjacent(L,L'),
                                               adjacent(L,PL),  
                                               PL != L'. 

% Adjacents of smell and breeze not safe initialy
%%%%%%%%%%%%%%%%%%%%%%%%% 
observed(T, false, env(safe,L'))            :- holds(T,env(smell,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T, env(safe,L)),
                                               adjacent(L,L'). 

observed(T, false, env(safe,L'))            :- holds(T,env(breeze,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T,env(safe,L)),
                                               adjacent(L,L').

% Assume wumpus or pit to be adjacent from S or B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
observed(T, true, env(assume(wumpus),L'))   :- holds(T,env(smell,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T, env(safe,L')), 
                                               not holds(T,env(wumpus,L')), 
                                               not holds(T, env(wall,(L,L'))),
                                               adjacent(L,L').


observed(T, true, env(assume(pit),L'))      :- holds(T,env(breeze,L)), 
                                               holds(T,in(agent,L)), 
                                               not holds(T, env(safe,L')), 
                                               not holds(T, env(pit,L')), 
                                               not holds(T, env(wall,(L,L'))),
                                               adjacent(L,L').
 
%safe location that are adjacent are not to be assumed wumpus or pit             
% DO I  keep this?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


observed(T, false, env(assume(wumpus),L'))  :- holds(T, in(agent,L)), 
                                               holds(T,env(safe,L')), time(T), 
                                               adjacent(L,L').


                                        
observed(T, false, env(assume(pit),L'))     :- holds(T, in(agent,L)), 
                                               holds(T,env(safe,L')), 
                                               time(T), 
                                               adjacent(L,L').


% If two S or B observed only shared adjacent is wumpus or pit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
observed(T, true, env(wumpus,L))            :- holds(T,env(smell, B)), 
                                               holds(T, env(smell,B')), 
                                               holds(T,env(assume(wumpus),L)),
                                               not holds(T,env(safe,L)), 
                                               adjacent(B,L), 
                                               adjacent(B',L), 
                                               B != B'.

  
observed(T, true, env(pit,L))               :- holds(T,env(breeze, B)), 
                                               holds(T, env(breeze,B')),
                                               holds(T,env(assume(pit),L)),  
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
holds(T, env(safe,SL))            :- -holds(T, env(assume(wumpus), SL)),  
                                     holds(T, env(wumpus,WL)), 
                                     not holds(T,env(wall,(WL,SL))),
                                     WL != SL, 
                                     adjacent(WL,SL),  
                                     agent_map(SL).
                                    

holds(T, env(safe,SL))            :- -holds(T, env(assume(pit), SL)),  
                                     holds(T, env(pit,WL)), 
                                     not holds(T,env(wall,(WL,SL))),
                                     WL != SL, 
                                     adjacent(WL,SL),  
                                     agent_map(SL).

% Belief that WUMPUS is at WL if there are no more assumed wumpus 
% locations i.e corner case.
holds(T, env(wumpus,WL))         :- holds(T,env(assume(wumpus),WL)),
                                    holds(T,env(smell,SL)),
                                    not holds(T,env(assume(wumpus),ZL)),                               
                                    -holds(T,env(assume(wumpus),NA)),
                                    not holds(T, env(smell,L)),
                                    holds(T,in(agent,L)),
                                    adjacent(SL,NA),
                                    adjacent(L,NA),
                                    adjacent(SL,WL),
                                    adjacent(SL,ZL),
                                    WL != NA, SL != L, ZL != WL. 

-holds(T+1,env(assume(wumpus),L)) :- holds(T,env(smell, S)),
                                     holds(T,env(wumpus,WL)),
                                     holds(T, env(assume(wumpus),L)),  
                                     adjacent(S,L), 
                                     adjacent(S,WL), 
                                     WL != L.
                                    
-holds(T+1,env(assume(wumpus),L)) :- holds(T,env(wumpus,L)), 
                                     holds(T, env(assume(wumpus),L)).

% Belief that WUMPUS is at WL if there are no more assumed wumpus 
% locations i.e corner case.

holds(T, env(pit,PL))            :- holds(T,env(assume(pit),PL)),
                                    holds(T,env(breeze,BL)),
                                    not holds(T,env(assume(pit),ZL)),                               
                                    -holds(T,env(assume(pit),NA)),
                                    not holds(T, env(breeze,L)),
                                    holds(T,in(agent,L)),
                                    adjacent(BL,NA),
                                    adjacent(L,NA),
                                    adjacent(BL,PL),
                                    adjacent(BL,ZL),
                                    PL != NA, BL != L, ZL != PL. 

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


holds(T, carry_gold(G))           :- occurs(T,grab_gold(G)), holds(T, in(agent,G)).
holds(T+1, carry_gold(G))         :- holds(T, carry_gold(G)), holds(T+1, in(agent,_)). 
 
-holds(T+1, env(sparkle,G))       :- occurs(T,grab_gold(G)), holds(T, in(agent,G)).

holds(T, env(dead_wumpus,W))      :- holds(T, env(wumpus_yell,W)).

-holds(T, env(wumpus,W))          :- holds(T, env(dead_wumpus,W)).

-holds(T+1, env(smell,L))         :- -holds(T,env(wumpus,W)),
                                     holds(T, env(smell,L)),
                                     adjacent(W,L).
                                    
holds(T,env(safe,W))              :- holds(T, env(dead_wumpus,W)).

-holds(T+1,env(assume(wumpus),AW)):- holds(T, env(dead_wumpus,W)),
                                     holds(T, env(smell,SL)),
                                     holds(T, env(assume(wumpus),AW)),
                                     adjacent(W,SL), 
                                     adjacent(AW,SL),
                                     W != AW.
                                    
-holds(T+1, env(arrow,N))         :- occurs(T, kill_wumpus(_,_)),
                                     holds(T, env(arrow,N)), time(T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THINK: select an approriate Goal, G
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1{occurs(T,A): action(T,A), time(T))}1. 


action(T, explore(L,L'))               :- holds(T, in(agent,L)),
                                       holds(T, env(safe,L')),
                                       not holds(T,env(wall,(L,L'))),
                                       not holds(_,in(agent,L')),
                                       not holds(_,env(exit,L')), 
                                       adjacent(L,L'), 
                                       time(T).

action(T, move_back(L,L'))             :- holds(T, in(agent,L)),
                                       holds(T, env(safe,L')),
                                       holds(_, in(agent,L')),
                                       %not occurs(T,leave(L,L')),
                                       not holds(T,env(wall,(L,L'))),
                                       adjacent(L,L'),
                                       time(T).
                                       

action(T, grab_gold(L))             :- holds(T, in(agent,L)),
                                       holds(T, env(sparkle,L)),
                                       time(T). 



action(T, escape(L,L'))               :- holds(T, in(agent,L)),
                                       holds(T, env(exit,L')), 
                                       holds(T, env(start,L)), 
                                       %holds(T, env(carry_gold,_)),
                                       T > 0. 


action(T, kill_wumpus((X,Y'),(X,Y)))          :- holds(T, env(wumpus,(X,Y))),
                                                 holds(T, in(agent,(X,Y'))),
                                                 holds(T, env(arrow,N)),
                                                 not holds(T,env(dead_wumpus,(X,Y))),
                                                 | Y'| - |Y| <= 3,
                                                 Y != Y',
                                                 N > 0.

action(T, kill_wumpus((X',Y),(X,Y)))          :- holds(T, env(wumpus,(X,Y))),
                                                 holds(T, in(agent,(X',Y))),
                                                 holds(T, env(arrow,N)),
                                                 time(T),
                                                 not holds(T,env(dead_wumpus,(X,Y))),
                                                 |X'| - |X| <= 3, 
                                                 X != X',
                                                 N > 0.   
                                       
:- action(T, explore(L,L')), 
   holds(T-1,in(agent,L')).

