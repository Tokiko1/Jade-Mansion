/turf/closed/wall/strong
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	explosion_block = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	hardness = 40 //lower numbers are harder. Used to determine the probability of a hulk smashing through.
	slicing_duration = 300  //default time taken to slice the wall
	sheet_type = /obj/item/stack/sheet/metal
	sheet_amount = 2
	girder_type = /obj/structure/jadegirder/strong
	disassembly_tool = /obj/item/weapon/weldingtool
	debris = list(/obj/item/debris/stonemetal, /obj/item/debris/stone)
	debris_amount_min = 5
	debris_amount_max = 10
	broken_turf = /turf/open/tiles/metaltile

/obj/structure/jadegirder/strong
	name = "girder"
	icon = 'icons/obj/jade_girders.dmi'
	icon_state = "rgirder"
	debris_icons = list("stone_debris1","stone_debris2","stone_debris3", "stone_debris4", "stone_debris5")
	anchored = 1
	density = 1
	layer = BELOW_OBJ_LAYER
	state = JADE_GIRDER_NORMAL
	girderpasschance = 5 // percentage chance that a projectile passes through the girder.

	girder_stack_amount = 4
	girder_turf_path = /turf/closed/wall/strong //type of turf that the fully constructed girder turns into

	density_broken = 1 //density and opacity of the states
	density_hole = 1
	opacity_broken = 0
	opacity_hole = 0
	density_broken_debris = 1 //okay okay, these should be a list but it's not like there will be thousands of these, ok?
	opacity_broken_debris = 0
	density_hole_debris = 1
	opacity_hole_debris = 0

	debris = list(/obj/item/debris/stonemetal, /obj/item/debris/stone)
	debris_amount_min = 5//how many debris items are created
	debris_amount_max = 10