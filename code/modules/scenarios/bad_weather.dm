/datum/scenario/bad_weather

	pickable = 1
	scenario_name = "Bad Weather"
	scenario_desc = "For the entire past week, rain has been pouring from the sky. And it doesn't look like it's going to stop anytime soon according to the weather forecasts. The road to the mansion might become damaged soon enough..."
	min_players = 0
	max_players = 0
	required_roles = list("mansion", "vip")
	round_lenght = 36000
	extension_lenght = 12000

	faction_list = list("mansion")
	faction_fluff = list("mansion" = "You are part of the mansion group! You have ordered a few crates of supplies but this is not enough. Food, ingredients, chemicals, medicine and wood need to be stockpiled. ")
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
		goalchecklist.Add("Goal: Store [number_raw] amount of food. <font color='green'>Success!</font> Stored [rawcount].")
	else
		goalchecklist.Add("Goal: Store [number_raw] amount of food. <font color='red'>Failed!</font> Stored [rawcount].")

	var/woodcount
	for(var/obj/item/stack/sheet/mineral/wood/woodA in world)
		if(istype(get_area(woodA), /area/inside/storage))
			woodcount = woodcount + woodA.amount

	if(woodcount >= number_wood)
		goalchecklist.Add("Goal: Store [number_wood] amount of food. <font color='green'>Success!</font> Stored [woodcount].")
	else
		goalchecklist.Add("Goal: Store [number_wood] amount of food. <font color='red'>Failed!</font> Stored [woodcount].")


	var/dirtS
//	for(var/obj/item/trash/a in /area/inside)
//		trash_and_dirt++
	for(var/obj/effect/decal/cleanable/b in world)
		if(istype(get_area(b), /area/inside))
			dirtS++

	if(dirtS >= maxdirt)
		goalchecklist.Add("Goal: Keep the mansion clean. <font color='green'>Success!</font>.")
	else
		goalchecklist.Add("Goal: Keep the mansion clean. <font color='red'>Failed!</font> There were [dirtS] tiles's worth of dirt.")

	goals_finished.["mansion"] = goalchecklist



	..()

/datum/scenario/bad_weather/handlescenario()
	number_foods = pick(100, 150, 200)
	number_raw = pick(200,300,400)
	number_wood = pick(400,800,1000)
	micebots = pick("Large", "Balanced", "Many", "Recurring")
	infestation = pick("Nest", "Normal", "Many")


	var/goaltext

	goaltext = "Cook [number_foods] foods and store them away in the freezer. Grow [number_raw] amounts of raw, edible plants and store them in the freezer. Have atleast [number_wood] pieces of cut wood in the storage room. Keep the mansion clean of any pests, dirt and trash!"




	..()