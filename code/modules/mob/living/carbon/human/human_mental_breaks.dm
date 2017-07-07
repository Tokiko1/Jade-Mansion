/mob/living/carbon/human/proc/handle_mental_breaks()
	update_idea_hud()
	for(var/datum/mental_break/mbreakS in mental_breaks)
		mbreakS.run_check(src)

/mob/living/carbon/human/proc/update_idea_hud()
	if(!client || !hud_used)
		return

	if(hud_used.bad_ideas)
		if(mental_breaks.len)
			hud_used.bad_ideas.icon_state = "idea_tantrum"
		else if(bad_ideas.len)
			hud_used.bad_ideas.icon_state = "idea_on"
		else
			hud_used.bad_ideas.icon_state = "idea_off"

