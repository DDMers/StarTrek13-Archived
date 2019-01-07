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
	delaywarp = 500 //Not very long to prepare, we want to catch them off-guard

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
	name =  "Restricted research sector -09"

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

/obj/structure/overmap/ship/proc/quantum_slipstream(var/admin_override = FALSE)
	var/obj/effect/landmark/warp_beacon/rebel/snowdin/S = locate(/obj/effect/landmark/warp_beacon/rebel/snowdin) in GLOB.landmarks_list
	if(admin_override)
		forceMove(get_turf(S))
		S.on_reach(src)
		return
	weapons.redalert()
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

/obj/effect/landmark/warp_beacon/rebel/snowdin //Special warp markers for rebel bases, the imperials must cut their way thru each base to unlock the next
	name = "Warp beacon"
	distance = 600 //1 min
	warp_restricted = TRUE
	scripted_text ={"
	DELAY 40
	NAME Arctic Research Outpost
	SAY <span_class='warning'>MAYDAY, MAYDAY outpost overr####"93$$%%% THEY'RE EVERYW''###555^^^^^^ TO ANY SHIPS IN THE SECT---O66^^%%%</span>
	PLAYSOUND fuck
	DELAY 20
	NAME Unknown
	SAY <I>FUCK FUCK THEY'RE ALL OVER THE PLACE</I>
	SAY Liberate ]###@@%%%--''me
	DELAY 30
	NAME Main Computer
	SAY <span_class='warning'>Distress call terminated.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/snowdin/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/antag/ling_aler.ogg')
		sleep(10)
		SEND_SOUND(M, 'sound/effects/glassbr1.ogg')
		sleep(5)
		SEND_SOUND(M, 'sound/effects/glassbr1.ogg')
		sleep(10)
		SEND_SOUND(M, 'sound/weapons/laser.ogg')
		sleep(5)
		SEND_SOUND(M, 'sound/weapons/laser.ogg')

/obj/effect/mob_spawn/human/alive/changeling
	name = "frozen sleeper"
	desc = "This stasis pod is frozen over, but contains some-thin..someone? Inside..."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	death = FALSE
	flavour_text = "<span class='big bold'>You are a survivor.</span><b> A massacre on artic outpost 13 killed most of the crew but your victim who was locked in a dorm room. You have assumed a new form \
	survived, but now you hunger for more genomes. Find a new ship to infiltrate at all costs..sensors show one's just arrived in the system you're in.</b>"
	outfit = /datum/outfit/job/crewman

/obj/effect/mob_spawn/human/alive/changeling/special(mob/living/new_spawn)
	if(new_spawn.mind)
		new_spawn.mind.make_Changling()


/obj/structure/rebel_capture/snowdin/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/moonoutpost/S = locate(/obj/effect/landmark/warp_beacon/rebel/moonoutpost) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/moonoutpost //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	DELAY 10
	PLAYSOUND fuck
	NAME Moon Outpost 19
	SAY <span_class='warning'>Attempting to connect to NTnet...</span>
	DELAY 20
	SAY <I>Failed</I>
	SAY Attempt 5e-17 failed. Re-establishing connection
	DELAY 30
	SAY <I>Failed.</I>
	DELAY 10
	SAY Main communication array: offline. Status: CODE DELTA | Threat level: NULL.
	NAME Main Computer
	SAY <span_class='warning'>Distress call terminated.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/moonoutpost/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/ambicave.ogg')

/obj/structure/rebel_capture/moonoutpost/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/underground/S = locate(/obj/effect/landmark/warp_beacon/rebel/underground) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/underground //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	PLAYSOUND fuck
	NAME Underground outpost 45
	SAY <span_class='warning'>Julliet Mayo Endemic System Alpha 4 4 B-4</span>
	DELAY 20
	SAY <I>'###~%%4444%^--</I>
	SAY Relay fail failed incomplete juliet four romeo
	DELAY 30
	SAY <I>Failed.</I>
	DELAY 10
	SAY Attempting to assimilate information romeo alpha four four delta party parties ballon happy
	NAME Main Computer
	SAY <span_class='warning'>Distress call terminated.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/underground/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/antag/malf.ogg')

/obj/structure/rebel_capture/underground/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/caves/S = locate(/obj/effect/landmark/warp_beacon/rebel/caves) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/caves //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	PLAYSOUND fuck
	NAME Unsigned 64-Bit transmission code
	SAY <span_class='warning'>S--s-s-sss V'or T'ahk Kan. Te'ndil egh kan.</span>
	DELAY 10
	SAY <span_class='warning'>Transmission ended.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/caves/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/ambidanger2.ogg')


/obj/structure/rebel_capture/caves/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/beach/S = locate(/obj/effect/landmark/warp_beacon/rebel/beach) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/beach //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	PLAYSOUND fuck
	NAME CB Radio signal
	SAY <span_class='warning'>Welcome to '~~~###! The home of pleasure, '@@"%55 and RRR_----. Why not set down for some fun, sun fun sun fun, sun, fun, sun...sun</span>
	DELAY 10
	SAY <span_class='warning'>Transmission ended.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/beach/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/ambiruin.ogg')

/obj/structure/rebel_capture/beach/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/academy/S = locate(/obj/effect/landmark/warp_beacon/rebel/academy) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/academy //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	PLAYSOUND fuck
	NAME Unknown origin
	SAY <span_class='warning'>You have violated the sacred territory of geldor the strange, leave this space immediately and do not violate our space further by landing on our prestigious academy.</span>
	DELAY 10
	SAY <span_class='warning'>Transmission ended.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/academy/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/ambimystery.ogg')

