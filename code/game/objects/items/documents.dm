/obj/item/documents
	name = "secret documents"
	desc = "\"Top Secret\" documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	item_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	layer = MOB_LAYER
	pressure_resistance = 2
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/authentic_documents = 1
	var/can_verify_by_hand = 1
	var/verification_tool
	var/verification_time = 100

/obj/item/documents/attack_self(mob/user)
	if(can_verify_by_hand)
		verify_documents(user)
		return
	.=..()

/obj/item/documents/attackby(obj/item/W, mob/user, params)
	if(verification_tool && istype(W, verification_tool))
		verify_documents(user)
		return
	.=..()

/obj/item/documents/proc/verify_documents(mob/user) //override this if you need more checks and then ..()
	if(!verification_time)
		return
	to_chat(user, "<span class='notice'>You begin trying to verify the authenticity of [src].</span>")
	if(do_after(user, verification_time, target = src, progress = 0))
		to_chat(user, "<span class='notice'>You verify that these documents are [authentic_documents == 1 ? "real" : "fake"].</span>")
	else
		to_chat(user, "<span class='warning'>You abort verification.</span>")
	return

/obj/item/documents/syndicate/red
	name = "red secret documents"
	desc = "\"Top Secret\" documents detailing sensitive Spy Cell operational intelligence. These documents are verified with a red wax seal."
	icon_state = "docs_red"

/obj/item/documents/syndicate/blue
	name = "blue secret documents"
	desc = "\"Top Secret\" documents detailing sensitive Spy Cell operational intelligence. These documents are verified with a blue wax seal."
	icon_state = "docs_blue"

/obj/item/documents/syndicate/mining
	desc = "\"Top Secret\" documents detailing Gold Shogunate mining operations."

/obj/item/documents/photocopy
	desc = "A copy of some top-secret documents. Nobody will notice they aren't the originals... right?"
	var/forgedseal = 0
	var/copy_type = null

/obj/item/documents/photocopy/New(loc, obj/item/documents/copy=null)
	..()
	if(copy)
		copy_type = copy.type
		if(istype(copy, /obj/item/documents/photocopy)) // Copy Of A Copy Of A Copy
			var/obj/item/documents/photocopy/C = copy
			copy_type = C.copy_type

/obj/item/documents/photocopy/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/toy/crayon/red) || istype(O, /obj/item/toy/crayon/blue))
		if (forgedseal)
			to_chat(user, "<span class='warning'>You have already forged a seal on [src]!</span>")
		else
			var/obj/item/toy/crayon/C = O
			name = "[C.item_color] secret documents"
			icon_state = "docs_[C.item_color]"
			forgedseal = C.item_color
			to_chat(user, "<span class='notice'>You forge the official seal with a [C.item_color] crayon. No one will notice... right?</span>")
			update_icon()