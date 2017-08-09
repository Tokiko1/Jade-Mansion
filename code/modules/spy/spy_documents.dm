/obj/item/documents/jade
	name = "secret Jade Empire documents"
	desc = "\"Top Secret\" Jade Empire documents, filled with complex diagrams and lists of names, dates and coordinates."
	icon_state = "docs_verified"

/obj/item/documents/jade/fake
	authentic_documents = 0

/obj/item/documents/wood
	name = "secret Wood Empire documents"
	desc = "\"Top Secret\" documents detailing sensitive Wood Empire exploration intelligence."

/obj/item/documents/wood/fake
	authentic_documents = 0

/obj/item/documents/porcelain
	name = "secret Porcelain Empire documents"
	desc = "\"Top Secret\" documents filled with complex research data."

/obj/item/documents/porcelain/fake
	authentic_documents = 0

/obj/effect/jade_spawner/fake_document
	objects_to_spawn = list(/obj/item/documents/jade, /obj/item/documents/jade/fake,
	/obj/item/documents/wood, /obj/item/documents/wood/fake,
	/obj/item/documents/porcelain, /obj/item/documents/porcelain/fake
	)
	amount_to_spawn = 1







/obj/item/documents/espionage/blueprints
	name = "secret documents"
	desc = "\"Top Secret\" blueprints."
	icon_state = "blueprints"
	authentic_documents = 1
	can_verify_by_hand = 0
	verification_tool = /obj/item/device/spy_locator
	verification_time = 300
	var/list/type_of_blueprints = list("a complex device", "some kind of ship", "an unusual building", "some kind of sword", "an unusually looking vehicle", "some kind of reactor", "what appears to be a set of armor", "some new type of material.") //purely fluff

/obj/item/documents/espionage/blueprints/Initialize()
	desc += "They appear to depict [pick(type_of_blueprints)]."

	.=..()

/obj/item/documents/espionage/blueprints/fake
	authentic_documents = 0