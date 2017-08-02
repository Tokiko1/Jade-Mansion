/obj/item/debris
	name = "debris"
	icon = 'icons/obj/debris.dmi'
	desc = "A useless chunk of broken materials."
	icon_state = ""
	w_class = WEIGHT_CLASS_BULKY
	messy_thing = 1
	var/list/possible_icons = list() //if anything is added here, the debris picks a random icon_state from this list. if left empty, the debris will use its original icon_state

/obj/item/debris/Initialize()
	..()
	if(possible_icons.len)
		icon_state = pick(possible_icons)


/obj/item/debris/stonemetal
	name = "debris"
	icon = 'icons/obj/debris.dmi'
	desc = "A useless chunk of broken metal and stone."
	icon_state = "stone_metal1"
	possible_icons = list("stone_metal1", "stone_metal2", "stone_metal3")
	messy_thing = 1
	materials = list(MAT_METAL=200, MAT_STONE=200)
	smeltable = 1

/obj/item/debris/stone
	name = "debris"
	icon = 'icons/obj/debris.dmi'
	desc = "A useless chunk of broken stone."
	icon_state = "stone1"
	possible_icons = list("stone1", "stone2", "stone3")
	messy_thing = 1
	materials = list(MAT_STONE=400)
	smeltable = 1

/obj/item/debris/wood
	name = "wooden debris"
	icon = 'icons/obj/debris.dmi'
	desc = "A useless chunk of broken wood."
	icon_state = "stone1"
	possible_icons = list("wood1", "wood2", "wood3")
	messy_thing = 1
	materials = list(MAT_WOOD=400)
	smeltable = 1