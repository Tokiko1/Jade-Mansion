//shoe related restraints


/obj/item/clothing/shoes/bootcuffs
	name = "movement restrainer boots"
	desc = "A special pair of boots that makes movement very, very difficult. Warning: They cannot be taken off easily without outside help."
	icon_state = "jackboots"

	breakouttime = 300
	can_resist = 1
	stop_remove = 1
	slowdown = SHOES_SLOWDOWN+4

/obj/item/clothing/shoes/bootcuffsstopper
	name = "movement stopper cuffs"
	desc = "A pair of cuffs that makes movement impossible. Anyone wearing these is unable to walk a single step."
	icon_state = "jackboots"

	breakouttime = 300
	can_resist = 1
	stop_remove = 1
	can_move_restrain = 1

//neck restraints
/obj/item/clothing/neck/remote_collar
	name = "remote collar"
	desc = "A collar with advanced barrier technology that can remotely stop its wearer from moving."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "remote_collar" //set these
	item_state = ""	 //inhands
	item_color = "remote_collar"
	w_class = WEIGHT_CLASS_SMALL
	var/collarID = ""
	var/bind_active = 0
	var/current_mode = "unlock"
	var/list/avaible_modes = list("unlock", "soft lock", "lock", "restrain", "full restrain")

	var/unsecure_frequency = 1 //this determines if universal remotes can find/operate this collar or not
	var/hidden_ID = 0 //the ID is hidden, it is not engraved on the tag and doesn't appear in the name either

	var/cuff_icon = 'icons/obj/cuffs.dmi'
	var/cuff_icon_state = "binding"

	breakouttime = 2000

	restrain = 0
	can_move_restrain = 0
	stand_up_restrain = 0
	can_resist = 0
	stop_remove = 0
	can_move_restrain = 0
	not_removeable = 0


/obj/item/clothing/neck/remote_collar/Initialize()
	if(!collarID)
		collarID = "ID#[rand(0, 10000)]"
	if(!hidden_ID)
		desc += "The tag has an engraved ID number: [collarID]"
		name += " [collarID]"
	.=..()

/obj/item/clothing/neck/remote_collar/proc/receive_cuffsignal(received_signal)
	if(!received_signal || received_signal == current_mode || !(received_signal in avaible_modes))
		return

	var/collar_worn = 0
	var/mob/living/carbon/human/C
	if(ishuman(loc))
		C = loc
		if(!(src in C.get_all_slots() ) ) //we are being carried but not actually worn
			return
		else
			collar_worn = TRUE
	else
		return

	switch(received_signal)
		if("unlock")
			restrain = 0
			can_move_restrain = 0
			stand_up_restrain = 0
			can_resist = 0
			stop_remove = 0
			not_removeable = 0
			bind_active = 0
			if(C && collar_worn)
				C.update_inv_neck()
				C.update_canmove()
				C.update_action_buttons_icon()
				to_chat(C, "<span class='notice'>The [name] opens.</span>")
			current_mode = "unlock"

		if("soft lock")
			restrain = 0
			can_move_restrain = 0
			stand_up_restrain = 0
			can_resist = 1
			stop_remove = 1
			can_move_restrain = 0
			not_removeable = 1
			bind_active = 0
			if(C && collar_worn)
				C.update_inv_neck()
				C.update_canmove()
				C.update_action_buttons_icon()
				to_chat(C, "<span class='warning'>The [name] moves for a moment.</span>")
			current_mode = "soft lock"
		if("lock")
			restrain = 0
			can_move_restrain = 0
			stand_up_restrain = 0
			can_resist = 0
			stop_remove = 1
			can_move_restrain = 0
			not_removeable = 1
			bind_active = 0
			if(C && collar_worn)
				C.update_inv_neck()
				C.update_canmove()
				C.update_action_buttons_icon()
				to_chat(C, "<span class='warning'>The [name] moves for a moment.</span>")
			current_mode = "lock"
		if("restrain")
			restrain = 1
			can_move_restrain = 0
			stand_up_restrain = 0
			can_resist = 0
			stop_remove = 1
			can_move_restrain = 0
			not_removeable = 1
			bind_active = 1
			if(C && collar_worn)
				C.update_inv_neck()
				C.update_canmove()
				C.update_action_buttons_icon()
				C.drop_all_held_items()
				to_chat(C, "<span class='warning'>The [name] glows and emits a barrier around you.</span>")
			current_mode = "restrain"
		if("full restrain")
			restrain = 1
			can_move_restrain = 1
			stand_up_restrain = 0
			can_resist = 0
			stop_remove = 1
			can_move_restrain = 1
			not_removeable = 1
			bind_active = 1
			if(C && collar_worn)
				C.update_inv_neck()
				C.update_canmove()
				C.update_action_buttons_icon()
				C.drop_all_held_items()
				to_chat(C, "<span class='warning'>The [name] glows and emits a barrier around you!</span>")
			current_mode = "full restrain"
	..()


