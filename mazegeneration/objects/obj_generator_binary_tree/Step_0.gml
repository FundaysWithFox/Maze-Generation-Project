//Checks to see if all the cells have been filled in yet
if current_cell < maze_width * maze_height
{
	//Check to see if the current cell is on the top of the maze
	if current_cell >= maze_width
	{
		//If the current cell isn't on the top of the maze, check to see if it's on the left side
		if current_cell % maze_width > 0
		{
			//If it isn't on the left side, choose to either carve a path North or West
			switch irandom(1)
			{
				case 0:
				{
					maze_status[current_cell][cell.CELL_PATH_NORTH] = true;
					maze_status[current_cell - maze_width][cell.CELL_PATH_SOUTH] = true;
					break;
				}
				case 1:
				{
					maze_status[current_cell][cell.CELL_PATH_WEST] = true;
					maze_status[current_cell - 1][cell.CELL_PATH_EAST] = true;
					break;
				}
			}
		}
		else
		{
			//If it is on the left side, carve a path North
			maze_status[current_cell][cell.CELL_PATH_NORTH] = true;
			maze_status[current_cell - maze_width][cell.CELL_PATH_SOUTH] = true;
		}
	}
	else if current_cell > 0
	{
		//If the current cell is on the top and it isn't also on the left side, carve a path West
		maze_status[current_cell][cell.CELL_PATH_WEST] = true;
		maze_status[current_cell - 1][cell.CELL_PATH_EAST] = true;
	}
	
	//Mark the current cell as visited
	maze_status[current_cell][cell.CELL_VISITED] = true;
	
	//Change the current cell to the next one
	current_cell ++;
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();