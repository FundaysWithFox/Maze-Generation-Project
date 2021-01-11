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

//Just some debug stuff
draw_set_color(c_black);
draw_text(20, 20, cells_visited);
draw_text(20, 40, ds_stack_top(coord_list_x));
draw_text(20, 60, ds_stack_top(coord_list_y));
draw_text(20, 80, maze_status[array_get_coord(clamp(mouse_x, 0, room_width) div cell_size, clamp(mouse_y, 0, room_height) div cell_size, maze_width)]);