//traps!

/obj/structure/jadetrap
	name = "trap"
	icon = 'icons/obj/traps.dmi'
	desc = ""
	icon_state = ""

	max_integrity = 100
	obj_integrity = 100

	var/disarmtool 							//path to the type of item that will start the disarm process instead of attacking the trap. if null, uses hands
	var/can_disarm							//can the trap be disarmed?
	var/disarmtime = 30						//how long the disarm process takes
	var/disarm_item							//path of the object you get back when you disarm the trap, leaving this blank is fine
	var/disarm_item_amount = 1				//how many of above object you get back. if the above item is a stack, this is the amount of items in the stack instead

	var/does_attack_trigger = 0				//does directly attacking the trap trigger it?
	var/attack_trigger_chance = 20			//chance in % that an attack triggers the trap
	var/does_disarm_trigger = 0
	var/disarm_trigger_chance = 20

	var/trigger_type = 0 			//0 = trap is triggered with no particular target(yet), 1 = trap is triggered with the attacker as the target

/obj/structure/jadetrap/attackby(obj/item/W, mob/user, params)
	if(can_disarm && istype(W, disarmtool))
		AttemptDisarm("tool", user, W)
	else
		. = ..()

/obj/structure/jadetrap/attack_hand(mob/user)
	if(can_disarm && !disarmtool)
		AttemptDisarm("hand", user)
	else
		. = ..()

/obj/structure/jadetrap/proc/AttemptDisarm(trap_disarm_type, mob/user, obj/item/W, params)
	if(!trap_disarm_type)
		return
	if(does_disarm_trigger)
		if(prob(disarm_trigger_chance))
			to_chat(user, "<span class='warning'>You accidently trigger the [src] while trying to disarm it!</span>")
			if(trigger_type)
				TriggerTrap(user)
			else
				TriggerTrap()
			return

	user.visible_message("<span class='warning'>[user] is starting to disarm the [src].!</span>")
	if(do_after(user, disarmtime, target = src))
		if(src)
			if(disarm_item && disarm_item_amount) //spawning the stack
				if(istype(disarm_item, /obj/item/stack))
					var/obj/item/stack/newstack = new disarm_item(get_turf(src))
					newstack.amount = disarm_item_amount
				else
					var/turf/t_target = get_turf(src)
					for(var/i in 1 to disarm_item_amount) //spawning the items
						new disarm_item(t_target)
			qdel(src)
	else
		to_chat(user, "<span class='warning'>You fail to disarm the [src]!</span>")

/obj/structure/jadetrap/proc/TriggerTrap(atom/movable/target) //call this proc when the trap does its stuff, don't put it in /collide() or whatever

///////////////////////////////////////

/obj/structure/jadetrap/spikewire
	name = "spiked wire"
	icon = 'icons/obj/traps.dmi'
	desc = "Painful, spiked wires."
	icon_state = "spikewire1"
	density = 0
	anchored = 1
	disarmtool = /obj/item/weapon/wirecutters
	can_disarm = 1
	disarmtime = 100
	disarm_item = /obj/item/stack/metal_wire
	disarm_item_amount = 50

	does_disarm_trigger = 1
	disarm_trigger_chance = 30
	trigger_type = 1

	var/spike_damage_min = 1
	var/spike_damage_max = 4
	var/spike_damage_type = BRUTE
	var/spike_damage_chance = 55
	var/spike_pass_chance = 10
	var/damage_sound = 'sound/weapons/genhit1.ogg'

/obj/structure/jadetrap/spikewire/CanPass(atom/movable/mover, turf/target, height=0)
	if(prob(50))
		TriggerTrap(mover)
		return 0
	if(spike_pass_chance)
		return 1
	return 0

/obj/structure/jadetrap/spikewire/TriggerTrap(atom/movable/target)
	if(!target)
		return

	if(isliving(target))
		var/mob/living/T = target
		playsound(loc, damage_sound, 25, 1)
		T.apply_damage(rand(spike_damage_min, spike_damage_max), spike_damage_type)
		to_chat(T, "<span class='warning'>You are hurt by [src]!</span>")


/////////////////////////


