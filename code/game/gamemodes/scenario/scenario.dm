/datum/game_mode/scenario
	name = "secret extended"
	config_tag = "secret extended"
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

/datum/game_mode/scenario/pre_setup()
	return 1

/datum/game_mode/scenario/post_setup()
	..()

/datum/game_mode/scenario/announced
	name = "extended"
	config_tag = "extended"

