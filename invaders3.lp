time(1..t).
xaxis(0..x).
yaxis(0..y).
alien(1;2;3;4).
cannon(1).

% cannon_on_grid(T,C) :- time(T), cannon(C).
% alien_on_grid(T,A) :- time(T), alien(A).

cannon_on_grid(1,1).
alien_on_grid(1,1).
alien_on_grid(1,2).
alien_on_grid(1,3).
alien_on_grid(1,4).

cannon_position(1,1,0,0).
alien_position(1,1,3,7).
alien_position(1,2,8,5).
alien_position(1,3,1,9).
alien_position(1,4,3,9).

 alien_position(T+1,A,X,Y-1)  :- alien_position(T,A,X,Y), alien_on_grid(T,A),
                               time(T), time(T+1),
                               alien(A),
                               xaxis(X),
                               yaxis(Y), yaxis(Y+1),
                               Y - 1 > 1.

1 { alien_position(T,A,X,Y): xaxis(X),yaxis(Y)  } a :- time(T), alien(A).

% alien_on_grid(T+1,A) :- cannon_position(T,C,X1,Y1), alien_position(T,A,X2,Y2), X1 != X2.
%
% 1{cannon_position(T+1,C,X2,0) : xaxis(X2), yaxis(0), time(T+1)}1 :- cannon_position(T,C,X1,0),
%                                alien_position(T,A,X2,Y),
%                                time(T), time(T+1),
%                                % cannon(C),
%                                % alien(A),
%                                % xaxis(X1), xaxis(X2),
%                                % yaxis(Y),
%                                X1 != X2.

% 1 { cannon_position(T,C,X,Y) : xaxis(X), yaxis(Y) } 1 :- time(T), cannon(C).

#show cannon_position/4.
#show alien_position/4.
% #show alien_on_grid/2.
