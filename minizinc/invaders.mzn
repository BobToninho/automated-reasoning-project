set of int: TIME = 0..t-1;
set of int: ALIENS = 1..a;

/* DECISION VARIABLES */
array[0..t] of var 0..x-1: cannon_x;
array[0..t-1] of var 0..a: cannon_shoot;
array[0..t-1] of var -1..x: move_x;

array[1..a,0..t] of var bool: aliens_dead; 
array[1..a,0..t] of var 1..y: aliens_y; 

/* Initial position of cannon */
constraint cannon_x[0] = 0;

/* Aliens start alive */
constraint forall(j in ALIENS) (
  aliens_dead[j,0] = false
);

/* Aliens initial position */
constraint forall(j in ALIENS) (
  aliens_y[j,0] = aliens_y_initial[j]
);



% Move effect
constraint forall(i in TIME) (
  (move_x[i] != -1) -> (cannon_x[i+1] = move_x[i])
);
constraint forall(i in TIME) (
  move_x[i] != cannon_x[i]
);

% Shoot effect

constraint forall(i in TIME, j in ALIENS) (
  (cannon_shoot[i] == j /\ (cannon_x[i] == aliens_x_initial[j])) -> 
    (aliens_dead[j,i+1] = true)
);
constraint forall(i in TIME, j in ALIENS) (
  (cannon_shoot[i] == j) -> (cannon_x[i+1] = cannon_x[i])
);
% We have either the cannon moving or the cannon shooting
% 0 and -1 are the respective "null values"
constraint forall(i in TIME, j in ALIENS) (
  (cannon_shoot[i] == 0) -> (move_x[i] != -1)
);


/* INERTIA */

constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == true) -> (aliens_dead[j,i+1] = true)
);
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == true) -> (aliens_y[j,i+1] = aliens_y[j,i])
);
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == false) -> (aliens_y[j,i+1] = max(1, aliens_y[j,i] - 1))
);



/* Constraints */




% Goal
constraint forall(j in ALIENS) (
  aliens_dead[j,t] = true 
);
/* Solve and output */
solve satisfy;
/* solve maximize sum(i in ALIENS)(aliens_dead[i,t]); */

output [
  "move_x:\t\t" ++ show(move_x) ++ "\n" ++
  "cannon_x:\t" ++ show(cannon_x) ++ "\n" ++
  "cannon_shoot:\t" ++ show(cannon_shoot) ++ "\n" ++
  /* "alien_1_x:\t" ++ show(alien_1_x) ++ "\n" ++ */
  "aliens_y:\t" ++ show(aliens_y) ++ "\n" ++
  "aliens_dead:\t" ++ show(aliens_dead) ++ "\n"
];
