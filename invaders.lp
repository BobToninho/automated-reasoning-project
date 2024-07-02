time(1..n).
object(cannon;alien_1;alien_2;alien_3).
% grid(1..max_x,1..max_y).
grid(1..10,1..10).

% === Initial state ===
on(1,cannon,0,0).
on(1,alien_1,2,6).
on(1,alien_2,5,9).
on(1,alien_3,1,1).

% One object can be on one position at any given time
% (and two objects cannot overlap?)
1 { on(T,O,X,Y) : grid(X,Y) } 1 :- time(T), object(O).

% An object moves on the grid
% move(T+1,A,FromX,FromY,ToX,ToY) :-
%   on(T,A,FromX,FromY), on(T+1,A,ToX,ToY), FromX != ToX, FromY != ToY,
%   time(T), time(T+1), object(A), grid(FromX,FromY), grid(ToX,ToY).
% cannon can move only on x axis
% :- move(T,cannon,FromX,Y,ToX,Y).

% on(T+1,cannon,X2,Y) :- on(T,cannon,X1,Y), X1 != X2, X2 < max_x.

% Cannon shoots alien (Notion of elimination from the grid)
on(T+1,alien_1,-1,-1) :- on(T,alien_1,X,Y1), on(T,cannon,X,Y2), time(T), grid(X,Y1), grid(X,Y2).

% Object moves
% on(T+1,alien_1,-1,-1) :- on(T,alien_1,X,Y1), on(T,cannon,X,Y2).

% Final state
final :- on(n,cannon,X,Y), on(n,alien_1,-1,-1), on(n,alien_2,-1,-1), on(n,alien_3,-1,-1).
:- not final.
