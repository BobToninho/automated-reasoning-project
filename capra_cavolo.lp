%%% TESTED CLINGO 4.4.0

%%% DOMAIN PREDICATES
time(1..n).
place(left;right;boat).
object(man;goat;cabbage;wolf).

%%% INITIAL STATE
on(1,goat,left).
on(1,cabbage,left).
on(1,wolf,left).
on(1,man,left).

%%% IF (goat and cabbage) OR (goat and wolf) are in place P,
%%%    THEN the man is in P
on(T,man,P) :- on(T,goat,P), on(T,cabbage,P), time(T), place(P).
on(T,man,P) :- on(T,goat,P), on(T,wolf,P), time(T), place(P).

%%% In any time, any object is exactly in one place.
1 { on(T,O,P) : place(P) } 1 :- time(T), object(O).

% #show on/3.

%% Boat effect (it is important where the motion has started)
on(T+2,O,right):- on(T+1,O,boat), on(T,O,left),  time(T), object(O).
on(T+2,O,left) :- on(T+1,O,boat), on(T,O,right), time(T), object(O).

%%% IF someone is in boat, then the man must be on boat.
on(T,man,boat) :- on(T,O,boat), time(T), object(O).

%%% The boat constains from 0 to 2 objects
%0 { on(T,O,boat) : object(O) } 2 :- time(T).

:- time(T), on(T,O1,boat), on(T, O2, boat), on(T, O3, boat),
   object(O1), object(O2), object(O3),
   O1 != O2, O1 != O3, O2 != O3.

%%% INERTIA rules
:- on(T+1,O,left), on(T,O,right), time(T), object(O).
:- on(T+1,O,right), on(T,O,left), time(T), object(O).

moved(T) :-
     move(T+1,A,From,To),
     time(T), time(T+1), object(A), place(From), place(To).

:- time(T), T < n, not moved(T).

%%%
final :-
on(n,goat,right),
on(n,cabbage,right),
on(n,wolf,right),
on(n,man,right).
:- not final.

%#show on/3.

move(T+1,A,From,To) :-
     on(T,A,From), on(T+1,A,To), From != To,
     time(T), time(T+1), object(A), place(From), place(To).
#show move/4.

