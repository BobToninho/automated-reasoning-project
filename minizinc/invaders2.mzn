set of int: TIME = 0..t-1;
set of int: ALIENS = 1..a;

/* DECISION VARIABLES */
array[0..t] of var 0..x-1: cannon_x;
% 0 = do not shoot
array[0..t-1] of var 0..a: shoot;
array[0..t-1] of var -x+1..x-1: move_x;

array[1..a,0..t] of var 0..1: aliens_dead;
array[1..a,0..t] of var 1..y-1: aliens_y;

/* Initial position of cannon */
constraint cannon_x[0] = 0;

/* Aliens start alive */
constraint forall(j in ALIENS) (
  aliens_dead[j,0] = 0
);

/* Aliens initial position */
constraint forall(j in ALIENS) (
  aliens_y[j,0] = aliens_y_initial[j]
);



% Move effect
constraint forall(i in TIME) (
  exists(j in ALIENS) (
    move_x[i+1] = (aliens_x_initial[j] - cannon_x[i]) * shoot[i]
  )
);


% Shoot effect

/* INERTIA */

constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == 1) -> (aliens_dead[j,i+1] = true)
);
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == 1) -> (aliens_y[j,i+1] = aliens_y[j,i])
);
constraint forall(i in TIME, j in ALIENS) (
  (aliens_dead[j,i] == 0) -> (aliens_y[j,i+1] = max(1, aliens_y[j,i] - 1))
);



constraint forall(j in ALIENS) (
  aliens_dead[j,t] = 1
);
solve satisfy;

/* solve maximize sum(i in ALIENS)(aliens_dead[i,t]); */

output [
  "move_x:\t\t" ++ show(move_x) ++ "\n" ++
  "cannon_x:\t" ++ show(cannon_x) ++ "\n" ++
  "shoot:\t\t" ++ show(shoot) ++ "\n" ++
  "aliens_y:\t" ++ show(aliens_y) ++ "\n" ++
  "aliens_dead:\t" ++ show(aliens_dead) ++ "\n"
];

