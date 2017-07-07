//trait menu

/datum/preferences/proc/SetTraits(mob/user, width = 600, height = 600, page = 1)

	if(!GLOB.alltraits.len) //what the egg??
		for(var/pages in GLOB.traitlistpaged)
			GLOB.alltraits += GLOB.traitlistpaged[pages]

	var/HTML = ""

	HTML += "<center><h2>Trait Setup</h2><br></center>"
	HTML += "<center>Select your desired traits here.</center>"
	HTML += "<center>Current Page: [page]</center>"

	HTML += "<center><a href='?_src_=prefs;preference=trait;task=close'>Done</a></center><br>"
	HTML += "<center><a href='?_src_=prefs;preference=trait;task=reset;tpage=[page]'>Reset Traits</a></center><br>"
	var/pagesT = 1
	HTML += "<center>"
	for(var/pages in GLOB.traitlistpaged)
		var/tencounter = 1
		if(tencounter >= 10)
			HTML += "</center><center>"
			tencounter = 1
		HTML += "<a href='?_src_=prefs;preference=trait;task=changepage;tpage=[pagesT]'>Page [pagesT]</a>"
		pagesT++
		tencounter++
	HTML += "</center><br>"

	var/totalcost = STARTING_TRAIT_COST
	if(traits && traits.len)
		for(var/traitS in traits)
			if(traitS in GLOB.alltraits)
				var/traitC = GLOB.alltraits.[traitS]
				totalcost += traitC.["tcost"]
			else // something went very wrong, one of the saved traits does not exist, let's remove it
				traits.Remove(traitS)



	if(totalcost < 0)
		HTML += "<b>Total Trait Cost: <font color='green'>[totalcost]</font></b><br>"
	if(totalcost == 0)
		HTML += "<b>Total Trait Cost: <font color='grey'>0</font></b><br>"
	if(totalcost > 0)
		HTML += "<b>Total Trait Cost: <font color='red'>[totalcost]</font></b><br>"
		HTML += "<b>Warning: Your trait cost must be 0 or lower to be accepted!</b>"
		HTML += "<b>You will be given random traits if you join with an invalid setup like this.</b>"
		HTML += "<b>Add traits with a negative cost or remove some with a positive cost to get to 0 or below.</b>"

	HTML += "<br><br>"
	var/list/TS = GLOB.traitlistpaged.["page[page]"]
	for(var/traitG in TS)
		var/list/traitC = TS.[traitG]
		var/tname = traitC.["tname"]
		var/tdesc = traitC.["tdesc"]
		var/tnote = traitC.["tnotes"]
		var/tcost = traitC.["tcost"]
		var/tactive
		if(tname in traits)
			tactive = 1
		else
			tactive = 0


		if(tactive)
			HTML += "<b>[tname]</b> -- SELECTED<br>"
		else
			HTML += "<b>[tname]</b><br>"

		if(tcost < 0)
			HTML += "<b>Cost: <font color='green'>[tcost]</font></b>"
		if(tcost == 0)
			HTML += "<b>Cost: <font color='grey'>None</font></b>"
		if(tcost > 0)
			HTML += "<b>Cost: <font color='red'>[tcost]</font></b>"
		HTML += "<br><br>"
		HTML += "[tdesc]<br>"
		if(tnote)
			HTML += "<b>Note:</b>[tnote]<br>"
		if(tactive)
			HTML += "<a href='?_src_=prefs;preference=trait;task=remove;trait=[tname];tpage=[page]'>Remove</a><br>"
		else
			HTML += "<a href='?_src_=prefs;preference=trait;task=add;trait=[tname];tpage=[page]'>Add</a><br>"
		HTML += "<br>"



	user << browse(null, "window=preferences")
	var/datum/browser/popup = new(user, "traits", "<div align='center'>Trait Preferences</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(0)