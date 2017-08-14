/datum/preferences/proc/SetBackstory(mob/user, width = 600, height = 600, page = 1)

	var/HTML = ""


	HTML += "<center><h2>Backstory Setup</h2><br></center>"
	HTML += "<center>Please setup the backstory for your character here if you want. Staff, Owner and Guest stories can be set indepently of each other.</center><br><br>"
	HTML += "<center>Staff Story:</center>"
	if(staff_story)
		HTML += "<center>[staff_story]</center>"
	else
		HTML += "<center>No story set for staff.</center>"
	HTML += "<a href='?_src_=prefs;preference=backstory;task=write;story=staff'>Change Staff Story</a><br>"
	HTML += "<br><br>"

	HTML += "<center>Mansion Owner Story:</center>"
		if(owner_story)
		HTML += "<center>[owner_story]</center>"
	else
		HTML += "<center>No story set for mansion owner.</center>"
	HTML += "<a href='?_src_=prefs;preference=backstory;task=write;story=owner'>Change Mansion Owner Story</a><br>"
	HTML += "<br><br>"

	HTML += "<center>Guest Story:</center>"
		if(guest_story)
		HTML += "<center>[guest_story]</center>"
	else
		HTML += "<center>No story set for mansion owner.</center>"
	HTML += "<a href='?_src_=prefs;preference=backstory;task=write;story=guest'>Change Guest Story</a><br>"