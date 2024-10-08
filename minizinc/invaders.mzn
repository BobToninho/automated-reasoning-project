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
constraint forall(j in ALIENS) (
  exists(i in TIME) (
    move_x[i] == aliens_x_initial[j]
    /\
    cannon_x[i+1] == move_x[i]
  )
);
constraint forall(j in ALIENS) (
  exists(i in TIME) (
    shoot[i] == j
    /\
    cannon_x[i+1] == cannon_x[i]
  )
);
constraint forall(i in TIME, j in ALIENS) (
  (move_x[i] == -1 /\ shoot[i] != 0)
  \/
  (move_x[i] != -1 /\ shoot[i] == 0)
);
constraint forall(j in ALIENS) (
  exists(i in TIME) (
    aliens_dead[j,i+1]
    /\
    shoot[i] = j
    /\
    cannon_x[i] == aliens_x_initial[j]
    /\
    not aliens_dead[j,i]
  )
);



/* INERTIA */
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == true) -> (
    aliens_dead[j,i+1] = true /\
    aliens_y[j,i+1] = aliens_y[j,i]
  )
);
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == false) -> (aliens_y[j,i+1] = max(1, aliens_y[j,i] - 1))
);



/* CONSTRAINTS */
% It's possible to shoot to an alien only once
constraint all_different_except_0(shoot);



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

