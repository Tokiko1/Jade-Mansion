/obj/screen/human/bad_idea
	icon = 'icons/mob/screen_gen.dmi'
	name = "bad ideas and mental breaks"
	icon_state = "idea_off"
	screen_loc = ui_bad_idea

/obj/screen/human/bad_idea/Click() //open the menu
	ViewIdeaWindow(usr)

/obj/screen/human/bad_idea/proc/ViewIdeaWindow(mob/living/carbon/human/player, width = 600, height = 600)

	var/HTML = ""
	if(!player.mental_breaks.len && !player.bad_ideas.len)
		HTML += "<center><h2>Mental Breaks and Bad Ideas</h2><br></center>"
		HTML += "You currently have no mental breaks or bad ideas.<br>"
	if(player.mental_breaks.len > 0)
		HTML += "<center><h2>Mental Breaks</h2><br></center>"
		HTML += "<br>"
		HTML += "<br>"
		for(var/datum/mental_break/mentalbreakS in player.mental_breaks)
			HTML += "<font color='red'>---</font> Name: [mentalbreakS.mbreak_name] <font color='red'>---</font><br>"
			HTML += "Description: [mentalbreakS.desc_text]<br>"
			var/remainingtime = (mentalbreakS.mbreak_timer - REALTIMEOFDAY) * 0.1
			var/remainingtime2 = mentalbreakS.default_breakduration * 0.1

			HTML += "Remaining Time: [remainingtime] seconds / [remainingtime2] seconds <br>"
		HTML += "<br>"

	if(player.bad_ideas.len > 0)
		HTML += "<center><h2>Bad Ideas</h2><br></center>"
		HTML += "Remember: Bad Ideas are optional and for fun only.<br>"
		HTML += "<br>"
		HTML += "<br>"
		for(var/datum/bad_idea/bad_ideaS in player.bad_ideas)
			HTML += "--- Name: [bad_ideaS.idea_name] ---<br>"
			HTML += "Description: [bad_ideaS.desc_text]<br>"
			HTML += "<br>"

	var/datum/browser/popup = new(player, "ideamenu", "<div align='center'>bad ideas and mental breaks</div>", width, height)
	popup.set_window_options("can_close=1")
	popup.set_content(HTML)
	popup.open(0)