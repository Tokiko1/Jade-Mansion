/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	anchored = 1
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/New()
	..()
	tag = text("landmark*[]", name)
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x"
	anchored = 1

/obj/effect/landmark/start/New()
	GLOB.start_landmarks_list += src
	..()
	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy()
	GLOB.start_landmarks_list -= src
	return ..()

// START LANDMARKS FOLLOW. Don't change the names unless
// you are refactoring shitty landmark code.

/obj/effect/landmark/start/assistant
	name = "Assistant"

/obj/effect/landmark/start/headmaid
	name = "Head Maid"

/obj/effect/landmark/start/owner
	name = "Mansion owner"

/obj/effect/landmark/start/butler
	name = "Butler"

/obj/effect/landmark/start/downstairsmaid
	name = "Downstairs Maid"

/obj/effect/landmark/start/upstairsmaid
	name = "Upstairs Maid"

/obj/effect/landmark/start/gardener
	name = "Gardener"

/obj/effect/landmark/start/guest
	name = "Guest"

/obj/effect/landmark/start/guard
	name = "Guard"



/obj/effect/landmark/start/new_player
	name = "New Player"

// Must be on New() rather than Initialize, because players will
// join before SSatom initializes everything.
/obj/effect/landmark/start/new_player/New(loc)
	..()
	GLOB.newplayer_start += loc

/obj/effect/landmark/start/new_player/Initialize(mapload)
	..()
	qdel(src)



/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/Initialize(mapload)
	..()
	GLOB.latejoin += loc
	qdel(src)

// carp.
/obj/effect/landmark/carpspawn
	name = "carpspawn"

// lightsout.
/obj/effect/landmark/lightsout
	name = "lightsout"

// observer-start.
/obj/effect/landmark/observer_start
	name = "Observer-Start"

// revenant spawn.
/obj/effect/landmark/revenantspawn
	name = "revnantspawn"

// triple ais.
/obj/effect/landmark/tripai
	name = "tripai"

// marauder entry (XXX WTF IS MAURADER ENTRY???)

/obj/effect/landmark/marauder_entry
	name = "Marauder Entry"

// syndicate breach area (XXX I DON'T KNOW WHAT THIS IS EITHER)

/obj/effect/landmark/syndicate_breach_area
	name = "Syndicate Breach Area"

// teleport scroll landmark, XXX DOES THIS DO ANYTHING?
/obj/effect/landmark/teleport_scroll
	name = "Teleport-Scroll"

/obj/effect/landmark/syndicate_spawn
	name = "Syndicate-Spawn"

// xenos.
/obj/effect/landmark/xeno_spawn
	name = "xeno_spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload)
	..()
	GLOB.xeno_spawn += loc
	qdel(src)

// blobs.
/obj/effect/landmark/blobstart
	name = "blobstart"

/obj/effect/landmark/blobstart/Initialize(mapload)
	..()
	GLOB.blobstart += loc
	qdel(src)

/obj/effect/landmark/secequipment
	name = "secequipment"

/obj/effect/landmark/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	qdel(src)

/obj/effect/landmark/prisonwarp
	name = "prisonwarp"

/obj/effect/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	qdel(src)

/obj/effect/landmark/ert_spawn
	name = "Emergencyresponseteam"

/obj/effect/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	qdel(src)

/obj/effect/landmark/holding_facility
	name = "Holding Facility"

/obj/effect/landmark/holding_facility/Initialize(mapload)
	..()
	GLOB.holdingfacility += loc
	qdel(src)

/obj/effect/landmark/thunderdome/observe
	name = "tdomeobserve"

/obj/effect/landmark/thunderdome/observe/Initialize(mapload)
	..()
	GLOB.tdomeobserve += loc
	qdel(src)

/obj/effect/landmark/thunderdome/one
	name = "tdome1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload)
	..()
	GLOB.tdome1	+= loc
	qdel(src)

/obj/effect/landmark/thunderdome/two
	name = "tdome2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload)
	..()
	GLOB.tdome2 += loc
	qdel(src)

/obj/effect/landmark/thunderdome/admin
	name = "tdomeadmin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload)
	..()
	GLOB.tdomeadmin += loc
	qdel(src)

//generic event spawns
/obj/effect/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "x4"


/obj/effect/landmark/event_spawn/New()
	..()
	GLOB.generic_event_spawns += src

/obj/effect/landmark/event_spawn/Destroy()
	GLOB.generic_event_spawns -= src
	return ..()

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[GLOB.ruin_landmarks.len + 1]"
	..(loc)
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()
