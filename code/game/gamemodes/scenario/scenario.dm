/datum/game_mode/scenario
	name = "secret scenario"
	config_tag = "secret scenario"
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"


	var/list/goals = list()
	var/setup_complete = 0
	var/polling = 0
	var/initiated_end = 0
	var/goals_done = 0
	var/finished = 0
	var/poll_roundend_next = 0
	var/check_counter = 0


/datum/game_mode/scenario/pre_setup()
	pickscenario()
	picksubscenario()
	spawn_items_landmarks()

	return 1

/datum/game_mode/scenario/post_setup()
	setup_all_scenario_things()
	poll_roundend_next = REALTIMEOFDAY + choosen_scenario.round_lenght
	choosen_scenario.handlescenario_postsetup()
	setup_complete = 1

	..()

/datum/game_mode/scenario/announced
	name = "scenario"
	config_tag = "scenario"

/datum/game_mode/scenario/process()
	check_counter++
	if(check_counter >= 5)
		if(!finished && setup_complete)
			if(REALTIMEOFDAY > poll_roundend_next)
				if(!SSvote.mode && !polling && !initiated_end)
					SSvote.initiate_vote("end round")
			if(initiated_end && !polling)
				choosen_scenario.handle_end()
				polling = 1

			if(goals_done)
				announce_end_stats()
		check_counter = 0
	return 0





/datum/game_mode/proc/pickscenario()
	var/scenario_type
	if(!GLOB.scenario_override)
		var/list/datum/scenario/scenario_list = subtypesof(/datum/scenario)
		scenario_type = pick(scenario_list)
	else
		scenario_type = GLOB.scenario_override_name
	choosen_scenario = new scenario_type



	choosen_scenario.handlescenario()
	return 1

/datum/game_mode/proc/picksubscenario()
	var/subscenario_type
	if(!GLOB.sub_scenario_override)
		var/list/datum/subscenario/subscenario_list = subtypesof(/datum/subscenario)
		subscenario_type = pick(subscenario_list)
	else
		subscenario_type = GLOB.sub_scenario_override_name
	choosen_sub = new subscenario_type
	choosen_sub.handle_subscenario()
	return 1

/datum/game_mode/scenario/proc/loadscenario()


/datum/game_mode/scenario/proc/setup_all_scenario_things()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		setup_scenario_factions(player)
		show_fluff(player, "scenario", 1)
		show_fluff(player, "faction", 1)
		show_fluff(player, "role", 1)
//		show_fluff(player, "goal", 1)
		show_subfluff(player, "description", 1)
		show_subfluff(player, "faction", 1)
		show_subfluff(player, "role", 1)
		if(choosen_scenario.use_goals)
			show_goals_mob(player)
		spawn_items_role(player)
		spawn_items_faction(player)



/datum/game_mode/scenario/proc/setup_scenario_factions(var/mob/living/carbon/human/player)
	var/mobjob = player.mind.assigned_role

	if(choosen_scenario.no_faction_restrictions)
		var/list/factions = choosen_scenario.faction_list
		while(!player.mind.scenario_faction.len)
			if(!factions.len) //either we ran out of avaible faction slots, or there were no factions set
				player.mind.scenario_faction |= "neutral"
				break
			var/randomfaction = pick(factions) //pick a random faction if the scenario has no faction restrictions for roles
			if(choosen_scenario.max_factionmember_amount.[randomfaction] == null)
				player.mind.scenario_faction |= randomfaction
			else if(choosen_scenario.max_factionmember_amount.[randomfaction] == 0)
				factions -= randomfaction
			else
				choosen_scenario.max_factionmember_amount.[randomfaction]--
				player.mind.scenario_faction |= randomfaction
	else
		if(!choosen_scenario.faction_restrictions.[mobjob])
			player.mind.scenario_faction |= "neutral" //all players without a faction in faction_restrictions only get the neutral faction

		else
			if(choosen_scenario.exclusive_factions) //we are only allowed to pick one faction, so choose a random one
				var/list/factions = choosen_scenario.faction_restrictions.[mobjob]
				while(!player.mind.scenario_faction.len)
					if(!factions.len) //either we ran out of avaible faction slots, or there were no factions set
						player.mind.scenario_faction |= "neutral"
						break
					var/randomfaction = pick(factions)
					if(choosen_scenario.max_factionmember_amount.[randomfaction] == null)
						player.mind.scenario_faction |= randomfaction
					else if(choosen_scenario.max_factionmember_amount.[randomfaction] == 0)
						factions -= randomfaction
					else
						choosen_scenario.max_factionmember_amount.[randomfaction]--
						player.mind.scenario_faction |= randomfaction
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

