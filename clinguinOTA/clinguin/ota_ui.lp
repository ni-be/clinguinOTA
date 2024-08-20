elem(w,window,root).

    %%%%%%%%%%%%%%%%%%%%%%%%
    % env knowledge
    %%%%%%%%%%%%%%%%%%%%%%%%
    elem(ota,container,w).
    attr(ota,child_layout,grid).
    attr(ota,width,200).
    % attr(ota,height,200).

        %%%%%%%%%%%%%%%%%%%%%%%%
        % Environment Cont.
        %%%%%%%%%%%%%%%%%%%%%%%%
        elem(env(X,Y),container,ota):-map((X,Y)).
        attr(env(X,Y),width,50):-map((X,Y)).
        attr(env(X,Y),height,50):-map((X,Y)).
        attr(env(X,Y),grid_column,X):-map((X,Y)).
        attr(env(X,Y),grid_row,Y):-map((X,Y)).

        % Basic Grid

        % Start point
        attr(env(X,Y), class,("border";"border-dark";"bg-info")) :- holds(0, start((X,Y))).
        % ENV        
        attr(env(X,Y), class,("border";"border-dark";"fa-solid";"fa-circle-down";"fa-2x")) :- holds(0, env, in(pit,(X,Y))), map((X,Y)).
        attr(env(X,Y), class,("border";"border-dark";"fa-solid";"fa-hippo";"fa-2x")) :- holds(0, env, in(wumpus,(X,Y))), map((X,Y)).
        attr(env(X,Y), class,("border";"border-dark";"fa-solid";"fa-gem";"fa-2x")) :- holds(0, env, in(gold, (X,Y))), map((X,Y)).
        attr(env(X,Y), class,("border";"border-dark";"fa-solid";"fa-user";"fa-2x")) :- holds(4,in(agent,(X,Y))), map((X,Y)).
        % room the agent visited
        attr(env(X,Y), class,("border";"border-dark";"bg-success")) :- holds(4, env,in(agent,(X,Y))), map((X,Y)). 

        % ENV EFFECTS
        
        attr(env(X,Y), class,("border";"border-dark";"fa-solid";"fa-wind";"fa-2x")) :- holds(0, env, effect(breeze,(X,Y))), map((X,Y)).
        
        attr(env(X,Y), class,("border";"border-dark";"fa-solid";"fa-biohazard";"fa-2x")) :- holds(0, env, effect(smell,(X,Y))), map((X,Y)).
        attr(env(X,Y), class,("border";"border-dark";"bg-warning")) :- holds(0, env, effect(sparkle,(X,Y))), map((X,Y)).

        
                
        attr(env(X,Y), class,("border")):- map((X,Y)).
        % WALLS 
        attr(env(X,Y), class,("rounded-bottom";)) :- holds(0,env, effect(wall,((X,Y),(X,Y')))), Y' > Y.

        attr(env(X,Y), class,("rounded-top")) :- holds(0,env, effect(wall,((X,Y),(X,Y')))), Y' < Y.

        attr(env(X,Y), class,("rounded-right";"bg-danger")) :- holds(0,env, effect(wall,((X,Y),(X',Y)))), X' > X.

        attr(env(X,Y), class,("rounded-left";"bg-warning")) :- holds(0,env, effect(wall,((X,Y),(X',Y)))), X' < X.

            
        
        % %%%%%%%%%%%%%%%%%%%%%%%%
        % % Agent Container. 
        % %%%%%%%%%%%%%%%%%%%%%%%%
        time(4).

        elem(agent(X,Y),container,ota):-cave((X,Y)).
        attr(agent(X,Y),width,50):-cave((X,Y)).
        attr(agent(X,Y),height,50):-cave((X,Y)).
        attr(agent(X,Y),grid_column,X+100):- cave((X,Y)).
        attr(agent(X,Y),grid_row,Y+100) :- cave((X,Y)).

        % Observed EMPTY
        attr(agent(X,Y), class,("border";"bg-success")) :- holds(4,env(empty,(X,Y))).
        % Observed WALL

        attr(agent(X,Y), class,("border";"rounded-top")) :- holds(4,env(wall,((X,Y),(X,Y')))), Y' < Y.

        attr(agent(X,Y), class,("border";"rounded-bottom")) :- holds(4,env(wall,((X,Y),(X,Y')))), Y' > Y.
        attr(agent(X,Y), class,("border";"rounded-left")) :- holds(4,env(wall,((X,Y),(X',Y)))), X' < X.

        attr(agent(X,Y), class,("border";"rounded-right")) :- holds(4,env(wall,((X,Y),(X',Y)))), X' > X.
        % Observed Sparkle

        attr(agent(X,Y), class,("border";"bg-success";"border-dark";"fa-solid";"fa-gem";"fa-2x")) :- holds(4,env(sparkle,(X,Y))).
        % Observed Breeze
        attr(agent(X,Y), class,("border";"bg-success";"border-dark";"fa-solid";"fa-wind";"fa-2x")) :- holds(4,env(breeze,(X,Y))).

        % Observed Smell
        
        attr(agent(X,Y), class,("border";"bg-success";"border-dark";"fa-solid";"fa-biohazard";"fa-2x")) :- holds(4,env(smell,(X,Y))).
        
        % CURRENT POSITION AT TIME T
        attr(agent(X,Y), class,("border";"fa-solid";"fa-user";"fa-2x")):- holds(4,in(agent,(X,Y))), time(T).

        
        

        
%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Wumpus Observe Think Act Loop").
attr(menu_bar, icon, "fa-table-cells").

