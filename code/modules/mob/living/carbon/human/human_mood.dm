mob/living/carbon/human/proc/handle_mood()
	refresh_mood()
	check_for_thoughts()



mob/living/carbon/human/proc/refresh_mood() //processes moods, removes them if their duration is over
	total_mood = 0
	for(var/thoughtS in mood_thoughts)
		var/list/moodS = mood_thoughts.["thoughtS"]
		if(REALTIMEOFDAY > moodS.["duration"])
			mood_thoughts.Remove(thoughtS)
		else

			total_mood = total_mood + moodS.["severity_current"]


//for modifiying existing thoughts
//for extending/shorterning durations, severity or even removal of thoughts
mob/living/carbon/human/proc/modify_thought(thought_to_modify = list(), mood_mod_type = "add", duration_mod = 300, severity_mod, forced_mod)
	for(var/thought_name in thought_to_modify)
		if(!(thought_name in mood_thoughts)) //thought to modify does not exist, abort!
			return
		var/list/existing_thought = mood_thoughts.[thought_name]
		if(existing_thought.["protected"] == TRUE && !forced_mod) //protected thoughts will be ignored unless forced
			return

		switch(mood_mod_type)
			if("add")
				existing_thought.["duration"] = existing_thought.["duration"] + duration_mod
				existing_thought.["severity"] = existing_thought.["severity"] + severity_mod
				mood_thoughts.Remove(thought_name)
				mood_thoughts.Add(existing_thought)
			if("set")
				existing_thought.["duration"] = REALTIMEOFDAY + duration_mod
				existing_thought.["severity"] = severity_mod
				mood_thoughts.Remove(thought_name)
				mood_thoughts.Add(existing_thought)
			if("delete")
				mood_thoughts.Remove(thought_name)


//allows transforming/replacing thoughts into different ones
//if no severity or duration is set, they are inherited from the default values of the thought

mob/living/carbon/human/proc/transform_thought(thought_to_modify, transformed_thought, inherit_duration, inherit_severity, forced_mod, forcetransform)
	var/list/moodS = mood_thoughts.[thought_to_modify]
	var/list/moodD = GLOB.default_moods.[thought_to_modify]
	var/duration_mod
	var/severity_mod

	if(!moodS.len) //thought to transform doesn't exist
		return

	if(moodS.["protected"] == TRUE && !forcetransform) //protected thoughts will be ignored unless forced
		return

	if(inherit_duration)
		duration_mod = moodS.["duration"]
	else
		duration_mod = moodD.["duration"]
	if(inherit_severity)
		severity_mod = moodS.["severity"]
	else
		severity_mod = moodD.["severity"]


	mood_thoughts.Remove(thought_to_modify)
	add_thought(transformed_thought, duration_mod, severity_mod, forced_mod)
	return

mob/living/carbon/human/proc/add_thought(thought_to_add, Tduration, Tseverity, Tforced = -1) //Tforced 1 and 0 set forced to true or false, -1 uses defaults
	var/list/moodADD = GLOB.default_moods.[thought_to_add]

	if(!moodADD.len)
		message_admins("Warning: Something tried to add a non-existant thought. Thought was [thought_to_add].")
		return

	if(thought_to_add in mood_thoughts) //thought already exists, let's refresh it instead
		mood_thoughts.Remove(thought_to_add)

	if(Tduration)
		moodADD.["duration"] = REALTIMEOFDAY + Tduration
	if(Tseverity)
		moodADD.["severity"] = Tseverity
	if(Tforced == 1)
		moodADD.["protected"] = TRUE
	else if(Tforced == 0)
		moodADD.["protected"] = FALSE

	mood_thoughts.Add(moodADD)
	return

mob/living/carbon/human/proc/check_for_thoughts()

	if(stat) //unconciouss people don't really react to the environment
		return

	//negative thoughts
	if(health < 90)
		add_thought("pain mild")
		if(health < 70)
			add_thought("pain strong")
			if(health < 50)
				add_thought("pain very strong")
	if(!w_uniform)
		var/seen
		for(var/mob/living/carbon/human/people in view(src))
			if(people != src)
				seen = TRUE
		if(seen)
			add_thought("embarassed")
			if(("dressed" in mood_thoughts) || ("well dressed" in mood_thoughts))
				modify_thought(thought_to_modify = list("dressed", "well dressed"), "remove")

	if(fire_stacks < 0)
		if(w_uniform)
			var/obj/item/clothing/uniform_S
			if(!uniform_S.suitable_for_swimming)
				add_thought("wet")
				if(fire_stacks < -10)
					add_thought("soaked")

	if(nutrition < NUTRITION_LEVEL_HUNGRY)
		add_thought("hungry")


	//positive thoughts

	if(nutrition > NUTRITION_LEVEL_WELL_FED)
		add_thought("well fed")
	if(drunkenness > DRUNK_LEVEL_HAPPY)
		add_thought("drunk happy")
		if(drunkenness > DRUNK_LEVEL_TIPSY)
			add_thought("drunk tipsy")


