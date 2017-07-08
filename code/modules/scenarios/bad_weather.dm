/datum/scenario/bad_weather

	pickable = 1
	scenario_name = "Bad Weather"
	scenario_desc = "For the entire past week, rain has been pouring from the sky. And it doesn't look like it's going to stop anytime soon according to the weather forecasts. The road to the mansion might become damaged soon enough..."
	min_players = 0
	max_players = 0
	required_roles = list("mansion")
	round_lenght = 48000 //80 minutes
	extension_lenght = 12000

	faction_list = list("mansion")
	faction_fluff = list("mansion" = "You are part of the mansion group! It's time to stockpile on food, raw vegetables, wooden planks! Beware the pests that will be attracted to the dry, warm comfort of the mansion. ")
	no_faction_restrictions = 1
	exclusive_factions = 0
	max_factionmember_amount =list()
	factionnames = list("mansion" = "Mansion",)

	roundend_inputs_factions = list()
	roundend_polls_factions = list()

	roundend_inputs = list()
	roundend_polls = list()
	faction_goal_text = list("mansion" = "", )

	role_fluff = list(
	"Head Maid" = "",
	"Mansion Owner" = "",
	"Custom 1" = "",
	"Custom 2" = "",
	"Custom 3" = "",
	"Downstairs Maid" = "",
	"Upstairs Maid" = "",
	"Gardener" = "",
	"Guard" = "",
	"Guest" = "You are a good friend of the mansion so you have decided to pay them a visit and help them stockpile stuff while at it.",
	"Assistant" = ""
	)

	var/maxdirt = 10
	var/number_foods
	var/number_raw
	var/number_wood
	var/micebots
	var/infestation
	var/maxinfestation = 5

/datum/scenario/bad_weather/handlegoals()
	var/list/goalchecklist = list()
	var/foodcount
	for(var/obj/item/weapon/reagent_containers/food/snacks/food_A in world)
		if(istype(get_area(food_A), /area/inside/freezer))
			if(!istype(food_A, /obj/item/weapon/reagent_containers/food/snacks/grown))
				foodcount++

	if(foodcount >= number_foods)
		goalchecklist.Add("Goal: Store [number_foods] amount of food. <font color='green'>Success!</font> Stored [foodcount].")
	else
		goalchecklist.Add("Goal: Store [number_foods] amount of food. <font color='red'>Failed!</font> Stored [foodcount].")

	var/rawcount
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/rawA in world)
		if(istype(get_area(rawA), /area/inside/freezer))
			rawcount++

	if(rawcount >= number_raw)
		goalchecklist.Add("Goal: Store [number_raw] amount of raw edible plants. <font color='green'>Success!</font> Stored [rawcount].")
	else
		goalchecklist.Add("Goal: Store [number_raw] amount of raw edible plants. <font color='red'>Failed!</font> Stored [rawcount].")

	var/woodcount
	for(var/obj/item/stack/sheet/mineral/wood/woodA in world)
		if(istype(get_area(woodA), /area/inside/storage))
			woodcount = woodcount + woodA.amount

	if(woodcount >= number_wood)
		goalchecklist.Add("Goal: Store [number_wood] amount of wood. <font color='green'>Success!</font> Stored [woodcount].")
	else
		goalchecklist.Add("Goal: Store [number_wood] amount of wood. <font color='red'>Failed!</font> Stored [woodcount].")


	var/dirtS
