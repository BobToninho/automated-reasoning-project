%%% DOMAIN PREDICATES
time(1..t).
xaxis(0..5).
yaxis(0..5).
cannon(cannon1).
alien(1..3).

at(1,cannon1,0,0).
at(1,1,3,7).
at(1,2,5,3).
at(1,3,3,9).
at(1,4,1,9).

% Actions definition
moveX(C, X1, X2, T) :- at(T,C,X1,Y), X1 != X2, time(T), cannon(C), xaxis(X1), xaxis(X2), yaxis(Y).
moveY(A, Y1, Y2, T) :- at(T,A,X,Y1), Y1 != Y2, time(T), alien(A), xaxis(X), yaxis(Y1), yaxis(Y2).
shoot(C,A,T) :- at(T,C,X1,Y1), at(T,A,X2,Y2), X1 = X2, cannon(C), alien(A), xaxis(X1), xaxis(X2), yaxis(Y1), yaxis(Y2), time(T).

% Transitions
at(T+1,C,X2,Y) :- moveX(C,_,X2, T), cannon(C), xaxis(X2), yaxis(Y), time(T+1), time(T).
at(T+1,A,X,Y2) :- moveY(A,_,Y2, T), alien(A), xaxis(X), time(T+1), yaxis(Y2), time(T).
dead(A) :- shoot(C,A,T), cannon(C), time(T).


% Constraints
% :- time(T), T < t.

goal :- dead(1..a).

:- not goal.

% #show moveX/3.
% #show moveY/3.
