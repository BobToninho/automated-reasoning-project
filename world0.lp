block(b0).
block(b1).
block(b2).

init(on(b1,table)).
init(on(b2,b0)).
init(on(b0,table)).

goal(on(b1,b0)).
goal(on(b2,b1)).
goal(on(b0,table)).
