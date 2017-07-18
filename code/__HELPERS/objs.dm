

/obj/proc/adjust_spawning_pixels(shift_x, shift_y)
	if(pixel_y || pixel_x) //a mapper overrode this, abort
		return 0

	switch(dir)
		if(NORTH)
			pixel_y = shift_y
		if(EAST)
			pixel_x = shift_x
		if(SOUTH)
			pixel_y = -shift_y
		if(WEST)
			pixel_x = -shift_x