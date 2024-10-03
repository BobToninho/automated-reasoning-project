/* PARAMETERS */
int: t = 3;  % Time steps
int: x = 5;
int: y = 5;
int: alien_1_x_initial = 3;
int: alien_1_y_initial = 3;

% always same x
array[0..t] of int: alien_1_x = array1d(0..t, [alien_1_x_initial | i in 0..t]);

/* DECISION VARIABLES */
array[0..t] of var 0..x-1: cannon_pos_x;
array[0..t-1] of var bool: cannon_shoot;
array[0..t-1] of var -x..x: move_x;

array[0..t] of var bool: alien_1_dead;
array[0..t] of var 1..y: alien_1_y;

/* Initial position of cannon */
constraint cannon_pos_x[0] = 0;

/* Alien starts alive */
constraint alien_1_dead[0] = false;

constraint alien_1_y[0] = alien_1_y_initial;

% Goal
% It seems that this makes minizinc generate a death just because this exists.
constraint exists(i in 0..t) (
    alien_1_dead[i] = true
);


% Move effect
constraint forall(i in 0..t-1) (
  cannon_pos_x[i+1] = move_x[i]
);
% Shoot effect
constraint forall(i in 0..t-1) (
  alien_1_dead[i+1] = (alien_1_dead[i] \/ (cannon_pos_x[i] == alien_1_x[i] /\ cannon_shoot[i]))
);

/* INERTIA */
constraint forall(i in 0..t-1) (
  alien_1_y[i+1] = max(1, alien_1_y[i] - 1)
);
% i don't understand how this "recursive" thing works
constraint forall(i in 0..t-1) (
  alien_1_dead[i+1] = (alien_1_dead[i] \/ alien_1_dead[i+1])
);

/* Constraints */
constraint forall(i in 0..t-1) (
  not (cannon_shoot[i] /\ (move_x[i] != 0))
);




/* Solve and output */
solve satisfy;

output [
  "move_x:\t\t" ++ show(move_x) ++ "\n" ++
  "cannon_pos_x:\t" ++ show(cannon_pos_x) ++ "\n" ++
  "cannon_shoot:\t" ++ show(cannon_shoot) ++ "\n" ++
  "alien_1_x:\t" ++ show(alien_1_x) ++ "\n" ++
  "alien_1_y:\t" ++ show(alien_1_y) ++ "\n" ++
  "alien_1_dead:\t" ++ show(alien_1_dead) ++ "\n"
];
