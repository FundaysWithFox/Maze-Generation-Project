randomize();

width = room_width div 32;
height = room_height div 32;

//Setting up the maze (a buffer that tells us the status of each cell)
maze_status = maze_create_blank(width, height);

for (var i = 0; i < width; i++)
{
	sets_list[i] = i;
	sets_list_next[i] = -1;
}

x_pos = 0;
y_pos = 0;