//trait menu

/datum/preferences/proc/SetTraits(mob/user, width = 295, height = 620, page = 1)

	var/HTML = ""

	HTML += "<center><h2>Trait Setup</h2><br></center>"
	HTML += "<br>"
	HTML += "<center><a href='?_src_=prefs;preference=trait;task=close'>Done</a></center><br>"
	HTML += "<center><a href='?_src_=prefs;preference=trait;task=changepage;page = 1'>Page 1</a><a href='?_src_=prefs;preference=trait;task=changepage;page=2'>Page 2</a></center><br>"

	for(var/traitS in user.traits)
		cost += traitS.["cost"]

	switch(cost)
		if(cost < 0)
			HTML += "<b>Total Trait Cost: <font color='green'>[cost]</font></b>"
		if(cost == 0)
			HTML += "<b>Total Trait Cost: <font color='grey'>0</font></b>"
		if(cost > 0)
			HTML += "<b>Total Trait Cost: <font color='grey'>[cost]</font></b>"
			HTML += "<b>Warning: Your trait cost must be 0 or lower to be accepted!<b>"
			HTML += "<b>You will be given random traits if you join with an invalid setup like this.<b>"

	HTML += "<br>"
	for(var/list/traitG in TRAITS_LIST[page])
		var/tname = traitG.["name"]
		var/tdesc = traitG.["tdesc"]
		var/tnote = traitG.["tnote"]
		var/tcost = traitG.["tcost"]
		var/tactive
		if(tname in user.traits)
			tactive = 1
		else
			tactive = 0

		HTML += "<b>[tname]</b>"
		HTML += "<b>Cost: [tcost]</b>"
		c
		HTML += "[desc]"
		if(tnote)
			HTML += "<b>Note:</b>[tnote]"
		if(!tactive)
			HTML += "<a href='?_src_=prefs;preference=trait;task=remove;trait=[tname]'>Remove</a><br>"
		else
			HTML += "<a href='?_src_=prefs;preference=trait;task=add;trait=[tname]'>Add</a><br>"
		HTML += "<br>"



	user << browse(null, "window=preferences")
	var/datum/browser/popup = new(user, "traits", "<div align='center'>Trait Preferences</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(0)