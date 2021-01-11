//Checking to see whether or not the maze has been finished, can be changed to a while loop to generate instantly
if cells_visited < maze_width * maze_height
{
	//Sets up the list of possible directions that the algorithm can go
	var neighbors = ds_list_create();
	
	//Stores the x and y coordinates of the current cell's position
	var pointer_x = ds_stack_top(coord_list_x);
	var pointer_y = ds_stack_top(coord_list_y);

	//Checks to see if there's an unvisited cell North, if yes then North is added to the list
	if pointer_y > 0
	{
		if !maze_status[array_get_coord(pointer_x, pointer_y - 1, maze_width)][cell.CELL_VISITED]
		{
			ds_list_add(neighbors, cell.CELL_PATH_NORTH);
		}
	}
	//Checks to see if there's an unvisited cell East, if yes then East is added to the list
	if pointer_x < maze_width - 1
	{
		if !maze_status[array_get_coord(pointer_x + 1, pointer_y, maze_width)][cell.CELL_VISITED]
		{
			ds_list_add(neighbors, cell.CELL_PATH_EAST);
		}
	}
	//Checks to see if there's an unvisited cell South, if yes then South is added to the list
	if pointer_y < maze_height - 1
	{
		if !maze_status[array_get_coord(pointer_x, pointer_y + 1, maze_width)][cell.CELL_VISITED]
		{
			ds_list_add(neighbors, cell.CELL_PATH_SOUTH);
		}
	}
	//Checks to see if there's an unvisited cell West, if yes then West is added to the list
	if pointer_x > 0
	{
		if !maze_status[array_get_coord(pointer_x - 1, pointer_y, maze_width)][cell.CELL_VISITED]
		{
			ds_list_add(neighbors, cell.CELL_PATH_WEST);
		}
	}
	
	if !ds_list_empty(neighbors)
	{
		//If there are any unvisited cells next to the current cell, it chooses a random direction in the list of possible directions
		var next_cell_dir = ds_list_find_value(neighbors, irandom(ds_list_size(neighbors) - 1));
		switch next_cell_dir
		{
			case cell.CELL_PATH_NORTH:
			{
				//If North was choosen, carve a path going North and mark the North cell as visited
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_NORTH] = true;
				
				ds_stack_push(coord_list_x, pointer_x);
				ds_stack_push(coord_list_y, pointer_y - 1);
				pointer_y--;
				
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_SOUTH] = true;
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_VISITED] = true;
				break;
			}
			case cell.CELL_PATH_EAST:
			{
				//If East was choosen, carve a path going North and mark the East cell as visited
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_EAST] = true;
				
				ds_stack_push(coord_list_x, pointer_x + 1);
				ds_stack_push(coord_list_y, pointer_y);
				pointer_x++;
				
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_WEST] = true;
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_VISITED] = true;
				break;
			}
			case cell.CELL_PATH_SOUTH:
			{
				//If South was choosen, carve a path going South and mark the North cell as visited
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_SOUTH] = true;
				
				ds_stack_push(coord_list_x, pointer_x);
				ds_stack_push(coord_list_y, pointer_y + 1);
				pointer_y++;
				
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_NORTH] = true;
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_VISITED] = true;
				break;
			}
			case cell.CELL_PATH_WEST:
			{
				//If West was choosen, carve a path going West and mark the North cell as visited
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_WEST] = true;
				
				ds_stack_push(coord_list_x, pointer_x - 1);
				ds_stack_push(coord_list_y, pointer_y);
				pointer_x--;
				
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_PATH_EAST] = true;
				maze_status[array_get_coord(pointer_x, pointer_y, maze_width)][cell.CELL_VISITED] = true;
				break;
			}
		}
		//Tell the program that another cell has been visited, so it knows when to stop when there are enough
		cells_visited++;
	}
	else
	{
		//If there are no available cells to move to, backtrack until you find a cell that has unvisited neihgbors
		ds_stack_pop(coord_list_x);
		ds_stack_pop(coord_list_y);
	}
	ds_list_destroy(neighbors);
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();