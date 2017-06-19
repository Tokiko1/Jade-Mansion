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
	var/number_foods = pick(100, 150, 200)
	var/number_raw = pick(200,300,400)
	var/number_wood = pick(400,800,1000)
	var/micebots = pick("Large", "Balanced", "Many", "Recurring")
	var/infestation = pick("Nest", "Normal", "Many")


/datum/scenario/bad_weather/handlegoals()
	var/foodcount
	for(var/obj/item/weapon/reagent_containers/food/snacks/food/foodA in """areastuff""")
		if(!istype(/obj/item/weapon/reagent_containers/food/snacks/grown/)
			foodcount++

	if(foodcount => number_foods
		goals_finished["mansion"].Add("Goal: Store [number_foods] amount of food. <font color='green'>Success!</font> Stored [foodcount].")
	else
		goals_finished["mansion"].Add("Goal: Store [number_foods] amount of food. <font color='red'>Failed!</font> Stored [foodcount].")

	var/rawcount
	for(var/obj/item/weapon/reagent_containers/food/snacks/food/snacks/grown/rawA in """areastuff""")
		rawcount++

	if(rawcount => number_raw
		goals_finished["mansion"].Add("Goal: Store [number_raw] amount of food. <font color='green'>Success!</font> Stored [rawcount].")
	else
		goals_finished["mansion"].Add("Goal: Store [number_raw] amount of food. <font color='red'>Failed!</font> Stored [rawcount].")

	var/woodcount
	for(var/obj/item/stack/sheet/mineral/wood/woodA in "areastuffs")
		woodcount = woodcount + woodA.amount

	if(woodcount => number_wood
		goals_finished["mansion"].Add("Goal: Store [number_wood] amount of food. <font color='green'>Success!</font> Stored [woodcount].")
	else
		goals_finished["mansion"].Add("Goal: Store [number_wood] amount of food. <font color='red'>Failed!</font> Stored [woodcount].")


	var/dirt
//	for(var/obj/item/trash/a in /area/inside)
//		trash_and_dirt++
	for(var/obj/effect/decal/cleanable/b in /area/inside)
		dirt++

	if(trash_and_dirt => maxdirt
		goals_finished["mansion"].Add("Goal: Keep the mansion clean. <font color='green'>Success!</font>.")
	else
		goals_finished["mansion"].Add("Goal: Keep the mansion clean. <font color='red'>Failed!</font> There were [dirt] tiles's worth of dirt.")





	..()

/datum/scenario/bad_weather/handlescenario()



	var/goaltext

	goaltext = "Cook [number_foods] foods and store them away in the freezer. Grow [number_raw] amounts of raw, edible plants and store them in the freezer. Have atleast [number_wood] pieces of cut wood in the storage room.




	..()