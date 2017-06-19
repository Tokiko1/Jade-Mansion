/area/outside
	icon_state = "outside"
	requires_power = 1
	always_unpowered = 0
//	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	valid_territory = 0
	outdoors = 1
	blob_allowed = 0

/area/outsidecave/
	icon_state = "cave"
	outdoors = 0
	requires_power = 1
	always_unpowered = 0


/area/inside //don't actually use this area
	icon_state = "error"
	requires_power = 1
	always_unpowered = 0
	valid_sc_research = 1
	valid_sc_defeat = 1
	purify_allowed = 1
	apc_covered = 1
	indoors = 1


/area/inside/hallways
	icon_state = "hallway"
	valid_sc_research = 0
	valid_sc_defeat = 0
	purify_allowed = 0

area/inside/stairs //stairs shouldn't have stuff spawned on them
	icon_state = "stairs"
	valid_sc_research = 0
	valid_sc_defeat = 0
	purify_allowed = 0

/area/inside/kitchen
	icon_state = "kitchen"

/area/inside/theatre
	icon_state = "theatre"

/area/inside/medical
	icon_state = "medbay"

/area/inside/power
	icon_state = "power"

/area/inside/bar
	icon_state = "bar"

/area/inside/garden
	icon_state = "garden"

/area/inside/library1
	icon_state = "library"

/area/inside/library2
	icon_state = "library2"

/area/inside/library3
	icon_state = "library3"

/area/inside/music
	icon_state = "music"

/area/inside/maint
	icon_state = "maint"

/area/inside/elec_maint
	icon_state = "elec_maint"

/area/inside/office
	icon_state = "office"

/area/inside/dressing_room
	icon_state = "dressing_room"

/area/inside/theatre_office
	icon_state = "theatre_office"

/area/inside/swimming_area
	icon_state = "swimming"

/area/inside/storage/storage_1
	icon_state = "storage"

/area/inside/storage/storage_2
	icon_state = "storage2"

/area/inside/toilet
	icon_state = "toilet"

/area/inside/backstage
	icon_state = "backstage"

/area/inside/theatre_dressing
	icon_state = "theatre_dressing"

/area/inside/swimming_dressing
	icon_state = "swimming_dressing"

/area/inside/fitness
	icon_state = "fitness"

/area/inside/diningroom
	icon_state = "diningroom"

/area/inside/backroom1
	icon_state = "backroom1"

/area/inside/sleeping_room1
	icon_state = "sleep1"

/area/inside/sleeping_room2
	icon_state = "sleep2"

/area/inside/sleeping_room3
	icon_state = "sleep3"

/area/inside/sleeping_room4
	icon_state = "sleep4"

/area/inside/sleeping_room5
	icon_state = "sleep5"

/area/inside/gambling_area
	icon_state = "gamble"

/area/inside/library_backroom1
	icon_state = "library_back1"

/area/inside/library_backroom2
	icon_state = "library_back2"

/area/inside/guard_room
	icon_state = "guard"

/area/inside/art_room
	icon_state = "art"

/area/inside/cleaning_room
	icon_state = "cleaning"

/area/inside/chem_storage
	icon_state = "chem_storage"

/area/inside/side_room1
	icon_state = "side1"

/area/inside/side_room2
	icon_state = "side2"

/area/inside/workshop
	icon_state = "workshop"

/area/inside/vault
	icon_state = "thevault"

/area/inside/delivery
	icon_state = "delivery"

/area/inside/personal_locker_room
	icon_state = "lockers"



/area/inside/freezer
	icon_state = "freezer"

/area/inside/wine_cellar
	icon_state = "winecellar"