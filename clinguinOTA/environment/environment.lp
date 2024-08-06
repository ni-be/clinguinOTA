% Everything related to the environment itself.

%extract current agent location
holds(T, agent, L) :- occurs(T,agent, move,(OL, L)). 

% Populate Map, with walls from cave
map((X-1..X+1,Y-1..Y+1)) :- cave((X,Y)).
wall((X,Y),(X,Y')) :- cave((X,Y)), map((X,Y')), not cave((X,Y')), |Y-Y'| == 1, not entrance((X,Y')). 
wall((X,Y),(X',Y)) :- cave((X,Y)), map((X',Y)), not cave((X',Y)), |X-X'| == 1, not entrance((X',Y)). 

holds(0,env,sparkle, G) :- gold(G).
% nholds(T, env,sparkle,G) :- occurs(GRAB GOLD).

holds(0,env,breeze, PP) :- pit(P), adjacent(P,PP), cave(PP).
holds(0,env,smell, WW) :- wumpus(W), adjacent(W,WW), cave(WW).
holds(T,env,empty,E) :- not holds(T,env,sparkle,E), not holds(T,env,breeze,E), not holds(T,env,smell,E), cave(E), ext_time(T).
holds(0,env,wall,(W,WW)) :- wall(W,WW).
holds(0,env,wall,(W,WW)) :- wall(WW,W).

% Update time
holds(T+1,E,W,L) :- holds(T,E,W,L), not nholds(T+1,E,W,L), ext_time(T+1).
nholds(T+1,E,W,L) :- nholds(T,E,W,L), not holds(T+1,E,W,L), ext_time(T+1).

occurs(T,env,empty,E) :- holds(T,env,empty,E), holds(T, agent, E).
occurs(T,env,sparkle, S) :- holds(T,env,sparkle,S), holds(T,agent,S). 
occurs(T,env,breeze, B) :- holds(T,env,breeze,B), holds(T,agent,B).
occurs(T,env,smell, S)  :-  holds(T,env,smell,S), holds(T,agent,S).
occurs(T,env,wall,(W,WW)) :- holds(T,env,wall,(W,WW)), holds(T,agent,W).
occurs(T,env,wall,(WW,W)) :- holds(T,env,wall,(W,WW)), holds(T,agent,WW).





#show occurs/4.
