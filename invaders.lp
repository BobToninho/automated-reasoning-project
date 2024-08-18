time(1..t).
cannon(1, 0,0).
alien(1..a).

alien(1,1, 3,7).
alien(2,1, 4,5).
alien(3,1, 1,9).
alien(4,1, 3,9). % this collapses with 3,7 see *1 for a tentative solution to this
xaxis(0..x).
yaxis(0..y).

% cannon can be in only one position in any given time
1 { cannon(T,X,0): xaxis(X)  } 1 :- time(T).



% % aliens can be in only one position in any given time
1 { alien(T,A,X,Y): xaxis(X),yaxis(Y)  } a :- time(T), alien(A).
% if an alien is out, it stays out till the end of time
% alien(T+1,-1,-1) :- alien(T,-1,-1), time(T), time(T+1).
% aliens move down one cell every time segment
alien(T+1,A,X,Y-1) :- alien(T,A,X,Y), time(T), time(T+1), xaxis(X), yaxis(Y), yaxis(Y-1), alien(A). % works
dead(A) :- cannon(T+1,X1,Y1), cannon(T,X1,Y1), alien(T,A,X2,Y2), time(T), time(T+1), alien(A), X1 = X2.


#show alien/4.
#show cannon/3.
