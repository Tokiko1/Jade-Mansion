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