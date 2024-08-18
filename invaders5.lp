#const t=5.
#const a=2.
#const mx=5.
#const my=5.

%%% DOMAIN PREDICATES
time(0..t).
xaxis(0..mx).
yaxis(0..my).
cannon(cannon1).
alien(1..a).

1 { at(T,A,X,Y): xaxis(X), yaxis(Y) } 1 :- time(T), alien(A).
1 { at(T,C,X,Y): cannon(C), xaxis(X), yaxis(Y) } 1 :- time(T).

1 { move(T,A,X,Y): xaxis(X), yaxis(Y)  } 1 :- time(T), T < t, T > 0, alien(A).
1 { move(T,C,X,Y): cannon(C), xaxis(X), yaxis(Y);  shoot(T,C,A): cannon(C), alien(A)   } 1 :- time(T), T < t, T > 0.


% - - - - - 2
% - - - - - -
% - - - 1 - -
% - - - - - -
% - - - - - -
% c - - - - -

at(0,cannon1,0,0).
at(0,1,3,3).
at(0,2,5,5).

goal :- dead(t,1), dead(t,2).
:- not goal.

% Move effect

at(T+1,C,X2,0) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    cannon(C), alien(A),
    %%%
    move(T,C,X2,0),
    at(T,C,X1,0), at(T,A,X2,Y2),
    X1 = X2, Y2 != 0.


at(T+1,A,X2,Y2) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    alien(A),
    %%%
    move(T,A,X2,Y2),
    at(T,A,X1,Y1),
    not dead(T,A).

% Shoot effect

dead(T+1,A) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    alien(A), cannon(C),
    %%%
    shoot(T,C,A),
    at(T,A,X1,Y1), at(T,C,X2,Y2),
    X1 = X2.
at(T+1,C,X,Y) :-
    time(T), time(T+1),
    xaxis(X),
    yaxis(Y),
    cannon(C), alien(A),
    %%%
    shoot(T,C,A),
    at(T,C,X,Y).
at(T+1,A,X,Y) :-
    time(T), time(T+1),
    xaxis(X),
    yaxis(Y),
    cannon(C), alien(A),
    %%%
    shoot(T,C,A),
    at(T,A,X,Y).

% Inertia
dead(T+1,A) :-
    time(T), time(T+1),
    alien(A),
    %%%
    dead(T,A).
at(T+1,A,X,Y) :-
    time(T), time(T+1),
    xaxis(X),
    yaxis(Y),
    alien(A),
    %%%
    dead(T,A),
    at(T,A,X,Y).

% Constraints

:- at(T,C,X,Y), Y != 0,
    time(T),
    xaxis(X),
    yaxis(Y),
    cannon(C).
:- move(T,C,X,Y), Y != 0,
    time(T),
    xaxis(X),
    yaxis(Y),
    cannon(C).

:- at(T+1,A,X2,Y), at(T,A,X1,Y), X1 != X2,
    time(T),
    xaxis(X1), xaxis(X2),
    yaxis(Y),
    alien(A).


#show at/4.
#show move/4.
#show shoot/3.
#show dead/2.
