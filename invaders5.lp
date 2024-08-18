#const a=2.

%%% DOMAIN PREDICATES
time(0..t).
xaxis(0..5).
yaxis(0..5).
cannon(cannon1).
alien(1..a).

1 { at(T,A,X,Y): xaxis(X), yaxis(Y)  } 1 :- time(T), alien(A).
1 { at(T,C,X,Y): cannon(C), xaxis(X), yaxis(Y)  } 1 :- time(T).

0 { move(T,A,X,Y): alien(A), xaxis(X), yaxis(Y)  } 1 :- time(T), T < t, T > 0.

% 0 { move(T,C,X,Y): cannon(C), xaxis(X), yaxis(Y)  } 1 :- time(T), T < t.
% 0 { shoot(T,C,A): cannon(C), alien(A) } 1 :- time(T), T < t.
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

% Move effect

at(T+1,C,X2,Y2) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    cannon(C),
    %%%
    move(T,C,X2,Y2),
    at(T,C,X1,Y1),
    X1 != X2, Y1 = Y2.

at(T+1,A,X2,Y2) :-
    time(T), time(T+1),
    xaxis(X1), xaxis(X2),
    yaxis(Y1), yaxis(Y2),
    alien(A),
    %%%
    move(T,A,X2,Y2),
    at(T,A,X1,Y1),
    X1 = X2, Y2 = Y1 - 1.

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

% Inertia
dead(T+1,A) :-
    time(T), time(T+1),
    alien(A),
    %%%
    dead(T,A).




goal :- dead(t,1), dead(t,2).
:- not goal.

#show at/4.
% #show move/4.
% #show shoot/3.
% #show dead/2.
