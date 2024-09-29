% Parameters
int: n = 5;  % Grid size
int: t = 3;  % Time steps

% Decision variables
array[0..t] of var 0..n-1: defender_pos;
array[0..t-1] of var -1..1: move;  % -1: left, 0: stay, 1: right

% Initial position of defender
constraint defender_pos[0] = 0;

% Effect of moves
constraint forall(i in 1..t) (
  defender_pos[i] = defender_pos[i-1] + move[i-1]
);

% Ensure defender stays within the grid
constraint forall(i in 0..t) (
  defender_pos[i] >= 0 /\ defender_pos[i] < n
);

% Invader position (simplified, moving right each step)
array[0..t] of int: invader_pos = array1d(0..t, [i | i in 0..t]);

% Goal: Defender must intercept invader
constraint exists(i in 0..t) (
  defender_pos[i] = invader_pos[i]
);

% Solve and output
solve satisfy;

output [
  "Moves: " ++ show(move) ++ "\n" ++
  "Defender positions: " ++ show(defender_pos) ++ "\n" ++
  "Invader positions: " ++ show(invader_pos)
];
