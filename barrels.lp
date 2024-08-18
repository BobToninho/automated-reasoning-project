litri(0..12).
barrel(5;7;12).
time(0..t).

% One and only one pour at the time T
1 { pour(T,X,Y): barrel(X), barrel(Y), X != Y } 1 :- time(T), T < t.

% Initial state
contains(0,12,12).
contains(0,7,0).
contains(0,5,0).

% Final state
goal :- contains(t,12,6), contains(t,7,6), contains(t,5,0).
:- not goal.

% Pour effect

contains(T+1,X,0) :-
    time(T),time(T+1),
    barrel(X),barrel(Y),X!=Y,
    litri(LX),litri(LY),
    %%%
    pour(T,X,Y),
    contains(T,X,LX),contains(T,Y,LY),
    Y-LY>LX.
contains(T+1,Y,LX+LY) :-
    time(T),time(T+1),
    barrel(X),barrel(Y),X!=Y,
    litri(LX),litri(LY),
    %%%
    pour(T,X,Y),
    contains(T,X,LX),contains(T,Y,LY),
    Y-LY>LX.
contains(T+1,X,LX-(Y-LY)) :-
    time(T),time(T+1),
    barrel(X),barrel(Y),X!=Y,
    litri(LX),litri(LY),
    %%%
    pour(T,X,Y),
    contains(T,X,LX),contains(T,Y,LY),
    Y-LY<=LX.
contains(T+1,Y,Y) :-
    time(T),time(T+1),
    barrel(X),barrel(Y),X!=Y,
    litri(LX),litri(LY),
    %%%
    pour(T,X,Y),
    contains(T,X,LX),contains(T,Y,LY),
    Y-LY<=LX.

% Inertia

contains(T+1,B,L) :-
    time(T),time(T+1),
    barrel(X),barrel(Y),barrel(B),
    litri(L),
    X!=Y,X!=B,Y!=B,
    pour(T,X,Y),
    contains(T,B,L).

% You can't pour an empty barrel or in a full one
:- barrel(X),barrel(Y),X!=Y,time(T),pour(T,X,Y),contains(T,X,0).
:- barrel(X),barrel(Y),X!=Y,time(T),pour(T,X,Y),contains(T,Y,Y).

#show pour/3.
