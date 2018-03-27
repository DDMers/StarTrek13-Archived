SUBSYSTEM_DEF(faction)
	name = "Faction"
	wait = 10

	flags = SS_KEEP_TIMING

	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME
	var/datum/faction/factions = list() //All factions that are currently in the game


/datum/controller/subsystem/faction/Initialize(timeofday)
	if(!factions)
		WARNING("No factions have been created!")
	for(var/F in subtypesof(/datum/faction))
		var/datum/faction/thefaction = F
		var/datum/faction/instance = new thefaction
		factions += instance
		message_admins("DEBUG: [instance] was created")
	. = ..()

/datum/controller/subsystem/faction/fire()
	if(factions)
		return
	else
		WARNING("There are no factions in the game!")

/datum/controller/subsystem/faction/proc/addToFaction(mob/living/M)
	var/datum/faction/thefaction = M.client.prefs.player_faction
	if(!M.client.prefs.player_faction)
		thefaction = pick(factions)
	thefaction.addMember(M)