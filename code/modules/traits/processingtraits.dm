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
	afraidcount = Clamp(afraidcount, 0, 10) //let's not have these values build up extremely low or high

	if(isturf(player.loc))
		var/turf/T = player.loc
		light_amount = T.get_lumcount()
	if(light_amount < 0.3)
		afraidcount++
		if(afraidcount > 2 && prob(20))
			to_chat(player, "<span class='warning'>You feel uneasy in the darkness.</span>")
	else
		afraidcount--

	if(afraidcount > 5)
		player.add_thought("scared dark")

//DISLIKE OF INJURY

/datum/trait/injury_dislike
	tname = "Injury Dislike"
	var/injurydislikecount

/datum/trait/injury_dislike/run_check(mob/living/carbon/human/player)
	if(injurydislikecount > 3)
		if(!("injury dislike" in player.mood_thoughts)) //well, it's a costly check
			for(var/mob/living/carbon/human/injureds in view(5, player))
				var/total_injury = injureds.getBruteLoss() + injureds.getFireLoss()
				if(total_injury > 20)
					player.add_thought("injury dislike")
		injurydislikecount = 0
	else
		injurydislikecount++



//CLEANING OBSESSION

/datum/trait/neat_freak
	tname = "Cleaning Obsessed"
	var/messcount = 0
	var/checkcooldown = 0

/datum/trait/neat_freak/run_check(mob/living/carbon/human/player)
	if(checkcooldown > 4)
		messcount = Clamp(messcount, 0, 10)
		var/dirty = 0
		for(var/obj/potentialmess in view(5, player))
			if(potentialmess.messy_thing == 1)
				if(istype(potentialmess.loc, /turf/open)) //we only care about dirty, messy things that we can see, stuff in bins is ok
					dirty = 1
		if(dirty)
			messcount++
		else if(prob(70))
			messcount--
		if(messcount > 3)
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
		goodmoodcounter = 0
	goodmoodcounter++


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
	if(player.drunkenness > 20 && prob(80))
		player.drunkenness = max((player.drunkenness - 5), 0)

//NARCOLEPSY
/datum/trait/narcolepsy
	tname = "Narcolepsy"
	var/sleepycounter = 0
	var/nextsleepcounter = 30

/datum/trait/narcolepsy/run_check(mob/living/carbon/human/player)
	if(sleepycounter > nextsleepcounter)
		if(prob(40))
			var/sleeptime = rand(5, 13)

			if(player.total_mood < THRESHOLD_MENTAL_LIGHT && prob(50))
				sleeptime += 10 //20 extra seconds
			if(player.total_mood < THRESHOLD_MENTAL_MEDIUM && prob(40))
				sleeptime += 20 //40 extra seconds
			if(player.total_mood < THRESHOLD_MENTAL_LIGHT && prob(50))
				sleeptime += 40 //80 extra seconds
			if(prob(80))
				to_chat(player, "<span class='warning'>Your conciousness starts drifting off into dreams...</span>")
			sleepycounter = 0
			sleep(rand(40, 80))
			player.Sleeping(sleeptime) //good night
		sleepycounter = 0
		nextsleepcounter = rand(20, 40)
	sleepycounter++

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

