%%% DOMAIN PREDICATES
time(1..t).
xaxis(0..5).
yaxis(0..5).
cannon(cannon1).
alien(1..3).

1 { at(T,A,X,Y): alien(A), xaxis(X), yaxis(Y)  } 1 :- time(T), T < t.


