randomize();

enum cell
{
	CELL_PATH_NORTH = 0,
	CELL_PATH_EAST = 1,
	CELL_PATH_SOUTH = 2,
	CELL_PATH_WEST = 3,
	CELL_VISITED = 4,
}

//A function to convert 2D array coordinates into 1D array coordinates
array_get_coord = function(x, y, width)
{
	return x + (y * width);
}

//Setting up the maze (an array of cells, where each cell is its own array that tells us whether there's a path facing North, East, South, West, and whether or not the path has been visited yet)
cell_size = 32;
maze_width = room_width / cell_size;
maze_height = room_height / cell_size;
maze_status = array_create(maze_width * maze_height, 0);
for (var i = 0; i < maze_width * maze_height; i++)
{
	maze_status[i] = array_create(5, false);
}

//Setting up the list of coordinates so the algorithm can backtrack
coord_list_x = ds_stack_create();
coord_list_y = ds_stack_create();
ds_stack_push(coord_list_x, irandom(maze_width - 1));
ds_stack_push(coord_list_y, irandom(maze_height - 1));

//Marking the starting cell as visited
maze_status[array_get_coord(ds_stack_top(coord_list_x), ds_stack_top(coord_list_y), maze_width)][cell.CELL_VISITED] = true;
cells_visited = 1;

//Sets up the delay between steps in the generation
delay = 0;