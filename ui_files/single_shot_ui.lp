%constant use

ctime(T) :- T = #max{T2 : time(T2)}.
%#const guitime = 0.

%ctime( ).



elem(w,window,root).
attr(w,class,("d-flex";"flex-row")).

%%%%%%%%%%%%%%%%%%%%%
%%%ELEMENT CONTAINER
%%%%%%%%%%%%%%%%%%%%%

%%%% Secondary AGENT CONTROL
%%%%%%%%%%%%%%%%%%
elem(action, container, w).       

%%%% GAME BOARD        
elem(ota_agent,container,w).
    attr(ota_agent,child_layout,grid).
      

%%% GAME INFO 
%%%%%%%%%%%%%%%%%%%%%
elem(info, container, w).      
   attr(info, class, ("border-start";"border-dark";"border-3")).    
   attr(info, class, ("border-end";"border-dark";"border-3")). 
%%%% Secondary AGENT CONTROL
%%%%%%%%%%%%%%%%%%
elem(action, container, w).       

%%%%  GAME RESET
%%%%%%%%%%%%%%%%%%%%
elem(ota_agent, container,w):- ctime(T),holds(T,env(escaped,_)).

  
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% GAME BOARD.
%%%%%%%%%%%%%%%%%%%%%%%%%

      elem(agent((X,Y)),container,ota_agent) :- _all(gui(map((X,Y)))).
        attr(agent((X,Y)),width,100)            :- _all(gui(map((X,Y)))).
        attr(agent((X,Y)),height,100)           :- _all(gui(map((X,Y)))).
        attr(agent((X,Y)),grid_column,X)       :- _all(gui(map((X,Y)))).
        attr(agent((X,Y)),grid_row,Y)          :- _all(gui(map((X,Y)))).
        attr(agent((X,Y)),class,("m-1"))       :- _all(gui(map((X,Y)))).
        attr(agent(S),child_layout, grid):- _all(gui(map(S))).
                     
      elem(agent_loc(A), button, agent(A)):- agent_map(A),ctime(T), not holds(T,env(wall,(_,A))).         %, holds(T,in(agent,A)).
         attr(agent_loc(A),width,30):-agent_map(A).
         attr(agent_loc(A),height,30):-agent_map(A).
         attr(agent_loc((X,Y)),grid_column,1):-agent_map((X,Y)).
         attr(agent_loc((X,Y)),grid_row,2):-agent_map((X,Y)).
         % % attr(agent_loc(A),class,("border-dark";"bg-info")):-agent_map(A).
   
         
         attr(agent_loc((X,Y)), icon,"fa-user")    :- holds(T,in(agent,(X,Y))), ctime(T), not holds(T, env(escaped,_)).
         attr(agent_loc((X,Y)), class,("border-dark";"bg-success";"bg-opacity-50"))    :- holds(T,in(agent,(X,Y))), ctime(T), not holds(T, env(escaped,_)).         
         attr(agent_loc(A), class, ("bg-opacity-25")) :- ctime(T), not holds(T,in(agent,(A))), agent_map(A).

      elem(state_info(A), button, agent(A)):- agent_map(A),ctime(T), not holds(T,env(wall,(_,A))).
         attr(state_info(A),width,30):-agent_map(A), holds(T,env(_,A)), ctime(T).
         attr(state_info(A),height,30):-agent_map(A), holds(T,env(_,A)), ctime(T).
         attr(state_info((X,Y)),grid_column,2):-agent_map((X,Y)), holds(T,env(_,(X,Y))), ctime(T).
         attr(state_info((X,Y)),grid_row,2):-agent_map((X,Y)), holds(T,env(_,(X,Y))), ctime(T).

         %% EMPTY STATE 
         %%%%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(A), class,("fa-solid";"fa-e")) :- holds(T,env(empty,A)), ctime(T).
         attr(state_info(A),class,("border-dark";"bg-success","bg-opacity-50")):-agent_map(A), holds(T,env(empty,A)), ctime(T).
         
         %% Smell State
         %%%%%%%%%%%%%%%%%%%%%%%%%

         attr(state_info(A), icon, "fa-biohazard") :- holds(T,env(smell,A)), ctime(T).
         attr(state_info(A), class,("border-dark";"bg-warning";"bg-opacity-50")) :- holds(T,env(smell,A)), ctime(T).

         %% Wumpus State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(A), icon, "fa-hippo") :- holds(T,env(assume(wumpus),A)), ctime(T).
         attr(state_info(A), class,("border-dark";"bg-warning";"bg-opacity-25")) :- holds(T,env(assume(wumpus),A)), ctime(T).

         attr(state_info(A), icon,"fa-hippo") :- holds(T,env(wumpus,A)), ctime(T).
         attr(state_info(A), class,("border-dark";"bg-danger";"bg-opacity-50")) :- holds(T,env(wumpus,A)), ctime(T). 
         
         %% Breeze State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(A), icon, "fa-wind") :- holds(T,env(breeze,A)), ctime(T).
         attr(state_info(A), class,("border-dark";"bg-warning";"bg-opacity-50")) :- holds(T,env(breeze,A)), ctime(T).

         %% Pit State
         %%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(A), icon, "fa-circle-down") :- holds(T,env(assume(pit),A)), ctime(T).
         attr(state_info(A), class,("border-dark";"bg-warning";"bg-opacity-25")) :- holds(T,env(assume(pit),A)), ctime(T).
         
         attr(state_info(A), icon,"fa-circle-down") :- holds(T,env(pit,A)), ctime(T).
         attr(state_info(A), class,("border-dark";"bg-danger";"bg-opacity-50")) :- holds(T,env(pit,A)), ctime(T). 
         
 
         %% Gold State
         %%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(A), icon,"fa-gem")   :- holds(T,env(sparkle,A)), ctime(T).
         attr(state_info(A), class,("border-dark";"bg-primary";"bg-opacity-25"))   :- holds(T,env(sparkle,A)), ctime(T).         
         
         %% Unknown State
         %%%%%%%%%%%%%%%%%%%%%%%%%
         attr(state_info(A),class,("bg-opacity-25")):-agent_map(A), not holds(T,env(empty,A)), ctime(T).
      
      
      
         
      elem(action_button(T,explore(L,A)), button, agent(A)):- _any(action(T,explore(L,A))), ctime(T).
      elem(action_button(T, move_back(L,A)), button, agent(A)):- _any(action(T,move_back(L,A))), ctime(T).
      elem(action_button(T, escape(L,A)), button, agent(A)):- _any(action(T,escape(L,A))), ctime(T).
      elem(action_button(T, grab_gold(A)), button, agent(A)) :- _any(action(T,grab_gold(A))),ctime(T).
      elem(action_button(T, kill_wumpus(L,A)), button, agent(L)) :- _any(action(T, kill_wumpus(L,A))), ctime(T).
      elem(action_button(T, empty(A)),button, agent(A)) :- agent_map(A), not action(T,explore(_,A)),
                                                                         not action(T,move_back(_,A)),
                                                                         not action(T,escape(_,A)), 
                                                                         not action(T,kill_wumpus(A,_)),
                                                                         not action(T,grab_gold(A)),
                                                                         ctime(T).          
         
         
      when(action_button(T,A), click, call, (agent_action_semi(occurs(T,A)))) :- _any(action(T,A)), ctime(T), not holds(T,env(escaped,_)).  
      
      %% ATTRIBUTES
      %%%%%%%%%%%%%%%%%%%%%%%
         attr(action_button(T,A),width,35):- _any(action(T,A)), ctime(T).
         attr(action_button(T,A),height,35):-_any(action(T,A)), ctime(T).
         attr(action_button(T,(X,Y)),grid_column,1):-_any(action(T,(X,Y))), ctime(T).
         attr(action_button(T,(X,Y)),grid_row,1):-_any(action(T,(X,Y))), ctime(T).
         attr(action_button(T,A),class,("border-dark";"bg-primary";"bg-opacity-50")):-_any(action(T,A)), ctime(T).

         
         attr(action_button(T,empty(A)),class,("bg-opacity-50")):- agent_map(A), not action(T,explore(_,A)),
                                                                                 not action(T,move_back(_,A)),
                                                                                 not action(T,escape(_,A)), 
                                                                                 not action(T,kill_wumpus(A,_)),
                                                                                 not action(T,grab_gold(A)),
                                                                                 ctime(T).      
         
         attr(action_button(T,grab_gold(A)), class, ("bg-success")) :- _any(action(T,grab_gold(A))), ctime(T).         
         attr(action_button(T,grab_gold(A)), icon, "fa-hand-lizard") :- _any(action(T,grab_gold(A))),ctime(T).     

         attr(action_button(T,explore((X,Y),(X',Y))), icon, "fa-arrow-left") :- action(T,explore((X,Y),(X',Y))), X > X'.     
         attr(action_button(T,explore((X,Y),(X',Y))), icon, "fa-arrow-right") :- action(T,explore((X,Y),(X',Y))), X < X'.  
         attr(action_button(T,explore((X,Y),(X,Y'))), icon, "fa-arrow-up") :- action(T,explore((X,Y),(X,Y'))), Y > Y'.     
         attr(action_button(T,explore((X,Y),(X,Y'))), icon, "fa-arrow-down") :- action(T,explore((X,Y),(X,Y'))), Y < Y'.     

         
         attr(action_button(T,move_back(L,A)), class, ("bg-info";"bg-opacity-50")) :- _any(action(T,move_back(L,A))), ctime(T).         
         attr(action_button(T,move_back((X,Y),(X',Y))), icon, "fa-arrow-left") :- action(T,move_back((X,Y),(X',Y))), X > X'.     
         attr(action_button(T,move_back((X,Y),(X',Y))), icon, "fa-arrow-right") :- action(T,move_back((X,Y),(X',Y))), X < X'.  
         attr(action_button(T,move_back((X,Y),(X,Y'))), icon, "fa-arrow-up") :- action(T,move_back((X,Y),(X,Y'))), Y > Y'.     
         attr(action_button(T,move_back((X,Y),(X,Y'))), icon, "fa-arrow-down") :- action(T,move_back((X,Y),(X,Y'))), Y < Y'.     

         attr(action_button(T,escape((X,Y),(X',Y))), icon, "fa-arrow-left") :- action(T,escape((X,Y),(X',Y))), X > X'.     
         attr(action_button(T,escape((X,Y),(X',Y))), icon, "fa-arrow-right") :- action(T,escape((X,Y),(X',Y))), X < X'.  
         attr(action_button(T,escape((X,Y),(X,Y'))), icon, "fa-arrow-up") :- action(T,escape((X,Y),(X,Y'))), Y > Y'.     
         attr(action_button(T,escape((X,Y),(X,Y'))), icon, "fa-arrow-down") :- action(T,escape((X,Y),(X,Y'))), Y < Y'.     


         attr(action_button(T,kill_wumpus((X,Y),L)),class, ("bg-danger";"bg-opacity-50")):- action(T,kill_wumpus((X,Y),L)).
         attr(action_button(T,kill_wumpus((X,Y),L)),icon, "fa-gun"):- action(T,kill_wumpus((X,Y),L)).

      %%%% ASSUME BUTTON
      %%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%
       % AGENT KNOWN MAP
       %%%%%%%%%%%%%%%%%%%%%
       attr(agent((X,Y)),class,("fa-solid";"fa-person-through-window";"fa-2x";"bg-secondary";"bg-opacity-25")) :- _all(holds(T,env(exit,(X,Y)))), time(T). 
       attr(agent((X,Y)),class,("bg-secondary")) :- _all(holds(T,env(start,(X,Y)))), time(T).
       attr(agent((X,Y)), class,("bg-secondary")) :- _all(agent_map((X,Y))), _all(holds(T,in(agent,(X,Y)))), time(T), not _any(holds(T,env(safe,(X,Y)))).
        
       %%%%%%%%%%%%%%%%%%%%
       % OBSERVATIONS
       %%%%%%%%%%%%%%%%%%%%

       %%% EMPTY
       %-------------------
       %%% WALLS
       %---------------------
       attr(agent((X,Y)), class,("border-bottom";"border-dark";"border-3")):- holds(T,env(wall,((X,Y),(X,Y')))), Y' > Y, ctime(T).
       attr(agent((X,Y)), class,("border-top";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X,Y')))), Y' < Y, ctime(T).
       attr(agent((X,Y)), class,("border-end";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X',Y)))), X' > X, ctime(T).
       attr(agent((X,Y)), class,("border-start";"border-dark";"border-3"))  :- holds(T,env(wall,((X,Y),(X',Y)))), X' < X, ctime(T).

       %%% WUMPUS
       %-----------------------        
       attr(agent((X,Y)), class,("bg-warning";"bg-opacity-25")) :- holds(T,env(smell,(X,Y))), ctime(T).
       attr(agent((X,Y)), class,("bg-warning";"bg-opacity-25")) :- holds(T,env(assume(wumpus),(X,Y))), ctime(T).
       attr(agent((X,Y)), class,("bg-warning")) :- holds(T,env(wumpus,(X,Y))), ctime(T).

       
       %attr(agent((X,Y)), class,("bg-warning";"bg-opacity-25";"fa-solid";"fa-hippo";"fa-2x")) :- _clinguin_assume(holds(T,env(assume(wumpus),(X,Y))),true), ctime(T).
       %%% PIT
       %------------------------
       attr(agent((X,Y)), class,("bg-warning";"bg-opacity-50")) :- holds(T,env(breeze,(X,Y))), ctime(T).
       attr(agent((X,Y)), class,("bg-warning";"bg-opacity-25")) :- holds(T,env(assume(pit),(X,Y))), ctime(T).
       attr(agent((X,Y)), class,("bg-warning")) :- holds(T,env(pit,(X,Y))), ctime(T).


       %%% SAFETY
       %---------------------------
       attr(agent((X,Y)), class,("bg-success";"bg-opacity-25"))   :- holds(T,env(safe,(X,Y))), ctime(T), agent_map((X,Y)). 
       attr(agent((X,Y)), class,("bg-success";"bg-opacity-100"))   :- holds(K,in(agent,(X,Y))), ctime(T), time(K), K < T.
        



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%% NEXT ACTION DROPDOWN MENU    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
      %elem(dd_holds(A), dropdown_menu, agent(A)):- agent_map(A),ctime(T), not holds(T,env(wall,(_,A))).
      %    attr(dd_holds(A),width,25):-agent_map(A).
      %    attr(dd_holds(A),height,25):-agent_map(A).
      %    attr(dd_holds((X,Y)),grid_column,X):-agent_map((X,Y)).
      %    attr(dd_holds((X,Y)),grid_row,Y):-agent_map((X,Y)).
      %    attr(dd_holds(A),class,("border-dark";"bg-info","bg-opacity-25")):-agent_map(A).

      %    %%%%%%%%%%%%%%%
      %    %% CELLS
      %    %%%%%%%%%%%%%%%
      %    elem(dd_items(A,H), dropdown_menu_item, dd_holds(A)) :- agent_map(A), ctime(T), holds(T,env(H,A)).
      %    attr(dd_items(A,H), label, H):- holds(T,env(H,A)),ctime(T).

      %    elem(dd_items(A,H), dropdown_menu_item, dd_holds(A)) :- agent_map(A), ctime(T), -holds(T,env(H,A)).
      %    attr(dd_items(A,H), label, H):- -holds(T,env(H,A)), ctime(T).
      %    attr(dd_items(A,H), class,("text-danger")) :- -holds(T,env(H,A)),ctime(T).  
      %    when(dd_items(A,H), click,call,(add_assumption(holds(T,env(H,A)),true))) :- -holds(T,env(H,A)), ctime(T).
      
      % elem(holds(T,env(E,A)),dropdown_menu_item, holds(T,env(E,A))) :- agent_map(A), holds(T,env(E,A)).
      % attr(assume(AM), label, E ) :- holds(T,env(E,AM)), ctime(T), agent_map(AM).
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%% GAME INFORMATION %%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      elem(ctl_info(T),button, info) :- ctime(T).
         attr(ctl_info(T), label, "Game Information"):- ctime(T).
         attr(ctl_info(T), class, ("border-dark";"border-2")) :- ctime(T).  
      
      
      elem(ctime(T),button, info) :- ctime(T).
         attr(ctime(T), label, T):- ctime(T).
         attr(ctime(T), class, ("bg-info";"m-2";"btn-sm")):- ctime(T).       
         attr(ctime(T), icon, "fa-clock"):- ctime(T).

      elem(holds(T,env(arrow,N)),button, info) :- ctime(T), holds(T,env(arrow,N)).
         attr(holds(T,env(arrow,N)), label, N):- ctime(T), holds(T,env(arrow,N)).
         attr(holds(T, env(arrow,N)), class, ("bg-info";"m-2";"btn-sm")):- ctime(T), holds(T,env(arrow,N)).
         attr(holds(T, env(arrow,N)), icon, ("fa-gun")):- ctime(T), holds(T,env(arrow,N)).      

      
      elem(holds(T,env(arrow,N)),button, info) :- ctime(T), -holds(T,env(arrow,N)).
         attr(holds(T,env(arrow,N)), label, "0"):- ctime(T), -holds(T,env(arrow,N)).
         attr(holds(T, env(arrow,N)), class, ("bg-info";"m-2";"btn-sm")):- ctime(T), -holds(T,env(arrow,N)).
         attr(holds(T, env(arrow,N)), icon, ("fa-gun")):- ctime(T), -holds(T,env(arrow,N)).      
      
      elem(holds(T,env(arrow,N)),button, info) :- ctime(T), -holds(T,env(arrow,N)).
         attr(holds(T,env(arrow,N)), label, "0"):- ctime(T), -holds(T,env(arrow,N)).
         attr(holds(T, env(arrow,N)), class, ("bg-info";"m-2";"btn-sm")):- ctime(T), -holds(T,env(arrow,N)).
         attr(holds(T, env(arrow,N)), icon, ("fa-gun")):- ctime(T), -holds(T,env(arrow,N)).      

      elem(wumpus(T), button, info) :- ctime(T).
         attr(wumpus(T), label, "ALIVE"):- ctime(T), not holds(T, env(dead_wumpus,_)).
         attr(wumpus(T), class, ("bg-warning";"m-2";"btn-sm")):- ctime(T), not holds(T, env(dead_wumpus,_)).%,holds(T,env(wumpus,W)).
         attr(wumpus(T), icon, ("fa-hippo")):- ctime(T), not holds(T, env(dead_wumpus,_)).%, holds(T,env(wumpus,W)).       
         
         attr(wumpus(T), label, "DEAD"):- ctime(T), holds(T, env(dead_wumpus,W)).
         attr(wumpus(T), class, ("bg-success";"m-2";"btn-sm")):- ctime(T), holds(T, env(dead_wumpus,W)).
         attr(wumpus(T), icon, ("fa-hippo")):- ctime(T), holds(T, env(dead_wumpus,W)).  
      
      elem(holds(T,carry_gold(L)), button, info):- ctime(T), holds(T,in(agent,L)), not holds(T,carry_gold(_)).  
         attr(holds(T,carry_gold(L)), label, gold):- ctime(T), holds(T,in(agent,L)), not holds(T,carry_gold(_)).
         attr(holds(T,carry_gold(L)), icon, "fa-xmark" ):- ctime(T), holds(T,in(agent,L)), not holds(T,carry_gold(_)).
         attr(holds(T,carry_gold(L)), class, ("bg-warning";"m-2";"btn-sm")):- ctime(T), holds(T,in(agent,L)), not holds(T,carry_gold(_)).      

         elem(holds(T,carry_gold(L)), button, info):- ctime(T), holds(T,carry_gold(L)).
         attr(holds(T,carry_gold(L)), label, gold):- ctime(T), holds(T,carry_gold(L)).
         attr(holds(T,carry_gold(L)), icon, "fa-check" ):- ctime(T), holds(T,carry_gold(L)).
         attr(holds(T,carry_gold(L)), class, ("bg-success";"m-2";"btn-sm")):- ctime(T), holds(T,carry_gold(L)). 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Secondary AGENT CONTROL %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
      elem(act_info(T),button, action) :- ctime(T).
         attr(act_info(T), label, "Possible Actions"):- ctime(T).         
         attr(act_info(T), class, ("border-dark";"border-2")) :- ctime(T).  
      
      elem(action(T,A), button, action):- _any(action(T,A)), ctime(T).
         attr(action(T,explore(L,L')), label, "Explore"):- _any(action(T,explore(L,L'))), ctime(T).
         attr(action(T,move_back(L,L')), label, "Visited Cave"):- _any(action(T,move_back(L,L'))), ctime(T).
         attr(action(T,escape(L,L')), label, "Escape"):- _any(action(T,escape(L,L'))), ctime(T).        
         attr(action(T,grab_gold(L)), label, "Grab Gold"):- _any(action(T,grab_gold(L))), ctime(T).
         attr(action(T,kill_wumpus(L,L')), label, "Shoot the Wumpus!"):- _any(action(T,kill_wumpus(L,L'))), ctime(T).
         
         attr(action(T,A), class, ("bg-info";"m-2";"btn-sm")):-  _any(action(T,A)), ctime(T).
         attr(action(T,A), class, ("bg-primary";"m-2";"btn-sm")) :- _any(action(T,A)), ctime(T).


         attr(action(T,grab_gold((X,Y))), icon, "fa-holding-circle") :- action(T,grab_gold((X,Y))).     

         attr(action(T,explore((X,Y),(X',Y))), icon, "fa-arrow-left") :- action(T,explore((X,Y),(X',Y))), X > X'.     
         attr(action(T,explore((X,Y),(X',Y))), icon, "fa-arrow-right") :- action(T,explore((X,Y),(X',Y))), X < X'.  
         attr(action(T,explore((X,Y),(X,Y'))), icon, "fa-arrow-up") :- action(T,explore((X,Y),(X,Y'))), Y > Y'.     
         attr(action(T,explore((X,Y),(X,Y'))), icon, "fa-arrow-down") :- action(T,explore((X,Y),(X,Y'))), Y < Y'.     
      
         attr(action(T,move_back((X,Y),(X',Y))), icon, "fa-arrow-left") :- action(T,move_back((X,Y),(X',Y))), X > X'.     
         attr(action(T,move_back((X,Y),(X',Y))), icon, "fa-arrow-right") :- action(T,move_back((X,Y),(X',Y))), X < X'.  
         attr(action(T,move_back((X,Y),(X,Y'))), icon, "fa-arrow-up") :- action(T,move_back((X,Y),(X,Y'))), Y > Y'.     
         attr(action(T,move_back((X,Y),(X,Y'))), icon, "fa-arrow-down") :- action(T,move_back((X,Y),(X,Y'))), Y < Y'.     

         attr(action(T,backtrack((X,Y),(X',Y))), icon, "fa-arrow-left") :- action(T,backtrack((X,Y),(X',Y))), X > X'.     
         attr(action(T,backtrack((X,Y),(X',Y))), icon, "fa-arrow-right") :- action(T,backtrack((X,Y),(X',Y))), X < X'.  
         attr(action(T,backtrack((X,Y),(X,Y'))), icon, "fa-arrow-up") :- action(T,backtrack((X,Y),(X,Y'))), Y > Y'.     
         attr(action(T,backtrack((X,Y),(X,Y'))), icon, "fa-arrow-down") :- action(T,backtrack((X,Y),(X,Y'))), Y < Y'.     

         attr(action(T,escape((X,Y),(X',Y))), icon, "fa-arrow-left") :- action(T,escape((X,Y),(X',Y))), X > X'.     
         attr(action(T,escape((X,Y),(X',Y))), icon, "fa-arrow-right") :- action(T,escape((X,Y),(X',Y))), X < X'.  
         attr(action(T,escape((X,Y),(X,Y'))), icon, "fa-arrow-up") :- action(T,escape((X,Y),(X,Y'))), Y > Y'.     
         attr(action(T,escape((X,Y),(X,Y'))), icon, "fa-arrow-down") :- action(T,escape((X,Y),(X,Y'))), Y < Y'.     

         attr(action(T,kill_wumpus((X,Y),L)),icon, "fa-gun"):- action(T,kill_wumpus((X,Y),L)).
      
      when(action(T,A), click, call, (agent_action_semi(occurs(T,A)))) :- _any(action(T,A)), ctime(T), not holds(T,env(escaped,_)).  


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% MESSAGES
%%%%%%%%%%%%%%%%%%%%%%%%%


elem(message_wumpus(W), message, info):- holds(T,env(wumpus_yell,W)), holds(T, in(agent(X))).
      attr(message_wumpus(W), title, "You Killed the Wumpus!"):- holds(T,env(wumpus_yell,W)).
      attr(message_wumpus(W), message, "Please Continue Exploring the Cave"):- holds(T,env(wumpus_yell,W)), not holds(T, carry_gold(_)).      
      attr(message_wumpus(W), message, "Time to leave the cave"):- holds(T,env(wumpus_yell,W)), holds(T, carry_gold(_)).      
      attr(message_wumpus(W), type, error):- holds(T,env(wumpus_yell,W)).
      
      
      elem(message_sparke(S), message, ota_agent):- holds(T,env(sparkle,S)).
      attr(message_sparke(S), title, "You found the Gold!"):- holds(T,env(sparkke,S)).
      attr(message_sparke(S), message, "Congrats, you found the gold time to leave"):- holds(T,env(sparke,S)).      
      attr(message_sparkle(S), type, error):- holds(T,env(sparkle,S)).
      
     elem(kw, container, w).
         elem(wy(W,T),modal,kw) :- ctime(T),holds(T,env(wumpus_yell,W)).
         attr(wy(W,T), title, "You have killed the Wumpus") :-  ctime(T),holds(T,env(wumpus_yell,W)).
         attr(wy(W,T), size, "m") :- ctime(T),holds(T,env(wumpus_yell,W)).
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%% DROPDOWN MENU 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      


      
% when(dropdown(A), click, call, (agent_action(occurs(T,A)))) :- occurs(T,A), max_time(T).  

% when(dropdown(A), click, call, set_constant("guitime", T+1)):- occurs(_,A), time(T+1), max_time(K), T <  K.



% %when(dropdown(A), click, call, select) :- _any(occurs(T,A)), time(T).  
% % when(dropdown(A), click, call, (select,update)) :- _any(occurs(T,A)), time(T).  


%%%%%%%%%%%%%%%%%%%
%%%%% GAME RESET 
%%%%%%%%%%%%%%%%%%%
   elem(restart(T), button, ota_agent):- ctime(T), holds(T,env(escaped,_)).
        attr(restart(T), label, "restart game") :- ctime(T), holds(T,env(escaped,_)).
        attr(restart(T), class, ("bg-warning";"m-2";"btn-sm")):-  ctime(T), holds(T,env(escaped,_)).   
        attr(restart(T), icon, "fa-clock"):- ctime(T), holds(T,env(escaped,_)). 
   
        when(restart(T), click, call, (restart())) :- ctime(T), holds(_,env(escaped,_)).  
 

% %%%%%%%%%%%%%%%%%%%%%%%%
% % Menu bar
% %%%%%%%%%%%%%%%%%%%%%%%
% elem(menu_bar, menu_bar, w).
% attr(menu_bar, title, "Wumpus Observe Think Act Loop").

% attr(menu_bar, icon, "fa-table-cells").
%      elem(menu_bar_prev, button, menu_bar):- time(T), time(T-1), T > 0.
%      attr(menu_bar_prev, label, "Previous Time Step"):- time(T), time(T-1), T > 0.
%      attr(menu_bar_prev, icon, "fa-backward-step"):- time(T), time(T-1), T > 0.

% when(menu_bar_prev, click, call, set_constant("guitime", T-1)):- time(T), time(T-1), T > 0.

%      elem(menu_bar_next, button, menu_bar). %:- time(T), time(T+1), max_time(K), T < K, T != K.
%      attr(menu_bar_next, label, "Next Time Step"). %:- time(T), time(T+1), max_time(K), T < K, T != K. 
%      attr(menu_bar_next, icon, "fa-forward-step"). %:- time(T), time(T+1),max_time(K), T < K, T != K.

% when(menu_bar_next, click, call, set_constant("guitime", T+1)):- time(T), time(T+1), max_time(K), T < K.




%% GRAVEYARD
%%?????? Why keep?
% %Hold believe that 
% attr(agent(X,Y), class,("bg-success";"fa-solid";"fa-wind";"fa-2x")) :- holds(T,env(breeze,(X,Y))), time(T).
        

% when(occurs(T,A), click, call, set_constant("guitime", T+1)):- occurs(T,A), ctime(T), time(K), T <  K.
       
 
