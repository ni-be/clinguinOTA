% Everything related to the environment itself.

map((X-1..X+1,Y-1..Y+1)) :- cave((X,Y)).

wall((X,Y),(X,Y')) :- cave((X,Y)), map((X,Y')), not cave((X,Y')), |Y-Y'| == 1. 
wall((X,Y),(X',Y)) :- cave((X,Y)), map((X',Y)), not cave((X',Y)), |X-X'| == 1. 



holds(T,env(empty,E)) :- not holds(T,env(sparkle,E)), not holds(T,env(breeze,E)), not holds(T,env(smell,E)), cave(E), holds(T,in(agent,E)).

holds(T,env(sparkle, G)) :- gold(G), holds(T,in(agent,G)). 

holds(T,env(breeze, PP)) :- pit(P), adjacent(P,PP), cave(PP), holds(T,in(agent,PP)).

holds(T,env(smell, WW)) :- wumpus(W), adjacent(W,WW), cave(WW), holds(T,in(agent,W)).
holds(T,env(wall,(W,WW))) :- wall(W,WW), holds(T,in(agent,W)).
holds(T,env(wall,(W,WW))) :- wall(WW,W), holds(T,in(agent,W)).





%holds(T,env(empty,E)) :- holds(T,in(A,E)), holds(T,carry(gold,A)).

%-holds(T,carry(gold,A)).  

%occurs(T, grabgold(A,E)). 



#show holds/2.
