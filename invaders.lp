time(1..n).
% maybe array of 2-elements tuples? so that the user can input an indefinite number of aliens
object(cannon;alien_1;alien_2;alien_3).
% grid(1..max_x,1..max_y).
grid(0..10,0..10).
% abscissa()
% ordinate()

% === Initial state ===
on(1,cannon, 0,0).
on(1,alien_1,3,3).
on(1,alien_2,2,2).
on(1,alien_3,1,1).

{ on(T,O,X,Y) : grid(X,Y),  time(T), object(O) } = 4.
% 1 { on(T,O,X,Y) : grid(X,Y) } 1 :- time(T), object(O) = 4 * n.

% Aliens move -1 each turn
% on(T+1,alien_1,X,Y-1) :- on(T,alien_1,X,Y), time(T), time(T+1), grid(X,Y), grid(X,Y-1).
% on(T+1,alien_2,X,Y-1) :- on(T,alien_2,X,Y), time(T), time(T+1), grid(X,Y), grid(X,Y-1).
% on(T+1,alien_3,X,Y-1) :- on(T,alien_3,X,Y), time(T), time(T+1), grid(X,Y), grid(X,Y-1).
%
% on(T+1,cannon,NX,Y) :- on(T,cannon,X,Y), time(T), time(T+1), grid(X,Y), grid(NX,Y).
% :- on(T+1,O,NX,Y), on(T,O,X,Y).



% One object can be on one position at any given time
% (and two objects cannot overlap?)
% 1 { on(T,O,X,Y): grid(X,Y)  } 1 :- time(T), object(O).

% Final state
% final :- on(n, cannon, X, Y).
% :- not final.
#show on/4.
