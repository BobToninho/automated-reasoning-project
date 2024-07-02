% coords are on the carthesian plane: 0,0 is bottom left

par int max_x;
par int max_y;
% constraint y != 0 for ships_coordinates
par int[][] shipe_coordinates;

% can shoot to astronaut in the same y
% OR can move on the x axis
int[][] cannon = [0,0];
int time;
