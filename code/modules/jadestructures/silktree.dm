/obj/structure/silktree/web
	icon = 'icons/effects/effects.dmi'
	icon_state = "stickyweb1"
	anchored = 1
	obj_integrity = 15
	density = 0
	name = "giant cobweb"
	desc = "It's stringy and sticky, you'll probably get stuck if you try to move past."
	messy_thing = 1

/obj/structure/silktree/web/Initialize()
	if(prob(50))
		icon_state = "stickyweb2"
	for(var/atom/movable/victim in get_turf(src))
		if(isliving(victim))
			entangle(victim)
	. = ..()

/obj/structure/silktree/web/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/feather_duster))
		if(do_after(user, 10, target = src))
			to_chat(user, "<span class='danger'>You easily remove the [src] with your [I].</span>")
			Destroy()
	..()



/obj/structure/silktree/web/Destroy()
	if(has_buckled_mobs())
		unbuckle_all_mobs(force=1)
	..()

/obj/structure/silktree/web/Crossed(atom/movable/mover)
	if(istype(mover, /mob/living/simple_animal)) //animals can pass
		return
	else if(isliving(mover))
		if(prob(40))
			entangle(mover)
			return
	..()

/obj/structure/silktree/web/proc/entangle(mob/living/V)
	if(!V)
		return
	if((V.buckled != src))
		to_chat(V, "<span class='danger'>You get stuck in the web!</span>")
		V.Weaken(2)
		buckle_mob(V, 1)

/obj/structure/silktree/web/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M == user)
			M.visible_message(\
			"<span class='warning'>[M.name] struggles to break free from the [src]!</span>",\
			"<span class='notice'>You struggle to break free from the [src](Stay still for 12 seconds.)</span>",\
			"<span class='italics'>You hear some sticky noise.</span>")
			if(!do_after(M, 120, target = src))
				if(M && M.buckled)
					to_chat(M, "<span class='warning'>You fail to free yourself!</span>")
				return
		src.visible_message(text("<span class='danger'>[M] escapes the [src]!</span>"))
		unbuckle_mob(M,force=1)

// the silk tree

/obj/structure/silktree/tree
	icon = 'icons/obj/flora/silktrees.dmi' //TODO:make a sprite
	icon_state = "silktree_large"
	anchored = 1
	obj_integrity = 50
	density = 1
	name = "silk tree"
	desc = "A tree that grows silk... a bit too fast it seems."

#define SILK_TARGET_REFRESH_RATE 15
#define SILK_PROCESS_RATE 1
#define SILK_SPREAD_DELAY 5

	var/pcounter = 0
	var/fcounter = 0
	var/scounter = 0
	var/rcounter = 0
	var/spread_frequency = 3
	var/can_plant_trees = 1
	var/tree_payloads = 3
	var/rstop = 0
	var/list/target_list = list()
	var/list/tree_target_list = list()

/obj/structure/silktree/tree/New()
	START_PROCESSING(SSobj, src)
	GLOB.silktree_list |= src
	..()

/obj/structure/silktree/tree/Destroy()
	GLOB.silktree_list -= src
	..()



/obj/structure/silktree/tree/process()
	if(pcounter > SILK_PROCESS_RATE)
		if(!target_list.len && !rstop)
			refresh_targets()
		if(target_list.len)
			if(fcounter > spread_frequency)
				var/turf/open/targetted_turf = pick(target_list)
				fire_at_target(targetted_turf)
				fcounter = 0
				refresh_targets()

		if(scounter > 5 && can_plant_trees) //it's time to spread!
			if(tree_payloads > 0)
				pick_tree_target()
				if(tree_target_list.len)
					var/turf/open/targetted_turfd = pick(tree_target_list)
					if(targetted_turfd)
						fire_at_target(targetted_turfd, payloadtype = "tree")
						tree_payloads--
			scounter = 0
		if(rstop)
			scounter++
			if(rcounter > SILK_TARGET_REFRESH_RATE)
				rstop = 0
				rcounter = 0
			else
				rcounter++
		if(prob(7))
			scounter++
		pcounter = 0
	pcounter++
	fcounter++



/obj/structure/silktree/tree/proc/refresh_targets()
	target_list = list()
	for(var/turf/open/turfA in orange(7, src))
		if((!locate(/obj/structure/silktree/web) in turfA) && !turfA.z_open && !turfA.density)
			target_list |= turfA
	if(!target_list.len)
		rstop = 1 //no valid targets left, let's stop searching for targets for a while

/obj/structure/silktree/tree/proc/pick_tree_target()
	tree_target_list = list()
	for(var/turf/open/turfA in range(7, src))
		if(!turfA.z_open && (!locate(/obj/structure/silktree/tree) in turfA) && !turfA.density)
			tree_target_list |= turfA


/obj/structure/silktree/tree/proc/fire_at_target(var/turf/open/targetted_turf, var/payloadtype = "normal")
	switch(payloadtype)
		if("normal")
			visible_message("<span class='warning'>A bunch of silklike roots grow out of the floor into a large cobweb!</span>")
			new /obj/structure/silktree/web(targetted_turf)
			playsound(targetted_turf, 'sound/effects/attackblob.ogg' , 100, 1)
			if(prob(30))
				for(var/turf/open/turfA in orange(1, targetted_turf))
					if((!locate(/obj/structure/silktree/web) in turfA) && !turfA.z_open && !turfA.density)
						new /obj/structure/silktree/web(turfA)

			return
		if("tree")
			visible_message("<span class='warning'>A tree emerges from the floor!</span>")
			new /obj/structure/silktree/tree/smalltree(targetted_turf)



/obj/structure/silktree/tree/smalltree

	can_plant_trees = 0
	tree_payloads = 0
	icon_state = "silktree"

/obj/structure/silktree/tree/nestree
	obj_integrity = 300
	density = 1
	name = "sturdy silk tree"
	desc = "A tree that grows silk... a bit too fast it seems."
	tree_payloads = 10

#undef SILK_TARGET_REFRESH_RATE
#undef SILK_PROCESS_RATE
#undef SILK_SPREAD_DELAY