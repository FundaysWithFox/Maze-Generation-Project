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
maze_status = array_create(maze_width * maze_height, 0);
for (var i = 0; i < maze_width * maze_height; i++)
{
	maze_status[i] = array_create(5, false);
}

//Setting up the coordinates for the pointer
x_pos = irandom(maze_width - 1);
y_pos = irandom(maze_height - 1);

//Marking the starting cell as visited
maze_status[array_get_coord(x_pos, y_pos, maze_width)][CELL_VISITED] = true;
cells_visited = 1;