/mob/living/simple_animal/mousebot
	name = "mouse bot"
	desc = "Automated pest. Makes a huge mess."
	icon_state = "mouse_bot"
	icon_living = "mouse_bot"
	speak = list("Beep!Squeek.","ERROR.","Squeek.")
	speak_emote = list("beeps")
	emote_hear = list("beeps.")
	emote_see = list("strides around mechanically.", "shakes and produces some sparks.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	density = 0
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = 2
	var/dirt_probability = 5

/mob/living/simple_animal/mousebot/Initialize()
	..()


/mob/living/simple_animal/mousebot/proc/splat()
	src.health = 0
	death()

/mob/living/simple_animal/mousebot/death(gibbed, toast)
	visible_message("<span class='warning'>[src] starts buzzing menacingly and breaks apart!</span>")
	do_sparks(5, TRUE, get_turf(src))
	var/turf/open/floor/F = get_turf(src)
	new /obj/effect/decal/cleanable/oil(F)
	var/picked_debris = pick(/obj/item/trash/gear1, /obj/item/trash/gear2)
	new picked_debris(F)
	qdel(src)


/mob/living/simple_animal/mousebot/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, "<span class='notice'>\icon[src] Squeek!</span>")
			playsound(src, 'sound/effects/mousesqueek.ogg', 100, 1)
	..()

/mob/living/simple_animal/mousebot/handle_automated_action()
	if(prob(dirt_probability))
		var/decal_to_spawn
		var/turf/open/floor/F = get_turf(src)
		if(prob(70))
			decal_to_spawn = /obj/effect/decal/cleanable/dirt
		else
			decal_to_spawn = pick(/obj/effect/decal/cleanable/oil, /obj/effect/decal/cleanable/shreds, /obj/effect/decal/cleanable/generic)
		visible_message("<span class='warning'>[src] opens its maw and ejects some waste!</span>")
		new decal_to_spawn(F)


/obj/item/trash/gear1
	name = "broken gear"
	icon_state = "brokengear1"
	resistance_flags = 0


/obj/item/trash/gear2
	name = "broken metal parts"
	icon_state = "brokengear2"
	resistance_flags = 0

