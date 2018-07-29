/obj/structure/overmap/away/station/system_outpost //This is how you'll capture a system, which will give you points on a regular basis to be used for buying ships etc.
	name = "Barnard's star station"
	desc = "A station that coordinates all the operations within the system it occupies. You can beam aboard it to capture the outpost"
	spawn_name = "barnardstar"
	health = 100000000 //If you blow this up it'll break things
	max_health = 100000000

/area/ship/barnardstar
	name = "Barnard's star outpost"

/obj/structure/overmap/away/station/system_outpost/old
	name = "Beta Hydri Outpost"
	desc = "A station that coordinates all the operations within the system it occupies. You can beam aboard it to capture the outpost"
	spawn_name = "betahydri"
	health = 100000000 //If you blow this up it'll break things
	max_health = 100000000

/area/ship/old
	name = "Beta Hydri outpost"

/obj/structure/overmap/away/station/system_outpost/asteroid
	name = "Lagrange IV Outpost"
	desc = "A station that coordinates all the operations within the system it occupies. You can beam aboard it to capture the outpost"
	spawn_name = "lagrange"
	health = 100000000 //If you blow this up it'll break things
	max_health = 100000000

/area/ship/asteroid
	name = "Lagrange IV outpost"

/obj/structure/overmap/away/station/system_outpost/hotel
	name = "Astralis I Outpost"
	desc = "A station that coordinates all the operations within the system it occupies. You can beam aboard it to capture the outpost"
	spawn_name = "hotel"
	health = 100000000 //If you blow this up it'll break things
	max_health = 100000000

/area/ship/hotel
	name = "Astralis I outpost"


/obj/structure/overmap/away/station/system_outpost/linkto()	//weapons etc. don't link!
	for(var/obj/structure/fluff/helm/desk/tactical/T in linked_ship)
		weapons = T
		T.theship = src
	for(var/obj/machinery/space_battle/shield_generator/G in linked_ship)
		generator = G
		G.ship = src
		var/obj/structure/overmap/ship/S = src
		S.SC.shields.linked_generators += G
		G.shield_system = S.SC.shields
	for(var/obj/machinery/computer/camera_advanced/transporter_control/T in linked_ship)
		transporters += T
	for(var/obj/structure/overmap/ship/fighter/F in linked_ship)
		F.carrier_ship = src
		if(!F in fighters)
			fighters += F
	for(var/obj/structure/fluff/helm/desk/functional/F in linked_ship)
		F.our_ship = src
		F.get_ship()
	for(var/obj/structure/subsystem_monitor/M in linked_ship)
		M.our_ship = src
		M.get_ship()
	for(var/obj/structure/viewscreen/V in linked_ship)
		V.our_ship = src
	get_damageable_components()
	for(var/obj/structure/weapons_console/WC in linked_ship)
		WC.our_ship = src
	for(var/obj/structure/capture_device/CD in linked_ship)
		CD.station = src
	for(var/obj/structure/overmap/ship/runabout/R in linked_ship)
		R.carrier = src
	for(var/obj/effect/landmark/runaboutdock/SS in linked_ship)
		docks += SS


/obj/structure/capture_device
	name = "System Control Mainframe"
	desc = "The central heart of an outpost, with thousands of entries for system operation flying all over its screen. Click it with an empty hand to hack it and take control of the system it's located in."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "systemdominator"
	var/datum/faction/owner
	var/beingcaptured = FALSE
	var/hacktime = 600 //1 minute to capture
	var/obj/structure/overmap/away/station/system_outpost/station
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE

/obj/structure/capture_device/Initialize()
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/capture_device/process()
	if(owner)
		owner.addCredits(50)

/obj/structure/capture_device/CtrlClick(mob/user)
	attack_hand(user)

/obj/structure/capture_device/attack_hand(mob/living/carbon/human/user)
	if(!user.player_faction)
		if(user.client.prefs.player_faction)
			user.player_faction = user.client.prefs.player_faction
			attack_hand(user)
			return
		to_chat(user, "You are not a member of a faction! What would be the point in hacking this, then?")
		return
	if(!beingcaptured)
		if(user.player_faction == owner || user.client.prefs.player_faction == owner)
			to_chat(user, "Your faction already owns this station... What'd be the point in hacking it?")
			return
		priority_announce("Network breach detected aboard [station]: [user.player_faction] is attempting a system takeover", "Incoming Priority Message", 'StarTrek13/sound/trek/ship_effects/bosun.ogg')
		to_chat(user, "You begin hacking [src], you should buckle in to a chair to prevent people pushing you.")
		beingcaptured = TRUE
		if(do_after(user,hacktime, target = src))
			owner = user.player_faction
			to_chat(user, "You successfully hacked [src], this system now belongs to [user.player_faction]")
			beingcaptured = FALSE
			station.name = initial(station.name)
			station.name = "[station.name] ([user.player_faction])"
		beingcaptured = FALSE
	else
		to_chat(user, "Someone is already attempting a network breach!")
		return