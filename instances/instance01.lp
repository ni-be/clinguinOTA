

cave((1..3,1..6)).

map((X-1..X+1,Y-1..Y+1)) :- cave((X,Y)).

wall((X,Y),(X,Y')) :- cave((X,Y)), map((X,Y')), not cave((X,Y')), |Y-Y'| == 1. 
wall((X,Y),(X',Y)) :- cave((X,Y)), map((X',Y)), not cave((X',Y)), |X-X'| == 1. 

%outside((0,0)). % Entrance. 

% intitial location of the agent at time 0
agent((1,1)).

% Wumpus cave
wumpus((2,5)).

% gold cave
gold((3,6)).

% initial Pits
pit((2,2)).

% Additional Walls within the field
wall((1,3),(1,4)).
wall((3,3),(3,4)).
wall((3,4),(3,5)).
