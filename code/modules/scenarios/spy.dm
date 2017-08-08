/datum/scenario/spy

//general stuff
	pickable = 1
	scenario_name = "Spy Battle"
	scenario_desc = "Two groups of spies have infiltrated the mansion. In fact, they did this so well, nobody even knows who is and who isn't part of their own group!"
	min_players = 0
	max_players = 0 //keep 0 to disable this cap
	round_lenght = 120
	extension_lenght = 120

//faction stuff
	faction_list = list("mansion", "spy1", "spy2")
	faction_fluff = list("mansion" = "You have been notified that two groups of spies have infiltrated the mansion. The mansion will lose a large amount of influence if they are allowed to operate: Capture them all! Don't forget: There are some important documents in your vault aswell.", "spy1" = "You are a spy of the Wood Empire, but you cannot say who or even if anyone else is also on your side.", "spy2" = "You are a spy of the Porcelain Empire, but you cannot say who or even if anyone else is also on your side.")
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
	"Gardener" = list("mansion", "spy1", "spy2"),
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
	faction_goal_text = list()

/datum/scenario/spy/handlegoals()
	..()


/datum/scenario/spy/handlescenario()
