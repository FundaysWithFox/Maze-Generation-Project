//Checking to see whether or not the maze has been finished
if cells_visited < maze_width * maze_height
{
	//Sets up the list of possible directions that the algorithm can go
	var neighbors = ds_list_create();
	
	//Stores the x and y coordinates of a random cell's position
	var cell_choice = irandom(ds_list_size(coord_list_x) - 1);
	var pointer_x = ds_list_find_value(coord_list_x, cell_choice);
	var pointer_y = ds_list_find_value(coord_list_y, cell_choice);

	//Checks to see if there's an unvisited cell North, if yes then North is added to the list
	if pointer_y > 0
	{
		if !maze_status[array_get_coord(pointer_x, pointer_y - 1, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_NORTH);
		}
	}
	//Checks to see if there's an unvisited cell East, if yes then East is added to the list
	if pointer_x < maze_width - 1
	{
		if !maze_status[array_get_coord(pointer_x + 1, pointer_y, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_EAST);
		}
	}
	//Checks to see if there's an unvisited cell South, if yes then South is added to the list
	if pointer_y < maze_height - 1
	{
		if !maze_status[array_get_coord(pointer_x, pointer_y + 1, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_SOUTH);
		}
	}
	//Checks to see if there's an unvisited cell West, if yes then West is added to the list
	if pointer_x > 0
	{
		if !maze_status[array_get_coord(pointer_x - 1, pointer_y, maze_width)][CELL_VISITED]
		{
			ds_list_add(neighbors, CELL_PATH_WEST);
		}
	}
	
	if !ds_list_empty(neighbors)
	{
		//If there are any unvisited cells next to the current cell, it chooses a random direction in the list of possible directions
		var next_cell_dir = ds_list_find_value(neighbors, irandom(ds_list_size(neighbors) - 1));
		var x_offset = dcos(next_cell_dir * 90 - 90);
		var y_offset = dsin(next_cell_dir * 90 - 90);
		
		//Carve a path from the current cell to the next one
		maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][next_cell_dir] = true;
		
		//Change the current cell to the next one
		pointer_x += x_offset;
		pointer_y += y_offset;
		ds_list_add(coord_list_x, pointer_x);
		ds_list_add(coord_list_y, pointer_y);
		
		//Carve a path from the new current cell to the old one, and mark the new one as visited
		maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][(next_cell_dir + 2) % 4] = true;
		maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][CELL_VISITED] = true;
		
		//Tell the program that another cell has been visited, so it knows when to stop when all the cells have been visited
		cells_visited++;
	}
	if ds_list_size(neighbors) <= 1
	{
		//If there are no available cells to move to, remove the current cell from the list of possible cells
		ds_list_delete(coord_list_x, cell_choice);
		ds_list_delete(coord_list_y, cell_choice);
	}
	ds_list_destroy(neighbors);
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();