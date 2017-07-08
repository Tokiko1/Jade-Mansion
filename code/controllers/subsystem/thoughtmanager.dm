//adds random bad ideas to humans, custom fluff objectives, random moods, mental breaks and other nonsense
SUBSYSTEM_DEF(thoughtmanager)
	name = "Thought Manager"
	flags = SS_BACKGROUND
	wait = 50 //every 5 seconds
	var/next_event

	var/frequency_of_events = 4500
	var/lower_bound_event_frequency = -200
	var/upper_bound_event_frequency = 7500


	//how the number of bad ideas is determined: for every player, the game generates a number based on the character's mischief var and adds them all
	//together, then checks against the lower_bound and causes that many events, rounded down
	//players add different amounts of chaos


	var/bad_idea_lower_bound = 1 //how many bad ideas to generate atleast
	var/bad_idea_lower_bound_chance = 50
	var/bad_idea_frequency_low = 0.10
	var/bad_idea_frequency_high = 2
	var/bad_idea_severity_low = 0.10
	var/bad_idea_severity_high = 6


	var/mischief_base = 0.4
	var/bad_idea_bonus = 2


	var/mischief_severity_base = 1
	var/bad_idea_severity_bonus = 10


	var/bad_idea_extreme_threshold = 15
	var/bad_idea_verybad_threshold = 13
	var/bad_idea_medium_threshold = 7


	var/tantrum_chance = 5

#define BAD_SEVERITY_MINOR 1
#define BAD_SEVERITY_MEDIUM 2
#define BAD_SEVERITY_VERYBAD 3
#define BAD_SEVERITY_EXTREME 4


/datum/controller/subsystem/thoughtmanager/fire()
	update_tantrums_candidates()
	handle_tantrums()
	handle_events()

/datum/controller/subsystem/thoughtmanager/proc/handle_events()
	if(REALTIMEOFDAY > next_event)
		var/bad_idea_counter = 0
		var/bad_idea_severity = 0
		var/final_severity = BAD_SEVERITY_MINOR
		var/list/player_list_human = list()
		for(var/mob/living/carbon/human/playerP in GLOB.player_list) //we only want humans, not people in the lobby or mobs
			player_list_human |= playerP



//setting the time for the next batch of bad ideas
		next_event = REALTIMEOFDAY + (frequency_of_events + rand(lower_bound_event_frequency, upper_bound_event_frequency))


		if(!player_list_human.len) //nobody here, let's not run this time
			return

//figuring out how many bad ideas to cause based on playercount and mischief var
		for(var/mob/living/carbon/human/player in player_list_human)
			bad_idea_counter += Clamp(((rand(0, bad_idea_bonus)*0.1) + mischief_base + (player.mischief * 0.01)),bad_idea_frequency_low ,bad_idea_frequency_high)

		if(bad_idea_counter < bad_idea_lower_bound && prob(bad_idea_lower_bound_chance))
			bad_idea_counter = bad_idea_lower_bound


//calculating severity of each event
		for(var/loops = bad_idea_counter, loops >= 1, loops--)
			var/amount_players = player_list_human.len
			var/severity_player_bonus
			for(var/mob/living/carbon/human/player in player_list_human)
				severity_player_bonus += Clamp((rand(0, bad_idea_severity_bonus) + (mischief_severity_base *0.05)+ (player.mischief * 0.15)),bad_idea_severity_low ,bad_idea_severity_high)
			if(!amount_players) //no division by zero
				severity_player_bonus = 1
			else
				severity_player_bonus = severity_player_bonus / amount_players
			bad_idea_severity = rand(0, 15) + severity_player_bonus


//grouping the events in 1 of the 4 severities after calculation
			if(bad_idea_severity >= bad_idea_extreme_threshold)
				final_severity = BAD_SEVERITY_EXTREME
			else if(bad_idea_severity >= bad_idea_verybad_threshold)
				final_severity = BAD_SEVERITY_VERYBAD
			else if(bad_idea_severity >= bad_idea_medium_threshold)
				final_severity = BAD_SEVERITY_MEDIUM
			else
				final_severity = BAD_SEVERITY_MINOR

			if(final_severity > 2 && prob(50))
				final_severity--


//picking the type and the person who gets this idea and possibly the victim
			var/btype = pick("general", "target")
			var/mob/living/carbon/human/victim
			var/mob/living/carbon/human/bad_idea_person

			var/list/peoples = list()
			peoples += player_list_human
			var/list/victimsS = list()
			victimsS += GLOB.bad_idea_victims

			var/list/badidea_peoples = list()
			if(prob(30) && GLOB.bad_idea_causers.len)
				badidea_peoples += GLOB.bad_idea_causers
			else
				badidea_peoples += player_list_human

			for(var/mob/living/carbon/human/good_people in badidea_peoples)
				if(good_people.total_mood < THRESHOLD_MENTAL_LIGHT) //bad people don't get fun bad ideas
					badidea_peoples.Remove(good_people)

			if(!badidea_peoples.len) //after filtering all the bad mooded people, do we still have people?
				return
			bad_idea_person = pick(badidea_peoples)


			peoples.Remove(bad_idea_person)
			victimsS.Remove(bad_idea_person)

			if(!peoples.len) //okay, there is no more people left to be victims so we are alone
				btype = "general" //let's put a general bad idea instead

			if(btype == "target")

				if(prob(50) && victimsS.len)
					victim = pick(victimsS)
				else
					victim = pick(peoples)
			else
				victim = bad_idea_person

