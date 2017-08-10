/datum/scenario/spy

//general stuff
	pickable = 1
	scenario_name = "Spy Battle"
	scenario_desc = "Two groups of spies have infiltrated the mansion. In fact, they did this so well, nobody even knows who is and who isn't part of their own group!"
	min_players = 0
	max_players = 0 //keep 0 to disable this cap
	round_lenght = 48000
	extension_lenght = 6000

//faction stuff
	faction_list = list("mansion", "spy1", "spy2")
	faction_fluff = list("mansion" = "You are a mansion loyalist. You have been notified that two groups of spies have infiltrated the mansion. The mansion will lose a large amount of influence if they are allowed to operate: Capture them all! Don't forget: There are some important documents in your vault aswell.", "spy1" = "You are a spy of the Wood Empire, but you cannot say who or even if anyone else is also on your side.", "spy2" = "You are a spy of the Porcelain Empire, but you cannot say who or even if anyone else is also on your side.")
	no_faction_restrictions = 0 //if 1, players are randomly assigned a faction in faction_list and restrictions is completely ignored
	exclusive_factions = 1 //if 0, players with a certain job will get all factions in the restriction list, if 1 they are randomly assigned a single faction from that list instead
	max_factionmember_amount =list("spy1" = 2, "spy2" = 2)
	factionnames = list("mansion" = "Mansion", "spy1" = "Wood Empire Spy Cell", "spy2" = "Porcelain Empire Spy Cell")
	epilogue = "And so the conflict between spies comes to an end here, for now..."

//faction restriction for roles
	faction_restrictions = list(
	"Head Maid" = list("mansion","mansion","mansion","mansion","mansion","mansion", "spy1", "spy2"),
	"Mansion Owner" = list("mansion"),
	"Custom 1" = list(),
	"Custom 2" = list(),
	"Custom 3" = list(),
	"Butler" = list("mansion", "spy1", "spy2", "spy1", "spy2"),
	"Downstairs Maid" = list("mansion", "spy1", "spy2", "spy1", "spy2"),
	"Upstairs Maid" = list("mansion", "spy1", "spy2", "spy1", "spy2"),
	"Gardener" = list("mansion", "spy1", "spy2", "spy1", "spy2"),
	"Guest" = list("mansion", "spy1", "spy2", "spy1", "spy2"),
	"Guard" = list("mansion", "spy1", "spy2"),
	"Assistant" = list("mansion", "spy1", "spy2", "spy1", "spy2")
	)
//role fluff

//other stuff
	special1 = 0
	special2 = 0


//player stuff


//things that need to be spawned, usually items
	landmark_spawns = list(secure_storage_spawn1 = /obj/effect/jade_spawner/fake_document)
	faction_spawns = list("spy1" = list(/obj/effect/jade_spawner/spyboxes), "spy2" = list(/obj/effect/jade_spawner/spyboxes) )

//goals
	faction_goal_text = list("mansion" = "Capture all spies. Put them in remote collars, to sleep or restrain them in any other way!",
	"spy1" = "Recover the most recorders, secure the most real blueprints from the spy caches and try to steal the most real documents.",
	"spy2" = "Recover the most recorders, secure the most real blueprints from the spy caches and try to steal the most real documents."
	)
	var/number_recorders
	var/number_caches


/datum/scenario/spy/handlegoals()
	var/uncapture_spies_in_mansion = 0//lets check if there are no uncaptured spies first
	var/list/mansiongoals = list()
	var/list/spy1goals = list()
	var/list/spy2goals = list()


	for(var/mob/living/carbon/human/humanS)
		if(("spy1" in humanS.mind.scenario_faction) || ("spy2" in humanS.mind.scenario_faction))
			if(!humanS.stat && !humanS.restrained() && !(istype(humanS.wear_neck, /obj/item/clothing/neck/remote_collar)))
				uncapture_spies_in_mansion++
	//add check here


	var/spy1_recorders
	var/spy1_blueprints
	var/spy1_real_documents

	var/spy2_recorders
	var/spy2_blueprints
	var/spy2_real_documents

	if(!uncapture_spies_in_mansion)
		mansiongoals.Add("Goal: Stop the spy cells! <font color='green'>Success!.</font>.")
		spy1goals.Add("Goal: Don't get captured! <font color='red'>Failure.</font>.")
		spy2goals.Add("Goal: Don't get captured! <font color='red'>Failure.</font>.")
		goals_finished.["mansion"] = mansiongoals
		goals_finished.["spy1"] = spy1goals
		goals_finished.["spy2"] = spy2goals
		..()
		return


	if(uncapture_spies_in_mansion) //I'm sure you could make these checks denser and faster but lets keep it readable for now
		for(var/mob/living/carbon/human/humanS)
			if("spy1" in humanS.mind.scenario_faction)
				for(var/obj/item/device/spy_device/recorder/recorderS in humanS.GetAllContents()) //get all recorders
					spy1_recorders++
				for(var/obj/item/documents/espionage/blueprints/blueprintsS in humanS.GetAllContents()) //get all REAL blueprints
					if(blueprintsS.authentic_documents)
						spy1_blueprints++
				for(var/obj/item/documents/documentS in humanS.GetAllContents()) //get all real documents
					if(documentS.authentic_documents && !istype(documentS, /obj/item/documents/espionage/blueprints)) //blueprints dont count towards this goal
						spy1_real_documents++

			if("spy2" in humanS.mind.scenario_faction)
				for(var/obj/item/device/spy_device/recorder/recorderS in humanS.GetAllContents())
					spy2_recorders++
				for(var/obj/item/documents/espionage/blueprints/blueprintsS in humanS.GetAllContents())
					if(blueprintsS.authentic_documents)
						spy2_blueprints++
				for(var/obj/item/documents/documentS in humanS.GetAllContents())
					if(documentS.authentic_documents && !istype(documentS, /obj/item/documents/espionage/blueprints)) //blueprints dont count towards this goal
						spy2_real_documents++

	var/spy1points
	var/spy2points



	if(spy1_recorders > spy2_recorders) //spy 1 won
		spy1points++
		spy1goals.Add("Goal: Secure the most recorders. <font color='green'>Success!</font>.")
		spy2goals.Add("Goal: Secure the most recorders. <font color='red'>Failure.</font>.")

	else if(spy1_recorders == spy2_recorders) //tie
		spy1points++
		spy2points++
		spy1goals.Add("Goal: Secure the most recorders. <font color='jadegreen'>Tied!.</font>.")
		spy2goals.Add("Goal: Secure the most recorders. <font color='jadegreen'>Tied!.</font>.")

	else //spy 2 won
		spy2points++
		spy1goals.Add("Goal: Secure the most recorders. <font color='red'>Failure.</font>.")
		spy2goals.Add("Goal: Secure the most recorders. <font color='green'>Success!</font>.")
