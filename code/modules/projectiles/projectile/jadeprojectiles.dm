/obj/item/projectile/ice_beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	light_range = 2
	damage_type = BURN
	hitsound = 'sound/weapons/effects/searwall.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2
	impact_effect_type = /obj/effect/overlay/temp/impact_effect/blue_laser
	hitscan = 1
	showbeam = 1
	beam_icon = "ice_beam"
	beamduration = 2

/obj/item/projectile/ice_beam/on_hit(atom/target, blocked = 0)
	var/turf/open/target_turf = get_turf(target)
	if(target_turf)
		for(var/turf/open/turfa in circleviewturfs(target, 2))
			for(var/obj/I in turfa.contents)
				if(!HAS_SECONDARY_FLAG(I, FROZEN))
					I.make_frozen_visual()
			for(var/mob/living/L in turfa.contents)
				if(L == target && prob(33))
					L.apply_status_effect(/datum/status_effect/restraining/freon, 3)
				else if(prob(10))
					L.apply_status_effect(/datum/status_effect/restraining/freon, 1)

			turfa.MakeSlippery(wet_setting = TURF_WET_PERMAFROST, ice_time_to_add = 5)
			addtimer(CALLBACK(turfa, /turf/open/.proc/MakeDry, TURF_WET_PERMAFROST), rand(3000, 3100))
	..()