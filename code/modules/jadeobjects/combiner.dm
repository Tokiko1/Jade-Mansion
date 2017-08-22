/obj/machinery/waste_combiner
	name = "waste combiner"
	desc = "It sucks up crushed material dust and ejects sheets of materials once it has enough."
	icon = 'icons/obj/jade_machinery.dmi'
	icon_state = "combiner"
	anchored = 1
	density = 1
	layer = ABOVE_MOB_LAYER

	var/eat_dir = NORTH
	var/datum/material_container/materials
	var/item_recycle_sound = 'sound/items/Welder.ogg'

/obj/machinery/waste_combiner/Initialize()
	materials = new /datum/material_container(src, list(MAT_METAL, MAT_GLASS, MAT_PLASTIC, MAT_WOOD, MAT_SILVER, MAT_GOLD, MAT_DIAMOND, MAT_URANIUM, MAT_STONE, MAT_TITANIUM))
	materials.max_amount = 100000

/obj/machinery/waste_combiner/Bumped(atom/movable/AM)

	if(stat & (BROKEN|NOPOWER))
		return

	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		eat(AM)

/obj/machinery/waste_combiner/proc/eat(atom/AM0, sound=TRUE)
	var/list/to_eat
	if(istype(AM0, /obj/item) && !istype(AM0, /obj/item/flat))
		to_eat = AM0.GetAllContents()
	else
		to_eat = list(AM0)

	var/items_recycled = 0

	for(var/i in to_eat)
		var/atom/movable/AM = i

		if(istype(AM, /obj/item/material_pile))
			recycle_item(AM)
			items_recycled++
		else
			AM.loc = src.loc

	if(items_recycled && sound)
		playsound(src.loc, item_recycle_sound, 50, 1)

/obj/machinery/waste_combiner/proc/recycle_item(obj/item/I)
	I.loc = src.loc

	var/material_amount = materials.get_item_material_amount(I)
	if(!material_amount)
		qdel(I)
		return
	materials.insert_item(I)
	qdel(I)
	materials.retrieve_all()