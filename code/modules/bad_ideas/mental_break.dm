/datum/mental_break/
	var/mbreak_name
	var/desc_text
	var/victim //who is the victim, if the break has one?
	var/default_breakduration //how long you have to do your task before you fall unconciouss
	var/mbreak_timer
	var/catharsis_counter = 0 //how many cycles of success you have
	var/catharsis_in_progress = 0 //time has run out, but you can still fulfill your requirements
	var/catharsis_success //how many cycles of successes you need
	var/ready_break = 0
	var/ending_break = 0

/datum/mental_break/proc/setup_mental_break(mob/living/carbon/human/victim_input, mob/living/carbon/human/player)
	victim = victim_input
	player.tantrum_active = 1
	mbreak_timer = REALTIMEOFDAY + default_breakduration
	ready_break = 1
	player << 'sound/effects/ghost2.ogg'
	to_chat(player, "<span class='warning'>You are suffering a mental break: [mbreak_name]!</span>")
	to_chat(player, "<span class='warning'>[desc_text]</span>")

/datum/mental_break/proc/run_check(mob/living/carbon/human/player)
	if(!ready_break)
		return
	if(catharsis_counter >= catharsis_success)
		completed_break(player)
		return
	if(REALTIMEOFDAY > mbreak_timer && !catharsis_in_progress)
		fail_break(player)
		return

/datum/mental_break/proc/fail_break(mob/living/carbon/human/player)
	if(!ending_break) //lets just make sure this doesn't run twice or whichever reason
		ending_break = 1
		var/sleeptime = rand(50, 100)
		to_chat(player, "<span class='warning'>All these intense emotions have made you very, very sleepy, you drift off into the world of dreams to calm down...</span>")
		sleep(rand(40, 80))
		player.Sleeping(sleeptime) //good night
		remove_tantrum(player)

/datum/mental_break/proc/completed_break(mob/living/carbon/human/player)
	to_chat(player, "<span class='notice'>You got over your mental break! You feel much better now!</span>")
	player.add_thought("catharsis")
	remove_tantrum(player)

/datum/mental_break/proc/remove_tantrum(mob/living/carbon/human/player)
	player.mental_breaks.Remove(src)
	if(player.mental_breaks.len == 0)
		player.tantrum_active = 0
	qdel(src)
	return

//Mental Breaks

//Isolation

/datum/mental_break/isolation
	mbreak_name = "Isolation"
	desc_text = "You don't want to be near any people for now. Avoid seeing any people other than yourself. Maybe lock yourself in a room or go outside."

	default_breakduration = 2200 //3 minutes
	catharsis_success = 40
	var/seclusioncounter = 0

/datum/mental_break/isolation/run_check(mob/living/carbon/human/player)
	..()
	var/seen = FALSE
	for(var/mob/living/carbon/human/people in view(player))
		if(people != player)
			seen = TRUE
	if(seen)
		seclusioncounter = 0
		catharsis_in_progress = 0
	else
		seclusioncounter++
	if(seclusioncounter > 10)
		if(seclusioncounter == 11)
			to_chat(player, "<span class='notice'>You seem to be alone, it feels good!</span>")
		catharsis_counter++ //how many cycles of success you have
		catharsis_in_progress = 1

//Extreme Hunger

/datum/mental_break/hunger
	mbreak_name = "Extreme Hunger"
	desc_text = "You feel extreme hunger and inner emptiness! You have to eat now! Anything will do!"

	default_breakduration = 2200
	catharsis_success = 20

/datum/mental_break/hunger/setup_mental_break(mob/living/carbon/human/victim_input, mob/living/carbon/human/player)
	..()
	player.nutrition = min(rand(20,100),player.nutrition)
	player.satiety = 0

/datum/mental_break/hunger/run_check(mob/living/carbon/human/player)
	..()
	if(player.nutrition > 150)
		catharsis_counter++
		catharsis_in_progress = 1
		for(var/datum/reagent/R in player.reagents.reagent_list) //keep eating, don't just wait until your food metabolizes!
			player.reagents.remove_reagent(R.id,3)
		player.nutrition = max((player.nutrition - rand(5,10)), 0)
		player.satiety = max((player.satiety - rand(5,10)), 0)
	else
		catharsis_in_progress = 0