//adjusting the final severity up and/or down based on traits
			if(("Strong Fate" in victim.traits) || ("Strong Fate" in bad_idea_person.traits)) //intensify the bad idea if traits allow it
				if(prob(50) && final_severity < BAD_SEVERITY_EXTREME)
					final_severity++

			if(("Weak Fate" in victim.traits) || ("Weak Fate" in bad_idea_person.traits)) //deintensify the bad idea if traits allow it
				if(prob(50) && final_severity > BAD_SEVERITY_MINOR)
					final_severity--

			if(!bad_idea_person || !victim.name || !bad_idea_person.name) //something went wrong!
				return
			final_severity = Clamp(final_severity, 1, 4)
			make_bad_idea(btype, final_severity, bad_idea_person, victim)


/datum/controller/subsystem/thoughtmanager/proc/make_bad_idea(type = "general", intensity = 1, mob/living/carbon/human/player, mob/living/carbon/human/victimB)
	var/path_of_bad_idea
	if(type == "general")
		switch(intensity)
			if(1)
				path_of_bad_idea = pick(GLOB.bad_ideas_general_minor)
			if(2)
				path_of_bad_idea = pick(GLOB.bad_ideas_general_medium)
			if(3)
				path_of_bad_idea = pick(GLOB.bad_ideas_general_verybad)
			if(4)
				path_of_bad_idea = pick(GLOB.bad_ideas_general_extreme)
	else if(type == "target")
		switch(intensity)
			if(1)
				path_of_bad_idea = pick(GLOB.bad_ideas_target_minor)
			if(2)
				path_of_bad_idea = pick(GLOB.bad_ideas_target_medium)
			if(3)
				path_of_bad_idea = pick(GLOB.bad_ideas_target_verybad)
			if(4)
				path_of_bad_idea = pick(GLOB.bad_ideas_target_extreme)
	if(path_of_bad_idea)
		var/removeideas = 0
		if(player.bad_ideas.len > BAD_IDEA_HARDCAP)
			removeideas = 1
		else if (player.bad_ideas.len > BAD_IDEA_REMOVE_CAP && prob(50))
			removeideas = 1

		if(removeideas)
			var/datum/bad_idea/idea_to_remove = pick(player.bad_ideas)
			to_chat(player, "<span class='warning'>You've forgot about your idea of [idea_to_remove.idea_name]...</span>")
			player.bad_ideas.Remove(idea_to_remove)
			qdel(idea_to_remove)

		var/datum/bad_idea/ideaT = new path_of_bad_idea(player)
		ideaT.setup_bad_idea(victimB.name, player, type)
		player.bad_ideas.Add(ideaT)
	return


/datum/controller/subsystem/thoughtmanager/proc/handle_tantrums()
	for(var/mob/living/carbon/human/player in GLOB.mental_break_candicates)
		var/breakchance = tantrum_chance

		if(prob(breakchance))
			if(player.total_mood >= THRESHOLD_MENTAL_LIGHT || player.tantrum_active || player.sleeping > 0)
				GLOB.mental_break_candicates.Remove(player)
			else
				start_tantrum(player)

/datum/controller/subsystem/thoughtmanager/proc/start_tantrum(mob/living/carbon/human/player)
	//todo: add different tantrums for different tiers
	var/path_of_mental_break
	if(player.total_mood < THRESHOLD_MENTAL_BAD)
		path_of_mental_break = pick(GLOB.mental_break_list)

	else if(player.total_mood < THRESHOLD_MENTAL_MEDIUM)
		if(prob(30))
			path_of_mental_break = pick(GLOB.mental_break_list)

	else if(player.total_mood < THRESHOLD_MENTAL_LIGHT)
		if(prob(3))
			path_of_mental_break = pick(GLOB.mental_break_list)

	if(path_of_mental_break)
		var/datum/mental_break/Sbreak = new path_of_mental_break(player)
		player.mental_breaks.Add(Sbreak)
		Sbreak.setup_mental_break(player, player)

/datum/controller/subsystem/thoughtmanager/proc/update_tantrums_candidates()

	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player in GLOB.mental_break_candicates)
			if(player.total_mood > THRESHOLD_MENTAL_LIGHT || player.tantrum_active)
				GLOB.mental_break_candicates.Remove(player)
		else
			if(player.total_mood < THRESHOLD_MENTAL_LIGHT && !player.tantrum_active && player.sleeping == 0)
				GLOB.mental_break_candicates.Add(player)