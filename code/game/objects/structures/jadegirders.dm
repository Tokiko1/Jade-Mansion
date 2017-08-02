////////////////////////////////////////////////////
//special, unbreakable girders for "permanent" turfs
//they cannot be moved or fully destroyed
//depending on the setting, you may or may not be able to move through them at certain damage levels


/obj/structure/jadegirder
	name = "girder"
	icon = 'icons/obj/jade_girders.dmi'
	icon_state = "jgirder"
	var/list/debris_icons = list("stone_debris1","stone_debris2","stone_debris3", "stone_debris4", "stone_debris5")
	anchored = 1
	density = 1
	layer = BELOW_OBJ_LAYER
	var/state = JADE_GIRDER_NORMAL
	var/girderpasschance = 20 // percentage chance that a projectile passes through the girder.

	var/disassembly_tool = /obj/item/weapon/crowbar
	var/repair_tool = /obj/item/weapon/wrench
	var/debris_clearing_tool = /obj/item/weapon/shovel
	var/girder_stack_amount = 2
	var/girder_stack_type = /obj/item/stack/sheet/metal //what kind of stack is used to repair the girder, if null, girders can be repaired for free, but also don't drop any stacks on deconstruction
	var/girder_finish_type = /obj/item/stack/sheet/metal //the type of stack used to finish the wall, ie so you can have metal girders inside a wooden wall
	var/girder_turf_path = /turf/closed/wall //type of turf that the fully constructed girder turns into

	var/density_broken = 1 //density and opacity of the states
	var/density_hole = 0
	var/opacity_broken = 0
	var/opacity_hole = 0
	var/density_broken_debris = 1 //okay okay, these should be a list but it's not like there will be thousands of these, ok?
	var/opacity_broken_debris = 0
	var/density_hole_debris = 1
	var/opacity_hole_debris = 0

	var/list/debris = list(/obj/item/debris/stonemetal, /obj/item/debris/stone)
	var/debris_amount_min = 2//how many debris items are created
	var/debris_amount_max = 5

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	obj_integrity = 200
	max_integrity = 200

/obj/structure/jadegirder/proc/state_update()
	if(state == JADE_GIRDER_NORMAL)
		icon_state = initial(icon_state)

	else
		icon_state = "[initial(icon_state)]-[state]"

	if(state == JADE_GIRDER_NORMAL || state == JADE_GIRDER_BROKEN_STACK) //structurally intact
		density = initial(density)
		opacity = initial(opacity)

	cut_overlays()

	if(state == JADE_GIRDER_BROKEN_DEBRIS|| state == JADE_GIRDER_HOLE_DEBRIS)
		var/picked_debris_icon = pick(debris_icons)
		add_overlay(picked_debris_icon)

	if(state == JADE_GIRDER_BROKEN || state == JADE_GIRDER_HOLE_STACK) //structurally broken,
		density = density_broken
		opacity = opacity_broken
	else if (state == JADE_GIRDER_HOLE) //girder with a hole
		density = density_hole
		opacity = opacity_hole
	else if(state == JADE_GIRDER_BROKEN_DEBRIS)
		density = density_broken_debris
		opacity = opacity_broken_debris
	else if(state == JADE_GIRDER_HOLE_DEBRIS)
		density = density_hole_debris
		opacity = opacity_hole_debris

/obj/structure/jadegirder/proc/handle_damage()
	//TODO: Add some sort of damage handling here, ie hit a girder enough to break a hole in it, circumventing the need for a tool
	return

/obj/structure/jadegirder/proc/adjust_state(input_state) //completely optional helper proc
	if(!input_state)
		return 0
	state = input_state
	state_update()
	return 1

/obj/structure/jadegirder/proc/remove_debris(removal_method, mob/user, obj/item/W)
	if(state == JADE_GIRDER_BROKEN_DEBRIS)
		state = JADE_GIRDER_BROKEN
		state_update()
	else if(state == JADE_GIRDER_HOLE_DEBRIS)
		state = JADE_GIRDER_HOLE
		state_update()

	if(removal_method == DEBRIS_TOOL_REMOVAL)
		var/turf/debris_target = get_turf(user)
		var/amount_of_debris = rand(debris_amount_min, debris_amount_max)
		if(debris_target && amount_of_debris)
			for(var/i in 1 to amount_of_debris)
				var/debristospawn = pick(debris)
				new debristospawn(debris_target)

	else if(removal_method == DEBRIS_KNOCKED_LOOSE)
		var/amount_of_debris = rand(debris_amount_min, debris_amount_max)
		if(amount_of_debris)
			for(var/i in 1 to amount_of_debris)
				var/debris_path = pick(debris)
				var/obj/item/debris/DS = new debris_path(src)
				if(prob(20)) //OW!
					DS.throw_at(user, 10, 10) // OW OW

	else if(removal_method == DEBRIS_BLASTED)
		var/list/turfs_to_target = circlerangeturfs(center=src,radius=4)
		var/amount_of_debris = rand(debris_amount_min,debris_amount_max)
		for(var/i in 1 to amount_of_debris)
			var/debris_path = pick(debris)
			var/obj/item/debris/DS = new debris_path(src)
			DS.throw_at(pick(turfs_to_target), 10, 10)


