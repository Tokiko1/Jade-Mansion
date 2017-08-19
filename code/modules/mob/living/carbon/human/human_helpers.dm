
/mob/living/carbon/human/restrained(ignore_grab)
	. = (GetClothingRestrain() || ..())

//checking all equipped clothing if it restrains
//returns 1 if we are being restrained, 0 if we can move
/mob/living/carbon/human/proc/GetClothingRestrain()
	. = 0
	. = w_uniform && w_uniform.restrain
	. = .|(shoes && shoes.restrain)
	. = .|(gloves && gloves.restrain)
	. = .|(wear_suit && wear_suit.restrain)
	. = .|(wear_neck && wear_neck.restrain)
	. = .|(wear_mask && wear_mask.restrain)
	. = .|(head && head.restrain)
	. = .|(ears && ears.restrain)
	. = .|(back && back.restrain)
	. = .|(belt && belt.restrain)
//	. = .|(handcuffed && handcuffed.restrain)
//	. = .|(leg_cuffed && leg_cuffed.restrain)
	return


//checking all equipped clothing if it inhibits can_move
//returns 1 if can_move is disallowed, 0 if we can move
/mob/living/carbon/human/proc/GetClothingCanmoveRestrain()
	. = 0
	. = w_uniform && w_uniform.can_move_restrain
	. = .|(shoes && shoes.can_move_restrain)
	. = .|(gloves && gloves.can_move_restrain)
	. = .|(wear_suit && wear_suit.can_move_restrain)
	. = .|(wear_neck && wear_neck.can_move_restrain)
	. = .|(wear_mask && wear_mask.can_move_restrain)
	. = .|(head && head.can_move_restrain)
	. = .|(ears && ears.can_move_restrain)
	. = .|(back && back.can_move_restrain)
	. = .|(belt && belt.can_move_restrain)
	return

/mob/living/carbon/human/proc/GetClothingCanresist()
	. = 0
	. = w_uniform && w_uniform.can_resist
	. = .|(shoes && shoes.can_resist)
	. = .|(gloves && gloves.can_resist)
	. = .|(wear_suit && wear_suit.can_resist)
	. = .|(wear_neck && wear_neck.can_resist)
	. = .|(wear_mask && wear_mask.can_resist)
	. = .|(head && head.can_resist)
	. = .|(ears && ears.can_resist)
	. = .|(back && back.can_resist)
	. = .|(belt && belt.can_resist)
	return

/mob/living/carbon/human/proc/GetClothingCanstandRestrain()
	. = 0
	. = w_uniform && w_uniform.stand_up_restrain
	. = .|(shoes && shoes.stand_up_restrain)
	. = .|(gloves && gloves.stand_up_restrain)
	. = .|(wear_suit && wear_suit.stand_up_restrain)
	. = .|(wear_neck && wear_neck.stand_up_restrain)
	. = .|(wear_mask && wear_mask.stand_up_restrain)
	. = .|(head && head.stand_up_restrain)
	. = .|(ears && ears.stand_up_restrain)
	. = .|(back && back.stand_up_restrain)
	. = .|(belt && belt.stand_up_restrain)
	return

/mob/living/carbon/human/proc/GetClothesResistList()
	. = list()
	if(w_uniform && w_uniform.can_resist)
		. += w_uniform
	if(shoes && shoes.can_resist)
		. += shoes
	if(gloves && gloves.can_resist)
		. += gloves
	if(wear_suit && wear_suit.can_resist)
		. += wear_suit
	if(wear_neck && wear_neck.can_resist)
		. += wear_neck
	if(wear_mask && wear_mask.can_resist)
		. += wear_mask
	if(head && head.can_resist)
		. += head
	if(ears && ears.can_resist)
		. += ears
	if(back && back.can_resist)
		. += back
	if(belt && belt.can_resist)
		. += belt
	return

