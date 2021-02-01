if keyboard_check_pressed(vk_space)
{
	maze = obj_maze.maze;
	width = maze_get_width(maze);
	height = maze_get_height(maze);
	
	x_pos_current = x_pos_start;
	y_pos_current = y_pos_start;
	
	cells_visited_list = array_create(maze_get_width(maze) * maze_get_height(maze), false);
	path_list = ds_list_create();
}

if mouse_check_button_pressed(mb_left)
{
	x_pos_start = clamp(mouse_x div cell_size, 0, width - 1);
	y_pos_start = clamp(mouse_y div cell_size, 0, height - 1);
	
	x_pos_current = x_pos_start;
	y_pos_current = y_pos_start;
	
	cells_visited_list = array_create(maze_get_width(maze) * maze_get_height(maze), false);
	path_list = ds_list_create();
}

if mouse_check_button_pressed(mb_right)
{
	x_pos_current = x_pos_start;
	y_pos_current = y_pos_start;
	
	x_pos_end = clamp(mouse_x div cell_size, 0, width - 1);
	y_pos_end = clamp(mouse_y div cell_size, 0, height - 1);
	
	cells_visited_list = array_create(maze_get_width(maze) * maze_get_height(maze), false);
	path_list = ds_list_create();
}

if x_pos_current != x_pos_end || y_pos_current != y_pos_end
{
	cells_visited_list[grid_get_coord_1d(x_pos_current, y_pos_current, width)] = true;
	
	var path_direction_next = -1;
	for (var i = CELL_PATH_NORTH; i <= CELL_PATH_WEST; i++)
	{
		if maze_get_path(maze, x_pos_current, y_pos_current, i) && !cells_visited_list[grid_get_coord_1d(x_pos_current + dcos(i * 90 - 90), y_pos_current + dsin(i * 90 - 90), width)] {path_direction_next = i; break;}
	}
	
	var offset_x, offset_y;
	
	if path_direction_next = -1
	{
		var direction_previous = ds_list_find_value(path_list, ds_list_size(path_list) - 1);
		offset_x = dcos(((direction_previous + 2) % 4) * 90 - 90);
		offset_y = dsin(((direction_previous + 2) % 4) * 90 - 90);
		ds_list_delete(path_list, ds_list_size(path_list) - 1);
	}
	else
	{
		offset_x = dcos(path_direction_next * 90 - 90);
		offset_y = dsin(path_direction_next * 90 - 90);
		ds_list_add(path_list, path_direction_next);
	}
	
	x_pos_current += offset_x;
	y_pos_current += offset_y;
}