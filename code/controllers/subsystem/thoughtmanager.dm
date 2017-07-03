//adds random bad ideas to humans, custom fluff objectives, random moods, mental breaks and other nonsense
SUBSYSTEM_DEF(thoughtmanager)
	name = "Thought Manager"
	flags = SS_BACKGROUND
	wait = 50 //every 5 seconds
	var/current_time = REALTIMEOFDAY
	var/next_event

	var/frequency_of_events = 300
	var/lower_bound_event_frequency = -20
	var/upper_bound_event_frequency = 600


	//how the number of bad ideas is determined: for every player, the game generates a number based on the character's mischief var and adds them all
	//together, then checks against the lower_bound and causes that many events, rounded down
	//players add different amounts of chaos


	var/bad_idea_lower_bound = 1 //how many bad ideas to generate atleast
	var/bad_idea_lower_bound_chance = 50
	var/bad_idea_frequency_low = 0.10
	var/bad_idea_frequency_high = 2
	var/bad_idea_severity_low = -0.10
	var/bad_idea_severity_high = 10


	var/mischief_base = 0.4
	var/bad_idea_bonus = 0.2


	var/mischief_severity_base = 1
	var/bad_idea_severity_bonus = 1


	var/bad_idea_extreme_threshold = 15
	var/bad_idea_verybad_threshold = 13
	var/bad_idea_medium_threshold = 7


	var/tantrum_chance = 5

#define BAD_SEVERITY_MINOR 1
#define BAD_SEVERITY_MEDIUM 2
#define BAD_SEVERITY_VERYBAD 3
#define BAD_SEVERITY_EXTREME 4


/datum/controller/subsystem/thoughtmanager/fire()
	handle_tantrums()

	current_time = REALTIMEOFDAY

/datum/controller/subsystem/thoughtmanager/handle_events()
	if(current_time > next_event)
		var/bad_idea_counter = 0
		var/bad_idea_severity = 0
		var/final_severity = BAD_SEVERITY_MINOR
		next_event = REALTIMEOFDAY + (frequency_of_events + rand(lower_bound_event_frequency, upper_bound_event_frequency))
		for(mob/living/carbon/human/player in GLOB.player_list)
			bad_idea_counter =+ Clamp((rand(0, bad_idea_bonus) + mischief_base + (player.mischief * 0.1)),bad_idea_frequency_low ,bad_idea_frequency_high)

		if(bad_idea_counter < bad_idea_lower_bound && prob(bad_idea_lower_bound_chance))
			bad_idea_counter = bad_idea_lower_bound)

		for(var/loops = bad_idea_counter, loops => 1, loops--)
			var/amount_players = GLOB.player_list.len
			var/severity_player_bonus
			for(mob/living/carbon/human/player in GLOB.player_list)
				severity_player_bonus + Clamp((rand(0, bad_idea_severity_bonus) + mischief_severity_base + (player.mischief * 0.15)),bad_idea_severity_low ,bad_idea_severity_high)
			if(!amount_players) //no division by zero
				severity_player_bonus = 1
			else
				severity_player_bonus = severity_player_bonus / amount_players
		bad_idea_severity = rand(0, 15) + severity_player_bonus

		if(bad_idea_severity >= bad_idea_extreme_threshold)
			final_severity = BAD_SEVERITY_EXTREME
		else if(bad_idea_severity >= bad_idea_verybad_threshold)
			final_severity = BAD_SEVERITY_VERYBAD
		else if(bad_idea_severity >= bad_idea_medium_threshold)
			final_severity = BAD_SEVERITY_MEDIUM
		else
			final_severity = BAD_SEVERITY_MINOR



		if(!victim)
			victim = bad_idea_person

		if(("Strong Fate" in victim.traits) || ("Strong Fate" in bad_idea_person.traits)) //intensify the bad idea if traits allow it
			if(prob(50) && final_severity < BAD_SEVERITY_EXTREME)
				final_severity++

		if(("Weak Fate" in victim.traits) || ("Weak Fate" in bad_idea_person.traits)) //intensify the bad idea if traits allow it
			if(prob(50) && final_severity > BAD_SEVERITY_MINOR)
				final_severity--


/datum/controller/subsystem/thoughtmanager/make_bad_idea(mob/living/carbon/human/player, intensity = "low")


/datum/controller/subsystem/thoughtmanager/handle_tantrums()
	for(mob/living/carbon/human/player in GLOB.mental_break_candicates)
		var/breakchance = tantrum_chance



		if(prob(breakchance)
			if(player.total_mood >= THRESHOLD_MENTAL_LIGHT)
				 GLOB.mental_break_candicates.Remove(player)
			else
				start_tantrum(player)

/datum/controller/subsystem/thoughtmanager/start_tantrum(mob/living/carbon/human/tantrum)


/datum/controller/subsystem/thoughtmanager/update_tantrums_candidates()

	for(mob/living/carbon/human/player in GLOB.player_list)
		if(player in GLOB.mental_break_candicates)
			if(player.total_mood >= THRESHOLD_MENTAL_LIGHT)
				 GLOB.mental_break_candicates.Remove(player)
		else
			if(player.total_mood >= THRESHOLD_MENTAL_LIGHT)
				GLOB.mental_break_candicates.Add(player)