% AGENT ENCODING WUMPUS
time(T) :- T = #max{T2 : ext_time(T2)}.

%Possible movement direction an Agent can take
dir((DX, DY)) :- DX = -1..1, DY = -1..1, |DX|+|DY| == 1.
adjacent((X, Y), (X+DX, Y+DY)) :- holds(_,in(agent,(X,Y))), dir((DX, DY)). %X+DX = X', Y+DY = Y', DX != DY.

% initial location:
holds(0,in(agent,L)) :- holds(0, start(L)). 
holds(T+1, in(agent,L)) :- occurs(T,move(agent,OL,L)).%, holds(T,in(agent,OL)),time(T).

env(breeze). env(smell). env(sparkle).  

observed(T, true, env(E,L)) :- holds(T,env(E,L)), time(T).
observed(T, false,env(E,L)) :- holds(T,env(empty,L)), holds(T,in(agent,L)), env(E), time(T).%, ext_time(T).

holds(T, F) :- observed(T, true, F).
-holds(T,F) :- observed(T, false,F).

holds(T+1,F) :- holds(T+1,F), not -holds(T,F), time(T+1).%, T< ET.
-holds(T+1,F) :- -holds(T+1,F), not holds(T,F), time(T+1).% T < ET.

% WHY ONLY WITH TIME OUTSIDE OF CHOICE RULE???
1 { occurs(T, move(agent,L1,L2)) : adjacent(L1,L2), holds(T,in(agent,L1))}1 :- time(T).


% Not allowed to pass through walls
:- occurs(T, move(agent,L1,L2)), holds(T,env(wall,(L1,L2))), time(T).

happened(T, F) :- observed(T,true, F). 
occurs(T,F) :- happened(T,F). 


goal :- holds(T, in(agent,L)), holds(T,env(sparkle,L)).
%:- not goal. 


 
