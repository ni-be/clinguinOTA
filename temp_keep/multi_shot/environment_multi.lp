% Everything related to the environment itself.

current_time(T) :- T = #max{T2 : holds(T2,env(agent,_))}.

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


%INIT LOCATION
holds(0,env(agent, L ))         :- eholds(0,start(L)). 
                                  % current_time(T), 
                                  %T == 0.

eholds(0, env(sparkle, G))     :- eholds(0,env(gold,G)).

eholds(0, env(breeze, PP))     :- eholds(0,env(pit,P)), 
                                  adjacent(P,PP),
                                  % time(T), 
                                  cave(PP).

eholds(0, env(smell, WW))      :- eholds(0,env(wumpus,W)), 
                                  adjacent(W,WW),
                                  % time(T), 
                                  cave(WW).

eholds(T,env(empty, E))        :- not eholds(T,env(sparkle,E)), 
                                  not eholds(T,env(breeze,E)), 
                                  not eholds(T,env(smell,E)), 
                                  cave(E), current_time(T).

eholds(0,env(wall,(W,WW)))     :- wall(W,WW).
eholds(0,env(wall,(W,WW)))     :- wall(WW,W).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OBSERVE / GET INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extra Current Location data after agent perfomed an action:


holds(T,env(agent,(X+1,Y))) :- occurs(T,right), holds(T-1,env(agent,(X,Y))).
holds(T,env(agent,(X-1,Y))) :- occurs(T,left), holds(T-1,env(agent,(X,Y))).
holds(T,env(agent,(X,Y-1))) :- occurs(T,up), holds(T-1,env(agent,(X,Y))).
holds(T,env(agent,(X,Y+1))) :- occurs(T,down), holds(T-1,env(agent,(X,Y))).

holds(T, env(agent,(X,Y))) :- occurs(T,grab_gold), holds(T-1,env(agent,(X,Y))).
-eholds(T, env(gold,(X,Y))) :- occurs(T, grab_gold), holds(T-1,env(agent,(X,Y))).
-eholds(T, env(sparkle,(X,Y))) :- occurs(T, grab_gold), holds(T-1,env(agent,(X,Y))).


holds(T,env(agent,(X,Y))) :- occurs(T,shoot_right), holds(T-1,env(agent,(X,Y))).
holds(T,env(agent,(X,Y))) :- occurs(T,shoot_left), holds(T-1,env(agent,(X,Y))).
holds(T,env(agent,(X,Y))) :- occurs(T,shoot_up), holds(T-1,env(agent,(X,Y))).
holds(T,env(agent,(X,Y))) :- occurs(T,shoot_down), holds(T-1,env(agent,(X,Y))).

% -eholds(T,env(smell,(WX,WY))) :- occurs(T,shoot_right),eholds(T-1,env(smell,(SX,SY))), holds(T-1,env(agent,(X,Y))), adjacent((X,Y),(WX,WY)),-eholds(T,env(wumpus,(WX,WY))).
% -eholds(T,env(smell,(WX,WY))) :- occurs(T,shoot_left), holds(T-1,env(agent,(X,Y))), adjacent((X,Y),(WX,WY)), -eholds(T,env(wumpus,(WX,WY))).
% -eholds(T,env(smell,(WX,WY))) :- occurs(T,shoot_up), holds(T-1,env(agent,(X,Y))), adjacent((X,Y),(WX,WY)),  -eholds(T,env(wumpus,(WX,WY))).
% -eholds(T,env(smell,(WX,WY))) :- occurs(T,shoot_down), holds(T-1,env(agent,(X,Y))), adjacent((X,Y),(WX,WY)),-eholds(T,env(wumpus,(WX,WY))).


-eholds(T,env(wumpus,(X+1,Y))) :- occurs(T,shoot_right), holds(T-1,env(agent,(X,Y))).
-eholds(T,env(wumpus,(X-1,Y))) :- occurs(T,shoot_left), holds(T-1,env(agent,(X,Y))).
-eholds(T,env(wumpus,(X,Y-1))) :- occurs(T,shoot_up), holds(T-1,env(agent,(X,Y))).
-eholds(T,env(wumpus,(X,Y+1))) :- occurs(T,shoot_down), holds(T-1,env(agent,(X,Y))).

-eholds(T,env(smell,(SX,SY))) :- -eholds(T,env(wumpus,(WX,WY))),adjacent((WX,WY),(SX,SY)),eholds(T-1,env(smell,(SX,SY))).

envholds(T,env(dead_wumpus_yell, WL)) :- occurs(T,_),-eholds(T,env(wumpus,WL)), eholds(T-1,env(wumpus,WL)).%, holds(T-1,env(agent,L)). 

envholds(T,env(goal_reached,(X-1,Y))) :- occurs(T,leave), holds(T-1,env(agent,(X,Y))).

%dummy to avoid warning!
occurs(-1000, dummy).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THINK / UPDATE KNOWLEDGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update time for var if no change occurs. 
eholds(T,env(E,L))             :- eholds(T-1,env(E,L)),
                                  not -eholds(T,env(E,L)), 
                                  occurs(T,_).

-eholds(T,env(E,L))            :- -eholds(T-1,env(E,L)), 
                                  not eholds(T,env(E,L)), 
                                  current_time(T,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT CONVERSEN / FILTER FOR AGENT %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Only share the effects - breeze, sparkle, smell, empty, wall


envholds(T, env(E,L))          :- eholds(T,env(E,L)),
                                  not -eholds(T,env(E,L)), 
                                  holds(T, env(agent,L)), 
                                  E  != agent, occurs(T,_).

envholds(T, env(E,(L1,L2)))    :- eholds(T,env(E,(L1,L2))), 
                                  holds(T,env(agent,L1)), 
                                  occurs(T,_).

#show envholds/2.
#show current_time/1.
%#show time/1.
%#show holds/2.
%#show eholds/2.
%#show -eholds/2.

