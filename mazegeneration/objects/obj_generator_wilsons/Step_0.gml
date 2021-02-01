//Checks to see if the maze has been finished
if !ds_list_empty(cells_available)
{
	//If it is not finished, check to see if the current path being added has come into contact with a visited cell
	if maze_status[array_get_coord(path_current_x, path_current_y, maze_width)][CELL_VISITED]
	{
		var x_pos = path_start_x;
		var y_pos = path_start_y;
		
		//If it has, mark all the cells in the path as visited and carve out the walls
		while !maze_status[array_get_coord(x_pos, y_pos, maze_width)][CELL_VISITED]
		{
			//Makes it so that the current cell in the path can not be the start of a new path
			ds_list_delete(cells_available, ds_list_find_index(cells_available, array_get_coord(x_pos, y_pos, maze_width)));
			
			//Marks the cell as visited
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][CELL_VISITED] = true;
			
			//Carves a path between the current cell in the path and the next one
			var path_dir = path_status[array_get_coord(x_pos, y_pos, maze_width)];
			var x_offset = dcos(path_dir * 90 - 90);
			var y_offset = dsin(path_dir * 90 - 90);
			
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][path_dir] = true;
			maze_status[array_get_coord(x_pos + x_offset, y_pos + y_offset, maze_width)][(path_dir + 2) % 4] = true;
			
			//Go to the next cell
			x_pos += x_offset;
			y_pos += y_offset;
		}
		
		//If the maze has not been finished, choose a cell to start the new path from
		if !ds_list_empty(cells_available)
		{
			var cell_start = irandom(ds_list_size(cells_available) - 1);
		
			path_start_x = ds_list_find_value(cells_available, cell_start) % maze_width;
			path_start_y = ds_list_find_value(cells_available, cell_start) div maze_width;
		
			path_current_x = path_start_x;
			path_current_y = path_start_y;
		}
	}
	//else
	//{
		//If the current path has not been completed, choose a direction for the path to go in
		var path_dir;
		var path_next_x = -1;
		var path_next_y = -1;
		
		while path_next_x != clamp(path_next_x, 0, maze_width - 1) || path_next_y != clamp(path_next_y, 0, maze_height - 1)
		{
			path_dir = irandom(CELL_PATH_WEST);
			path_next_x = path_current_x + dcos(path_dir * 90 - 90);
			path_next_y = path_current_y + dsin(path_dir * 90 - 90);
		}
		
		//Tell the path that the next cell is the choosen direction
		path_status[array_get_coord(path_current_x, path_current_y, maze_width)] = path_dir;
		path_current_x = path_next_x;
		path_current_y = path_next_y;
	//}
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();