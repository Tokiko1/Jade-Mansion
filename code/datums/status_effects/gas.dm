/datum/status_effect/restraining/freon
	id = "frozen"
	duration = -1
	status_type = STATUS_EFFECT_UPGRADE_RERESH
	alert_type = /obj/screen/alert/status_effect/freon
	var/icon/cube
	var/iconpath = 'icons/effects/water.dmi'
	var/icon_name = "ice_cube1"
	var/freezetimer = 0
	var/unfreezetime = 10

	effect_level = 1
	upgrade_path = /datum/status_effect/restraining/freon/strongfreeze


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
	cube = icon(iconpath, icon_name)
	owner.add_overlay(cube)
	owner.update_canmove()

/datum/status_effect/restraining/freon/tick()
	owner.update_canmove()
	if(get_turf(owner) && istype(get_turf(owner), /turf/open))
		var/turf/open/ownerturf = get_turf(owner)
		if(ownerturf)
			if(ownerturf.air.temperature > T30C)
				freezetimer++
				if(freezetimer >= unfreezetime)
					owner.cut_overlay(cube)
					owner.update_canmove()
					qdel(src)

				else if(prob(10))
					to_chat(owner, "<span class='userdanger'>The ice cube appears to be melting!</span>")
			else
				freezetimer = max(freezetimer - 1, 0)
		else
			freezetimer = max(freezetimer - 1, 0)

/datum/status_effect/restraining/freon/be_replaced()
	owner.cut_overlay(cube)
	owner.update_canmove()
	..()

/datum/status_effect/restraining/freon/on_remove()
	owner.cut_overlay(cube)
	owner.update_canmove()
	..()


/datum/status_effect/restraining/freon/strongfreeze
	resist_timer = 200 //20 seconds
	restrain_priority = 101
	effect_level = 2
	upgrade_path = /datum/status_effect/restraining/freon/superfreeze
	icon_name = "ice_cube2"

/datum/status_effect/restraining/freon/superfreeze
	can_resist = 0
	can_move = 0
	can_act = 0
	effect_level = 3
	icon_name = "ice_cube"