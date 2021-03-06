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

/obj/item/device/PICD/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(M == user)
		to_chat(user, "<span class='spynotice'>You hold [src] close to yourself but the device does not appear to react.</span>")
		return

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

////

/obj/item/device/spy_locator
	name = "espionage device locator"
	desc = "A device used to locate hidden spy related objects and even interface with some of them. When on, scans for nearby active objects and notifies the user of their existance."
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
		to_chat(user, "<span class='spynotice'>You turn [src] on.</span>")
		icon_state = "[initial(icon_state)]_on"
		START_PROCESSING(SSobj, src)
		active_scanning = 1
	else
		to_chat(user, "<span class='spynotice'>You turn [src] off.</span>")
		icon_state = initial(icon_state)
		STOP_PROCESSING(SSobj, src)
		active_scanning = 0

/obj/item/device/spy_locator/process()
	if(!active_scanning)
		return

	if(scan_timer < scan_timer_delay)
		scan_timer++
		return

	scan_timer = 0

	if(!istype(loc, /mob/living/carbon/human)) //there's no point processing this proc any further as there is nobody to display its results to
		return
	var/mob/living/carbon/human/tool_holder = loc


	var/number_of_found_objects = 0
	var/list/objectsfound = list()
	for(var/obj/item/device/spy_device/scanned_object in range(15, tool_holder))
		if(scanned_object.device_active)
			if(!(scanned_object in objectsfound))
				number_of_found_objects++
				objectsfound.Add(scanned_object)
	for(var/obj/ST in range(15, tool_holder))
		for(var/obj/item/device/spy_device/scanned_object in ST.GetAllContents())
			if(scanned_object.device_active)
				if(!(scanned_object in objectsfound))
					number_of_found_objects++
					objectsfound.Add(scanned_object)
	for(var/mob/H in range(15, tool_holder))
		for(var/obj/item/device/spy_device/scanned_object in H.GetAllContents())
			if(scanned_object.device_active)
				if(!(scanned_object in objectsfound))
					number_of_found_objects++
					objectsfound.Add(scanned_object)


	if(!number_of_found_objects)
		return

	tool_holder.playsound_local(tool_holder, 'sound/machines/terminal_prompt_deny.ogg', 50, 1, -1)
	to_chat(tool_holder, "<span class='spynotice'>Detected [number_of_found_objects] active [number_of_found_objects == 1 ? "device" : "devices"] nearby.</span>") //no hightech device would display something like " 1 device(s) detected", these are spy things afterall!
	return

////

/obj/item/device/spy_device/
	name = "espionage device"
	desc = ""
	icon = 'icons/obj/device.dmi'
	icon_state = ""
	item_state = ""
	var/device_active

/obj/item/device/spy_device/recorder
	name = "clandestine recorder"
	desc = "Some kind of recording device. Comes with a miniaturized internal elemental reactor and optical camouflage."
	icon = 'icons/obj/device.dmi'
	icon_state = "spy_recorder"
	device_active = 1
	alpha = 50

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

	var/switching_device_state = 0
	var/switching_time = 100
	var/switch_timer = 0

/obj/item/device/spy_device/recorder/attack_self(mob/user)
	if(switching_device_state)
		to_chat(user, "<span class='spynotice'>The device is currently non-responsive, wait until its has finished processing.</span>")
		return

	if(!device_active)
		to_chat(user, "<span class='spynotice'>You set [src] to start powering its internal reactor.</span>")
		START_PROCESSING(SSobj, src)
		switching_device_state = 1
	else
		to_chat(user, "<span class='spynotice'>You set [src] to shut off its internal reactor.</span>")
		START_PROCESSING(SSobj, src)
		switching_device_state = 1

/obj/item/device/spy_device/recorder/process()
	if(switch_timer < switching_time)
		switch_timer++
		return
	switch_timer = 0

	if(!device_active)
		icon_state = initial(icon_state)
		alpha = initial(alpha)
		device_active = 1
	else
		icon_state = "[initial(icon_state)]_off"
		alpha = 255
		device_active = 0

	STOP_PROCESSING(SSobj, src)
	return

/obj/item/device/spy_device/transponder // a simple device to be inserted into machines or structures or other stuff
	name = "barrier transponder"
	desc = "Some absurdly complex device for continually sending out signals. It seems that this signal is undetectable unless you have a matching barrier receiving device."
	icon = 'icons/obj/device.dmi'
	icon_state = "spy_transponder"
	device_active = 1

/obj/item/device/spy_device/transponder/Initialize()
	if(device_active == 1)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = "[initial(icon_state)]_off"
	.=..()

/obj/item/device/spy_device/transponder/attack_self(mob/user)
	if(!device_active)
		to_chat(user, "<span class='spynotice'>You turn [src] on.</span>")
		switch_transponder_states("on")
		return
	else
		to_chat(user, "<span class='spynotice'>You turn [src] off.</span>")
		switch_transponder_states("off")
		return

/obj/item/device/spy_device/transponder/proc/switch_transponder_states(target_transponder_state)
	if(!target_transponder_state)
		return
	if(target_transponder_state == "on")
		device_active = 1
		icon_state = "[initial(icon_state)]_on"
	else
		device_active = 0
		icon_state = "[initial(icon_state)]_off"
	return

/obj/item/device/spy_device/transponder/off
	device_active = 0

////////////////////////