#macro CELL_PATH_NORTH 0
#macro CELL_PATH_EAST 1
#macro CELL_PATH_SOUTH 2
#macro CELL_PATH_WEST 3
#macro CELL_VISITED 4

function grid_get_coord_1d(x, y, width)
{
	return x + y * width;
}

function maze_get_width(maze)
{
	return buffer_peek(maze, 0, buffer_u32);
}

function maze_get_height(maze)
{
	return buffer_peek(maze, 4, buffer_u32);
}

function maze_get_path(maze, x, y, direction)
{
	var width = maze_get_width(maze);
	
	return buffer_peek(maze, (grid_get_coord_1d(x, y, width) * 4) + direction + 8, buffer_bool);
}

function maze_set_path(maze, x, y, path, direction, set_adjacent_cell)
{
	 set_adjacent_cell = is_undefined(set_adjacent_cell) ? true : set_adjacent_cell;
	 
	 var width = maze_get_width(maze);
	 
	 buffer_poke(maze, (grid_get_coord_1d(x, y, width) * 4) + direction + 8, buffer_bool, path);
	 if set_adjacent_cell buffer_poke(maze, (grid_get_coord_1d(x + dcos(direction * 90 - 90), y + dsin(direction * 90 - 90), width) * 4) + ((direction + 2) % 4) + 8, buffer_bool, path);
}

function draw_maze(maze, cell_size)
{
	var maze_width = maze_get_width(maze);
	var maze_height = maze_get_height(maze);
	
	//Draw the maze
	for (var j = 0; j < maze_height; j++)
	{
		for (var i = 0; i < maze_width; i++)
		{
			var vert_a = [i * cell_size, j * cell_size];
			var vert_b = [(i + 1) * cell_size - 1, (j + 1) * cell_size - 1];
	
			//Draw the cell
			draw_set_color(c_white);
			draw_rectangle(vert_a[0], vert_a[1], vert_b[0], vert_b[1], false);
	
			draw_set_color(c_black);
			//Checks whether or not the cell being drawn has North, East, South, and West facing walls
			if !maze_get_path(maze, i, j, CELL_PATH_NORTH)
			{
				draw_line(vert_a[0] - 1, vert_a[1], vert_b[0], vert_a[1]);
			}
			if !maze_get_path(maze, i, j, CELL_PATH_EAST)
			{
				draw_line(vert_b[0], vert_a[1] - 1, vert_b[0], vert_b[1]);
			}
			if !maze_get_path(maze, i, j, CELL_PATH_SOUTH)
			{
				draw_line(vert_a[0] - 1, vert_b[1], vert_b[0], vert_b[1]);
			}
			if !maze_get_path(maze, i, j, CELL_PATH_WEST)
			{
				draw_line(vert_a[0], vert_a[1] - 1, vert_a[0], vert_b[1]);
			}
		}
	}
}

function maze_create_recursive_backtracker(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	//Setting up the maze (a buffer that tells us the status of each cell)
	var maze_status = buffer_create(8 + width * height * 4, buffer_fixed, 1);
	buffer_poke(maze_status, 0, buffer_u32, width);
	buffer_poke(maze_status, 4, buffer_u32, height);
	var cells_visited_list;
	for (var i = 8; i < width * height + 8; i++)
	{
		buffer_poke(maze_status, i, buffer_bool, false);
		cells_visited_list[i - 8] = false;
	}

	//Setting up the list of coordinates so the algorithm can backtrack
	var coord_list = ds_stack_create();
	ds_stack_push(coord_list, [irandom(width - 1), irandom(height - 1)]);

	//Marking the starting cell as visited
	cells_visited_list[grid_get_coord_1d(ds_stack_top(coord_list)[0], ds_stack_top(coord_list)[1], width)] = true;
	var cells_visited = 1;
	
	//Loops until the maze has been completed
	while cells_visited < width * height
	{
		//Sets up the list of possible directions that the algorithm can go
		var neighbors = ds_list_create();
	
		//Stores the x and y coordinates of the current cell's position
		var pointer_x = ds_stack_top(coord_list)[0];
		var pointer_y = ds_stack_top(coord_list)[1];

		for (var i = CELL_PATH_NORTH; i <= CELL_PATH_WEST; i++)
		{
			if !cells_visited_list[grid_get_coord_1d(clamp(pointer_x + dcos(i * 90 - 90), 0, width - 1), clamp(pointer_y + dsin(i * 90 - 90), 0, height - 1), width)]
			{
				ds_list_add(neighbors, i);
			}
		}
	
		if !ds_list_empty(neighbors)
		{
			//If there are any unvisited cells next to the current cell, it chooses a random direction in the list of possible directions
			var next_cell_dir = ds_list_find_value(neighbors, irandom(ds_list_size(neighbors) - 1));
			var x_offset = dcos(next_cell_dir * 90 - 90);
			var y_offset = dsin(next_cell_dir * 90 - 90);
			//Carve a path from the current cell to the next one
			maze_set_path(maze_status, pointer_x, pointer_y, true, next_cell_dir);
		
			//Change the current cell to the next one
			pointer_x += x_offset;
			pointer_y += y_offset;
			ds_stack_push(coord_list, [pointer_x, pointer_y]);
		
			//Mark the new cell as visited
			cells_visited_list[grid_get_coord_1d(pointer_x, pointer_y, width)] = true;
		
			//Tell the program that another cell has been visited, so it knows when to stop when all the cells have been visited
			cells_visited++;
		}
		else
		{
			//If there are no available cells to move to, backtrack until you find a cell that has unvisited neihgbors
			ds_stack_pop(coord_list);
		}
		ds_list_destroy(neighbors);
	}
	
	random_set_seed(seed_old);
	
	ds_stack_destroy(coord_list);
	
	return maze_status;
}

function maze_create_randomized_prim(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	//Setting up the maze (a buffer that tells us the status of each cell)
	var maze_status = buffer_create(8 + width * height * 4, buffer_fixed, 1);
	buffer_poke(maze_status, 0, buffer_u32, width);//Setting up the list of coordinates so the algorithm can decide what cell to expand from
	buffer_poke(maze_status, 4, buffer_u32, height);coord_list = ds_list_create();
	var cells_visited_list;ds_list_add(coord_list, [irandom(maze_width - 1), irandom(maze_height - 1)]);
	for (var i = 8; i < width * height + 8; i++)
	{
		//Marking the starting cell as visited
		buffer_poke(maze_status, i, buffer_bool, false);
		cells_visited_list[i - 8] = false;
	}
	
	//Setting up the list of coordinates so the algorithm can backtrack
	var coord_list = ds_list_create();
	ds_list_add(coord_list, [irandom(width - 1), irandom(height - 1)]);
	
	//Marking the starting cell as visited
	cells_visited_list[grid_get_coord_1d(ds_stack_top(coord_list)[0], ds_stack_top(coord_list)[1], width)] = true;
	var cells_visited = 1;
	
	random_set_seed(seed_old);
}