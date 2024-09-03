% Cave the agent moves in 
cave((1..10,1..10)).

%% WILL BE REPLACED WITH INSTANCE GENERATOR LATER ON
% Populate Map, with walls from cave
map((X-1..X+1,Y-1..Y+1)) :- cave((X,Y)).
wall((X,Y),(X,Y')) :- cave((X,Y)), map((X,Y')), not cave((X,Y')), |Y-Y'| == 1. 
wall((X,Y),(X',Y)) :- cave((X,Y)), map((X',Y)), not cave((X',Y)), |X-X'| == 1. 

holds(0, start((1,1))).
holds(0, env, in(wumpus,(2,5))).
holds(0, env, in(pit,(3,2))).
holds(0, env, in(gold,(1,2))).
holds(0, env, in(gold,(2,1))).