/obj/structure/jadetrap/tripwire
	name = "trip wire"
	icon = 'icons/obj/traps.dmi'
	desc = "A strong, camouflaged wire intended to trip and knock unsuspecting people down."
	icon_state = "tripwire1"
	density = 0
	anchored = 1
	alpha = 150
	disarmtool = /obj/item/weapon/wirecutters
	can_disarm = 1
	disarmtime = 30
	disarm_item = /obj/item/stack/metal_wire
	disarm_item_amount = 20
	var/walk_stun = 0 //does this stun people who carefully walk?
	var/hit_flying = 0 //does this stun flying people?
	var/hit_prone = 0 //does this hit people who fell down? this will enable chain reactions if combined with send_flying and might cause infinite loops of forced movement, be SMART when you use this
	var/send_flying = 0
	var/send_flying_distance = 3
	var/weaken_amount = 2
	var/trip_damage_type = BRUTE
	var/trip_damage_min = 1
	var/trip_damage_max = 4

	does_disarm_trigger = 0



/obj/structure/jadetrap/tripwire/Crossed(atom/movable/AM)
	if(iscarbon(AM))
		var/mob/living/carbon/T = AM
		if((T.movement_type & FLYING) && !hit_flying) //harpies have it so good...
			return 0
		if(T.m_intent == MOVE_INTENT_WALK && !walk_stun)
			return 0

		if((T.lying || !(T.status_flags & CANWEAKEN)) && !hit_prone)
			return 0

		TriggerTrap(AM)

	. = ..()

/obj/structure/jadetrap/tripwire/TriggerTrap(atom/movable/target)
	if(!target)
		return 0

	if(iscarbon(target))
		var/mob/living/carbon/T = target

		T.Weaken(weaken_amount)
		T.visible_message("<span class='warning'>[T] trips over [src]!</span>")

		for(var/obj/item/I in T.held_items)
			T.accident(I)

		if(trip_damage_type)
			T.apply_damage(rand(trip_damage_min, trip_damage_max), trip_damage_type)

		if(send_flying)
			new /datum/forced_movement(T, get_ranged_target_turf(T, T.dir, send_flying_distance), 1, FALSE, CALLBACK(T, /mob/living/carbon/.proc/spin, 1, 1))
		return 1

/obj/structure/jadetrap/tripwire/bouncy
	name = "bouncy trip wire"
	icon = 'icons/obj/traps.dmi'
	desc = "A tripwire under pressure. Anyone stepping on it will be flung forward quite a bit."
	icon_state = "tripwire2"
	disarm_item_amount = 60
	alpha = 75
	send_flying = 1
	send_flying_distance = 7 //OW!
	weaken_amount = 5
	walk_stun = 1
	trip_damage_type = BRUTE
	trip_damage_min = 5
	trip_damage_max = 15 //yes, this will hurt

/obj/structure/jadetrap/tripwire/high
	name = "tall trip wire"
	icon = 'icons/obj/traps.dmi'
	desc = "A whole bunch of trip wires. Sure to knock over and entangle even flying things."
	icon_state = "tripwire3"
	disarm_item_amount = 40
	alpha = 75
	hit_flying = 1

/////CALTROP ITEM///////

/obj/structure/jadetrap/tripwire/caltrop
	name = "caltrops"
	icon = 'icons/obj/traps.dmi'
	desc = "A whole bunch of dangerous caltrops!"
	icon_state = "caltrops1"
	density = 0
	anchored = 1
	alpha = 255
	disarmtool = null
	can_disarm = 1
	disarmtime = 100
	disarm_item = /obj/item/caltrop/
	disarm_item_amount = 1
	walk_stun = 1 //does this stun people who carefully walk?
	hit_prone = 1
	hit_flying = 0
	send_flying = 0
	weaken_amount = 5
	trip_damage_type = BRUTE
	trip_damage_min = 10
	trip_damage_max = 20
	does_disarm_trigger = 0

/obj/structure/jadetrap/tripwire/caltrop/Initialize()
	icon_state = pick("caltrops1","caltrops2","caltrops3")
	. = ..()


