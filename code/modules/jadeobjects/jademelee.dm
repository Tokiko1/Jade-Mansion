/obj/item/weapon/disabler_blade
	name = "disabler blade"
	desc = "A sword made using a strange material called Diyurite which is able to phase through objects and people. Standard equipment for law enforcement. Although this material causes no injuries or pain, the victim still feels the unpleasant sensation of the cut. According to ancient legends, oni use tools made out of this material to cut people over and over without injuring them in the lower naraka."
	icon = 'icons/obj/jadeweapons.dmi'
	icon_state = "disabler_blade2"
	item_state = "disabler_blade"
	force = 9
	throwforce = 25
	flags = CONDUCT
	damtype = STAMINA
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT | SLOT_BACK
	materials = list(MAT_METAL=50)
	attack_verb = list("sliced", "cut", "punished", "stabbed")
	hitsound = 'sound/weapons/bladeslice.ogg'

	melee_block = 60
	counter_chance = 80
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
	desc = "A knife made using a strange material called Diyurite which is able to phase through objects and people. Unlike its blade variant, this one is not quite capable of counter attacks, but has the same disabler strenght."
	icon = 'icons/obj/jadeweapons.dmi'
	icon_state = "disabler_knife1"
	item_state = "disabler_blade"
	force = 9
	throwforce = 25
	flags = CONDUCT
	damtype = STAMINA
	w_class = WEIGHT_CLASS_TINY
	materials = list(MAT_METAL=50)
	attack_verb = list("sliced", "cut", "punished", "stabbed")
	hitsound = 'sound/weapons/bladeslice.ogg'

	melee_block = 40
	counter_chance = 0