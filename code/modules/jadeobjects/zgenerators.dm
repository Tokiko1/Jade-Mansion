
/obj/machinery/power/multiarea_apc
	name = "mansion area power controller"
	desc = "A control terminal for the area electrical systems. Press the button to turn it off or on. It has a very small internal power buffer that lasts up to 20 seconds, but no way to store power."

	icon_state = "zgen0"
	anchored = 1
	use_power = 0
	req_access = null
	obj_integrity = 200
	max_integrity = 200
	integrity_failure = 50
	resistance_flags = FIRE_PROOF
	density = 1

	var/microcharge = 20
	var/powerstate = 1
	var/list/apc_areas = list()

/obj/machinery/power/multiarea_apc/Initialize()
	updateareas()
	updatepower()
	..()

/obj/machinery/power/multiarea_apc/proc/updateareas()

	for(var/area/A in world)
	//var/list/GA = get_areas_in_z(z)
	//for(var/area/A in GA)
		if(A.apc_covered)
			apc_areas |= A

/obj/machinery/power/multiarea_apc/proc/updatepower()
	if(!apc_areas)
		return
	if(powerstate)
		for(var/area/A in apc_areas)
			A.power_light = 1
			A.power_equip = 1
			A.power_environ = 1
			A.power_change()
	else
		for(var/area/A in apc_areas)
			A.power_light = 0
			A.power_equip = 0
			A.power_environ = 0
			A.power_change()

/obj/machinery/power/multiarea_apc/process()
	if(surplus())
		microcharge = Clamp(microcharge + 1, 0, 20)
	else
		microcharge = Clamp(microcharge - 1, 0, 20)
	if(powerstate && !surplus() && !microcharge)
		icon_state = "zgen0"
		powerstate = 0
		updatepower()
		return



/obj/machinery/power/multiarea_apc/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>You press the power button.</span>")
	if(!powerstate)
		if(!surplus() && !microcharge)
			to_chat(user, "<span class='warning'>Nothing happens. Looks like there is no power.</span>")
			return
		icon_state = "zgen1"
		powerstate = 1
		updatepower()
		to_chat(user, "<span class='notice'>Power turns on.</span>")
		return
	else
		icon_state = "zgen0"
		powerstate = 0
		updatepower()
		to_chat(user, "<span class='notice'>Power turns off.</span>")
		return


/obj/machinery/power/multiarea_apc/Destroy()
	for(var/area/A in apc_areas)
		A.power_light = 0
		A.power_equip = 0
		A.power_environ = 0
		A.power_change()
	qdel(src)
	..()
