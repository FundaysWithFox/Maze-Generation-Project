//Checks to see whether or not the maze has been finished
if cells_visited < maze_width * maze_height
{
	//Sets up the list of possible directions that the algorithm can go
	var neighbors = ds_list_create();

	//Checks to see if there's an unvisited cell North, if yes then North is added to the list
	if y_pos > 0
	{
		if !maze_status[array_get_coord(x_pos, y_pos - 1, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_NORTH);
		}
	}
	//Checks to see if there's an unvisited cell East, if yes then East is added to the list
	if x_pos < maze_width - 1
	{
		if !maze_status[array_get_coord(x_pos + 1, y_pos, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_EAST);
		}
	}
	//Checks to see if there's an unvisited cell South, if yes then South is added to the list
	if y_pos < maze_height - 1
	{
		if !maze_status[array_get_coord(x_pos, y_pos + 1, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_SOUTH);
		}
	}
	//Checks to see if there's an unvisited cell West, if yes then West is added to the list
	if x_pos > 0
	{
		if !maze_status[array_get_coord(x_pos - 1, y_pos, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_WEST);
		}
	}
	
	var x_offset = 0;
	var y_offset = 0;
	
	if !ds_list_empty(neighbors)
	{
		//If there are any unvisited cells next to the current cell, it chooses a random direction in the list of possible directions
		var next_cell_dir = ds_list_find_value(neighbors, irandom(ds_list_size(neighbors) - 1));
		x_offset = dcos(next_cell_dir * 90 - 90);
		y_offset = dsin(next_cell_dir * 90 - 90);
		
		
		//Carve a path from the current cell to the next one
		maze_status[array_get_coord(x_pos, y_pos, maze_width)][next_cell_dir] = true;
		
		//Change the current cell to the next one
		x_pos += x_offset;
		y_pos += y_offset;
		
		//Carve a path from the new current cell to the old one, and mark the new one as visited
		maze_status[array_get_coord(x_pos, y_pos, maze_width)][(next_cell_dir + 2) % 4] = true;
		maze_status[array_get_coord(x_pos, y_pos, maze_width)][CELL_VISITED] = true;
		
		//Tell the program that another cell has been visited, so it knows when to stop when all the cells have been visited
		cells_visited++;
	}
	else
	{
		//A variable to tell us when we've found a cell that meets the criteria
		var found = false;
		
		//The location of the cell being checked
		var pointer_pos = cells_clear;
		
		while found = false
		{
			var currently_clear = true;
		
			//Sets up the list of possible directions that the new cell can connect to
			var neighbors = ds_list_create();
		
			//Checks to see if there's a visited cell North, if yes then North is added to the list
			if pointer_pos >= maze_width
			{
				if maze_status[pointer_pos - maze_width][CELL_VISITED]
				{
					ds_list_add(neighbors, CELL_PATH_NORTH);
				}
			}
			//Checks to see if there's a visited cell East, if yes then East is added to the list
			if pointer_pos % maze_width < maze_width - 1
			{
				if maze_status[pointer_pos + 1][CELL_VISITED]
				{
					ds_list_add(neighbors, CELL_PATH_EAST);
				}
			}
			//Checks to see if there's a visited cell South, if yes then South is added to the list
			if pointer_pos < maze_width * (maze_height - 1)
			{
				if maze_status[pointer_pos + maze_width][CELL_VISITED]
				{
					ds_list_add(neighbors, CELL_PATH_SOUTH);
				}
			}
			//Checks to see if there's a visited cell West, if yes then West is added to the list
			if pointer_pos % maze_width > 0
			{
				if maze_status[pointer_pos - 1][CELL_VISITED]
				{
					ds_list_add(neighbors, CELL_PATH_WEST);
				}
			}
		
			if !maze_status[pointer_pos][CELL_VISITED] && !ds_list_empty(neighbors)
			{
				//If the cell being checked is unvisited and it is adjacent to at least one visited cell, start carving a path from there
				x_pos = pointer_pos % maze_width;
				y_pos = pointer_pos div maze_width;
				
				//Choose which visited cell to connect to
				var connection_dir = ds_list_find_value(neighbors, irandom(ds_list_size(neighbors) - 1));
				x_offset = dcos(connection_dir * 90 - 90);
				y_offset = dsin(connection_dir * 90 - 90);
				
				//Carve a path from the new current cell to the adjacent visited one
				maze_status[array_get_coord(x_pos, y_pos, maze_width)][connection_dir] = true;
				maze_status[array_get_coord(x_pos + x_offset, y_pos + y_offset, maze_width)][(connection_dir + 2) % 4] = true;
				
				//Mark the new cell as visited and let us know that a cell has been found
				maze_status[pointer_pos][CELL_VISITED] = true;
				cells_visited++;
				found = true;
			}
			else
			{
				if maze_status[pointer_pos][CELL_VISITED] && currently_clear cells_clear++;
				else currently_clear = false;
				//Move the pointer to the next location so that it can check the next cell
				pointer_pos++;
			}
		}
	}
	ds_list_destroy(neighbors);
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();