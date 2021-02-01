maze = obj_maze.maze;
width = maze_get_width(maze);
height = maze_get_height(maze);
cell_size = obj_maze.cell_size;

x_pos_start = 0;
y_pos_start = 0;

x_pos_current = x_pos_start;
y_pos_current = y_pos_start;

x_pos_end = width - 1;
y_pos_end = height - 1;

cells_visited_list = array_create(maze_get_width(maze) * maze_get_height(maze), false);
path_list = ds_list_create();

line_width = 2;