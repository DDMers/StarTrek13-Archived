SUBSYSTEM_DEF(faction)
	name = "Faction"
	wait = 10

	flags = SS_KEEP_TIMING

	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME
	var/datum/faction/factions = list() //All factions that are currently in the game
	var/jumpgates_forbidden = TRUE //Lock jumpgates to prevent instarushes.
	var/timing_jumpgates = FALSE //Jumpgate countdown begun?
	var/mob/living/vips = list() //People involved in vip objectives
	var/mob/living/lovers = list() //people involved in VIP objectives as the VIPs lover
	var/datum/borg_hivemind/borg_hivemind
	var/datum/crew/crews = list() //available crew slots to fill
	var/Screwdrivername //Specific tool names to confuse non engineers.
	var/Wrenchname //PASS ME THE DUOTRONIC SEQUENCER! NO NOT THE TRIPHASIC REGULATOR!
	var/Crowbarname
	var/Wirecuttername
	var/obj/effect/landmark/music_controller/music_controllers = list()
	var/datum/crew/most_popular

/datum/controller/subsystem/faction/Initialize(timeofday)
	for(var/F in subtypesof(/datum/faction))
		var/datum/faction/thefaction = F
		var/datum/faction/instance = new thefaction
		factions += instance
		message_admins("DEBUG: [instance] was created")
	borg_hivemind = new
	if(!factions)
		WARNING("No factions have been created!")
	InitToolNames()
	for(var/datum/crew/S in crews)
		S.pickthefaction()
	. = ..()

/datum/controller/subsystem/faction/proc/TryToHandleJob(mob/M)
	var/datum/crew/mostpopulated
	var/datum/crew/whatcrew
	var/list/peoplemax = list()
	for(var/datum/crew/FS in crews)
		peoplemax += FS.count
	var/highest = max(peoplemax)
	for(var/datum/crew/EE in crews)
		if(EE.count >= highest)
			mostpopulated = EE //yeah it's the most populated so no need to add someone to it
			highest = EE.count
			continue
		var/quickmath = highest - EE.count
		if(quickmath >= 2) //imbalance on crews there buddy :) Show those romulans some love.
			whatcrew = EE
			whatcrew.addbyforce(M)
			return TRUE
	if(prob(70))
		whatcrew = pick(M.client.prefs.crews)
		whatcrew.addbyforce(M)
	else //We'll make it a generous chance to get the crew you want
		whatcrew = pick(crews)
		whatcrew.addbyforce(M)
	most_popular = mostpopulated
	return TRUE

/datum/controller/subsystem/faction/proc/InitToolNames()
	Screwdrivername = pick(GLOB.toolnames)
	Wrenchname = pick(GLOB.toolnames)
	if(Wrenchname == Screwdrivername)
		Wrenchname = pick(GLOB.toolnames)
	Crowbarname = pick(GLOB.toolnames)
	if(Crowbarname == Screwdrivername || Wrenchname)
		Crowbarname = pick(GLOB.toolnames)
	Wirecuttername = pick(GLOB.toolnames)
	if(Wirecuttername == Screwdrivername || Wrenchname || Crowbarname)
		Wirecuttername = pick(GLOB.toolnames)
	return

/datum/controller/subsystem/faction/fire()
	if(SSticker.current_state > GAME_STATE_PREGAME) //Round started. Now begin the countdown to allow jumpgates.
		for(var/obj/effect/landmark/music_controller/music_controller in music_controllers)
			if(music_controller && !music_controller.roundstarted)
				music_controller.play()
				music_controller.roundstarted = TRUE
		if(!timing_jumpgates)
			addtimer(CALLBACK(src, .proc/announce_jumpgates), 200)
			timing_jumpgates = TRUE
		for(var/datum/crew/S in crews)
			S.SanityCheck()
	if(factions)
		return
	else
		WARNING("There are no factions in the game!")

/datum/controller/subsystem/faction/proc/addToFaction(mob/living/carbon/human/M)
	if(ishuman(M))
		var/datum/faction/thefaction
		if(M.player_faction)
			thefaction = M.player_faction
		if(M.client.prefs.player_faction)
			thefaction = M.client.prefs.player_faction
		if(!thefaction)
			thefaction = pick(factions)
		thefaction.addMember(M)
	else
		var/datum/faction/thefaction
		thefaction = M.client.prefs.player_faction
		thefaction.addMember(M)


/datum/controller/subsystem/faction/proc/announce_jumpgates()
	priority_announce("Cross system warping will enable in 5 minutes. All crews should man their stations. Any crew posted on stations should beam over to nearby ships via the transporter", "Incoming Priority Message", 'StarTrek13/sound/trek/ship_effects/bosun.ogg')
	addtimer(CALLBACK(src, .proc/announce_jumpgates_soon), 2000)


/datum/controller/subsystem/faction/proc/announce_jumpgates_soon()
	priority_announce("Cross system warping will enable shortly, all pilots should prepare for cross system travel.", "Incoming Priority Message", 'StarTrek13/sound/trek/ship_effects/bosun.ogg')
	addtimer(CALLBACK(src, .proc/allow_jumpgates), 1000)

/datum/controller/subsystem/faction/proc/allow_jumpgates()
	priority_announce("Cross system warping is enabled. Directive: Explore and claim systems", "Incoming Priority Message", 'StarTrek13/sound/trek/ship_effects/bosun.ogg')
	jumpgates_forbidden = FALSE
	flags |= SS_NO_FIRE //we no longer need to fire, and this may(?) prevent a bug
	can_fire = FALSE