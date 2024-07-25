time(1..t).
cannon(1, 0,0).
alien(1, 3,7).
alien(1, 8,5).
alien(1, 1,9).
row(0..x).
col(0..y).

% cannon can be in only one position in any given time
1 { cannon(T,X,0): row(X)  } 1 :- time(T).
% aliens can be in only one position in any given time
1 { alien(T,X,Y): row(X),col(Y)  } a :- time(T).

% aliens go down one cell every instant
alien(T+1,X,Y-1) :- alien(T,X,Y), time(T), time(T+1), row(X), col(Y), col(Y-1), Y > 1. % works

alien(T+1,-1,-1) :- cannon(T,X,0), alien(T,X,Y).

% cannon(T+1,X,0) :- cannon(T,X,0), alien(T,X,Y).



% One of the solutions:
%
% cannon(2, 3,0).
% alien(2, 3,6).
% alien(2, 8,4).
% alien(2, 1,8).
%
% cannon(3, 3,0).
% alien(3, -1,-1).
% alien(3, 8,5).
% alien(3, 1,9).
%
% cannon(4, 1,0).
% alien(4, -1,-1).
% alien(4, 8,5).
% alien(4, 1,9).
%
% cannon(5, 1,0).
% alien(5, -1,-1).
% alien(5, 8,5).
% alien(5, -1,-1).
%
% cannon(6, 8,0).
% alien(6, -1,-1).
% alien(6, 8,5).
% alien(6, -1,-1).
%
% cannon(7, 8,0).
% alien(7, -1,-1).
% alien(7, -1,5).
% alien(7, -1,-1).


% Final state
final :- alien(t,-1,-1), alien(t,-1,-1),alien(t,-1,-1).
:- not final.
#show alien/3.
#show cannon/3.
