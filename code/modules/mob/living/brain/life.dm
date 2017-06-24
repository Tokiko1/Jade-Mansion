
/mob/living/brain/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (notransform)
		return
	if(!loc)
		return
	. = ..()
	handle_emp_damage()

/mob/living/brain/update_stat()
	if(status_flags & GODMODE)
		return


/mob/living/brain/proc/handle_emp_damage()
	if(emp_damage)
		if(stat == DEAD)
			emp_damage = 0
		else
			emp_damage = max(emp_damage-1, 0)

/mob/living/brain/handle_status_effects()
	return

/mob/living/brain/handle_disabilities()
	return



