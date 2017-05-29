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
	setup_all_scenario_factions()
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


/datum/game_mode/scenario/proc/setup_all_scenario_factions()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		setup_scenario_factions(player)

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



//spawning items on the landmarks
/datum/game_mode/scenario/proc/spawn_items_landmarks()
	var/scenario_spawns = choosen_scenario.landmark_spawns
	for(var/obj/L in GLOB.landmarks_list)
		var/itempath = scenario_spawns[L.name]
		if(itempath)
			new itempath(get_turf(L))

//spawning items
/datum/game_mode/scenario/proc/spawn_items_faction()

/datum/game_mode/proc/handle_scenario_latejoin(var/mob/living/carbon/human/player)
	if(!SSticker.mode == "scenario")
		return

/datum/game_mode/scenario/handle_scenario_latejoin(var/mob/living/carbon/human/player)
	..()
	setup_scenario_factions(player)
