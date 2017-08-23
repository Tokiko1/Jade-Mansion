/obj/item/material_pile
	name = "material pile"
	desc = "Finely crushed materials."
	icon = 'icons/obj/mining.dmi'
	icon_state = "waste_pile1"

	flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	materials = list()
	var/max_shift = 8

/obj/item/material_pile/Initialize()
	.=..()
	if(max_shift)
		pixel_x += rand(max_shift, -max_shift)
		pixel_y += rand(max_shift, -max_shift)

/obj/item/material_pile/proc/AddMaterials(obj/item/materialholder)
	if(!materialholder)
		return
	materials += materialholder.materials
	if(materials.len)
		name = "rich [initial(name)]"
		desc = "[initial(desc)] This pile looks like it contains useful materials."

//TODO: Make some kind of proc that colors or picks a different icon based on what material it contains