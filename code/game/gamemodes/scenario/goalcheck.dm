//abandoned for now...

/*
/datum/game_mode/scenario/proc/checkgoal(var/input1, var/input2, var/input3, var/input4, var/input5, var/input6, var/input7, var/input8)

#define INPUT_EXIST_MOB 1
#define INPUT_EXIST_MOB_MORE 2
#define INPUT_EXIST_MOB_LESS 3
#define INPUT_EXIST_OBJ 4
#define INPUT_EXIST_OBJ_MORE 5
#define INPUT_EXIST_OBJ_LESS 6
#define INPUT_MOB_EXIST_FACTION 7
#define INPUT_MOB_EXIST_FACTION_RESTRAIN 8
#define INPUT_MOB_EXIST_ROLE 9
#define INPUT_PICTURE_EXIST 10
#define INPUT_ROUNDENDGUESS_OWN 11
#define INPUT_ROUNDENDGUESS_OWN_PERCENT 12
#define INPUT_MORETHAN 13
#define INPUT_ROUNDENDGUESS_OTHER 14
#define INPUT_ROUNDENDGUESS_OTHER_PERCENT 15
#define INPUT_MAP_OBJECTIVES 16
#define INPUT_FACTION_LOSS 17

#define INPUT_ANYWHERE 1
#define INPUT_OUTSIDE 2
#define INPUT_MANSION 3
#define INPUT_PLAYERINV 4
#define INPUT_CONTENTS 5
#define INPUT_ROLEINV 6
#define INPUT_FACTIONINV 7
#define INPUT_AREA 8

#define INPUT_NOINVERT 0
#define INPUT_INVERT 1

#define SCENARIO_CHECKGOAL_MOB 1
#define SCENARIO_CHECKGOAL_OBJ 2
#define SCENARIO_CHECKGOAL_SPECIAL 3


	var/checktype
	var/second_input_clean
	var/list/second_input_list = list()
	var/stuffcount1
	var/list/moblist1 = list()
	var/goal_success


	switch(input1)
		if(INPUT_EXIST_MOB,INPUT_EXIST_MOB_MORE,INPUT_EXIST_MOB_LESS,INPUT_MOB_EXIST_FACTION,INPUT_MOB_EXIST_FACTION_RESTRAIN,INPUT_MOB_EXIST_ROLE)
			checktype = SCENARIO_CHECKGOAL_MOB
		if(INPUT_EXIST_OBJ,INPUT_EXIST_OBJ_MORE,INPUT_EXIST_OBJ_LESS,INPUT_PICTURE_EXIST,INPUT_MORETHAN)
			checktype = SCENARIO_CHECKGOAL_OBJ
		else
			checktype = SCENARIO_CHECKGOAL_SPECIAL

	switch(input2)
		if(INPUT_ANYWHERE)
			second_input_clean = world
		if(INPUT_OUTSIDE)
			for(var/area/A in world)
				if(A.outdoors)
					second_input_list |= A
			second_input_clean = second_input_list
		if(INPUT_MANSION)
			for(var/area/A in world)
				if(A.indoors)
					second_input_list |= A
		if(INPUT_PLAYERINV) //not implemented currently
		if(INPUT_CONTENTS)
			for(var/obj/stuff in world)
				if(istype(stuff, input8))
					second_input_list |= stuff.GetAllContents()
			second_input_clean = second_input_list
		if(INPUT_ROLEINV)
			for(var/mob/living/carbon/human/stuff in world)
				if(stuff.mind.assigned_role == input8)
					second_input_list |= stuff.GetAllContents()
			second_input_clean = second_input_list
		if(INPUT_FACTIONINV)
			for(var/mob/living/carbon/human/stuff in world)
				if(stuff.mind.scenario_faction == input8)
					second_input_list |= stuff.GetAllContents()
			second_input_clean = second_input_list
		if(INPUT_AREA)
			second_input_clean = input8



	switch(checktype)
		if(SCENARIO_CHECKGOAL_MOB)
			for(var/mob/check in second_input_clean)
				if(istype (check,input5))
					moblist1 |= check
					switch(input1)
						if(INPUT_MOB_EXIST_FACTION,INPUT_MOB_EXIST_FACTION_RESTRAIN,INPUT_MOB_EXIST_ROLE)
							if(istype (check, /mob/living/carbon/human))
								var/mob/living/carbon/human/player = check
								switch(input1)
									if(INPUT_MOB_EXIST_FACTION)
										if(player.mind.scenario_faction == input6)
											stuffcount1++
									if(INPUT_MOB_EXIST_FACTION_RESTRAIN)
										if(player.mind.scenario_faction == input6 && player.restrained())
											stuffcount1++
									if(INPUT_MOB_EXIST_ROLE)
										if(player.mind.assigned_role == input6)
											stuffcount1++
						else
							stuffcount1++
			switch(input1)
				if(INPUT_EXIST_MOB_LESS)
					if(input4 >= stuffcount1)
						goal_success = 1
				else
					if(stuffcount1 >= input4 && stuffcount1 > 0)
						goal_success = 1
			message_admins("[goal_success]")
		if(SCENARIO_CHECKGOAL_OBJ)
		if(SCENARIO_CHECKGOAL_SPECIAL)
*/