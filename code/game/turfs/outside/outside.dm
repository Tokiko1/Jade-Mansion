/turf/open/outside
	icon = 'icons/turf/floors.dmi'
	icon_state = "outsidedirt"
	name = "\proper dirt"

	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	planetary_atmos = TRUE
//	light_power = 5
//	light_range = 3


/*
/turf/open/outside/Initialize()
	var/proper_name = name
	..()
	name = proper_name
	if(prob(floor_variance))
		icon_state = "outsidedirt[rand(1,13)]"

/turf/open/upstairsoutside
*/

/turf/open/outside/roofing
	icon = 'icons/turf/jadefloors.dmi'
	icon_state = "jaderoof_south"
	name = "\proper rooftile"

/turf/open/outside/roofing/east
	icon_state = "jaderoof_east"

/turf/open/outside/roofing/west
	icon_state = "jaderoof_west"

/turf/open/outside/roofing/north
	icon_state = "jaderoof_north"

/turf/open/outside/roofing/tile
	icon_state = "jaderoof_tile"