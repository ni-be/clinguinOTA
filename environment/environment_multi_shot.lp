% Environment that in itselfs uses Single_Shot implementation 
% to keep track of changes to the environment

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WORLD RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir((DX, DY))                  :- DX = -1..1,
                                  DY = -1..1, 
                                  |DX|+|DY| == 1.

adjacent((X, Y), (X+DX, Y+DY)) :- cave((X, Y)), 
                                  dir((DX, DY)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(0,env(agent, L ))         :- eholds(0,start(L)). 

eholds(0, env(sparkle, G))     :- eholds(0,env(gold,G)).

eholds(0, env(breeze, PP))     :- eholds(0,env(pit,P)), 
                                  adjacent(P,PP),
                                  % time(T), 
                                  cave(PP).

eholds(0, env(smell, WW))      :- eholds(0,env(wumpus,W)), 
                                  adjacent(W,WW),
                                  % time(T), 
                                  cave(WW).

eholds(0,env(wall,(W,WW)))     :- wall(W,WW).
eholds(0,env(wall,(W,WW)))     :- wall(WW,W).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OBSERVE / GET INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(T,env(agent,NL))          :- occurs(T,move,(L,NL)), 
                                   holds(T-1,env(agent,L)).

holds(T, env(agent,L))          :- occurs(T,grab_gold,(L,L)), 
                                   holds(T-1,env(agent,L)).

-eholds(T, env(gold,L))         :- occurs(T, grab_gold,(L,L)), 
                                   holds(T-1,env(agent,L)).

-eholds(T, env(sparkle,L))      :- occurs(T, grab_gold,(L,L)), 
                                   holds(T-1,env(agent,L)).

holds(T,env(agent,NL))          :- occurs(T,shoot,(NL,_)), 
                                   holds(T-1,env(agent,NL)).

-eholds(T,env(wumpus,WL))       :- occurs(T,shoot,(L,WL)), 
                                   eholds(T-1,env(wumpus,WL)).

-eholds(T,env(smell,L))         :- -eholds(T,env(wumpus,WL)),
                                   occurs(T,shoot,(_,WL)), 
                                   adjacent(L,WL), 
                                   eholds(T-1,env(smell,L)).

eholds(T,env(dead_wumpus_yell,WL)) :- -eholds(T,env(wumpus,WL)), 
                                    eholds(T-1,env(wumpus,WL)).

%dummy to avoid warning!
occurs(-1000,x, dummy).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THINK / UPDATE KNOWLEDGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update time for var if no change occurs. 
eholds(T,env(E,L))             :- eholds(T-1,env(E,L)),
                                  not -eholds(T,env(E,L)), 
                                  time(T).

-eholds(T,env(E,L))            :- -eholds(T-1,env(E,L)), 
                                  not eholds(T,env(E,L)), 
                                  time(T).

eholds(T,env(empty, E))        :- not eholds(T,env(sparkle,E)), 
                                  not eholds(T,env(breeze,E)), 
                                  not eholds(T,env(smell,E)), 
                                  cave(E), time(T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT CONVERSEN / FILTER FOR AGENT %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Only share the effects - breeze, sparkle, smell, empty, wall

percept(T, env(E,L))          :- eholds(T,env(E,L)),
                                  not -eholds(T,env(E,L)), 
                                  holds(T, env(agent,L)), 
                                  E  != agent, time(T),
                                  not holds(K,env(agent,L)), time(K).

percept(T,env(E,(L1,L2)))    :- eholds(T,env(E,(L1,L2))), 
                                  not -eholds(T,env(E,(L1,L2))),
                                  holds(T,env(agent,L1)), 
                                  not holds(K,env(agent,L1)), time(K), time(T).

percept(T,env(dead_wumpus_yell,WL)) :- eholds(T,env(dead_wumpus_yell,WL)),time(T),
                                        occurs(T,shoot,(L,WL)),
                                        holds(T,env(agent,L)).

#show percept/2.

