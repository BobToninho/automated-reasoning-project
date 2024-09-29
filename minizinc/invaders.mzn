/* PARAMETERS */
int: t = 10;  % Time steps
int: x = 5;
int: y = 5;
int: alien_1_x_initial = 3;
int: alien_1_y_initial = 3;

array[0..t] of int: alien_1_x = array1d(0..t, [alien_1_x_initial | i in 0..t]);

/* DECISION VARIABLES */
array[0..t] of var 0..x-1: cannon_pos_x;
array[0..t-1] of var -x..x: move_x;
array[0..t-1] of var -y..y: move_y;

array[0..t] of var 0..1: alien_1_dead;
array[0..t] of var 1..y: alien_1_y;

/* Initial position of cannon */
constraint cannon_pos_x[0] = 0;

/* Alien starts alive */
constraint alien_1_dead[0] = 0;

constraint alien_1_y[0] = alien_1_y_initial;

constraint forall(i in 0..t-1) (
  alien_1_y[i+1] = max(1, alien_1_y[i] - 1)
);
/* constraint forall(i in 1..t) ( */
/*   cannon_pos_x[i] = cannon_pos_x[i-1] + move[i-1] */
/* ); */

/* Ensure cannon stays within the grid */
/* constraint forall(i in 0..t) ( */
/*   cannon_pos_x[i] >= 0 /\ cannon_pos_x[i] < x */
/* ); */

/* alien position (simplified, moving right each step) */
/* array[0..t] of int: alien_1_pos_x = array1d(0..t, [i | i in 0..t]); */
/* array[0..t] of int: alien_1_pos_y = array1d(0..t, [i | i in 0..t]); */

/* Goal: cannon must intercept alien */
/* constraint alien_1_dead[t] = 1; */

/* Solve and output */
solve satisfy;

output [
  "move_x:\t\t" ++ show(move_x) ++ "\n" ++
  "move_y:\t\t" ++ show(move_y) ++ "\n" ++
  "cannon_pos_x:\t" ++ show(cannon_pos_x) ++ "\n" ++
  "alien_1_x:\t" ++ show(alien_1_x) ++ "\n" ++
  "alien_1_y:\t" ++ show(alien_1_y) ++ "\n" ++
  "alien_1_dead:\t" ++ show(alien_1_dead) ++ "\n"
];
