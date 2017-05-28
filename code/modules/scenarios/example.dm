/datum/scenario/example

//general stuff
	pickable = 1
	scenario_name = "Example Scenario"
	scenario_desc = "This is an example scenario in which there are two factions: Staff and Owners."
	min_players = 0
	max_players = 0 //keep 0 to disable this cap
	required_roles = list(mansionowner = 1) //game cannot start unless these are filled

//faction stuff
	faction_list = list()
	faction_fluff = list()

//faction restriction for roles
	headmaid_faction_restriction = list()
	mansionowner_faction_restriction = list()
	custom1_faction_restriction = list()
	custom2_faction_restriction = list()
	custom3_faction_restriction = list()
	butler_faction_restriction = list()
	downstairsmaid_faction_restriction = list()
	upstairsmaid_faction_restriction = list()
	gardener_faction_restriction = list()
	guard_faction_restriction = list()
	betweenmaid_faction_restriction = list()

//other stuff
	special1 = 0
	special2 = 0


//player stuff
	player_fluff = list()


//things that need to be spawned, usually items
	landmark_spawns = list(secure_storage_spawn1 = /obj/item/doorkey/master, secure_storage_spawn2 = /obj/item/device/laser_pointer)
	role_spawns = list()
	faction_spawns = list()

//goals
	faction_goal_text = list()
	faction_goal_amounts = list()
	faction_goals = list()

//maps and stuff
	restrictmap = 0// 0 = all maps are allowed, 1 = only maps in the list are allowed, 2 = all maps not in the list are allowed
	maplist = list()

//custom jobs
	custom_job1_allowed = 0
	custom_job1_amount = 0
	custom_job1_name = "Placeholder job."
	custom_job1_fluff = ""
	custom_job1_items = list()

	custom_job2_allowed = 0
	custom_job2_amount = 0
	custom_job2_name = "Placeholder job."
	custom_job2_fluff = ""
	custom_job2_items = list()

	custom_job3_allowed = 0
	custom_job3_amount = 0
	custom_job3_name = "Placeholder job."
	custom_job3_fluff = ""
	custom_job3_items = list()

//sub scenarios, loads from a different file
	sub_scenario_allowed = 0
	sub_scenario = list()
	sub_scenario_probabilities = list()

//round end inputs
	allow_roundend_input = 0
	unchecked_input = 0 //disables checks and simply displays answer, for when you want questions that can't be checked with code
	roundend_input_factions = list() //who gets to input stuff?
	roundend_input_amounts = list() //how many inputs?
	roundend_input_types = list() //what kind of inputs?
	roundend_input_questiontext = list() //question that is displayed during inputs
	roundend_input_inputtext = list() //if there are pick options, use this text
	roundend_input_check = list() //how to check if each input was correct?




