if maze_surface = 0
{
	maze_surface = surface_create(maze_width * cell_size, maze_height * cell_size);
	surface_set_target(maze_surface);
	draw_maze(maze, cell_size);
	surface_reset_target();
	
}

draw_surface(maze_surface, 0, 0);

if keyboard_check_pressed(vk_space)
{
	seed++;
	maze = maze_create_recursive_backtracker(maze_width, maze_height, seed);
	
	surface_set_target(maze_surface);
	draw_maze(maze, cell_size);
	surface_reset_target();
}