% Everything related to the environment itself.

time(T) :- T = #max{T2 : ext_time(T2)}.

% Possible direction
dir((DX, DY)) :- DX = -1..1, DY = -1..1, |DX|+|DY| == 1.

% Adjacent relations in the cave:
adjacent((X, Y), (X+DX, Y+DY)) :- cave((X, Y)), cave((X',Y')), 
                                  dir((DX, DY)), X+DX = X', Y+DY = Y', DX != DY.


%extract current agent location
holds(T,env,in(agent, L )) :- holds(T, start(L)), time(T), T== 0.
holds(T+1,env, in(agent, L)) :- occurs(T, move(agent,OL, L)), time(T+1).%, K > 0. 


holds(T, env, effect(sparkle, G)) :- holds(T,env, in(gold,G)).
holds(T, env, effect(breeze, PP)) :- holds(T,env, in(pit,P)), adjacent(P,PP), cave(PP).
holds(T, env, effect(smell, WW)) :- holds(T,env, in(wumpus,W)), adjacent(W,WW), cave(WW).

holds(T,env, effect(empty, E)) :- not holds(T,env, effect(sparkle,E)), 
                                  not holds(T,env, effect(breeze,E)), 
                                  not holds(T,env, effect(smell,E)), 
                                  cave(E), time(T).

holds(0,env, effect(wall,(W,WW))) :- wall(W,WW).
holds(0,env, effect(wall,(W,WW))) :- wall(WW,W).

% Update time for var. 
holds(T+1,E, F) :- holds(T,E,F), not -holds(T+1,E,F), time(T+1).
-holds(T+1,E,F) :- -holds(T,E,F), not holds(T+1,E,F), time(T+1).

% Only share the effects - breeze, sparkle, smell, empty, wall
holds(T, env(E,L)) :- holds(T,env,effect(E,L)), holds(T, env, in(agent,L)), time(T).
holds(T, env(E,(L1,L2))) :- holds(T,env,effect(E,(L1,L2))), holds(T,env,in(agent,L1)), time(T).
  

#show holds/2.

