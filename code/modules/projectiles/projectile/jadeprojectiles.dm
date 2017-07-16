/obj/item/projectile/ice_beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 20
	light_range = 2
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2
	impact_effect_type = /obj/effect/overlay/temp/impact_effect/blue_laser
	light_color = LIGHT_COLOR_RED