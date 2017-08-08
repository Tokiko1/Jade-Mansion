/obj/item/weapon/storage/box/spybox
	name = "box"
	desc = "Appears to be unusually spacious on the inside."
	icon_state = "spybox"
	item_state = "syringe_kit"
	resistance_flags = FLAMMABLE
	foldable = null
	illustration = "flashbang"

	w_class = WEIGHT_CLASS_SMALL
	max_w_class = WEIGHT_CLASS_BULKY
	max_combined_w_class = 60
	storage_slots = 30


//loadouts here
/obj/item/weapon/storage/box/spybox/basic/PopulateContents()
	new /obj/item/device/PICD(src)
	new /obj/item/device/spy_locator(src)
	new /obj/item/weapon/gun/energy/micro_focus_disabler(src)
	new /obj/item/weapon/gun/energy/auto_hail_gun(src)
	new /obj/effect/jade_spawner/fake_document(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/stack/sheet/metal/twenty(src)
	new /obj/item/caltrop/(src)
	new /obj/item/caltrop/(src)
	new /obj/item/caltrop/(src)
	new /obj/item/clothing/neck/remote_collar/spy(src)
	new /obj/item/collar_remote/unsafe(src)
	new /obj/item/weapon/grenade/spy_minibomb(src)
	new /obj/item/weapon/grenade/freeze(src)

/obj/item/weapon/storage/box/spybox/chaotic/PopulateContents()
	new /obj/item/device/PICD(src)
	new /obj/item/device/spy_locator(src)
	new /obj/effect/jade_spawner/fake_document(src)
	new /obj/item/weapon/gun/energy/micro_focus_disabler(src)
	new /obj/item/weapon/gun/energy/scatter_shotgun(src)
	new /obj/item/clothing/neck/remote_collar/spy(src)
	new /obj/item/clothing/neck/remote_collar/spy(src)
	new /obj/item/clothing/neck/remote_collar/spy(src)
	new /obj/item/clothing/neck/remote_collar/spy(src)
	new /obj/item/collar_remote/unsafe(src)
	new /obj/item/weapon/grenade/spy_minibomb(src)
	new /obj/item/weapon/grenade/spy_minibomb(src)
	new /obj/item/weapon/grenade/spy_minibomb(src)

/obj/item/weapon/storage/box/spybox/unusual/PopulateContents()
	new /obj/item/device/PICD(src)
	new /obj/item/device/spy_locator(src)
	new /obj/effect/jade_spawner/fake_document(src)
	new /obj/item/weapon/gun/energy/ice_beam_gun(src)
	new /obj/item/weapon/gun/energy/micro_focus_disabler(src)
	new /obj/item/clothing/neck/remote_collar/spy(src)
	new /obj/item/collar_remote/unsafe(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/stack/sheet/metal/twenty(src)
	new /obj/item/weapon/grenade/freeze(src)
	new /obj/item/weapon/grenade/freeze(src)
	new /obj/item/weapon/grenade/freeze(src)
	new /obj/item/weapon/grenade/freeze(src)
	new /obj/item/weapon/grenade/freeze(src)
	new /obj/item/weapon/grenade/freeze(src)

/obj/item/weapon/storage/box/spybox/stealthy/PopulateContents()
	new /obj/item/device/PICD(src)
	new /obj/item/device/spy_locator(src)
	new /obj/effect/jade_spawner/fake_document(src)
	new /obj/effect/jade_spawner/fake_document(src)
	new /obj/effect/jade_spawner/fake_document(src)
	new /obj/item/weapon/gun/energy/micro_focus_disabler(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/device/spy_device/transponder/off(src)
	new /obj/item/stack/sheet/metal/fifty(src)
	new /obj/item/stack/sheet/metal/fifty(src)
	new /obj/item/stack/sheet/metal/fifty(src)
	new /obj/item/clothing/neck/remote_collar/spy(src)
	new /obj/item/collar_remote/unsafe(src)

///spawner for the boxes

/obj/effect/jade_spawner/spyboxes
	objects_to_spawn = list(
	/obj/item/weapon/storage/box/spybox/basic,
	/obj/item/weapon/storage/box/spybox/chaotic,
	/obj/item/weapon/storage/box/spybox/unusual,
	/obj/item/weapon/storage/box/spybox/stealthy
	)
	amount_to_spawn = 1