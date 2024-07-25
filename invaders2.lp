time(1..t).
row(0..x).
col(0..y).
object(cannon;alien_1;alien_2;alien_3).

on(1,cannon,0,0).
on(1,alien_1,7,7).
on(1,alien_2,5,3).
on(1,alien_3,2,9).

1 { on(T,O,X,Y) : row(X), col(Y) } 1 :- time(T), object(O).

on(T+1,alien_1,X,Y-1) :- on(T,alien_1,X,Y), time(T).
on(T+1,alien_2,X,Y-1) :- on(T,alien_2,X,Y), time(T).
on(T+1,alien_3,X,Y-1) :- on(T,alien_3,X,Y), time(T).

on(T+1,cannon,XA,0) :- on(T,cannon,XC,0), on(T,alien_1,XA,Y), time(T), row(XA), col(Y).
on(T+1,cannon,XA,0) :- on(T,cannon,XC,0), on(T,alien_2,XA,Y), time(T), row(XA), col(Y).
on(T+1,cannon,XA,0) :- on(T,cannon,XC,0), on(T,alien_3,XA,Y), time(T), row(XA), col(Y).

#show on/4.
