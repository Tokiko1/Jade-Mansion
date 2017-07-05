//these traits here need to be called constantly to check for a condition

/datum/trait
	var/tname

/datum/trait/proc/run_check(mob/living/carbon/human/player)








//AFRAID OF DARKNESS

/datum/trait/afraid_of_darkness
	tname = "Afraid of Darkness"
	var/afraidcount

/datum/trait/afraid_of_darkness/run_check(mob/living/carbon/human/player)
	var/light_amount = 0
	afraidcount = Clamp(afraidcount, 0, 20) //let's not have these values build up extremely low or high

	if(isturf(player.loc))
		var/turf/T = player.loc
		light_amount = T.get_lumcount()
	if(light_amount < 0.3)
		afraidcount++
		if(afraidcount > 5 && prob(10))
			to_chat(player, "<span class='warning'>You feel uneasy in the darkness.</span>")
	else
		afraidcount--

	if(afraidcount > 10)
		player.add_thought("scared dark")

//CLEANING OBSESSION

/datum/trait/neat_freak
	tname = "Cleaning Obsessed"
	var/messcount = 0
	var/checkcooldown = 0

/datum/trait/neat_freak/run_check(mob/living/carbon/human/player)
	if(checkcooldown > 6)
		messcount = Clamp(messcount, 0, 20)
		var/dirty = 0
		for(var/obj/potentialmess in view(5, src))
			if(potentialmess.messy_thing == 1)
				dirty = 1
				break
		if(dirty)
			messcount++
		else if(prob(30))
			messcount--
		if(messcount > 10)
			player.add_thought("annoyed by mess")
		checkcooldown = 0

	checkcooldown++

//POSITIVE

/datum/trait/positive
	tname = "Positive Thinking"
	var/goodmoodcounter = 0

/datum/trait/positive/run_check(mob/living/carbon/human/player)
	if(goodmoodcounter > 120)
		if(prob(60))
			player.add_thought("happy positive")
		else if(prob(30))
			player.add_thought("very happy positive")


//GLUTTON
/datum/trait/glutton
	tname = "Glutton"
	var/hungercounter

/datum/trait/glutton/run_check(mob/living/carbon/human/player)
	hungercounter = Clamp(hungercounter, 0, 20)
	if(player.nutrition < NUTRITION_LEVEL_WELL_FED)
		hungercounter++
	else
		hungercounter--
	if(hungercounter > 10)
		player.add_thought("glutton hungry")


//SHAKY
/datum/trait/shaky
	tname = "Shaky"
	var/shakycounter = 0

/datum/trait/shaky/run_check(mob/living/carbon/human/player)
	if(shakycounter > 10)
		shakycounter = 0
		if(prob(10))
			var/obj/item/I = player.get_active_held_item()
			if(I)
				to_chat(player, "<span class='warning'>Your hands start shaking uncontrollably and you drop what you were holding.</span>")
				player.drop_item()

	shakycounter++

//ONI LIVER
/datum/trait/oni_liver
	tname = "Oni Liver"

/datum/trait/oni_liver/run_check(mob/living/carbon/human/player)
	if(player.drunkenness > 10 && prob(10))
		player.drunkenness = max((player.drunkenness - 10), 0)

//NARCOLEPSY
/datum/trait/narcolepsy


//MAID FASHION OBSESSION
/datum/trait/maidfashion
	tname = "Maid Fashion Obsession"

/datum/trait/maidfashion/run_check(mob/living/carbon/human/player)
	var/maid_missing = 1
	if(player.w_uniform && player.shoes && player.head)
		var/obj/item/clothing/uniform_U = player.w_uniform
		var/obj/item/clothing/uniform_H = player.w_uniform

		if(uniform_U.maid_uniform && uniform_H.maid_uniform)
			maid_missing = 0
	if(maid_missing)
		player.add_thought("missing maid fashion")

