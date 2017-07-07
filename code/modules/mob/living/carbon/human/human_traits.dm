/mob/living/carbon/human/proc/handle_traits()

	for(var/datum/trait/traitS in active_traits)
		traitS.run_check(src)