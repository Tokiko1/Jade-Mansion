#define RECYCLER_STATE_DOWN 0
#define RECYCLER_STATE_UPWARDS 1
#define RECYCLER_STATE_UP 2
#define RECYCLER_STATE_DOWNWARDS 3

/obj/machinery/waste_recycler
	name = "waste compactor"
	desc = "Crushes useless things into recycleable stuff."
	icon = 'icons/obj/jade_machinery_32x64.dmi'
	icon_state = "piston"
	anchored = 1
	density = 1
	layer = ABOVE_MOB_LAYER

	var/image/base_down
	var/base_icon = "recycler_base"
	var/image/machine_above
	var/above_icon = "recycler_above"

	var/operation_sound = 'sound/machines/airlock.ogg'
	var/floor_hit_sound = 'sound/effects/bang.ogg'
	var/machinery_state = RECYCLER_STATE_DOWN
	var/automation = 0 //working var
	var/linked_conveyor_state = 0 //working var
	var/r_autowait = 0 //working variable

	var/mob_auto_unflat
	var/mob_flat_override

	var/recycler_ID
	var/conveyor_id //set this to the conveyor(s) below it, if it exists

	var/list/conveyors = list()//working variable, don't use

	//these are vars for automation timing, so you can setup synchronized crushers, or whatever
	//set each pair of vars to the same value if you want them to stay synchronized
	var/down_to_up_min_delay = 100
	var/down_to_up_max_delay = 100

	var/down_to_up_min_conveyor_delay = 20
	var/down_to_up_max_conveyor_delay = 20

	var/conveyor_movetime = 30

	var/up_to_down_min_delay = 100
	var/up_to_down_max_delay = 100



/obj/machinery/waste_recycler/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)]_down"

	base_down = image(layer = LOW_OBJ_LAYER, icon_state = base_icon)
	machine_above += image(layer = src.layer+0.01, icon_state = above_icon)

	src.overlays += base_down
	src.overlays += machine_above

	if(recycler_ID || conveyor_id)
		desc += "It has a small sign on its side:"
		if(recycler_ID)
			desc += "Recycler ID: [recycler_ID]"
		if(conveyor_id)
			desc += "Linked Conveyor ID: [conveyor_id]"


	conveyors = list()
	for(var/obj/machinery/conveyor/C in range(10, src))
		if(C.id == conveyor_id)
			conveyors += C

/obj/machinery/waste_recycler/proc/ConveyorMove(conveyor_state = 0) //kind of a dirty proc, you could do this better if you spent more time on it
	for(var/obj/machinery/conveyor/C in conveyors)
		C.operating = conveyor_state
		C.update_move_direction()
		linked_conveyor_state = conveyor_state


/obj/machinery/waste_recycler/Destroy()
	cut_overlay(base_down)
	cut_overlay(machine_above)
	..()

/obj/machinery/waste_recycler/proc/RecyclerMoveDown()
	if(machinery_state != RECYCLER_STATE_UP)
		return 0
	machinery_state = RECYCLER_STATE_DOWNWARDS
	icon_state = "[initial(icon_state)]_downwards"
	playsound(src, operation_sound , 50, -6)
	density = 1
	sleep(2)
	if(!src)
		return

	icon_state = "[initial(icon_state)]_down"
	machinery_state = RECYCLER_STATE_DOWN
	playsound(src, floor_hit_sound , 50, -6)
	RecyclerCrushStuff()

/obj/machinery/waste_recycler/proc/RecyclerMoveUp()
	if(machinery_state != RECYCLER_STATE_DOWN)
		return 0
	machinery_state = RECYCLER_STATE_UPWARDS
	icon_state = "[initial(icon_state)]_upwards"
	playsound(src, operation_sound , 50, -6)
	sleep(8)
	if(!src)
		return
	density = 0
	icon_state = "[initial(icon_state)]_up"
	machinery_state = RECYCLER_STATE_UP