//	for(var/obj/item/trash/a in /area/inside)
//		trash_and_dirt++
	for(var/obj/effect/decal/cleanable/b in world)
		if(istype(get_area(b), /area/inside))
			dirtS++
	for(var/obj/effect/decal/cleanable/b in world)
		if(istype(get_area(b), /area/inside))
			dirtS++

	if(dirtS <= maxdirt)
		goalchecklist.Add("Goal: Keep the mansion clean. <font color='green'>Success!</font>.")
	else
		goalchecklist.Add("Goal: Keep the mansion clean. <font color='red'>Failed!</font> There were [dirtS] tiles's worth of dirt.")

	var/infestationS
	var/mousebots
	var/silktree
	var/silkwebs
	for(var/mob/living/simple_animal/mousebot/mouseB in world)
		if(istype(get_area(mouseB), /area/inside))
			infestationS++
			mousebots++
	for(var/obj/structure/silktree/web/silkB in world)
		if(istype(get_area(silkB), /area/inside))
			infestationS++
			silkwebs++
	for(var/obj/structure/silktree/tree/silkC in world)
		if(istype(get_area(silkC), /area/inside))
			infestationS++
			silktree++


	if(infestationS <= maxinfestation)
		goalchecklist.Add("Goal: Keep the mansion free from infestations and pests. <font color='green'>Success!</font>.")
	else
		goalchecklist.Add("Goal: Keep the mansion free from infestations and pests. <font color='red'>Failed!</font> There were [mousebots] mousebots, [silkwebs] silk cobwebs and [silktree] silktrees still inside the mansion!")



	goals_finished.["mansion"] = goalchecklist



	..()

/datum/scenario/bad_weather/handlescenario()
	number_foods = pick(10, 15, 20)
	number_raw = pick(20,30,40)
	number_wood = pick(40,80,100)
	micebots = pick("Large", "Balanced", "Many")
	infestation = pick("Nest", "Normal", "Many")

	faction_goal_text = list("mansion" = "Cook and store atleast [number_foods] meals and additionally atleast [number_raw] edible plants and vegetables in the freezer. Store [number_wood] amount of wooden planks in any of the storage rooms. Also, keep an eye out for pests and infestations! Don't let them stay in the mansion and clean up if they cause a mess.")
	..()

/datum/scenario/bad_weather/handlescenario_postsetup()
	var/delayA = 9000 //15 minutes or 9000 milisecods before stuff goes to hell... on average atleast

	var/list/turfS = list()
	for(var/area/inside/Ar in world)
		for(var/turf/T in Ar)
			if(T.density || T.z_open)
				continue
			turfS.Add(T)

	var/spawningstuff = 0

	switch(micebots)

		if("Large")
			for(spawningstuff = 0, spawningstuff < 20, spawningstuff++)
				var/turf/where_spawn = pick(turfS)
				var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
				var/list/listA = list(/mob/living/simple_animal/mousebot)
				SP.setup(listA, (delayA + rand(-3000,9000)), 5, 0)
		if("Balanced")
			for(spawningstuff = 0, spawningstuff < 30, spawningstuff++)
				var/turf/where_spawn = pick(turfS)
				var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
				var/list/listA = list(/mob/living/simple_animal/mousebot)
				SP.setup(listA, (delayA + rand(-3000,9000)), 3, 0)
		if("Many")
			for(spawningstuff = 0, spawningstuff < 40, spawningstuff++)
				var/turf/where_spawn = pick(turfS)
				var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
				var/list/listA = list(/mob/living/simple_animal/mousebot)
				SP.setup(listA, (delayA + rand(-3000,9000)), rand(1,2), 0)
	switch(infestation)
		if("Nest")
			for(spawningstuff = 0, spawningstuff < 0, spawningstuff++)
				var/turf/where_spawn = pick(turfS)
				var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
				var/list/listA = list(/obj/structure/silktree/tree/nestree)
				SP.setup(listA, (delayA + rand(-3000,12000)), 1, 0)
		if("Normal")
			for(spawningstuff = 0, spawningstuff < 1, spawningstuff++)
				var/turf/where_spawn = pick(turfS)
				var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
				var/list/listA = list(/obj/structure/silktree/tree)
				SP.setup(listA, (delayA + rand(-3000,12000)), 1, 0)
		if("Many")
			for(spawningstuff = 0, spawningstuff < 2, spawningstuff++)
				var/turf/where_spawn = pick(turfS)
				var/obj/effect/delayed_spawner/SP = new /obj/effect/delayed_spawner(where_spawn)
				var/list/listA = list(/obj/structure/silktree/tree)
				SP.setup(listA, (delayA + rand(-3000,6000)), 1, 0)

	SSweather.run_weather("long rain", ZLEVEL_ALL)
	..()