/obj/item/weapon/disabler_blade
	name = "disabler blade"
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
	block_ignore_item_bonus = 40