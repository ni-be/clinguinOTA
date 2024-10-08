%constant use

max_time(T) :- T = #max{T2 : time(T2)}.
#const guitime = 0.

ctime(guitime).



elem(w,window,root).
attr(w,class,("d-flex";"flex-row")).



    %%%%%%%%%%%%%%%%%%%%%%%%
    % env knowledge
    %%%%%%%%%%%%%%%%%%%%%%%%
    elem(ota,container,w).
    attr(ota,child_layout,grid).
 
   %attr(ota,height,200).

        %%%%%%%%%%%%%%%%%%%%%%%%
        % Environment Cont.
        %%%%%%%%%%%%%%%%%%%%%%%%
        elem(env(X,Y),container,ota):-map((X,Y)).
        attr(env(X,Y),width,50):-map((X,Y)).
        attr(env(X,Y),height,50):-map((X,Y)).
        attr(env(X,Y),grid_column,X):-map((X,Y)).
        attr(env(X,Y),grid_row,Y):-map((X,Y)).
        attr(env(X,Y),class,("m-1")):-map((X,Y)).
        

        % Environment Grid
        attr(env(X,Y), class,("bg-info";"bg-opacity-25")) :- map((X,Y)), not eholds(T, env(_,(X,Y) )),ctime(T), not holds(T,env(exit,(X,Y))).
        attr(env(X,Y), class,("bg-info";"bg-opacity-50")) :- cave((X,Y)), 
                                                             not eholds(T, env(agent,(X,Y))), ctime(T),  
                                                             not holds(T, env(start,(X,Y))). 
                                      
        % Start and Exit Point 
        attr(env(X,Y), class,("fa-solid";"fa-person-through-window";"fa-2x";"bg-secondary";"bg-opacity-25")) :- holds(T,env(exit,(X,Y))), ctime(T). 
        attr(env(X,Y), class,("bg-secondary")) :- holds(0, env(start,(X,Y))), ctime(T).

        
        %outside walls
        attr(env(X,Y), class,("fa-solid";"fa-circle-down";"fa-2x")) :- eholds(T, env(pit,(X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("fa-solid";"fa-hippo";"fa-2x")) :- eholds(T, env(wumpus,(X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("fa-solid";"fa-gem";"fa-2x")) :- eholds(T, env(gold, (X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("fa-solid";"fa-user";"fa-2x")) :- holds(T,in(agent,(X,Y))), map((X,Y)), ctime(T).
    
        % room the agent visited
        attr(env(X,Y), class,("bg-success")) :- holds(K, in(agent,(X,Y))), map((X,Y)), ctime(T),time(K), K <= T, not holds(T,env(start,(X,Y))).

        % ENV EFFECTS

        attr(env(X,Y), class,("fa-solid";"fa-wind";"fa-2x")) :- eholds(T, env(breeze,(X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("fa-solid";"fa-biohazard";"fa-2x")) :- eholds(T, env(smell,(X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("bg-warning")) :- eholds(T, env(sparkle,(X,Y))), map((X,Y)), ctime(T).

        % WALLS
        attr(env(X,Y), class,("border-bottom";"border-dark";"border-3")) :- eholds(0,env(wall,((X,Y),(X,Y')))), Y' > Y.
        attr(env(X,Y), class,("border-top";"border-dark";"border-3")) :- eholds(0,env(wall,((X,Y),(X,Y')))), Y' < Y.
        attr(env(X,Y), class,("border-end";"border-dark";"border-3")) :- eholds(0,env(wall,((X,Y),(X',Y)))), X' > X.
        attr(env(X,Y), class,("border-start";"border-dark";"border-3")) :- eholds(0,env(wall,((X,Y),(X',Y)))), X' < X.


    %%%%%%%%%%%%%%%%%%%%%%%%
    % Agent knowledge
    %%%%%%%%%%%%%%%%%%%%%%%%
    elem(ota_agent,container,w).
    attr(ota_agent,child_layout,grid).
    attr(ota_agent,title, "Agent Live Tracking").

        % %%%%%%%%%%%%%%%%%%%%%%%%
        % % Agent Container.
        % %%%%%%%%%%%%%%%%%%%%%%%%

        elem(agent(X,Y),container,ota_agent):-map((X,Y)).
        attr(agent(X,Y),width,50):-map((X,Y)).
        attr(agent(X,Y),height,50):-map((X,Y)).
        attr(agent(X,Y),grid_column,X):-map((X,Y)).
        attr(agent(X,Y),grid_row,Y):-map((X,Y)).
        attr(agent(X,Y),class,("m-1")):-map((X,Y)).
        attr(person(P), label, P):- person(P,_).
        % Basic Grid

        attr(agent(X,Y), class,("fa-solid";"fa-person-through-window";"fa-2x";"bg-secondary";"bg-opacity-25")) :- holds(T,env(exit,(X,Y))), ctime(T). 
        attr(agent(X,Y), class,("bg-secondary")) :- holds(T, env(start,(X,Y))), ctime(T).

        attr(agent(X,Y), class,("bg-secondary")) :- agent_map((X,Y)), holds(T, in(agent,(X,Y))), ctime(T), not holds(T,env(safe,(X,Y))).
        

       % Observed EMPTY
        attr(agent(X,Y), class,("fa-solid";"fa-e")) :- holds(T,env(empty,(X,Y))), ctime(T).
        
      % observed Smell and confirmed Wumpus
      % observed WALLS
        attr(agent(X,Y), class,("border-bottom";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X,Y')))), Y' > Y, ctime(T).
        attr(agent(X,Y), class,("border-top";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X,Y')))), Y' < Y, ctime(T).
        attr(agent(X,Y), class,("border-end";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X',Y)))), X' > X, ctime(T).
        attr(agent(X,Y), class,("border-start";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X',Y)))), X' < X, ctime(T).


       % Hold believe that 

        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-gem";"fa-2x")) :- holds(T,env(sparkle,(X,Y))), ctime(T).
        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-wind";"fa-2x")) :- holds(T,env(breeze,(X,Y))), ctime(T).
        
        % WUMPUS
        attr(agent(X,Y), class,("bg-warning";"bg-opacity-25";"fa-solid";"fa-hippo";"fa-2x")):- holds(T,env(assume(wumpus),(X,Y))), ctime(T).
        attr(agent(X,Y), class,("bg-warning";"bg-opacity-50";"fa-solid";"fa-biohazard";"fa-2x")) :- holds(T,env(smell,(X,Y))), ctime(T).
        attr(agent(X,Y), class,("bg-warning";"fa-solid"; "fa-hippo";"fa-2x")) :- holds(T,env(wumpus,(X,Y))), ctime(T).

        % PIT
        attr(agent(X,Y), class,("bg-warning";"bg-opacity-25";"fa-solid";"fa-circle-down";"fa-2x")):- holds(T,env(assume(pit),(X,Y))), ctime(T).
        % attr(agent(X,Y), class,("bg-warning";"bg-opacity-25";"fa-solid";"fa-wind";"fa-2x")) :- holds(T,env(breeze,(X,Y))), ctime(T), not holds(_,in(agent,(X,Y))).
        attr(agent(X,Y), class,("bg-warning";"bg-opacity-50";"fa-solid";"fa-wind";"fa-2x")) :- holds(T,env(breeze,(X,Y))), ctime(T), holds(_,in(agent,(X,Y))).
        attr(agent(X,Y), class,("bg-warning";"fa-solid"; "fa-circle-down";"fa-2x")) :- holds(T,env(pit,(X,Y))), ctime(T).
        
        % CURRENT POSITION AT cTIME T
        attr(agent(X,Y), class,("fa-solid";"fa-user";"fa-2x")):- holds(T,in(agent,(X,Y))), ctime(T).

        % KNOW SAFE AND ASSUME SAFE
        attr(agent(X,Y), class,("bg-success";"bg-opacity-25")) :- holds(T,env(safe,(X,Y))), ctime(T), agent_map((X,Y)). 

        attr(agent(X,Y), class,("bg-success";"bg-opacity-100")) :- holds(K, in(agent,(X,Y))), ctime(T), time(K), K < T.
        
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%% INFO CONTAINER %%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      elem(info, container, w).
      elem(goal(T,A,L), button, info):- goal(T,A,L), ctime(T).
      attr(goal(T,A,L), label, goal(T,A,L) ):- goal(T,A,L), ctime(T).
      attr(goal(T,A,L), class, ("bg-info";"m-2";"btn-sm")):- goal(T,A,L), ctime(T).
      elem(info_env, container, w).
      elem(env_info(E,L), button, info_env):- envholds(T,env(E,L)), ctime(T). 
      attr(env_info(E,L), label, env_info(E,L)):- envholds(T,env(E,L)), ctime(T).
      attr(env_info(E,L), class, ("bg-primary";"m-2";"btn-sm")):- envholds(T,env(E,L)), ctime(T).
      

%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Wumpus Observe Think Act Loop").

attr(menu_bar, icon, "fa-table-cells").
     elem(menu_bar_prev, button, menu_bar):- ctime(T), time(T-1), T > 0.
     attr(menu_bar_prev, label, "Previous Time Step"):- ctime(T), time(T-1), T > 0.
     attr(menu_bar_prev, icon, "fa-backward-step"):- ctime(T), time(T-1), T > 0.

when(menu_bar_prev, click, call, set_constant("guitime", T-1)):- ctime(T), time(T-1), T > 0.

     elem(menu_bar_next, button, menu_bar):- ctime(T), time(T+1), max_time(K), T < K.
     attr(menu_bar_next, label, "Next Time Step"):- ctime(T), time(T+1), max_time(K), T < K. 
     attr(menu_bar_next, icon, "fa-forward-step"):- ctime(T), time(T+1),max_time(K), T < K.

when(menu_bar_next, click, call, set_constant("guitime", T+1)):- ctime(T), time(T+1), max_time(K), T < K.



