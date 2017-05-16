/mob/living/carbon/alien/larva/death(gibbed)
	if(stat == DEAD)
		return

	. = ..()

	update_icons()

/mob/living/carbon/alien/larva/spawn_gibs(with_bodyparts)

/mob/living/carbon/alien/larva/gib_animation()
	new /obj/effect/overlay/temp/gib_animation(loc, "gibbed-l")

/mob/living/carbon/alien/larva/spawn_dust()
	new /obj/effect/decal/remains/xeno(loc)

/mob/living/carbon/alien/larva/dust_animation()
	new /obj/effect/overlay/temp/dust_animation(loc, "dust-l")
