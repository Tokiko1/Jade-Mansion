/datum/round_event_control/rain
	name = "Rain"
	typepath = /datum/round_event/rain
	max_occurrences = -1

/datum/round_event/rain

/datum/round_event/rain/start()
	SSweather.run_weather("rain", ZLEVEL_ALL)