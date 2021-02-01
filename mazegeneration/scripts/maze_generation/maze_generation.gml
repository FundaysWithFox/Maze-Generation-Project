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

function maze_create_blank(width, height)
{
	var maze_status = buffer_create(8 + width * height * 4, buffer_fixed, 1);
	buffer_poke(maze_status, 0, buffer_u32, width);
	buffer_poke(maze_status, 4, buffer_u32, height);
	
	return maze_status;
}

function maze_create_recursive_backtracker(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	//Setting up the maze (a buffer that tells us the status of each cell)
	var maze_status = maze_create_blank(width, height);
	var cells_visited_list = array_create(width * height, false);

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
	var maze_status = maze_create_blank(width, height);
	var cells_visited_list = array_create(width * height, false);
	
	//Setting up the list of coordinates so the algorithm can backtrack
	var coord_list = ds_list_create();
	var start_x = irandom(width - 1);
	var start_y = irandom(height - 1);
	
	ds_list_add(coord_list, [start_x, start_y]);
	
	//Marking the starting cell as visited
	cells_visited_list[grid_get_coord_1d(start_x, start_y, width)] = true;
	var cells_visited = 1;
	
	for (var i = CELL_PATH_NORTH; i <= CELL_PATH_WEST; i++)
	{
		var x_offset = dcos(i * 90 - 90);
		var y_offset = dsin(i * 90 - 90);
		var x_in_bounds = start_x + x_offset = clamp(start_x + x_offset, 0, width - 1);
		var y_in_bounds = start_y + y_offset = clamp(start_y + y_offset, 0, height - 1);
		if  x_in_bounds && y_in_bounds ds_list_add(coord_list, [start_x + x_offset, start_y + y_offset]);
	}
	
	//Checking to see whether or not the maze has been finished
	while cells_visited < width * height
	{
		//Sets up the list of possible directions that the algorithm can go
		var neighbors = ds_list_create();
	
		//Stores the x and y coordinates of a random cell's position
		var cell_choice = irandom(ds_list_size(coord_list) - 1);
		var pointer_x = ds_list_find_value(coord_list, cell_choice)[0];
		var pointer_y = ds_list_find_value(coord_list, cell_choice)[1];
		
		while cells_visited_list[grid_get_coord_1d(pointer_x, pointer_y, width)]
		{
			ds_list_delete(coord_list, cell_choice);
			var cell_choice = irandom(ds_list_size(coord_list) - 1);
			var pointer_x = ds_list_find_value(coord_list, cell_choice)[0];
			var pointer_y = ds_list_find_value(coord_list, cell_choice)[1];
		}
		
		//Checks to see if there's an unvisited cell North, if yes then North is added to the list
		for (var i = CELL_PATH_NORTH; i <= CELL_PATH_WEST; i++)
		{
			if cells_visited_list[grid_get_coord_1d(clamp(pointer_x + dcos(i * 90 - 90), 0, width - 1), clamp(pointer_y + dsin(i * 90 - 90), 0, height - 1), width)]
			{
				ds_list_add(neighbors, i);
			}
		}
		
		//If there are any unvisited cells next to the current cell, it chooses a random direction in the list of possible directions
		var next_cell_dir = ds_list_find_value(neighbors, irandom(ds_list_size(neighbors) - 1));
		
		//Carve a path from the current cell to the next one
		maze_set_path(maze_status, pointer_x, pointer_y, true, next_cell_dir);
		cells_visited_list[grid_get_coord_1d(pointer_x, pointer_y, width)] = true;
		ds_list_delete(coord_list, cell_choice);
		
		for (var i = CELL_PATH_NORTH; i <= CELL_PATH_WEST; i++)
		{
			var x_offset = dcos(i * 90 - 90);
			var y_offset = dsin(i * 90 - 90);
			if !cells_visited_list[grid_get_coord_1d(clamp(pointer_x + x_offset, 0, width - 1), clamp(pointer_y + y_offset, 0, height - 1), width)] && ds_list_find_index(coord_list, [pointer_x + x_offset, pointer_y + y_offset]) = -1
			{
				ds_list_add(coord_list, [pointer_x + x_offset, pointer_y + y_offset]);
			}
		}
		
		//Tell the program that another cell has been visited, so it knows when to stop when all the cells have been visited
		cells_visited++;
		
		ds_list_destroy(neighbors);
	}
	
	ds_list_destroy(coord_list);
	
	random_set_seed(seed_old);
	
	return maze_status;
}

