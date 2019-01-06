/*
IDEAS!
Attack patterns, special combo moves used by the tactical officer
Computer core, controls all shipboard functions, lights, doors, atmos, gravity. You can damage this to disable a load of functions
Outer hull, outer hull is repairable via a spacewalk, hull hardpoints take damage BEFORE ship health. When your outer hull goes you are vulnerable to breaches, these hardpoints can be upgraded with upgrade modules you fabricate / purchase
	Health gets renamed to structural integrity, when you lose your structural integrity field you die.
We'll steal FTL. Each system you jump to will have a random event in it, roll based on progression in game
Subsystems get persistant damage, as they take more punishment the lasting effects increase, can only be repaired with expensive relay swaps which take a while:
	Stuff like phasers burning out when they fire, torpedo tubes refusing to launch
Ship gets persistent damage, as the ship takes more of a beating the corridors get filled with rubble and battle damage. Clearing it could be dangerous....

Add super in depth sensors, shield modulation mini-game, phaser targeting console perhaps?
Skill based abilities, engineers will be able to "diagnose" systems by looking at them giving technobabble instructions on how to fix them:

--Damn, the ODN relays are fused, but perhaps if I could reverse the polarity?

Resource mining on the overmap, most likely by flying near dangerous space objects

Fluff rooms that can be upgraded like astrometrics

More scientific options (polaron bursts, reverse polarity) etc. Mainly involving the deflector. Science officers would need to memorise their techno  jargon

Cargo bays

Maybe:
Site to site transporter
Refinery
Deflector control room

INSTEAD, I think I'll incorporate the "lower decks" mechanic and allow you to take control of npc crewmembers for respawn, when the ship runs out of spare crew you're boned

Bulkheads that can be sealed from the captains office
Maybe one button per department, and jefferies bypass them? So Bridge, Engineering, Security, Medbay, Living Quarters, and Science(Transporters, chemlab, ect) or something like Bridge, EngSec, MedSci, Living Quarters?
Part of the disadvantage to locking them being that they lock off large portions and likely block you from critical areas.
So say for medbay, it seals it off protecting it's atmosphere, but also cuts off the treatment room from the supply room so they have to take a prolonged jefferies trip to reach their supplies in exchange for the protection.


*/

/datum/game_mode/voyager
	name = "odyssey"
	config_tag = "odyssey"
	announce_span = "danger"
	announce_text = "A sovereign class vessel has been ordered to test out an experimental propulsion drive...\n\
	<span class='danger'>Survive the test\n\
	<span class='danger'>Hack the blue console on each away mission to unlock a new warp target."
	faction_participants = list("starfleet")
	delaywarp = 2000 //Not very long to prepare, we want to catch them off-guard

/datum/game_mode/proc/on_allow_jumpgates() //When the timer's up...
	return

/datum/game_mode/voyager/on_allow_jumpgates()
	priority_announce("We're reading an error in the slipstream device, we'll need some time to corr- Hello? Do you read? Your signal is breakin--####nn##00--- u%^666'66543%££%%%%%%%\\-----")
	var/obj/structure/overmap/ship/federation_capitalclass/sovreign/thevoyager = locate(/obj/structure/overmap/ship/federation_capitalclass/sovreign) in GLOB.overmap_ships
	if(thevoyager)
		thevoyager.quantum_slipstream()

/datum/game_mode/voyager/send_intercept() //Overriding the "security level elevated thing" because we don't really use it :)
	priority_announce("Sovereign class cruiser, your ship has been fitted with an experimental propulsion system known as the 'slipstream' drive. We will automatically plot coordinates in a few minutes, and you can activate it when ready. Warp back to earth as soon as you have confirmed your location. Good luck, and fly safe.")
	to_chat(world,"<span class='warning'>-Listen closely to the captain's log when you reach a new system, it will give you hints. Complete the away missions by clicking the blue consoles you find, this will give you a new warp target.</span>")
	return "By the order of the galactic empire, all available ships will mount an assault to break rebel supply lines. Capture each rebel base and move on to the next, failure will not be tolerated. Your captain has been given a set of documents of the utmost importance: see that these reach their destination safely."

/area/overmap/odyssey
	name = "Uncharted sector -01"

/area/overmap/odyssey/moonoutpost
	name =  "Uncharted sector -02"

/area/overmap/odyssey/underground
	name =  "Uncharted sector -03"

/area/overmap/odyssey/caves
	name =  "Restricted sector -04"

/area/overmap/odyssey/beach
	name =  "Open sector -05"

/area/overmap/odyssey/academy
	name =  "Restricted sector -06"

/area/overmap/odyssey/spacebattle
	name =  "Restricted sector -07"