//anouncing subscenario fluff
/datum/game_mode/scenario/proc/show_subfluff(var/mob/living/carbon/human/player, var/fluff_type, var/save_memory = 1)
	if(!fluff_type)
		return
	switch(fluff_type)
		if("description")
			to_chat(player, "<B>Extra Scenario: [choosen_sub.sub_name]</B>")
			to_chat(player, "[choosen_sub.sub_desc]")
			if(save_memory)
				player.mind.memory += "<B>Extra Scenario: [choosen_sub.sub_name]</B><BR>"
				player.mind.memory += "[choosen_sub.sub_desc]<BR>"
		if("faction")
			for(var/currentfaction in player.mind.scenario_faction)
				var/ff = choosen_sub.sub_factionfluff.[currentfaction]
				if(ff)
					to_chat(player, "[ff]")
					if(save_memory)
						player.mind.memory += "[ff]<BR>"
		if("role")
			var/rf = choosen_sub.sub_rolefluff.[player.mind.assigned_role]
			if(rf)
				to_chat(player, "[rf]")
				if(save_memory)
					player.mind.memory += "[rf]<BR>"

//showing goals to a mob, usually the ones at latejoin/roundstart
/datum/game_mode/scenario/proc/show_goals_mob(var/mob/living/carbon/human/player, var/save_memory = 1)
	for(var/currentfaction in player.mind.scenario_faction)
		var/fg = choosen_scenario.faction_goal_text.[currentfaction]
		if(fg)
			to_chat(player, "<B>Goals:</B>[fg]")
			if(save_memory)
				player.mind.memory += "<B>Goals:</B>[fg]<BR>"


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
		to_chat(player, "<span class='danger'>You have been given [item_name] in your [where] as part of the scenario.")
		if(where == "backpack")
			var/obj/item/weapon/storage/B = player.back
			B.orient2hud(player)
			B.show_to(player)
		return

/*/datum/game_mode/scenario/proc/handlegoals()
	for(var/faction_to_check in choosen_scenario.faction_list)
		if(choosen_scenario.handlegoals(faction_to_check))
			goals.[faction_to_check] = 1
		else
			goals.[faction_to_check] = 0
*/

/datum/game_mode/proc/handle_scenario_latejoin(var/mob/living/carbon/human/player)
	if(!SSticker.mode == "scenario")
		return

/datum/game_mode/proc/announce_end_stats(var/list/submitted_goals)

/datum/game_mode/scenario/announce_end_stats(var/list/submitted_goals)
	..()
	to_chat(world, "<BR><BR><BR><FONT size=3><B>The round has ended.</B></FONT>")
	to_chat(world, "<BR>[GLOB.TAB]Round Duration: <B>[round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[world.time / 100 % 6][world.time / 100 % 10]</B>")
	var/total_players = GLOB.joined_player_list.len
	if(total_players)
		to_chat(world, "<BR>[GLOB.TAB]Total Population: <B>[total_players]</B>")


	for(var/faction_to_check in choosen_scenario.faction_list)
		if(faction_to_check in choosen_scenario.factionnames)
			var/factionname = choosen_scenario.factionnames.[faction_to_check]
			to_chat(world,"<BR><BR><BR><B>[factionname]:</B>")
			to_chat(world,"<BR>The following players were members of [factionname]:")

			for(var/mob/living/carbon/human/player in GLOB.player_list)
				if(faction_to_check in player.mind.scenario_faction)
					to_chat(world,"<BR>[player.mind.key] was [player.name] the [player.job].")

			if(faction_to_check in submitted_goals)
				to_chat(world,"<BR><BR><B>The goals of [factionname] were:</B>")
				for(var/listgoals in submitted_goals.[faction_to_check])
					to_chat(world,"<BR><B>[listgoals]</B>")
	var/ending_text = choosen_scenario.epilogue
	if(ending_text)
		to_chat(world, "<BR><BR><BR><B>[ending_text]</B></FONT>")
	to_chat(world, "<BR><BR><BR>Server restarting in 60 seconds.</FONT>")
	sleep(600)
	world.Reboot("Restarting...", "end", "round_ended")

/datum/game_mode/scenario/handle_scenario_latejoin(var/mob/living/carbon/human/player)
	..()
	setup_scenario_factions(player)
	show_fluff(player, "scenario", 1)
	show_fluff(player, "faction", 1)
	show_fluff(player, "role", 1)
//	show_fluff(player, "goal", 1)
	show_subfluff(player, "description", 1)
	show_subfluff(player, "faction", 1)
	show_subfluff(player, "role", 1)
	if(choosen_scenario.use_goals)
		show_goals_mob(player)
	spawn_items_role(player)
	spawn_items_faction(player)

/datum/game_mode/proc/end_scenario(var/result)
	if(!SSticker.mode == "scenario")
		return

/datum/game_mode/scenario/end_scenario(var/result)
	..()
	if(result)
		initiated_end = 1
	else
		poll_roundend_next = REALTIMEOFDAY + choosen_scenario.extension_lenght