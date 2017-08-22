 //if you want to crush something, especially mobs, without the violence and gore
 //don't spawn this object in, just use the Flatten() proc below on the thing


/obj/item/flat
	name = "flat ERROR"
	flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	var/time_to_normalize = 50
	var/timed_unflat = 0

/obj/item/flat/proc/SetupFlat(atom/movable/AM, causing_attack, scale_x = 1.5, scale_y = 0.5, ftime_override, autounflat)
	if(!AM)
		qdel(src)
		return

	if(ismob(AM))
		var/mob/M = AM
		M.Stun(1)
		M.drop_all_held_items()
		M.unset_machine()
		if(M.pulling)
			M.stop_pulling()

	sleep(1)
	if(!src || !AM)
		return

	AM.loc = src
	src.visible_message("<span class='warning'>[AM] is crushed flat[causing_attack ? " by [causing_attack]" : ""]!</span>")
	appearance = AM.appearance
	var/matrix/ntransform = matrix(transform)
	ntransform.Scale(scale_x, scale_y)

	animate(src, transform = ntransform, time = 3, pixel_y = -6, dir = AM.dir, easing = EASE_IN|EASE_OUT)
	name = "flattened [AM.name]"
	desc = "[AM.desc]"
	if(ftime_override)
		time_to_normalize = ftime_override
	if(autounflat)
		timed_unflat = 1
		addtimer(CALLBACK(src, .proc/UnFlat), time_to_normalize)


/obj/item/flat/proc/UnFlat()
	animate(src, transform = null, pixel_y = 0, time = 3, easing = EASE_IN|EASE_OUT)
	sleep(3)

	if(!src)
		return

	src.visible_message("<span class='warning'>[src] goes back to normal!</span>")

	var/turf/leaveturf = get_turf(src)
	for(var/atom/movable/AM in src)
		AM.dir = src.dir
		AM.loc = leaveturf
		if(ismob(AM))
			var/mob/M = AM
			M.reset_perspective(null)

	qdel(src)

/obj/item/flat/container_resist(mob/living/user)
	if(timed_unflat)
		return
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, "<span class='notice'>You start going back to normal.</span>")
	if(do_after(user,(time_to_normalize), target = src))
		if(!user || !src || user.stat != CONSCIOUS || user.loc != src || user.restrained())
			return
		UnFlat()

/obj/item/flat/attack_self(mob/user)
	if(timed_unflat)
		return
	to_chat(user, "<span class='notice'>You start to stretch out [src].</span>")
	if(do_after(user,(time_to_normalize), target = src, progress = 0))
		if(!user || !src || user.stat != CONSCIOUS || user.restrained())
			return
		UnFlat()
	else
		to_chat(user, "<span class='warning'>You let go of [src].</span>")

/obj/item/flat/Destroy()
	if(contents && contents.len)
		var/turf/leaveturf = get_turf(src)
		for(var/atom/movable/AM in src)
			AM.loc = leaveturf
			if(ismob(AM))
				var/mob/M = AM
				M.reset_perspective(null)
	..()

/atom/movable/proc/Flatten(flat_source, scalex = 1.5, scaley = 0.5, f_override, autounflating)
	var/obj/item/flat/flatS = new(get_turf(src))
	flatS.SetupFlat(src, flat_source, scalex, scaley, f_override, autounflating)