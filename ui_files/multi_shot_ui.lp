time(0):- not query(_).
time(T):- query(T).

info(E):- env(E).
info(assume(pit)).info(assume(wumpus)).info(wumpus).info(pit).info(exit).
action_legend(move;grab_gold;shoot;leave).

elem(w,window,root).
attr(w,class,("d-flex";"flex-row")).

when(w, load, call, (ground(step,(1)),
                     set_external(query(1),true),
                     set_external(i_was_added(top_load),true) 
                     )):- time(0), not _clinguin_external(query(_),true).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALL ELEMENT CONTAINERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% GAME BOARD        
%%%%%%%%%%%%%%%%%%%%
elem(ota_agent,container,w).
    attr(ota_agent,child_layout,grid).

%% SIDEBAR / LEGEND / LIVE GAME INFO 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elem(sidebar,container,w).


% GAME BOARD.
%%%%%%%%%%%%%%%%%%%%%%%%%

elem(map((X,Y)),container,ota_agent)                :- _clinguin_env(map((X,Y))).
   attr(map((X,Y)),width,130)                       :- _clinguin_env(map((X,Y))).
   attr(map((X,Y)),height,130)                      :- _clinguin_env(map((X,Y))).
   attr(map((X,Y)),grid_column,X)                   :- _clinguin_env(map((X,Y))).
   attr(map((X,Y)),grid_row,Y)                      :- _clinguin_env(map((X,Y))).
   attr(map((X,Y)),class,("m-1"))                   :- _clinguin_env(map((X,Y))).
   attr(map(S),child_layout, grid)                  :- _clinguin_env(map(S)).

   %% WALLS
   %%%%%%%%%%%%%%%%%%%%%
   attr(map((X,Y)), class,("border-bottom";"border-dark";"border-3")) :- holds(T,env(wall,((X,Y),(X,Y')))), Y' > Y, time(T).
   attr(map((X,Y)), class,("border-top";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X,Y')))), Y' < Y, time(T).
   attr(map((X,Y)), class,("border-end";"border-dark";"border-3"))    :- holds(T,env(wall,((X,Y),(X',Y)))), X' > X, time(T).
   attr(map((X,Y)), class,("border-start";"border-dark";"border-3"))  :- holds(T,env(wall,((X,Y),(X',Y)))), X' < X, time(T).

   %% PIT
   %%%%%%%%%%%%%%%%%%%%
   attr(map(L), class,("bg-warning";"bg-opacity-25"))    :- holds(T,env(assume(pit),L)), time(T).
   attr(map(L), class,("bg-danger";"bg-opacity-50"))     :- holds(T,env(pit,L)), time(T).

   %%%% WUMPUS
   %%%%%%%%%%%%%%%%%%%%
   attr(map(L), class,("bg-warning";"bg-opacity-25"))     :- holds(T,env(assume(wumpus),L)), time(T).
   attr(map(L), class,("bg-danger";"bg-opacity-50"))      :-  holds(T,env(wumpus,L)), time(T).     

   %% SAFETY
   %%%%%%%%%%%%%%%%%%%
   attr(map((X,Y)), class,("bg-success";"bg-opacity-25")) :- holds(T,env(safe,(X,Y))), time(T). 
   attr(map((X,Y)), class,("bg-success";"bg-opacity-75")) :- holds(K,in(agent,(X,Y))), time(T), K < T.

   %% EXIT
   %%%%%%%%%%%%%%%%%%
   attr(map(L), class,("bg-opacity-50";"bg-info"))        :- holds(T,env(exit,L)), time(T), not holds(T-1,env(carry_gold,_)).
   attr(map(L), class,("bg-opacity-25";"bg-success"))     :- holds(T,env(exit,L)), time(T), holds(T-1,env(carry_gold,_)). 
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INFORMATION on the CONTENTS/Observation/State of each Room
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


room_section((agent,(0,1));(env,(1,0));(action,(0,0))).
elem(room(R,S), container, map(R))      :- _clinguin_env(map(R)), room_section((S,_)).
   attr(room(R,S),width,60)             :- _clinguin_env(map(R)), room_section((S,_)).
   attr(room(R,S),height,60)            :- _clinguin_env(map(R)), room_section((S,_)).
   attr(room(R,S),grid_column,X)        :- _clinguin_env(map(R)), room_section((S,(X,Y))).
   attr(room(R,S),grid_row,Y)           :- _clinguin_env(map(R)), room_section((S,(X,Y))).

   
     attr(room_section(R,S), class,("m-1"))            :- holds(T-1,env(E,R)), E != wall, time(T), room_section((S,_)).
     attr(room_section(R,S), width,50)                 :- _clinguin_env(map(R)), time(T), room_section((S,_)).  
     attr(room_section(R,S), height,50)                :- _clinguin_env(map(R)), time(T), room_section((S,_)).  
     attr(room_section(R,S),class,("disabled"))        :- holds(T-1,env(E,R)), E != wall, time(T), room_section((S,_)), S != action. 

elem(room_section(R,agent), button, room(R,agent))     :- holds(T-1,in(agent,R)), time(T).   
     attr(room_section(R,agent), icon,"fa-user")       :- holds(T-1,in(agent,R)), time(T).           
     attr(room_section(R,agent),class,("bg-opacity-50";"bg-success")) :- holds(T-1,in(agent,R)), time(T).        

   
elem(room_section(R,env), button, room(R,env))  :- not holds(T,env(empty,R)),holds(T,env(E,R)), E != wall, time(T), E!= safe.
     attr(room_section(R,env),class,("bg-warning";"bg-opacity-25"))   :- holds(T,env(assume(_),R)), time(T). 
     attr(room_section(R,env),class,("bg-success";"bg-opacity-50"))   :- holds(T,env(sparkle,R)), time(T).
     attr(room_section(R,env), class,("bg-warning";"bg-opacity-50"))  :- holds(T,env(E,R)),E != empty, E!= sparkle, env(E), time(T).
     attr(room_section(R,env), class,("bg-danger";"bg-opacity-100"))  :- holds(T,env(D,R)), danger(wumpus;pit), danger(D), time(T).  

     attr(room_section(R,env), icon,"fa-gem")          :- holds(T,env(sparkle,R)), time(T).     
     attr(room_section(R,env), icon,"fa-wind")         :- holds(T,env(breeze,R)), time(T).
     attr(room_section(R,env), icon,"fa-biohazard")    :- holds(T,env(smell,R)), time(T).

     attr(room_section(R,env), icon, "fa-circle-down") :- holds(T,env(assume(pit),R)), time(T).
     attr(room_section(R,env), icon,"fa-circle-down")  :- holds(T,env(pit,R)), time(T).

     attr(room_section(R,env), icon, "fa-hippo")       :- holds(T,env(assume(wumpus),R)), time(T).
     attr(room_section(R,env), icon, "fa-hippo")       :- holds(T,env(wumpus,R)), time(T).
     attr(room_section(R,env), icon, "fa-trophy" )        :- holds(T,env(dead_wumpus_yell,R)), time(T).
     attr(room_section(R,env),icon,"fa-door-closed")  :- holds(T,env(exit,R)), time(T), not holds(T-1,env(carry_gold,_)).                                                           
     attr(room_section(R,env),icon,"fa-door-open")    :- holds(T,env(exit,R)), time(T), holds(T-1,env(carry_gold,_)). 
     attr(room_section(R,env),class,("bg-success";"bg-opacity-50")) :- holds(T,env(exit,R)), time(T), holds(T-1,env(carry_gold,_)). 
        
elem(room_section(R,action), button, room(R,action))  :- holds(T-1,in(agent,L)), _any(occurs(T,A,(L,R))), time(T).
      attr(room_section(R,action),class,("bg-primary";"bg-opacity-50")) :- holds(T-1,in(agent,L)), _any(occurs(T,_,(L,R))), time(T).
      attr(room_section((X+1,Y),action),icon,"fa-arrow-right")          :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,move,((X,Y),(X+1,Y)))).  
      attr(room_section((X-1,Y),action),icon,"fa-arrow-left")           :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,move,((X,Y),(X-1,Y)))).  
      attr(room_section((X,Y+1),action),icon,"fa-arrow-down")           :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,move,((X,Y),(X,Y+1)))).  
      attr(room_section((X,Y-1),action),icon,"fa-arrow-up")             :- holds(T-1,in(agent,(X,Y))), time(T), _any(occurs(T,move,((X,Y),(X,Y-1)))).  

      attr(room_section(R,action), icon,"fa-bullseye")                  :- holds(T-1,in(agent,L)), time(T), _any(occurs(T,shoot,(L,R))). 
      attr(room_section(R,action), icon,"fa-person-through-window")     :- holds(_,env(exit,R)), time(T), holds(T-1,in(agent,L)), _any(occurs(T,leave,(L,R))).

      attr(room_section(R,action),icon, "fa-hand-holding-dollar")       :- holds(T,env(sparkle,R)), time(T),holds(T-1,in(agent,R)), _any(occurs(T,grab_gold,(R,R))).

 %----------------
 % WHEN CLICK BUTTON
 %----------------
 when(room_section(R,action), click, call, (
                        agent_action_multi(T, occurs(T,A,(L,R) ) ) ) ) :- holds(T-1,in(agent,L)), action(T,A,(L,R)), _any(occurs(T,A,(L,R))), time(T).
     
  
   
   
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%                         Legend
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elem(legend, container, sidebar).
   attr(legend, class, ("bg-info";"bg-opacity-25";"rounded";"m-3";"p-1")).


elem(legend_label,container, legend):- time(T).
   elem(ctl_legend(T,(title;text)),label, legend_label) :- time(T).
         attr(ctl_legend(T,title), label, "Legend"):- time(T).
         attr(ctl_legend(T,title), class, ("p-3";"h2")) :- time(T).

elem(action_info,container, legend):- time(T).
   elem(action_label(T), label,action_info) :- time(T).
         attr(action_label(T), label, "Possible Actions"):-time(T).
         attr(action_label(T), class, ("p-3";"h5")) :- time(T).
   
   elem(actions(T,A),button, action_info):- time(T), action_legend(A).
         attr(actions(T,A),class,("bg-primary";"bg-opacity-50";"disabled";"m-1")) :- time(T), action_legend(A).
         attr(actions(T,move),label," :  Move") :- time(T).
         attr(actions(T,move),icon,"fa-arrow-right")  :- time(T).

         attr(actions(T,grab_gold),label," :  Grab Gold") :- time(T).
         attr(actions(T,grab_gold),icon,"fa-hand-holding-dollar")  :- time(T).

         attr(actions(T,shoot),label," :  Shoot Wumpus") :- time(T).
         attr(actions(T,shoot),icon,"fa-bullseye")  :- time(T).

         attr(actions(T,leave),label," :  Exit") :- time(T).
         attr(actions(T,leave),icon,"fa-person-through-window")  :- time(T).

elem(board_info,container, legend):- time(T).
   elem(board_label(T),label,board_info) :- time(T).
         attr(board_label(T), label, "Board Information"):-time(T).
         attr(board_label(T), class, ("p-3";"h5")) :- time(T).
   
   elem(board(T,(wall;assume_safe;safe;warning;danger;room)),label, board_info) :- time(T).
        
         attr(board(T, wall), label, "Wall"):-time(T).
         attr(board(T, wall), class,("border-top";"border-dark";"border-3";"bg-info";"bg-opacity-25")) :- time(T).     

         attr(board(T, assume_safe), label, "Assumes to be Safe"):-time(T).
         attr(board(T,assume_safe), class, ("p-2";"bg-success";"bg-opacity-25")) :- time(T).

         attr(board(T, safe), label, "Visited Location: Confirmed Safe"):-time(T).
         attr(board(T, safe), class, ("p-2";"bg-success";"bg-opacity-75")) :- time(T).

         attr(board(T, warning), label, "Possible Wumpus or Pit location"):-time(T).
         attr(board(T, warning), class, ("p-2";"bg-warning";"bg-opacity-25")) :- time(T).

         attr(board(T, danger), label, "Confirmed Wumpus or Pit location"):-time(T).
         attr(board(T, danger), class, ("p-2";"bg-danger";"bg-opacity-75")) :- time(T).

elem(room_data,container, legend):- time(T).
   elem(room_label(T), label,room_data) :- time(T).
         attr(room_label(T), label, "Room Information"):-time(T).
         attr(room_label(T), class, ("p-3";"h5")) :- time(T).
   
   elem(room_info(T,(breeze;pit;smell;wumpus;sparkle;exit)),button, room_data) :- time(T).         

         attr(room_info(T,(breeze;pit;smell;wumpus;sparkle;exit)), class,("disabled";"rounded";"m-1")) :- time(T).
         attr(room_info(T,breeze), label," : Breeze")  :- time(T).
         attr(room_info(T,breeze), icon,"fa-wind")  :- time(T).
         attr(room_info(T,breeze), class,("bg-warning";"bg-opacity-100")) :- time(T).

         attr(room_info(T,pit), label," : Pit")  :- time(T).
         attr(room_info(T,pit), icon,"fa-circle-down")  :- time(T).
         attr(room_info(T,pit), class,("bg-danger";"bg-opacity-50")) :- time(T).

         attr(room_info(T,smell), label," : Smell")  :- time(T).
         attr(room_info(T,smell), icon,"fa-biohazard")  :- time(T).
         attr(room_info(T,smell), class,("bg-warning";"bg-opacity-100")) :- time(T).
         
         attr(room_info(T,wumpus), label," : Wumpus")  :- time(T).
         attr(room_info(T,wumpus), icon,"fa-hippo")  :- time(T).
         attr(room_info(T,wumpus), class,("bg-danger";"bg-opacity-50")) :- time(T).

         attr(room_info(T,sparkle), label," : Gold")  :- time(T).
         attr(room_info(T,sparkle), icon,"fa-gem")  :- time(T).
         attr(room_info(T,sparkle), class,("bg-success";"bg-opacity-50")) :- time(T).

         attr(room_info(T,exit), label," : Exit (if door open)")  :- time(T).
         attr(room_info(T,exit), icon,"fa-door-closed")  :- time(T).
         attr(room_info(T,exit), class,("bg-info";"bg-opacity-50")) :- time(T).

elem(live_info, container, legend).
   elem(ctl_info(T),label, live_info) :- time(T).
         attr(ctl_info(T), label, "Live Game Information"):- time(T).
         attr(ctl_info(T), class, ("border-dark";"border-2";"disabled";"p-3";"h5")) :- time(T).       
   
   elem(time(T),button, live_info) :- time(T).

         attr(time(T), label, T):- time(T).
         attr(time(T), class, ("bg-info";"m-2";"btn-m";"disabled")):- time(T).       
         attr(time(T), icon, "fa-clock"):- time(T).

   elem(holds(T,arrow(N)),button, live_info) :- time(T), holds(0,arrow(N)), N == 1, not holds(_,arrow(0)).
         attr(holds(T,arrow(N)), label, "  1 Shot Left") :- time(T), holds(0,arrow(N)), N == 1.
         attr(holds(T,arrow(N)), icon, ("fa-gun")):- time(T), holds(_,arrow(N)).      
         attr(holds(T,arrow(N)), class, ("bg-info";"m-2";"disabled")):- time(T), holds(0,arrow(N)), N == 1.

   elem(holds(T,arrow(N)),button, live_info) :- time(T), holds(K,arrow(N)), N == 0, K < T.      
         attr(holds(T,arrow(N)), label, " Out of shots"):- time(T), holds(K,arrow(N)), N == 0, K < T.
         attr(holds(T, arrow(N)), icon, ("fa-gun")):- time(T), holds(K,arrow(N)), N == 0, K < T.      
         attr(holds(T, arrow(N)), class, ("bg-danger";"m-2";"btn-m";"disabled")):- time(T), holds(K,arrow(N)), N == 0, K < T.

   elem(wumpus(T), button, live_info) :- time(T).
         attr(wumpus(T), label, "Wumpus is ALIVE"):- time(T), not holds(_, env(dead_wumpus_yell,_)).
         attr(wumpus(T), class, ("bg-warning";"m-2";"btn-m";"disabled")):- time(T), not holds(_,env(dead_wumpus_yell,_)).
         attr(wumpus(T), icon, ("fa-hippo")):- time(T), not holds(_, env(dead_wumpus_yell,_)).       
         
         attr(wumpus(T), label, "Wumpus is DEAD"):- time(T), holds(T, env(dead_wumpus_yell,W)).
         attr(wumpus(T), class, ("bg-success";"m-2";"btn-m";"disabled")):- time(T), holds(T, env(dead_wumpus_yell,W)).
         attr(wumpus(T), icon, ("fa-hippo")):- time(T), holds(T, env(dead_wumpus_yell,W)).  
      
   elem(holds(T,carry_gold), button, live_info):- time(T).  
         attr(holds(T,carry_gold), label, "No Gold"):- time(T), holds(T-1,in(agent,L)), not holds(T-1,env(carry_gold,_)).
         attr(holds(T,carry_gold), icon, "fa-xmark" ):- time(T), holds(T-1,in(agent,L)), not holds(T-1,env(carry_gold,_)).
         attr(holds(T,carry_gold), class, ("bg-warning";"m-2";"btn-m";"disabled")):- time(T), holds(T-1,in(agent,L)), not holds(T-1,env(carry_gold,_)).      

         attr(holds(T,carry_gold), label, "Grabed Gold"):- time(T), holds(T-1,env(carry_gold,_)).
         attr(holds(T,carry_gold), icon, "fa-check" ):- time(T), holds(T-1,env(carry_gold,_)).
         attr(holds(T,carry_gold), class, ("bg-success";"m-2";"btn-m";"disabled")):- time(T), holds(T-1,env(carry_gold,_)). 


%%%%%%%%%%%%%%%%%%%%%%%%
% Menu bar
%%%%%%%%%%%%%%%%%%%%%%%
elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Implementing the Observe Think Act Loop - Multishot Variant").

