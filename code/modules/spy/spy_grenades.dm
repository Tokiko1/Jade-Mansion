/obj/item/weapon/grenade/spy_minibomb
	desc = "A small and easily deployable explosive. An expensive and complex explosion mechanism allows for total devastation of objects with no risk of killing living beings. A typical grenade used for clandestine operations as no nation is foolish enough to even risk violating peace treaty.."
	name = "explosion grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "blue_grenade"
	item_state = "flashbang"

/obj/item/weapon/grenade/spy_minibomb/prime()
	update_mob()
	explosion(src.loc,1,2,4,flame_range = 2)
	qdel(src)

////

/obj/item/weapon/grenade/freeze
	desc = "A useful grenade that freezes things in a large radius and greatly exhausts living beings caught inside its blast range."
	name = "freeze grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "cryogrenade"
	item_state = "flashbang"
	var/freeze_range = 7
	var/stamina_damage = 30

/obj/item/weapon/grenade/freeze/prime()
	update_mob()
	playsound(loc, 'sound/effects/EMPulse.ogg', 50, 1)
	for(var/turf/T in circleviewturfs(src, freeze_range))
		if(isopenfloorturf(T))
			var/turf/open/F = T
			F.MakeSlippery(wet_setting = TURF_WET_PERMAFROST, ice_time_to_add = 5)
			addtimer(CALLBACK(F, /turf/open.proc/MakeDry, TURF_WET_PERMAFROST), rand(3000, 3100))
			for(var/obj/I in T.contents)
				if(!HAS_SECONDARY_FLAG(I, FROZEN))
					I.make_frozen_visual()
			for(var/mob/living/carbon/L in T)
				L.apply_status_effect(/datum/status_effect/restraining/freon, 3)
				L.adjustStaminaLoss(stamina_damage)
				L.bodytemperature -= 230
	qdel(src)