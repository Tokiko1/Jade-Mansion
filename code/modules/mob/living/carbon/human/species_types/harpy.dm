/datum/species/harpy
	name = "Harpy"
	id = "harpy"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("tail_human", "ears", "wings")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "Large Dove")
	use_skintones = 1
	no_equip = list(slot_back)
	blacklisted = 1
	limbs_id = "human"
	skinned_type = /obj/item/stack/sheet/animalhide/human

	var/datum/action/innate/flight/fly
	var/datum/action/innate/flight_up/fly_up
	var/datum/action/innate/flight_down/fly_down

/datum/species/harpy/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/jadeharpy)


/datum/species/harpy/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	/*if(H.dna && H.dna.species &&((H.dna.features["wings"] != "Large Dove") && ("wings" in H.dna.species.mutant_bodyparts)))
		H.dna.features["wings"] = "Large Dove"
		H.update_body()*/
	if(ishuman(H)&& !fly)
		fly = new
		fly.Grant(H)
	if(ishuman(H)&& !fly_up)
		fly_up = new
		fly_up.Grant(H)
	if(ishuman(H)&& !fly_down)
		fly_down = new
		fly_down.Grant(H)


/datum/species/harpy/on_species_loss(mob/living/carbon/human/H)
	if(fly)
		fly.Remove(H)
	if(fly_up)
		fly_up.Remove(H)
	if(fly_down)
		fly_down.Remove(H)
	if(H.movement_type & FLYING)
		H.movement_type &= ~FLYING
	ToggleFlight(H,0)
	/*if(H.dna && H.dna.species &&((H.dna.features["wings"] != "None") && ("wings" in H.dna.species.mutant_bodyparts)))
		H.dna.features["wings"] = "None"
		H.update_body()*/
	..()

/datum/species/harpy/spec_life(mob/living/carbon/human/H)
	HandleFlight(H)

/datum/species/harpy/proc/HandleFlight(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		if(!CanFly(H))
			ToggleFlight(H,0)
			return 0
		return 1
	else
		return 0

/datum/species/harpy/proc/CanFly(mob/living/carbon/human/H)
	if(H.stat || H.stunned || H.weakened)
		return 0
	if(H.wear_suit && ((H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))	//Jumpsuits have tail holes, so it makes sense they have wing holes too
		to_chat(H, "Your suit blocks your wings from extending!")
		return 0
	var/turf/T = get_turf(H)
	if(!T)
		return 0

	var/datum/gas_mixture/environment = T.return_air()
	if(environment && !(environment.return_pressure() > 30))
		to_chat(H, "<span class='warning'>The atmosphere is too thin for you to fly!</span>")
		return 0
	else
		return 1

/datum/action/innate/flight
	name = "Toggle Flight"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "flight"

/datum/action/innate/flight/Activate()
	var/mob/living/carbon/human/H = owner
	var/datum/species/harpy/A = H.dna.species
	if(A.CanFly(H))
		if(H.movement_type & FLYING)
			to_chat(H, "<span class='notice'>You settle gently back onto the ground...</span>")
			A.ToggleFlight(H,0)
			H.update_canmove()
		else
			to_chat(H, "<span class='notice'>You beat your wings and begin to hover gently above the ground...</span>")
			H.resting = 0
			A.ToggleFlight(H,1)
			H.update_canmove()

/datum/action/innate/flight_up
	name = "Fly Upwards"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "flight_up"

/datum/action/innate/flight_up/Activate()
	var/mob/living/carbon/human/H = owner
	if(H.movement_type & FLYING)
		if(H.z >= GLOB.JADE_MAX_MAP_Z_LEVEL)
			to_chat(H, "<span class='notice'>You cannot fly any higher.</span>")
			return
		var/turf/above = locate(H.x, H.y, H.z+1)
		if(!above)
			return
		if(istype(above, /turf/open/hole))
			to_chat(H, "<span class='notice'>You fly upwards.</span>")
			H.forceMove(above)
		else
			to_chat(H, "<span class='notice'>There is something above you that blocks you from ascending.</span>")
			return
	else
		to_chat(H, "<span class='notice'>Your wings are not spread, you cannot fly now.</span>")

/datum/action/innate/flight_down
	name = "Fly Downwards"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "flight_down"

/datum/action/innate/flight_down/Activate()
	var/mob/living/carbon/human/H = owner
	if(H.movement_type & FLYING)
		if(H.z <= JADE_MIN_MAP_Z_LEVEL)
			return
		var/turf/below = locate(H.x, H.y, H.z)
		var/turf/downwards = locate(H.x, H.y, H.z-1)

		if(!below || !downwards)
			return
		if(istype(below, /turf/open/hole) && !downwards.density)
			to_chat(H, "<span class='notice'>You fly downwards.</span>")
			H.forceMove(downwards)
		else
			to_chat(H, "<span class='notice'>There is something below you that blocks you from descending.</span>")
			return



/datum/species/harpy/proc/flyslip(mob/living/carbon/human/H)
	var/obj/buckled_obj
	if(H.buckled)
		buckled_obj = H.buckled

	to_chat(H, "<span class='notice'>Your wings spazz out and launch you!</span>")

	playsound(H.loc, 'sound/misc/slip.ogg', 50, 1, -3)

	for(var/obj/item/I in H.held_items)
		H.accident(I)

	var/olddir = H.dir

	H.stop_pulling()
	if(buckled_obj)
		buckled_obj.unbuckle_mob(H)
		step(buckled_obj, olddir)
	else
		for(var/i=1, i<5, i++)
			spawn (i)
				step(H, olddir)
				H.spin(1,1)
	return 1


/datum/species/harpy/spec_stun(mob/living/carbon/human/H,amount)
	if(H.movement_type & FLYING)
		ToggleFlight(H,0)
		flyslip(H)
	. = ..()

/datum/species/harpy/negates_gravity(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/harpy/space_move(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/harpy/proc/ToggleFlight(mob/living/carbon/human/H,flight)
	if(flight && CanFly(H))
		stunmod = 2
		speedmod = -1
		H.movement_type |= FLYING
		override_float = 1
		H.pass_flags |= PASSTABLE
		H.OpenWings()
	else
		stunmod = 1
		speedmod = 0
		H.movement_type &= ~FLYING
		override_float = 0
		H.pass_flags &= ~PASSTABLE
		H.CloseWings()
		if(isturf(H.loc))
			var/turf/below = H.loc
			below.Entered(H)