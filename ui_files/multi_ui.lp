time(0):- not query(_).
time(T):- query(T).

elem(w,window,root).
attr(w,class,("d-flex";"flex-row";"justify-content-between")).


when(w, load, call, (ground(step,(1)),
                     set_external(query(1),true),
                    set_external(i_was_added(top_load),true)
                     )):- time(0), not _clinguin_external(query(_),true).


%%%%%%%%%%%%%%%%%%%%%
%%%ELEMENT CONTAINER
%%%%%%%%%%%%%%%%%%%%%

% %%%% GAME BOARD
elem(ota_agent,container,w).
    attr(ota_agent,child_layout,grid).

elem(sidebar,container,w).

%%% GAME INFO
%%%%%%%%%%%%%%%%%%%%%
elem(info, container, sidebar).
   attr(info, class, ("bg-info";"bg-opacity-25";"rounded";"m-3";"p-1")).

%%% Legend
%%%%%%%%%%%%%%%%%%%%%
elem(legend, container, sidebar).
   attr(legend, class, ("bg-info";"bg-opacity-25";"rounded";"m-3";"p-1")).

elem(ctl_legend(T),label, legend) :- time(T).
         attr(ctl_legend(T), label, "Legend"):- time(T).
         attr(ctl_legend(T), class, ("p-3";"h5")) :- time(T).
% TODO: Add content to the legend of what things mean

