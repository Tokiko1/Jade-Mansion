/datum/job
	//The name of the job
	var/title = "NOPE"

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Determines who can demote this position
	var/department_head = list()

	//Tells the given channels that the given mob is the new department head. See communications.dm for valid channels.
	var/list/head_announce = null

	//Bitflags for the job
	var/flag = 0
	var/department_flag = 0

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Sellection screen color
	var/selection_color = "#ffffff"


	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/outfit = null

//Only override this proc
//H is usually a human unless an /equip override transformed it
/datum/job/proc/after_spawn(mob/living/H, mob/M)
	//do actions on H but send messages to M as the key may not have been transferred_yet


/datum/job/proc/announce(mob/living/carbon/human/H)
	if(head_announce)
		announce_head(H, head_announce)


//Don't override this unless the job transforms into a non-human (Silicons do this for example)
/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE)
	if(!H)
		return 0

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	if(outfit)
		H.equipOutfit(outfit, visualsOnly)

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(!visualsOnly && announce)
		announce(H)

	if(config.enforce_human_authority && (title in GLOB.command_positions))
		H.dna.features["tail_human"] = "None"
		H.dna.features["ears"] = "None"
		H.regenerate_icons()

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	. = list()

	if(config.jobs_have_minimal_access)
		. = src.minimal_access.Copy()
	else
		. = src.access.Copy()

	if(config.jobs_have_maint_access & EVERYONE_HAS_MAINT_ACCESS) //Config has global maint access set
		. |= list(GLOB.access_maint_tunnels)

/datum/job/proc/announce_head(var/mob/living/carbon/human/H, var/channels) //tells the given channel that the given mob is the new department head. See communications.dm for valid channels.
	if(H && GLOB.announcement_systems.len)
		//timer because these should come after the captain announcement
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/addtimer, CALLBACK(pick(GLOB.announcement_systems), /obj/machinery/announcement_system/proc/announce, "NEWHEAD", H.real_name, H.job, channels), 1))

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return 1	//Available in 0 days = available right now = player is old enough to play.
	return 0


/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!config.use_age_restriction_for_jobs)
		return 0
	if(!isnum(C.player_age))
		return 0 //This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

/datum/job/proc/config_check()
	return 1

/datum/job/proc/map_check()
	return TRUE


