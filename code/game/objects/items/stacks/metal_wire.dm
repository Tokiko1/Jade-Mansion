GLOBAL_LIST_INIT(metal_wire_recipes, list ( \
	new/datum/stack_recipe("spikewire wall", /obj/structure/jadetrap/spikewire, 20, time = 50, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/metal_wire
	name = "metal wire"
	desc = "Metal wire. Useful for securing makeshift structures and conducting electricity."
	singular_name = "metal rod"
	icon_state = "metal_wire"
	item_state = "coil_blue" //close enough!... not really
	flags = CONDUCT
	w_class = WEIGHT_CLASS_NORMAL
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 3
	materials = list(MAT_METAL=100)
	max_amount = 150
	attack_verb = list("hit", "bludgeoned", "whacked")
	hitsound = 'sound/weapons/grenadelaunch.ogg'

/obj/item/stack/metal_wire/Initialize(mapload, new_amount, merge = TRUE)
	..()

	recipes = GLOB.metal_wire_recipes
	update_icon()