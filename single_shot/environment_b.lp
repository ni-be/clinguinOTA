% Everything related to the environment itself.

current_time(T) :- T = #max{T2 : time(T2)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WORLD RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Possible direction

dir((DX, DY))                  :- DX = -1..1,
                                  DY = -1..1, 
                                  |DX|+|DY| == 1.

% Adjacent relations in the cave:
adjacent((X, Y), (X+DX, Y+DY)) :- cave((X, Y)), 
                                  dir((DX, DY)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%INIT LOCATION
holds(T,in(agent, L ))         :- eholds(T,
                                  start(L)), 
                                  current_time(T), 
                                  T == 0.

eholds(0, env(sparkle, G))     :- eholds(0,env(gold,G)).
eholds(0, env(breeze, PP))     :- eholds(0,env(pit,P)), 
                                  adjacent(P,PP), 
                                  cave(PP).

eholds(0, env(smell, WW))      :- eholds(0,env(wumpus,W)), 
                                  adjacent(W,WW),
                                  time(T), 
                                  cave(WW).

eholds(T,env(empty, E))        :- not eholds(T,env(sparkle,E)), 
                                  not eholds(T,env(breeze,E)), 
                                  not eholds(T,env(smell,E)), 
                                  cave(E), time(T).

eholds(0,env(wall,(W,WW)))     :- wall(W,WW).
eholds(0,env(wall,(W,WW)))     :- wall(WW,W).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OBSERVE / GET INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extra Current Location data after agent perfomed an action:

holds(T,in(agent, L))          :- occurs(T-1, explore(OL, L)), 
                                  time(T).
holds(T,in(agent, L))          :- occurs(T-1, move(OL, L)), 
                                  time(T).
                                   
holds(T,in(agent,L))           :- occurs(T-1, grab_gold(L)), 
                                  time(T).

holds(T, in(agent,A))          :- occurs(T-1, kill_wumpus(A,L)),
                                  time(T).

holds(T, in(agent,A))          :- occurs(T-1, leave(OL,A)),
                                  time(T).

%holds(T, in(agent,A))          :- occurs(T-1, escape(A)),
%                                  time(T).
holds(T, in(agent,A))          :- occurs(T-1, backtrack(L,A)),
                                  time(T).

eholds(T,env(agent,L))         :- holds(T,in(agent,L)).

%dummy to avoid warning!
occurs(-1000, dummy(-1000)).

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

% After the agent grabed gold 
-eholds(T, env(gold,G))        :- eholds(T-1, env(gold,G)), 
                                  occurs(T-1,grab_gold(G)), 
                                  time(T).
                                   
-eholds(T, env(sparkle,G))     :- eholds(T-1, env(sparkle,G)), 
                                  occurs(T-1,grab_gold(G)), 
                                  time(T).

-eholds(T, env(wumpus,W))      :- eholds(T-1, env(wumpus,W)),
                                  occurs(T-1, kill_wumpus(A,W)),
                                  time(T).
                                  
eholds(T, env(dead_wumpus,W))  :- -eholds(T-1,env(wumpus,W)),
                                  occurs(T-1, kill_wumpus(A,W)),
                                  time(T).

-eholds(T, env(smell,S))       :- occurs(T-1, kill_wumpus(A,W)),
                                  eholds(T-1,env(smell,S)),
                                  adjacent(W,S),
                                  time(T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT CONVERSEN / FILTER FOR AGENT %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Only share the effects - breeze, sparkle, smell, empty, wall


envholds(T, env(E,L))          :- eholds(T,env(E,L)), 
                                  holds(T, in(agent,L)),
                                  time(T).

envholds(T, env(E,(L1,L2)))    :- eholds(T,env(E,(L1,L2))), 
                                  holds(T,in(agent,L1)), 
                                  time(T).

envholds(T, env(exit,L))       :- eholds(T,exit(L)), 
                                  time(T).
                                   
envholds(T, env(start,L))      :- eholds(T,start(L)), 
                                  time(T).

envholds(T, env(wumpus_yell,W)):- occurs(T-1, kill_wumpus(A,W)),
                                  time(T).

gui(map(L)) :- map(L).

#show envholds/2.
#show holds/2.
%#show eholds/2.
%#show -eholds/2.
#show gui/1.

