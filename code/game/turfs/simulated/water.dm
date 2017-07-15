/turf/open/water
	name = "water"
	desc = "Shallow water."
	icon = 'icons/turf/floors.dmi'
	icon_state = "riverwater"
	slowdown = 1
	wet = TURF_WET_WATER

/turf/open/water/HandleWet()
	if(wet == TURF_WET_WATER)
		return
	..()
	MakeSlippery(TURF_WET_WATER) //rewet after ..() clears out lube/ice etc.

/turf/open/water/Entered(atom/movable/L)
	..()
	if(istype(L, /mob/living))
		var/mob/living/wet_L = L
		wet_L.fire_stacks = -20