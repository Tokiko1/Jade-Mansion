/datum/martial_art/medic
	name = "Ibis Nurse"
	deflection_chance = 0 //Chance to deflect projectiles
	block_chance = 90 //Chance to block melee attacks
	armed_melee_block = 1 //if 0, holding an item in your active hand will override the melee block chance, if 1, both item and martial block checks will occur separately
	easy_block = 0 //If 1, melee attacks can be blocked without needing to be on throw mode
	help_verb = /mob/living/carbon/human/proc/Ibis_Nurse_help
	counter = 1 //if 1, calls the counter proc on a successfull block
	armed_counter_override = 0
	counter_chance = 95

	block_ignore_chance = 60 //chance to bypass the blockchance of a mob completely
	armed_block_pierce = 0

	var/datum/action/nurse_stab/nurse_stab = new/datum/action/nurse_stab()

/datum/martial_art/medic/teach(var/mob/living/carbon/human/H,var/make_temporary=0)
	..()
	to_chat(H, "<span class = 'danger'>Place your cursor over a move at the top of the screen to see what it does.</span>")
	nurse_stab.Grant(H)

/datum/martial_art/medic/remove(var/mob/living/carbon/human/H)
	..()
	nurse_stab.Remove(H)

/datum/action/nurse_stab
	name = "Nurse's Stab - A quick, skillfull stab with your fingers into the enemy's stomach region that knocks them down for a very short time amount."
	button_icon_state = "nurse_stab"

/datum/action/nurse_stab/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You cannot prepare this ability while incapacitated.</span>")
		return
	to_chat(owner, "<span class='notice'>You prepare the Nurse Stab technique. Your next disarm attack will be a Nurse Stab.</span>")
	var/mob/living/carbon/human/H = owner
	H.martial_art.streak = "nurse_stab"

/datum/martial_art/medic/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	switch(streak)
		if("nurse_stab")
			streak = ""
			nurse_stab(A,D)
			return 1
	return 0


/datum/martial_art/medic/counter_act(mob/living/carbon/human/A, mob/living/D)
	if(A.a_intent == INTENT_HELP)
		return 1

	D.visible_message("<span class='warning'>[A] skillfully grabs [D]!</span>", \
					  	"<span class='userdanger'>[A] skillfully grabs you!</span>")
	A.Stun(2)
	D.Stun(2)
	sleep(20)
	if(!A || !D || get_dist(A, D) > 1)
		return 0
	if(!iscarbon(D))
		D.Stun(5)
		D.visible_message("<span class='warning'>[A] skillfully hits [D] in the weakspot!</span>", \
					  	"<span class='userdanger'>[A] skillfully hits your weakspot!</span>")
		playsound(get_turf(D), 'sound/effects/hit_kick.ogg', 50, 1, -1)
		return 1

	switch(A.a_intent)
		if(INTENT_GRAB)
			D.Weaken(3)
			D.visible_message("<span class='warning'>[A] skillfully twists [D] around and grabs them!</span>", \
					  	"<span class='userdanger'>[A] skillfully twists you around and grabs you!</span>")
			D.grabbedby(A)
			D.grippedby(A)
			playsound(get_turf(D), 'sound/effects/hit_kick.ogg', 50, 1, -1)
			return 1
		if(INTENT_HARM)
			D.Weaken(3)
			D.visible_message("<span class='warning'>[A] skillfully elbows [D] in the head and stomach!</span>", \
					  	"<span class='userdanger'>[A] skillfully elbows you in the head and stomach!</span>")
			playsound(get_turf(D), 'sound/effects/hit_kick.ogg', 50, 1, -1)
			D.apply_damage(rand(10, 15), BRUTE)
			return 1
		if(INTENT_DISARM)
			D.Weaken(10)
			D.visible_message("<span class='warning'>[A] skillfully elbows [D] in the neck and back!</span>", \
					  	"<span class='userdanger'>[A] skillfully elbows you in the neck and back!</span>")
			playsound(get_turf(D), 'sound/effects/hit_kick.ogg', 50, 1, -1)
			D.apply_damage(rand(2, 5), STAMINA)
			return 1
	return 1

/datum/martial_art/medic/proc/nurse_stab(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A == D)
		return

	D.visible_message("<span class='warning'>[A] stabs [D] in the stomach with their fingers!</span>", \
					  	"<span class='userdanger'>[A] stabs you in the stomach with their fingers</span>")
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
	D.Weaken(2)

/datum/martial_art/medic/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	else
		return 0

/mob/living/carbon/human/proc/Ibis_Nurse_help()
	set name = "Remember the Ibis Nurse Self Defense Training"
	set desc = "You try to remember the Ibis Nurse Self Defense Training."
	set category = "Ibis Nurse"

	to_chat(usr, "<b><i>You try to recall the Ibis Nurse Self Defense Training.</i></b>")

	to_chat(usr, "<span class='notice'>Nurse Stab</span>: A stab with your fingers into the stomach of the enemy. Weak, but knocks them to the ground for a moment.")
	to_chat(usr, "<span class='notice'>Advanced Block</span>: Activate throw mode to enter your defense mode. If you successfully block a melee attack, you automatically counterattack with a devastating attack depending on your current intent. Pick help intent if you don't want to counter but still block. The counter cannot be used while holding an item, though you will still get the block bonus.")
	to_chat(usr, "<span class='notice'>Body Movement Lessons</span>: As part of your training, you know well how the body of a person moves when attacking. This knowledge allows your melee attacks to completely nullify block attempts 60 percent of the time. It does not work when carrying a weapon however.")