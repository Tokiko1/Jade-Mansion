/datum/controller/subsystem/ticker/proc/handle_all_join_traits()

	for(var/mob/living/carbon/human/player in GLOB.player_list)
		handle_join_traits(player)

/datum/controller/subsystem/ticker/proc/handle_join_traits()