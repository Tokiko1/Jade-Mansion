/datum/game_mode/monster
	name = "monster"
	config_tag = "monster"
	antag_flag = ROLE_BAKEMONO
	restricted_jobs = list()
	protected_jobs = list()
	required_players = 0
	required_enemies = 1
	recommended_enemies = 1
	reroll_friendly = 1
	enemy_minimum_age = 0

	announce_span = "danger"
	announce_text = "A horrifying monster has arrived at the mansion.\n\
	<span class='danger'>Monster</span>: Capture everyone in the mansion!\n\
	<span class='notice'>Staff</span>: Don't get caught, research the monster and defeat it!"

	var/number_of_monsters = 1
	var/monstername = "monster"
	var/phase = 0 //the current phase of the mode. 0 = no monster yet, 1 = monster has appeared, 2 = research possible, 3 = research completed, 4 = round over
	var/list/datum/mind/linked_monsters = list()


/datum/game_mode/monster/pre_setup()

	for(var/i in 1 to number_of_monsters)
		if (!antag_candidates.len)
			break

		var/datum/mind/monstermind = pick(antag_candidates)
		linked_monsters += monstermind
		monstermind.special_role = monstername
		log_game("[monstermind.key] (ckey) has been selected as a [monstername]")
		antag_candidates.Remove(monstermind)

	if(linked_monsters.len < required_enemies)
		return 0
	return 1

/datum/game_mode/monster/post_setup()
	for(var/datum/mind/monstermind in linked_monsters)
		//make some objectives for monster
		//give them the datums they need
		//announce stuff they need and handle the ability adding or transformation into mobs
		//handle the different possible phases for the mode

	modePlayer += linked_monsters
	..()
	return 1

/datum/game_mode/monster/proc/forge_monster_objectives(datum/mind/traitor)