/obj/item/clothing/neck/remote_collar/worn_overlays(isinhands)
    . = list()
    if(!isinhands && bind_active)
        . += image(layer = MOB_LAYER-0.01, icon = cuff_icon, icon_state = cuff_icon_state)
        . += image(layer = MOB_LAYER+0.01, icon = cuff_icon, icon_state = "[cuff_icon_state]_top")


/obj/item/clothing/neck/remote_collar/Destroy()
	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc
		if(src in C.get_all_slots() ) //we are being worn, update their state
			C.update_inv_neck()
			C.update_canmove()
			C.update_action_buttons_icon()
	.=..()

/obj/item/clothing/neck/remote_collar/prelocked
	name = "secure remote collar"
	desc = "A collar with advanced barrier technology that can remotely stop its wearer from moving. This one is especially safe and cannot be removed. You knew what you were getting into."
	avaible_modes = list("lock", "restrain", "full restrain")
	current_mode = "lock"
	restrain = 0
	can_move_restrain = 0
	stand_up_restrain = 0
	can_resist = 0
	stop_remove = 1
	can_move_restrain = 0
	not_removeable = 1
	bind_active = 0

/obj/item/clothing/neck/remote_collar/prelocked/proc/PutNameInID(var/mob/living/carbon/human/ID_target)
	if(!ID_target)
		return
	collarID = "ID#[ID_target.real_name]"
	desc = initial(desc)
	name = initial(name)

	if(!hidden_ID)
		desc += "The tag has an engraved ID: [collarID]"
		name += " [collarID]"
	.=..()



/obj/item/clothing/neck/remote_collar/spy
	unsecure_frequency = 0
	hidden_ID = 1
	desc = "A special collar with advanced barrier technology to restrain its wearer. This is a special one that automatically locks upon being applied and has no visible ID, thought it appears it can still be scanned by the remote."


/obj/item/clothing/neck/remote_collar/spy/equipped(mob/user, slot)
	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc
		if(!(src in C.get_all_slots() ) )
			return //someone just put us into their hands, no need to lock shut

	user.visible_message("<span class='warning'>The collar shuts closed immediatly!</span>")
	restrain = 0
	can_move_restrain = 0
	stand_up_restrain = 0
	can_resist = 0
	stop_remove = 1
	can_move_restrain = 0
	not_removeable = 1
	bind_active = 0
	user.update_inv_neck()
	user.update_canmove()
	user.update_action_buttons_icon()
	current_mode = "lock"
	. = ..()


//////////////Cuff Remotes///////

/obj/item/collar_remote
	name = "collar remote"
	icon = 'icons/obj/cuffs.dmi'
	desc = "A remote for collars. Lets you send signals to remote collars. Swipe a remote collar at the scanner to automatically link it."
	icon_state = "remote"
	var/remoteID = ""
	var/remote_safety = 1
	var/universal = 0
	var/obj/item/clothing/neck/remote_collar/linked_collar
	var/list/modes_avaible = list("unlock", "soft lock", "lock", "restrain", "full restrain")

	w_class = WEIGHT_CLASS_TINY


/obj/item/collar_remote/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/clothing/neck/remote_collar))
		if(!CheckValidUser(user) )
			return

		if(universal)
			to_chat(user, "<span class='notice'>The [name] lacks am ID scanner.</span>.")
			return
		var/obj/item/clothing/neck/remote_collar/collarS = W
		remoteID = collarS.collarID
		if(remoteID)
			to_chat(user, "<span class='notice'>The [name] successfully identified and copied the ID tag. New ID set to [remoteID]</span>.")
		return
	..()

