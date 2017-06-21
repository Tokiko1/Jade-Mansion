SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

	flags = SS_FIRE_IN_LOBBY|SS_KEEP_TIMING|SS_NO_INIT

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	var/cancelable = 1
	var/list/choices = list()
	var/list/voted = list()
	var/list/voting = list()
	var/list/generated_actions = list()
	var/restricted_vote = 0
	var/scenario_vote = 0
	var/winning_vote
	var/endvote_allowed = 0
	var/list/allowed_voters_vote =list()
	var/list/scenario_input_vote = list()

/datum/controller/subsystem/vote/fire()	//called by master_controller
	if(mode)
		time_remaining = round((started_time + config.vote_period - world.time)/10)

		if(time_remaining < 0)
			result()
			for(var/client/C in voting)
				C << browse(null, "window=vote;can_close=0")
			reset()
		else
			var/datum/browser/client_popup
			for(var/client/C in voting)
				client_popup = new(C, "vote", "Voting Panel")
				client_popup.set_window_options("can_close=0")
				client_popup.set_content(interface(C))
				client_popup.open(0)


/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	cancelable = 1
	mode = null
	question = null
	choices.Cut()
	voted.Cut()
	voting.Cut()
	remove_action_buttons()

/datum/controller/subsystem/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!config.vote_no_default && choices.len)
		var/list/non_voters = GLOB.directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if (!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(non_voters.len > 0)
			if(mode == "restart")
				choices["Continue Playing"] += non_voters.len
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]
			else if(mode == "gamemode")
				if(GLOB.master_mode in choices)
					choices[GLOB.master_mode] += non_voters.len
					if(choices[GLOB.master_mode] >= greatest_votes)
						greatest_votes = choices[GLOB.master_mode]
			else if(mode == "end round")
				choices["Extend Round"] += non_voters.len
				if(choices["Extend Round"] >= greatest_votes)
					greatest_votes = choices["Extend Round"]

	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(winners.len > 0)
		if(question)
			text += "<b>[question]</b>"
		else
			text += "<b>[capitalize(mode)] Vote</b>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			text += "\n<b>[choices[i]]:</b> [votes]"
		if(mode != "custom")
			if(winners.len > 1)
				text = "\n<b>Vote Tied Between:</b>"
				for(var/option in winners)
					text += "\n\t[option]"
			. = pick(winners)
			text += "\n<b>Vote Result: [.]</b>"
		else
			text += "\n<b>Did not vote:</b> [GLOB.clients.len-voted.len]"
	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	log_vote(text)
	remove_action_buttons()
	to_chat(world, "\n<font color='purple'>[text]</font>")
	winning_vote = .
	return .

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if("restart")
				if(. == "Restart Round")
					restart = 1
			if("gamemode")
				if(GLOB.master_mode != .)
					world.save_mode(.)
					if(SSticker && SSticker.mode)
						restart = 1
					else
						GLOB.master_mode = .
			if("end round")
				if(. == "Initiate Round End")
					to_chat(world, "<span style='boldannounce'>The round is now ending.</span>")
					SSticker.mode.end_scenario(1)
					endvote_allowed = 0
				else
					to_chat(world, "<span style='boldannounce'>The round has been extended!</span>")
					SSticker.mode.end_scenario(0)
					endvote_allowed = 1
			if("scenario input")
				SSticker.mode.choosen_scenario.handle_vote_result(.)
	else
		if(mode == "scenario input")
			var/list/votesT = list("NO VOTE")
			SSticker.mode.choosen_scenario.handle_vote_result(votesT)
	if(restart)
		var/active_admins = 0
		for(var/client/C in GLOB.admins)
			if(!C.is_afk() && check_rights_for(C, R_SERVER))
				active_admins = 1
				break
		if(!active_admins)
			world.Reboot("Restart vote successful.", "end_error", "restart vote")
		else
			to_chat(world, "<span style='boldannounce'>Notice:Restart vote will not restart the server automatically because there are active admins on.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +server, so it has been canceled. If you wish, you may restart the server.")

	return .

