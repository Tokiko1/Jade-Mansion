/obj/item/weapon/disabler_blade
	name = "disabler habidao"
	desc = "A Diyurite self-defense sword made for subdueing targets non-harmfully. It comes with an intergrated guard assist system that allows even untrained users to block, counter and even disarm incoming melee attacks effectively. Blades like these are standard equipment for Jade Empire police."
	icon = 'icons/obj/jadeweapons.dmi'
	icon_state = "disabler_blade1"
	item_state = "disabler_blade"
	force = 9
	throwforce = 25
	flags = CONDUCT
	damtype = STAMINA
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT | SLOT_BACK
	materials = list(MAT_METAL=50)
	attack_verb = list("sliced", "cut", "punished", "stabbed")
	hitsound = 'sound/weapons/emitter2.ogg'
	reach = 2

	melee_block = 70
	counter_chance = 80
	disarm_chance_mod = 60
	block_ignore_item_bonus = 30

	var/counter_disarm_chance = 20
	var/attack_chance = 50

/obj/item/weapon/disabler_blade/counter_act(mob/living/carbon/human/A, mob/living/D)
	if(!A || !D)
		return 0
	if(istype(D, /mob/living/carbon/human/) )
		var/mob/living/carbon/human/targetH = D
		if(targetH.get_active_held_item() && prob(counter_disarm_chance))
			var/obj/item/itemD = targetH.get_active_held_item()
			if(itemD && targetH.drop_item())
				A.visible_message("<span class='warning'>[A] hits [itemD] held by [targetH] with [src], sending [itemD] flying!</span>")
				var/atom/throw_target = get_edge_target_turf(targetH, get_dir(A, targetH))
				itemD.throw_at(throw_target, rand(2, 7), 6, targetH)
				return 1
	if(prob(attack_chance))
		A.visible_message("<span class='warning'>[A] counters the attack by [D]!</span>")
		attack(D, A)
		return 1
	else
		A.visible_message("<span class='warning'>[A] counters the attack by [D], but [D] dodges out of the way!</span>")
		return 0

	return 1

/obj/item/weapon/disabler_guandao
	name = "disabler guandao"
	desc = "A high power Diyurite non-lethal polearm. It has long reach and it has an internal stabilizer that allows effective usage even with just a single arm. Due to its high power core and design, it can easily break through most blocking attempts."
	icon = 'icons/obj/jadeweapons.dmi'
	icon_state = "disabler_guandao1"
	item_state = "disabler_guandao"
	force = 15
	reach = 3
	throwforce = 25
	flags = CONDUCT
	damtype = STAMINA
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=50)
	attack_verb = list("sliced", "cut", "punished", "stabbed")
	hitsound = 'sound/weapons/emitter2.ogg'

	melee_block = 10
	block_ignore_item_bonus = 60

/obj/item/weapon/disabler_guandao/low_power
	name = "low power disabler guandao"
	desc = "A Diyurite non-lethal polearm. It has long reach and it has an internal stabilizer that allows effective usage even with just a single arm. This low power version is not as strong, nor as good at getting through blocking as its normal variant."
	icon_state = "disabler_guandao1_low"
	item_state = "disabler_guandao_low"
	force = 9

	melee_block = 5
	block_ignore_item_bonus = 30

/obj/item/weapon/disabler_sasumata
	name = "disabler sasumata"
	desc = "A Diyurite non-lethal polearm. The sasumata polearm is designed to capture people and it is capable of knocking down. Grab intent will pull people closer, disarm intent pulls them away. Help and Harm intent don't move the victim. It has long reach and it has an internal stabilizer that allows effective usage even with just a single arm."
	icon = 'icons/obj/jadeweapons.dmi'
	icon_state = "disabler_sasumata1"
	item_state = "disabler_sasumata"
	force = 5
	reach = 3
	throwforce = 25
	flags = CONDUCT
	damtype = STAMINA
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=50)
	attack_verb = list("prodded", "hit", "poked")
	hitsound = 'sound/weapons/emitter2.ogg'

	melee_block = 50
	block_ignore_item_bonus = 10
	var/weakenprob = 100
	var/allow_doublegrab = 1

/obj/item/weapon/disabler_sasumata/attack(mob/living/M, mob/living/user)
	..()
	if(prob(weakenprob))
		M.Weaken(1)
	switch(user.a_intent)
		if(INTENT_GRAB)
			if(get_dist(M, user) > 1)
				M.throw_at(get_step_towards(user,M), 1, 2)
			else if(user.pulling != M)
				M.visible_message("<span class='warning'>[user] grabs [M] with [src]!</span>", \
					  	"<span class='userdanger'>[user] grabs you with [src]!</span>")
				M.grabbedby(user)
				if(allow_doublegrab)
					M.grippedby(user)
		if(INTENT_DISARM)
			M.throw_at(get_step_away(M, user), 2, 2)

/obj/item/weapon/disabler_sasumata/low_power
	name = "low power disabler sasumata"
	desc = "A low power Diyurite non-lethal polearm. The sasumata polearm is designed to capture people and it is capable of knocking down. Grab intent will pull people closer, disarm intent pulls them away. Help and Harm intent don't move the victim. It has long reach and it has an internal stabilizer that allows effective usage even with just a single arm. This variant uses a low power core."
	icon_state = "disabler_sasumata1_low"
	item_state = "disabler_sasumata_low"


	force = 2
	melee_block = 10
	block_ignore_item_bonus = 5
	weakenprob = 30
	allow_doublegrab = 0



/obj/item/weapon/disabler_knife
	name = "disabler knife"
	desc = "A self defense Diyurite disabler knife. It comes with an intergrated guard assist system that allows even untrained users to block incoming melee attacks. Although it can block, it lacks the counter and disarm functionality of its blade versions."
	icon = 'icons/obj/jadeweapons.dmi'
	icon_state = "disabler_knife1"
	item_state = "disabler_knife"
	force = 8
	throwforce = 25
	flags = CONDUCT
	damtype = STAMINA
	w_class = WEIGHT_CLASS_TINY
	materials = list(MAT_METAL=50)
	attack_verb = list("sliced", "cut", "punished", "stabbed")
	hitsound = 'sound/weapons/emitter2.ogg'

	melee_block = 30
	counter_chance = 0
	disarm_chance_mod = 30
	block_ignore_item_bonus = 30

/obj/item/weapon/disabler_knife/highpower
	name = "high power disabler knife"
	desc = "A self defense Diyurite disabler knife. This one is for advanced users, it replaced the integrated guard assist with a much more effective disabler core."
	icon = 'icons/obj/jadeweapons.dmi'
	icon_state = "disabler_knife2"
	item_state = "disabler_knife"
	force = 18

	melee_block = 10
	disarm_chance_mod = 10
	block_ignore_item_bonus = 60