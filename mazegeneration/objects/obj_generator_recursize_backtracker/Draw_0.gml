//Draw the maze
for (var i = 0; i < maze_width; i++)
{
	for (var j = 0; j < maze_height; j++)
	{
		//If the cell being drawn has been visited, color it white. Otherwise, color it blue
		if maze_status[array_get_coord(i, j, maze_width)][cell.CELL_VISITED]
		{
			draw_set_color(c_white);
			draw_rectangle(i * cell_size, j * cell_size, (i + 1) * cell_size, (j + 1) * cell_size, false);
		}
		else
		{
			draw_set_color(c_blue);
			draw_rectangle(i * cell_size, j * cell_size, (i + 1) * cell_size, (j + 1) * cell_size, false);
		}
		
		draw_set_color(c_black);
		//Checks whether or not the cell being drawn has East and South facing walls, if it does draw the walls. Does not check North and West walls
		if !maze_status[array_get_coord(i, j, maze_width)][cell.CELL_PATH_EAST]
		{
			draw_line((i + 1) * cell_size - 1, j * cell_size - 1, (i + 1) * cell_size - 1, (j + 1) * cell_size - 1);
		}
		if !maze_status[array_get_coord(i, j, maze_width)][cell.CELL_PATH_SOUTH]
		{
			draw_line(i * cell_size - 1, (j + 1) * cell_size - 1, (i + 1) * cell_size - 1, (j + 1) * cell_size - 1);
		}
	}
}