/datum/controller/subsystem/vote/proc/submit_vote(vote)
	if(mode)
		if(config.vote_no_dead && usr.stat == DEAD && !usr.client.holder)
			return 0
		if(restricted_vote && !(usr.client in allowed_voters_vote))
			return 0
		if(!(usr.ckey in voted))
			if(vote && 1<=vote && vote<=choices.len)
				voted += usr.ckey
				choices[choices[vote]]++	//check this
				return vote
	return 0

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key, var/list/scenario_input, var/list/allowed_voters)
	if(!mode)
		if(started_time)
			var/next_allowed_time = (started_time + config.vote_delay)
			if(mode)
				return 0

			var/admin = FALSE
			var/ckey = ckey(initiator_key)
			if((GLOB.admin_datums[ckey]) || (ckey in GLOB.deadmins))
				admin = TRUE

			if(next_allowed_time > world.time && !admin && !scenario_vote)
				to_chat(usr, "<span class='warning'>A vote was initiated recently, you must wait roughly [(next_allowed_time-world.time)/10] seconds before a new vote can be started!</span>")
				return 0

		reset()
		switch(vote_type)
			if("end round")
				cancelable = 0
				scenario_vote = 1
				restricted_vote = 0
				choices.Add("Initiate Round End", "Extend Round")
				question = "Would you like to end the round naturally or extend it?"
			if("scenario input")
				cancelable = 0
				allowed_voters_vote = allowed_voters
				scenario_input_vote = scenario_input
				restricted_vote = 1
				scenario_vote = 1
				question = scenario_input.["question"]
				for(var/s_answer in scenario_input.["answers"])
					choices |= s_answer
			if("restart")
				scenario_vote = 0
				restricted_vote = 0
				choices.Add("Restart Round","Continue Playing")
			if("gamemode")
				scenario_vote = 0
				restricted_vote = 0
				choices.Add(config.votable_modes)
			if("custom")
				scenario_vote = 0
				restricted_vote = 0
				question = stripped_input(usr,"What is the vote for?")
				if(!question)
					return 0
				for(var/i=1,i<=10,i++)
					var/option = capitalize(stripped_input(usr,"Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			else
				return 0
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text
		if(initiator)
			text = "[capitalize(mode)] vote started by [initiator]."
		else
			text = "[capitalize(mode)] vote started."

		if(mode == "custom" && mode == "scenario input")
			text += "\n[question]"
		log_vote(text)
		if(restricted_vote)
			to_chat(world, "\n<font color='purple'><b>[text]</b>\n</font>")
			var/list/nonvoters = list()
			nonvoters = GLOB.clients - allowed_voters_vote
			to_chat(allowed_voters, "<font color='purple'>Type <b>vote</b> or click <a href='?src=\ref[src]'>here</a> to place your votes.\nYou have [config.vote_period/10] seconds to vote.</font>")
			to_chat(nonvoters, "<font color='purple'>Type <b>vote</b> or click <a href='?src=\ref[src]'>here</a> to view the voting. \nThis is a restricted vote and you may not participate.\nThe vote will end in [config.vote_period/10] seconds.</font>")

		else
			to_chat(world, "\n<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=\ref[src]'>here</a> to place your votes.\nYou have [config.vote_period/10] seconds to vote.</font>")
		time_remaining = round(config.vote_period/10)
		for(var/c in GLOB.clients)
			var/client/C = c
			var/datum/action/vote/V = new
			if(question)
				V.name = "Vote: [question]"
			V.Grant(C.mob)
			generated_actions += V
		return 1
	return 0

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = 0
	var/trialmin = 0
	if(C.holder)
		admin = 1
		if(check_rights_for(C, R_ADMIN))
			trialmin = 1
	voting |= C

	if(mode)
		if(question)
			. += "<h2>Vote: '[question]'</h2>"
		else
			. += "<h2>Vote: [capitalize(mode)]</h2>"
		if(restricted_vote && !(C in allowed_voters_vote))
			. += "(Note: You may not vote, this vote is intended for others.)<hr>"
		. += "Time Left: [time_remaining] s<hr><ul>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			. += "<li><a href='?src=\ref[src];vote=[i]'>[choices[i]]</a> ([votes] votes)</li>"
		. += "</ul><hr>"
		if(admin && cancelable == 1)
			. += "(<a href='?src=\ref[src];vote=cancel'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul><li>"
		//manual endvote
		if(endvote_allowed || usr.client.holder)
			. += "<a href='?src=\ref[src];vote=end round'>End Round</a>"
		else
			. += "<font color='grey'>End Round (Disallowed for now)</font>"
		. += "</li><li>"
		//restart
		if(trialmin || config.allow_vote_restart)
			. += "<a href='?src=\ref[src];vote=restart'>Restart</a>"
		else
			. += "<font color='grey'>Restart (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=\ref[src];vote=toggle_restart'>[config.allow_vote_restart?"Allowed":"Disallowed"]</a>)"
		. += "</li><li>"
		//gamemode
		if(trialmin || config.allow_vote_mode)
			. += "<a href='?src=\ref[src];vote=gamemode'>GameMode</a>"
		else
			. += "<font color='grey'>GameMode (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=\ref[src];vote=toggle_gamemode'>[config.allow_vote_mode?"Allowed":"Disallowed"]</a>)"

		. += "</li>"
		//custom
		if(trialmin)
			. += "<li><a href='?src=\ref[src];vote=custom'>Custom</a></li>"
		. += "</ul><hr>"
	. += "<a href='?src=\ref[src];vote=close' style='position:absolute;right:50px'>Close</a>"
	return .


/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid
	switch(href_list["vote"])
		if("close")
			voting -= usr.client
			usr << browse(null, "window=vote")
			return
		if("cancel")
			if(usr.client.holder && cancelable == 1)
				reset()
		if("toggle_restart")
			if(usr.client.holder)
				config.allow_vote_restart = !config.allow_vote_restart
		if("toggle_gamemode")
			if(usr.client.holder)
				config.allow_vote_mode = !config.allow_vote_mode
		if("restart")
			if(config.allow_vote_restart || usr.client.holder)
				initiate_vote("restart",usr.key)
		if("gamemode")
			if(config.allow_vote_mode || usr.client.holder)
				initiate_vote("gamemode",usr.key)
		if("custom")
			if(usr.client.holder)
				initiate_vote("custom",usr.key)
		if("end round")
			if(endvote_allowed || usr.client.holder)
				initiate_vote("end round",usr.key)
		else
			submit_vote(round(text2num(href_list["vote"])))
	usr.vote()

/datum/controller/subsystem/vote/proc/remove_action_buttons()
	for(var/v in generated_actions)
		var/datum/action/vote/V = v
		if(!QDELETED(V))
			V.Remove(V.owner)
	generated_actions = list()

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	var/datum/browser/popup = new(src, "vote", "Voting Panel")
	popup.set_window_options("can_close=0")
	popup.set_content(SSvote.interface(client))
	popup.open(0)

/datum/action/vote
	name = "Vote!"
	button_icon_state = "vote"

/datum/action/vote/Trigger()
	if(owner)
		owner.vote()
		Remove(owner)

/datum/action/vote/IsAvailable()
	return 1
