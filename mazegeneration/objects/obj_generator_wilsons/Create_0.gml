randomize();

//A function to convert 2D array coordinates into 1D array coordinates
array_get_coord = function(x, y, width)
{
	return x + (y * width);
}

//Setting up the maze (an array of cells, where each cell is its own array that tells us whether there's a path facing North, East, South, West, and whether or not the path has been visited yet)
cell_size = 32;
maze_width = room_width div cell_size;
maze_height = room_height div cell_size;

//A list of all the cells that have not been visited, so the algorithm knows where it can start a new path
cells_available = ds_list_create();

for (var i = 0; i < maze_width * maze_height; i++)
{
	maze_status[i] = array_create(5, false);
	path_status[i] = -1;
	ds_list_add(cells_available, i);
}

//Marking the starting cell as visited
var cell_x = irandom(maze_width - 1);
var cell_y = irandom(maze_height - 1);
maze_status[array_get_coord(cell_x, cell_y, maze_width)][CELL_VISITED] = true;

ds_list_delete(cells_available, array_get_coord(cell_x, cell_y, maze_width));

//Setting up the path
path_start_x = ds_list_find_value(cells_available, irandom(ds_list_size(cells_available) - 1)) % maze_width;
path_start_y = ds_list_find_value(cells_available, irandom(ds_list_size(cells_available) - 1)) div maze_width;
path_current_x = path_start_x;
path_current_y = path_start_y;