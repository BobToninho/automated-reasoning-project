%%% DOMAIN PREDICATES

time(0..t).

xaxis(0..mx).

yaxis(0..my).

cannon(cannon1).

alien(1..a).



% INITIAL STATE

at(0,cannon1,0,0).



%%% 1. HEURISTIC RULES TO PREFER SHOOTING WHEN ALIGNED

% Define when cannon is aligned with an alien

aligned(T,C,A) :-

    time(T),

    cannon(C), alien(A),

    at(T,C,X,_), at(T,A,X,_),

    not dead(T,A).



% Heuristic to prefer shooting when aligned

#heuristic shoot(T,C,A) : aligned(T,C,A). [10,true]



%%% 2. CONSTRAINTS TO ELIMINATE BAD MOVES

% Don't move away from aligned aliens unless they're dead

:- move(T,C,X2),

   aligned(T,C,A),

   at(T,C,X1,_),

   not dead(T,A),

   |X1-X2| > 1.



% Don't waste shots on dead aliens

:- shoot(T,C,A), dead(T,A).



%%% 3. BREAK PROBLEM INTO PHASES

% Define phases based on alien y-positions

phase(T,1) :- time(T), #max { Y : at(T,A,_,Y), alien(A), not dead(T,A) } >= 30.

phase(T,2) :- time(T), #max { Y : at(T,A,_,Y), alien(A), not dead(T,A) } >= 15, not phase(T,1).

phase(T,3) :- time(T), not phase(T,1), not phase(T,2).



% Prioritize higher aliens in early phases

#heuristic shoot(T,C,A) : at(T,A,_,Y), phase(T,1), Y > 30. [5,true]



%%% 4. INTERMEDIATE GOALS

% Track aliens killed in each phase

killed_in_phase(T,P,A) :-

    time(T),

    phase(T,P),

    dead(T,A),

    not dead(T-1,A).



% Encourage killing minimum number of aliens per phase

:- phase(t,3), #count{A : killed_in_phase(T,1,A), T <= t} < 5.

:- phase(t,3), #count{A : killed_in_phase(T,2,A), T <= t} < 5.



%%% ORIGINAL RULES

% Either move OR shoot, at each time step < t

1 { move(T,C,X): xaxis(X); shoot(T,C,A): alien(A) } 1 :- time(T), T < t, cannon(C).



% Move effect

at(T+1,C,X,0) :-

    time(T), time(T+1),

    xaxis(X),

    cannon(C),

    move(T,C,X).



% Shoot effect

dead(T+1,A) :-

    time(T), time(T+1),

    xaxis(X1),

    alien(A), cannon(C),

    shoot(T,C,A),

    at(T,A,X1,_), at(T,C,X1,0).



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

    dead(T,A).



at(T+1,A,X,Y) :-

    time(T), time(T+1),

    xaxis(X),

    yaxis(Y),

    alien(A),

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
