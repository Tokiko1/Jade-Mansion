/datum/scenario/

//general stuff
	var/pickable = 0
	var/scenario_name = "Placeholder title"
	var/scenario_desc = "Description of scenario for all players that enter the round."
	var/min_players = 0
	var/max_players = 0 //keep 0 to disable this cap
	var/list/required_roles = list() //game cannot start unless these are filled

//faction stuff
	var/list/faction_list = list()
	var/list/faction_fluff = list()
	var/no_faction_restrictions = 0 //if 1, players are randomly assigned a faction in faction_list and restrictions is completely ignored
	var/exclusive_factions = 0 //if 0, players with a certain job will get all factions in the restriction list, if 1 they are randomly assigned a single faction from that list instead

//faction restriction for roles
	var/list/headmaid_faction_restriction = list()
	var/list/mansionowner_faction_restriction = list()
	var/list/custom1_faction_restriction = list()
	var/list/custom2_faction_restriction = list()
	var/list/custom3_faction_restriction = list()
	var/list/butler_faction_restriction = list()
	var/list/downstairsmaid_faction_restriction = list()
	var/list/upstairsmaid_faction_restriction = list()
	var/list/gardener_faction_restriction = list()
	var/list/guard_faction_restriction = list()
	var/list/betweenmaid_faction_restriction = list()

	var/list/faction_restrictions = list(
	"Head Maid" = list(),
	"Mansion Owner" = list(),
	"Custom 1" = list(),
	"Custom 2" = list(),
	"Custom 3" = list(),
	"Butler" = list(),
	"Downstairs Maid" = list(),
	"Upstairs Maid" = list(),
	"Gardener" = list(),
	"Guard" = list(),
	"Assistant" = list()
	)

//other stuff
	var/special1 = 0
	var/special2 = 0


//player stuff
	var/list/player_fluff = list()


//things that need to be spawned, usually items
	var/list/landmark_spawns = list()
	var/list/role_spawns = list()
	var/list/faction_spawns = list()

//goals
	var/list/faction_goal_text = list()
	var/list/faction_goal_amounts = list()
	var/list/faction_goals = list()

//maps and stuff
	var/restrictmap = 0// 0 = all maps are allowed, 1 = only maps in the list are allowed, 2 = all maps not in the list are allowed
	var/list/maplist = list()

//custom jobs
	var/custom_job1_allowed = 0
	var/custom_job1_amount = 0
	var/custom_job1_name = "Placeholder job."
	var/custom_job1_fluff = ""
	var/list/custom_job1_items = list()

	var/custom_job2_allowed = 0
	var/custom_job2_amount = 0
	var/custom_job2_name = "Placeholder job."
	var/custom_job2_fluff = ""
	var/list/custom_job2_items = list()

	var/custom_job3_allowed = 0
	var/custom_job3_amount = 0
	var/custom_job3_name = "Placeholder job."
	var/custom_job3_fluff = ""
	var/list/custom_job3_items = list()

//sub scenarios, loads from a different file
	var/sub_scenario_allowed = 0
	var/list/sub_scenario = list()
	var/list/sub_scenario_probabilities = list()

//round end inputs
	var/allow_roundend_input = 0
	var/unchecked_input = 0 //disables checks and simply displays answer, for when you want questions that can't be checked with code
	var/list/roundend_input_factions = list() //who gets to input stuff?
	var/list/roundend_input_amounts = list() //how many inputs?
	var/list/roundend_input_types = list() //what kind of inputs?
	var/list/roundend_input_questiontext = list() //question that is displayed during inputs
	var/list/roundend_input_inputtext = list() //if there are pick options, use this text
	var/list/roundend_input_check = list() //how to check if each input was correct?




