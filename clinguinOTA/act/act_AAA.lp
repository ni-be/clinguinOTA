% ACTION part

1{occurs(T, move(agent,P,PP)) : holds(T,in(agent,P)), adjacent(P,PP), not happened(T,in(wall,P,PP)), not fluent(in(wumpus,PP),inertial_world), not fluent(in(pit,PP),inertial_world)}1 :- holds(T, in(agent,P)). 

%:- occurs(T,move(agent,P,PP)), holds(T, in(safe,PP)). 

% Update belief with new knowlegdeafter each step
holds(T+1, in(agent,PP)) :- occurs(T,move(agent,P,PP)), time(T). 

