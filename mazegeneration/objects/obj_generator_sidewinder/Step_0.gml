//Checks to see whether or not the maze has been finished
if cells_visited < maze_width * maze_height
{
	cells_visited++;
	
	//Checks to see if the current cell is not on the top edge
	if y_pos > 0
	{
		//If it is't on the top edge, check to see if we need to set up a new run set
		if ds_list_empty(run_set)
		{
			//If we do, add the current cell to the run set and mark it as visited
			ds_list_add(run_set, [x_pos, y_pos]);
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][CELL_VISITED] = true;
		}
		
		//Decides whether to carve a path East, or take a random cell in the run set and carve a path North
		if irandom(1) && x_pos < maze_width - 1
		{
			//Carves a path East, add the East cell to the run set
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][CELL_PATH_EAST] = true;
			maze_status[array_get_coord(x_pos + 1, y_pos, maze_width)][CELL_PATH_WEST] = true;
			maze_status[array_get_coord(x_pos + 1, y_pos, maze_width)][CELL_VISITED] = true;
			ds_list_add(run_set, [x_pos + 1, y_pos]);
		}
		else
		{
			//Chooses a random cell in the run seet to carve North from, and resets the run set
			var list_choice = irandom(ds_list_size(run_set) - 1);
			var cell_choice = ds_list_find_value(run_set, list_choice);
			
			maze_status[array_get_coord(cell_choice[0], cell_choice[1], maze_width)][CELL_PATH_NORTH] = true;
			maze_status[array_get_coord(cell_choice[0], cell_choice[1] - 1, maze_width)][CELL_PATH_SOUTH] = true;
			
			run_set = ds_list_create();
		}
	}
	else if x_pos < maze_width - 1
	{
		//If the current cell is on the top edge, carve a path East
		maze_status[x_pos][CELL_PATH_EAST] = true;
		maze_status[x_pos + 1][CELL_PATH_WEST] = true;
		maze_status[x_pos + 1][CELL_VISITED] = true;
	}
	
	//Update the current cell to the next one
	x_pos++;
	if x_pos >= maze_width y_pos++;
	x_pos = x_pos % maze_width;
}


//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();