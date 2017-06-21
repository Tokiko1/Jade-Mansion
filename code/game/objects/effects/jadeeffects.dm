/obj/effect/upstairshine
	icon = 'icons/effects/jadeeffects.dmi'
	anchored = 1
	mouse_opacity = 0
	icon_state = "upstairshine"
	layer = ABOVE_OPEN_TURF_LAYER

/obj/effect/upstairshine/Initialize()
	STOP_PROCESSING(SSobj, src)

/obj/effect/upstairshine/process()
	STOP_PROCESSING(SSobj, src)

/obj/effect/delayed_spawner
	var/list/list_of_stuff_to_spawn = list()
	var/thing_to_spawn
	var/spawn_amount
	var/spawn_delay
	var/setup = 0
	var/repeat = 0
	var/repeat_frequency = 0
	var/dcounter
	mouse_opacity = 0

/obj/effect/delayed_spawner/proc/setup(var/list/listS = list(), var/delayS, var/amountS = 1, var/repeatS = 0, var/repeat_freqS = 6000)

	list_of_stuff_to_spawn = listS
	spawn_amount = amountS
	spawn_delay = REALTIMEOFDAY + delayS
	setup = 1
	START_PROCESSING(SSobj, src)
	repeat = repeatS
	repeat_frequency = repeat_freqS

/obj/effect/delayed_spawner/process()
	if(dcounter > 5)
		if(!setup)
			STOP_PROCESSING(SSobj, src)
		else
			if(REALTIMEOFDAY > spawn_delay)
				var/spawned
				for(spawned=0, spawn_amount > spawned, spawned++)
					thing_to_spawn = pick(list_of_stuff_to_spawn)
					new thing_to_spawn(get_turf(src))
				if(repeat)
					spawn_delay = REALTIMEOFDAY + repeat_frequency
				else
					qdel(src)
		dcounter = 0
	dcounter++