/datum/job/borg
	starting_faction = "the borg"

/datum/job/borg/drone
	title = "Borg Drone"
	flag = BORG_DRONE
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "The queen."
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = null