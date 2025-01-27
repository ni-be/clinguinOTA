graph(T):- time(T).
attr(graph,T,label,@concat("Time ", T)):- time(T).

node((X,Y,T),T):-cave((X, Y)), time(T).

attr(node,(X,Y,T),pos,@pos(X,Y)):-cave((X, Y)),time(T).

attr(node,(X,Y,T),width,1):-cave((X, Y)),time(T).
attr(node,(X,Y,T),height,1):- cave((X,Y)), time(T).
attr(node,(X,Y,T),shape,square):-cave((X, Y)),time(T).
attr(node,(X,Y,T),style,filled):-cave((X, Y)),time(T).


node((X,Y,T),T):-outside((X,Y)), time(T).
attr(node,(X,Y,T),pos,@pos(X,Y)):-outside((X, Y)),time(T).
attr(node,(X,Y,T),width,1):-outside((X, Y)),time(T).
attr(node,(X,Y,T),shape,circle):-outside((X, Y)),time(T).
attr(node,(X,Y,T),style,filled):-outside((X, Y)),time(T).

attr(node,(X,Y,T),fillcolor,red):-pit((X, Y)), time(T).
attr(node,(X,Y,T),fillcolor,blue):-wumpus((X, Y)), time(T).
attr(node,(X,Y,T),fillcolor,yellow):-gold((X, Y)), time(T), not occurs(T,(X,Y),grab_gold).

attr(node,(X,Y,T),label,""):-cave((X, Y)),time(T), not know(T,(X, Y),_), not at((X, Y),T).

attr(node,(X,Y,T),label,"☻"):-  at((X, Y),T).
attr(node,(X,Y,T),label,"✓"):-  know(T,(X, Y),safe).
attr(node,(X,Y,T),label,"♨︎"):-  know(T,(X, Y),stench).
attr(node,(X,Y,T),label,"♒︎"):- know(T,(X, Y),breeze).
attr(node,(X,Y,T),label,"P"):-  know(T,(X, Y),pit).
attr(node,(X,Y,T),label,"W"):-  know(T,(X, Y),wumpus).
attr(node,(X,Y,T),label,"宝"):- know(T,(X,Y),gold). 

attr(node,(X,Y,T),label, "GG"):- occurs(T,(X,Y), grab_gold), time(T).
attr(nod,(X,Y,T), label, ""):- outside((X,Y)), time(T), not occurs(T,(X,Y),leave_cave).
attr(node,(X,Y,T),label, "出"):- occurs(T,LC, leave_cave), outside((X,Y)), time(T).
attr(node,(X,Y,T),fillcolor,green):- occurs(T,LC, leave_cave), outside((X, Y)), time(T).