function maze_create_hunt_and_kill(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	//Setting up the maze (a buffer that tells us the status of each cell)
	var maze_status = maze_create_blank(width, height);
	var cells_visited_list = array_create(width * height, false);

	var x_pos = irandom(width - 1);
	var y_pos = irandom(height - 1);
	
	var cells_clear = 0;
	
	//Marking the starting cell as visited
	cells_visited_list[grid_get_coord_1d(x_pos, y_pos, width)] = true;
	var cells_visited = 1;
	
	//Loops until the maze has been completed
	while cells_visited < width * height
	{
		//Sets up the list of possible directions that the algorithm can go
		var neighbors = ds_list_create();
		
		for (var i = CELL_PATH_NORTH; i <= CELL_PATH_WEST; i++)
		{
			if !cells_visited_list[grid_get_coord_1d(clamp(x_pos + dcos(i * 90 - 90), 0, width - 1), clamp(y_pos + dsin(i * 90 - 90), 0, height - 1), width)]
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
			maze_set_path(maze_status, x_pos, y_pos, true, next_cell_dir);
			
			//Change the current cell to the next one
			x_pos += x_offset;
			y_pos += y_offset;
		
			//Mark the new cell as visited
			cells_visited_list[grid_get_coord_1d(x_pos, y_pos, width)] = true;
		
			//Tell the program that another cell has been visited, so it knows when to stop when all the cells have been visited
			cells_visited++;
			
			ds_list_destroy(neighbors);
		}
		else
		{
			var hunt_pos = cells_clear;
			var currently_clear = true;
			
			while true
			{
				if !cells_visited_list[hunt_pos]
				{
					currently_clear = false;
					
					var neighbors = ds_list_create();
					for (var i = CELL_PATH_NORTH; i <= CELL_PATH_WEST; i++)
					{
						var x_offset = dcos(i * 90 - 90);
						var y_offset = dsin(i * 90 - 90);
						
						var x_search = clamp(hunt_pos % width + x_offset, 0, width - 1);
						var y_search = clamp(hunt_pos div width + y_offset, 0, height - 1);
						
						if cells_visited_list[grid_get_coord_1d(x_search, y_search, width)] ds_list_add(neighbors, i);
					}
					
					if !ds_list_empty(neighbors)
					{
						var connection_dir = ds_list_find_value(neighbors, irandom(ds_list_size(neighbors) - 1));
						var hunt_x = hunt_pos % width;
						var hunt_y = hunt_pos div width;
						maze_set_path(maze_status, hunt_x, hunt_y, true, connection_dir);
						x_pos = hunt_x;
						y_pos = hunt_y;
						
						cells_visited_list[hunt_pos] = true;
						cells_visited++;
						
						ds_list_destroy(neighbors);
						break;
					}
				}
				else if currently_clear
				{
					cells_clear++;
				}
				
				hunt_pos++;
			}
		}
	}
	
	random_set_seed(seed_old);
	
	return maze_status;
}

function maze_create_binary_tree(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	var maze_status = maze_create_blank(width, height);
	
	var current_cell = 0;
	
	while current_cell < width * height
	{
		var x_pos = current_cell % width;
		var y_pos = current_cell div width;
		
		if (irandom(1) || x_pos <= 0) && y_pos > 0
		{
			maze_set_path(maze_status, x_pos, y_pos, true, CELL_PATH_NORTH);
		}
		else if x_pos > 0
		{
			maze_set_path(maze_status, x_pos, y_pos, true, CELL_PATH_WEST);
		}
		
		current_cell++;
	}
	
	random_set_seed(seed_old);
	
	return maze_status;
}

