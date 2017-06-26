//trait menu

/datum/preferences/proc/SetTraits(mob/user, widthPerColumn = 295, height = 620)

	var/width = widthPerColumn

	var/HTML = ""

	HTML += "<center><h2>Trait Setup</h2><br></center>"
	HTML += "<br>"
	HTML += "<center><a href='?_src_=prefs;preference=trait;task=close'>Done</a></center><br>"

	for(var/traitS in user.traits)
		cost += traits.["traitS"].["cost"] //too long for now

	switch(cost)
		if(cost < 0)
			HTML += "<b>Total Trait Cost: <font color='green'>[cost]</font></b>
		if(cost == 0)
			HTML += "<b>Total Trait Cost: <font color='grey'>0</font></b>
		if(cost > 0)
			HTML += "<b>Total Trait Cost: <font color='grey'>[cost]</font></b>
			HTML += "<b>Warning: Your trait cost must be 0 or lower to be accepted!<b>
			HTML += "<b>You will be given random traits if you join with an invalid setup like this.<b>

	HTML += "<br>"
	for(var/list/traitG in GLOB.traitlist
		var/tID = traitG.["TID"]
		var/tname = traitG.["name"]
		var/tdesc = traitG.["desc"]
		var/tnote = traitG.["note"]
		var/tcost = traitG.["tcost"]
		var/tactive
		if(tname in user.traits)
			tactive = 1
		else
			tactive = 0

		HTML += "<b>[tname]</b>"
		HTML += "<b>Cost: [tcost]</b>"
		HTML += "<br>"
		HTML += "[desc]"
		if(tnote)
			HTML += "<b>Note:</b>[tnote]"
		if(!tactive)
			HTML += "<a href='?_src_=prefs;preference=trait;task=remove[tID]'>Remove</a><br>"
		else
			HTML += "<a href='?_src_=prefs;preference=trait;task=add[tID]'>Add</a><br>"