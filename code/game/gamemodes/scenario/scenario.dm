/datum/game_mode/scenario
	name = "secret scenario"
	config_tag = "secret scenario"
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

	var/datum/scenario/choosen_scenario


/datum/game_mode/scenario/pre_setup()
	pickscenario()

	spawn_items_landmarks()

	return 1

/datum/game_mode/scenario/post_setup()
	setup_all_scenario_things()
//	announce_all_factionfluff()


	..()

/datum/game_mode/scenario/announced
	name = "scenario"
	config_tag = "scenario"

/datum/game_mode/scenario/proc/pickscenario()
	var/list/datum/scenario/scenario_list = subtypesof(/datum/scenario)
	var/scenario_type = pick(scenario_list)
	choosen_scenario = new scenario_type
	if(!choosen_scenario.pickable)
		return 0
	return 1

/datum/game_mode/scenario/proc/loadscenario()


/datum/game_mode/scenario/proc/setup_all_scenario_things()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		setup_scenario_factions(player)
		show_fluff(player, "scenario", 1)
		show_fluff(player, "faction", 1)
		show_fluff(player, "role", 1)
//		show_fluff(player, "goal", 1)
		spawn_items_role(player)
		spawn_items_faction(player)



/datum/game_mode/scenario/proc/setup_scenario_factions(var/mob/living/carbon/human/player)
	var/mobjob = player.mind.assigned_role

	if(choosen_scenario.no_faction_restrictions)
		var/randomfaction = pick(choosen_scenario.faction_list) //pick a random faction if the scenario has no faction restrictions for roles
		player.mind.scenario_faction |= randomfaction
	else
		if(!choosen_scenario.faction_restrictions.[mobjob])
			player.mind.scenario_faction |= "neutral" //all players without a faction in faction_restrictions only get the neutral faction

		else
			if(choosen_scenario.exclusive_factions) //we are only allowed to pick one faction, so choose a random one
				var/list/factionlist = choosen_scenario.faction_restrictions.[mobjob]
				var/selected_faction = pick(factionlist)
				player.mind.scenario_faction |= selected_faction

			else //let's add all factions instead
				var/list/factionlist = choosen_scenario.faction_restrictions.[mobjob]
				for(var/selected_faction in factionlist)
					player.mind.scenario_faction |= selected_faction

/datum/game_mode/scenario/proc/show_fluff(var/mob/living/carbon/human/player, var/fluff_type, var/save_memory = 1)
	if(!fluff_type)
		return
	switch(fluff_type)
		if("scenario")
			to_chat(player, "<B>Scenario: [choosen_scenario.scenario_name]</B>")
			to_chat(player, "[choosen_scenario.scenario_desc]")
			if(save_memory)
				player.mind.memory += "<B>Scenario: [choosen_scenario.scenario_name]</B><BR>"
				player.mind.memory += "[choosen_scenario.scenario_desc]<BR>"
		if("faction")
			for(var/currentfaction in player.mind.scenario_faction)
				var/ff = choosen_scenario.faction_fluff.[currentfaction]
				if(ff)
					to_chat(player, "[ff]")
					if(save_memory)
						player.mind.memory += "[ff]<BR>"
		if("role")
			var/rf = choosen_scenario.role_fluff.[player.mind.assigned_role]
			if(rf)
				to_chat(player, "[rf]")
				if(save_memory)
					player.mind.memory += "[rf]<BR>"
//		if("goal")

//spawning items on the landmarks
/datum/game_mode/scenario/proc/spawn_items_landmarks()
	var/scenario_spawns = choosen_scenario.landmark_spawns
	for(var/obj/L in GLOB.landmarks_list)
		var/itempath = scenario_spawns[L.name]
		if(itempath)
			new itempath(get_turf(L))

//spawning items for roles
/datum/game_mode/scenario/proc/spawn_items_role(var/mob/living/carbon/human/player)
	var/list/srl = choosen_scenario.role_spawns.[player.mind.assigned_role]
	for(var/ITS in srl)
		scenario_give_item(ITS, player)

//spawning items for factions
/datum/game_mode/scenario/proc/spawn_items_faction(var/mob/living/carbon/human/player)
	for(var/current_faction in player.mind.scenario_faction)
		var/list/srl = choosen_scenario.faction_spawns.[current_faction]
		for(var/ITS in srl)
			scenario_give_item(ITS, player)



/datum/game_mode/scenario/proc/scenario_give_item(var/itempath,var/mob/living/carbon/human/player)
	var/obj/item/item_to_give = itempath
	var/list/slots = list(
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store
	)

	var/T = new item_to_give(player)
	var/item_name = initial(item_to_give.name)
	var/where = player.equip_in_one_of_slots(T, slots)
	if(!where)
		to_chat(player, "<span class='userdanger'>Unfortunately, you didn't have enough space in your inventory for all items, so [item_name] has dropped to your feet, pick it up!</span>")
		var/atom/movable/droppeditem = T
		var/turf/below_player = locate(player.x, player.y, player.z)
		droppeditem.forceMove(below_player)
		return
	else
		to_chat(player, "<span class='danger'>You have a [item_name] in your [where].")
		if(where == "backpack")
			var/obj/item/weapon/storage/B = player.back
			B.orient2hud(player)
			B.show_to(player)
		return




/datum/game_mode/proc/handle_scenario_latejoin(var/mob/living/carbon/human/player)
	if(!SSticker.mode == "scenario")
		return

/datum/game_mode/scenario/handle_scenario_latejoin(var/mob/living/carbon/human/player)
	..()
	setup_scenario_factions(player)
	show_fluff(player, "scenario", 1)
	show_fluff(player, "faction", 1)
	show_fluff(player, "role", 1)
//	show_fluff(player, "goal", 1)
	spawn_items_role(player)
	spawn_items_faction(player)
