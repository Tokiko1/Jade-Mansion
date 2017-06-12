/datum/scenario/important_guest

	pickable = 1
	scenario_name = "A very important guest"
	scenario_desc = "A very influential guest is visiting the mansion. Everyone at the mansion tries their best to make sure they enjoy their visit... except perhaps one?"
	min_players = 0
	max_players = 0
	required_roles = list("mansion", "vip")
	round_lenght = 36000
	extension_lenght = 12000

	faction_list = list("mansion", "vip", "backstabber")
	faction_fluff = list("mansion" = "You are part of the mansion group! You all want this meeting to go very well, try your best to keep the guest happy.", "vip" = "You are an influential guest visiting this mansion. If the mansion owners fail to provide an enjoyable evening for you, they'll have to deal with the consequences.", "backstabber" = "You are a member of the mansion, but you dislike them all! You want to quit your job anyway and messing up this meeting is a perfect way to get your revenge. Make sure the guest has an awful evening!")
	no_faction_restrictions = 0
	exclusive_factions = 1
	max_factionmember_amount =list("backstabber" = 1)
	factionnames = list("mansion" = "Mansion", "vip" = "Important Guest", "backstabber" = "Disgruntled Staff")

	faction_restrictions = list(
	"Head Maid" = list("mansion"),
	"Mansion Owner" = list("mansion"),
	"Custom 1" = list(),
	"Custom 2" = list(),
	"Custom 3" = list(),
	"Butler" = list("mansion", "backstabber"),
	"Downstairs Maid" = list("mansion", "backstabber"),
	"Upstairs Maid" = list("mansion", "backstabber"),
	"Gardener" = list("mansion", "backstabber"),
	"Guest" = list("vip"),
	"Guard" = list("mansion", "backstabber"),
	"Assistant" = list("mansion", "backstabber")
	)

	roundend_inputs_factions = list()
	roundend_polls_factions = list("poll1" = list("vip"))

	roundend_inputs = list()
	roundend_polls = list("poll1" = list("question" = "Did you enjoy your stay?", "answers" = list("Yes", "No")))
	faction_goal_text = list("mansion" = "Make sure the guest(s) enjoys their stay!", "backstabber" = "Make sure the guest(s) don't enjoy themselves!")


/datum/scenario/important_guest/handlegoals()
	var/stuff1 = pick(voteresults.["poll1"])
	if(stuff1 == "Yes")
		goals_finished = list("mansion" = list("Goal: Make sure the guest(s) enjoys their stay! <font color='green'>Success!</font>"), "backstabber" = list("Goal: Make sure the guest(s) does not enjoy themselves. <font color='red'>Failed.</font>"))
		epilogue = "And so the mansion expanded its influence over the nearby prefectures and the staff members were luxuriously awarded for their good work."
	else
		goals_finished = list("mansion" = list("Goal: Make sure the guest(s) enjoys their stay! <font color='red'>Failed.</font>"), "backstabber" = list("Goal: Make sure the guest(s) does not enjoy themselves. <font color='green'>Success!</font>"))
		epilogue = "And so, the mansions influence in the prefecture decreased..."
	..()