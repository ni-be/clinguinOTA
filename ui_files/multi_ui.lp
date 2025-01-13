time(0):- not query(_).
time(T):- query(T).

%constant use

ctime(T) :- T = #max{T2 : time(T2)}.


elem(w,window,root).
attr(w,class,("d-flex";"flex-row")).


when(w, load, call, (ground(step,(1)),
                     set_external(query(1),true) 
                     )):- time(0), not _clinguin_external(query(_),true).


%%%%%%%%%%%%%%%%%%%%%
%%%ELEMENT CONTAINER
%%%%%%%%%%%%%%%%%%%%%

%%%% Secondary AGENT CONTROL
%%%%%%%%%%%%%%%%%%
% elem(action, container, w).       

% %%%% GAME BOARD        
elem(ota_agent,container,w).
    attr(ota_agent,child_layout,grid).

%%% GAME INFO 
%%%%%%%%%%%%%%%%%%%%%
elem(info, container, w).      
   attr(info, class, ("border-start";"border-dark";"border-3")).    
   attr(info, class, ("border-end";"border-dark";"border-3")). 

      

% %%%% Secondary AGENT CONTROL
% %%%%%%%%%%%%%%%%%%
elem(action, container, w).       


  
% %%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% GAME BOARD.
% %%%%%%%%%%%%%%%%%%%%%%%%%

      elem(agent((X,Y)),container,ota_agent)    :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),width,100)            :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),height,100)           :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),grid_column,X)        :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),grid_row,Y)           :- _clinguin_env(map((X,Y))).
        attr(agent((X,Y)),class,("m-1"))        :- _clinguin_env(map((X,Y))).

        attr(agent(S),child_layout, grid):- _clinguin_env(map(S)).

                         
      elem(agent_loc(L), button, agent(L)):- holds(T-1,in(agent,L)),time(T).        
         attr(agent_loc(L),width,30):- holds(T-1,in(agent,L)),time(T).%adjecent(_,_,A).
         attr(agent_loc(L),height,30):-holds(T-1,in(agent,L)),time(T).% adjecent(_,_,A).
         attr(agent_loc(L),grid_column,1):- holds(T-1,in(agent,L)),time(T).%adjecent(_,_,(X,Y)).
         attr(agent_loc(L),grid_row,2):- holds(T-1,in(agent,L)),time(T).%adjecent(_,_,(X,Y)).
         attr(agent_loc(L),class,("border-dark";"bg-info")):-holds(T,in(agent,L)),time(T).% adjecent(_,_,A).
  
         
         attr(agent_loc((X,Y)), class,("border-dark";"bg-success";"disabled")):- holds(T-1,in(agent,(X,Y))), time(T). 
        %, not holds(T, env(escaped,_)).         

         attr(agent_loc((X,Y)), icon,"fa-user")    :- holds(T-1,in(agent,(X,Y))), time(T).
         %attr(agent_loc(A), class, ("bg-opacity-25")) :- time(T), not holds(T,in(agent,(A))), adjecent(_,_,A).

      elem(state_info(E), button, agent(E)):- holds(T,env(S,E)),time(T), S!= wall, not holds(T,env(wall,(_,E))).
          attr(state_info(E),width,30):-holds(T,env(_,E)), time(T).
          attr(state_info(E),height,30):- holds(T,env(_,E)), time(T).
          attr(state_info((X,Y)),grid_column,2):- holds(T,env(_,(X,Y))), time(T).
          attr(state_info((X,Y)),grid_row,2):- holds(T,env(_,(X,Y))), time(T).

         %% EMPTY STATE 
         %%%%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), class,("fa-solid";"fa-e";"disabled")) :- holds(T,env(empty,E)), time(T).

         %% Unknown State
         %%%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E),class,("bg-opacity-25")):- _clinguin_env(map(E)), not holds(T,env(empty,E)), time(T).
      
         
         %% Gold State
         %%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon,"fa-gem")   :- holds(T,env(sparkle,E)), time(T), not holds(T-1,in(agent,E)).

         %% Breeze State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon, "fa-wind") :- holds(T,env(breeze,E)), time(T).

         %% Pit State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon, "fa-circle-down") :- holds(T,env(assume(pit),E)), time(T).
         attr(state_info(E), class,("border-dark";"bg-warning";"bg-opacity-25")) :- holds(T,env(assume(pit),E)), time(T).

         attr(state_info(E), icon,"fa-circle-down") :- holds(T,env(pit,E)), time(T).
         attr(state_info(E), class,("border-dark";"bg-danger";"bg-opacity-50")) :- holds(T,env(pit,E)), time(T). 
         
         %% Smell State
         %%%%%%%%%%%%%%%%%%%%%%%%%

         attr(state_info(E), icon, "fa-biohazard") :- holds(T,env(smell,E)), time(T).
         attr(state_info(E), class,("border-dark";"bg-warning";"bg-opacity-50")) :- holds(T,env(smell,E)), time(T).

         %% Wumpus State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(E), icon, "fa-hippo") :- holds(T,env(assume(wumpus),E)), not -holds(T,env(wumpus,E)),time(T).
         attr(state_info(E), class,("border-dark";"bg-warning";"bg-opacity-25")) :- holds(T,env(assume(wumpus),E)),not -holds(T,env(wumpus,E)), time(T).

         attr(state_info(E), icon,"fa-hippo") :- holds(T,env(wumpus,E)), time(T), not -holds(T,env(wumpus,E)).
         attr(state_info(E), class,("border-dark";"bg-danger";"bg-opacity-50")) :- not -holds(T,env(wumpus,E)),holds(T,env(wumpus,E)), time(T).  
           
      %%%%%%%%%%%%%%%%%%%
      % AGENT KNOWN MAP
      %%%%%%%%%%%%%%%%%%%%%
       attr(agent((X,Y)),class,("fa-solid";"fa-person-through-window";"fa-2x";"bg-secondary";"bg-opacity-25")) :- holds(T,env(exit,(X,Y))), time(T). 
       attr(agent((X,Y)),class,("bg-secondary")) :- holds(T,env(start,(X,Y))), time(T).
       attr(agent((X,Y)), class,("bg-secondary")) :- agent_map(_,(X,Y)), holds(T,in(agent,(X,Y))), time(T), not holds(T,env(safe,(X,Y))).
        
       %%%%%%%%%%%%%%%%%%%%
       % OBSERVATIONS
       %%%%%%%%%%%%%%%%%%%%

       %%% EMPTY
       %-------------------
       %%% WALLS
       %---------------------
       attr(agent((X,Y)), class,("border-bottom";"border-dark";"border-3")):- holds(T,env(wall,((X,Y),(X,Y')))), Y' > Y, time(T).
       attr(agent((X,Y)), class,("border-top";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X,Y')))), Y' < Y, time(T).
       attr(agent((X,Y)), class,("border-end";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X',Y)))), X' > X, time(T).
       attr(agent((X,Y)), class,("border-start";"border-dark";"border-3"))  :- holds(T,env(wall,((X,Y),(X',Y)))), X' < X, time(T).


       %%% SAFETY
       %---------------------------
       attr(agent((X,Y)), class,("bg-success";"bg-opacity-25"))      :- holds(T,env(safe,(X,Y))), time(T). 
        

       %%% SAFETY
       %---------------------------
       attr(agent((X,Y)), class,("bg-success";"bg-opacity-25"))      :- holds(T,env(safe,(X,Y))), time(T). 

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MOVEMENT ACTIONs  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    elem(action_button(T,(X,Y),(X+1,Y),right), button, agent((X+1,Y))) :- adjacent(T-1,(X,Y),(X+1,Y)), 
                                                                          holds(T-1,in(agent,(X,Y))), 
                                                                          _any(occurs(T,right)), time(T).

           attr(action_button(T,(X,Y),(X+1,Y),right),width,35)      :- adjacent(T-1,(X,Y),(X+1,Y)), 
                                                                       holds(T-1,in(agent,(X,Y))), 
                                                                       _any(occurs(T,right)),time(T).
           attr(action_button(T,(X,Y),(X+1,Y),right),height,35)     :- adjacent(T-1,(X,Y),(X+1,Y)), 
                                                                       holds(T-1,in(agent,(X,Y))), 
                                                                       _any(occurs(T,right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),right),grid_column,1) :- adjacent(T-1,(X,Y),(X+1,Y)), 
                                                                       holds(T-1,in(agent,(X,Y))), 
                                                                       _any(occurs(T,right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),right),grid_row,1)    :- adjacent(T-1,(X,Y),(X+1,Y)),
                                                                       holds(T-1,in(agent,(X,Y))),
                                                                       _any(occurs(T,right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),right),class,
                      ("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X+1,Y)), 
                                                                       holds(T-1,in(agent,(X,Y))), 
                                                                       _any(occurs(T,right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),right),icon,
                      "fa-arrow-right")                             :- holds(T-1,in(agent,(X,Y))), 
                                                                       time(T), 
                                                                       _any(occurs(T,right)).  
         
     elem(action_button(T,(X,Y),(X-1,Y),left), button, agent((X-1,Y))) :- adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),left),width,35) :-     adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,left)),time(T).
           attr(action_button(T,(X,Y),(X-1,Y),left),height,35):-     adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),left),grid_column,1) :-adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),left),grid_row,1)    :-adjacent(T-1,(X,YL),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),left),class,("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),left), icon, "fa-arrow-left")    :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,left)).  
            

     elem(action_button(T,(X,Y),(X,Y-1),up), button, agent((X,Y-1))) :- adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),up),width,35) :-     adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,up)),time(T).
           attr(action_button(T,(X,Y),(X,Y-1),up),height,35):-     adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),up),grid_column,1) :-adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),up),grid_row,1)    :-adjacent(T-1,(X,YL),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),up),class,("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),up), icon, "fa-arrow-up")    :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,up)).  
         
     elem(action_button(T,(X,Y),(X,Y+1),down), button, agent((X,Y+1))) :- adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),down),width,35) :-     adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,down)),time(T).
           attr(action_button(T,(X,Y),(X,Y+1),down),height,35):-     adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),down),grid_column,1) :-adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),down),grid_row,1)    :-adjacent(T-1,(X,YL),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),down),class,("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),down), icon, "fa-arrow-down")    :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,down)).  
       
    
     elem(state_info(L), button, agent(L))   :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
           attr(state_info(L),width,35)      :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)),time(T).
           attr(state_info(L),height,35)     :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
           attr(state_info(L),grid_column,1) :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
           attr(state_info(L),grid_row,1)    :- holds(T-1,env(sparkle,L)), holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
           attr(state_info(L),class,("border-dark";"bg-primary";"bg-opacity-50")) :-  holds(T-1,env(sparkle,L)),holds(T-1,in(agent,L)), _any(occurs(T,grab_gold)), time(T).
           attr(state_info(L), icon, "fa-hand-holding-dollar")    :- holds(T-1,env(sparkle,L)),holds(T-1,in(agent,L)), time(T), _any(occurs(T,grab_gold)).

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% SHOOT WUMPUS
%%%%%%%%%%%%%%%%%%%%%%%%
     elem(action_button(T,(X,Y),(X-1,Y),shoot_left), button, agent((X-1,Y))) :- holds(T,env(wumpus,(X-1,Y))), adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),shoot_left),width,35)          :- holds(T,env(wumpus,(X-1,Y))),adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_left)),time(T).
           attr(action_button(T,(X,Y),(X-1,Y),shoot_left),height,35)         :- holds(T,env(wumpus,(X-1,Y))),adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),shoot_left),grid_column,1)     :- holds(T,env(wumpus,(X-1,Y))),adjacent(T-1,(X,Y),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),shoot_left),grid_row,1)        :- holds(T,env(wumpus,(X-1,Y))),adjacent(T-1,(X,YL),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),shoot_left),class,("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X-1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_left)), time(T).
           attr(action_button(T,(X,Y),(X-1,Y),shoot_left), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X-1,Y))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_left)). 

          