/obj/item/caltrop/
	name = "bunched up caltrops"
	icon = 'icons/obj/traps.dmi'
	icon_state = "caltrop_5"
	desc = "A bunch of tiny balls with very long spikes, used since hundred-thousands of years as a way to deter pursuers. Simply USE them to scatter them across the floor."
	w_class = WEIGHT_CLASS_TINY
	materials = list(MAT_METAL = 200)


/obj/item/caltrop/attack_self(mob/user)
	if(isopenfloorturf(user.loc))
		var/turf/target_turf = get_turf(user)
		to_chat(user, "<span class='warning'>You scatter [src] all over [target_turf]!</span>")
		new /obj/structure/jadetrap/tripwire/caltrop(target_turf)
		qdel(src)
		return
	else
		to_chat(user, "<span class='warning'>[src] can't be deployed here!</span>")
		return

//////////////////////////

/obj/structure/jadetrap/tripwire/grenademine
	name = "metal makeshift mine"
	icon = 'icons/obj/traps.dmi'
	desc = "A mine that is activated when someone steps onto it"
	icon_state = "mine"
	hit_prone = 1
	walk_stun = 1
	alpha = 255
	disarmtool = /obj/item/weapon/wrench
	can_disarm = 1
	disarmtime = 100
	disarm_item = /obj/item/stack/sheet/metal
	disarm_item_amount = 2
	var/mine_switch_sound = 'sound/effects/pressureplate.ogg'
	var/mine_trigger_sound = 'sound/effects/snap.ogg'

	var/icon/grenade_overlay //overlay for the mine
	var/obj/item/weapon/grenade/internal_grenade //link to the grenade stored inside

	var/grenade_insert_time = 50
	var/trigger_state = 0 //1 = trap triggers if someone steps on it

/obj/structure/jadetrap/tripwire/grenademine/Initialize()
	icon_state = "[initial(icon_state)]_[trigger_state]"
	.=..()

/obj/structure/jadetrap/tripwire/grenademine/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/grenade) && !internal_grenade)
		to_chat(user, "<span class='notice'>You begin connecting the [W] to the trigger of [src].</span>")
		if(do_after(user, grenade_insert_time, target = src))
			if(!user.drop_item() || W.loc == src || !W || internal_grenade)
				return
			W.loc = src
			to_chat(user, "<span class='notice'>You successfully connect [W] to the trigger of [src].</span>")
			internal_grenade = W

			grenade_overlay = icon(internal_grenade.icon, internal_grenade.icon_state)
			add_overlay(grenade_overlay)

		else
			to_chat(user, "<span class='warning'>You fail to connect [W] to [src]!</span>")
			return
		return
	.=..()

/obj/structure/jadetrap/tripwire/grenademine/proc/SwitchMineTriggerState(f_trigger_state)
	if(f_trigger_state != null)
		trigger_state = f_trigger_state
	else if(!trigger_state)
		trigger_state = 1
	else if(trigger_state)
		trigger_state = 0
	playsound(loc, mine_switch_sound, 25, 1)
	icon_state = "[initial(icon_state)]_[trigger_state]"

/obj/structure/jadetrap/tripwire/grenademine/attack_hand(mob/user)
	SwitchMineTriggerState()
	. = ..()



/obj/structure/jadetrap/tripwire/grenademine/TriggerTrap(atom/movable/target)
	if(!trigger_state)
		return
	playsound(loc, mine_trigger_sound, 25, 1)
	if(internal_grenade)
		src.visible_message("<span class='warning'>[src] is triggered and sends [internal_grenade] hopping into the air!</span>")
		src.cut_overlay(grenade_overlay)
		internal_grenade.loc = src.loc
		internal_grenade.prime() //boom!
		internal_grenade = null //remove it
	SwitchMineTriggerState(0) //set the trap to off again

/obj/structure/jadetrap/tripwire/grenademine/Destroy()
	if(internal_grenade)
		src.cut_overlay(grenade_overlay)
		internal_grenade.loc = src.loc
		qdel(src)
		. = ..()

/obj/structure/jadetrap/tripwire/grenademine/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if(damage_type == BRUTE && damage_amount > 1)
		TriggerTrap()
	.=..()