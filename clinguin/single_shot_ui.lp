


elem(w,window,root).
attr(w,class,("d-flex";"flex-row")).

    %%%%%%%%%%%%%%%%%%%%%%%%
    % env knowledge
    %%%%%%%%%%%%%%%%%%%%%%%%
    elem(ota,container,w).
    attr(ota,child_layout,grid).
    % attr(ota,width,200).
    % attr(ota,height,200).

        %%%%%%%%%%%%%%%%%%%%%%%%
        % Environment Cont.
        %%%%%%%%%%%%%%%%%%%%%%%%
        elem(env(X,Y),container,ota):-map((X,Y)).
        attr(env(X,Y),width,50):-map((X,Y)).
        attr(env(X,Y),height,50):-map((X,Y)).
        attr(env(X,Y),grid_column,X):-map((X,Y)).
        attr(env(X,Y),grid_row,Y):-map((X,Y)).
        attr(env(X,Y),class,("m-1")):-map((X,Y)).

        % Basic Grid

        % Start point
        attr(env(X,Y), class,("bg-secondary")) :- holds(0, start((X,Y))).
        attr(env(X,Y), class,("bg-info";"bg-opacity-25")) :- map((X,Y)), not holds(T, env(_,(X,Y))), time(T). % There is nothing there to paint
        % ENV
        attr(env(X,Y), class,("fa-solid";"fa-circle-down";"fa-2x")) :- holds(0, env(pit,(X,Y))), map((X,Y)).
        attr(env(X,Y), class,("fa-solid";"fa-hippo";"fa-2x")) :- holds(0, env(wumpus,(X,Y))), map((X,Y)).
        attr(env(X,Y), class,("fa-solid";"fa-gem";"fa-2x")) :- holds(0, env(gold, (X,Y))), map((X,Y)).
        attr(env(X,Y), class,("fa-solid";"fa-user";"fa-2x")) :- holds(0,in(agent,(X,Y))), map((X,Y)).
        % room the agent visited
        attr(env(X,Y), class,("bg-success")) :- holds(T, env(agent,(X,Y))), map((X,Y)), time(T).

        % ENV EFFECTS

        attr(env(X,Y), class,("fa-solid";"fa-wind";"fa-2x")) :- holds(0, env(breeze,(X,Y))), map((X,Y)).

        attr(env(X,Y), class,("fa-solid";"fa-biohazard";"fa-2x")) :- holds(0, env(smell,(X,Y))), map((X,Y)).
        attr(env(X,Y), class,("bg-warning")) :- holds(0, env(sparkle,(X,Y))), map((X,Y)).



        % WALLS
        attr(env(X,Y), class,("border-bottom";"border-dark";"border-3")) :- holds(0,env(wall,((X,Y),(X,Y')))), Y' > Y.

        attr(env(X,Y), class,("border-top";"border-dark";"border-3")) :- holds(0,env(wall,((X,Y),(X,Y')))), Y' < Y.

        attr(env(X,Y), class,("border-end";"border-dark";"border-3")) :- holds(0,env(wall,((X,Y),(X',Y)))), X' > X.

        attr(env(X,Y), class,("border-start";"border-dark";"border-3")) :- holds(0,env(wall,((X,Y),(X',Y)))), X' < X.


    %%%%%%%%%%%%%%%%%%%%%%%%
    % Agent knowledge
    %%%%%%%%%%%%%%%%%%%%%%%%
    elem(ota_agent,container,w).
    attr(ota_agent,child_layout,grid).
    % attr(ota_agent,width,200).

        % %%%%%%%%%%%%%%%%%%%%%%%%
        % % Agent Container.
        % %%%%%%%%%%%%%%%%%%%%%%%%

        elem(agent(X,Y),container,ota_agent):-map((X,Y)).
        attr(agent(X,Y),width,50):-map((X,Y)).
        attr(agent(X,Y),height,50):-map((X,Y)).
        attr(agent(X,Y),grid_column,X):-map((X,Y)).
        attr(agent(X,Y),grid_row,Y):-map((X,Y)).
        attr(agent(X,Y),class,("m-1")):-map((X,Y)).

        % Basic Grid

        % Start point
        % #TODO predicate to state that you know the cell
        attr(agent(X,Y), class,("bg-secondary")) :- map((X,Y)), occurs(T, env(agent,(X,Y))), time(T). % TODO CHange the holds


        % elem(agent(X,Y),container,ota_agent):-cave((X,Y)).
        % attr(agent(X,Y),width,50):-cave((X,Y)).
        % attr(agent(X,Y),height,50):-cave((X,Y)).
        % attr(agent(X,Y),grid_column,X):- cave((X,Y)).
        % attr(agent(X,Y),grid_row,Y) :- cave((X,Y)).

        % Observed EMPTY
        attr(agent(X,Y), class,("bg-info")) :- occurs(T,env(empty,(X,Y))).
        % Observed WALL

        % WALLS
        attr(agent(X,Y), class,("border-bottom";"border-dark";"border-3")) :- occurs(_, env(wall,((X,Y),(X,Y')))), Y' > Y.

        attr(agent(X,Y), class,("border-top";"border-dark";"border-3")) :- occurs(_, env(wall,((X,Y),(X,Y')))), Y' < Y.

        attr(agent(X,Y), class,("border-end";"border-dark";"border-3")) :- occurs(_, env(wall,((X,Y),(X',Y)))), X' > X.

        attr(agent(X,Y), class,("border-start";"border-dark";"border-3")) :- occurs(_, env(wall,((X,Y),(X',Y)))), X' < X.


        % Observed Sparkle

        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-gem";"fa-2x")) :- occurs(_,env(sparkle,(X,Y))), time(T).
        % Observed Breeze
        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-wind";"fa-2x")) :- occurs(_,env(breeze,(X,Y))), time(T).

        % Observed Smell

        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-biohazard";"fa-2x")) :- occurs(_,env(smell,(X,Y))).

        % CURRENT POSITION AT TIME T
        attr(agent(X,Y), class,("fa-solid";"fa-user";"fa-2x")):- holds(4,in(agent,(X,Y))), time(T).





%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Wumpus Observe Think Act Loop").
attr(menu_bar, icon, "fa-table-cells").
    elem(menu_bar_next, button1, menu_bar).
    attr(menu_bar_next, label, "Next Time Step").
    attr(menu_bar_next, icon, "fa-forward-step").


    elem(menu_bar_previous, button0, menu_bar).
    attr(menu_bar_previous, label, "Previous Time Step").
    attr(menu_bar_previous, icon, "fa-backward-step").

when(button0, click, call, add_assumption(time(T-1), true)):- ctime(T).
when(button1, click, call, add_assumption(time(T+1), true)):- ctime(T).
