/turf/open/hole
	icon = 'icons/turf/openspace.dmi'
	icon_state = "downwards"
	var/initial_icon = "downwards"
	name = "hole"
	desc = "Watch your step!"
	z_open = 1
	var/drop_x = 1
	var/drop_y = 1
	var/drop_z = 1
	var/downstairshine = 1 //does this cause a downstair shine effect?
	var/turf/destinationT



/turf/open/hole/Entered(atom/movable/AM)
	START_PROCESSING(SSobj, src)
	drop_stuff(AM)

/turf/open/hole/process()
	if(!drop_stuff())
		STOP_PROCESSING(SSobj, src)


/turf/open/hole/proc/drop_stuff(AM)
	if(AM)
		if(droppable(AM))
			drop(AM)

/turf/open/hole/proc/droppable(atom/movable/AM)
	if(!isliving(AM) && !isobj(AM))
		return 0
	if(istype(AM, /obj/item/projectile) || AM.throwing)
		return 0
	if(AM.anchored)
		//anchored objects shouldn't fall down
		return 0

	if(istype(AM, /obj/effect/portal))
		//Portals aren't affected by gravity. Probably.
		return 0
	//Flies right over the chasm
	if(isliving(AM))
		var/mob/MM = AM
		if(MM.movement_type & FLYING)
			return 0
	return 1

/turf/open/hole/proc/drop(atom/movable/AM)
	//Make sure the item is still there after our sleep
	if(!AM || QDELETED(AM))
		return

	if(destinationT)
		AM.visible_message("<span class='boldwarning'>[AM] falls into [src]!</span>", "<span class='userdanger'>You fall down a floor!</span>")
		destinationT.visible_message("<span class='boldwarning'>[AM] falls from above!</span>")
		AM.forceMove(destinationT)
		if(isliving(AM))
			var/mob/living/L = AM
			L.Weaken(5)


/turf/open/hole/Initialize()
	..()
	drop_x = x
	drop_y = y
	if(z > 1)
		drop_z = z-1
	destinationT = locate(drop_x, drop_y, drop_z)
	if(istype(destinationT, /turf/open/hole))
		icon_state = "[initial_icon]2"
	if(downstairshine)
		if(!destinationT.density)
			new /obj/effect/upstairshine(destinationT)

/turf/open/hole/can_have_cabling()
	return 0

/turf/open/hole/outside
	icon_state = "outsidedownwards"
	initial_icon = "outsidedownwards"
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	planetary_atmos = TRUE
	downstairshine = 0