/datum/game_mode/conquest/deepspacenine
	name = "deep space 9"
	config_tag = "deepspacenine"
	announce_span = "danger"
	announce_text = "A key outpost in the Bajor system is under threat\n\
	<span class='danger'>Starfleet must defend deep space 9 at all costs\n\
	<span class='danger'>The borg must assimilate Deep Space 9."
	faction_participants = list("starfleet", "the borg collective")
	delaywarp = 7000 //MUCH longer to prepare for the attack. You'll get about 15 mins to prepare
	var/result = 0

/datum/game_mode/conquest/deepspacenine/send_intercept() //Overriding the "security level elevated thing" because we don't really use it :)
	priority_announce("Deep space outposts have detected a transwarp signature approaching the bajor system. All crew must defend deep space 9 at all costs. An uplink has been established with a nearby shipyard linked to DS9. You can use it to fabricate ships to build a defense fleet.")
	var/ping = "<font color='green' size='2'><B><i>Borg Collective: </b> <b>Hivemind Notice:</b></i> New directive: All drones must assimilate federation outpost #3055950 by claiming its station core. Threat level: Low. Continue with upgrades en route.</font></span>"
	for(var/mob/living/carbon/human/H in SSfaction.borg_hivemind.borgs)
		to_chat(H, ping)
	for(var/mob/M in GLOB.dead_mob_list)
		to_chat(M, ping)

/datum/game_mode/conquest/deepspacenine/check_win()
	var/obj/structure/overmap/ship/assimilated/goal = locate(/obj/structure/overmap/ship/assimilated) in world
	if(!goal)
		check_finished(TRUE)
		SSticker.force_ending = 1
		result = 1
		return TRUE
	var/obj/structure/overmap/away/station/system_outpost/ds9 = locate(/obj/structure/overmap/away/station/system_outpost/ds9) in world
	if(!ds9 || ds9.wrecked)
		check_finished(TRUE)
		SSticker.force_ending = 1
		result = 2
		return TRUE
	if(ds9.owner)
		if(ds9.owner.name != "starfleet")
			check_finished(TRUE)
			SSticker.force_ending = 1
			result = 3
			return TRUE
	return ..()


/datum/game_mode/conquest/deepspacenine/special_report()
	var/feedback = "Federation minor victory! Deep space 9 did not fall."
	switch(result)
		if(1)
			feedback = "Federation major victory! The borg invasion ship was destroyed. Resistance was evidently not futile."
		if(2)
			feedback = "Borg victory! Deep space 9 was destroyed! Resistance was futile."
		if(3)
			feedback = "BORG MAJOR VICTORY! Deep space 9 was captured and assimilated. Resistance was futile."
	return "<div class='panel greenborder'><span class='header'>[feedback]</div>"
