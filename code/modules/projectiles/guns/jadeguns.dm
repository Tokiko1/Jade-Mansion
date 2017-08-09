/obj/item/weapon/gun/energy/ice_beam_gun
	icon_state = "freezegun"
	name = "ice beam gun"
	desc = "An ice beam gun that freezes stuff."
	icon = 'icons/obj/guns/energy.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/ice_beam)
	item_state = "freezegun"
	can_flashlight = 0
	modifystate = 1

//disabling guns
/obj/item/weapon/gun/energy/scatter_shotgun
	name = "disabler scatter shotgun"
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "turretlaser"
	item_state = "turretlaser"
	slot_flags = null
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_HEAVY
	can_flashlight = 0
	trigger_guard = TRIGGER_GUARD_NONE
	ammo_x_offset = 2
	modifystate = 1
	desc = "A heavy scatter lasergun that fires harmless but very effective disabler shots. Can fire 3, 5 or 10 shots at the same time, each with decreasing accuracy. Extremely good in close range."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/jade/lowscatter, /obj/item/ammo_casing/energy/laser/jade/normalscatter, /obj/item/ammo_casing/energy/laser/jade/heavyscatter)
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=2000)
	origin_tech = "combat=4;magnets=2"

	recoil = 1.5

/obj/item/weapon/gun/energy/auto_hail_gun
	icon_state = "hail"
	name = "automatic disabler rifle"
	desc = "A very efficient, low power disabler rifle meant for suppressive fire. The downside is its enourmous recoil and spread. It has a secondary, less energy efficient but much faster mode."
	icon = 'icons/obj/guns/energy.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/laser/jade/hail1, /obj/item/ammo_casing/energy/laser/jade/hail2)
	item_state = "arg"
	can_flashlight = 0
	modifystate = 1
	burst_size = 5
	spread = 30
	recoil = 1.5

	ammo_x_offset = 2
	charge_sections = 3

/obj/item/weapon/gun/energy/micro_focus_disabler
	icon_state = "mini"
	name = "focus disabler pistol"
	desc = "A small disabler pistol capable of firing accurate, medium power disabler beams. It has an internal energy recharge mechanism. It's secondary firing mode drains less power than the gun regenerates, a good way to lay down suppression fire while charging up the stronger shots."
	icon = 'icons/obj/guns/energy.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/laser/jade/focus1, /obj/item/ammo_casing/energy/laser/jade/focus2)
	item_state = "gun"
	can_flashlight = 0
	modifystate = 1
	ammo_x_offset = 1
	charge_sections = 3
	selfcharge = 1