elem(action_button(T,(X,Y),(X+1,Y),shoot_right), button, agent((X+1,Y))) :- holds(T,env(wumpus,(X+1,Y))), adjacent(T-1,(X,Y),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),shoot_right),width,35)      :- holds(T,env(wumpus,(X+1,Y))),adjacent(T-1,(X,Y),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_right)),time(T).
           attr(action_button(T,(X,Y),(X+1,Y),shoot_right),height,35)         :- holds(T,env(wumpus,(X+1,Y))),adjacent(T-1,(X,Y),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),shoot_right),grid_column,1)     :- holds(T,env(wumpus,(X+1,Y))),adjacent(T-1,(X,Y),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),shoot_right),grid_row,1)        :- holds(T,env(wumpus,(X+1,Y))),adjacent(T-1,(X,YL),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),shoot_right),class,("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X+1,Y)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_right)), time(T).
           attr(action_button(T,(X,Y),(X+1,Y),shoot_right), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X+1,Y))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_right)).  
           
elem(action_button(T,(X,Y),(X,Y+1),shoot_down), button, agent((X,Y+1))) :- holds(T,env(wumpus,(X,Y+1))), adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),shoot_down),width,35)          :- holds(T,env(wumpus,(X,Y+1))),adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_down)),time(T).
           attr(action_button(T,(X,Y),(X,Y+1),shoot_down),height,35)         :- holds(T,env(wumpus,(X,Y+1))),adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),shoot_down),grid_column,1)     :- holds(T,env(wumpus,(X,Y+1))),adjacent(T-1,(X,Y),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),shoot_down),grid_row,1)        :- holds(T,env(wumpus,(X,Y+1))),adjacent(T-1,(X,YL),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),shoot_down),class,("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X,Y+1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_down)), time(T).
           attr(action_button(T,(X,Y),(X,Y+1),shoot_down), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X,Y+1))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_down)).  