/datum/outfit/job
	name = "Standard Gear"

	var/jobtype = null

	uniform = null
	id = /obj/item/weapon/card/id
	ears = null
	belt = null
	back = /obj/item/weapon/storage/backpack
	shoes = null

	var/list/implants = null

	var/backpack = /obj/item/weapon/storage/backpack
	var/satchel  = /obj/item/weapon/storage/backpack/satchel
	var/dufflebag = /obj/item/weapon/storage/backpack/dufflebag
	var/box = null

	var/pda_slot = slot_belt

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	/*switch(H.backbag)
		if(GBACKPACK)
			back = null //Grey backpack
		if(GSATCHEL)
			back = null //Grey satchel
		if(GDUFFLEBAG)
			back = null //Grey Dufflebag
		if(LSATCHEL)
			back = null //Leather Satchel
		if(DSATCHEL)
			back = null //Department satchel
		if(DDUFFLEBAG)
			back = null //Department dufflebag
		else */
	back = /obj/item/weapon/storage/backpack/satchel //everyone gets a tiny satchel

	if(box)
		backpack_contents.Insert(1, box) // Box always takes a first slot in backpack
		backpack_contents[box] = 1

	switch(H.workuniform)
		if(BLACKMAID0)
			uniform = /obj/item/clothing/under/maidbase
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(BLACKMAID1)
			uniform = /obj/item/clothing/under/maidblack1
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(BLACKMAID2)
			uniform = /obj/item/clothing/under/maidblack2
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(BLACKMAID3)
			uniform = /obj/item/clothing/under/maidblack3
			head = /obj/item/clothing/head/maidhead2
			shoes = /obj/item/clothing/shoes/laceup
			gloves = null

		if(BLACKMAID4)
			uniform = /obj/item/clothing/under/maidblack4
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(BLACKMAID5)
			uniform = /obj/item/clothing/under/maidblack5
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(BLACKMAID6)
			uniform = /obj/item/clothing/under/maidblack6
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(BLACKMAID7)
			uniform = /obj/item/clothing/under/maidblack7
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null


		if(BLUEMAID1)
			uniform = /obj/item/clothing/under/maidblue1
			head = /obj/item/clothing/head/maidhead2
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(BLUEMAID2)
			uniform = /obj/item/clothing/under/maidblue2
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(KAPPOUGI0)
			uniform = /obj/item/clothing/under/furisodeblack
			head = /obj/item/clothing/head/maidhead2
			shoes = /obj/item/clothing/shoes/jackboots //boots and furisode, so cool!!
			gloves = null

		if(KAPPOUGI1)
			uniform = /obj/item/clothing/under/kappougi1
			head = /obj/item/clothing/head/maidhead2
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(KAPPOUGI2)
			uniform = /obj/item/clothing/under/kappougi2
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(KIMONOMAID1)
			uniform = /obj/item/clothing/under/maidkimono1
			head = /obj/item/clothing/head/maidhead1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = null

		if(CHEMISTMAID1)
			uniform = /obj/item/clothing/under/nurse1
			head = /obj/item/clothing/head/maidhead2
			gloves = /obj/item/clothing/gloves/color/latex/nitrile
			shoes = /obj/item/clothing/shoes/jackboots


		if(BUTLER1)
			uniform = /obj/item/clothing/under/suit1
			shoes = /obj/item/clothing/shoes/laceup
			head = null
			gloves = null


		if(BUTLER2)
			uniform = /obj/item/clothing/under/suit2
			shoes = /obj/item/clothing/shoes/laceup
			head = null
			gloves = null


		if(BUTLER3)
			uniform = /obj/item/clothing/under/suit3
			shoes = /obj/item/clothing/shoes/laceup
			head = null
			gloves = null


		if(OWNERDRESS1)
			uniform = /obj/item/clothing/under/casualskirtblue
			shoes = /obj/item/clothing/shoes/jackboots
			head = null
			gloves = null


		if(OWNERDRESS2)
			uniform = /obj/item/clothing/under/blackdress1
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = /obj/item/clothing/gloves/long_gloves1
			head = null

		if(OWNERDRESS3)
			uniform = /obj/item/clothing/under/whitedress2
			shoes = /obj/item/clothing/shoes/jackboots
			gloves = /obj/item/clothing/gloves/long_gloves2
			head = null

		if(CASUALSUIT1)
			uniform = /obj/item/clothing/under/jadesuits/fancysuit1
			shoes = /obj/item/clothing/shoes/laceup
			head = null
			gloves = null


		if(CASUALSUIT2)
			uniform = /obj/item/clothing/under/jadesuits/casual1
			shoes = /obj/item/clothing/shoes/jackboots
			head = null
			gloves = null


		if(CASUALSUIT3)
			uniform = /obj/item/clothing/under/jadesuits/casual2
			shoes = /obj/item/clothing/shoes/laceup
			head = null
			shoes = null


		if(DEFAULTJOBSUIT)

		else
			uniform = /obj/item/clothing/under/maidblack2 //PLACEHOLDER


/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/datum/job/J = SSjob.GetJobType(jobtype)
	if(!J)
		J = SSjob.GetJob(H.job)

	var/obj/item/weapon/card/id/C = H.wear_id
	if(istype(C))
		C.access = J.get_access()
		C.registered_name = H.real_name
		C.assignment = J.title
		C.update_label()
		H.sec_hud_set_ID()

	var/obj/item/device/pda/PDA = H.get_item_by_slot(pda_slot)
	if(istype(PDA))
		PDA.owner = H.real_name
		PDA.ownjob = J.title
		PDA.update_label()

	if(implants)
		for(var/implant_type in implants)
			var/obj/item/weapon/implant/I = new implant_type(H)
			I.implant(H, null, silent=TRUE)
