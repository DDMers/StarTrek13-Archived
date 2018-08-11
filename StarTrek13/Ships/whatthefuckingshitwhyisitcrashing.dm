var/global/SUPERLAGMODE = FALSE

/atom/proc/FixServer()
	if(SUPERLAGMODE)
		to_chat(world, "Severe lag detected, engaging countermeasures!")
		SUPERLAGMODE = TRUE
	else
		to_chat(world, "Severe lag not detected!, disengaging countermeasures!")
		SUPERLAGMODE = FALSE