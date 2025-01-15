graph(T):- time(T).
attr(graph,T,label,@concat("Time ", T)):- time(T).

node((X,Y,T),T):- cave((X, Y)), time(T).

attr(node,(X,Y,T),pos,@pos(X,Y)):-cave((X, Y)),time(T).

attr(node,(X,Y,T),width,1):-cave((X, Y)),time(T).
attr(node,(X,Y,T),height,1):- cave((X,Y)), time(T).
attr(node,(X,Y,T),shape,square):-cave((X, Y)),time(T).
attr(node,(X,Y,T),style,filled):-cave((X, Y)),time(T).

%node((X,Y,T),T):-outside((X,Y)), time(T).
%attr(node,(X,Y,T),pos,@pos(X,Y)):-outside((X, Y)),time(T).
%attr(node,(X,Y,T),width,1):-outside((X, Y)),time(T).
%attr(node,(X,Y,T),shape,circle):-outside((X, Y)),time(T).
%attr(node,(X,Y,T),style,filled):-outside((X, Y)),time(T).

%attr(node,(X,Y,T),fillcolor,red):-pit((X, Y)), time(T).
%attr(node,(X,Y,T),fillcolor,blue):-wumpus((X, Y)), time(T).
%attr(node,(X,Y,T),fillcolor,yellow):- environment(T,in(sparkle,(X,Y))), time(T).

attr(node,(X,Y,T),label,""):- cave((X, Y)),time(T).

attr(node,(X,Y,T),label,"☻") :-  holds(T, in(agent,(X,Y))).
attr(node,(X,Y,T),fillcolor, green) :- holds(T, in(safe,(X,Y))).
attr(node,(X,Y,T),label,"え") :- observed(T, true, in(empty,(X,Y))).
attr(node,(X,Y,T), label,"エ") :- observed(T, false, in(empty, (X,Y))).

attr(node,(X,Y,T),label, "X") :- fluent(in(gold,(X,Y)), inertial_world), time(T).
attr(node,(X,Y,T), label,"sparkle") :- occurs(T, in(sparkle,(X,Y))).


attr(node, (X,Y,T), label, "P") :- fluent(in(pit,(X,Y)), inertial_world), time(T).
attr(node, (X,Y,T), label, "W") :- fluent(in(wumpus,(X,Y)), inertial_world), time(T).

attr(node, (X,Y,T), label, "び") :- happened(T, in(breeze,(X,Y))). 
attr(node, (X,Y,T), label, "ビ") :- observed(T, false, in(breeze,(X,Y))).

attr(node, (X,Y,T), fillcolor,red) :- holds(T,in(pit,(X,Y))).
attr(node, (X,Y,T), label,"危険な") :- -holds(T, in(safe,(X,Y))).
attr(node, (X,Y,T), fillcolor,pink) :- holds(T,in(wumpus,(X,Y))).

attr(node, (X,Y,T), label, "わ") :- happened(T, in(wall,(X,Y),(X',Y'))).
attr(node, (X,Y,T), label, "わ") :- happened(T, in(wall,(X',Y'), (X,Y))).


%attr(node, (X,Y,T), fillcolor, yellow) :- happened(T,in(sparkle,(X,Y))).
 

%attr(node,(X,Y,T),label,"✓"):-  know(T, safe(_,(X,Y))).
%attr(node,(X,Y,T),label,"♨︎"):-  know(T,(X, Y),stench).
%attr(node,(X,Y,T),label,"♒︎"):- know(T,(X, Y),breeze).
%attr(node,(X,Y,T),label,"P"):-  know(T,(X, Y),pit).
%attr(node,(X,Y,T),label,"W"):-  know(T,(X, Y),wumpus).
%attr(node,(X,Y,T),label,"宝"):- know(T,(X,Y),gold). 


%attr(node,(X,Y,T),label, "GG"):- occurs(T,(X,Y), grab_gold), time(T).
%attr(nod,(X,Y,T), label, ""):- outside((X,Y)), time(T), not occurs(T,(X,Y),leave_cave).
%attr(node,(X,Y,T),label, "出"):- occurs(T,LC, leave_cave), outside((X,Y)), time(T).
%attr(node,(X,Y,T),fillcolor,green):- occurs(T,LC, leave_cave), outside((X, Y)), time(T).