/obj/structure/rebel_capture/academy/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/spacebattle/S = locate(/obj/effect/landmark/warp_beacon/rebel/spacebattle) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/spacebattle //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	PLAYSOUND fuck
	NAME NT Cruiser 'Gallahad'
	SAY <span_class='warning'>Mayday! Mayday this is the NTS Gallahad requiring IMMEDIATE assistance, we are under attack by multip---'x;'~~%%% We were en route to moon outpost 19--%%£$E££333</span>
	DELAY 10
	SAY IF YOU CAN HEAR US PLEASE HELP FOR THE LOVE OF GOD
	SAY <span_class='warning'>Transmission ended.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/spacebattle/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/ambitech3.ogg')

/obj/structure/rebel_capture/spacebattle/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/wildwest/S = locate(/obj/effect/landmark/warp_beacon/rebel/wildwest) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/wildwest //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	NAME Prospector George
	SAY <span_class='warning'>Howdy! Welcome to our humble abode, why not-wno---w-why not? stay a while? FOREVER @@'###^0--</span>
	DELAY 10
	SAY <span_class='warning'>Transmission ended.</span>
	DELAY 20"}

/obj/structure/rebel_capture/wildwest/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/research/S = locate(/obj/effect/landmark/warp_beacon/rebel/research) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/effect/landmark/warp_beacon/rebel/research //Specialised
	name = "Warp beacon"
	distance = 600
	warp_restricted = TRUE
	scripted_text ={"
	PLAYSOUND fuck
	NAME NT Research outpost 447 V
	SAY <span_class='warning'>Error. Error. Transmission failure error. Uncaught exception. Status: DELTA. Code: DELTA. Destruction state: IMMINENT</span>
	DELAY 10
	SAY <span_class='warning'>Transmission ended.</span>
	DELAY 20"}

/obj/effect/landmark/warp_beacon/rebel/research/play_sounds(var/obj/structure/overmap/what) //The PLAYSOUNDS tag runs this
	if(!what)
		what = locate(/obj/structure/overmap) in orange(src,1)
	for(var/mob/M in what.linked_ship)
		SEND_SOUND(M, null)
		SEND_SOUND(M, 'sound/ambience/ambireebe1.ogg')

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

/obj/structure/overmap/proc/beacons_test()
	for(var/obj/effect/landmark/warp_beacon/W in GLOB.landmarks_list)
		W.distance = 30
		W.warp_restricted = FALSE
	to_chat(world, "Beacons test active")
	SSfaction.jumpgates_forbidden = FALSE

/obj/effect/landmark/warp_beacon
	name = "Warp beacon"
	var/scripted_text = null //Play a message when a ship arrives in this system?

/obj/structure/overmap/proc/relay_message(var/what) //Send a ping to everyone inside a ship
	if(!linked_ship) //FUCK
		return
	for(var/mob/L in linked_ship)
		to_chat(L, what)

/obj/structure/overmap/proc/relay_sound(var/what) //Send a ping to everyone inside a ship
	if(!linked_ship) //FUCK
		return
	for(var/mob/L in linked_ship)
		SEND_SOUND(L, what)
/obj/structure/overmap/planet
	var/list/sleepers = list() //Where can people spawn?

/obj/structure/overmap/planet/proc/get_spawns()//Get turfs for our sleeper spawns so ghosts can fill the roles!
	for(var/obj/effect/mob_spawn/MS in linked_ship)
		sleepers += MS

/obj/effect/landmark/warp_beacon/proc/on_reach(var/obj/structure/overmap/what)
	if(scripted_text)
		var/list/lines = splittext(scripted_text,"\n")
		var/speaker = ""
		var/msg
		what.relay_sound('StarTrek13/sound/trek/hail_incoming.ogg')
		what.relay_message("<span_class='warning'>Incoming transmission: routing to main speakers...</span>")
		sleep(10)
		what.relay_sound('StarTrek13/sound/trek/hail_open.ogg')
		var/obj/structure/overmap/planet/FF = locate(/obj/structure/overmap/planet) in(get_area(src))
		if(FF)
			FF.get_spawns()
			if(FF.sleepers.len)
				for(var/obj/effect/mob_spawn/MS in FF.sleepers)
					for(var/mob/dead/observer/F in GLOB.dead_mob_list)
						var/turf/turfy = get_turf(MS)
						var/link = TURF_LINK(F, turfy)
						if(F)
							to_chat(F, "<font color='#EE82EE'><b>Antagonist spawn available (just click the sleeper): [link]</b></font>")
		for(var/line in lines) //Run through the script
			var/prepared_line = trim(line)
			if(!length(prepared_line))
				continue
			var/splitpoint = findtext(prepared_line," ")
			if(!splitpoint)
				continue
			var/command = copytext(prepared_line,1,splitpoint)
			var/value = copytext(prepared_line,splitpoint+1)
			switch(command)
				if("DELAY")
					var/delay_value = text2num(value)
					if(!delay_value)
						continue
					sleep(delay_value)
					continue
				if("NAME")
					speaker = value
					continue
				if("SAY")
					msg = value
				if("PLAYSOUND")
					play_sounds(what)
					continue
			msg = "<font color='red'>[speaker]:[msg]</font>"
			what.relay_message(msg)
			continue
	return //We can now make cutscenes, woo!

/obj/effect/landmark/warp_beacon/proc/play_sounds(var/obj/structure/overmap/what)
	return