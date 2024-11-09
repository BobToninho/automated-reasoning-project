include "globals.mzn";

set of int: TIME = 0..t-1;
set of int: ALIENS = 1..a;

/* DECISION VARIABLES */
array[0..t] of var 0..mx-1: cannon_x;
array[TIME] of var -1..mx-1: move_x;
array[TIME] of var 0..a: shoot;

array[ALIENS,0..t] of var bool: aliens_dead;
array[ALIENS,0..t] of var 0..my-1: aliens_y;

/* Initial position of cannon */
constraint cannon_x[0] = 0;

/* Aliens start alive */
constraint forall(j in ALIENS) (
  aliens_dead[j,0] = false
);

/* Aliens' initial position */
constraint forall(j in ALIENS) (
  aliens_y[j,0] = aliens_y_initial[j]
);


/* ACTIONS */
% Move effect
constraint forall(j in ALIENS) (
  exists(i in TIME) (
    % putting the 2 clauses together: the cannon moves to an alien's position
    % it can be considered an effect of the move action
    move_x[i] == aliens_x_initial[j] % precondition/action - not clear here
    /\
    cannon_x[i+1] == move_x[i] % action
  )
);
% Shoot effect
constraint forall(j in ALIENS) (
  exists(i in TIME) (
    shoot[i] == j % action
    /\
    cannon_x[i+1] == cannon_x[i] % effect
  )
);
% At any given time step the cannon either moves or shoots
constraint forall(i in TIME, j in ALIENS) (
  (move_x[i] == -1 /\ shoot[i] != 0)
  \/
  (move_x[i] != -1 /\ shoot[i] == 0)
);
% The cannon moves where the living aliens are
constraint forall(j in ALIENS) (
  exists(i in TIME) (
    aliens_dead[j,i+1] % effect
    /\
    shoot[i] = j % action
    /\
    cannon_x[i] == aliens_x_initial[j] % precondition
    /\
    not aliens_dead[j,i] % precondition
  )
);



/* INERTIA */
% If an alien is dead it stays dead and its y position does not change
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == true) -> (
    aliens_dead[j,i+1] = true /\
    aliens_y[j,i+1] = aliens_y[j,i]
  )
);
% Living aliens decrease their y-axe position each time step
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == false) -> (aliens_y[j,i+1] = max(1, aliens_y[j,i] - 1))
  /* (aliens_dead[j,i] == false) -> (aliens_y[j,i+1] = aliens_y[j,i] - 1) */
);



/* CONSTRAINTS */
% It's possible to shoot to an alien only once
constraint all_different_except_0(shoot);



% Goal
constraint forall(j in ALIENS) (
  aliens_dead[j,t] = true
);
solve satisfy;

/* solve maximize sum(i in ALIENS)(aliens_dead[i,t]); */

output [
  "t:\t\t\t" ++ show(t) ++ "\n" ++
  "mx:\t\t\t" ++ show(mx) ++ "\n" ++
  "my:\t\t\t" ++ show(my) ++ "\n" ++
  "aliens_y_initial:\t" ++ show(aliens_y_initial) ++ "\n" ++
  "aliens_x_initial:\t" ++ show(aliens_x_initial) ++ "\n" ++
  "..." ++ "\n" ++
  "move_x:\t\t\t" ++ show(move_x) ++ "\n" ++
  "cannon_x:\t\t" ++ show(cannon_x) ++ "\n" ++
  "shoot:\t\t\t" ++ show(shoot) ++ "\n" ++
  "aliens_y:\t\t" ++ show(aliens_y) ++ "\n" ++
  "aliens_dead:\t\t" ++ show(aliens_dead) ++ "\n"
];

