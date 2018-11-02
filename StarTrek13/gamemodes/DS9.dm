/datum/game_mode/conquest/deepspacenine
	name = "deep space 9"
	config_tag = "deepspacenine"
	announce_span = "danger"
	announce_text = "A key outpost in the Bajor system is under threat\n\
	<span class='danger'>Starfleet must defend deep space 9 at all costs\n\
	<span class='danger'>The borg must assimilate Deep Space 9."
	faction_participants = list("starfleet", "the borg collective")
	delaywarp = 7000 //MUCH longer to prepare for the attack. You'll get about 15 mins to prepare

/datum/game_mode/conquest/deepspacenine/send_intercept() //Overriding the "security level elevated thing" because we don't really use it :)
	priority_announce("Deep space outposts have detected a transwarp signature approaching the bajor system. All crew must defend deep space 9 at all costs. An uplink has been established with a nearby shipyard linked to DS9. You can use it to fabricate ships to build a defense fleet.")
	var/ping = "<font color='green' size='2'><B><i>Borg Collective: </b> <b>Hivemind Notice:</b></i>Resource transfer request APPROVED: All drones must assimilate federation outpost #3055950. Threat level: Low. Continue with upgrades en route.</font></span>"
	for(var/mob/living/carbon/human/H in SSfaction.borg_hivemind.borgs)
		to_chat(H, ping)
	for(var/mob/M in GLOB.dead_mob_list)
		to_chat(M, ping)