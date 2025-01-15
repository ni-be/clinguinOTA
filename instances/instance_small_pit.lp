% Cave the agent moves in 
cave((1..3,1..3)).

%% WILL BE REPLACED WITH INSTANCE GENERATOR LATER ON
% Populate Map, with walls from cave
map((X-1..X+1,Y-1..Y+1)) :- cave((X,Y)).
wall((X,Y),(X,Y')) :- cave((X,Y)), map((X,Y')), not cave((X,Y')), |Y-Y'| == 1, not eholds(0, exit((X,Y'))). 
wall((X,Y),(X',Y)) :- cave((X,Y)), map((X',Y)), not cave((X',Y)), |X-X'| == 1, not eholds(0, exit((X',Y))).  


eholds(0, start((1,1))).
eholds(0, exit((0,1))).
 
eholds(0, env(pit,(1,3))).
eholds(0, env(gold,(3,3))).



eholds(0, env(wumpus,(10,10))).
