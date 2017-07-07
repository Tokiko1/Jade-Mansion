/obj/screen/human/mood
	icon = 'icons/mob/screen_gen.dmi'
	name = "mood"
	icon_state = "mood_unknown"
	screen_loc = ui_mood

/obj/screen/human/mood/Click() //open the menu
	ViewMoodWindow(usr)

/obj/screen/human/mood/proc/ViewMoodWindow(mob/living/carbon/human/user, width = 300, height = 600)

	var/HTML = ""
	HTML += "<center><h2>Thoughts and Mood</h2><br></center>"
	HTML += "<center>Current Mood:[user.total_mood]</center><br>"
	if(user.total_mood < THRESHOLD_MENTAL_LIGHT)
		HTML += "<center><b>Mental Break Warning</b></center><br>"
		HTML += "<center><font color='yellow'>Character can suffer a light mental break.</font></center><br>"
	if(user.total_mood < THRESHOLD_MENTAL_MEDIUM)
		HTML += "<center><font color='orange'>Character can suffer a medium mental break.</font></center><br>"
	if(user.total_mood < THRESHOLD_MENTAL_BAD)
		HTML += "<center><font color='red'>Character can suffer a bad mental break.</font></center><br>"
	HTML += "<br>"
	for(var/thoughts in user.mood_thoughts)

		var/nameT = user.mood_thoughts[thoughts]["name_menu"]
		var/descT = user.mood_thoughts[thoughts]["desc"]
		var/durationT = (user.mood_thoughts[thoughts]["duration"] - REALTIMEOFDAY) * 0.1
		var/severityT = user.mood_thoughts[thoughts]["severity"] //sorry - Tokiko1


		if(severityT < 0)
			HTML += "<b>Name:</b> [nameT] <font color='red'>--Bad--</font><br>"
		else if(severityT == 0)
			HTML += "<b>Name:</b> [nameT]<br>" //there shouldn't actually be any 0 severity moods at all since they don't make sense, but let's check just in case
		else if (severityT > 0)
			HTML += "<b>Name:</b> [nameT] <font color='green'>--Good--</font><br>"

		HTML += "Remaining Duration : [durationT]<br>"

		if(severityT < 0)
			HTML += "Mood Modifier: <font color='red'>[severityT]</font><br>"
		else if(severityT == 0)
			HTML += "Mood Modifier: 0<br>"
		else if(severityT > 0)
			HTML += "Mood Modifier: <font color='green'>[severityT]</font><br>"

		HTML += "Description: [descT]<br>"
		HTML += "<br>"

	var/datum/browser/popup = new(user, "moodmenu", "<div align='center'>Thought Summary</div>", width, height)
	popup.set_window_options("can_close=1")
	popup.set_content(HTML)
	popup.open(0)