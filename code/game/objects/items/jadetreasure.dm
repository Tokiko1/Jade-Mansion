/obj/item/treasure
	name = "treasure"
	icon = 'icons/obj/mining.dmi'
	desc = "A valuable item."
	icon_state = ""
	w_class = WEIGHT_CLASS_SMALL
	var/treasure_value
	var/bar_stack_type
	var/shift_pixels = TRUE
	var/max_shift = 8

/obj/item/treasure/jadepiece
	name = "jade stone"
	icon = 'icons/obj/mining.dmi'
	desc = "An execptionally high quality piece of jade. Extremely valuable."
	icon_state = "jade_piece1"
	w_class = WEIGHT_CLASS_SMALL
	treasure_value = 2000
	shift_pixels = TRUE
	max_shift = 8

/obj/item/treasure/Initialize()
	..()
	if(shift_pixels)
		pixel_x += rand(max_shift, -max_shift)
		pixel_y += rand(max_shift, -max_shift)

/obj/item/treasure/jadepiece/Initialize()
	..()
	//this whole thing should be expanded later on
	if(prob(10))
		treasure_value = rand(2000, 5000)
		name = "rare [name]"
		icon_state = pick("jade_piece1", "jade_piece2")
	else
		treasure_value = rand(1000, 3000)
		icon_state = pick("jade_piece1", "jade_piece2", "raw_jade1", "raw_jade2", "raw_jade3")


/obj/item/treasure/goldbar
	name = "gold bar"
	icon = 'icons/obj/mining.dmi'
	desc = "A bar of pure gold. Exceptionally valuable."
	icon_state = "sheet-gold"
	bar_stack_type = /obj/structure/bar_stack/gold
	w_class = WEIGHT_CLASS_SMALL
	treasure_value = 1500

/obj/item/treasure/silverbar
	name = "gold bar"
	icon = 'icons/obj/mining.dmi'
	desc = "A bar of pure silver. Exceptionally valuable."
	icon_state = "sheet-silver"
	bar_stack_type = /obj/structure/bar_stack/silver
	w_class = WEIGHT_CLASS_SMALL
	treasure_value = 1100

/obj/item/treasure/attackby(obj/item/W, mob/user, params)
	if(istype(W, src) && W != src && bar_stack_type)
		var/turf/bartargetturf = get_turf(user)
		if(isopenfloorturf(bartargetturf))
			if(!user.drop_item()) //checks if the item can be dropped AND drops it so it can be properly moved
				return
			to_chat(user, "<span class='notice'>You create a [src.name] stack.</span>")
			var/obj/structure/bar_stack/BS = new src.bar_stack_type(bartargetturf)
			W.loc = BS
			src.loc = BS
			BS.barlist.Add(W)
			BS.barlist.Add(src)
			BS.calculate_worth()
			BS.update_icon()
	..()


//bar stacks types
/obj/structure/bar_stack
	name = "stack of bars"
	icon = 'icons/obj/mining.dmi'
	desc = ""
	icon_state = ""
	anchored = 1
	var/treasure_value
	var/list/barlist = list()
	var/allowed_type
	var/max_stack_size

/obj/structure/bar_stack/gold
	name = "gold bar stack"
	desc = "A pile of valuable gold bars."
	allowed_type = /obj/item/treasure/goldbar
	max_stack_size = 6
	icon_state = "gold_pile"

/obj/structure/bar_stack/gold/full/Initialize()
	spawnfull()
	..()

/obj/structure/bar_stack/silver
	name = "silver bar stack"
	desc = "A pile of valuable silver bars."
	allowed_type = /obj/item/treasure/silverbar
	max_stack_size = 6
	icon_state = "silver_pile"

/obj/structure/bar_stack/silver/full/Initialize()
	spawnfull()
	..()



//bar pile procs


/obj/structure/bar_stack/proc/spawnfull()
	for(var/i in 1 to max_stack_size)
		var/obj/item/treasure/newbar = new allowed_type(src)
		barlist.Add(newbar)
	..()

/obj/structure/bar_stack/proc/spawnrandom(min_spawn_amount = 2)
	for(var/i in 1 to rand(min_spawn_amount, max_stack_size))
		var/obj/item/treasure/newbar = new allowed_type(src)
		barlist.Add(newbar)
	..()

/obj/structure/bar_stack/Initialize()
	..()
	update_icon()

/obj/structure/bar_stack/update_icon()
	var/size_of_barpile = barlist.len
	icon_state = "[initial(icon_state)]_[size_of_barpile]"

/obj/structure/bar_stack/proc/check_pile()
	if(barlist.len == 1) //well, this is no longer a pile, let's release the last item
		var/obj/item/treasure/treasureH = barlist[1]
		treasureH.loc = get_turf(src)
		qdel(src)


/obj/structure/bar_stack/proc/calculate_worth()
	treasure_value = 0
	for(var/obj/item/treasure/treasureS in barlist)
		treasure_value += treasureS.treasure_value

/obj/structure/bar_stack/attackby(obj/item/W, mob/user, params)
	if(istype(W, allowed_type) && !(W in barlist))
		if(barlist.len >= max_stack_size)
			to_chat(user, "<span class='notice'>The [name] cannot be stacked any higher.</span>")
			return
		if(!user.drop_item()) //checks if the item can be dropped AND drops it so it can be properly moved
			return
		to_chat(user, "<span class='notice'>You add the [W.name] to the [name].</span>")
		W.loc = src
		barlist.Add(W)
		calculate_worth()
		update_icon()
		check_pile()
	..()

/obj/structure/bar_stack/attack_hand(mob/user)
	..()
	var/obj/item/treasure/treasureH = barlist[barlist.len] //pick the last bar put into the pile
	user.put_in_hands(treasureH)
	barlist.Remove(treasureH)
	calculate_worth()
	update_icon()
	check_pile()