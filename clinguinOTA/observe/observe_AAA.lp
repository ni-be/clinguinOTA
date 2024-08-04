% OBSERVE PART OF OTA

% at step 0, the agent observes its own location and none of the environment stuff, but it is aware that it exists

% for step 0 to get the ball rolling
observed(0,true, F) :- fluent(F,inertial_agent).
%later use the observed false with random coordinates for dynamics
%observed(0,false,F) :- fluent(F, inertial_world).
%observed(0,true, in(safe,(1,1))).
%observed(0,true, in(empty,(1,1))).

holds(T,F) :- observed(T,true,F).
-holds(T,F) :- observed(T,false,F).

% Update Knowledge
happened(T,E) :- observed(T,true,E).
%happened(T+1,E) :- happened(T,E), time(T+1).
occurs(T,E) :- happened(T,E). 

% Creating the appropriate observations for each room based on the input from def environment() 
env(breeze). env(smell). env(sparkle). env(empty).


observed(T,true,in(E,L)) :- holds(T,in(agent,L)), environment(in(E,L)), env(E).
observed(T,false, in(E,L)):- holds(T,in(agent,L)), not observed(T,true,in(E,L)), env(E).

observed(T, true,in(wall,W,WW)) :- holds(T,in(agent,W)), environment(in(wall,W,WW)).
observed(T, true,in(wall,WW,W)) :- holds(T,in(agent,WW)),environment(in(wall,W,WW)).


%update preexisting beliefs, if no new observation occured, since they should remain the same 

holds(T+1, F) :- holds(T,F), not -holds(T+1,F), time(T'), T < T'.%, not fluent(F,inertial_agent). 
-holds(T+1,F) :- -holds(T,F), not holds(T+1,F), time(T'), T < T'.%, not fluent(F,inertial_agent).



% %%%% OBSERVE the ENVIRONMENT
% Step one the field agent is in is observed to safe
% holds(T,in(safe,L)) :- holds(T,in(agent,L)).

% % if the field the agent is empty then all the adjacents are safe as well
% holds(T, in(safe,P')) :- holds(T, in(agent, P)), adjacent(P,P'), -holds(T, in(breeze,P)). 

% % assume there to be a pit at BB after having 2 adjacents confirmed.
% holds(T,in(pit,BB)) :- happened(T, in(breeze,B)), happened(T, in(breeze,B')), adjacent(B,BB), adjacent(B',BB), B != B', not holds(T,in(safe,BB)). 

% % If the pit assumed then that location is believed not to be safe
% -holds(T,in(safe,P)) :- holds(T,in(pit,P)). 
% -holds(T,in(safe,PP)) :- holds(T, in(agent,P)), holds(T', in(safe,P')), T' < T, adjacent(P,PP)

% % AL is safe if breeze at B and Pit at P are not adjacent. 
% holds(T, in(safe,AL)) :- happened(T,in(breeze,B)), holds(T,in(pit,P)), holds(T,in(agent,AL)), adjacent(B,AL), adjacent(B,P), AL != P.


observed(T,true,in(safe,L)) :- holds(T,in(agent,L)).
observed(T, true, in(safe,P')) :- holds(T, in(agent, P)), adjacent(P,P'), -holds(T, in(breeze,P)), -holds(T,in(smell,P)), not happened(T,in(wall,P,P')). 
observed(T,true, in(pit,BB)) :- happened(T, in(breeze,B)), happened(T, in(breeze,B')), adjacent(B,BB), adjacent(B',BB), B != B', not holds(T,in(safe,BB)), not happened(T,in(wall,B,BB)). 
observed(T,true, in(wumpus,WW)) :- happened(T, in(smell,S)), happened(T, in(smell,S')), adjacent(S,WW), adjacent(S',WW), S != S', not holds(T,in(safe,WW)), not happened(T, in(wall,S,WW)).
observed(T, false, in(safe,W)) :- happened(T, in(wumpus,W)).
observed(T, true, in(safe,AL)) :- happened(T,in(smell,S)), happened(T,in(wumpus,W)), holds(T,in(agent,AL)), adjacent(S,AL), adjacent(S,W), AL != W.
observed(T, false, in(safe,P)) :- happened(T,in(pit,P)). 
observed(T, true, in(safe,AL)) :- happened(T,in(breeze,B)), happened(T,in(pit,P)), holds(T,in(agent,AL)), adjacent(B,AL), adjacent(B,P), AL != P.



% Rules that show if an observation has been inconcistent
inconcistent_observation(T, false, F) :- observed(T, false, F), holds(T,F).
inconcistent_observation(T, true, F) :- observed(T, true, F), -holds(T,F).

% if a fact F is observed to be false at some time T, then F should not hold true at 
% that same time T while there is another time T' which is later than T. This avoids 
% any inconsistency between observed data and what is held to be true in the model.
:- observed(T, false, F), holds(T,F), time(T'), T < T'.
:- observed(T, true, F), -holds(T,F), time(T'), T < T'. 



% OCCURS tracks the agents history
% Happened, observed tracks exogenous / environment events

% In addition to the system description given by a logic program the agent’s memory contains the system’s recorded 
% history – the record of execution of all the actions performed by the agent together with a collection of truth 
% values of fluents and occurrences of exogenous actions observed by the agent up to the current step j of the system’s trajectory.
% The history is recorded using two new relations obs and hpd; obs(F,V,I) is true if at step I fluent F was observed to have
% truth value V ; hpd(E, I) is true if an event E was observed to have happened at I. (Names different from holds and occurs 
% are used to indicate that unlike the latter these statements can not be falsified by new information.
