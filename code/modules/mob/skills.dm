#define CRIT_SUCCESS 3
#define CRIT_FAILURE 4
#define SUCCESS 1
#define FAILURE 2

////SKILLHANDLER\\\

/mob
	var/datum/skillhandler/skills

/mob/New()
	..()
	skills = new /datum/skillhandler

/datum/skillhandler
	var/list/stored_skills = list()

/datum/skillhandler/New()
	for(var/path in subtypesof(/datum/skill))
		stored_skills += new path()

/datum/skillhandler/proc/getskill(var/skill)
	for(var/datum/skill/S in stored_skills)
		if(S.name == skill)
			return S

/datum/skillhandler/proc/add_skill(var/skill, var/num)
	var/datum/skill/S = getskill(skill)
	if(S)
		S.value += num
		if(S.value > 10)
			S.value = 10 // NO GODS ALLOWED.. Unless and admeme modifies it.

/datum/skillhandler/proc/skillcheck(var/mob/target, var/skill, var/requirement, var/show_message = TRUE, var/message = pick("I've failed.", "I have failed to complete this task."))
	var/datum/skill/S = getskill(skill)
	if(!S)
		to_chat(target, "<span class='userdanger'>THE SKILLCHECKER SYSTEM HAS ENCOUNTERED AN ERROR. PLEASE REPORT THIS TO AN ADMINISTRATOR.</span>")
		return
	skill = S.value

	if(prob(get_chance(skill, requirement)))
		if(prob((skill - 4) * 10)) //trained+ are the only ones allowed for a crit success roll
			return CRIT_SUCCESS
		else
			return SUCCESS

	else if(!prob(get_chance(skill, requirement))) //Roll again. if we fail AGAIN, critfail.
		if(show_message)
			message = "CRITICAL FAILURE! [message]"
			if(show_message)
				to_chat(target, "<span class='userdanger'>[message]</span>")
			return CRIT_FAILURE
	else
		to_chat(target, "<span class='userdanger'>[message]</span>")
		return FAILURE

/datum/skillhandler/proc/get_chance(var/num1, var/num2)
	var/percentage = (num1 / num2) * 100
	return percentage

/datum/skillhandler/proc/skillnumtodesc(var/skill)
	switch(skill)
		if(1 to 2)
			return "<font color=red><small><i>pathetic</i></small></font>"
		if(3)
			return "unskilled"
		if(4)
			return "amature"
		if(5 to 6)
			return "trained"
		if(7)
			return "<font color=#49639A>experienced</font>"
		if(8 to 9)
			return "<font color=#49639A>an expert</font>"
		if(10 to INFINITY)
			return "<font color=#7851a9><b>LEGENDARY</b></font>"

/datum/skill
	var/name = "ERROR"
	var/value = 0

/mob/proc/show_skills(mob/living/target)//For showing the player their skills.
	if(!target.skills)
		to_chat(target, "<span class='userdanger'>ERROR: You do not have a skill handler! Contact an administrator for assistance.</span>")
		return

	var/message = "<big><b>Skills:</b></big>\n"
	var/skill_found

	for(var/datum/skill/S in target.skills.stored_skills)
		if(S.value > 0)
			skill_found = TRUE
			message += "I am [skills.skillnumtodesc(S.value)] at [S.name].\n"

	if(!skill_found)
		message += "<i>  +Pathetic. You have no skills of trade.+</i>\n"

	to_chat(target, message)

////SKILLS\\\\

/datum/skill/medical
	name = "medicine"

/datum/skill/engineering
	name = "construction and maintenance"

/datum/skill/piloting
	name = "piloting"
