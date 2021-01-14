randomize();

//A function to convert 2D array coordinates into 1D array coordinates
array_get_coord = function(x, y, width)
{
	return x + (y * width);
}

//Setting up the maze (an array of cells, where each cell is its own array that tells us whether there's a path facing North, East, South, West, and whether or not the path has been visited yet)
cell_size = 64;
maze_width = room_width div cell_size;
maze_height = room_height div cell_size;
maze_status = array_create(maze_width * maze_height, 0);
for (var i = 0; i < maze_width * maze_height; i++)
{
	maze_status[i] = array_create(5, false);
}

//Creates the list of the current path
path_list = ds_list_create();
ds_list_add(path_list, [irandom(maze_width - 1), irandom(maze_height - 1), 0, 0, 0]);
cell_current = 0;

//Marking the starting cell as visited
maze_status[array_get_coord(irandom(maze_width - 1), irandom(maze_height - 1), maze_width)][CELL_VISITED] = true;
cells_visited = 1;