% %%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% GAME BOARD.
% %%%%%%%%%%%%%%%%%%%%%%%%%

      % TODO call this elements smething like cell, agent is missleading
      elem(agent((X,Y)),container,ota_agent)    :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),width,100)            :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),height,100)           :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),grid_column,X)        :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),grid_row,Y)           :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),class,("m-1"))        :- _clinguin_env(map((X,Y))).
        attr(agent(S),child_layout, grid)       :- _clinguin_env(map(S)).

      % A fixed container for each section
      cell_section((user,(0,1));(other,(1,0));(env,(1,1));(action,(0,0))).
      elem(agent(N,C),container,agent(C))    :- _clinguin_env(map(C)), cell_section((N,_)).
      attr(agent(N,C),width,30)    :- _clinguin_env(map(C)), cell_section((N,_)).
      attr(agent(N,C),height,30)    :- _clinguin_env(map(C)), cell_section((N,_)).
      attr(agent(N,C),grid_column,X)    :- _clinguin_env(map(C)), cell_section((N,(X,Y))).
      attr(agent(N,C),grid_row,Y)    :- _clinguin_env(map(C)), cell_section((N,(X,Y))).




      elem(agent_loc(L), button, agent(user,L))       :- holds(T-1,in(agent,L)), time(T).
         % attr(agent_loc(L),width,35)             :- holds(T-1,in(agent,L)), time(T).
         % attr(agent_loc(L),height,35)            :- holds(T-1,in(agent,L)), time(T).
         % attr(agent_loc(L),grid_column,1)        :- holds(T-1,in(agent,L)), time(T).
         % attr(agent_loc(L),grid_row,2)           :- holds(T-1,in(agent,L)), time(T).
         attr(agent_loc((X,Y)), class,
          ("border-0";"btn-outline";"disabled";"opacity-100";"text-primary")) :- holds(T-1,in(agent,(X,Y))), time(T).
         attr(agent_loc((X,Y)), icon,"fa-user")    :- holds(T-1,in(agent,(X,Y))), time(T).

      elem(state_info(E), button, agent(env,E))       :- holds(T,env(S,E)),time(T), S!= wall, not holds(T,env(wall,(_,E))).
         %  attr(state_info(E),width,35)            :- holds(T,env(_,E)), time(T).
         %  attr(state_info(E),height,35)           :- holds(T,env(_,E)), time(T).
         %  attr(state_info((X,Y)),grid_column,2)   :- holds(T,env(_,(X,Y))), time(T).
          attr(state_info((X,Y)),grid_row,2)      :- holds(T,env(_,(X,Y))), time(T).
         attr(state_info(E), class,("border-0")) :- holds(T,env(_,E)), time(T).


         % TODO: I am not sure about your predicates here, the idea is to put opacity of 25 for things you dont know for sure, and 100 for things you are certain about
         attr(state_info(E), class,("opacity-25")) :- holds(T,env(assume(_),E)), time(T).


         %% EMPTY STATE
         %%%%%%%%%%%%%%%%%%%%%%%%%%
         % TODO: add a general rule to make sure all buttons other than actions are disabled
         attr(state_info(E), class,("disabled")) :- holds(T,env(empty,E)), time(T).
         attr(state_info(E), icon,("fa-check")) :- holds(T,env(empty,E)), time(T).

         %% Unknown State
         %%%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E),class,("bg-opacity-25")) :- _clinguin_env(map(E)), not holds(T,env(empty,E)), time(T).

         %% Gold State
         %%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon,"fa-gem") :- holds(T,env(sparkle,E)), time(T).

         %% Breeze State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon,"fa-wind") :- holds(T,env(breeze,E)), time(T).
         % attr(state_info(E), class,"text-danger") :- holds(T,env(breeze,E)), time(T).

         %% Pit State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon, "fa-exclamation-circle") :- holds(T,env(assume(pit),E)), time(T).
         % attr(state_info(E), class,("bg-warning";"bg-opacity-25")) :- holds(T,env(assume(pit),E)), time(T).

         attr(state_info(E), icon,"fa-exclamation-circle") :- holds(T,env(pit,E)), time(T).
         attr(state_info(E), class,("text-danger")) :- holds(T,env(pit,E)), time(T).
         attr(state_info(E), class,("text-danger")) :- holds(T,env(assume(pit),E)), time(T).

         %% Smell State
         %%%%%%%%%%%%%%%%%%%%%%%%%

         attr(state_info(E), icon, "fa-biohazard") :- holds(T,env(smell,E)), time(T).
         % attr(state_info(E), class, "text-danger") :- holds(T,env(smell,E)), time(T).

         % attr(state_info(E), class,("bg-warning";"bg-opacity-50";"disabled")) :- holds(T,env(smell,E)), time(T).

         %% Wumpus State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon, "fa-hippo") :- holds(T,env(assume(wumpus),E)), time(T).
         attr(state_info(E), class,("disabled";"text-danger")) :- time(T),holds(T,env(assume(wumpus),E)).

         attr(state_info(E), icon,"fa-hippo") :- holds(T,env(wumpus,E)), time(T), not -holds(T,env(wumpus,E)).
         attr(state_info(E), class,("disabled";"text-danger")) :- not -holds(T,env(wumpus,E)), holds(T,env(wumpus,E)), time(T).
         % TODO: Do something like this also for the pit, if you are sure it is there, then change opacity to 100
         attr(state_info(E), class,("opacity-100")) :- not -holds(T,env(wumpus,E)), holds(T,env(wumpus,E)), time(T).

      %%%%%%%%%%%%%%%%%%%
      % AGENT KNOWN MAP
      %%%%%%%%%%%%%%%%%%%%%
      attr(agent((X,Y)),class,("bg-info";"bg-opacity-25")) :- holds(T,env(exit,(X,Y))), time(T).
      %  I don't get the lines below just keep it simple
      %  attr(agent((X,Y)),class,("bg-secondary")) :- holds(T,env(start,(X,Y))), time(T).
      %  attr(agent((X,Y)), class,("bg-secondary")) :- agent_map(_,(X,Y)), holds(T,in(agent,(X,Y))), time(T), not holds(T,env(safe,(X,Y))).
      elem(exit_lbl,label, agent(other,(X,Y))):- holds(T,env(exit,(X,Y))), time(T).
      attr(exit_lbl, label, "EXIT"):- holds(T,env(exit,(X,Y))), time(T).
      % attr(exit_lbl, class, ("bg-info";"bg-opacity-25";"text-dark";"p-1")):- holds(T,env(exit,(X,Y))), time(T).
       %%%%%%%%%%%%%%%%%%%%
       % OBSERVATIONS
       %%%%%%%%%%%%%%%%%%%%

       %%% WALLS
       %---------------------
       attr(agent((X,Y)), class,("border-bottom";"border-dark";"border-3")):- holds(T,env(wall,((X,Y),(X,Y')))), Y' > Y, time(T).
       attr(agent((X,Y)), class,("border-top";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X,Y')))), Y' < Y, time(T).
       attr(agent((X,Y)), class,("border-end";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X',Y)))), X' > X, time(T).
       attr(agent((X,Y)), class,("border-start";"border-dark";"border-3"))  :- holds(T,env(wall,((X,Y),(X',Y)))), X' < X, time(T).

       %%% PIT
       %---------------------
      %TODO  Why some many options? simplify I think the colors of the cells are too much, perhaps just chaning the opacity of the state information is enough
      % You could also put in red the environment information that is dangerous, like for the pit and the wumpus
      %  attr(agent((X,Y)), class,("bg-warning";"bg-opacity-25")) :- holds(T,env(breeze,(X,Y))), time(T).
      %  attr(agent((X,Y)), class,("bg-warning";"bg-opacity-25")) :- holds(T,env(assume(pit),(X,Y))), time(T).
      %  attr(agent((X,Y)), class,("bg-danger";"bg-opacity-50")):- holds(T,env(pit,(X,Y))), time(T).

       %%%% WUMPUS
       %---------------------
      %  attr(agent((X,Y)), class,("bg-warning";"bg-opacity-25")) :- holds(T,env(smell,(X,Y))), time(T).
      %  attr(agent((X,Y)), class,("bg-warning";"bg-opacity-50")) :- holds(T,env(assume(wumpus),(X,Y))), time(T).
      %  attr(agent((X,Y)), class,("bg-danger";"bg-opacity-50")) :-  holds(T,env(wumpus,(X,Y))), time(T).



       %%% SAFETY
       %---------------------------
       attr(agent((X,Y)), class,("bg-success";"bg-opacity-25"))      :- holds(T,env(safe,(X,Y))), time(T).
       attr(agent((X,Y)), class,("bg-success";"bg-opacity-100"))     :- holds(K,in(agent,(X,Y))), time(T), K < T.

      %  TODO: This should be for cells that are know, but no idea how to get that information. Change _clinguin_env(map((X,Y))) for the right one
       attr(agent((X,Y)), class,("bg-info";"bg-opacity-25"))      :- _clinguin_env(map((X,Y))), not holds(T,env(safe,(X,Y))), time(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MOVEMENT ACTIONs  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

         %   attr(action_button(T,L,NL,A),width,35) :-     adjacent(T-1,L,NL), holds(T-1,in(agent,L)), _any(occurs(T,A)),time(T).
         %   attr(action_button(T,L,NL,A),height,35):-     adjacent(T-1,L,NL), holds(T-1,in(agent,L)), _any(occurs(T,A)), time(T).
         %   attr(action_button(T,L,NL,A),grid_column,1) :-adjacent(T-1,L,NL), holds(T-1,in(agent,L)), _any(occurs(T,A)), time(T).
         %   attr(action_button(T,L,NL,A),grid_row,1)    :-adjacent(T-1,L,NL), holds(T-1,in(agent,L)), _any(occurs(T,A)), time(T).
           attr(action_button(T,L,NL,A),class,("btn-primary";"btn-sm")) :- adjacent(T-1,L,NL), holds(T-1,in(agent,L)), _any(occurs(T,A)), time(T).

    elem(action_button(T,(X,Y),(X+1,Y),right),
          button, agent(action,(X+1,Y)))               :- adjacent(T-1,(X,Y),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,right)), time(T).
          attr(action_button(T,(X,Y),(X+1,Y),right),icon,"fa-arrow-right") :- holds(T-1,in(agent,(X,Y))),  time(T), _any(occurs(T,right)).

    elem(action_button(T,(X,Y),(X-1,Y),left),button,agent(action,(X-1,Y))) :- adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,left)), time(T).
          attr(action_button(T,(X,Y),(X-1,Y),left), icon, "fa-arrow-left") :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,left)).

    elem(action_button(T,(X,Y),(X,Y-1),up), button, agent(action,(X,Y-1))) :- adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,up)), time(T).
          attr(action_button(T,(X,Y),(X,Y-1),up), icon, "fa-arrow-up") :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,up)).

    elem(action_button(T,(X,Y),(X,Y+1),down),button, agent(action,(X,Y+1))) :- adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,down)), time(T).
         attr(action_button(T,(X,Y),(X,Y+1),down), icon, "fa-arrow-down")    :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,down)).



     elem(extra_action(L), button, agent(other,L))   :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
         %   attr(state_info(L),width,50)      :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)),time(T).
         %   attr(state_info(L),height,50)     :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
         %   attr(state_info(L),grid_column,1) :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
         %   attr(state_info(L),grid_row,1)    :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
           attr(extra_action(L),class,("btn-primary";"btn-sm")) :-  holds(T-1,env(sparkle,L)),holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
           attr(extra_action(L), icon, "fa-hand-holding-dollar")    :- holds(T-1,env(sparkle,L)),holds(T-1,in(agent,L)), time(T), _any(occurs(T,grab_gold)).

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% SHOOT WUMPUS
%%%%%%%%%%%%%%%%%%%%%%%%
    elem(action_button(T,(X,Y),(X-1,Y),shoot_left), button, agent(other,(X-1,Y))) :- holds(T,env(wumpus,(X-1,Y))), adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_left)), time(T).
         attr(action_button(T,(X,Y),(X-1,Y),shoot_left), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X-1,Y))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_left)).


