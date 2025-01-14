#program base.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dir((DX, DY))               :- DX = -1..1, 
                               DY = -1..1, 
                               |DX|+|DY| == 1.

adjacent(0,(X,Y),(X+DX,Y+DY)) :- holds(0,in(agent,(X,Y))), 
                                 dir((DX, DY)). 

holds(0,env(safe,L)) :- adjacent(0,L',L), 
                        holds(0,in(agent,L')), 
                        not holds(0,env(wall,(L',L))).

holds(0,env(safe,L)) :- holds(0,in(agent,L)).
env(breeze). env(smell). env(sparkle).  

holds(0,in(agent,L)) :- init_env(0,in(agent,L)).

holds(0,env(E,L)) :- init_env(0,env(E,L)).

holds(0,treasure(1)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program step(t).
#external query(t).
#external check(t).

#external envholds(t,env(empty,L)) : holds(t,in(agent,L)).
#external envholds(t,env(wall,(L,L'))) : holds(t,in(agent,L)),adjacent(t,L,L').
#external envholds(t,env(sparkle,L)) : holds(t,in(agent,L)).
#external envholds(t,env(breeze,L)) : holds(t, in(agent,L)).
#external envholds(t,env(smell,L)) : holds(t, in(agent,L)).
#external envholds(t,env(dead_wumpus_yell, L)) : holds(t,env(wumpus,L)),adjacent(_,_,L).
#external envholds(t,env(goal_reached,EXIT)) : holds(t,env(exit,EXIT)).

adjacent(t,(X,Y),(X+DX,Y+DY)) :- holds(t,in(agent,(X,Y))), 
                                 dir((DX, DY)). 

holds(t,treasure(F)) :- holds(t-1,treasure(F)), not holds(t,carry_gold).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% REALITY CHECK AXIOMS / Occurence-Awareness Axioms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(t, F)     :- observed(t, true, F).
-holds(t,F)     :- observed(t, false,F).

:- holds(t,F),  observed(t, false, F).
:- -holds(t,F), observed(t, true, F).

happened(t,F)  :- observed(t, true, F). 
happened(t,agent(L,A)) :-  holds(t-1,in(agent,L)), occurs(t-1,A). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OBSERVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

observed(t, true, env(E,L)) :- envholds(t,env(E,L)).
observed(t, false,env(E,L)) :- envholds(t,env(empty,L)), env(E). 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THINK: select an approriate Goal, G
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Update knowledge base
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(t,env(E,L))                 :- holds(t-1,env(E,L)), 
                                     not -holds(t,env(E,L)).

-holds(t,env(E,L))                :- -holds(t-1,env(E,L)), 
                                     not holds(t,env(E,L)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reason about Observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Observed to be safe based on Agent location: 
holds(t, env(safe,L ))             :- holds(t-1,env(empty,L)), 
                                               holds(t-1,in(agent,L)), 
                                               not holds(t,env(exit,L)).

holds(t,env(safe,L'))              :- holds(t-1,env(empty,L)), 
                                               holds(t-1, in(agent,L)), 
                                               not holds(t,env(wall,(L,L'))), 
                                               adjacent(_,L,L').

holds(t,env(safe,L ))              :- holds(t-1,env(sparkle,L)), 
                                               holds(t-1,in(agent,L)).

holds(t,env(safe,L'))              :- holds(t-1,env(sparkle,L)), 
                                               holds(t-1, in(agent,L)), 
                                               not holds(t,env(wall,(L,L'))), 
                                               adjacent(_,L,L').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PIT / BREEZE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
holds(t, env(assume(pit),L'))      :- holds(t-1,env(breeze,L)),
                                      holds(t-1,in(agent,L)), 
                                      not holds(t, env(safe,L')), 
                                      not holds(t-1, env(pit,L')),
                                      not holds(t-1, env(wall,(L,L'))),
                                      adjacent(_,L,L').


holds(t, env(pit,L))               :- holds(t-1,env(breeze, B)), 
                                      holds(t-1,in(agent,B)),
                                      holds(t-1,env(breeze,B')),
                                      holds(t-1,env(assume(pit),L)),
                                      not holds(t-1,env(safe,L)), 
                                      adjacent(_,B,L), 
                                      adjacent(_,B',L), 
                                      B != B'.


holds(t,env(safe,L))               :- holds(t,env(breeze, B)),
                                      holds(t,env(pit,WL)), 
                                      % holds(t-1,in(agent,B)),
                                      not holds(t, env(wall,(B,L))),
                                      %holds(t, env(assume(pit),L)),
                                      adjacent(_,B,L), 
                                      adjacent(_,B,WL), 
                                      WL != L.

-holds(t,env(assume(pit),L))       :- holds(t-1,env(breeze, B)),
                                      %holds(t-1,in(agent,B)), 
                                      holds(t-1,env(pit,WL)),  
                                      holds(t-1, env(assume(pit),L)),
                                      adjacent(_,B,L), 
                                      adjacent(_,B,WL), 
                                      WL != L.

holds(t,env(safe,L)) :- -holds(t,env(assume(pit),L)), not holds(t-1,env(pit,L)).
-holds(t,env(assume(pit),L)) :- holds(t,env(safe,L)), holds(t-1,env(assume(pit),L)). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% WUMPUS / SMELL  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
holds(t, env(assume(wumpus),L'))      :- holds(t-1,env(smell,L)),
                                      holds(t-1,in(agent,L)), 
                                      not holds(t-1, env(safe,L')), 
                                      not holds(t-1, env(wumpus,L')),
                                      not holds(t-1, env(wall,(L,L'))),
                                      adjacent(_,L,L').


holds(t, env(wumpus,L))               :- holds(t-1,env(smell, B)), 
                                      holds(t-1,in(agent,B)),
                                      holds(t-1,env(smell,B')),
                                      holds(t-1,env(assume(wumpus),L)),
                                      not holds(t-1,env(safe,L)), 
                                      adjacent(_,B,L), 
                                      adjacent(_,B',L), 
                                      B != B'.


holds(t,env(safe,L))               :- holds(t,env(smell, B)),
                                      holds(t,env(wumpus,WL)), 
                                      % holds(t-1,in(agent,B)),
                                      not holds(t, env(wall,(B,L))),
                                      %holds(t, env(assume(wumpus),L)),
                                      adjacent(_,B,L), 
                                      adjacent(_,B,WL), 
                                      WL != L.

-holds(t,env(assume(wumpus),L))       :- holds(t-1,env(smell, B)),
                                      %holds(t-1,in(agent,B)), 
                                      holds(t-1,env(wumpus,WL)),  
                                      holds(t-1, env(assume(wumpus),L)),
                                      adjacent(_,B,L), 
                                      adjacent(_,B,WL), 
                                      WL != L.

holds(t,env(safe,L)) :- -holds(t,env(assume(wumpus),L)), not holds(t-1,env(wumpus,L)).

-holds(t,env(assume(wumpus),L)) :- holds(t,env(safe,L)), holds(t-1,env(assume(wumpus),L)). 

-holds(t,env(wumpus,L))             :- holds(t-1,env(dead_wumpus_yell,L)), 
                                       holds(t-1,env(wumpus,L)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
1{occurs(t,A): action(A)}1.  

action(up;down;left;right;grab_gold;shoot_left;shoot_right;shoot_up;shoot_down;leave).

%% Movement
holds(t,in(agent,(X+1,Y))) :- occurs(t,right), holds(t-1,in(agent,(X,Y))),adjacent(_,(X,Y),(X+1,Y)).
holds(t,in(agent,(X-1,Y))) :- occurs(t,left), holds(t-1,in(agent,(X,Y))),adjacent(_,(X,Y),(X-1,Y)).
holds(t,in(agent,(X,Y-1))) :- occurs(t,up), holds(t-1,in(agent,(X,Y))),adjacent(_,(X,Y),(X,Y-1)).
holds(t,in(agent,(X,Y+1))) :- occurs(t,down), holds(t-1,in(agent,(X,Y))),adjacent(_,(X,Y),(X,Y+1)).

:- occurs(t,right), holds(t-1,in(agent,(X,Y))), not holds(t,env(safe,(X+1,Y))).%,(X+1,Y))).
:- occurs(t,left), holds(t-1,in(agent,(X,Y))), not holds(t,env(safe,(X-1,Y))).
:- occurs(t,down), holds(t-1,in(agent,(X,Y))), not holds(t,env(safe,(X,Y+1))).
:- occurs(t,up), holds(t-1,in(agent,(X,Y))), not holds(t,env(safe,(X,Y-1))).


% :- holds(t,env(wall,(L,L'))), holds(t,in(agent,L')), holds(t-1, in(agent,L)), adjacent(_,L,L').

%% Interaction with Environment - Gold
holds(t,in(agent,L)) :- occurs(t,grab_gold), holds(t-1,in(agent,L)), holds(t-1,env(sparkle,L)).
holds(t, carry_gold) :- occurs(t,grab_gold), holds(t-1,in(agent,L)), holds(t-1,env(sparkle,L)).
holds(t, carry_gold) :- holds(t-1, carry_gold).

:- occurs(t,grab_gold), not holds(t-1,env(sparkle,L)), holds(t-1,in(agent,L)).

%% Interaction with Environment - Wumpus
holds(t,in(agent,L)) :- occurs(t,shoot_right), holds(t-1,in(agent,L)).
holds(t,in(agent,L)) :- occurs(t,shoot_left), holds(t-1,in(agent,L)).
holds(t,in(agent,L)) :- occurs(t,shoot_down), holds(t-1,in(agent,L)).
holds(t,in(agent,L)) :- occurs(t,shoot_up), holds(t-1,in(agent,L)).

:- occurs(t,shoot_left), not holds(t,env(wumpus,(X-1,Y))), holds(t-1,in(agent,(X,Y))).%, |X'| - |X| >= 2. %, X != X'. %,  N > 0.
:- occurs(t,shoot_right), not holds(t,env(wumpus,(X+1,Y))), holds(t-1,in(agent,(X,Y))).
:- occurs(t,shoot_up), not holds(t,env(wumpus,(X,Y-1))), holds(t-1,in(agent,(X,Y))).
:- occurs(t,shoot_down), not holds(t,env(wumpus,(X,Y+1))), holds(t-1,in(agent,(X,Y))).

%%%% EXIT

holds(t,in(agent,EXIT)) :- occurs(t,leave), holds(t-1,in(agent,L)),holds(_,env(exit,EXIT)), adjacent(_,L,EXIT).
:- occurs(t,leave), not holds(t-1,carry_gold).


% goal(t):- #count{F:holds(t, treasure(F))}==0, query(t).
% :-check(t), query(t), not goal(t).

% goal(t) :- holds(t-1,in(agent,(2,2))), query(t). %, init_env(0,env(exit,(0,1))), holds(t-1,carry_gold).
% :- not goal(t), query(t).
