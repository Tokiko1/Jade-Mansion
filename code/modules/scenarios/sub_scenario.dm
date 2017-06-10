/datum/subscenario/

	var/pickable = 0

	var/sub_name = "Placeholder Subscenario."
	var/sub_desc = "Placeholder text. If this got selected, something went awfully wrong!"
	var/list/sub_rolefluff = list()
	var/list/sub_factionfluff = list() //keep in mind that factions are based on the scenario, not the subscenario.

datum/subscenario/proc/handle_subscenario()