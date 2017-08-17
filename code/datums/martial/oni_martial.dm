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

/datum/martial_art/oni/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(D.stat || D.weakened)
		return 0

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
	A.Stun(2)
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, rand(1, 4), 4,A)
	return 1

/datum/martial_art/oni/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(D.stat || D.weakened)
		return 0

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
	A.Stun(2)
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, rand(1, 4), 4,A)
	return 1