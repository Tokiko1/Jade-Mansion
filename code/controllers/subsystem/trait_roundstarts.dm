/datum/controller/subsystem/ticker/proc/handle_all_join_traits()

	for(var/mob/living/carbon/human/player in GLOB.player_list)
		handle_join_traits(player)

/datum/controller/subsystem/ticker/proc/handle_join_traits(mob/living/carbon/human/traitholder)
	var/list/itemstoadd = list()
	for(var/traitS in traitholder.traits)
		if(GLOB.alltraits[traitS]["active"]) //active traits being added here
			var/traittype = GLOB.alltraits[traitS]["active"]
			var/a = new traittype(traitholder)
			traitholder.active_traits |= a


		switch(traitS) //inactive traits being added here
			if("Near Sighted")
				traitholder.disabilities |= NEARSIGHT
				itemstoadd += /obj/item/clothing/glasses/regular

			if("Master Chemist")
				traitholder.can_see_chems = 1

			if("Red Sparrow CQC")
				var/datum/martial_art/cqc/D = new(null)
				D.teach(traitholder)

			if("Combat Clothes")
				if(traitholder.w_uniform)
					var/obj/item/clothing/uniform_A = traitholder.w_uniform
					uniform_A.armor = list(melee = 40, bullet = 40, laser = 40, energy = 20, bomb = 10, bio = 4, rad = 0, fire = 90, acid = 90)
					uniform_A.desc += "There appears to be a reinforced lining on the inside."
			if("Poison Sting")

			if("Heavy Bag")

			if("Heavy Bag")

			if("Criminal Ties")

			if("Spider Web Glands")

			if("Maid Box Lunch")

			if("Loud Voice")