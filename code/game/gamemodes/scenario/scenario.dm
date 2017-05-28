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

//spawning items on the landmarks
/datum/game_mode/scenario/proc/spawn_items_landmarks()
	var/scenario_spawns = choosen_scenario.landmark_spawns
	for(var/obj/L in GLOB.landmarks_list)
		var/itempath = scenario_spawns[L.name]
		if(itempath)
			new itempath(get_turf(L))

//spawning items
/datum/game_mode/scenario/proc/spawn_items_faction()