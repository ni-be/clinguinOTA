% AGENT ENCODING WUMPUS

% TIME() = External / Program time
% INIT int_time at step 0
int_time(0) :- ext_time(T), T == 0.
int_time(T+1) :- int_time(T), holds(T+1, in(agent,_)).
%int_time tracks time for the agent 


% INIT OBSERVATION and LOCATION

%observed(0, true, in(agent,C)) :- agent(C), time(0).
holds(0, in(agent,C)) :- agent(C), ext_time(0). 

holds(T,F) :- observed(T, true, F).
-holds(T,F) :- observed(T, false, F). 


happened(T,E) :- observed(T,true, E). 
occurs(T,E) :- happened(T,E). 

env(breeze). env(smell). env(sparkle). env(empty). 

observed(T, true, env(E,XY)) :- holds(T,env(E,XY)), holds(T,in(agent,XY)), env(E).
observed(T, true, env(wall,(XY, XY'))) :- holds(T,env(wall,(XY,XY'))), holds(T,in(agent,XY)).

observed(T, false, env(E,XY)) :- holds(T,in(agent(XY))), not holds(T, env(E,XY)), env(E).
observed(T, false, env(wall,(XY,XY'))) :- holds(T, in(agent(XY))), not holds(T, env(wall,(XY,XY'))), adjacent(XY,XY').

%%%% MOVEMENT %%%%%
%had to remove here time(T) for the agent to move beyond back and forth
1{ occurs(T, agent, move, (P, (1,1) )) : adjacent(P,PP)}1 :- holds(T, in(agent,P)). %, ext_time(ET), ET != 0. 





%have to keep time(T) here otherwise infinite grounding.
%holds(T, in(agent,NL)) :- holds(T-1,in(agent,L)), occurs(T, move(agent,L,NL)), int_time(T-1), ext_time(T).


% UPDATE Knowledge

holds(T+1,env(E,L)) :- holds(T,env(E,L)), not -holds(T+1, env(E,L)), int_time(T+1).
-holds(T+1, env(E,L)) :- -holds(T,env(E,L)), not holds(T+1, env(E,L)), int_time(T+1). 

 
