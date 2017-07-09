//web glands
/datum/action/innate/web_glands
	name = "Produce Silkball"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "webby"
	var/silkball_cooldown = 0
	var/maxcooldowntime = 30
	var/ball_path = /obj/item/webball //for adminfun and players spitting out random nonsense.
	var/name_of_web = "a ball of web"

/datum/action/innate/web_glands/Activate()
	var/mob/living/carbon/human/player = owner
	if(silkball_cooldown <= 0)
		to_chat(player, "<span class='notice'>You spit out [name_of_web]!</span>")
		var/obj/item/B = new ball_path(player)
		player.put_in_hands(B, del_on_fail = FALSE)
		silkball_cooldown = maxcooldowntime
		START_PROCESSING(SSprocessing, src)
	else
		to_chat(player, "<span class='warning'>Your web glands are not ready yet!</span>")

/datum/action/innate/web_glands/process()
	var/mob/living/carbon/human/player = owner
	if(silkball_cooldown <= 0)
		to_chat(player, "<span class='notice'>Your web glands are ready to produce more web!</span>")
		STOP_PROCESSING(SSprocessing, src)
	else
		player.nutrition = max((player.nutrition - 2), 0)
		silkball_cooldown--

/obj/item/webball
	name = "web ball"
	icon = 'icons/obj/jadeobjects.dmi'
	desc = "Smooth and surprisingly non-sticky, for now atleast. Throw to unravel and spread sticky webs."
	icon_state = "webby_ball"
	w_class = WEIGHT_CLASS_TINY
	messy_thing = 1

/obj/item/webball/throw_impact(atom/hit_atom)
	var/turf/T = get_turf(hit_atom)
	if(T)
		visible_message("<span class='warning'>The [src.name] explodes into a sticky web!</span>")
		playsound(T, 'sound/effects/attackblob.ogg' , 100, 1)
		for(var/turf/open/turfA in circlerangeturfs(center=T,radius=1))
			if(!turfA.z_open)
				new /obj/structure/silktree/web(turfA)
	qdel(src)

//poison stinger

/datum/action/innate/poison_sting
	name = "Poison Stinger"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "sting_poison"
	var/sting_cooldown = 0
	var/maxcooldowntime = 60


/datum/action/innate/poison_sting/Activate()
	var/mob/living/carbon/human/player = owner
	if(sting_cooldown <= 0)
		to_chat(player, "<span class='notice'>You extend your stinger and stab at anyone nearby!</span>")
		var/reagent_random = pick("chloralhydrate", "tirizene", "sodium_thiopental")
		var/sting_success = 0
		for(var/mob/living/carbon/human/victim in view(2, player))
			if(victim != player)
				if(prob(20))
					to_chat(victim, "<span class='warning'>You feel a sting.</span>")
				victim.reagents.add_reagent(reagent_random, 30)
				sting_success = 1
		if(!sting_success)
			to_chat(player, "<span class='warning'>There is nobody in range!</span>")
			return
		sting_cooldown = maxcooldowntime
		START_PROCESSING(SSprocessing, src)
	else
		to_chat(player, "<span class='warning'>You are still regenerating chemicals for your sting!</span>")

/datum/action/innate/poison_sting/process()
	var/mob/living/carbon/human/player = owner
	if(sting_cooldown <= 0)
		to_chat(player, "<span class='notice'>Your poison sting ability is ready!</span>")
		STOP_PROCESSING(SSprocessing, src)
	else
		player.nutrition = max((player.nutrition - 1), 0)
		sting_cooldown--


//mind shock
/datum/action/innate/mind_shock
	name = "Cause Mindshock"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "emp"
	var/mindshock_cooldown = 0
	var/maxcooldowntime = 60


/datum/action/innate/mind_shock/Activate()
	var/mob/living/carbon/human/player = owner
	if(mindshock_cooldown <= 0)
		to_chat(player, "<span class='notice'>You focus for a bit and then release a blast of telepathic confusion shock waves!</span>")
		playsound(player, 'sound/magic/Charge.ogg' , 100, 1)
		for(var/mob/living/carbon/human/victim in view(8, player))
			if(victim != player)
				to_chat(victim, "<span class='warning'>You feel a bright, unpleasant wave enter your mind!</span>")
				victim.Jitter(25)
				victim.Dizzy(25)
				victim.confused = max(victim.confused, 25)
				victim.blur_eyes(25)
		mindshock_cooldown = maxcooldowntime
		START_PROCESSING(SSprocessing, src)
	else
		to_chat(player, "<span class='warning'>You are still recharging your telepathic ability!</span>")

/datum/action/innate/mind_shock/process()
	var/mob/living/carbon/human/player = owner
	if(mindshock_cooldown <= 0)
		to_chat(player, "<span class='notice'>Your mindshock ability is ready!</span>")
		STOP_PROCESSING(SSprocessing, src)
	else
		player.nutrition = max((player.nutrition - 1), 0)
		mindshock_cooldown--