

//maid lunchbox

/obj/item/weapon/reagent_containers/food/snacks/maidlunchbox
	name = "Maid Lunchbox"
	desc = "Looks like a regular lunchbox but anyone even looking at this can feel that it's special."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "lunchbox"
	unique_rename = 0
	list_reagents = list("nutriment" = 10, "vitamin" = 5)
	bitesize = 2
	customfoodfilling = 0 // whether it can be used as filling in custom food
	tastes  = list("cheese" = 1, "salad" = 1, "bread" = 2, "magic" = 1, "meat" = 1)
	var/nextrefill = 0
	var/owner = null
	var/boxcooldown = 1800 //3 minutes

/obj/item/weapon/reagent_containers/food/snacks/maidlunchbox/On_Consume()
	return

/obj/item/weapon/reagent_containers/food/snacks/maidlunchbox/try_delete_food(mob/user)
	to_chat(user, "<span class='warning'>The lunchbox is empty.</span>")
	return

/obj/item/weapon/reagent_containers/food/snacks/maidlunchbox/proc/refill_lunchbox(typeoffood = "default")
	switch(typeoffood)
		if("default")
			tastes  = list("cheese" = 1, "salad" = 1, "bread" = 2, "magic" = 1, "meat" = 1)
		if("meat")
			tastes  = list("meat" = 4, "salt" = 1, "cheese" = 1, "magic" = 1, "soy sauce" = 1)
		if("fish")
			tastes  = list("shark" = 1, "tuna" = 1, "whale" = 1, "oyster" = 1, "magic" = 1)
	add_initial_reagents()

/obj/item/weapon/reagent_containers/food/snacks/maidlunchbox/attack_self(mob/user)
	if(!owner)
		owner = user
		to_chat(user, "<span class='notice'>The lunchbox accepts you as its owner.</span>")
		playsound(user, 'sound/magic/Charge.ogg' , 100, 1)
	else if(owner != user)
		to_chat(user, "<span class='warning'>The lunchbox refuses to accept you. It seems that someone else already owns it.</span>")

	if(owner == user && !reagents.total_volume)
		if(REALTIMEOFDAY > nextrefill)
			to_chat(user, "<span class='notice'>The lunchbox is refills itself magically!</span>")
			refill_lunchbox(pick("default", "meat", "fish"))
			nextrefill = REALTIMEOFDAY + boxcooldown
			return
		else
			to_chat(user, "<span class='notice'>The lunchbox needs more time to refill itself.</span>")



/obj/item/weapon/reagent_containers/food/snacks/maidlunchbox/attack(mob/M, mob/user, def_zone)
	if(!owner)
		to_chat(user, "<span class='notice'>The lunchbox is unlinked. Use it to claim it.</span>")
		return
	else if(owner != M)
		to_chat(user, "<span class='warning'>The lunchbox brings up a shield that prevents eating.</span>")
		playsound(src, 'sound/magic/Charge.ogg' , 100, 1)
		return
	else
		..()