seed = 0;

maze_type = maze_create_ellers;

cell_size = 32;
maze_width = room_width div cell_size;
maze_height = room_height div cell_size;
maze = maze_type(maze_width, maze_height, seed);

maze_surface = 0;