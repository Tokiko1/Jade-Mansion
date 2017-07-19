/datum/status_effect/restraining/freon
	id = "frozen"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /obj/screen/alert/status_effect/freon
	var/icon/cube
	can_resist = 1
	resist_timer = 50
	can_move = 0
	can_stand = 1 //note that you cannot resist out of stuff while
	can_act = 1
	resist_name = "ice cube"
	restrain_priority = 100
	does_anchor = 1

/obj/screen/alert/status_effect/freon
	name = "Frozen Solid"
	desc = "You're frozen inside of an ice cube, and cannot move! You can still do stuff, like shooting. Resist out of the cube!"
	icon_state = "frozen"

/datum/status_effect/restraining/freon/on_apply()
	if(!owner.stat)
		to_chat(owner, "<span class='userdanger'>You become frozen in a cube!</span>")
	cube = icon('icons/effects/water.dmi', "ice_cube")
	owner.add_overlay(cube)
	owner.update_canmove()

/datum/status_effect/restraining/freon/tick()
	owner.update_canmove()
	if(get_turf(owner) && istype(get_turf(owner), /turf/open))
		var/turf/open/ownerturf = get_turf(owner)
		if(ownerturf)
			if(ownerturf.air.temperature > T50C)
				qdel(src)

/datum/status_effect/restraining/freon/on_remove()
	owner.cut_overlay(cube)
	owner.update_canmove()


/datum/status_effect/restraining/freon/strongfreeze
	id = "frozen_strong"
	resist_timer = 200 //20 seconds
	restrain_priority = 101