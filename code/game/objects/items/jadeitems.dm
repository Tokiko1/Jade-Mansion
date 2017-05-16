/obj/item/doorkey/
	name = "door key"
	icon = 'icons/obj/jadeequipments.dmi'
	desc = "A keyring with a small steel key. Only useable for general doors."
	icon_state = "key"
	var/keyid = "general"
	w_class = WEIGHT_CLASS_TINY

/obj/item/doorkey/upstairs
	name = "upstairs maid key"
	desc = "A keyring with a small steel key. Works on all general and upstair maid doors."
	icon_state = "key_red"
	keyid = "upstairs"

/obj/item/doorkey/downstairs
	name = "downstairs maid key"
	desc = "A keyring with a small steel key. Works on all general and downstair maid doors."
	icon_state = "key_orange"
	keyid = "downstairs"

/obj/item/doorkey/between
	name = "between maid key"
	desc = "A keyring with a small steel key. Works on all general and between maid doors."
	icon_state = "key_blue"
	keyid = "between"

/obj/item/doorkey/gardener
	name = "gardener key"
	desc = "A keyring with a small steel key. Works on all general and gardener doors."
	icon_state = "key_green"
	keyid = "gardener"

/obj/item/doorkey/owner
	name = "mansion owner keychain"
	desc = "A keyring with a several keys. Works on all general and mansion owner doors."
	icon_state = "key_multi"
	keyid = "owner"

/obj/item/doorkey/master
	name = "master key"
	desc = "A golden key. It opens all doors in the mansion."
	icon_state = "key_golden"
	keyid = "owner"

/obj/item/doorkey/lockpick
	name = "lockpick"
	icon_state = "lockpick"
	desc = "A lockpick. Can be used to open some locks. Doesn't look very sturdy."
	var/broken = 0
	var/chancetobreak = 5

/obj/item/doorkey/lockpick/proc/attemptpicklock(atom/target, mob/user, difficulty)
	if(broken)
		to_chat(user, "<span class='notice'>The [name] is broken, it cannot be used!</span>")
		return
	to_chat(user, "<span class='notice'>You insert the [name] into the [target] and start picking the lock.</span>")
	playsound(src, 'sound/machines/locktoggle.ogg', 50, 1)
	var/picktime = (difficulty*0.1) + 10
	if(do_after(user, picktime, target = src))
		if(!user || !target || broken)
			return 0
		if(prob(100 - difficulty))
			to_chat(user, "<span class='notice'>You successfully pick the lock!</span>")
			return 1
		else
			to_chat(user, "<span class='notice'>You fail at picking the lock!</span>")
			if(prob(chancetobreak))
				to_chat(user, "<span class='notice'>Your lockpick breaks!</span>")
				broken = 1
				icon_state = "[icon_state]_broken"
				name = "broken [name]"
				desc = "A [name]. It's useless now."
			return 0