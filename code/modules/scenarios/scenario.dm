/datum/scenario/

//general stuff
	var/pickable = 0
	var/scenario_name = "Placeholder title"
	var/scenario_desc = "Description of scenario for all players that enter the round."
	var/min_players = 0
	var/max_players = 0 //keep 0 to disable this cap
	var/list/required_roles = list() //game cannot start unless these are filled
	var/round_lenght = 36000 //time until the round end vote is called in 10ths of a second. 36000 = 1 hour, 600 = 1 minute
	var/extension_lenght = 12000 //time in 10th of second the round is extended if players vote for an extention, 12000 = 20 minutes
	var/epilogue //some story closure displayed at roundend, recommended to manipulate via handlegoals()

//faction stuff
	var/list/faction_list = list()
	var/list/faction_fluff = list()
	var/no_faction_restrictions = 0 //if 1, players are randomly assigned a faction in faction_list and restrictions is completely ignored
	var/exclusive_factions = 1 //if 0, players with a certain job will get all factions in the restriction list, if 1 they are randomly assigned a single faction from that list instead
	var/list/max_factionmember_amount = list() //use this list to limit the amount of members a faction may have, does not work with exclusive_factions 0
	var/list/factionnames = list() //nicer names for factions, any faction in here will have their goals/members displayed at roundend

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

//processing related vars
	var/polling = 0 // 0 = not started, 1 = not started but should run again, 2 = in progress, 3 = all done
	var/inputting = 0
	var/poll_id = 1
	var/input_id = 1
	var/game_ending = 0
	var/ended = 0

	var/list/roundend_inputs_factions = list("input1" = list())
	var/list/roundend_polls_factions = list("poll1" = list())

	var/list/roundend_inputs = list()
	var/list/roundend_polls = list("poll1" = list("question" = "", "answers" = list()))
	var/faction_goal_text = list()


	var/inputnumbers
	var/pollnumbers
	var/list/voteresults = list()
	var/list/inputsgiven = list()
	var/list/inputresults = list()
	var/list/goals_finished = list()

	var/processing_counter = 0

/datum/scenario/process()
	processing_counter++
	if(processing_counter > 5)
		if(!game_ending)
			inputting = 0
			polling = 0
			STOP_PROCESSING(SSobj, src)
			return
		if(inputting == 1)
			var/list/currentinput = roundend_inputs.["input[input_id]"]
			var/questionT = currentinput.["question"]
			var/list/allowed_voters = list()

			if(!roundend_inputs_factions.["input[input_id]"])
				allowed_voters = GLOB.clients
			for(var/mob/living/carbon/human/player in GLOB.player_list)
				for(var/factionT in player.mind.scenario_faction)
					if(factionT in roundend_inputs_factions.["input[input_id]"])
						allowed_voters |= player.client
			if(!allowed_voters)
				inputsgiven = list()
				if(input_id >= inputnumbers) //all polls done, finishing polling
					handle_postinput()
				else
					inputting = 1
					input_id++

			inputting = 2

			for(var/people_inputting in allowed_voters)
				spawn()
					var/entered = stripped_input(people_inputting, questionT)
					if(entered)
						inputsgiven.Add(entered)
			spawn(150)
				inputresults.Add("input[input_id]")
				inputresults.["input[input_id]"] = inputsgiven
				inputsgiven = list()
				inputting = 1


				if(input_id >= inputnumbers) //all polls done, finishing polling
					handle_postinput()
				else
					inputting = 1
					input_id++

		if(polling == 1 && inputting == 3)
			var/list/currentpoll = roundend_polls.["poll[poll_id]"]
			var/questionT = currentpoll.["question"]
			var/list/answersT = currentpoll.["answers"]
			var/list/vote = list("question" = questionT,"answers" = answersT)
			var/list/allowed_voters = list()

			if(!roundend_polls_factions.["poll[poll_id]"])
				allowed_voters = GLOB.clients
			for(var/mob/living/carbon/human/player in GLOB.player_list)
				for(var/factionT in player.mind.scenario_faction)
					if(factionT in roundend_polls_factions.["poll[poll_id]"])
						allowed_voters |= player.client
			if(allowed_voters)
				SSvote.initiate_vote("scenario input", "", vote, allowed_voters)
				polling = 2
			else
				if(poll_id >= pollnumbers) //all polls done, finishing polling
					polling = 3
				else
					polling = 1
					poll_id++

		if(polling == 3 && inputting == 3 && !ended)
			ended = 1
			handlegoals()

		processing_counter = 0


/datum/scenario/proc/handle_vote_result(var/list/winning_vote)
	var/winner = pick(winning_vote)
	voteresults.Add("poll[poll_id]")
	voteresults.["poll[poll_id]"] = winner


	if(poll_id >= pollnumbers) //all polls done, finishing polling
		polling = 3
	else
		polling = 1
		poll_id++

/datum/scenario/proc/handle_end()
	if(!roundend_inputs.len) //if there are no inputs, skip this
		inputting = 3
	else
		for(var/A in roundend_inputs)
			inputnumbers++
		inputting = 1
	if(!roundend_polls.len) //if there are no polls, skip it too
		polling = 3
	else
		for(var/A in roundend_polls)
			pollnumbers++
		polling = 1
	game_ending = 1
	START_PROCESSING(SSobj, src)


/datum/scenario/proc/handlegoals()
//this is where you can put more complex goal completion checks for a scenario


	SSticker.mode.announce_end_stats(goals_finished)



/datum/scenario/proc/handlescenario()
//if you want to randomize or calculate stuff for a scenario you can do it here, this is called before the scenario is set up

/datum/scenario/proc/handlescenario_postsetup()
//this gets called after setup is completed, in case you want more complex scenario custimization still

/datum/scenario/proc/handle_postinput()
//this is called after all inputs were

	inputting = 3