elem(action_button(T,(X,Y),(X+1,Y),shoot_right), button, agent(other,(X+1,Y))) :- holds(T,env(wumpus,(X+1,Y))), adjacent(T-1,(X,Y),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),shoot_right), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X+1,Y))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_right)).

elem(action_button(T,(X,Y),(X,Y+1),shoot_down), button, agent(other,(X,Y+1))) :- holds(T,env(wumpus,(X,Y+1))), adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),shoot_down), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X,Y+1))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_down)).

elem(action_button(T,(X,Y),(X,Y-1),shoot_up), button, agent(other,(X,Y-1))) :- holds(T,env(wumpus,(X,Y-1))), adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),shoot_up), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X,Y-1))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_up)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXIT %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elem(action_button(T,L,EXIT,leave), button, agent(action,(EXIT))) :- holds(_,env(exit,EXIT)), adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
         %   attr(action_button(T,L,EXIT,leave),width,35) :-   holds(_,env(exit,EXIT)),  adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)),time(T).
         %   attr(action_button(T,L,EXIT,leave),height,35):-    holds(_,env(exit,EXIT)), adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
         %   attr(action_button(T,L,EXIT,leave),grid_column,1) :- holds(_,env(exit,EXIT)),adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
         %   attr(action_button(T,L,EXIT,leave),grid_row,0)    :- holds(_,env(exit,EXIT)),adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
           attr(action_button(T,L,EXIT,leave),class,("btn-primary";"btn-sm")) :-holds(_,env(exit,EXIT)), adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
           attr(action_button(T,L,EXIT,leave), icon, "fa-arrow-left")    :- holds(_,env(exit,EXIT)),holds(T-1,in(agent,L)), time(T), _any(occurs(T,leave)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BUTTONS ON CLICK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      when(action_button(T,(X,Y),(X,Y+1),down), click, call, (
                            agent_action_multi(T, occurs(T,down))
                            )) :- adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), action(down), _any(occurs(T,down)), time(T).

      when(action_button(T,(X,Y),(X,Y-1),up), click, call, (
                            agent_action_multi(T, occurs(T,up))
                            )) :- adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), action(up), _any(occurs(T,up)), time(T).


      when(action_button(T,(X,Y),(X+1,Y),right), click, call, (
                            agent_action_multi(T, occurs(T,right))
                            )) :- adjacent(T-1,(X,Y),(X+1,Y)), holds(T-1,in(agent,(X,Y))), action(right), _any(occurs(T,right)), time(T).

      when(action_button(T,(X,Y),(X-1,Y),left), click, call, (
                            agent_action_multi(T, occurs(T,left))
                            )) :- adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), action(left), _any(occurs(T,left)), time(T).


      when(action_button(T,(X,Y),(X-1,Y),shoot_left), click, call, (agent_action_multi(T,occurs(T,shoot_left))
                            )) :- holds(T-1,in(agent,(X,Y))),holds(T,env(wumpus,(X-1,Y))), action(shoot_left), _any(occurs(T,shoot_left)),time(T).


      when(action_button(T,(X,Y),(X+1,Y),shoot_right), click, call, (agent_action_multi(T,occurs(T,shoot_right))
                            )) :- holds(T-1,in(agent,(X,Y))),holds(T,env(wumpus,(X+1,Y))), action(shoot_right), _any(occurs(T,shoot_right)),time(T).


      when(action_button(T,(X,Y),(X,Y-1),shoot_up), click, call, (agent_action_multi(T,occurs(T,shoot_up))
                            )) :- holds(T-1,in(agent,(X,Y))),holds(T,env(wumpus,(X,Y-1))), action(shoot_up), _any(occurs(T,shoot_up)),time(T).

      when(action_button(T,(X,Y),(X,Y+1),shoot_down), click, call, (agent_action_multi(T,occurs(T,shoot_down))
                            )) :- holds(T-1,in(agent,(X,Y))),holds(T,env(wumpus,(X,Y+1))), action(shoot_down), _any(occurs(T,shoot_down)),time(T).


      when(action_button(T,L,EXIT,leave), click, call, (agent_action_multi(T,occurs(T,leave))
                            )) :- holds(T-1,in(agent,L)),holds(T,env(exit,EXIT)), action(leave), _any(occurs(T,leave)),time(T).

      % % % Old action button - generates to
      % when(action_button(T,L,ADJ,A), click, call, (
      %                       agent_action_multi(T, occurs(T,A))
      %                       )) :- adjacent(T-1,L,ADJ), holds(T-1,in(agent,L)), action(A), _any(occurs(T,A)), time(T), A != grab_gold.

      when(extra_action(L), click, call, (agent_action_multi(T,occurs(T,grab_gold))
                            )) :- holds(T-1,in(agent,L)), action(grab_gold), _any(occurs(T,grab_gold)),time(T).



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%% GAME INFORMATION %%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      elem(ctl_info(T),label, info) :- time(T).
         attr(ctl_info(T), label, "Game Information"):- time(T).
         attr(ctl_info(T), class, ("p-3";"h5")) :- time(T).

      attr(X,class,("p-2";"disabled";"m-2";"border-0")):- elem(X,button, info).


      elem(time(T),button, info) :- time(T).
         attr(time(T), label, T):- time(T).
         % attr(time(T), class, ("bg-info";"m-2";"btn-sm")):- time(T).
         attr(time(T), icon, "fa-clock"):- time(T).

      % elem(holds(T,env(arrow,N)),button, info) :- time(T), holds(T,env(arrow,N)).
      %    attr(holds(T,env(arrow,N)), label, N):- time(T), holds(T,env(arrow,N)).
      %    attr(holds(T, env(arrow,N)), class, ("bg-info";"m-2";"btn-sm")):- time(T), holds(T,env(arrow,N)).
      %    attr(holds(T, env(arrow,N)), icon, ("fa-gun")):- time(T), holds(T,env(arrow,N)).


      % elem(holds(T,env(arrow,N)),button, info) :- time(T), -holds(T,env(arrow,N)).
      %    attr(holds(T,env(arrow,N)), label, "0"):- time(T), -holds(T,env(arrow,N)).
      %    attr(holds(T, env(arrow,N)), class, ("bg-info";"m-2";"btn-sm")):- time(T), -holds(T,env(arrow,N)).
      %    attr(holds(T, env(arrow,N)), icon, ("fa-gun")):- time(T), -holds(T,env(arrow,N)).

      % elem(holds(T,env(arrow,N)),button, info) :- time(T), -holds(T,env(arrow,N)).
      %    attr(holds(T,env(arrow,N)), label, "0"):- time(T), -holds(T,env(arrow,N)).
      %    attr(holds(T, env(arrow,N)), class, ("bg-info";"m-2";"btn-sm")):- time(T), -holds(T,env(arrow,N)).
      %    attr(holds(T, env(arrow,N)), icon, ("fa-gun")):- time(T), -holds(T,env(arrow,N)).

      elem(wumpus(T), button, info) :- time(T).
         attr(wumpus(T), label, "ALIVE"):- time(T), not holds(T, env(dead_wumpus_yell,_)).
         % attr(wumpus(T), class, ("bg-warning";"m-2";"btn-sm")):- time(T), not holds(T, env(dead_wumpus_yell,_)).%,holds(T,env(wumpus,W)).
         attr(wumpus(T), icon, ("fa-hippo")):- time(T), not holds(T, env(dead_wumpus_yell,_)).%, holds(T,env(wumpus,W)).

         attr(wumpus(T), label, "DEAD"):- time(T), holds(T, env(dead_wumpus_yell,W)).
         % attr(wumpus(T), class, ("bg-success";"m-2";"btn-sm")):- time(T), holds(T, env(dead_wumpus_yell,W)).
         attr(wumpus(T), icon, ("fa-hippo")):- time(T), holds(T, env(dead_wumpus_yell,W)).

      elem(holds(T,carry_gold), button, info):- time(T), holds(T-1,in(agent,L)), not holds(T-1,carry_gold).
         attr(holds(T,carry_gold), label, gold):- time(T), holds(T-1,in(agent,L)), not holds(T-1,carry_gold).
         attr(holds(T,carry_gold), icon, "fa-xmark" ):- time(T), holds(T-1,in(agent,L)), not holds(T-1,carry_gold).
         % attr(holds(T,carry_gold), class, ("bg-warning";"m-2";"btn-sm")):- time(T), holds(T-1,in(agent,L)), not holds(T-1,carry_gold).

         elem(holds(T,carry_gold), button, info):- time(T), holds(T-1,carry_gold).
         attr(holds(T,carry_gold), label, gold):- time(T), holds(T-1,carry_gold).
         attr(holds(T,carry_gold), icon, "fa-check" ):- time(T), holds(T-1,carry_gold).
         % attr(holds(T,carry_gold), class, ("bg-success";"m-2";"btn-sm")):- time(T), holds(T-1,carry_gold).

%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Wumpus game").
attr(menu_bar, icon, "fa-hippo").


inc_operation((      inc_agent_action(T, occurs(T,A))
                     % set_external(check(T), false),
                     % set_external(check(T+1), true),
                     % set_external(i_was_added(menu_bar),true)
        )):- _clinguin_external(query(T),true), action(A), _any(occurs(T,A)).


elem(menu_bar_next, button, menu_bar):- not goal(_).
    attr(menu_bar_next, label, "Solve incrementally"):- not goal(_).
    attr(menu_bar_next, icon, "fa-forward-step"):- not goal(_).
    % when(w, load, call, O):- _clinguin_unsat, inc_operation(O).


    when(menu_bar_next, click, call,O) :- not goal(_), inc_operation(O).

    % when(w, load, call, (select("#show occurs/2."),
    %            agent_action_multi(T, occurs(T,A)),
    %           set_external(check(T),false)
    %        )) :- action(A), _any(occurs(T,A)), time(T), _clinguin_external(check(T),true), not _clinguin_unsat.

