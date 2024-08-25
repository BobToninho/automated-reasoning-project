%%% DECEMBER 2015
%%% Agostino Dovier
%%% TESTED WITH CLINGO 4.5.3

tempo(0..t).
val(0..8).
range(0..2).

% 0 1 2    % riga 0
% 3 4 5    % riga 1
% 6 7 8    % riga 2
%%%%%%%
% 0 1 2  colonne
%%%%%%

%% Predicato
%% cell(tempo T, riga X, colonna Y, valore V)

%%% Input (cambiarli)
%cell(0,0,0,1). cell(0,0,1,2). cell(0,0,2,5).
%cell(0,1,0,3). cell(0,1,1,4). cell(0,1,2,8).
%cell(0,2,0,6). cell(0,2,1,0). cell(0,2,2,7).


%cell(0,0,0,1). cell(0,0,1,0). cell(0,0,2,5).
%cell(0,1,0,4). cell(0,1,1,2). cell(0,1,2,8).
%cell(0,2,0,3). cell(0,2,1,6). cell(0,2,2,7).

cell(0,0,0,4). cell(0,0,1,0). cell(0,0,2,1).
cell(0,1,0,2). cell(0,1,1,8). cell(0,1,2,5).
cell(0,2,0,3). cell(0,2,1,6). cell(0,2,2,7).


%%% Goal
goal(X,Y) :- range(X), range(Y), cell(t,X,Y,3*X+Y).
:- range(X),range(Y), not goal(X,Y).

%%% Una mossa (sposta il buco!)

1{ move(T,up); move(T,down); move(T,left); move(T,right)}1 :- tempo(T), tempo(T+1).

hole(T,X,Y) :- cell(T,X,Y,0), tempo(T), range(X), range(Y).

% Mosse proibite
:- tempo(T), move(T,up),    range(Y), hole(T,0,Y).
:- tempo(T), move(T,down),  range(Y), hole(T,2,Y).
:- tempo(T), move(T,left),  range(X), hole(T,X,0).
:- tempo(T), move(T,right), range(Y), hole(T,X,2).

% Effetti

moved(T,X-1,Y) :-  hole(T,X,Y), move(T,up),    tempo(T),  range(X), range(Y).
moved(T,X+1,Y) :-  hole(T,X,Y), move(T,down),  tempo(T),  range(X), range(Y).
moved(T,X,Y-1) :-  hole(T,X,Y), move(T,left),  tempo(T),  range(X), range(Y).
moved(T,X,Y+1) :-  hole(T,X,Y), move(T,right), tempo(T),  range(X), range(Y).



cell(T+1,X,Y,0)     :-
     moved(T,X,Y), tempo(T), tempo(T+1), range(X), range(Y).
cell(T+1,X1,Y1,V)   :-
    hole(T,X1,Y1), moved(T,X2,Y2), cell(T,X2,Y2,V),
    tempo(T), tempo(T+1), range(X1), range(X2), range(Y1), range(Y2), val(V).

% Inerzia

affected(T,X,Y) :- hole(T,X,Y),  tempo(T),  range(X), range(Y).
affected(T,X,Y) :- moved(T,X,Y), tempo(T),  range(X), range(Y).

cell(T+1,X,Y,V) :-  cell(T,X,Y,V),
       not affected(T,X,Y),
       tempo(T), tempo(T+1), range(X), range(Y), val(V).

#show move/2.
