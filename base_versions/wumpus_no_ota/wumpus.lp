%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Version 0.2 Wumpus Implementation - Simplified version 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple Wumpus encoding without shooting action. No rewards yet implementent 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cave Prior Knowledge / "world rules"
%=====================================================================================
% Possible movement direction
dir((DX, DY)) :- DX = -1..1, DY = -1..1, |DX|+|DY| <= 1.

% Adjacent relations in the cave:
adjacent((X, Y), (X+DX, Y+DY)) :- cave((X, Y)), cave((X',Y')), dir((DX, DY)), X+DX = X', Y+DY = Y', DX != DY.
breeze(B) :- adjacent(B, PP), pit(PP), cave(S).
stench(S) :- adjacent(S, W), wumpus(W), cave(S).
glitter(G) :- gold(G), cave(G).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handling the known and unknown 
%==============================================================
know(T,SP,safe):- at(SP,T).
know(T,B,breeze):- at(B,T), breeze(B).
know(T,S,stench):- at(S,T), stench(S).
know(T,G,gold):- at(G,T), glitter(G). 

know(T+1,Q,SOMETHIG):- know(T,Q,SOMETHIG), time(T+1).

% SAFE if AT location P there is no breeze and no stench
know(T,SP,safe) :- at(P,T), adjacent(P,SP), not know(T,P,breeze), not know(T,P,stench).

% If 2 breezes are known and they share an adjacent that shared adjacent should be a pit
know(T, PP, pit):- know(T, B, breeze), know(T, B', breeze), cave(PP), adjacent(B, PP), adjacent(B', PP), B != B', not know(T,PP,safe).
know(T,WP,wumpus) :- know(T,S,stench), know(T,S',stench), adjacent(S,WP), adjacent(S',WP), S != S', not know(T,WP,safe).

% SP is safe if at B if adjacent not the same adjacent that is known to be a PIT
know(T,SP,safe):- know(T,B,breeze), know(T,P,pit), cave(SP), adjacent(B,P), adjacent(B,SP), SP != P.
know(T,SP,safe):- know(T,S,stench), know(T,W,wumpus), cave(SP), adjacent(S,W), adjacent(S,SP), SP != W.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AGENT ACTIONS
%========================================================
%MOVEMENT
1 { occurs(T, (DX,DY), move) : cave((X+DX,Y+DY)), dir((DX,DY)), know(T,(X+DX,Y+DY),safe)} 1 :- at((X,Y),T), time(T+1).
at((X+DX,Y+DY),T+1) :- occurs(T, (DX,DY), move), at((X,Y),T), time(T+1).

% grab gold 
0 { occurs(T, G, grab_gold) : know(T,G, gold), occurs(T,(DX,DY), move), DX + DY = 0 } 1 :- at(GG, T). 
0 { occurs(T, SW, shoot) : cave(SW), at(AT,T), know(T,WP, wumpus)} 1 :- at(AT,T), not occurs(T,_,shoot).

% Leave Cave
0 { occurs(T, LC, leave_cave) : time(T) } 1 :- at(LC, T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GOAL
%================================================================================
% Goal condition: Agent is at the same square as the gold
goal :- occurs(T,GG, grab_gold), occurs(T+1,GG, leave_cave).
:- not goal.



