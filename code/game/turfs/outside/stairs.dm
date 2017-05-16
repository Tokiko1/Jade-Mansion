/turf/open/stairs
	icon = 'icons/turf/stairs.dmi'
	icon_state = ""
	name = "\proper stairs"

/turf/open/stairs/north
	icon_state = "stairs_north"
/turf/open/stairs/east
	icon_state = "stairs_east"
/turf/open/stairs/west
	icon_state = "stairs_west"
/turf/open/stairs/south
	icon_state = "stairs_south"

/turf/open/stairs/moving/
	icon_state = ""
	var/destination_x = 1
	var/destination_y = 1
	var/destination_z = 1
	var/shift_x = 0
	var/shift_y = 0
	var/shift_z = 0

/turf/open/stairs/moving/northup
	shift_y = 1
	shift_z = 1
	icon_state = "stairs_north_up"

/turf/open/stairs/moving/northdown
	shift_y = -1
	shift_z = -1
	icon_state = "stairs_north_down"

/turf/open/stairs/moving/eastup
	shift_x = 1
	shift_z = 1
	icon_state = "stairs_east_up"

/turf/open/stairs/moving/eastdown
	shift_x = -1
	shift_z = -1
	icon_state = "stairs_east_down"

/turf/open/stairs/moving/southup
	shift_y = -1
	shift_z = 1
	icon_state = "stairs_south_up"

/turf/open/stairs/moving/southdown
	shift_y = 1
	shift_z = -1
	icon_state = "stairs_south_down"

/turf/open/stairs/moving/westup
	shift_x = -1
	shift_z = 1
	icon_state = "stairs_west_up"

/turf/open/stairs/moving/westdown
	shift_x = 1
	shift_z = -1
	icon_state = "stairs_west_down"



/turf/open/stairs/moving/Initialize()
	..()
	destination_x = x + shift_x
	destination_y = y + shift_y
	destination_z = z + shift_z

/turf/open/stairs/moving/Entered(atom/movable/AM)
	START_PROCESSING(SSobj, src)
	climb(AM)

/turf/open/stairs/moving/process()
	if(!climb())
		STOP_PROCESSING(SSobj, src)

/turf/open/stairs/moving/proc/climb(AM)
	. = 0
	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		if(canclimb(thing))
			. = 1
			INVOKE_ASYNC(src, .proc/climbmove, thing)

/turf/open/stairs/moving/proc/canclimb(atom/movable/AM)
	if(!isliving(AM) && !isobj(AM))
		return 0
	return 1

/turf/open/stairs/moving/proc/climbmove(atom/movable/AM)
	//Make sure the item is still there after our sleep
	if(!AM || QDELETED(AM))
		return

	var/turf/T = locate(destination_x, destination_y, destination_z)
	if(T)
		AM.forceMove(T)