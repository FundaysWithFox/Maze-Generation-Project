seed = 0;

cell_size = 32;
maze_width = 16;
maze_height = 16;
maze = maze_create_recursive_backtracker(maze_width, maze_height, seed);

maze_surface = 0;