//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "metal door"
	density = 1
	anchored = 1
	opacity = 1

	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "metal"

	var/initial_state
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/close_delay = -1 //-1 if does not auto close.
	obj_integrity = 200
	max_integrity = 200
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 100, bomb = 10, bio = 100, rad = 100, fire = 50, acid = 50)
	var/sheetType = /obj/item/stack/sheet/metal
	var/sheetAmount = 10
	var/openSound = 'sound/effects/stonedoor_openclose.ogg'
	var/closeSound = 'sound/effects/stonedoor_openclose.ogg'
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/haslock = 0
	var/doorkeyid = "any"
	var/doorlocked = 0
	var/autoclose = 0
	var/doorlockdifficulty  = 20



/obj/structure/mineral_door/New(location)
	..()
	initial_state = icon_state
	air_update_turf(1)

/obj/structure/mineral_door/Destroy()
	density = 0
	air_update_turf(1)
	return ..()

/obj/structure/mineral_door/Move()
	var/turf/T = loc
	..()
	move_update_air(T)

/obj/structure/mineral_door/Bumped(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)

/obj/structure/mineral_door/attack_ai(mob/user) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(iscyborg(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/mineral_door/attack_paw(mob/user)
	return TryToSwitchState(user)

/obj/structure/mineral_door/attack_hand(mob/user)
	return TryToSwitchState(user)

/obj/structure/mineral_door/CanPass(atom/movable/mover, turf/target, height=0)
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/mineral_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates)
		return
	if(isliving(user))
		var/mob/living/M = user
		if(REALTIMEOFDAY - M.last_bumped <= 60)
			return //NOTE do we really need that?
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState(user)
			else
				SwitchState(user)
	else if(istype(user, /obj/mecha))
		SwitchState(user)

/obj/structure/mineral_door/proc/SwitchState(atom/user)
	if(state)
		Close()
	else
		Open(user)

/obj/structure/mineral_door/proc/Open(atom/user)
	if(doorlocked)
		to_chat(user, "<span class='notice'>The door is locked!</span>")
		return
	isSwitchingStates = 1
	playsound(loc, openSound, 100, 1)
	set_opacity(0)

	flick("[initial_state]opening",src)
	sleep(10)
	density = 0
	state = 1
	air_update_turf(1)
	update_icon()
	isSwitchingStates = 0

	if(close_delay != -1)
		addtimer(CALLBACK(src, .proc/Close), close_delay)

	if(autoclose)
		heldopen()


/obj/structure/mineral_door/proc/heldopen()
	while(state)
		var/people_near_door = 0
		sleep(10)
		for(var/mob/living/L in orange(1,src))
			if(L.stat == CONSCIOUS)
				people_near_door++
		if(!people_near_door)
			if(!isSwitchingStates && state)
				SwitchState()
				return
		people_near_door = 0


/obj/structure/mineral_door/proc/Close()
	if(isSwitchingStates || state != 1)
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		return
	isSwitchingStates = 1
	flick("[initial_state]closing",src)
	sleep(10)
	playsound(loc, closeSound, 100, 1)
	density = 1
	set_opacity(1)
	state = 0
	air_update_turf(1)
	update_icon()
	isSwitchingStates = 0

/obj/structure/mineral_door/update_icon()
	if(state)
		icon_state = "[initial_state]open"
	else
		icon_state = initial_state

/obj/structure/mineral_door/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/doorkey))
		var/obj/item/doorkey/DK = W
		if(!haslock)
			to_chat(user, "<span class='notice'>This door does not appear to be lockable.</span>")
			return
		if(isSwitchingStates)
			to_chat(user, "<span class='notice'>Wait until the door has finished opening or closing.</span>")
			return
		if(state)
			to_chat(user, "<span class='notice'>You cannot lock open doors. Close it first.</span>")
			return
		if(doorkeyid == DK.keyid || doorkeyid == "any" || DK.keyid == "master"|| istype(W,/obj/item/doorkey/lockpick))
			if(istype(W,/obj/item/doorkey/lockpick))
				var/obj/item/doorkey/lockpick/LP = W
				if(!LP.attemptpicklock(src, user, doorlockdifficulty))
					return
			if(doorlocked)
				to_chat(user, "<span class='notice'>You unlock the door.</span>")
				doorlocked = 0
			else
				to_chat(user, "<span class='notice'>You lock the door.</span>")
				doorlocked = 1
			playsound(loc, 'sound/machines/DoorClick.ogg', 100, 1)
			return
		else
			to_chat(user, "<span class='notice'>Your key doesn't fit into the lock.</span>")
			return
	else if(user.a_intent != INTENT_HARM)
		attack_hand(user)
	else
		return ..()

