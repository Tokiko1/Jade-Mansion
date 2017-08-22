/datum/martial_art/oni
	name = "Oni Martial Art"
	streak = ""
	max_streak_length = 6
	current_target = null
	temporary = 0
	deflection_chance = 0 //Chance to deflect projectiles
	block_chance = 50 //Chance to block melee attacks using items while on throw mode.
	easy_block = 1
	help_verb = null
	no_guns = FALSE
	allow_temp_override = TRUE //if this martial art can be overridden by temporary martial arts

	var/datum/action/oni_flying_punch/oni_flying_punch = new/datum/action/oni_flying_punch()
	var/datum/action/ground_shake/ground_shake = new/datum/action/ground_shake()

/datum/martial_art/oni/teach(var/mob/living/carbon/human/H,var/make_temporary=0)
	..()
	to_chat(H, "<span class = 'danger'>Place your cursor over a move at the top of the screen to see what it does.</span>")
	oni_flying_punch.Grant(H)
	ground_shake.Grant(H)

/datum/martial_art/oni/remove(var/mob/living/carbon/human/H)
	..()
	oni_flying_punch.Remove(H)
	ground_shake.Remove(H)

/datum/martial_art/oni/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	switch(streak)
		if("oni_flying")
			streak = ""
			oni_flying(A,D)
			return 1
	return 0

/datum/action/oni_flying_punch
	name = "Flying Punch - A strong punch that sends someone flying far."
	button_icon_state = "oni_flying_punch"

/datum/action/oni_flying_punch/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't assume the Flying Punch stance while you're incapacitated.</span>")
		return
	owner.visible_message("<span class='danger'>[owner] prepares a Flying Punch stance</span>", "<b><i>Your next attack will be a Flying Punch.</i></b>")
	var/mob/living/carbon/human/H = owner
	H.martial_art.streak = "oni_flying"

/datum/martial_art/oni/proc/oni_flying(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A == D)
		return

	D.visible_message("<span class='warning'>[A] hits [D] with an open palm!</span>", \
					  	"<span class='userdanger'>[A] hits you with an open palm!</span>")
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
	D.apply_damage(rand(10, 15), STAMINA)
	D.Weaken(5)
	A.next_click = world.time + CLICK_CD_ONIPUNCH
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, rand(3, 7), 4,A)


/datum/action/ground_shake
	name = "Ground Shake - Punch or stomp on the ground to create a shockwave that throws everyone away from you."
	button_icon_state = "oni_ground_smash"

/datum/action/ground_shake/Trigger()
	if(owner.incapacitated() || owner.restrained())
		to_chat(owner, "<span class='warning'>You can't use this now!</span>")
		return
	owner.visible_message("<span class='danger'>[owner] hits the ground, sending out a shockwave!</span>")
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromowner
	playsound(owner.loc, 'sound/effects/bamf.ogg', 50, 1)
	for(var/turf/T in range(5, owner)) //Done this way so things don't get thrown all around hilariously.
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == owner || AM.anchored)
			continue

		throwtarget = get_edge_target_turf(owner, get_dir(owner, get_step_away(AM, owner)))
		distfromowner = get_dist(owner, AM)

		new /obj/effect/overlay/temp/oni_ground_cracks(get_turf(owner))

		if(distfromowner == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Stun(5)
				M.adjustBruteLoss(5)
				to_chat(M, "<span class='userdanger'>You're slammed into the floor by [owner]!</span>")
				M.Flatten(owner)
		else
			if(isliving(AM))
				var/mob/living/M = AM
				M.Weaken(2)
				to_chat(M, "<span class='userdanger'>You're thrown back by the shockwave!</span>")
			AM.throw_at(throwtarget, ((Clamp((6 - (Clamp(distfromowner - 2, 0, distfromowner))), 3, 6))), 1,owner)//So stuff gets tossed around at the same time.
		owner.Stun(1)
		owner.next_click = world.time + CLICK_CD_ONIGROUNDSMASH

/obj/effect/overlay/temp/oni_ground_cracks
	name = "cracks"
	icon_state = "ground_crack"
	duration = 6

/datum/martial_art/oni/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1

	var/damage = rand(A.dna.species.punchdamagelow, A.dna.species.punchdamagehigh) + 5

	if(damage <= 0)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to punch [D]!</span>", \
			"<span class='userdanger'>[A] has attempted to punch [D]!</span>", null, COMBAT_MESSAGE_RANGE)
		add_logs(A, D, "attempted to punch")
		return 0

	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)

	D.visible_message("<span class='warning'>[A] punches [D] really hard!</span>", \
					  	"<span class='userdanger'>[A] punches you really hard!</span>")
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
	D.apply_damage(5, STAMINA)
	D.Weaken(2)
	A.next_click = world.time + CLICK_CD_ONIPUNCH
	return 1

/datum/martial_art/oni/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1

	var/damage = rand(A.dna.species.punchdamagelow, A.dna.species.punchdamagehigh) + 5

	if(damage <= 0)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to punch [D]!</span>", \
			"<span class='userdanger'>[A] has attempted to punch [D]!</span>", null, COMBAT_MESSAGE_RANGE)
		add_logs(A, D, "attempted to punch")
		return 0

	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)

	D.visible_message("<span class='warning'>[A] punches [D] really hard!</span>", \
					  	"<span class='userdanger'>[A] punches you really hard!</span>")
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
	D.apply_damage(5, BRUTE)
	D.Weaken(2)
	A.next_click = world.time + CLICK_CD_ONIPUNCH
	return 1