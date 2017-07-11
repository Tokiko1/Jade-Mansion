/turf/open/outside
	icon = 'icons/turf/floors.dmi'
	icon_state = ""
	name = "\proper dirt"

	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	planetary_atmos = TRUE
//	light_power = 5
//	light_range = 3

/turf/open/outside/sand/
	icon = 'icons/turf/floors.dmi'
	icon_state = "outsidedirt"
	var/sand_type = /obj/item/weapon/ore/glass

/turf/open/outside/sand/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(!W || !user)
		return 0
	if (istype(W, /obj/item/weapon/shovel))
		to_chat(user, "<span class='notice'>You start digging...</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)

		if(do_after(user, 50, target = src))
			for(var/i in 1 to 5)
				new sand_type(src)

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