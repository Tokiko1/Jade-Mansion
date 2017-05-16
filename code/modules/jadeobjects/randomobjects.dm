/obj/structure/jadelibrary/bookcase
	name = "bookcase"
	icon = 'icons/obj/library.dmi'
	icon_state = "book-5"
	anchored = 1
	density = 1
	opacity = 1
	resistance_flags = FLAMMABLE
	obj_integrity = 200
	max_integrity = 200

/obj/structure/jadelibrary/bookcase/Initialize()

	icon_state = "book-[rand(2,5)]"