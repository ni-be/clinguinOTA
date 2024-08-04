% Possible movement direction an Agent can take
dir((DX, DY)) :- DX = -1..1, DY = -1..1, |DX|+|DY| <= 1.

% Adjacent relations in the cave:
%adjacent((X, Y), (X+DX, Y+DY)) :- cave((X, Y)), cave((X',Y')), dir((DX, DY)), X+DX = X', Y+DY = Y', DX != DY.

adjacent((X, Y), (X+DX, Y+DY)) :- holds(_,in(agent,(X,Y))), dir((DX, DY)), X+DX = X', Y+DY = Y', DX != DY.
