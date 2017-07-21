/datum/scenario/hiring

	pickable = 1
	scenario_name = "Hiring New Staff"
	scenario_desc = "The mansion is hiring new staff. Will people succeed in being hired?"
	min_players = 0
	max_players = 0
	required_roles = list("mansion", "jobseeker")
	round_lenght = 36000
	extension_lenght = 12000

	faction_list = list("mansion", "jobseeker")
	faction_fluff = list("mansion" = "You are part of the mansion. Test the skills of the new potential employees and then judge them! Or maybe you will come up with unreasonable requests and interview questions?", "jobseeker" = "You wish to be hired! Pick a job and then successfully complete the trials the mansion presents you!")
	no_faction_restrictions = 0
	exclusive_factions = 1
	factionnames = list("mansion" = "Mansion Owners and Staff", "jobseeker" = "Potential New Staff")

	faction_restrictions = list(
	"Head Maid" = list("mansion"),
	"Mansion Owner" = list("mansion"),
	"Custom 1" = list(),
	"Custom 2" = list(),
	"Custom 3" = list(),
	"Butler" = list("mansion"),
	"Downstairs Maid" = list("mansion"),
	"Upstairs Maid" = list("mansion"),
	"Gardener" = list("mansion"),
	"Guest" = list("jobseeker"),
	"Guard" = list("mansion"),
	"Assistant" = list("mansion")
	)

 role_fluff = list(
	"Head Maid" = "",
	"Mansion Owner" = "As the owner of the mansion, it is in your best interest to pick good staff. Come up with tests and trials for those that are applying for a job.",
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

	roundend_inputs_factions = list()

	roundend_inputs = list()
	faction_goal_text = list("mansion" = "Give all the job seekers a difficult trial and hire the best! Or all of them...", "jobseeker" = "Get hired!")

	var/list/listofjobseekersID = list()

//nobody cares for functionality like this... yet. I'll make it work someday

/*/datum/scenario/hiring/handlescenario_postsetup()
	var/currentpoll = 1
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		message_admins("Test1")
		if(player.mind.scenario_faction == "jobseeker")
			message_admins("Test2")
			var/list/listT = list("poll[currentpoll]" = list("question" = "Did you decide to hire [player.name]?", "answers" = list("Yes", "No")))
			roundend_polls.Add(listT)
			var/list/listF = list("poll[currentpoll]" = list("mansion"))
			roundend_polls_factions.Add(listF)
			var/list/listjID = list("[player.name]" = currentpoll)
			listofjobseekersID.Add(listjID)
			currentpoll++
	..()


/datum/scenario/hiring/handlegoals()
	var/newhires = FALSE
	for(var/votee in listofjobseekersID)
		var/voteIDF = listofjobseekersID[votee]
		if(voteresults["poll[voteIDF]" == "Yes"])
			var/list/listhiresuccess = list("[votee]'s Goal: Get hired! <font color='green'>Success!</font>")
			goals_finished["jobseeker"] += listhiresuccess
			newhires = TRUE
		else
			var/list/listfailedhire = list("[votee]'s Goal: Get hired! <font color='red'>Failed.</font>")
			goals_finished["jobseeker"] += listfailedhire

	if(newhires == TRUE)
		epilogue = "And so, the mansion welcomes its new staff members!"
	else
		epilogue = "And so, it seems that nothing much has changed in the mansion as nobody new was hired."


	..()*/