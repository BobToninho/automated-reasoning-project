% <input>
#const t=5.
#const a=3.
#const mx=7.
#const my=7.
% </input>

%%% DOMAIN PREDICATES
time(0..t).
xaxis(0..mx).
yaxis(0..my).
cannon(cannon1).
alien(1..a).

1 { at(T,A,X,Y): xaxis(X), yaxis(Y) } 1 :- time(T), alien(A).
1 { at(T,C,X,Y): cannon(C), xaxis(X), yaxis(Y) } 1 :- time(T).

% 1 { move(T,A,X,Y): xaxis(X), yaxis(Y); dead(T,A) } 1 :- time(T), T < t, alien(A).
1 { move(T,C,X,Y): cannon(C), xaxis(X), yaxis(Y);  shoot(T,C,A): cannon(C), alien(A)   } 1 :- time(T), T < t.

% yaxis
% 5 - - - - - 2
% 4 - - - - - -
% 3 - - - 1 - -
% 2 - - - - - -
% 1 - - - - - -
% 0 c - - - - -
%   0 1 2 3 4 5 xaxis
% at(time T, cannon C, xaxis X, yaxis Y)
% at(time T,  alien A, xaxis X, yaxis Y)

% <input>
at(0,cannon1,0,0).
at(0,1,4,4).
at(0,2,5,5).
at(0,3,3,6).
% </input>

goal :- dead(t,1), dead(t,2).
:- not goal.

% Move effect

at(T+1,C,X2,Y2) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    cannon(C), alien(A),
    %%%
    move(T,C,X2,Y2),
    at(T,C,X1,Y1), at(T,A,X2,Y2),
    X1 = X2, Y2 != 0, Y1 = 0.


at(T+1,A,X2,Y2) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    alien(A),
    move(T,A,X2,Y2),
    at(T,A,X1,Y1),
    not dead(T,A),
    X1 == X2.

% Shoot effect

dead(T+1,A) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    alien(A), cannon(C),
    shoot(T,C,A),
    at(T,A,X1,Y1), at(T,C,X2,Y2),
    X1 = X2, Y2 = 0.
at(T+1,C,X,Y) :-
    time(T), time(T+1),
    xaxis(X),
    yaxis(Y),
    cannon(C), alien(A),
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

:- at(T,C,X,Y), move(T,C,X,Y), Y != 0,
    time(T),
    xaxis(X),
    yaxis(Y),
    cannon(C).

% Alien can't reach y 0
:- at(T,A,X,0),
    time(T),
    xaxis(X),
    alien(A).




#show at/4.
#show move/4.
#show shoot/3.
#show dead/2.