/obj/structure/jadegirder/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if(state == JADE_GIRDER_BROKEN_DEBRIS || state == JADE_GIRDER_HOLE_DEBRIS) //don't damage the girder, try to knock the debris loose instead
		if(prob(damage_amount)) //you can probably make this nicer later on
			remove_debris(DEBRIS_KNOCKED_LOOSE)
	..()
	obj_integrity = max(obj_integrity, 1)
	handle_damage()


/obj/structure/jadegirder/deconstruct(disassembled = TRUE)
	return

/obj/structure/jadegirder/obj_break(damage_flag)
	return

/obj/structure/jadegirder/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	//////////////////////////DISASSEMBLY//////////////////////////

	if(istype(W, disassembly_tool))
		if(state == JADE_GIRDER_NORMAL)
			playsound(src.loc, W.usesound, 100, 1)
			user.visible_message("<span class='warning'>[user] starts disassembling the girder.</span>", \
								"<span class='notice'>You start to disassemble the girder...</span>", "You hear clanking and banging noises.")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_NORMAL)
					return
				state = JADE_GIRDER_BROKEN_STACK
				to_chat(user, "<span class='notice'>You disassemble the girder.</span>")
				state_update()
				return

		else if(state == JADE_GIRDER_BROKEN_STACK)
			playsound(src.loc, W.usesound, 100, 1)
			user.visible_message("<span class='warning'>[user] starts removing some material from the girder.</span>", \
								"<span class='notice'>You start to remove material from the girder...</span>", "You hear clanking and banging noises.")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_BROKEN_STACK)
					return
				state = JADE_GIRDER_BROKEN
				to_chat(user, "<span class='notice'>You successfully remove materials from the girder.</span>")
				if(girder_stack_type)
					var/obj/item/stack/M = new girder_stack_type(loc, girder_stack_amount)
					M.add_fingerprint(user)
				state_update()
				return

		else if(state == JADE_GIRDER_BROKEN)
			playsound(src.loc, W.usesound, 100, 1)
			user.visible_message("<span class='warning'>[user] starts breaking the girder apart.</span>", \
								"<span class='notice'>You start to break the girder apart...</span>", "You hear clanking and banging noises.")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_BROKEN)
					return
				state = JADE_GIRDER_HOLE_STACK
				to_chat(user, "<span class='notice'>You break the girder apart.</span>")
				state_update()
				return

		else if(state == JADE_GIRDER_HOLE_STACK)
			playsound(src.loc, W.usesound, 100, 1)
			user.visible_message("<span class='warning'>[user] starts breaking the girder apart.</span>", \
								"<span class='notice'>You start to break the girder apart...</span>", "You hear clanking and banging noises.")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_HOLE_STACK)
					return
				state = JADE_GIRDER_HOLE
				to_chat(user, "<span class='notice'>You break the girder apart.</span>")
				if(girder_stack_type)
					var/obj/item/stack/M = new girder_stack_type(loc, girder_stack_amount)
					M.add_fingerprint(user)
				state_update()
				return

		else if(state == JADE_GIRDER_HOLE)
			to_chat(user, "<span class='notice'>The girder cannot be disassembled any further.</span>")
			return
		else if(state == JADE_GIRDER_BROKEN_DEBRIS || state == JADE_GIRDER_HOLE_DEBRIS)
			to_chat(user, "<span class='notice'>You cannot disassemble the girder, there is debris everywhere.</span>")
			return

	//////////////////////////////////////////////////////////
	///// REPAIRS ///////////////////////////////////////////

	if(istype(W, repair_tool))
		if(state == JADE_GIRDER_NORMAL) //only gets called if stacks repairs are disabled, repairs the wall fully!
			if(girder_stack_type)
				to_chat(user, "<span class='notice'>The girder requires some materials to repair it further.</span>")
				return

			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the added material...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_NORMAL)
					return
				to_chat(user, "<span class='notice'>You successfully repair the wall.</span>")
				var/turf/T = get_turf(src)
				T.ChangeTurf(girder_turf_path)
				qdel(src)
				return

		else if(state == JADE_GIRDER_BROKEN_STACK)
			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the added material...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_BROKEN_STACK)
					return
				to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
				state = JADE_GIRDER_NORMAL
				state_update()
				return

		else if (state == JADE_GIRDER_BROKEN)
			if(girder_stack_type)
				to_chat(user, "<span class='notice'>The girder requires some materials to repair it further.</span>")
				return

			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the detached materials...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_BROKEN)
					return
				to_chat(user, "<span class='notice'>You successfully reconnect the materials to the girder.</span>")
				state = JADE_GIRDER_BROKEN_STACK
				state_update()
				return

		else if(state == JADE_GIRDER_HOLE_STACK)
			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the added material...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_HOLE_STACK)
					return
				to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
				state = JADE_GIRDER_BROKEN
				state_update()
				return
		else if(state == JADE_GIRDER_HOLE && !girder_stack_type) //only gets called if stacks repairs are disabled
			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the added material...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_HOLE)
					return
				to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
				state = JADE_GIRDER_HOLE_STACK
				state_update()
				return

		else if(state == JADE_GIRDER_BROKEN_DEBRIS || state == JADE_GIRDER_HOLE_DEBRIS)
			to_chat(user, "<span class='notice'>You cannot repair the girder, there is debris everywhere.</span>")
			return