elem(action_button(T,(X,Y),(X,Y-1),shoot_up), button, agent((X,Y-1))) :- holds(T,env(wumpus,(X,Y-1))), adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),shoot_up),width,35)          :- holds(T,env(wumpus,(X,Y-1))),adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_up)),time(T).
           attr(action_button(T,(X,Y),(X,Y-1),shoot_up),height,35)         :- holds(T,env(wumpus,(X,Y-1))),adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),shoot_up),grid_column,1)     :- holds(T,env(wumpus,(X,Y-1))),adjacent(T-1,(X,Y),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),shoot_up),grid_row,1)        :- holds(T,env(wumpus,(X,Y-1))),adjacent(T-1,(X,YL),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),shoot_up),class,("border-dark";"bg-primary";"bg-opacity-50")) :- adjacent(T-1,(X,YL),(X,Y-1)), holds(T-1,in(agent,(X,Y))), _any(occurs(T,shoot_up)), time(T).
           attr(action_button(T,(X,Y),(X,Y-1),shoot_up), icon, "fa-bullseye")    :- holds(T,env(wumpus,(X,Y-1))),holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,shoot_up)).  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXIT %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elem(action_button(T,L,EXIT,leave), button, agent((EXIT))) :- holds(_,env(exit,EXIT)), adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
           attr(action_button(T,L,EXIT,leave),width,35) :-   holds(_,env(exit,EXIT)),  adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)),time(T).
           attr(action_button(T,L,EXIT,leave),height,35):-    holds(_,env(exit,EXIT)), adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
           attr(action_button(T,L,EXIT,leave),grid_column,1) :- holds(_,env(exit,EXIT)),adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
           attr(action_button(T,L,EXIT,leave),grid_row,1)    :- holds(_,env(exit,EXIT)),adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
           attr(action_button(T,L,EXIT,leave),class,("border-dark";"bg-primary";"bg-opacity-100")) :-holds(_,env(exit,EXIT)), adjacent(T-1,L,EXIT), holds(T-1,in(agent,L)), _any(occurs(T,leave)), time(T).
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
      
      when(state_info(L), click, call, (agent_action_multi(T,occurs(T,grab_gold))
                            )) :- holds(T-1,in(agent,L)), action(grab_gold), _any(occurs(T,grab_gold)),time(T). 

              
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

      % Old action button - generates to 
      % when(action_button(T,L,ADJ,A), click, call, ( 
      %                       agent_action_multi(T, occurs(T,A))      
      %                       )) :- adjacent(T-1,L,ADJ), holds(T-1,in(agent,L)), action(A), _any(occurs(T,A)), time(T), A != grab_gold.



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%% GAME INFORMATION %%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      elem(ctl_info(T),label, info) :- time(T).
         attr(ctl_info(T), label, "Game Information"):- time(T).
         % attr(ctl_info(T), class, ("border-dark";"border-2")) :- time(T).  
      
      
      elem(time(T),button, info) :- time(T).
         attr(time(T), label, T):- time(T).
         attr(time(T), class, ("bg-info";"m-2";"btn-sm")):- time(T).       
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
         attr(wumpus(T), class, ("bg-warning";"m-2";"btn-sm")):- time(T), not holds(T, env(dead_wumpus_yell,_)).%,holds(T,env(wumpus,W)).
         attr(wumpus(T), icon, ("fa-hippo")):- time(T), not holds(T, env(dead_wumpus_yell,_)).%, holds(T,env(wumpus,W)).       
         
         attr(wumpus(T), label, "DEAD"):- time(T), holds(T, env(dead_wumpus_yell,W)).
         attr(wumpus(T), class, ("bg-success";"m-2";"btn-sm")):- time(T), holds(T, env(dead_wumpus_yell,W)).
         attr(wumpus(T), icon, ("fa-hippo")):- time(T), holds(T, env(dead_wumpus_yell,W)).  
      
      elem(holds(T,carry_gold), button, info):- time(T), holds(T,in(agent,L)), not holds(T,carry_gold).  
         attr(holds(T,carry_gold), label, gold):- time(T), holds(T,in(agent,L)), not holds(T,carry_gold).
         attr(holds(T,carry_gold), icon, "fa-xmark" ):- time(T), holds(T,in(agent,L)), not holds(T,carry_gold).
         attr(holds(T,carry_gold), class, ("bg-warning";"m-2";"btn-sm")):- time(T), holds(T,in(agent,L)), not holds(T,carry_gold).      

         elem(holds(T,carry_gold), button, info):- time(T), holds(T-1,carry_gold).
         attr(holds(T,carry_gold), label, gold):- time(T), holds(T-1,carry_gold).
         attr(holds(T,carry_gold), icon, "fa-check" ):- time(T), holds(T-1,carry_gold).
         attr(holds(T,carry_gold), class, ("bg-success";"m-2";"btn-sm")):- time(T), holds(T-1,carry_gold). 

%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Implementing the Observe Think Act Loop - Multishot Variant").