/obj/item/collar_remote/proc/IDset(mob/user)
	if(universal) //universal remotes dont get linked IDs
		return

	var/IDchoice = alert(user,"Set ID now?",,"Enter ID manually","Abort")
	switch(IDchoice)
		if("Enter ID manually")
			var/IDentered = stripped_input(user, "Enter ID.")
			if(IDentered)
				remoteID = IDentered
				if(remoteID)
					to_chat(user, "<span class='notice'>ID successfully set to [remoteID].</span>")
					linked_collar = null
					return remoteID
			else
				return 0
		else
			return 0

/obj/item/collar_remote/proc/link_collar(mob/user)
	var/list/collars_avaible = list()
	for(var/obj/item/clothing/neck/remote_collar/collarC) //this might be a bit costly maybe
		if(collarC.collarID == remoteID || (universal && collarC.unsecure_frequency))
			collars_avaible.Add(collarC)

	if(!collars_avaible.len)
		to_chat(user, "<span class='notice'>No collars have been found.</span>")
		if(!universal)
			to_chat(user, "<span class='notice'>Please make sure you have entered the correct ID.</span>")
			IDset(user)
			return 0
	else if(collars_avaible.len > 1)
		to_chat(user, "<span class='notice'>Multiple collars detected! Please select one.</span>")
		var/client/selection = input("Please, select a collar.", "Collar Selection", null, null) as null|anything in collars_avaible
		if(!selection)
			return 0
		linked_collar = selection
		return 1
	else if(collars_avaible.len == 1)
		linked_collar = pick(collars_avaible)
		return 1

/obj/item/collar_remote/proc/TryToSendCollarSignal(mob/user)
	if(linked_collar)
		var/list/options_allowed = list()
		options_allowed = modes_avaible & linked_collar.avaible_modes

		var/client/selection = input("Please, select the collar mode you desire.", "Mode Selection", null, null) as null|anything in options_allowed
		if(!selection || !linked_collar)
			return 0
		linked_collar.receive_cuffsignal(selection)
		return selection

/obj/item/collar_remote/proc/CheckValidUser(mob/user)
	//uncomment the code below if people start with collars and link it to their own collar

	//if(ishuman(user)) //check if the user attempting to operate the collar started with a collar
		//var/mob/living/carbon/human/S = user
		//if(S.restrain_role && remote_safety)
			//to_chat(user, "<span class='warning'>Error: User [S.name] is disallowed from operating this device. Aborting.</span>")
			//return 0
	return 1

/obj/item/collar_remote/attack_self(mob/user)
	if(!remoteID && !universal)
		to_chat(user, "<span class='notice'>No ID set. Please swipe a remote collar or enter the ID now.</span>")
		if(!IDset(user))
			return

	if(!CheckValidUser(user) )
		return

	if(!linked_collar)
		if(!link_collar(user))
			return

	var/choice = alert(user,"What would you like to do?",,"Set Collar Mode","Change ID / Change Collar","Cancel")
	switch(choice)
		if("Set Collar Mode")
			if(TryToSendCollarSignal(user))
				to_chat(user, "<span class='notice'>Signal successfully sent!</span>")
			return
		if("Change ID / Change Collar")
			if(!universal) //No need to input an ID with an universal remote
				IDset(user)
			else
				link_collar(user)
			return
		if("Cancel")
			return
	..()

/obj/item/collar_remote/universal
	name = "universal collar remote"
	icon = 'icons/obj/cuffs.dmi'
	desc = "This is a special collar remote, it automatically scans and finds all authorized mansion collars, no need to input IDs or swipe collars."
	icon_state = "remote_universal"
	remoteID = ""
	universal = 1

/obj/item/collar_remote/universal/unsafe
	remote_safety = 0
	desc = "This is a special collar remote, it automatically scans and finds all authorized mansion collars, no need to input IDs or swipe collars. On closer inspection, this one seems to have some safeties removed."

/obj/item/collar_remote/unsafe
	remote_safety = 0
	desc = "A remote for collars. Lets you send signals to remote collars. Swipe a remote collar at the scanner to automatically link it. On closer inspection, this one seems to have some safeties removed."