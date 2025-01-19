% Environment that in itselfs uses Single_Shot implementation 
% to keep track of changes to the environment

current_time(T) :- T = #max{T2 : time(T2)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WORLD RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Possible direction

dir((DX, DY))                  :- DX = -1..1,
                                  DY = -1..1, 
                                  |DX|+|DY| == 1.

% Adjacent relations in the cave:
adjacent((X, Y), (X+DX, Y+DY)) :- cave((X, Y)), 
                                  dir((DX, DY)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(0,in(agent, L ))         :- eholds(T,start(L)). 

eholds(0, env(sparkle, G))     :- eholds(0,env(gold,G)).
eholds(0, env(breeze, PP))     :- eholds(0,env(pit,P)), 
                                  adjacent(P,PP),
                                  time(T), 
                                  cave(PP).

eholds(0, env(smell, WW))      :- eholds(0,env(wumpus,W)), 
                                  adjacent(W,WW),
                                  time(T), 
                                  cave(WW).

eholds(0,env(wall,(W,WW)))     :- wall(W,WW).
eholds(0,env(wall,(W,WW)))     :- wall(WW,W).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OBSERVE / GET INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extra Current Location data after agent perfomed an action:

holds(T,env(agent, L))         :- occurs(T, move,(OL, L)),time(T).
                                   
holds(T,env(agent,L))          :- occurs(T, grab_gold,(L,L)), time(T).

holds(T,env(agent,L))          :- occurs(T, shoot,(L,WL)), time(T).

holds(T, in(agent,L))          :- occurs(T, leave,(OL,L)), time(T).
holds(T,env(agent,L))         :- holds(T,in(agent,L)).


%%% KEEEP or dump single shot
% holds(T,in(agent, L))          :- occurs(T, move_back,(OL, L)), time(T).

% holds(T, in(agent,L))          :- occurs(T-1, escape(L,A)),
                                  % time(T).


% holds(T, in(agent,A))          :- occurs(T-1, backtrack(L,A)),
                                  % time(T).

%dummy to avoid warning!
occurs(-1000, dummy(-1000)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THINK / UPDATE KNOWLEDGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update environment data that remains unchanged  
eholds(T,env(E,L))             :- eholds(T-1,env(E,L)),
                                  not -eholds(T,env(E,L)), 
                                  time(T).

-eholds(T,env(E,L))            :- -eholds(T-1,env(E,L)), 
                                  not eholds(T,env(E,L)), 
                                  time(T).

eholds(T,env(empty, E))        :- not eholds(T,env(sparkle,E)), 
                                  not eholds(T,env(breeze,E)), 
                                  not eholds(T,env(smell,E)), 
                                  cave(E), time(T).

% After the agent grabed gold 
-eholds(T, env(gold,G))        :- eholds(T-1, env(gold,G)), 
                                  occurs(T,grab_gold,(G,G)), 
                                  time(T).
                                   
-eholds(T, env(sparkle,G))     :- eholds(T-1, env(sparkle,G)), 
                                  occurs(T,grab_gold,(G,G)), 
                                  time(T).

%% After Wumpus has been shot
-eholds(T, env(wumpus,W))      :- eholds(T-1, env(wumpus,W)),
                                  occurs(T, shoot,(L,W)),
                                  time(T).
                                  
eholds(T, env(dead_wumpus_yell,W)):- -eholds(T-1,env(wumpus,W)),
                                  occurs(T, shoot, (A,W)),
                                  time(T).

-eholds(T, env(smell,S))       :- occurs(T, shoot,(A,W)),
                                  eholds(T-1,env(smell,S)),
                                  adjacent(W,S),
                                  time(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT CONVERSEN / FILTER FOR AGENT %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Only share the effects - breeze, sparkle, smell, empty, wall


envholds(T, env(E,L))          :- eholds(T,env(E,L)), 
                                  holds(T, in(agent,L)),
                                  current_time(T).

envholds(T, env(E,(L1,L2)))    :- eholds(T,env(E,(L1,L2))), 
                                  holds(T,in(agent,L1)), 
                                  current_time(T).

envholds(T, env(dead_wumpus_yell,W)) :- occurs(T, shoot,(A,W)), 
                                        holds(T-1,env(agent,A)).


gui(map(L)) :- map(L).

%% Keep for single shot
% envholds(T, env(exit,L))       :- eholds(T,exit(L)), 
%                                   current_time(T).
                                   
% envholds(T, env(start,L))      :- eholds(T,start(L)), 
%                                   current_time(T).

% envholds(T, env(escaped,L)) :- occurs(T-1, escape(A,L)), current_time(T).
#show envholds/2.

% #show holds/2.
% %#show eholds/2.
% %#show -eholds/2.
% #show gui/1.

