if keyboard_check_pressed(vk_space)
{
	seed++;
	maze = maze_type(maze_width, maze_height, seed);
	
	surface_set_target(maze_surface);
	draw_maze(maze, cell_size);
	surface_reset_target();
}