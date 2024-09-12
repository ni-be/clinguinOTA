%constant use

#const guitime = 0.

ctime(guitime).

elem(w,window,root).
attr(w,class,("d-flex";"flex-row")).

    %%%%%%%%%%%%%%%%%%%%%%%%
    % env knowledge
    %%%%%%%%%%%%%%%%%%%%%%%%
    elem(ota,container,w).
    attr(ota,child_layout,grid).
 
    %attr(ota,width,200).
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

        % Basic Grid

        % % Start point
        attr(env(X,Y), class,("bg-secondary")) :- holds(0,in(agent,(X,Y))). %, ctime(T), T == 0.
        attr(env(X,Y), class,("bg-info";"bg-opacity-25")) :- map((X,Y)), not holds(T, env(_,(X,Y))), ctime(T).
        % % ENV
        attr(env(X,Y), class,("fa-solid";"fa-circle-down";"fa-2x")) :- eholds(T, env(pit,(X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("fa-solid";"fa-hippo";"fa-2x")) :- eholds(T, env(wumpus,(X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("fa-solid";"fa-gem";"fa-2x")) :- eholds(T, env(gold, (X,Y))), map((X,Y)), ctime(T).
        attr(env(X,Y), class,("fa-solid";"fa-user";"fa-2x")) :- holds(T,in(agent,(X,Y))), map((X,Y)), ctime(T).
    
        % room the agent visited
        attr(env(X,Y), class,("bg-success")) :- holds(T, in(agent,(X,Y))), map((X,Y)), ctime(T).

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
    %attr(ota_agent,width,200).

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
        
        attr(agent(X,Y), class,("bg-secondary")) :- map((X,Y)), holds(T, in(agent,(X,Y))), ctime(T).
        

        % elem(agent(X,Y),container,ota_agent):-cave((X,Y)).
        % attr(agent(X,Y),width,50):-cave((X,Y)).
        % attr(agent(X,Y),height,50):-cave((X,Y)).
        % attr(agent(X,Y),grid_column,X):- cave((X,Y)).
        % attr(agent(X,Y),grid_row,Y) :- cave((X,Y)).

       % Observed EMPTY
        attr(agent(X,Y), class,("bg-info")) :- holds(T,env(empty,(X,Y))), ctime(T).
       % WALLS
        attr(agent(X,Y), class,("border-bottom";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X,Y')))), Y' > Y, ctime(T).
        attr(agent(X,Y), class,("border-top";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X,Y')))), Y' < Y, ctime(T).
        attr(agent(X,Y), class,("border-end";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X',Y)))), X' > X, ctime(T).
        attr(agent(X,Y), class,("border-start";"border-dark";"border-3")) :- holds(T, env(wall,((X,Y),(X',Y)))), X' < X, ctime(T).


        % Observed Sparkle

        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-gem";"fa-2x")) :- occurs(T,env(sparkle,(X,Y))), ctime(T).
         % Observed Breeze
        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-wind";"fa-2x")) :- occurs(T,env(breeze,(X,Y))), ctime(T).

        % Observed Smell

        attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-biohazard";"fa-2x")) :- occurs(T,env(smell,(X,Y))), ctime(T).
        % CURRENT POSITION AT cTIME T
        attr(agent(X,Y), class,("fa-solid";"fa-user";"fa-2x")):- holds(T,in(agent,(X,Y))), ctime(T).



% TODO use label to add time and more information. environment
% fix bug environment knows 

%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Wumpus Observe Think Act Loop").
attr(menu_bar, icon, "fa-table-cells").
     elem(menu_bar_next, button, menu_bar):- ctime(T), time(T+1).
     attr(menu_bar_next, label, "Next cTime Step"):- ctime(T), time(T+1).
     attr(menu_bar_next, icon, "fa-forward-sep"):- ctime(T), time(T+1).

when(menu_bar_next, click, call, set_constant("guitime", T+1)):- ctime(T), time(T+1).