/area/overmap/odyssey/wildwest
	name =  "Restricted sector -08"

/area/overmap/odyssey/research
	name =  "Restricted research sector -08"

/obj/structure/overmap/planet
	var/obj/structure/overmap/ship/narration_target = null //Who are we going to send our flufftext to?
	var/captains_log = null //What file should we play? It'll go "captains' log stardate BLANK
	var/flufftext = "We need assistance!" //call for help

/obj/structure/overmap/planet/proc/play_narration() //This will play when the ship enters the system, it will inform players of what they need to do
	if(!narration_target)
		return
	for(var/mob/M in narration_target.linked_ship)
		SEND_SOUND(M,'StarTrek13/sound/trek/hail_open.ogg')
		SEND_SOUND(M, captains_log)
		to_chat(M, flufftext)

/obj/structure/overmap/ship/proc/quantum_slipstream()
	var/obj/effect/landmark/warp_beacon/rebel/snowdin/S = locate(/obj/effect/landmark/warp_beacon/rebel/snowdin) in GLOB.landmarks_list
	if(S)
		do_warp(S, S.distance,TRUE)
	else
		var/obj/effect/landmark/warp_beacon/ss = pick(warp_beacons)
		do_warp(ss, ss.distance,TRUE)
	if(pilot)
		to_chat(pilot, "<span_class='warning'><b>Quantum slipstream drive activated.</b></span>")
	if(weapons)
		playsound(weapons.loc,'StarTrek13/sound/borg/machines/alert2.ogg',100,0)
		weapons.say("WARNING: Quantum slipstream device has been activated. All hands brace for acceleration.")
		weapons.redalert()

/obj/effect/landmark/warp_beacon/rebel/snowdin //Special warp markers for rebel bases, the imperials must cut their way thru each base to unlock the next
	name = "Warp beacon"
	distance = 600 //1 min
	warp_restricted = TRUE

/obj/structure/rebel_capture/snowdin/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/moonoutpost/S = locate(/obj/effect/landmark/warp_beacon/rebel/moonoutpost) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/moonoutpost //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/moonoutpost/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/underground/S = locate(/obj/effect/landmark/warp_beacon/rebel/underground) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/underground //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/underground/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/caves/S = locate(/obj/effect/landmark/warp_beacon/rebel/caves) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/caves //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/caves/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/beach/S = locate(/obj/effect/landmark/warp_beacon/rebel/beach) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/beach //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/beach/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/academy/S = locate(/obj/effect/landmark/warp_beacon/rebel/academy) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/academy //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/academy/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/spacebattle/S = locate(/obj/effect/landmark/warp_beacon/rebel/spacebattle) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/spacebattle //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/spacebattle/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/wildwest/S = locate(/obj/effect/landmark/warp_beacon/rebel/wildwest) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/wildwest //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/wildwest/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/research/S = locate(/obj/effect/landmark/warp_beacon/rebel/research) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/research //Specialised
	name = "Warp beacon"
	distance = 2000
	warp_restricted = TRUE

/obj/structure/rebel_capture/research/pass_coordinates()
	SSticker.mode.result = 1
	SSticker.mode.check_win()
	SSticker.mode.check_finished(TRUE)
	SSticker.force_ending = 1
	to_chat(world, "<span_class='ratvar'You have reached the end of part 1 of the odyssey./span>")
//	var/obj/effect/landmark/warp_beacon/rebel/final/S = locate(/obj/effect/landmark/warp_beacon/rebel/final) in GLOB.landmarks_list
//	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/final //Specialised
	name = "Warp beacon"
	distance = 5000
	warp_restricted = TRUE

/obj/structure/overmap/planet/snowdin
	name = "Class D Planetoid"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "6"
	spawn_name = "snowdin_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/moonoutpost
	name = "Class D Moon"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "10"
	spawn_name = "moonoutpost_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/underground
	name = "Class D Moon"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "10"
	spawn_name = "underground_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/caves
	name = "Class K Planet"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "2"
	spawn_name = "caves_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/beach
	name = "Class M Planet"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "1"
	spawn_name = "beach_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/academy
	name = "Unidentified Starbase"
	icon = 'StarTrek13/icons/trek/large_overmap.dmi'
	icon_state = "station"
	spawn_name = "academy_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/spacebattle
	name = "Asteroid belt"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "keekenox"
	spawn_name = "spacebattle_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/wildwest
	name = "Asteroid belt"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "keekenox"
	spawn_name = "wildwest_spawn"
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/research
	name = "Asteroid belt"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "keekenox"
	spawn_name = "research_spawn_ruin"
	max_health = 1000000000
	health = 1000000000