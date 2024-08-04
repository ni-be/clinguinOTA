% Think part

% Define a goal

goal :- observed(T, true, in(sparkle,P)), time(T).
%goal :- happened(T, find(gold,P)), holds(T',in(agent,P)), time(T).
:- not goal.

