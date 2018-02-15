#define CRIT_SUCCESS_NORM 5
#define CRIT_FAILURE_NORM 5
#define CRIT_SUCCESS 2
#define CRIT_FAILURE 3

/mob
    //skills
	var/melee_skill = 28 //Unimplimented AT THE MOMENT. // Unlike the other skills, this one will determine not only how well you can land a hit, but how quickly you can grab, and other combat stuff.
	var/ranged_skill = 50 //Unimplimented AT THE MOMENT. //Rolls on contact with a mob/object to determine if you actually managed to hit it.
	var/medical_skill = 20 //Simply a success roll. Critical failure will do more harm than good, so watch out! Though, already dangerous stuff, such as surgury and usage of advanced medical machinery will only require a failure to harm.
	var/engineering_skill = 20 // Unimplimented AT THE MOMENT.
	var/pilot_skill = 15 // Could probably use some more instances, but it's in for the moment.

	//TODO: SPECIALTIES. Thus, preventing klingons from being masters of romulan technology, ect. Research staff would be more likely to spawn with the ability to operate another faction's equipment. Borg will be able to aquire these with their tool, probably. ~Cdey

	//crit stuff
	var/crit_success_chance = CRIT_SUCCESS_NORM
	var/crit_failure_chance = CRIT_FAILURE_NORM
	var/crit_success_modifier = 0
	var/crit_failure_modifier = 0


/mob/proc/skillcheck(var/skill, var/requirement, var/show_message, var/message = pick("I have failed..","This task seems too complicated for me..","It's too complicated!"))
	if(prob(get_chance(skill, requirement)))//Roll, to see if we pass. If the skill surpasses, the requirement, it'll still give a 100% or more chance of succeeding.
		if(prob(get_success_chance()))//If we pass, attempt a critical success.
			return 2
		return 1
	else
		if(show_message)//If we don't pass then we return failure
			to_chat(src, "<span class = 'warning'>[message]</span>")
		if(prob(get_failure_chance()))//And roll for a crit failure.
			return 3
		return 0



//Skill helpers.

/mob/proc/get_chance(var/num1, var/num2) //Now it's not impossible to do something simply because you're lacking in one skillpoint. ~Cdey--
	var/percentage
	percentage = num1 / num2
	percentage = percentage * 100
	return percentage

/mob/proc/get_success_chance()
	return crit_success_chance + crit_success_modifier

/mob/proc/get_failure_chance()
	return crit_failure_chance + crit_failure_modifier

/mob/proc/skillnumtodesc(var/skill)
	switch(skill)
		if(0 to 24)
			return "<font color=red><small><i>pathetic</i></small></font>"
		if(25 to 44)
			return "unskilled"
		if(45 to 59)
			return "amature"
		if(60 to 79)
			return "trained"
		if(80 to 109)
			return "expert"
		if(110 to INFINITY)
			return "<font color=#7851a9><b>LEGENDARY</b></font>"

/mob/proc/add_skills(var/melee, var/ranged, var/medical, var/engineering, var/piloting)//To make adding skills quicker.
	if(melee)
		melee_skill = melee
	if(ranged)
		ranged_skill = ranged
	if(medical)
		medical_skill = medical
	if(engineering)
		engineering_skill = engineering
	if(piloting)
		pilot_skill = piloting

/mob/living/carbon/human/verb/check_skills()//Not bothering with UIs at the moment, so have another tab option for the while. ~Cdey
	set name = "Check Skills"
	set category = "IC"

	var/message = "<big><b>Skills:</b></big>\n"
	message += "I am [skillnumtodesc(melee_skill)] at melee.\n"
	message += "I am [skillnumtodesc(ranged_skill)] with guns.\n"
	message += "I am [skillnumtodesc(medical_skill)] with medicine.\n"
	message += "I am [skillnumtodesc(engineering_skill)] at engineering.\n"
	message += "I am [skillnumtodesc(pilot_skill)] at piloting.\n"
	message += "<b>*---------------------------------*</b>"

	to_chat(src, message)