/obj/structure/mineral_door/deconstruct(disassembled = TRUE)
	var/turf/T = get_turf(src)
	if(disassembled)
		new sheetType(T, sheetAmount)
	else
		new sheetType(T, max(sheetAmount - 2, 1))
	qdel(src)

/obj/structure/mineral_door/iron
	name = "iron door"
	obj_integrity = 300
	max_integrity = 300

/obj/structure/mineral_door/silver
	name = "silver door"
	icon_state = "silver"
	sheetType = /obj/item/stack/sheet/mineral/silver
	obj_integrity = 300
	max_integrity = 300

/obj/structure/mineral_door/gold
	name = "gold door"
	icon_state = "gold"
	sheetType = /obj/item/stack/sheet/mineral/gold

/obj/structure/mineral_door/uranium
	name = "uranium door"
	icon_state = "uranium"
	sheetType = /obj/item/stack/sheet/mineral/uranium
	obj_integrity = 300
	max_integrity = 300
	light_range = 2

/obj/structure/mineral_door/sandstone
	name = "sandstone door"
	icon_state = "sandstone"
	sheetType = /obj/item/stack/sheet/mineral/sandstone
	obj_integrity = 100
	max_integrity = 100

/obj/structure/mineral_door/transparent
	opacity = 0

/obj/structure/mineral_door/transparent/Close()
	..()
	opacity = 0

/obj/structure/mineral_door/transparent/plasma
	name = "plasma door"
	icon_state = "plasma"
	sheetType = /obj/item/stack/sheet/mineral/plasma

/obj/structure/mineral_door/transparent/plasma/attackby(obj/item/weapon/W, mob/user, params)
	if(W.is_hot())
		message_admins("Plasma mineral door ignited by [key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Plasma mineral door ignited by [key_name(user)] in ([x],[y],[z])")
		TemperatureAct()
	else
		return ..()

/obj/structure/mineral_door/transparent/plasma/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		TemperatureAct()

/obj/structure/mineral_door/transparent/plasma/proc/TemperatureAct()
	atmos_spawn_air("plasma=500;TEMP=1000")
	deconstruct(FALSE)

/obj/structure/mineral_door/transparent/diamond
	name = "diamond door"
	icon_state = "diamond"
	sheetType = /obj/item/stack/sheet/mineral/diamond
	obj_integrity = 1000
	max_integrity = 1000

/obj/structure/mineral_door/wood
	name = "wood door"
	icon_state = "wood"
	openSound = 'sound/machines/door_open.ogg'
	closeSound = 'sound/machines/door_close.ogg'
	sheetType = /obj/item/stack/sheet/mineral/wood
	resistance_flags = FLAMMABLE
	obj_integrity = 200
	max_integrity = 200

/obj/structure/mineral_door/wood/lock
	haslock = 1
	autoclose = 1
	name = "general access door"

/obj/structure/mineral_door/wood/lock/paper
	icon_state = "paperframe"

/obj/structure/mineral_door/wood/lock/whitewood
	icon_state = "silver"

/obj/structure/mineral_door/wood/lock/upstairs
	name = "upstairs maid access wood door"
	doorkeyid = "upstairs"

/obj/structure/mineral_door/wood/lock/downstairs
	name = "downstairs maid access wood door"
	doorkeyid = "downstairs"

/obj/structure/mineral_door/wood/lock/between
	name = "between maid access wood door"
	doorkeyid = "between"

/obj/structure/mineral_door/wood/lock/gardener
	name = "gardener access wood door"
	doorkeyid = "gardener"

/obj/structure/mineral_door/wood/lock/owner
	name = "owner access wood door"
	doorkeyid = "owner"
	doorlockdifficulty  = 90

/obj/structure/mineral_door/wood/lock/owner/locked
	name = "owner access wood door"
	doorkeyid = "owner"
	doorlockdifficulty  = 90
	doorlocked = 1