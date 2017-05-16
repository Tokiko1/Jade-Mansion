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

