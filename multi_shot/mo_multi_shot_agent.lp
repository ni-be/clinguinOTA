
#program base.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dir((DX, DY))               :- DX = -1..1, 
                               DY = -1..1, 
                               |DX|+|DY| == 1.

adjacent(0,(X,Y),(X+DX,Y+DY)) :- agent_map(0,(X,Y)), dir((DX,DY)).
holds(0,env(safe,L)) :- adjacent(0,L',L), 
                        holds(0,in(agent,L')), 
                        not holds(0,env(wall,(L',L))).

holds(0,env(safe,L)) :- holds(0,in(agent,L)).
env(breeze). env(smell). env(sparkle).  

holds(0,in(agent,L)) :- init_env(0,in(agent,L)).

holds(0,env(E,L)) :- init_env(0,env(E,L)).

holds(0,arrow(1)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program step(t).
#external query(t).

#external room_contents(t,env(empty,L)) : holds(t,in(agent,L)), not holds(t-1,env(empty,L)).
#external room_contents(t, env(wall,((X,Y),(X+DX,Y+DY)))) : holds(t,in(agent,(X,Y))), dir((DX,DY)). 
#external room_contents(t,env(sparkle,L)) : holds(t,in(agent,L)), not holds(t-1,env(sparkle,L)).
#external room_contents(t,env(breeze,L)) : holds(t, in(agent,L)), not holds(t-1,env(breeze,L)).
#external room_contents(t,env(smell,L)) : holds(t, in(agent,L)), not holds(t-1,env(smell,L)).
#external room_contents(t,env(dead_wumpus_yell,WL)) : holds(t-1,in(agent,L)), adjacent(_,L,WL).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% REALITY CHECK AXIOMS / Occurence-Awareness Axioms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(t,F)      :- observed(t, true, F), holds(t,in(agent,_)).
-holds(t,F)     :- observed(t, false,F), holds(t,in(agent,_)).

:- holds(t,F),  observed(t, false, F).
:- -holds(t,F), observed(t, true, F).

% happened(t,F)          :- observed(t, true, F). 
% happened(t,agent(L,(A,E))) :- holds(t-1,in(agent,L)), occurs(t-1,A,E). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OBSERVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

observed(t, true, env(E,L))         :- room_contents(t,env(E,L)), 
                                       holds(t,in(agent,L)), 
                                       not holds(t-1,env(E,L)).

observed(t, true, env(wall,(L,NL))) :- room_contents(t,env(wall,(L,NL))), 
                                       holds(t,in(agent,L)), 
                                       not holds(t-1,env(wall,(L,NL))).

observed(t, false,env(E,L))         :- room_contents(t,env(empty,L)),
                                       holds(t,in(agent,L)),
                                       holds(t-1,env(E,L)), 
                                       env(E). 

observed(t, true, env(dead_wumpus_yell,WL)) :- room_contents(t,env(dead_wumpus_yell,WL)), 
                                               not holds(t-1,env(dead_wumpus_yell,WL)).

% One could remove the holds(t-1,env(E,L)), but that increases the program
% size significantly. As implemented above something is only observed to be false
% if it was previously observed.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THINK: select an approriate Goal, G
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update unchanged knowledge 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(t,env(E,L))                  :- holds(t-1,env(E,L)), 
                                      not -holds(t,env(E,L)).

-holds(t,env(E,L))                 :- -holds(t-1,env(E,L)), 
                                      not holds(t,env(E,L)).

adjacent(t,(X,Y),(X+DX,Y+DY))      :- occurs(t,move,(_,(X,Y))),
                                      dir((DX, DY)). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reason about SAFETY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(t, env(safe,L ))             :- holds(t,env(empty,L)), 
                                      holds(t,in(agent,L)), 
                                      not holds(t,env(exit,L)).

holds(t,env(safe,NL))              :- holds(t,env(empty,L)), 
                                      holds(t-1, in(agent,L)),    
                                      not holds(t,env(wall,(L,NL))), 
                                      adjacent(_,L,NL).

holds(t,env(safe,L ))              :- holds(t,env(sparkle,L)), 
                                      holds(t-1,in(agent,L)).

holds(t,env(safe,NL))              :- holds(t,env(sparkle,L)), 
                                      holds(t-1, in(agent,L)), 
                                      not holds(t,env(wall,(L,NL))), 
                                      adjacent(_,L,NL).

holds(t,env(safe,SL))              :- holds(t-1,in(agent,B)),
                                      holds(t,env(breeze,B)),
                                      holds(t,env(pit,PL)),
                                      not holds(t,env(wall,(B,SL))),
                                      adjacent(_,B,PL),
                                      adjacent(_,B,SL),
                                      SL != PL.

holds(t,env(safe,SL))              :- holds(t-1,in(agent,B)),
                                      holds(t,env(smell,B)),
                                      holds(t,env(wumpus,WL)),
                                      not holds(t,env(wall,(B,SL))),
                                      adjacent(_,B,WL),
                                      adjacent(_,B,SL),
                                      SL != WL.

holds(t,env(safe,SL))              :- holds(t-1,env(assume(E),SL)),
                                      -holds(t,env(assume(E),SL)),
                                      not holds(t,env(E,SL)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reason about PIT / BREEZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(t, env(pit,PL))              :- holds(t,env(breeze, B)), 
                                      holds(t,in(agent,B)),
                                      holds(t-1,env(breeze,B')),
                                      not holds(t-1,env(safe,PL)),
                                      not holds(t-1,env(empty,PL)),
                                      adjacent(_,EL,PL), 
                                      adjacent(_,B,PL), 
                                      adjacent(_,B',PL), 
                                      B != B'.

holds(t, env(assume(pit),PL))      :- holds(t,env(breeze,L)),
                                      holds(t-1,in(agent,L)), 
                                      not holds(t, env(safe,PL)), 
                                      not holds(t, env(wall,(L,PL))),
                                      not holds(t, env(pit,PL)),
                                      adjacent(_,L,PL).


-holds(t,env(assume(pit),L))       :- holds(t-1,in(agent,E)),
                                      holds(t-1,env(assume(pit),L)),
                                      holds(t,env(safe,L)),
                                      adjacent(_,E,L).

-holds(t,env(assume(pit),L))      :-  holds(t-1,env(assume(pit),L)),
                                      holds(t,env(pit,PL)),
                                      holds(t-1,env(breeze,B)),
                                      adjacent(_,B,PL),
                                      adjacent(_,B,L).

-holds(t,env(assume(pit),L))       :- holds(t-1,env(assume(pit),L)), 
                                      holds(t,env(pit,L)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% REASON about WUMPUS / SMELL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


holds(t, env(wumpus,WL))           :- holds(t,env(smell, B)), 
                                      holds(t,in(agent,B)),
                                      holds(t-1,env(smell,B')),
                                      not holds(t-1,env(safe,WL)),
                                      not holds(t-1,env(empty,WL)),
                                      adjacent(_,EL,WL), 
                                      adjacent(_,B,WL), 
                                      adjacent(_,B',WL), 
                                      B != B'.

holds(t, env(assume(wumpus),WL))   :- holds(t,env(smell,L)),
                                      holds(t-1,in(agent,L)), 
                                      not holds(t, env(safe,WL)), 
                                      not holds(t, env(wall,(L,WL))),
                                      not holds(t, env(wumpus ,WL)),
                                      adjacent(_,L,WL).

-holds(t,env(assume(wumpus),L))    :- holds(t-1,in(agent,E)),
                                      holds(t-1,env(assume(wumpus),L)),
                                      holds(t,env(safe,L)),
                                      adjacent(_,E,L).

-holds(t,env(assume(wumpus),L))    :- holds(t-1,env(assume(wumpus),L)),
                                      holds(t,env(wumpus,WL)),
                                      holds(t-1,env(smell,S)),
                                      adjacent(_,S,WL),
                                      adjacent(_,S,L).

-holds(t,env(assume(wumpus),L))    :- holds(t-1,env(assume(wumpus),L)), 
                                      holds(t,env(wumpus,L)).

-holds(t,env(wumpus,WL))           :- holds(t-1,env(dead_wumpus_yell,WL)),
                                      holds(t-1,env(wumpus,WL)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

1{occurs(t,A,(L,NL)) : action(t,A,(L,NL))}1 :- holds(t-1,in(agent,L)).

%%%%%%%%%%%%%%%%%%%%
%%%% MOVE 
%%%%%%%%%%%%%%%%%%%%

action(t,move,(L,NL))            :- holds(t-1,in(agent,L)), 
                                    adjacent(_,L,NL),
                                    holds(t,env(safe,NL)).
  
holds(t,in(agent,NL))            :- holds(t-1,in(agent,L)),
                                    occurs(t,move,(L,NL)).

:- occurs(t,move,(L,NL)),
   holds(t-1,env(wall,(L,NL))).

:- occurs(t,move,(L,NL)),
   holds(t-1,env(exit,NL)).

%%%%%%%%%%%%%%%%%%%%
%%%% SHOOT 
%%%%%%%%%%%%%%%%%%%%

action(t,shoot,(L,WL))           :- holds(t-1,in(agent,L)),
                                    holds(t,env(wumpus,WL)),
                                    adjacent(_,L,WL).

holds(t,in(agent,NL))            :- holds(t-1,in(agent,NL)),
                                    occurs(t,shoot,(NL,_)).

holds(t, arrow(X-1))             :- occurs(t,shoot,(_,_)),
                                    holds(0,arrow(X)).
                                    
:- action(t,shoot,_), holds(t-1,arrow(0)).
                                       
%%%%%%%%%%%%%%%%%%%%
%%%% GRAB Gold 
%%%%%%%%%%%%%%%%%%%%

action(t,grab_gold,(L,L))        :- holds(t-1, in(agent,L)),
                                    holds(t-1, env(sparkle,L)).

holds(t,in(agent,L))             :- holds(t-1,in(agent,L)), 
                                    occurs(t,grab_gold,(L,G)).

holds(t, env(carry_gold,G))     :- holds(t-1,in(agent,G)), 
                                   occurs(t,grab_gold,(G,G)).

:- occurs(t,grab_gold,(G,G)), 
   holds(t-1,env(carry_gold,G)).


%%%%%%%%%%%%%%%%%%%%
%%%% EXIT 
%%%%%%%%%%%%%%%%%%%%

action(t,leave,(L,NL))           :- holds(t-1, in(agent,L)),
                                    holds(t-1, env(exit,NL)),
                                    holds(t-1, env(carry_gold,_)).
