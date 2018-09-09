/mob/living/carbon/human/AIborg //finite state machine broke
	name = "remote drone"
	var/AImode = TRUE //do we have a person inside of us?
	var/datum/goal/endgoal = new //What's this drone's purpose? auto assimilation of walls? assimilation of humans?
	var/obj/item/borg_tool/tool
	var/list/goals = list()
	var/datum/goal/primedirective
	var/talk = FALSE //stop them yelling infinitely
	var/atom/target //What do i want to find for my goal?
	var/turf/endpoint
	var/list/path = list()

/datum/goal
	var/name = "assimilate stuff"
	var/cost = 6
	var/requirement = 300 //Required material is 300 in this case, then he tries to find his way home.
	var/target = /obj/machinery/borg/converter///What we want to find
	var/mob/living/carbon/human/AIborg/user
	var/turf/turftarget
	var/converting = FALSE

/datum/goal/proc/do_action(mob/living/carbon/human/AIborg/M)
	user = M
	var/obj/structure/chair/borg/conversion/FS = locate(/obj/structure/chair/borg/conversion) in get_area(M)
	if(!FS)
		M.AntiSpamSay("There is no conversion suite on this ship, this drone will build one.")
		new /obj/structure/chair/borg/conversion(get_turf(M))
		M.tool.resource_amount -= M.tool.resource_cost
	if(M.tool.resource_amount >= requirement)
		var/obj/machinery/borg/converter/findme = locate(/obj/machinery/borg/converter) in get_area(M)
		if(findme)
			M.target = findme
			M.AntiSpamSay("This drone wants to find a ship converter to transfer resources.")
			if(M in orange(findme, 2))
				M.forceMove(findme.loc)
				var/Tt = M.tool.resource_amount
				if(findme.attackby(M.tool, M))
					M.target = null
					M.PingStatus("This drone has transferred [Tt] m2 of resources to [findme] in [get_area(M)]")
					return
			return //Already have one, no need to spam them
		else //Alright, we need to build one ourselves.
			M.PingStatus("This drone has built a ship converter")
			new /obj/machinery/borg/converter(get_turf(M))
			M.tool.resource_amount -= 100
	else
		if(turftarget && !converting)
			M.AntiSpamSay("This drone wants to assimilate [turftarget]")
			M.target = turftarget
			if(turftarget in orange(M, 2))
				converting = TRUE
				M.tool.mode = 1
				if(M.tool.afterattack(turftarget,M, TRUE)) //assimilate those floors
					M.target = null
					turftarget = null
				turftarget = null
				M.target = null
			converting = FALSE
		if(!turftarget)
			var/list/L = list()
			for(var/D in orange(M, 5))
				if(istype(D, /turf/open/floor))
					if(!istype(D, /turf/open/floor/borg))
						L += D
			var/turf/open/T = pick(L)
			M.target = T
			turftarget = T
			M.path = get_path_to(M, get_turf(M.target), /turf/proc/Distance, 32 + 1, 250,1) //Couldn't make a path to it, aka unreachable.
			if(!M.path.len || !M.path)
				turftarget = null
				M.target = null

/datum/goal/GetGear
	name = "get equipment"
	cost = 0
	target = /obj/structure/chair/borg/conversion
	converting = FALSE

/datum/goal/GetGear/do_action(mob/living/carbon/human/AIborg/M)
	user = M
	var/obj/structure/chair/borg/conversion/FS = locate(/obj/structure/chair/borg/conversion) in get_area(M)
	if(FS)
		M.AntiSpamSay("This drone is looking for [FS]")
		M.target = FS
	else
		M.AntiSpamSay("This drone can't find a conversion suite. Make it one")
		return
	if(M in orange(FS,2))
		M.forceMove(FS.loc)
		if(!converting)
			converting = TRUE
			if(FS.user_buckle_mob(M, M))
				M.AntiSpamSay("This drone has been upgraded and can now hunt for resources")
				M.primedirective = null
				M.target = null
				FS.user_unbuckle_mob(M,M)
				M.goals -= src
				qdel(src)
			converting = FALSE

/mob/living/carbon/human/AIborg/Initialize()
	. = ..()
	make_borg()
	new /obj/structure/chair/borg/conversion(get_turf(src))
	if(!endgoal)
		endgoal = new

/mob/living/carbon/human/AIborg/proc/letmespeak()
	talk = TRUE
	return

/mob/living/carbon/human/AIborg/proc/PingStatus(var/message)
	var/ping = "<font color='green' size='2'><B><i>Borg Collective: </b> <b>[name](autonomous mode):</b></i>[message]</font></span>"
	for(var/mob/living/carbon/human/H in SSfaction.borg_hivemind.borgs)
		for(var/obj/item/organ/borgNanites/B in H.internal_organs)
			B.receive_message(ping)
	for(var/mob/M in GLOB.dead_mob_list)
		to_chat(M, ping)

/mob/living/carbon/human/AIborg/proc/AntiSpamSay(var/message as text)
	if(!talk)
		return
	say(message)
	talk = FALSE
	addtimer(CALLBACK(src, .proc/letmespeak), 50)

/mob/living/carbon/human/AIborg/Life()
	. = ..()
	if(client)
		AImode = FALSE
	if(AImode)
		if(target)
			if(!path.len || !path)
				path = get_path_to(src, get_turf(target), /turf/proc/Distance, 32 + 1, 250,1)
		tool = locate(/obj/item/borg_tool) in contents
		if(!tool)
			if(!primedirective)
				AntiSpamSay("This drone does not have a tool. This drone will upgrade itself")
				var/datum/goal/GetGear/getgear = new
				goals += getgear
				primedirective = getgear
		if(primedirective)
			primedirective.do_action(src)
		else
			AntiSpamSay("Returning to primary operations")
			primedirective = endgoal //Return to primary operations
			target = null
			return
		if(target)
			if(!path.len || !path)
				path = get_path_to(src, get_turf(target), /turf/proc/Distance, 32 + 1, 250,1)
			if(path.len > 1)
				step_towards(src, path[1])
				if(get_turf(src) == path[1]) //Successful move
					path -= path[1]
			else if(path.len <= 1)
				if(get_turf(src) != get_turf(endpoint))
					src.forceMove(get_turf(endpoint))
				path = list()
				AntiSpamSay("This drone has finished walking")