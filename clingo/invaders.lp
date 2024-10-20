%%% DOMAIN PREDICATES
time(0..t).
xaxis(0..mx).
yaxis(0..my).
cannon(cannon1).
alien(1..a).

% at(time T, cannon C, xaxis X, yaxis Y)
% at(time T,  alien A, xaxis X, yaxis Y)
% either move OR shoot, at each time step < t
1 { move(T,C,X): xaxis(X); shoot(T,C,A): alien(A) } 1 :- time(T), T < t, cannon(C).

% INITIAL STATE
at(0,cannon1,0,0).

% ACTIONS
% Move effect

at(T+1,C,X,0) :-
    time(T), time(T+1),
    xaxis(X),
    cannon(C),
    move(T,C,X).


% Shoot effect

dead(T+1,A) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    alien(A), cannon(C),
    %%%
    shoot(T,C,A),
    at(T,A,X1,Y1), at(T,C,X2,Y2),
    X1 = X2, Y2 = 0.
at(T+1,C,X,Y) :-
    time(T), time(T+1),
    xaxis(X),
    yaxis(Y),
    cannon(C), alien(A),
    %%%
    shoot(T,C,A),
    at(T,C,X,Y).

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
at(T+1,A,X,Y-1) :-
    time(T), time(T+1),
    xaxis(X),
    yaxis(Y), yaxis(Y-1),
    alien(A),
    not dead(T,A),
    at(T,A,X,Y).

% Constraints

:- at(T,C,X,Y), move(T,C,X), Y != 0,
    time(T),
    xaxis(X),
    yaxis(Y),
    cannon(C).

% Alien can't reach y 0
:- at(T,A,X,0),
    time(T),
    xaxis(X),
    alien(A).

% GOAL
goal :- #count{X : dead(t,X)} == a.
:- not goal.

#show at/4.
#show move/3.
#show shoot/3.
#show dead/2.
