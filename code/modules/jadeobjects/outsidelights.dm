//===================FLOODLIGHT==============

/obj/structure/outsidelights/floodlight
	name = "floodlight"
	desc = "A pole with powerful mounted lights on it."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floodlight"
	anchored = TRUE
	density = TRUE
	var/list/light_setting_list = list(0, 2, 5, 10)
	var/setting = 3
	light_power = 1.75

/obj/structure/outsidelights/floodlight/Initialize()
	set_light(light_setting_list[setting])

/obj/structure/outsidelights/floodlight/proc/change_setting(val, mob/user)
	if((val < 1) || (val > light_setting_list.len))
		return
	setting = val
	set_light(light_setting_list[val])
	var/setting_text = ""
	if(val > 1)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)
	switch(val)
		if(1)
			setting_text = "OFF"
		if(2)
			setting_text = "low power"
		if(3)
			setting_text = "standard lighting"
		if(4)
			setting_text = "high power"
	if(user)
		to_chat(user, "You set the [src] to [setting_text].")

/obj/structure/outsidelights/floodlight/attack_hand(mob/user)
	var/current = setting
	if(current == 1)
		current = light_setting_list.len
	else
		current--
	change_setting(current, user)
	..()

//===