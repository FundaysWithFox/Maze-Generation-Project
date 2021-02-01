if grid_get_coord_1d(x_pos, y_pos, width) < width * height
{
	if (irandom(1) || y_pos = height - 1) && x_pos < width - 1
	{
		if sets_list[x_pos] != sets_list[x_pos + 1]
		{
			var cell_current_set = sets_list[x_pos];
			var cell_next_set = sets_list[x_pos + 1];
			maze_set_path(maze_status, x_pos, y_pos, true, CELL_PATH_EAST);
			for (var i = 0; i < width && sets_list[i] = cell_next_set; i++)
			{
				sets_list[i] = cell_current_set;
			}
		}
	}
	else if x_pos >= width - 1 && y_pos < height - 1
	{
		
		var cells_not_added = ds_list_create();
		for (var i = 0; i < width; i++)
		{
			ds_list_add(cells_not_added, i);
		}
		
		var sets = [];
		
		var sets_count = 0;
		while !ds_list_empty(cells_not_added)
		{
			var set_current = sets_list[ds_list_find_value(cells_not_added, 0)];
			var set = ds_list_create();
			
			for (var i = 0; i < width; i++)
			{
				if sets_list[i] = set_current
				{
					ds_list_add(set, i);
					ds_list_delete(cells_not_added, ds_list_find_index(cells_not_added, i));
				}
			}
			
			sets[sets_count] = set;
			sets_count++;
		}
		
		for (var i = 0; i < array_length(sets); i++)
		{
			var connections_added = irandom_range(1, ds_list_size(sets[i]) - 2)
			for (var j = 0; j < connections_added; j++)
			{
				var cell_choice = irandom(ds_list_size(sets[i]) - 1);
				var cell_pos = ds_list_find_value(sets[i], cell_choice);
				maze_set_path(maze_status, cell_pos, y_pos, true, CELL_PATH_SOUTH);
				ds_list_delete(sets[i], ds_list_find_index(sets[i], cell_pos));
				sets_list_next[cell_pos] = sets_list[cell_pos];
			}
		}
		
		for (var i = 0; i < width && sets_list_next[i] = -1; i++)
		{
			sets_list_next[i] = grid_get_coord_1d(x_pos, y_pos + 1, width);
		}
		sets_list = sets_list_next;
		sets_list_next = array_create(width, -1);
	}
	
	x_pos++;
	if x_pos >= width y_pos++;
	x_pos = x_pos % width;
}