///////////////////////
	if(spy1_blueprints > spy2_blueprints)
		spy1points++
		spy1goals.Add("Goal: Secure the most authentic blueprints. <font color='green'>Success!</font>.")
		spy2goals.Add("Goal: Secure the most authentic blueprints. <font color='red'>Failure.</font>.")

	else if(spy1_blueprints == spy2_blueprints)
		spy1points++
		spy2points++
		spy1goals.Add("Goal: Secure the most authentic blueprints. <font color='jadegreen'>Tied!</font>.")
		spy2goals.Add("Goal: Secure the most authentic blueprints. <font color='jadegreen'>Tied!</font>.")

	else
		spy2points++
		spy2goals.Add("Goal: Secure the most authentic blueprints. <font color='green'>Success!</font>.")
		spy1goals.Add("Goal: Secure the most authentic blueprints. <font color='red'>Failure.</font>.")
///////////////////////
	if(spy1_real_documents > spy2_real_documents)
		spy1points++
		spy1goals.Add("Goal: Steal and keep the most real documents. <font color='green'>Success!</font>.")
		spy2goals.Add("Goal: Steal and keep the most real documents. <font color='red'>Failure.</font>.")

	else if(spy1_real_documents == spy2_real_documents)
		spy1points++
		spy2points++
		spy1goals.Add("Goal: Steal and keep the most real documents. <font color='jadegreen'>Tied!</font>.")
		spy2goals.Add("Goal: Steal and keep the most real documents. <font color='jadegreen'>Tied!</font>.")


	else
		spy2points++
		spy2goals.Add("Goal: Steal and keep the most real documents. <font color='green'>Success!</font>.")
		spy1goals.Add("Goal: Steal and keep the most real documents. <font color='red'>Failure.</font>.")

	if(spy1points > spy2points)
		spy1goals.Add("Goal: Have your spy team succeed! <font color='green'>Success!.</font>.")
		spy2goals.Add("Goal: Have your spy team succeed! <font color='red'>Failure.</font>.")
		epilogue = "And so the Wood Empire has won yet another victory in the battle of espionage!"
	else if(spy1points == spy2points)
		spy1goals.Add("Goal: Have your spy team succeed! <font color='jadegreen'>Tied!</font>.")
		spy2goals.Add("Goal: Have your spy team succeed! <font color='red'>Tied!</font>.")
		epilogue = "Despite best efforts from everyone, the battle between spies will still rage on in this mansion."
	else
		spy2goals.Add("Goal: Have your spy team succeed! <font color='green'>Success!.</font>.")
		spy1goals.Add("Goal: Have your spy team succeed! <font color='red'>Failure.</font>.")
		epilogue = "The Porcelain Empire wins yet another victory in the battle of espionage!"

	mansiongoals.Add("Goal: Stop the spy cells! <font color='red'>Failure.</font>.")

	goals_finished.["mansion"] = mansiongoals
	goals_finished.["spy1"] = spy1goals
	goals_finished.["spy2"] = spy2goals
	..()
	return

/datum/scenario/spy/handlescenario()
	number_recorders = pick(5, 7, 9, 12)
	number_caches = pick(3, 5)
	..()
/datum/scenario/spy/handlescenario_postsetup()
	var/list/turfS = list()
	for(var/area/inside/Ar in world)
		for(var/turf/T in Ar)
			if(T.density || T.z_open)
				continue
			turfS.Add(T)


	for(var/i in 1 to number_recorders)
		var/turf/where_spawn = pick(turfS)
		var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
		var/list/listA = list(/obj/item/device/spy_device/recorder)
		SP.setup(listA, (rand(6000,24000)), 1, 0)

	var/number_of_fake_caches
	if(prob(50))
		number_of_fake_caches = 2
	number_caches = number_caches - number_of_fake_caches

	for(var/i in 1 to number_caches)
		var/turf/where_spawn = pick(turfS)
		var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
		var/list/listA = list(/obj/structure/spystructure/spycache)
		SP.setup(listA, (rand(6000,24000)), 1, 0)
	if(number_of_fake_caches)
		for(var/i in 1 to number_of_fake_caches)
			var/turf/where_spawn = pick(turfS)
			var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
			var/list/listA = list(/obj/structure/spystructure/spycache/fake)
			SP.setup(listA, (rand(6000,24000)), 1, 0)