/obj/machinery/waste_recycler/proc/RecyclerCrushStuff()
	for(var/mob/living/mobS in get_turf(src))
		INVOKE_ASYNC(mobS, /atom/movable.proc/Flatten, src, 1.5, 0.5, mob_flat_override, mob_auto_unflat)
	for(var/obj/item/itemS in get_turf(src))
		if(!istype(itemS, /obj/item/flat) && !istype(itemS, /obj/item/material_pile) && !istype(itemS, /obj/item/stack/)) //turn this into a disallowed typecache or something
			var/list/stuffinitem = itemS.GetAllContents()
			for(var/mob/living/mobS in stuffinitem) //flattened mobs inside containers should not have their items deleted
				stuffinitem -= mobS.GetAllContents()

			for(var/obj/item/itemD in stuffinitem)
				if(!istype(itemD, /obj/item/flat) && !istype(itemD, /obj/item/material_pile) && !istype(itemD, /obj/item/stack/))
					if(istype(itemD, /obj/item/weapon/storage/))
						var/obj/item/weapon/storage/itemSD = itemD
						itemSD.do_quick_empty()
					var/obj/item/material_pile/newpile = new(get_turf(src))
					newpile.AddMaterials(itemD)
					qdel(itemD)


/obj/machinery/waste_recycler/proc/RecycleAutomation()  //another very dirty proc, but it should be robust enough for the time being
	if(automation)
		if(machinery_state == RECYCLER_STATE_DOWN)

			if(conveyors.len) //turn conveyors off before lifting, just in case
				ConveyorMove(conveyor_state = 0)

			sleep(rand(down_to_up_min_delay, down_to_up_max_delay)) //just waiting a bit
			if(!src || !automation)
				return

			RecyclerMoveUp() //moving up
			sleep(rand(down_to_up_min_conveyor_delay,down_to_up_max_conveyor_delay)) //tiny pause
			if(!src || !automation)
				return

			if(conveyors.len) //if conveyors exist, turn them on
				ConveyorMove(conveyor_state = 1)

				sleep(conveyor_movetime)
				if(!src || !automation)
					return

		if(machinery_state == RECYCLER_STATE_UP)

			if(conveyors.len) //turn conveyors off again.
				ConveyorMove(conveyor_state = 0)

			sleep(rand(up_to_down_min_delay, up_to_down_max_delay)) //delay before moving down
			if(!src || !automation)
				return

			RecyclerMoveDown()
			if(!src || !automation)
				return

/obj/machinery/waste_recycler/process()
	if(!r_autowait)
		r_autowait = 1
		RecycleAutomation()
		r_autowait = 0

//////////////////////the computers for this

//there are all very simple and bad but they work and got made fast, if you can read this you should improve these

///////COMMON dont actually spawn thos console
/obj/machinery/computer/recycle_computers/
	var/scandelay = 120
	var/nextscan = 0
	var/linked_recycler_ID
	var/list/linked_recyclers = list()


/obj/machinery/computer/recycle_computers/proc/RelinkRecyclers(mob/user)
	if(REALTIMEOFDAY > nextscan)
		nextscan = REALTIMEOFDAY + scandelay
		for(var/obj/machinery/waste_recycler/RecyclerS in range(10,src))
			if(RecyclerS.recycler_ID == linked_recycler_ID)
				linked_recyclers += RecyclerS
		if(linked_recyclers.len)
			to_chat(user, "<span class='notice'>Recycler found and successfully linked.</span>")
			return 1
		else
			to_chat(user, "<span class='warning'>No linked recyclers found, please try again later.</span>")
			return 0
	else
		to_chat(user, "<span class='notice'>Please wait moment before attempting a new scan.</span>")
		return 0
	return 0

/obj/machinery/computer/recycle_computers/AltClick(mob/user)
	if(!user.canUseTopic(src))
		return
	RelinkRecyclers(user)

//////////AUTO
/obj/machinery/computer/recycle_computers/recycler_automation
	name = "Recycler Automation Console"
	desc = "Toggles the recycler automation."
	icon_keyboard = "tech_key"
	icon_screen = "recycler_auto"
	light_color = LIGHT_COLOR_YELLOW
	var/autostate = 0