/mob/living/carbon/human/canBeHandcuffed()
	if(get_num_arms() >= 2)
		return TRUE
	else
		return FALSE

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(if_no_id = "No id", if_no_job = "No job")
	var/obj/item/weapon/card/id/id = get_idcard()
	if(id)
		. = id.assignment
	else
		var/obj/item/device/pda/pda = wear_id
		if(istype(pda))
			. = pda.ownjob
		else
			return if_no_id
	if(!.)
		return if_no_job

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(if_no_id = "Unknown")
	var/obj/item/weapon/card/id/id = get_idcard()
	if(id)
		return id.registered_name
	var/obj/item/device/pda/pda = wear_id
	if(istype(pda))
		return pda.owner
	return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/get_visible_name()
	var/face_name = get_face_name("")
	var/id_name = get_id_name("")
	if(name_override)
		return name_override
	if(face_name)
		if(id_name && (id_name != face_name))
			return "[face_name] (as [id_name])"
		return face_name
	if(id_name)
		return id_name
	return "Unknown"

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when Fluacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name(if_no_face="Unknown")
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return if_no_face
	if( head && (head.flags_inv&HIDEFACE) )
		return if_no_face		//Likewise for hats
	var/obj/item/bodypart/O = get_bodypart("head")
	if( !O || (status_flags&DISFIGURED) || (O.brutestate+O.burnstate)>2 || cloneloss>50 || !real_name )	//disfigured. use id-name if possible
		return if_no_face
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(if_no_id = "Unknown")
	var/obj/item/weapon/storage/wallet/wallet = wear_id
	var/obj/item/device/pda/pda = wear_id
	var/obj/item/weapon/card/id/id = wear_id
	if(istype(wallet))
		id = wallet.front_id
	if(istype(id))
		. = id.registered_name
	else if(istype(pda))
		. = pda.owner
	if(!.)
		. = if_no_id	//to prevent null-names making the mob unclickable
	return

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/get_idcard()
	if(wear_id)
		return wear_id.GetID()


/mob/living/carbon/human/abiotic(full_body = 0)
	var/abiotic_hands = FALSE
	for(var/obj/item/I in held_items)
		if(!(I.flags & NODROP))
			abiotic_hands = TRUE
			break
	if(full_body && abiotic_hands && ((back && !(back.flags&NODROP)) || (wear_mask && !(wear_mask.flags&NODROP)) || (head && !(head.flags&NODROP)) || (shoes && !(shoes.flags&NODROP)) || (w_uniform && !(w_uniform.flags&NODROP)) || (wear_suit && !(wear_suit.flags&NODROP)) || (glasses && !(glasses.flags&NODROP)) || (ears && !(ears.flags&NODROP)) || (gloves && !(gloves.flags&NODROP)) ) )
		return TRUE
	return abiotic_hands


/mob/living/carbon/human/IsAdvancedToolUser()
	return 1//Humans can use guns and such

/mob/living/carbon/human/InCritical()
	return (health <= HEALTH_THRESHOLD_CRIT && stat == UNCONSCIOUS)

/mob/living/carbon/human/reagent_check(datum/reagent/R)
	return dna.species.handle_chemicals(R,src)
	// if it returns 0, it will run the usual on_mob_life for that reagent. otherwise, it will stop after running handle_chemicals for the species.


/mob/living/carbon/human/can_track(mob/living/user)
	if(wear_id && istype(wear_id.GetID(), /obj/item/weapon/card/id/syndicate))
		return 0
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/hat = head
		if(hat.blockTracking)
			return 0

	return ..()

/mob/living/carbon/human/get_permeability_protection()
	var/list/prot = list("hands"=0, "chest"=0, "groin"=0, "legs"=0, "feet"=0, "arms"=0, "head"=0)
	for(var/obj/item/I in get_equipped_items())
		if(I.body_parts_covered & HANDS)
			prot["hands"] = max(1 - I.permeability_coefficient, prot["hands"])
		if(I.body_parts_covered & CHEST)
			prot["chest"] = max(1 - I.permeability_coefficient, prot["chest"])
		if(I.body_parts_covered & GROIN)
			prot["groin"] = max(1 - I.permeability_coefficient, prot["groin"])
		if(I.body_parts_covered & LEGS)
			prot["legs"] = max(1 - I.permeability_coefficient, prot["legs"])
		if(I.body_parts_covered & FEET)
			prot["feet"] = max(1 - I.permeability_coefficient, prot["feet"])
		if(I.body_parts_covered & ARMS)
			prot["arms"] = max(1 - I.permeability_coefficient, prot["arms"])
		if(I.body_parts_covered & HEAD)
			prot["head"] = max(1 - I.permeability_coefficient, prot["head"])
	var/protection = (prot["head"] + prot["arms"] + prot["feet"] + prot["legs"] + prot["groin"] + prot["chest"] + prot["hands"])/7
	return protection

/mob/living/carbon/human/can_use_guns(var/obj/item/weapon/gun/G)
	. = ..()

	if(G.trigger_guard == TRIGGER_GUARD_NORMAL)
		if(src.dna.check_mutation(HULK))
			to_chat(src, "<span class='warning'>Your meaty finger is much too large for the trigger guard!</span>")
			return 0
		if(NOGUNS in src.dna.species.species_traits)
			to_chat(src, "<span class='warning'>Your fingers don't fit in the trigger guard!</span>")
			return 0

	if(martial_art && martial_art.no_guns) //great dishonor to famiry
		to_chat(src, "<span class='warning'>Use of ranged weaponry would bring dishonor to the clan.</span>")
		return 0

	return .
