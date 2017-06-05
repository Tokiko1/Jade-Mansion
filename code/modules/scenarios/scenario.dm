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
	var/exclusive_factions = 1 //if 0, players with a certain job will get all factions in the restriction list, if 1 they are randomly assigned a single faction from that list instead
	var/list/max_factionmember_amount = list() //use this list to limit the amount of members a faction may have, does not work with exclusive_factions 0

//faction restriction for roles
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
	"Guest" = list(),
	"Guard" = list(),
	"Assistant" = list()
	)
//role fluff
//if you want certain roles to have a special message at the start, add it here
//highly recommended for custom jobs!
	var/list/role_fluff = list(
	"Head Maid" = "",
	"Mansion Owner" = "",
	"Custom 1" = "",
	"Custom 2" = "",
	"Custom 3" = "",
	"Downstairs Maid" = "",
	"Upstairs Maid" = "",
	"Gardener" = "",
	"Guard" = "",
	"Guest" = "",
	"Assistant" = ""
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
	var/use_goals = 1 //0 = goals are unused not announced, 1 = goals are used and will be announced
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
	var/list/custom_job1_items = list()

	var/custom_job2_allowed = 0
	var/custom_job2_amount = 0
	var/custom_job2_name = "Placeholder job."
	var/list/custom_job2_items = list()

	var/custom_job3_allowed = 0
	var/custom_job3_amount = 0
	var/custom_job3_name = "Placeholder job."
	var/list/custom_job3_items = list()

//sub scenarios, loads from a different file
	var/sub_scenario_allowed = 1
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

/datum/scenario/proc/handlegoals(var/faction_to_check)
//this is where you can put more complex goal completion checks for a scenario

/datum/scenario/proc/handlescenario()
//if you want to randomize or calculate stuff for a scenario you can do it here, this is called before the scenario is set up
