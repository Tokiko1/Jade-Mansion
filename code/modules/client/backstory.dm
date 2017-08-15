/datum/preferences/proc/SetBackstory(mob/user, width = 400, height = 600)

	var/HTML = ""


	HTML += "<center><h2>Backstory Setup</h2><br></center>"
	HTML += "<center><a href='?_src_=prefs;preference=backstory;task=close'>Done</a></center>"
	HTML += "Please setup the backstory for your character here if you want. Staff, Owner and Guest stories can be set to different things."
	HTML += "There is a 1024 character limit, please keep it brief and informative."
	HTML += "Remember, this is an overview for others about your character, not their full life story. Don't put stuff here other characters shouldn't know."
	HTML += "<br><br>"

	HTML += "<b>Staff Story:</b><br>"
	if(staff_story)
		HTML += "[staff_story]<br>"
	else
		HTML += "No story set for staff.<br>"
	HTML += "<a href='?_src_=prefs;preference=backstory;task=write;story=staff'>Change Staff Story</a><a href='?_src_=prefs;preference=backstory;task=reset;story=staff'>Remove Story</a><br>"
	HTML += "<br><br>"

	HTML += "<b>Mansion Owner Story:</b><br>"
	if(owner_story)
		HTML += "[owner_story]<br>"
	else
		HTML += "No story set for mansion owner.<br>"
	HTML += "<a href='?_src_=prefs;preference=backstory;task=write;story=owner'>Change Mansion Owner Story</a><a href='?_src_=prefs;preference=backstory;task=reset;story=owner'>Remove Story</a><br>"
	HTML += "<br><br>"

	HTML += "<b>Guest Story:</b><br>"
	if(guest_story)
		HTML += "[guest_story]<br>"
	else
		HTML += "No story set for mansion owner.<br>"
	HTML += "<a href='?_src_=prefs;preference=backstory;task=write;story=guest'>Change Guest Story</a><a href='?_src_=prefs;preference=backstory;task=reset;story=guest'>Remove Story</a><br>"

	user << browse(null, "window=preferences")
	var/datum/browser/popup = new(user, "backstory", "<div align='center'>Backstory Setup</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(0)