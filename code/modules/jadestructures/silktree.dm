/obj/structure/silktree/web
	icon = 'icons/effects/effects.dmi'
	icon_state = "stickyweb1"
	anchored = 1
	obj_integrity = 15
	density = 0
	name = "Giant Cobweb"
	desc = "it's stringy and sticky"

/obj/structure/silktree/web/Initialize()
	if(prob(50))
		icon_state = "stickyweb2"
	. = ..()

/obj/structure/silktree/web/Destroy()
	if(has_buckled_mobs())
		unbuckle_all_mobs(force=1)
	..()

/obj/structure/silktree/web/Crossed(atom/movable/mover)
	if(istype(mover, /mob/living/simple_animal)) //animals can pass
		return
	else if(isliving(mover))
		if(prob(40))
			entangle(mover)
			return
	..()

/obj/structure/silktree/web/proc/entangle(mob/living/V)
	if(!V)
		return
	if((V.buckled != src))
		to_chat(V, "<span class='danger'>You get stuck in the web!</span>")
		buckle_mob(V, 1)

/obj/structure/silktree/web/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M == user)
			M.visible_message(\
			"<span class='warning'>[M.name] struggles to break free from the [src]!</span>",\
			"<span class='notice'>You struggle to break free from the [src](Stay still for two minutes.)</span>",\
			"<span class='italics'>You hear some sticky noise.</span>")
			if(!do_after(M, 120, target = src))
				if(M && M.buckled)
					to_chat(M, "<span class='warning'>You fail to free yourself!</span>")
				return
		src.visible_message(text("<span class='danger'>[M] escapes the [src]!</span>"))
		unbuckle_mob(M,force=1)