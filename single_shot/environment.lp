% Everything related to the environment itself.

time(T) :- T = #max{T2 : ext_time(T2)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WORLD RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Possible direction
dir((DX, DY)) :- DX = -1..1, DY = -1..1, |DX|+|DY| == 1.
% Adjacent relations in the cave:
adjacent((X, Y), (X+DX, Y+DY)) :- cave((X, Y)), cave((X',Y')), dir((DX, DY)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%INIT LOCATION
holds(T,env(agent, L )) :- holds(T, start(L)), time(T), T == 0.

holds(0, env(sparkle, G)) :- holds(0,env(gold,G)).
holds(0, env(breeze, PP)) :- holds(0,env(pit,P)), adjacent(P,PP), cave(PP).
holds(0, env(smell, WW)) :- holds(0,env(wumpus,W)), adjacent(W,WW), cave(WW).

holds(T,env(empty, E)) :- not holds(T,env(sparkle,E)), 
                                  not holds(T,env(breeze,E)), 
                                  not holds(T,env(smell,E)), 
                                  cave(E), time(T).

holds(0,env(wall,(W,WW))) :- wall(W,WW).
holds(0,env(wall,(W,WW))) :- wall(WW,W).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OBSERVE / GET INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extra Current Location data after agent perfomed an action:
holds(T+1,env(agent, L)) :- occurs(T, move(agent,OL, L)), time(T+1). 
holds(T+1,env(agent,L)) :- occurs(T, grab_gold(agent,L)), time(T+1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THINK / UPDATE KNOWLEDGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update time for var if no change occurs. 
holds(T+1,F) :- holds(T,F), not -holds(T+1,F), time(T+1).
-holds(T+1,F) :- -holds(T,F), not holds(T+1,F), time(T+1).

% After the agent grabed gold 
-holds(T+1, env(gold,G)) :- occurs(T,grab_gold(agent,G)), time(T+1). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT CONVERSEN / FILTER FOR AGENT %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Only share the effects - breeze, sparkle, smell, empty, wall
eholds(T, env(E,L)) :- holds(T,env(E,L)), holds(T, env(agent,L)), time(T).
eholds(T, env(E,(L1,L2))) :- holds(T,env(E,(L1,L2))), holds(T,env(agent,L1)), time(T).
  
#show eholds/2.

