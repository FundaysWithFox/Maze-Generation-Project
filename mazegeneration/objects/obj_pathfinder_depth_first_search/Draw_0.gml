var dot_x = x_pos_start;
var dot_y = y_pos_start;

for (var i = 0; i <= ds_list_size(path_list); i++)
{	
	draw_set_color(c_red);//make_color_hsv(lerp(0, 255, i / ds_list_size(path_list)), 255, 255));
	draw_circle(dot_x * cell_size + (cell_size / 2) - 1, dot_y * cell_size + (cell_size / 2) - 1, line_width / 2, false);
	
	if i < ds_list_size(path_list)
	{
		var x_offset = dcos(ds_list_find_value(path_list, i) * 90 - 90);
		var y_offset = dsin(ds_list_find_value(path_list, i) * 90 - 90);
		draw_line_width(dot_x * cell_size + (cell_size / 2) - 1, dot_y * cell_size + (cell_size / 2) - 1, (dot_x + x_offset) * cell_size + (cell_size / 2) - 1, (dot_y + y_offset) * cell_size + (cell_size / 2) - 1, line_width);
		dot_x += x_offset;
		dot_y += y_offset;
		draw_circle(dot_x * cell_size + (cell_size / 2) - 1, dot_y * cell_size + (cell_size / 2) - 1, line_width / 2, false);
	}
}

/*var txt = "";
for (var i = 0; i < ds_list_size(path_list); i++)
{
	txt += string(ds_list_find_value(path_list, i)) + " ";
}

draw_set_color(c_black);
draw_text(20, 20, txt);