function maze_create_sidewinder(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	var maze_status = maze_create_blank(width, height);
	
	var current_cell = 0;
	var run_set = ds_list_create();
	
	while current_cell < width * height
	{
		ds_list_add(run_set, current_cell);
		
		if (irandom(1) || current_cell < width) && current_cell % width < width - 1
		{
			var x_pos = current_cell % width
			var y_pos = current_cell div width;
			maze_set_path(maze_status, x_pos, y_pos, true, CELL_PATH_EAST);
		}
		else if current_cell >= width
		{
			var cell_choice = ds_list_find_value(run_set, irandom(ds_list_size(run_set) - 1));
			var x_pos = cell_choice % width;
			var y_pos = cell_choice div width;
			maze_set_path(maze_status, x_pos, y_pos, true, CELL_PATH_NORTH);
			ds_list_clear(run_set);
		}
		else
		{
			ds_list_clear(run_set);
		}
		
		current_cell++;
	}
	
	ds_list_destroy(run_set);
	
	random_set_seed(seed_old);
	return maze_status;
}

function maze_create_aldous_broder(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	//Setting up the maze (a buffer that tells us the status of each cell)
	var maze_status = maze_create_blank(width, height);
	var cells_visited_list = array_create(width * height, false);

	//Setting up the list of coordinates so the algorithm can backtrack
	var x_pos = irandom(width - 1);
	var y_pos = irandom(height - 1);

	//Marking the starting cell as visited
	cells_visited_list[grid_get_coord_1d(x_pos, y_pos, width)] = true;
	var cells_visited = 1;
	
	while cells_visited < width * height
	{
		var expansion_direction = irandom(CELL_PATH_WEST);
		var x_offset = dcos(expansion_direction * 90 - 90);
		var y_offset = dsin(expansion_direction * 90 - 90);
		
		var x_new = clamp(x_pos + x_offset, 0, width - 1);
		var y_new = clamp(y_pos + y_offset, 0, height - 1);
		
		if !cells_visited_list[grid_get_coord_1d(x_new, y_new, width)]
		{
			maze_set_path(maze_status, x_pos, y_pos, true, expansion_direction);
			cells_visited_list[grid_get_coord_1d(x_new, y_new, width)] = true;
			cells_visited++;
		}
		
		x_pos = x_new;
		y_pos = y_new;
	}
	
	random_set_seed(seed_old);
	return maze_status;
}

function maze_create_wilsons(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	//Setting up the maze (a buffer that tells us the status of each cell)
	var maze_status = maze_create_blank(width, height);
	var cells_visited_list = array_create(width * height, false);
	var cells_available = ds_list_create();
	
	var path_status;
	for (var i = 0; i < width * height; i++)
	{
		ds_list_add(cells_available, i);
		path_status[i] = -1;
	}
	
	var cell_start_visited = irandom(width * height - 1);
	cells_visited_list[cell_start_visited] = true;
	ds_list_delete(cells_available, cell_start_visited);
	
	var path_start_x = ds_list_find_value(cells_available, irandom(ds_list_size(cells_available) - 1)) % width;
	var path_start_y = ds_list_find_value(cells_available, irandom(ds_list_size(cells_available) - 1)) div width;
	var path_current_x = path_start_x;
	var path_current_y = path_start_y;
	
	while !ds_list_empty(cells_available)
	{
		if cells_visited_list[grid_get_coord_1d(path_current_x, path_current_y, width)]
		{
			var x_pos = path_start_x;
			var y_pos = path_start_y;
			
			while !cells_visited_list[grid_get_coord_1d(x_pos, y_pos, width)]
			{
				//Makes it so that the current cell in the path can not be the start of a new path
				ds_list_delete(cells_available, ds_list_find_index(cells_available, grid_get_coord_1d(x_pos, y_pos, width)));
			
				//Marks the cell as visited
				cells_visited_list[grid_get_coord_1d(x_pos, y_pos, width)] = true;
			
				//Carves a path between the current cell in the path and the next one
				var path_dir = path_status[grid_get_coord_1d(x_pos, y_pos, width)];
				var x_offset = dcos(path_dir * 90 - 90);
				var y_offset = dsin(path_dir * 90 - 90);
				
				maze_set_path(maze_status, x_pos, y_pos, true, path_dir);
			
				//Go to the next cell
				x_pos += x_offset;
				y_pos += y_offset;
			}
			
			//If the maze has not been finished, choose a cell to start the new path from
			if !ds_list_empty(cells_available)
			{
				var cell_start = irandom(ds_list_size(cells_available) - 1);
		
				path_start_x = ds_list_find_value(cells_available, cell_start) % maze_width;
				path_start_y = ds_list_find_value(cells_available, cell_start) div maze_width;
		
				path_current_x = path_start_x;
				path_current_y = path_start_y;
			}
		}
		
		var path_dir;
		var path_next_x = -1;
		var path_next_y = -1;
		
		while path_next_x != clamp(path_next_x, 0, width - 1) || path_next_y != clamp(path_next_y, 0, height - 1)
		{
			path_dir = irandom(CELL_PATH_WEST);
			path_next_x = path_current_x + dcos(path_dir * 90 - 90);
			path_next_y = path_current_y + dsin(path_dir * 90 - 90);
		}
		
		//Tell the path that the next cell is the choosen direction
		path_status[grid_get_coord_1d(path_current_x, path_current_y, width)] = path_dir;
		path_current_x = path_next_x;
		path_current_y = path_next_y;
	}
	
	ds_list_destroy(cells_available);
	
	random_set_seed(seed_old);
	return maze_status;
}

