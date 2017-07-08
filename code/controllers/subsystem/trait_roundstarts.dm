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
			if("Trouble Maker")
				traitholder.mischief += 30
				GLOB.bad_idea_causers |= traitholder

			if("Near Sighted")
				traitholder.become_nearsighted()
				itemstoadd += /obj/item/clothing/glasses/regular/hipster

			if("Bad Luck")
				traitholder.mischief += 20 //you are a magnet for chaos
				GLOB.bad_idea_victims |= traitholder

			if("Master Chemist")
				traitholder.can_see_chems = 1

			if("Red Sparrow CQC")
				var/datum/martial_art/cqc/D = new(null)
				D.teach(traitholder)
				traitholder.mischief -= 10 //combat is not funny, especially not a pragmatic style like this

			if("Combat Clothes")
				if(traitholder.w_uniform)
					var/obj/item/clothing/uniform_A = traitholder.w_uniform
					uniform_A.armor = list(melee = 40, bullet = 40, laser = 40, energy = 20, bomb = 10, bio = 4, rad = 0, fire = 90, acid = 90)
					uniform_A.desc += " There appears to be a reinforced lining on the inside."
			if("Poison Sting")
				var/datum/action/innate/poison_sting/sting
				sting = new
				sting.Grant(traitholder)
			if("Heavy Bag")
				if(traitholder.back)
					var/obj/item/weapon/storage/backpack/backpack_A = traitholder.back
					backpack_A.max_combined_w_class = 30
					backpack_A.storage_slots = 30
					backpack_A.slowdown += 1
					backpack_A.name = "heavy [backpack_A.name]"

			if("Criminal Ties")
				traitholder.faction.Add("Black Crane")
				traitholder.mischief -= 10

			if("Spider Web Glands")
				var/datum/action/innate/web_glands/webby
				webby = new
				webby.Grant(traitholder)


			if("Maid Box Lunch")
				itemstoadd += /obj/item/weapon/reagent_containers/food/snacks/maidlunchbox

			if("Mind Shock")
				var/datum/action/innate/mind_shock/mindS
				mindS = new
				mindS.Grant(traitholder)
				traitholder.mischief += 10

			if("Hardy")
				traitholder.maxHealth += 25

			if("Frail")
				traitholder.maxHealth -= 30



	if(itemstoadd.len)
		if(traitholder.back)
			var/obj/item/weapon/storage/backpack/backpack_A = traitholder.back
			for(var/thing_to_add in itemstoadd)
				var/addstuff = new thing_to_add
				backpack_A.contents += addstuff