/////////////STACK REPAIRS //////////////////

	if((girder_stack_type || girder_finish_type) && girder_stack_amount)
		if(istype(W, girder_stack_type) || istype(W, girder_finish_type))
			var/obj/item/stack/sheet/S = W
			if(S.amount < girder_stack_amount)
				to_chat(user, "<span class='notice'>You need atleast [girder_stack_amount] of [S.name] to carry out repairs on this girder.</span>")
				return

			if(state == JADE_GIRDER_NORMAL && istype(W, girder_finish_type)) // wall gets fully restored here
				to_chat(user, "<span class='notice'>You start finishing the wall...</span>")
				if(do_after(user, 40, target = src))
					if(state != JADE_GIRDER_NORMAL && S.amount < girder_stack_amount)
						return
					S.use(girder_stack_amount)
					to_chat(user, "<span class='notice'>You successfully repair the wall.</span>")
					var/turf/T = get_turf(src)
					T.ChangeTurf(girder_turf_path)
					qdel(src)
					return

			else if(state == JADE_GIRDER_BROKEN && istype(W, girder_stack_type))
				to_chat(user, "<span class='notice'>You start finishing the wall...</span>")
				if(do_after(user, 40, target = src))
					if(state != JADE_GIRDER_BROKEN && S.amount < girder_stack_amount)
						return
					S.use(girder_stack_amount)
					to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
					state = JADE_GIRDER_BROKEN_STACK
					state_update()
					return

			else if(state == JADE_GIRDER_HOLE && istype(W, girder_stack_type))
				to_chat(user, "<span class='notice'>You start finishing the wall...</span>")
				if(do_after(user, 40, target = src))
					if(state != JADE_GIRDER_HOLE && S.amount < girder_stack_amount)
						return
					S.use(girder_stack_amount)
					to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
					state = JADE_GIRDER_HOLE_STACK
					state_update()
					return

			else if(state == JADE_GIRDER_BROKEN_DEBRIS || state == JADE_GIRDER_HOLE_DEBRIS)
				to_chat(user, "<span class='notice'>You cannot repair the girder, there is debris everywhere.</span>")
				return

/////////REMOVING DEBRIS/////////////////////////////////

	if(istype(W, debris_clearing_tool))
		if(state == JADE_GIRDER_BROKEN_DEBRIS)
			playsound(src.loc, W.usesound, 100, 1)
			user.visible_message("<span class='warning'>[user] starts removing the debris.</span>", \
								"<span class='notice'>You start to remove the debris...</span>", "You hear clanking and banging noises.")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_BROKEN_DEBRIS)
					return
				state = JADE_GIRDER_BROKEN
				to_chat(user, "<span class='notice'>You remove the debris.</span>")
				remove_debris(DEBRIS_TOOL_REMOVAL , user, W)
				state_update()
				return
		else if(state == JADE_GIRDER_HOLE_DEBRIS)
			playsound(src.loc, W.usesound, 100, 1)
			user.visible_message("<span class='warning'>[user] starts removing the debris.</span>", \
								"<span class='notice'>You start to remove the debris...</span>", "You hear clanking and banging noises.")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_HOLE_DEBRIS)
					return
				state = JADE_GIRDER_HOLE
				to_chat(user, "<span class='notice'>You remove the debris.</span>")
				remove_debris(DEBRIS_TOOL_REMOVAL , user, W)
				state_update()
				return






////////////////////////////////////////////////////////

	if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			if(!user.drop_item())
				return
			P.loc = src.loc
			to_chat(user, "<span class='notice'>You fit the pipe into \the [src].</span>")
			return


	return ..()

///////////////////////////////////////////////////////

/obj/structure/jadegirder/CanPass(atom/movable/mover, turf/target, height=0)
	if(density==0)
		return 1
	if(height==0)
		return 1
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return prob(girderpasschance)
	else
		if(istype(mover, /obj/item/projectile))
			return prob(girderpasschance)
		else
			return 0

/obj/structure/jadegirder/CanAStarPass(ID, dir, caller)
	. = !density
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		. = . || mover.checkpass(PASSGRILLE)

/obj/structure/jadegirder/deconstruct(disassembled = TRUE)
	return

/obj/structure/jadegirder/ex_act(severity, target)
	..() //contents explosion
	if(target == src)
		take_damage(rand(100, 250), BRUTE, "bomb", 0)
		return
	switch(severity)
		if(1)
			take_damage(rand(100, 250), BRUTE, "bomb", 0)
		if(2)
			take_damage(rand(100, 250), BRUTE, "bomb", 0)
		if(3)
			take_damage(rand(10, 90), BRUTE, "bomb", 0)