function maze_create_ellers(width, height, seed)
{
	var seed_old = random_get_seed();
	random_set_seed(seed);
	
	//Setting up the maze (a buffer that tells us the status of each cell)
	var maze_status = maze_create_blank(width, height);
	var sets_list;
	var sets_list_next;
	for (var i = 0; i < width; i++)
	{
		sets_list[i] = i;
		sets_list_next[i] = -1;
	}
	
	var x_pos = 0;
	var y_pos = 0;
	
	while grid_get_coord_1d(x_pos, y_pos, width) < width * height
	{
		if (irandom(1) || y_pos = height - 1) && x_pos < width - 1
		{
			if sets_list[x_pos] != sets_list[x_pos + 1]
			{
				var cell_current_set = sets_list[x_pos];
				var cell_next_set = sets_list[x_pos + 1];
				maze_set_path(maze_status, x_pos, y_pos, true, CELL_PATH_EAST);
				for (var i = 0; i < width && sets_list[i] = cell_next_set; i++)
				{
					sets_list[i] = cell_current_set;
				}
			}
		}
		else if x_pos >= width - 1 && y_pos < height - 1
		{
			
			var cells_not_added = ds_list_create();
			for (var i = 0; i < width; i++)
			{
				ds_list_add(cells_not_added, i);
			}
			
			var sets = [];
			
			var sets_count = 0;
			while !ds_list_empty(cells_not_added)
			{
				var set_current = sets_list[ds_list_find_value(cells_not_added, 0)];
				var set = ds_list_create();
				
				for (var i = 0; i < width; i++)
				{
					if sets_list[i] = set_current
					{
						ds_list_add(set, i);
						ds_list_delete(cells_not_added, ds_list_find_index(cells_not_added, i));
					}
				}
				
				sets[sets_count] = set;
				sets_count++;
			}
			
			for (var i = 0; i < array_length(sets); i++)
			{
				var connections_added = irandom_range(1, ds_list_size(sets[i]) - 2)
				for (var j = 0; j < connections_added; j++)
				{
					var cell_choice = irandom(ds_list_size(sets[i]) - 1);
					var cell_pos = ds_list_find_value(sets[i], cell_choice);
					maze_set_path(maze_status, cell_pos, y_pos, true, CELL_PATH_SOUTH);
					ds_list_delete(sets[i], ds_list_find_index(sets[i], cell_pos));
					sets_list_next[cell_pos] = sets_list[cell_pos];
				}
			}
			
			for (var i = 0; i < width && sets_list_next[i] = -1; i++)
			{
				sets_list_next[i] = grid_get_coord_1d(x_pos, y_pos + 1, width);
			}
			sets_list = sets_list_next;
			sets_list_next = array_create(width, -1);
		}
		
		x_pos++;
		if x_pos >= width y_pos++;
		x_pos = x_pos % width;
	}
	
	random_set_seed(seed_old);
	return maze_status;
}