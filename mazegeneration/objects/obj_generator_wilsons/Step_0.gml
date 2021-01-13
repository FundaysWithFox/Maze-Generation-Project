while cells_visited < maze_width * maze_height
{
	var x_pos = ds_list_find_value(path_list, ds_list_size(path_list) - 1)[0];
	var y_pos = ds_list_find_value(path_list, ds_list_size(path_list) - 1)[1];
	
	if !maze_status[array_get_coord(x_pos, y_pos, maze_width)][cell.CELL_VISITED]
	{
		//Sets up the list of possible directions that the algorithm can go
		var neighbors = ds_list_create();
	
		//Checks to see if there's an unvisited cell North, if yes then North is added to the list
		if y_pos > 0
		{
			ds_list_add(neighbors, [x_pos, y_pos - 1]);
		}
		//Checks to see if there's an unvisited cell East, if yes then East is added to the list
		if x_pos < maze_width - 1
		{
			ds_list_add(neighbors, [x_pos + 1, y_pos]);
		}
		//Checks to see if there's an unvisited cell South, if yes then South is added to the list
		if y_pos < maze_height - 1
		{
			ds_list_add(neighbors, [x_pos, y_pos + 1]);
		}
		//Checks to see if there's an unvisited cell West, if yes then West is added to the list
		if x_pos > 0
		{
			ds_list_add(neighbors, [x_pos - 1, y_pos]);
		}
	
		var next_dir = irandom(ds_list_size(neighbors) - 1);
		var next_cell = ds_list_find_value(neighbors, next_dir);
	
		ds_list_delete(path_list, ds_list_size(path_list) - 1);
		ds_list_add(path_list, [x_pos, y_pos, next_cell[0], next_cell[1], next_dir]);
		ds_list_add(path_list, [next_cell[0], next_cell[1], 0, 0, 0]);
	}
	else
	{
		if cell_current < ds_list_size(path_list) - 1
		{
			var path_current = ds_list_find_value(path_list, cell_current);
			x_pos = path_current[0];
			y_pos = path_current[1];
		
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][cell.CELL_VISITED] = true;
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][path_current[4]] = true;
			maze_status[array_get_coord(path_current[2], path_current[3], maze_width)][path_current[4]] = true;
			
			for (var i = 0; i < ds_list_size(path_list); i++)
			{
				var current_cell = ds_list_find_value(path_list, i);
				if current_cell[0] = path_current[2] && current_cell[1] = path_current[3]
				{
					cell_current = i;
					break;
				}
			}
			
			cells_visited++;
		}
		else
		{
			cell_current = 0;
			path_list = ds_list_create();
			ds_list_add(path_list, [irandom(maze_width - 1), irandom(maze_height - 1), 0, 0, 0]);
		}
		
	}
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();