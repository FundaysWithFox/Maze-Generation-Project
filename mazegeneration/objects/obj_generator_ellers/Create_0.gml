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

x_pos = 0;
y_pos = 0;

sets_list = ds_list_create();
sets_list_next = ds_list_create();

row_lists = array_create(maze_width, 0);
row_lists_next = array_create(maze_width, -1);

for (var i = 0; i < maze_width; i++)
{
	row_lists[i] = i;
	var set_list = ds_list_create();
	ds_list_add(set_list, i);
	ds_list_add(sets_list, set_list);
	
	maze_status[i][CELL_VISITED] = true;
}