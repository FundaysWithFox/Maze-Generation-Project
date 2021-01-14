//Checking to see whether or not the maze has been finished
if cells_visited < maze_width * maze_height
{
	//Decides whether to go North, South, East, or West
	var next_cell_dir = irandom(3);
	var x_offset = dcos(next_cell_dir * 90 - 90);
	var y_offset = dsin(next_cell_dir * 90 - 90);
	
	//Checks to see if the next cell is within the bounds of the maze
	if x_pos + x_offset = clamp(x_pos + x_offset, 0, maze_width - 1) && y_pos + y_offset = clamp(y_pos + y_offset, 0, maze_height - 1)
	{
		//If it is within the bounds, check to see if the next cell has been visited
		if !maze_status[array_get_coord(x_pos + x_offset, y_pos + y_offset, maze_width)][CELL_VISITED]
		{
			//If it hasn't been visited, carve a path North and mark the next cell as visited
			maze_status[array_get_coord(x_pos, y_pos, maze_width)][next_cell_dir] = true;
			maze_status[array_get_coord(x_pos + x_offset, y_pos + y_offset, maze_width)][(next_cell_dir + 2) % 4] = true;
			maze_status[array_get_coord(x_pos + x_offset, y_pos + y_offset, maze_width)][CELL_VISITED] = true;
		
			//Increase the number of cells that has been visited
			cells_visited++;
		}
		//Move the pointer
		x_pos += x_offset;
		y_pos += y_offset;
	}
}

//Reset the maze if the space bar has been pressed
if keyboard_check_pressed(vk_space) room_restart();