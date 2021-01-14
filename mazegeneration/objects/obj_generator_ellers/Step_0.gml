if y_pos < maze_height
{
	if x_pos < maze_width
	{
		var current_cell = array_get_coord(x_pos, y_pos, maze_width);
		
		var same_set = false;
		for (var i = 0; i < ds_list_size(row_status[current_cell % maze_width]); i++)
		{
			for (var j = 0; j < ds_list_size(row_status_next[current_cell % maze_width]); j++)
			{
				if ds_list_find_value(row_status[current_cell % maze_width], i) = ds_list_find_value(row_status_next[current_cell % maze_width], j) same_set = true;
			}
		}
		
		if (irandom(2) > 0 || y_pos = maze_height - 1) && !same_set && x_pos < maze_width - 1
		{
			maze_status[current_cell][CELL_PATH_EAST] = true;
			maze_status[current_cell + 1][CELL_PATH_WEST] = true;
			for (var i = 0; i < ds_list_size(row_status[current_cell % maze_width]); i++)
			{
				ds_list_add(row_status[(current_cell + 1) % maze_width], ds_list_find_value(row_status[current_cell % maze_width], i));
			}
		}
		else if y_pos < maze_height - 1
		{
			var group = ds_list_create();
			var group_check = current_cell;
			
			ds_list_add(group, group_check);
			
			while maze_status[group_check][CELL_PATH_WEST]
			{
				group_check--;
				ds_list_add(group, group_check);
			}
			
			var connection_count = irandom_range(1, ds_list_size(group));
			for (var i = 0; i < connection_count; i++)
			{
				var group_choice = irandom(ds_list_size(group) - 1);
				maze_status[ds_list_find_value(group, group_choice)][CELL_PATH_SOUTH] = true;
				maze_status[ds_list_find_value(group, group_choice) + maze_width][CELL_PATH_NORTH] = true;
				maze_status[ds_list_find_value(group, group_choice) + maze_width][CELL_VISITED] = true;
				row_status_next[ds_list_find_value(group, group_choice) % maze_width] = row_status[group_check % maze_width];
				
				ds_list_delete(group, group_choice);
			}
		}
		x_pos++;
	}
	else
	{
		x_pos = 0;
		y_pos++;
		for (var i = 0; i < maze_width; i++)
		{
			row_status[i] = row_status_next[i];
			row_status_next[i] = ds_list_create();
			ds_list_add(row_status_next[i], i + (y_pos * maze_width));
			maze_status[i + (y_pos * maze_width)][CELL_VISITED] = true;
		}
		cells_visited += maze_width;
	}
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();