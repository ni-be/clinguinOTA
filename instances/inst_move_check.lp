% Cave the agent moves in 
cave((1..6,1..6)).

%% WILL BE REPLACED WITH INSTANCE GENERATOR LATER ON
% Populate Map, with walls from cave
map((X-1..X+1,Y-1..Y+1)) :- cave((X,Y)).
wall((X,Y),(X,Y')) :- cave((X,Y)), map((X,Y')), not cave((X,Y')), |Y-Y'| == 1. 
wall((X,Y),(X',Y)) :- cave((X,Y)), map((X',Y)), not cave((X',Y)), |X-X'| == 1. 


eholds(0, start((1,1))).
eholds(0, exit((0,1))).

eholds(0, env(wumpus,(5,3))). 
eholds(0, env(pit,(1,4))).
eholds(0, env(pit,(3,6))).
eholds(0, env(gold,(6,6))).

