////////////////////////////////////////////////////
//special, unbreakable girders for "permanent" turfs
//they cannot be moved or fully destroyed
//depending on the setting, you may or may not be able to move through them at certain damage levels


/obj/structure/jadegirder
	name = "girder"
	icon_state = "jgirder"
	anchored = 1
	density = 1
	layer = BELOW_OBJ_LAYER
	var/state = JADE_GIRDER_NORMAL
	var/girderpasschance = 20 // percentage chance that a projectile passes through the girder.
	var/can_displace = FALSE //If the girder can be moved around by wrenching it

	var/disassembly_tool = /obj/item/weapon/wrench
	var/repair_tool = /obj/item/weapon/wrench
	var/rubble_clearing_tool = /obj/item/weapon/shovel
	var/girder_stack_amount = 2
	var/girder_stack_type = /obj/item/stack/sheet/metal //what kind of stack is used to repair the girder, if null, girders can be repaired for free, but also don't drop any stacks on deconstruction
	var/girder_turf_path //type of turf that the fully constructed girder turns into

	var/density_broken = 1 //density and opacity of the states
	var/density_hole = 0
	var/opacity_broken = 0
	var/opacity_hole = 0



	obj_integrity = 200
	max_integrity = 200

/obj/structure/jadegirder/proc/state_update()
	if(state == JADE_GIRDER_NORMAL)
		icon_state = initial(icon_state)

	else
		icon_state = "[initial(icon_state)]-[state]"

	if(state == JADE_GIRDER_NORMAL || state == JADE_GIRDER_BROKEN_STACK) //structurally intact, includes broken girder that had its stack applied to it
		density = initial(denisty)
		opacity = initial(opacity)

	if(state == JADE_GIRDER_BROKEN || state == JADE_GIRDER_HOLE_STACK || state == JADE_GIRDER_BROKEN_DEBRIS) //structurally broken, includes girders with a hole that had a stack applied to fix the hole
			density = density_broken
			opacity = opacity_broken
		else if (state == JADE_GIRDER_HOLE || state == JADE_GIRDER_HOLE_DEBRIS) //girder with a hole
			density = density_hole
			opacity = opacity_hole



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

		else if(state == JADE_GIRDER_HOLE)
			to_chat(user, "<span class='notice'>The girder cannot be disassembled any further.</span>")
			return
		else if(state == JADE_GIRDER_BROKEN_DEBRIS || state == JADE_GIRDER_HOLE_DEBRIS)
			to_chat(user, "<span class='notice'>You cannot disassemble the girder, there is debris everywhere.</span>")
			return

	//////////////////////////////////////////////////////////
	///// REPAIRS ///////////////////////////////////////////

	if(istype(W, repair_tool)
		if(state == JADE_GIRDER_NORMAL && !girder_stack_type) //only gets called if stacks repairs are disabled, repairs the wall fully!
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

		else if (state == JADE_GIRDER_BROKEN && !girder_stack_type) //only gets called if stacks repairs are disabled
			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the detached materials...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_BROKEN)
					return
				to_chat(user, "<span class='notice'>You successfully reconnect the materials to the girder.</span>")
				state = JADE_GIRDER_BROKEN_STACK
				state_update()

		else if(state == JADE_GIRDER_HOLE_STACK)
			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the added material...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_HOLE_STACK)
					return
				to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
				state = JADE_GIRDER_BROKEN
				state_update()
		else if(state == JADE_GIRDER_HOLE && !girder_stack_type) //only gets called if stacks repairs are disabled
			playsound(src.loc, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>You start securing the added material...</span>")
			if(do_after(user, 40*W.toolspeed, target = src))
				if(state != JADE_GIRDER_HOLE)
					return
				to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
				state = JADE_GIRDER_HOLE_STACK
				state_update()

		else if(state == JADE_GIRDER_BROKEN_DEBRIS || state == JADE_GIRDER_HOLE_DEBRIS)
			to_chat(user, "<span class='notice'>You cannot repair the girder, there is debris everywhere.</span>")
			return

/////////////STACK REPAIRS //////////////////

	if(girder_stack_type && girder_stack_amount)
		if(istype(W, girder_stack_type)
			var/obj/item/stack/sheet/S = W
			if(S.amount < girder_stack_amount)
				to_chat(user, "<span class='notice'>You need atleast [girder_stack_amount] of [S.name] to carry out repairs on this girder.</span>")
				return

			if(state == JADE_GIRDER_NORMAL) // wall gets fully restored here
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

			else if(state == JADE_GIRDER_BROKEN )
				to_chat(user, "<span class='notice'>You start finishing the wall...</span>")
				if(do_after(user, 40, target = src))
					if(state != JADE_GIRDER_BROKEN && S.amount < girder_stack_amount)
						return
					S.use(girder_stack_amount)
					to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
					state = JADE_GIRDER_BROKEN_STACK
					state_update()

			else if(state == JADE_GIRDER_HOLE)
				to_chat(user, "<span class='notice'>You start finishing the wall...</span>")
				if(do_after(user, 40, target = src))
					if(state != JADE_GIRDER_HOLE && S.amount < girder_stack_amount)
						return
					S.use(girder_stack_amount)
					to_chat(user, "<span class='notice'>You successfully repair the girder.</span>")
					state = JADE_GIRDER_HOLE_STACK
					state_update()

			else if(state == JADE_GIRDER_BROKEN_DEBRIS || state == JADE_GIRDER_HOLE_DEBRIS)
			to_chat(user, "<span class='notice'>You cannot repair the girder, there is debris everywhere.</span>")
			return

//////////////////////////////////////////

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			if(!user.drop_item())
				return
			P.loc = src.loc
			to_chat(user, "<span class='notice'>You fit the pipe into \the [src].</span>")
	else
		return ..()

/obj/structure/jadegirder/CanPass(atom/movable/mover, turf/target, height=0)
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
	if(!(flags & NODECONSTRUCT))
		var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
		new remains(loc)
	qdel(src)