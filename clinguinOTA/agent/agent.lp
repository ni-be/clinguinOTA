% AGENT ENCODING WUMPUS

time(0) :- ext_time(T), T == 0.
time(T+1) :- occurs(T+1,agent,_,_), ext_time(T+1), T > 0. 

observed(T, true, agent,in, WHERE) :- agent(WHERE), time(T), T == 0.
observed(T, true, env,empty,W) :- agent(W), time(T), T == 0.
 
% GENERAL RULE if something occurs, the agent observes it.
observed(T,true,env,WHAT,WHERE) :- occurs(T,env,WHAT,WHERE).

hold(T,agent,in,W1) :- occurs(T,agent,move,(W,W1)), time(T).%, holds(T-1,agent,in,W).
holds(T,agent,in,W1) :- occurs(T,agent,stay,W1), time(T).%, holds(T,agent,in,W1).
%time(T+1) :- holds(T+1,agent,in,_), holds(T,agent,in,_), time(T), ext_time(T+1).

% DEFAULT unless otherwise observed
env(breeze). env(smell). env(sparkle). env(empty). 
observed(T,false,env,WHAT,WHERE) :- holds(T,agent,in,WHERE), env(WHAT), not occurs(T,env,WHAT,WHERE), time(T).

holds(T,WHO,WHAT,WHERE) :- observed(T, true, WHO, WHAT, WHERE).
-holds(T,WHO,WHAT,WHERE) :- observed(T, false, WHO,WHAT,WHERE). 

happened(T,W0,W1,W2) :- observed(T,true, W0,W1,W2). 
occurs(T,W0,W1,W2) :- happened(T,W0,W1,W2). 



%%% MOVEMENT %%%%%

1{ occurs(T,agent,stay,P); occurs(T+1,agent,move,(P,PP)):adjacent(P,PP)}1 :- holds(T,agent,in,P).
1{ occurs(T, agent, stay,P) : holds(T,agent,in,P)}1. %, T = 0, ext_time(T). 
%0{ occurs(T, agent, move, (P, PP )) : adjacent(P,PP), holds(T,agent,in,P)}1. % :- holds(T, agent, in, P).  

temp_goal((1,2)).
%goal :- holds(T,agent,in,P), time(T), temp_goal(P).
%:- not goal. 

% UPDATE Knowledge

% holds(T+1,env(E,L)) :- holds(T,env(E,L)), not -holds(T+1, env(E,L)), int_time(T+1).
% -holds(T+1, env(E,L)) :- -holds(T,env(E,L)), not holds(T+1, env(E,L)), int_time(T+1). 

 
