/obj/item/device/PICD
	name = "Portable Inhyeongite Containment Device"
	desc = "The PICD erases short term memory of victims. A rather simple barrier device containing an unusually large chunk of inhyeongite. Although usually used for making mechanical dolls, this mineral is also known to cause confusion and short term memory loss. Hold it up to someone's head for a moment and they will fall asleep and forget what happened in the last few minutes."
	icon = 'icons/obj/device.dmi'
	icon_state = "mind_shroud"
	item_state = ""
	w_class = WEIGHT_CLASS_SMALL
	flags = CONDUCT
	slot_flags = SLOT_BELT
	materials = list(MAT_METAL=50)

/obj/item/device/mind_shroud/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(M == user)
		to_chat(user, "<span class='spynotice'>You hold [src] close to yourself but the device does not appear to react.</span>")

	user.visible_message("<span class='userdanger'>[user] holds [src] up to [M]!</span>")
	if(do_after(user, 70, target = M))
		to_chat(user, "<span class='spynotice'>The [src] weakens its barrier and even you can feel the strange sensations emitting from the inhyeongite.</span>")
		to_chat(M, "<span class='warning'>The [src] starts emitting something strange. Thinking suddenly becomes difficult...</span>")
		playsound(loc, 'sound/effects/EMPulse.ogg', 25, 1)

		user.Jitter(20)
		user.Dizzy(20)

		M.Jitter(25)
		M.Dizzy(25)
		M.confused = max(M.confused, 25)
		M.blur_eyes(25)

		if(do_after(user, 70, target = M))
			playsound(loc, 'sound/effects/EMPulse.ogg', 50, 1)
			M.Sleeping(70)
			to_chat(M, "<span class='boldwarning'>You feel very confused.</span>")
			to_chat(M, "<span class='boldwarning'>You forget what has happened in the last few minutes that have lead up to this situation.</span>")
			to_chat(M, "<span class='boldwarning'>You also forget any interactions you had in these last few minutes, even those that weren't directly involved in this.</span>")
		return
	return

/obj/item/device/spy_locator
	name = "espionage device locator"
	desc = "A device used to locate hidden spy related objects. When on, scans for nearby active objects and notifies the user of their existance."
	icon = 'icons/obj/device.dmi'
	icon_state = "spy_locator"
	item_state = ""
	w_class = WEIGHT_CLASS_SMALL
	flags = CONDUCT
	slot_flags = SLOT_BELT
	materials = list(MAT_METAL=200)
	var/active_scanning = 0
	var/scan_timer_delay = 5 //how many process cycles it takes to scan for items
	var/scan_timer = 0 //used for processing

/obj/item/device/spy_locator/attack_self(mob/user)
	if(!active_scanning)
		to_chat(M, "<span class='spynotice'>You turn [src] on.</span>")
		icon_state = "[initial(icon_state)]_on"
		START_PROCESSING(SSobj, src)
		active_scanning = 1
	else
		to_chat(M, "<span class='spynotice'>You turn [src] off.</span>")
		icon_state = "[initial(icon_state)]_on"
		STOP_PROCESSING(SSobj, src)
		active_scanning = 0

/obj/item/device/spy_locator/process()
	if(!active_scanning)
		return

	if(scan_timer < scan_timer_delay)
		scan_timer++
		return

	scan_timer = 0

	if(!istype(loc, mob/living/carbon/human) //there's no point processing this proc any further as there is nobody to display its results to
		return

	var/mob/living/carbon/human/tool_holder = loc

	var/number_of_found_objects = 0
	for(var/obj/item/device/spy_device/scanned_object in orange(15, src)
		if(scanned_object.device_active)
			number_of_found_objects++

	if(!number_of_found_objects)
		return

	tool_holder.playsound_local(tool_holder, 'sound/machines/terminal_prompt_deny.ogg', 50, 1, -1)
	to_chat(tool_holder, "<span class='spynotice'>Detected [number_of_found_objects] active [number_of_found_objects == 1 ? "device" : "devices"] nearby.</span>") //no hightech device would display something like " 1 device(s) detected", these are spy things afterall!
	return


/obj/item/device/spy_device/
	name = "espionage device"
	desc = ""
	icon = 'icons/obj/device.dmi'
	icon_state = ""
	item_state = ""
	var/device_active