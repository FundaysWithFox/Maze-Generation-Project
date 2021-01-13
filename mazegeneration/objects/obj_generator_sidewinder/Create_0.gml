randomize();

//A function to convert 2D array coordinates into 1D array coordinates
array_get_coord = function(x, y, width)
{
	return x + (y * width);
}

//Sets up the maze (an array of cells, where each cell is its own array that tells us whether there's a path facing North, East, South, West, and whether or not the path has been visited yet)
cell_size = 32;
maze_width = room_width div cell_size;
maze_height = room_height div cell_size;
maze_status = array_create(maze_width * maze_height, 0);
for (var i = 0; i < maze_width * maze_height; i++)
{
	maze_status[i] = array_create(5, false);
}

//Sets up the coordinates of the current cell
x_pos = 0;
y_pos = 0;

//Marks the first cell as visited
maze_status[0][cell.CELL_VISITED] = true;
cells_visited = 0;

//Sets the run set to empty
run_set = ds_list_create();