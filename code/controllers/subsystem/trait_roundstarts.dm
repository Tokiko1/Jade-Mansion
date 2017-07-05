/datum/controller/subsystem/ticker/proc/handle_all_join_traits()

	for(var/mob/living/carbon/human/player in GLOB.player_list)
		handle_join_traits(player)

/datum/controller/subsystem/ticker/proc/handle_join_traits(mob/living/carbon/human/traitholder)
	//active traits added
	for(var/traitS in traitholder.traits)
		if(GLOB.alltraits[traitS]["active"])
			var/traittype = GLOB.alltraits[traitS]["active"]
			var/a = new traittype(traitholder)
			traitholder.active_traits |= a
			return

		switch(traitS)
			if(

