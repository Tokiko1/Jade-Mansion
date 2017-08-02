/turf/closed/wall/wood
	name = "wooden wall"
	desc = "A huge chunk of wood used to separate rooms."
	icon = 'icons/turf/walls/brightwood.dmi'
	icon_state = "wood"
	explosion_block = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	hardness = 40 //lower numbers are harder. Used to determine the probability of a hulk smashing through.
	slicing_duration = 300  //default time taken to slice the wall
	sheet_type = /obj/item/stack/sheet/mineral/wood
	sheet_amount = 2
	girder_type = /obj/structure/jadegirder/wooden
	disassembly_tool = /obj/item/weapon/crowbar
	debris = list(/obj/item/debris/wood, /obj/item/debris/wood, /obj/item/debris/stone)
	debris_amount_min = 2
	debris_amount_max = 5
	broken_turf = /turf/open/windowplating
	canSmoothWith = list(/turf/closed/wall/wood)


/obj/structure/jadegirder/wooden
	name = "girder"
	icon = 'icons/obj/jade_girders.dmi'
	icon_state = "jgirder"
	debris_icons = list("wood_debris1","wood_debris2","wood_debris3", "wood_debris4", "wood_debris5")
	anchored = 1
	density = 1
	layer = BELOW_OBJ_LAYER
	state = JADE_GIRDER_NORMAL
	girderpasschance = 5 // percentage chance that a projectile passes through the girder.

	girder_stack_amount = 2
	girder_turf_path = /turf/closed/wall/wood //type of turf that the fully constructed girder turns into
	girder_finish_type = /obj/item/stack/sheet/mineral/wood

	density_broken = 1 //density and opacity of the states
	density_hole = 1
	opacity_broken = 0
	opacity_hole = 0
	density_broken_debris = 1 //okay okay, these should be a list but it's not like there will be thousands of these, ok?
	opacity_broken_debris = 0
	density_hole_debris = 1
	opacity_hole_debris = 0

	debris = list(/obj/item/debris/wood)
	debris_amount_min = 5//how many debris items are created
	debris_amount_max = 10