/obj/machinery/computer/recycle_computers/recycler_automation/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!linked_recyclers.len)
		to_chat(user, "<span class='notice'>No linked recyclers found, scanning for new ones...</span>")
		if(!RelinkRecyclers(user))
			return

	if(!autostate) //very ugly
		autostate = 1
	else
		autostate = 0

	for(var/obj/machinery/waste_recycler/RecyclerS in linked_recyclers)
		RecyclerS.automation = autostate
	src.visible_message("<span class='warning'>[user] set recycler automation to [autostate ? "on" : "off"]!</span>")

//////PISTON
/obj/machinery/computer/recycle_computers/recycler_piston
	name = "Recycler Piston Console"
	desc = "Raises and lowers the piston. Automation needs to be off for this to work."
	icon_keyboard = "tech_key"
	icon_screen = "recycler_piston"
	light_color = LIGHT_COLOR_YELLOW
	var/pistonstate = 0


/obj/machinery/computer/recycle_computers/recycler_piston/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!linked_recyclers.len)
		to_chat(user, "<span class='notice'>No linked recyclers found, scanning for new ones...</span>")
		if(!RelinkRecyclers(user))
			return

	if(pistonstate == 0)
		pistonstate = 1
	else
		pistonstate = 0

	for(var/obj/machinery/waste_recycler/RecyclerS in linked_recyclers)
		if(!RecyclerS.automation)
			if(pistonstate == 0 && RecyclerS.machinery_state == RECYCLER_STATE_UP)
				INVOKE_ASYNC(RecyclerS, /obj/machinery/waste_recycler.proc/RecyclerMoveDown)
			else if(RecyclerS.machinery_state == RECYCLER_STATE_DOWN)
				INVOKE_ASYNC(RecyclerS, /obj/machinery/waste_recycler.proc/RecyclerMoveUp)
	src.visible_message("<span class='warning'>[user] activated the piston toggle controls!</span>")

////CONVEYORS
/obj/machinery/computer/recycle_computers/recycler_conveyor
	name = "Recycler Conveyor Console"
	desc = "Toggles the piston conveyors.Automation needs to be off for this to work."
	icon_keyboard = "tech_key"
	icon_screen = "recycler_conv"
	light_color = LIGHT_COLOR_YELLOW


/obj/machinery/computer/recycle_computers/recycler_conveyor/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!linked_recyclers.len)
		to_chat(user, "<span class='notice'>No linked recyclers found, scanning for new ones...</span>")
		if(!RelinkRecyclers(user))
			return

	for(var/obj/machinery/waste_recycler/RecyclerS in linked_recyclers)
		if(!RecyclerS.automation)
			if(RecyclerS.linked_conveyor_state)
				RecyclerS.ConveyorMove(0)
			else
				RecyclerS.ConveyorMove(1)
	src.visible_message("<span class='warning'>[user] toggled the conveyor controls!</span>")

///////////////////

/obj/structure/plasticflaps/recycler //special plastic flaps that stop uncrushed OR uncrushable stuff from moving through
	name = "recycler plastic flaps"
	desc = "Very low plastic flaps that stop anything uncrushed from moving through."

/obj/structure/plasticflaps/recycler/CanPass(atom/movable/A, turf/T)
	if(istype(A, /obj/item/flat) || istype(A, /obj/item/material_pile) || istype(A, /obj/item/stack) || ( !istype(A, /obj/item)  && !istype(A, /mob/living) ) ) //turn this into a typecache
		return 1
	else
		return 0

/obj/item/weapon/paper/jade/recycler
	name = "paper - 'recycling instruction'"
	info = "<h2>Recycling Instruction Manual</h2> Recycling is very easy: First crush the thing you want recycled \
	with the waste compactor, then move the resulting material pile into the combiner. The combiner will automatically eject \
	useable material sheets once it has accumulated enough for one."







#undef RECYCLER_STATE_DOWN
#undef RECYCLER_STATE_UPWARDS
#undef RECYCLER_STATE_UP
#undef RECYCLER_STATE_DOWNWARDS