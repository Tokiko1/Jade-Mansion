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
	var/turf/destinationT

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
	destinationT = locate(destination_x, destination_y, destination_z)

/turf/open/stairs/moving/Entered(atom/movable/AM)
	climb(AM)

/turf/open/stairs/moving/proc/climb(AM)
	if(!isliving(AM) && !isobj(AM))
		return
	var/list/stufftomove = list()
	stufftomove.Add(AM)
	//handling pulled stuff
	var/mob/AMOB
	var/atom/movable/pulled_thing
	if(istype(AM, /mob)) //only mobs can pull
		AMOB = AM
		if(AMOB.pulling && !AMOB.pulling.anchored)
			pulled_thing = AMOB.pulling
			stufftomove.Add(AMOB.pulling)

	for(var/atom/movable/AMmove in stufftomove)
		climbmove(AMmove)

	if(AMOB && pulled_thing && AMOB.pulling != pulled_thing) //oops, we lost our pulled thing, let's reattach it
		AMOB.pulling = pulled_thing


/turf/open/stairs/moving/proc/canclimb(atom/movable/AM)
	if(!isliving(AM) && !isobj(AM))
		return 0
	return 1

/turf/open/stairs/moving/proc/climbmove(atom/movable/AM)
	if(destinationT)
		AM.forceMove(destinationT)
