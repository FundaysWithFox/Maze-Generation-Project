if y_pos < maze_height
{
	if x_pos < maze_width - 1
	{
		if (irandom(1) || y_pos >= maze_height - 1) && row_lists[x_pos] != row_lists[x_pos + 1]
		{
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][CELL_PATH_EAST] = true;
			maze_status[array_get_coord(x_pos + 1, y_pos, maze_width)][CELL_PATH_WEST] = true;
			
			var cell_current_set = row_lists[x_pos];
			var cell_next_set = row_lists[x_pos + 1];
			for (var i = 0; i < ds_list_size(ds_list_find_value(sets_list, cell_next_set)) || i > ds_list_size(ds_list_find_value(sets_list, cell_next_set)); i++)
			{
				var cell_adding = ds_list_find_value(ds_list_find_value(sets_list, cell_next_set), i);
				ds_list_add(cell_current_set, cell_adding);
				row_lists[cell_adding] = cell_current_set;
			}
			ds_list_clear(cell_next_set);
		}
		
		x_pos++;
	}
	else
	{
		x_pos = 0;
		y_pos++;
		
		if y_pos < maze_height
		{
			for (var i = 0; i < ds_list_size(sets_list) && !ds_list_empty(ds_list_find_value(sets_list, i)) && y_pos != maze_height - 1; i++)
			{
				var set_list = ds_list_create();
				for (var j = 0; j < irandom_range(1, ds_list_size(ds_list_find_value(sets_list, i)) - 1); j++)
				{
					var cell_choosen = irandom(ds_list_size(ds_list_find_value(sets_list, i)) - 1);
					var cell_pos = ds_list_find_value(ds_list_find_value(sets_list, i), cell_choosen);
					maze_status[array_get_coord(cell_pos, y_pos - 1, maze_width)][CELL_PATH_SOUTH] = true;
					maze_status[array_get_coord(cell_pos, y_pos, maze_width)][CELL_PATH_NORTH] = true;
					ds_list_delete(ds_list_find_value(sets_list, i), cell_choosen);
					
					ds_list_add(set_list, cell_pos);
					row_lists_next[cell_pos % maze_width] = row_lists[cell_pos % maze_width];
				}
				ds_list_add(sets_list_next, set_list);
			}
			
			for (var i = 0; i < maze_width; i++)
			{
				if row_lists_next[i] = -1
				{
					row_lists_next[i] = ds_list_size(sets_list_next);
					var set_list = ds_list_create();
					ds_list_add(set_list, row_lists_next[i]);
					
					ds_list_add(sets_list_next, set_list);
				}
				
				maze_status[array_get_coord(i, y_pos, maze_width)][CELL_VISITED] = true;
			}
			
			row_lists = row_lists_next;
			row_lists_next = array_create(maze_width, -1);
			
			sets_list = sets_list_next;
			sets_list_next = ds_list_create();
		}
	}
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();