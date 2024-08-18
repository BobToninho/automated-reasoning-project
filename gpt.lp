% Define time steps
time(0..4).

% Objects
location(loc1; loc2; loc3).
package(pkg1; pkg2).
robot(robot1).

% Initial state at time 0
at(pkg1, loc1, 0).
at(pkg2, loc2, 0).
at(robot1, loc1, 0).

% Moving the robot

move(robot1, L1, L2, T) :- at(robot1, L1, T), location(L2), L1 != L2, time(T), T < 4.

% Picking up a package
pickup(robot1, P, L, T) :- at(P, L, T), at(robot1, L, T), package(P), time(T), T < 4.

% Putting down a package
putdown(robot1, P, L, T) :- holding(robot1, P, T), location(L), time(T), T < 4.

% State transitions for the robot's location
at(robot1, L2, T+1) :- move(robot1, _, L2, T), time(T).

% State transitions for packages being held
holding(robot1, P, T+1) :- pickup(robot1, P, _, T), time(T).

% State transitions for packages being put down
at(P, L, T+1) :- putdown(robot1, P, L, T), time(T).

% A package remains at its location if not picked up
at(P, L, T+1) :- at(P, L, T), not pickup(robot1, P, L, T), time(T).

% Robot remains at the same location if not moved
at(robot1, L, T+1) :- at(robot1, L, T), not move(robot1, _, _, T), time(T).
% The robot cannot be in two places at the same time
:- at(robot1, L1, T), at(robot1, L2, T), L1 != L2, time(T).

% A package cannot be in two places at the same time
:- at(P, L1, T), at(P, L2, T), L1 != L2, time(T), package(P).

% A package cannot be held and at a location at the same time
:- holding(robot1, P, T), at(P, L, T), time(T), package(P).

% The robot can only hold one package at a time
:- holding(robot1, P1, T), holding(robot1, P2, T), P1 != P2, time(T).

% Goal: All packages at loc3 by the end of time
goal :- at(pkg1, loc3, 4), at(pkg2, loc3, 4).

:- not goal.
