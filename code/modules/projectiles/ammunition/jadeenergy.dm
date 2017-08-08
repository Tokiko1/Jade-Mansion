/obj/item/ammo_casing/energy/ice_beam
	name = "ice beam lens"
	desc = "Warning: Not for freezing parasites."
	caliber = "energy"
	projectile_type = /obj/item/projectile/ice_beam
	e_cost = 100 //The amount of energy a cell needs to expend to create this shot.
	select_name = null
	notice_name = "ice"

	fire_sound = 'sound/weapons/Laser.ogg'
	firing_effect_type = /obj/effect/overlay/temp/dir_setting/firing_effect/energy

//laser scatter gun

/obj/item/ammo_casing/energy/laser/jade/lowscatter
	projectile_type = /obj/item/projectile/beam/weak_disabler
	e_cost = 50
	pellets = 3
	variance = 15
	select_name = "disable"
	notice_name = "disabler: low scatter"

/obj/item/ammo_casing/energy/laser/jade/normalscatter
	projectile_type = /obj/item/projectile/beam/weak_disabler
	e_cost = 80
	pellets = 5
	variance = 50
	select_name = "disable"
	notice_name = "disabler: high scatter"

/obj/item/ammo_casing/energy/laser/jade/heavyscatter
	projectile_type = /obj/item/projectile/beam/weak_disabler
	e_cost = 120
	pellets = 10
	variance = 90
	select_name = "disable"
	notice_name = "disabler: veryhigh scatter"

//hailgun

/obj/item/ammo_casing/energy/laser/jade/hail1
	projectile_type = /obj/item/projectile/beam/weak_disabler
	e_cost = 5
	variance = 15
	select_name = "disable"
	notice_name = "disabler: ultra efficient low power"
	delay = 3

/obj/item/ammo_casing/energy/laser/jade/hail2
	projectile_type = /obj/item/projectile/beam/weak_disabler
	e_cost = 20
	select_name = "disable"
	notice_name = "disabler: fast low power"
	delay = 1

//focus disabler

/obj/item/ammo_casing/energy/laser/jade/focus1
	projectile_type = /obj/item/projectile/beam/medium_disabler
	e_cost = 100
	select_name = "disable"
	notice_name = "disabler: medium power"
	delay = 8

/obj/item/ammo_casing/energy/laser/jade/focus2
	projectile_type = /obj/item/projectile/beam/weak_disabler
	e_cost = 10
	select_name = "disable"
	notice_name = "disabler: efficient low power"
	delay = 8