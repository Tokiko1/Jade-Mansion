mob/living/carbon/human/proc/handle_mood()
	refresh_mood()
	handle_new_moods()



mob/living/carbon/human/proc/refresh_mood() //processes moods, removes them if their duration is over
	for(var/thoughtS in mood_thoughts)
		var/list/moodS = mood_thoughts.["thoughtS"]


//for modifiying existing thoughts
//for extending/shorterning durations, severity or even removal of thoughts
mob/living/carbon/human/proc/modify_thought(thought_to_modify = list(), mood_mod_type, duration_mod, severity_mod, forced_mod)



//allows transforming/replacing thoughts into different ones
//if no severity or duration is set, they are inherited from the default values of the thought

mob/living/carbon/human/proc/transform_thought(thought_to_modify, transformed_thought, inherit_duration, inherit_severity, forced_mod)
	var/list/moodS = mood_thoughts.[thought_to_modify]
	var/list/moodD = GLOB.default_moods.[thought_to_modify]
	var/duration_mod
	var/severity_mod


	if(inherit_duration)
		duration_mod = moodS.["duration"]
	if(inherit_severity)
		severity_mod = moodS.["severity"]


	mood_thoughts.Remove(thought_to_modify)
	add_thought(transformed_thought, duration_mod, severity_mod, forced_mod)
	return

mob/living/carbon/human/proc/add_thought(thought_to_add, Tduration, Tseverity, Tforced = -1) //Tforced 1 and 0 set forced to true or false, -1 uses defaults
	var/list/moodADD = GLOB.default_moods.[thought_to_add]

	if(Tduration)
		moodADD.["duration"] = Tduration
	if(Tseverity)
		moodADD.["severity"] = Tseverity
	if(Tforced == 1)
		moodADD.["forced"] = TRUE
	else if(Tforced == 0)
		moodADD.["forced"] = FALSE

	mood_thoughts.Add(moodADD)
	return