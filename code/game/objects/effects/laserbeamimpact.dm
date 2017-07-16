/obj/effect/overlay/temp/laserbeam_impact
	icon_state = "nothing"
	duration = 4

/obj/effect/overlay/temp/laserbeam_impact/New(loc, atom/target, x_shift = 0, y_shift = 0, beam_duration, beam_impact_icon)
	pixel_x = x_shift
	pixel_y = y_shift
	if(beam_duration)
		duration = beam_duration
	if(beam_impact_icon)
		icon_state = beam_impact_icon
	..()

/obj/effect/overlay/temp/laserbeam_impact/ice_beam
	icon_state = "impact_laser_blue"
	duration = 4
