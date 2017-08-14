/obj/structure/spystructure/spycache
	name = "spycache"
	icon = 'icons/obj/spystructures.dmi'
	desc = "Some kind of container. It appears to have a complex opening mechanism."
	icon_state = "spy_cache"
	density = 1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/open = 0
	var/opening_time = 250 //25 seconds, roughly...
	var/list/objects_inside = list() //objects in its contents that actually leave the spy_cache
	var/list/objects_to_put_inside = list(/obj/item/documents/espionage/blueprints) //put the objects you want to be able to get from the cache here
	var/obj/item/device/spy_device/transponder/internal_transponder
	var/make_transponder = 1
	var/explosive_entry = 1 //does this cause an explosion when spawned?
	var/explosion_size = 1

/obj/structure/spystructure/spycache/Initialize()
	if(explosive_entry) //BOOM!
		explosion(src.loc,explosion_size,explosion_size * 1.5,explosion_size * 2,flame_range = explosion_size * 2)

	if(make_transponder)
		internal_transponder = new /obj/item/device/spy_device/transponder(src)
		internal_transponder.switch_transponder_states("on") //not neccesary but just in case something went horrifyingly wrong

	for(var/OTS in objects_to_put_inside)
		var/OSTL = new OTS(src)
		objects_inside.Add(OSTL)

	.=..()

/obj/structure/spystructure/spycache/ex_act()
	return

/obj/structure/spystructure/spycache/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/device/spy_locator))
		if(open)
			to_chat(user, "<span class='spynotice'>[src] is already open and there is no way to close it again.</span>")
			return
		var/obj/item/device/spy_locator/WL = W
		if(!WL.active_scanning) //the spy locator is not on
			return
		user.visible_message("<span class='warning'>[user] is using [WL] to interface with [src]!</span>")
		if(do_after(user, opening_time, target = src))
			if(open)
				return
			open = 1
			density = 0
			playsound(loc, 'sound/machines/BoltsUp.ogg', 50, 1)
			playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
			icon_state = "[initial(icon_state)]_open"
			for(var/obj/stuff_to_eject in objects_inside)
				stuff_to_eject.loc = src.loc
			if(internal_transponder)
				internal_transponder.switch_transponder_states("off")
			return
		else
			to_chat(user, "<span class='spynotice'>You fail to open [src].</span>")

	.=..()

/obj/structure/spystructure/spycache/fake
	objects_to_put_inside = list(/obj/item/documents/espionage/blueprints/fake)


