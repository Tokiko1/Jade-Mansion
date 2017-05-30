/datum/scenario/example

//general stuff
	pickable = 1
	scenario_name = "Example Scenario"
	scenario_desc = "This is an example scenario in which there are two factions: Staff and Owners and Owners posing as Staff"
	min_players = 0
	max_players = 0 //keep 0 to disable this cap
	required_roles = list(mansionowner = 1) //game cannot start unless these are filled

//faction stuff
	faction_list = list("owner", "staff", "posing_staff")
	faction_fluff = list("owner" = "You are a mansion owner! You own this mansion!", "staff" = "You work as a staff member here.", "posing_staff" = "You are pretending to be a staff member but are actually a mansion owner too!")
	no_faction_restrictions = 0 //if 1, players are randomly assigned a faction in faction_list and restrictions is completely ignored
	exclusive_factions = 1 //if 0, players with a certain job will get all factions in the restriction list, if 1 they are randomly assigned a single faction from that list instead

//faction restriction for roles
	faction_restrictions = list(
	"Head Maid" = list("staff", "posing_staff"),
	"Mansion Owner" = list("owner"),
	"Custom 1" = list(),
	"Custom 2" = list(),
	"Custom 3" = list(),
	"Butler" = list("staff", "posing_staff"),
	"Downstairs Maid" = list("staff", "posing_staff"),
	"Upstairs Maid" = list("staff", "posing_staff"),
	"Gardener" = list("staff", "posing_staff"),
	"Guard" = list("staff", "posing_staff"),
	"Assistant" = list("staff", "posing_staff")
	)
//role fluff
	role_fluff = list(
	"Head Maid" = "This is an example text that only shows up if you picked Head Maid as your role!",
	"Mansion Owner" = "",
	"Custom 1" = "",
	"Custom 2" = "",
	"Custom 3" = "",
	"Downstairs Maid" = "",
	"Upstairs Maid" = "",
	"Gardener" = "",
	"Guard" = "",
	"Assistant" = ""
	)
//other stuff
	special1 = 0
	special2 = 0


//player stuff
	player_fluff = list()


//things that need to be spawned, usually items
	landmark_spawns = list(secure_storage_spawn1 = /obj/item/doorkey/master, secure_storage_spawn2 = /obj/item/device/laser_pointer)
	role_spawns = list("Head Maid" = list(/obj/item/doorkey/master, /obj/item/doorkey/master), "Mansion Owner" = list(/obj/item/doorkey/master, /obj/item/doorkey/master))
	faction_spawns = list("posing_staff" = list(/obj/item/doorkey/master, /obj/item/doorkey/master))

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
	custom_job1_items = list()

	custom_job2_allowed = 0
	custom_job2_amount = 0
	custom_job2_name = "Placeholder job."
	custom_job2_items = list()

	custom_job3_allowed = 0
	custom_job3_amount = 0
	custom_job3_name = "Placeholder job."
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




