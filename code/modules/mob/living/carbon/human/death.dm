/mob/living/carbon/human/gib_animation()


/mob/living/carbon/human/dust_animation()


/mob/living/carbon/human/spawn_gibs(with_bodyparts)

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		new /obj/effect/decal/cleanable/ash(loc)
	else
		new /obj/effect/decal/remains/human(loc)

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return

	. = ..()

	dizziness = 0
	jitteriness = 0

	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.go_out()

	dna.species.spec_death(gibbed, src)

	if(SSticker && SSticker.mode)
		sql_report_death(src)
	if(mind && mind.devilinfo)
		INVOKE_ASYNC(mind.devilinfo, /datum/devilinfo.proc/beginResurrectionCheck, src)

/mob/living/carbon/human/proc/makeSkeleton()
	status_flags |= DISFIGURED
	set_species(/datum/species/skeleton)
	return 1


/mob/living/carbon/proc/Drain()
	disabilities |= NOCLONE
	blood_volume = 0
	return 1
