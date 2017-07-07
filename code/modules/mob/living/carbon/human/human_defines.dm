/mob/living/carbon/human
	initial_languages = list(/datum/language/common)
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD,ANTAG_HUD)
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	pressure_resistance = 25
	//Hair colour and style
	var/hair_color = "000"
	var/hair_style = "Bald"

	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hair_style = "Shaved"

	//Eye colour
	var/eye_color = "000"

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	var/age = 30		//Player's age (pure fluff)

	var/underwear = "Nude"	//Which underwear the player wants
	var/undershirt = "Nude" //Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backbag = DBACKPACK		//Which backpack type the player has chosen.
	var/workuniform = BLACKMAID1

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/belt = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/list/traits = list() //traits
	var/list/active_traits = list() //traits that actively process
	var/list/mood_thoughts = list() //current thoughts
	var/list/mental_breaks = list() //tantrums
	var/list/bad_ideas = list() //bad ideas

	var/total_mood = 0
	var/tantrum_active = 0
	var/mischief = 0
	var/can_see_chems = 0

	var/bleed_rate = 0 //how much are we bleeding
	var/bleedsuppress = 0 //for stopping bloodloss, eventually this will be limb-based like bleeding

	var/datum/martial_art/martial_art = null
	var/static/default_martial_art = new/datum/martial_art

	var/name_override //For temporary visible name changes

	var/drunkenness = 0 //Overall drunkenness - check handle_alcohol() in life.dm for effects
	var/datum/personal_crafting/handcrafting
	can_buckle = TRUE
	buckle_lying = FALSE
	can_ride_typecache = list(/mob/living/carbon/human, /mob/living/simple_animal/slime, /mob/living/simple_animal/parrot)