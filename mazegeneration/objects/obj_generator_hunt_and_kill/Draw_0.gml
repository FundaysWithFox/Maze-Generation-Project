//Draw the maze
for (var i = 0; i < maze_width; i++)
{
	for (var j = 0; j < maze_height; j++)
	{
		var vert_a = [i * cell_size, j * cell_size];
		var vert_b = [(i + 1) * cell_size - 1, (j + 1) * cell_size - 1];
	
		//If the cell being drawn has been visited, color it white. Otherwise, color it blue
		if maze_status[array_get_coord(i, j, maze_width)][CELL_VISITED] draw_set_color(c_white);
		else draw_set_color(c_blue);
		
		if array_get_coord(i, j, maze_width) < cells_clear draw_set_color(c_lime);
		
		if i = x_pos && j = y_pos && cells_visited < maze_width * maze_height draw_set_color(c_lime);
		
		draw_rectangle(vert_a[0], vert_a[1], vert_b[0], vert_b[1], false);
	
		draw_set_color(c_black);
		//Checks whether or not the cell being drawn has North, East, South, and West facing walls
		if !maze_status[array_get_coord(i, j, maze_width)][CELL_PATH_NORTH]
		{
			draw_line(vert_a[0] - 1, vert_a[1], vert_b[0], vert_a[1]);
		}
		if !maze_status[array_get_coord(i, j, maze_width)][CELL_PATH_EAST]
		{
			draw_line(vert_b[0], vert_a[1] - 1, vert_b[0], vert_b[1]);
		}
		if !maze_status[array_get_coord(i, j, maze_width)][CELL_PATH_SOUTH]
		{
			draw_line(vert_a[0] - 1, vert_b[1], vert_b[0], vert_b[1]);
		}
		if !maze_status[array_get_coord(i, j, maze_width)][CELL_PATH_WEST]
		{
			draw_line(vert_a[0], vert_a[1] - 1, vert_a[0], vert_b[1]);
		}
	}
}