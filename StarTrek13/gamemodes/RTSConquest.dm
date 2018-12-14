/*
Concept for our new mode! RTS
One player per faction becomes an admiral, though captains can use this console too in times of dire need.

This gives you an RTS like view (THINK: STELLARIS, red alert etc.) where you can:

Build stations:
Mining outposts generate metal and dilithium, both are needed to build starships
Refineries take shipments from mining outposts, converting their raw materials into usable materials

TO BUILD ANYTHING IN A SYSTEM: You must capture the system outpost. If you capture an enemy system outpost, their structures become yours

Defense turrets which can be set to attack anything that isnt your faction, or just retaliate.
Shipyards, which allow you to build new ships and repair pre-existing ones
Communications outposts, which clear fog of war in an area (darkness, theyre a bigass light source)

Command ships:
Player ships are still at the forefront under the admirality's guiding hand. Admirals can send orders to player controlled ships which CANNOT BE DISOBEYED UNLESS IT VIOLATES THE PRIME DIRECTIVE OR EQUIVALENT
The admirals can form fleets of weaker AI ships which will fly in formation with the lead ship (of their choosing). These ships will do the majority of the raiding against other AI stuff. They can also be left near a base to guard it.
The admirals get to fly the AI ships manually, or set waypoints for them to move to.

Conduct direct diplomacy, or delegate this to captains, this is entirely player controlled but we may add NPC factions

The admirals get an AI style view of the sector ideally with a CM "CIC" style map showing locations. They can also choose to directly fly ships with human crews though this is going to cost them. Admirals are like AIs here.

The admirals will live in "mother base" a large starbase which comes pre-fortified. If you lose this, it's game over.

The galaxy class will ALWAYS respawn for the players no matter what. When it dies it will cost a load of credits and metal to resurrect. Other ships must be rebuilt by the admiral at a shipyard
Then obviously the romulan D'deridex will ALWAYS respawn. Any crucial ship that is large enough to accomodate all the players will respawn.

There will be several ways to win / end the round:
1: Have over half the members of a given faction sign a truce with another faction. This will give a neutral ending which defaults to an economic win condition
2. Have the most credits, resources and structures in the game
3. Obliterate the competition's mother base to get a war ending
4. Borg assimilate the mother base of a faction, which is a 100% borg win


Dispatch ships for research missions to generate extra cash and dilithium

Ship types:
Constructor: Builds stuff. No weapons and very squishy
AI controlled: No physical interior, can be remote controlled by an admiral
Science: Deals with anomalies for research, can be manned by science crew(?)

CURRENT CONTROLS:
Middle mouse a turf to set a rally point
Ctrl click a ship to add it to your command group
Shift click to remove a ship from your command group
Alt click to hail a ship with a message


FOG OF WAR:
We're going to make the overmap DARK
All ships will have LIGHTS
All overmaps in general will have LIGHTS
When you place a station in a system, upon entering that system you get NIGHT VISION and can see everything. If you go around enemy systems, you'll just see what your ships are lighting up (you cant enter without at least one ship in there)

This way, to see past fog of war, you must build structures
You will NOT be able to jump to systems with ENEMY BASES IN THEM. You must send your ships in to clear them first

*/

//SHIT TO FUCKING ADD://
//STOP THROWING PEOPLE OFF THE CONSOLE OH GOD//
//A WAY TO FIND FUCKING SHIPS//
//TOGGLEABLE ZOOMMMMMMM ZOOOOOOOOOOOOOOOOOOOOOM//


//Let's begin!//

/datum/game_mode/conquest/send_intercept() //Overriding the "security level elevated thing" because we don't really use it :)
	priority_announce("Attention all crews: Due to increased pirate activity all claims on neutral zone systems are now void, factions may now claim these systems on a first come, first served basis. Any future violations after claiming are an act of war.")
	to_chat(world,"<span class='warning'>-The neutral zone is now unclaimed, it is to be claimed on a first come-first served basis. If you violate another faction's territory, be prepared to pay the price!</span>")
	return "By the order of the galactic empire, all available ships will mount an assault to break rebel supply lines. Capture each rebel base and move on to the next, failure will not be tolerated. Your captain has been given a set of documents of the utmost importance: see that these reach their destination safely."


//Federation space

/obj/structure/overmap/away/station/system_outpost/rts
	name = "A starbase"
	spawn_name = "earth_spawn"
	spawn_random = TRUE
	faction = "starfleet"

/obj/structure/overmap/away/station/system_outpost/rts/process()
	. = ..()
	structures = 0
	for(var/obj/structure/overmap/rts_structure/rts in get_area(src))
		structures ++

/obj/effect/landmark/ship_spawner
	name = "earth_spawn"

/area/overmap/rts
	name = "Sector 001 (Earth)"

/area/ship/earth
	name = "Spacedock"

/area/overmap/rts/fed
	name = "Denobula"

/area/ship/denobula
	name = "Starbase 229"

/obj/structure/overmap/away/station/system_outpost/rts/denobula
	spawn_name = "denobula_spawn"

/obj/effect/landmark/ship_spawner/denobula
	name = "denobula_spawn"

/area/overmap/rts/fed/trill
	name = "Trill"

/area/ship/trill
	name = "Starbase 235"

/obj/structure/overmap/away/station/system_outpost/rts/trill
	spawn_name = "trill_spawn"

/obj/effect/landmark/ship_spawner/trill
	name = "trill_spawn"

/area/overmap/rts/fed/betazed
	name = "Betazed"

/area/ship/betazed
	name = "Starbase 449"

/obj/structure/overmap/away/station/system_outpost/rts/betazed
	spawn_name = "betazed_spawn"

/obj/effect/landmark/ship_spawner/betazed
	name = "betazed_spawn"

/area/overmap/rts/fed/risa
	name = "Risa"

/area/ship/risa
	name = "Starbase 759"

/obj/structure/overmap/away/station/system_outpost/rts/risa
	spawn_name = "risa_spawn"

/obj/effect/landmark/ship_spawner/risa
	name = "risa_spawn"

//Neutral zone
/area/overmap/rts/neutral
	name = "Galorndon Core (neutral zone)"
	desc = "A system in the ever-contested neutral zone."

/area/ship/neutral
	name = "Star outpost 399"

/obj/structure/overmap/away/station/system_outpost/rts/galorndon
	spawn_name = "galorndon_spawn"

/obj/effect/landmark/ship_spawner/galorndon
	name = "galorndon_spawn"

/area/overmap/rts/neutral/jolanisar
	name = "Jolanisar (neutral zone)"

/area/ship/jolanisar
	name = "Star outpost 449"

/obj/structure/overmap/away/station/system_outpost/rts/jolanisar
	spawn_name = "jolanisar_spawn"

/obj/effect/landmark/ship_spawner/jolanisar
	name = "jolanisar_spawn"

/area/overmap/rts/neutral/alasayan
	name = "Al'Asayan (neutral zone)"

/area/ship/alasayan
	name = "Star outpost 250"

/obj/structure/overmap/away/station/system_outpost/rts/alasayan
	spawn_name = "alasayan_spawn"

/obj/effect/landmark/ship_spawner/alasayan
	name = "alasayan_spawn"

/area/overmap/rts/neutral/aurillac
	name = "Aurillac (neutral zone)"

/area/ship/aurillac
	name = "Star outpost 150"

/obj/structure/overmap/away/station/system_outpost/rts/aurillac
	spawn_name = "aurillac_spawn"

/obj/effect/landmark/ship_spawner/aurillac
	name = "aurillac_spawn"

//Romulan
/area/overmap/rts/romulan
	name = "Romulus"

/area/ship/romulus
	name = "Star fortress 'praetor'"

/obj/structure/overmap/away/station/system_outpost/rts/romulus
	spawn_name = "romulus_spawn"
	faction = "romulan empire"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	icon_state = "romstarbase"

/obj/effect/landmark/ship_spawner/romulus
	name = "romulus_spawn"

/area/overmap/rts/romulan/devron
	name = "Devron"

/area/ship/devron
	name = "Star outpost 'imperator'"

/obj/structure/overmap/away/station/system_outpost/rts/devron
	spawn_name = "devron_spawn"
	faction = "romulan empire"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	icon_state = "romstarbase"

/obj/effect/landmark/ship_spawner/devron
	name = "devron_spawn"

/area/overmap/rts/romulan/talon
	name = "Talon"

/area/ship/talon
	name = "Star outpost 'talon'"

/obj/structure/overmap/away/station/system_outpost/rts/talon
	spawn_name = "talon_spawn"
	faction = "romulan empire"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	icon_state = "romstarbase"

/obj/effect/landmark/ship_spawner/talon
	name = "talon_spawn"

/area/overmap/rts/romulan/pretorian
	name = "Pretorian"

/area/ship/pretorian
	name = "Star outpost 'victory'"

/obj/structure/overmap/away/station/system_outpost/rts/pretorian
	spawn_name = "pretorian_spawn"
	faction = "romulan empire"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	icon_state = "romstarbase"

/obj/effect/landmark/ship_spawner/pretorian
	name = "pretorian_spawn"

/area/overmap/rts/romulan/minos
	name = "Minos Tureth"

/area/ship/minos
	name = "Observation post 'eagle'"

/obj/structure/overmap/away/station/system_outpost/rts/minos
	spawn_name = "minos_spawn"
	faction = "romulan empire"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	icon_state = "romstarbase"

/obj/effect/landmark/ship_spawner/minos
	name = "minos_spawn"


//Borg
/area/overmap/rts/borg
	name = "Spatial component 543459"

/area/ship/borg_rts
	name = "Unimatrix 141" //We aren't ready for the borg...yet.

//The most important of all...the RTS eye//
/obj/machinery/computer/camera_advanced/rts_control
	name = "system analysis module"
	desc = "Allows direct interfacing with the computer systems of starships, granting its user direct control over many ships."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	dir = 4
	icon_keyboard = null
	icon_screen = null
	layer = 4.5
	anchored = TRUE
	can_be_unanchored = TRUE
	var/datum/action/innate/jump_area/area_action = new
	var/datum/action/innate/rally/rally_action = new
	var/datum/action/innate/jumptoship/jumptoship_action = new
	var/datum/action/innate/fleet_warp/warp_action = new
	var/obj/structure/overmap/theship
	var/mob/living/carbon/operator
	var/mob/camera/aiEye/remote/rts/RTSeye
	var/faction = "starfleet" //Which ships are we allowed to control? the operator does NOT change this! so you can sabotage enemy bases!
	var/list/saved_fleet = list() //save fleet when you re-use the cam
	var/zoom_out = 12
	var/datum/faction/our_faction

/obj/machinery/computer/camera_advanced/rts_control/Initialize()
	. = ..()
	START_PROCESSING(SSmachines,src)

/obj/machinery/computer/camera_advanced/rts_control/process()
	. = ..()
	if(RTSeye)
		if(RTSeye.tracking_target)
			RTSeye.forceMove(get_turf(RTSeye.tracking_target))

/obj/machinery/computer/camera_advanced/rts_control/romulan
	faction = "romulan empire"

/obj/machinery/computer/camera_advanced/rts_control/attack_hand(mob/user)
	if(!user.skills.skillcheck(user, "micromanagement", 10))
		return
	if(!theship)
		var/obj/structure/fluff/helm/desk/tactical/AA = locate(/obj/structure/fluff/helm/desk/tactical) in get_area(src)
		theship = AA.theship
	if(!powered())
		to_chat(user, "Insufficient power!")
		return
	if(operator)
		remove_eye_control(operator)
	operator = user
	if(!RTSeye)
		CreateEye()
	give_eye_control(user, get_turf(theship))//Make the RTS eye appear over the ship
	if(operator.client)
		operator.client.change_view(zoom_out) //ZOOOOM ZOOOM


/obj/machinery/computer/camera_advanced/rts_control/CreateEye()
	if(RTSeye)
		qdel(RTSeye)
	RTSeye = new()
	RTSeye.use_static = FALSE //FOG OF WAR, CHANGE TO TRUE WHEN YOURE READY TO ACTIVATE FOG OF WAR AND HAVE CAMERAS ENABLED!
	RTSeye.origin = src
	RTSeye.visible_icon = 1
	RTSeye.icon = 'icons/obj/abductor.dmi'
	RTSeye.icon_state = "camera_target"
	RTSeye.console = src
	for(var/obj/structure/overmap/away/station/system_outpost/rts/RTS in get_area(theship))
		if(RTS)
			RTSeye.station = RTS
			continue
	for(var/datum/faction/F in SSfaction.factions)
		if(F.name == faction)
			our_faction = F
	RTSeye.our_faction = our_faction
	if(saved_fleet.len)
		RTSeye.fleet = saved_fleet.Copy()
		to_chat(operator, "The previous user of this console had a command group set. That group has been transferred to you.")

/obj/machinery/computer/camera_advanced/rts_control/give_eye_control(mob/living/carbon/user, var/turf/TT)
	if(user == operator)
		GrantActions(user)
		current_user = user
		RTSeye.eye_user = user
		RTSeye.name = "RTS controller ([user.name])"
		user.remote_control = RTSeye
		user.reset_perspective(RTSeye)
		RTSeye.forceMove(TT)
		//user.sight = 60 //see through walls
	else
		to_chat(user, "This is already in use!")

/obj/machinery/computer/camera_advanced/rts_control/remove_eye_control(mob/living/user)
	if(!user)
		return
	for(var/V in actions)
		var/datum/action/A = V
		A.Remove(user)
	actions.Cut()
	if(user.client)
		user.reset_perspective(null)
		RTSeye.RemoveImages()
		user.client.change_view(CONFIG_GET(string/default_view))
		user.client.widescreen = FALSE //So they get widescreen mode back after we dick with their view
	if(RTSeye.fleet.len)
		saved_fleet = RTSeye.fleet.Copy()
		to_chat(operator, "Command group saved")
	RTSeye.eye_user = null
	user.remote_control = null
	current_user = null
	user.unset_machine()
	playsound(src, 'sound/machines/terminal_off.ogg', 25, 0)

/obj/machinery/computer/camera_advanced/rts_control/GrantActions(mob/living/carbon/user)
	if(user != operator)
		to_chat(user, "This is already in use!")
	if(off_action)
		off_action.target = user
		off_action.Grant(user)
		actions += off_action
	if(rally_action)
		rally_action.RTSeye = RTSeye
		rally_action.target = user
		rally_action.Grant(user)
		actions += rally_action
	if(jumptoship_action)
		jumptoship_action.RTSeye = RTSeye
		jumptoship_action.target = user
		jumptoship_action.Grant(user)
		actions += jumptoship_action
	if(warp_action)
		warp_action.RTSeye = RTSeye
		warp_action.target = user
		warp_action.Grant(user)
		actions += warp_action

/obj/machinery/computer/camera_advanced/rts_control/proc/RemoveActions(mob/living/carbon/user)
	if(off_action)
		off_action.Remove(user)
		off_action.target = null
	if(rally_action)
		rally_action.Remove(user)
		rally_action.RTSeye = null
		rally_action.target = null
	if(jumptoship_action)
		jumptoship_action.Remove(user)
		jumptoship_action.RTSeye = null
		jumptoship_action.target = null
	if(warp_action)
		warp_action.Remove(user)
		warp_action.RTSeye = null
		warp_action.target = null

//ACTIONS!//

/datum/action/innate/rally
	name = "Set rally point"
	icon_icon = 'StarTrek13/icons/actions/rts_actions.dmi'
	button_icon_state = "rallybutton"
	var/mob/camera/aiEye/remote/rts/RTSeye //Set this!

/datum/action/innate/rally/Activate()
	RTSeye.rally(RTSeye.loc) //Rally the selected fleet to this location

/datum/action/innate/fleet_warp
	name = "Fleet warp"
	icon_icon = 'StarTrek13/icons/actions/rts_actions.dmi'
	button_icon_state = "warp"
	var/mob/camera/aiEye/remote/rts/RTSeye //Set this!

/datum/action/innate/fleet_warp/Activate()
	RTSeye.fleet_warp() //Rally the selected fleet to this location

/datum/action/innate/jumptoship
	name = "Jump to ship"
	icon_icon = 'StarTrek13/icons/actions/rts_actions.dmi'
	button_icon_state = "jumptoship"
	var/mob/camera/aiEye/remote/rts/RTSeye //Set this!

/datum/action/innate/jumptoship/Activate()
	RTSeye.jump() //Rally the selected fleet to this location

//END ACTIONS!//

//EFFECTS!//
/obj/effect/temp_visual/trek/rallypoint
	icon = 'StarTrek13/icons/actions/rts_actions.dmi'
	icon_state = "rallying"
	duration = 30

//END EFFECTS//

//Juicy bits//

/obj/structure/overmap
	var/faction = "neutral" //Are we a faction's ship? if so, when we blow up, DEDUCT EXPENSES

/mob/living/carbon/canMobMousedown(atom/object, location, params)
	if(istype(src.loc, /obj/structure/overmap))
		var/obj/structure/overmap/o = loc
		. = o
	if(remote_control)
		if(istype(remote_control, /mob/camera/aiEye/remote/rts))
			var/mob/camera/aiEye/remote/rts/camgirl = remote_control
			camgirl.onMouseDown(object,location,params)
	. = ..()

/mob/camera/aiEye/remote/rts
	name = "RTS camera eye"
	var/list/fleet = list()
	var/obj/machinery/computer/camera_advanced/rts_control/console
	var/obj/structure/overmap/tracking_target
	var/list/to_clear = list() //list of rally point icons we need to clear up
	var/voice_cooldown = 10 //Small voice cooldown
	var/saved_time = 0
	var/datum/faction/our_faction
	var/obj/structure/overmap/away/station/system_outpost/rts/station //What's the station in this system, then?

/mob/camera/aiEye/remote/rts/proc/play_voice(sound)
	if(!sound)
		return
	if(!console)
		return
	if(!console.operator)
		return
	if(world.time >= saved_time + voice_cooldown)
		saved_time = world.time
		SEND_SOUND(console.operator, sound) //Prevents multiple things overlapping

/mob/camera/aiEye/remote/rts/relaymove(mob/user, direction)
	. = ..()
	if(tracking_target)
		tracking_target = null

/mob/camera/aiEye/remote/rts/proc/jump() //Jump to any overmap ship in this sector
	if(tracking_target)
		tracking_target = null
	var/A
	var/list/theships = list() //We need a special one for jumping to command groups
	for(var/obj/structure/overmap/O in overmap_objects)
		if(O.faction)
			if(O.faction == console.faction)
				theships += O
	if(!theships.len)
		return
	A = input(console.operator,"What ship shall we track?", "Ship navigation", A) as null|anything in theships//overmap_objects
	if(!A)
		return
	var/obj/structure/overmap/O = A
	forceMove(O.loc)
	tracking_target = O
	to_chat(console.operator, "Now following [O], use this button again to cancel tracking")
	station = null
	for(var/obj/structure/overmap/away/station/system_outpost/rts/TS in get_area(src))
		if(TS.faction == console.faction)
			station = TS

/mob/camera/aiEye/remote/rts/proc/rally(turf/T)
	if(!T)
		return
	for(var/obj/effect/temp_visual/trek/rallypoint/SS in to_clear)
		qdel(SS)
	var/obj/effect/temp_visual/trek/rallypoint/rs = new /obj/effect/temp_visual/trek/rallypoint(T)
	to_clear += rs //prevent multiple rally point icons spamming everything
	if(fleet.len)
		var/list/thelist = list('StarTrek13/sound/voice/rts/construction/movingout.ogg','StarTrek13/sound/voice/rts/combat/movingout.ogg')
		var/tsound = pick(thelist)
		play_voice(tsound)
	for(var/obj/structure/overmap/ship/AI/S in fleet)
		S.rally_point = T
		S.stored_target = null
		S.force_target = null
		S.agressive = FALSE

/mob/camera/aiEye/remote/rts/proc/fleet_warp()
	if(fleet.len >= 1)
		var/list/beacon = list()
		for(var/obj/effect/landmark/warp_beacon/wb in warp_beacons)
			if(wb.z && !wb.warp_restricted)
				beacon += wb.name
		beacon += "cancel"
		if(!beacon.len)
			to_chat(console.operator, "Unable to fleet warp: No available warp points.")
		var/A = input(console.operator,"Warp where?", "Fleet warp", null) as anything in beacon
		if(!A || A == "cancel")
			return
		var/obj/effect/landmark/warp_beacon/B
		for(var/obj/effect/landmark/warp_beacon/ww in warp_beacons)
			if(ww.name == A)
				B = ww
		if(B)
			to_chat(console.operator, "Confirmed commander, preparing to warp")
			for(var/obj/structure/overmap/ship/AI/S in fleet)
				S.do_warp(B, B.distance)
				S.stored_target = null
				S.force_target = null
				S.rally_point = null
		return

/mob/camera/aiEye/remote/rts/proc/fleet_attack(obj/structure/overmap/OM)
	if(!OM)
		return
	//if(OM.faction != console.faction) RE-ADD ME WHEN WE'RE DONE TESTING FOR THE LOVE OF ALL THAT IS HOLY JESUSUUUSUSUDUADJASKXMJNDKMASDKMAN
	for(var/obj/effect/temp_visual/trek/rallypoint/SS in to_clear)
		qdel(SS)
	if(OM)
		play_voice('StarTrek13/sound/voice/rts/combat/intercepting.ogg')
		to_chat(console.operator, "Command confirmed, moving in to attack!")
		var/obj/effect/temp_visual/trek/rallypoint/rs = new /obj/effect/temp_visual/trek/rallypoint(OM.loc)
		to_clear += rs //prevent multiple rally point icons spamming everything
		for(var/obj/structure/overmap/ship/AI/S in fleet)
			S.force_target = OM
			S.rally_point = null
			S.stored_target = null
			S.agressive = TRUE

/mob/camera/aiEye/remote/rts/proc/onMouseDown(object, location, params)
	var/bleeps = list('StarTrek13/sound/voice/rts/beeps/beep.ogg','StarTrek13/sound/voice/rts/beeps/beep2.ogg','StarTrek13/sound/voice/rts/beeps/beep3.ogg')
	var/thesound = pick(bleeps)
	SEND_SOUND(console.operator,thesound)
	var/list/modifiers = params2list(params)
	if(istype(object, /obj/structure/overmap/rts_structure/shipyard)) //https://www.youtube.com/watch?v=53t_GEJliEo
		if(console.faction == "starfleet")
			var/list/options = list("miranda", "constructor", "galaxy", "sovereign", "repair")
			for(var/option in options)
				options[option] = image(icon = 'StarTrek13/icons/actions/rts_actions.dmi', icon_state = "[option]")
			var/dowhat = show_radial_menu(console.operator,get_turf(object),options)
			if(!dowhat)
				return
			var/obj/structure/overmap/rts_structure/shipyard/sy = object
			sy.RTSeye = src
			if(dowhat == "repair")
				sy.repair()
				return
			if(!sy.building)
				sy.build(dowhat)
			return
		if(console.faction == "romulan empire")
			var/list/options = list("constructor-rom", "birdofprey", "dderidex", "repair")
			for(var/option in options)
				options[option] = image(icon = 'StarTrek13/icons/actions/rts_actions.dmi', icon_state = "[option]")
			var/dowhat = show_radial_menu(console.operator,get_turf(object),options)
			if(!dowhat)
				return
			var/obj/structure/overmap/rts_structure/shipyard/sy = object
			sy.RTSeye = src
			if(dowhat == "repair")
				sy.repair()
				return
			if(!sy.building)
				sy.build(dowhat)
			return
	if(modifiers["middle"])
		if(istype(object, /turf/open))
			rally(object)
		else
			if(istype(object, /obj/structure/overmap)) //For now, you can't attack your own stuff. We may need to change this!
				var/obj/structure/overmap/om = object
				if(om.faction == console.faction)
					play_voice('StarTrek13/sound/voice/rts/combat/notfiring.ogg')
					return
				fleet_attack(om)
		return
	if(modifiers["shift"])
		if(istype(object, /obj/structure/overmap/ship/AI))
			var/obj/structure/overmap/ship/AI/om = object
			if(om.faction == console.faction)
				if(om in fleet)
					fleet -= om
					console.saved_fleet -= om
					om.RTSeye = null
					to_chat(console.operator, "[om] has been removed your command group")
		else
			var/atom/theobj = object
			theobj.examine(console.operator)
		return
	if(modifiers["ctrl"])
		if(istype(object, /obj/structure/overmap/ship/AI))
			var/obj/structure/overmap/ship/AI/om = object
			if(om.faction == console.faction)
				fleet += om
				console.saved_fleet += om
				to_chat(console.operator, "[om] has been added to your command group")
				play_voice('StarTrek13/sound/voice/rts/construction/yescommander.ogg')
		return
	if(modifiers["alt"])
		if(istype(object, /obj/structure/overmap))
			var/obj/structure/overmap/om = object
			var/message = stripped_input(console.operator,"Gold-channel frequency.","Transmit message.")
			if(message)
				if(om)
					to_chat(console.operator, "<font size='2' color='#FFD700'><I>Gold-band transmission:</I> <b>You -> [om]</b>, [html_encode(message)]</span>")
					if(om.pilot)
						to_chat(om.pilot, "<font size='2' color='#FFD700'><I>Gold-band transmission:</I> <b>[console.operator] -> [om]</b>, [html_encode(message)]</span>")
					for(var/mob/living/M in om.linked_ship)
						to_chat(M, "<font size='2' color='#FFD700'><I>Gold-band transmission:</I> <b>[console.operator] -> [om]</b>, [html_encode(message)]</span>") //IM A FUCKING IDIOT
				for(var/mob/O in GLOB.dead_mob_list)
					to_chat(O, "<font size='2' color='#FFD700'><I>Gold-band transmission:</I> <b>[console.operator] -> [om]</b>, [html_encode(message)]</span>")
		return
	var/obj/structure/overmap/away/station/system_outpost/rts/S = locate(/obj/structure/overmap/away/station/system_outpost/rts) in get_area(src)
	if(!S || S.faction != console.faction)
		to_chat(console.operator, "<span_class='warning'>You must capture [S] by beaming an away team down onto it before you can build here!</span>")
		return FALSE
	var/list/options = list("build", "destroy", "upgrade") //Thanks for this  nich :)
	for(var/option in options)
		options[option] = image(icon = 'StarTrek13/icons/actions/rts_actions.dmi', icon_state = "[option]")
	var/dowhat = show_radial_menu(console.operator,get_turf(object),options)
	if(!dowhat)
		return
	switch(dowhat)
		if("build")
			if(isturf(object))
				var/turf/T = object
				build(T)
		if("destroy")
			if(istype(object, /obj/structure/overmap) && !istype(object, /obj/structure/overmap/away/station/system_outpost) && !istype(object, /obj/structure/overmap/away/station/system_outpost/rts))
				try_destroy(object)
		if("upgrade")
			if(istype(object, /obj/structure/overmap))
				upgrade(object)

/mob/camera/aiEye/remote/rts/proc/build(turf/open/T)
	var/list/builders = list()
	for(var/obj/structure/overmap/ship/AI/constructor/C in get_area(src))
		if(C.faction == console.faction)
			builders += C
	if(!builders.len)
		to_chat(console.operator, "Could not locate any builder ships in this sector!")
		return
	var/list/options = list("shipyard", "mining","refinery","turret","comms")
	for(var/option in options)
		options[option] = image(icon = 'StarTrek13/icons/actions/rts_actions.dmi', icon_state = "[option]")
	var/dowhat = show_radial_menu(console.operator,T,options)
	if(!dowhat)
		return
	if(!station)
		to_chat(console.operator, "Capture the station in this system first.")
		return
	if(station.structures >= station.structure_limit)
		to_chat(console.operator, "There are too many structures in this system, we should expand our operations to a new system")
		return
	for(var/obj/structure/overmap/ship/AI/constructor/CS in builders)
		if(!CS.build_target && !CS.building)
			var/whattomake = null
			var/cost_metal = 0 //How much does it cost to make what we want?
			var/cost_dilithium = 0
			switch(dowhat)
				if("shipyard")
					if(console.faction == "starfleet")
						whattomake = /obj/structure/overmap/rts_structure/shipyard
						cost_metal = 0
						cost_dilithium = 0 //add me later!
					if(console.faction == "romulan empire")
						whattomake = /obj/structure/overmap/rts_structure/shipyard/romulan
						cost_metal = 0
						cost_dilithium = 0 //add me later!
				if("mining")
					if(console.faction == "starfleet")
						whattomake = /obj/structure/overmap/rts_structure/mining
						cost_metal = 0
						cost_dilithium = 0 //add me later!
					if(console.faction == "romulan empire")
						whattomake = /obj/structure/overmap/rts_structure/mining/romulan
						cost_metal = 0
						cost_dilithium = 0 //add me later!
				if("refinery")
					if(console.faction == "starfleet")
						whattomake = /obj/structure/overmap/rts_structure/refinery
						cost_metal = 0
						cost_dilithium = 0 //add me later!
					if(console.faction == "romulan empire")
						whattomake = /obj/structure/overmap/rts_structure/refinery/romulan
						cost_metal = 0
						cost_dilithium = 0 //add me later!
				if("turret")
					if(console.faction == "starfleet")
						play_voice('StarTrek13/sound/voice/rts/construction/constructioncomplete.ogg')
						new /obj/structure/overmap/ship/AI/turret(T)
						return
					if(console.faction == "romulan empire")
						play_voice('StarTrek13/sound/voice/rts/construction/constructioncomplete.ogg')
						new /obj/structure/overmap/ship/AI/turret/romulan(T)
						return
				if("comms")
					if(console.faction == "starfleet")
						whattomake = /obj/structure/overmap/rts_structure/comms
						cost_metal = 0
						cost_dilithium = 0 //add me later!
					if(console.faction == "romulan empire")
						whattomake = /obj/structure/overmap/rts_structure/comms/romulan
						cost_metal = 0
						cost_dilithium = 0 //add me later!
			if(whattomake)
				if(CS.metal < cost_metal)
				//	to_chat(console.operator, "Insufficient metal!")
					continue //OK, well maybe one of our constructors has enough?
				if(CS.dilithium < cost_dilithium)
			//		to_chat(console.operator, "Insufficient dilithium!")
					continue
				CS.rally_point = T
				CS.build_target = whattomake
				CS.RTSeye = src
				to_chat(console.operator, "Construction ship moving out")
				play_voice('StarTrek13/sound/voice/rts/construction/movingout.ogg')
				return

/mob/camera/aiEye/remote/rts/proc/try_destroy(var/obj/structure/overmap/what)
	if(!what.faction)
		return FALSE
	if(what.faction != console.faction)
		to_chat(console.operator, "You don't own this")
		return FALSE
	var/A = input(console.operator, "Are you sure you want to DESTROY [what]?", "Scuttle ship") in list("yes","no")
	if(A == "yes")
		to_chat(console.operator, "Ship scuttled.") //https://www.youtube.com/watch?v=hVPjGkVOaJ8
		qdel(what) //Thank you for your service
		return TRUE
	return FALSE

/mob/camera/aiEye/remote/rts/proc/upgrade()
	return

//RTS specific structures!//

/obj/structure/overmap/ship/AI/constructor //These badboys allow you to construct things, you can use them in combat but it's highly inadvisable as they're super expensive and important!
	name = "Knox class construction frigate"
	desc = "An industrial tug ship fitted with advanced replication technology, these ships allow you to build all kinds of structures but are ineffective in combat!"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "constructor"
	max_health = 8500 //Quite tough, but still squishy
	max_speed = 6
	acceleration = 0.5 //slow
	faction = "starfleet"
	spawn_random = FALSE
	damage = 200 //It can sort of fight back, but not very well
	agressive = FALSE //Do we attack on sight? admirals can change this!
	var/obj/structure/overmap/build_target = null //As a type, what do we want to build when we reach our rally point?
	var/build_time = 50 //5 seconds build time, this can be reduced with upgrades, set this higher when done testing!
	var/metal = 1000 //give them a starting amount so they can build the basics.
	var/dilithium = 50
	var/building = FALSE
	pixel_z = -48
	pixel_w = -48

/obj/structure/overmap/ship/AI/constructor/romulan //https://www.youtube.com/watch?v=53t_GEJliEo
	name = "Tal'dar class construction vessel"
	icon_state = "romulan-constructor"
	faction = "romulan empire"

/obj/structure/overmap/ship/AI/constructor/on_reach_rally()
	var/obj/structure/overmap/away/station/system_outpost/rts/S = locate(/obj/structure/overmap/away/station/system_outpost/rts) in(get_area(src))
	if(S.structures >= S.structure_limit)
		rally_point = null
		building = FALSE
		build_target = null
		return //No more room
	if(build_target && !building)
		building = TRUE
		new /obj/effect/temp_visual/swarmer/disintegration(rally_point)
		addtimer(CALLBACK(src, .proc/build), build_time)
		if(RTSeye)
			RTSeye.play_voice('StarTrek13/sound/voice/rts/construction/constructioninprogress.ogg')

/obj/structure/overmap/ship/AI/constructor/proc/build()
	var/obj/structure/overmap/away/station/system_outpost/rts/S = locate(/obj/structure/overmap/away/station/system_outpost/rts) in(get_area(src))
	if(S.structures >= S.structure_limit)
		return //No more room
	if(build_target)
		var/obj/structure/overmap/built = new build_target(rally_point)
		if(RTSeye)
			if(RTSeye.console && RTSeye.console.operator)
				to_chat(RTSeye.console.operator, "Construction of [built] complete!")
				RTSeye.play_voice('StarTrek13/sound/voice/rts/construction/constructioncomplete.ogg')
		RTSeye = null
		rally_point = null
		build_target = null
		building = FALSE
		force_target = null
		stored_target = null

/obj/structure/overmap/rts_structure
	name = "generic thing"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	icon_state = "generic"
	desc = "Add me!"
	faction = "starfleet"
	respawn = FALSE
	pixel_z = -78
	pixel_w = -78
	inherit_name_from_area = FALSE
	spawn_random = FALSE

/obj/structure/overmap/rts_structure/linkto()
	for(var/area/AR in world)
		if(istype(AR, /area/ship/ai))
			linked_ship = AR
			return

/obj/structure/overmap/rts_structure/shipyard
	name = "Class IV shipyard"
	desc = "This massive structure is the birthplace of ships, simply click it while in RTS mode to access its properties."
	icon_state = "shipyard"
	var/mob/camera/aiEye/remote/rts/RTSeye
	var/build_time = 300 //How long will it take to build this unit? defaults to 30 seconds
	var/metal_cost = 0
	var/dilithium_cost = 0 //How much is that bill for?!
	var/repair_range = 3 //3 tiles around the shipyard for repairs? not a bad deal
	var/building = FALSE

/obj/structure/overmap/rts_structure/shipyard/proc/build(what)
	var/datum/faction/thefaction
	for(var/datum/faction/F in SSfaction.factions)
		if(F.name == faction)
			thefaction = F
	if(!thefaction)
		return
	if(thefaction.ships >= thefaction.max_ships)
		to_chat(RTSeye.console.operator, "Maximum buildable shipcount has already been reached!")
		return FALSE
	var/obj/structure/overmap/ship/tobuild
	var/found = FALSE //Found a refinery to steal ore from?
	switch(what)
		if("miranda")
			tobuild = /obj/structure/overmap/ship/AI/federation
			metal_cost = 5000 //Quite cheap
			dilithium_cost = 2
		if("constructor")
			tobuild = /obj/structure/overmap/ship/AI/constructor
			metal_cost = 10000 //Pricy
			dilithium_cost = 5

		if("galaxy")
			tobuild = /obj/structure/overmap/ship/AI/federation/galaxy
			metal_cost = 30000 //Oof ow my bones
			dilithium_cost = 20

		if("sovereign")
			tobuild = /obj/structure/overmap/ship/AI/federation/sovereign
			metal_cost = 50000 //the ferrari of spaceships
			dilithium_cost = 50

		if("constructor-rom")
			tobuild = /obj/structure/overmap/ship/AI/constructor/romulan
			metal_cost = 5000
			dilithium_cost = 2

		if("birdofprey")
			tobuild = /obj/structure/overmap/ship/AI/romulan/cruiser
			metal_cost = 6000 //Quite cheap, it's also better than the miranda.
			dilithium_cost = 5

		if("dderidex")
			tobuild = /obj/structure/overmap/ship/AI/romulan
			metal_cost = 45000 //The staple of the romulan empire's navy
			dilithium_cost = 20

	for(var/obj/structure/overmap/rts_structure/refinery/rs in overmap_objects)
		if(rs.faction == RTSeye.console.faction && !found)
			if(rs.metal >= metal_cost && rs.dilithium >= dilithium_cost)
				rs.metal -= metal_cost
				rs.dilithium -= dilithium_cost
				found = TRUE
	if(!found)
		to_chat(RTSeye.console.operator, "Insufficient resources! Ensure that you have refineries stocked up and built.")
		return
	building = TRUE
	RTSeye.play_voice('StarTrek13/sound/voice/rts/construction/constructioninprogress.ogg')
	addtimer(CALLBACK(src, .proc/build_finish, tobuild), build_time)

/obj/structure/overmap/rts_structure/shipyard/proc/build_finish(var/obj/structure/overmap/ship/what)
	building = FALSE
	if(!what)
		return
	RTSeye.play_voice('StarTrek13/sound/voice/rts/construction/constructioncomplete.ogg')
	var/obj/structure/overmap/ship/newthing = new what(get_turf(src))
	if(RTSeye.console)
		if(RTSeye.console.operator)
			to_chat(RTSeye.console.operator, "Construction of [newthing] complete")
	var/datum/faction/thefaction
	for(var/datum/faction/F in SSfaction.factions)
		if(F.name == faction)
			thefaction = F
	thefaction.ships ++
	RTSeye = null

/obj/structure/overmap/rts_structure/shipyard/proc/repair()
	to_chat(RTSeye.console.operator, "Repairs in progress, please ensure ships in need of repair remain inside the highlighted radius, or they will not be repaired.")
	var/longasstime = build_time*2
	addtimer(CALLBACK(src, .proc/repair_finish), longasstime)
	for(var/turf/T in orange(src, repair_range))
		var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(T)
		H.duration = 50
		H.color = "#FF4500" //orangered

/obj/structure/overmap/rts_structure/shipyard/proc/repair_finish()
	RTSeye.play_voice('StarTrek13/sound/voice/rts/construction/repairscomplete.ogg')
	for(var/obj/structure/overmap/OM in orange(src, repair_range))
		if(OM.faction == RTSeye.console.faction)
			var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(OM))
			H.color = "#00FFFF" //Cyan
			for(var/datum/shipsystem/SS in OM.SC.systems)
				SS.integrity = SS.max_integrity
				SS.failed = FALSE
			OM.health = OM.max_health

/obj/structure/overmap/rts_structure/shipyard/romulan
	name = "Class IV shipyard"
	desc = "This massive structure is the birthplace of ships, simply click it while in RTS mode to access its properties."
	icon_state = "shipyard"
	faction = "romulan empire"

/obj/structure/overmap/rts_structure/comms
	name = "Subspace relay station"
	desc = "This station relays thousands of subspace transmissions a second allowing for a sensor net to be formed. It will alert its owner when ships enter the system as well as giving full sight to the owner over a system."
	icon_state = "comms"

/obj/structure/overmap/rts_structure/comms/romulan
	name = "Subspace relay station"
	desc = "This station relays thousands of subspace transmissions a second allowing for a sensor net to be formed. It will alert its owner when ships enter the system as well as giving full sight to the owner over a system."
	icon_state = "romcomms"
	faction = "romulan empire"

/obj/structure/overmap/rts_structure/mining //This passively generates dilithium and metal, then sends little ships to ferry it over to refineries to get processed.
	name = "Yangtzee-Kiang class mining outpost"
	desc = "An extra large station orbiting a nearby asteroid, it mines minerals and ships them to refineries."
	icon_state = "mining"
	var/metal = 0 //How much metal have we mined?
	var/dilithium = 0 //how much dilithium have we mined?
	var/max_metal = 5000 //Maximum amount of minerals we can store
	var/max_dilithium = 5000

/obj/structure/overmap/rts_structure/mining/romulan
	name = "Reman mining colony"
	icon_state = "rommining"
	faction = "romulan empire"

/obj/structure/overmap/rts_structure/mining/process()
	. = ..() //Soulless minions of orthodoxy..
	if(prob(50))
		if(metal < max_metal)
			metal += 50
	if(prob(5))
		if(dilithium < max_dilithium)
			dilithium += 0.5
	if(metal >= 2000)
		prepare_transport()
	if(dilithium >= 10)
		prepare_transport_dilithium()

/obj/structure/overmap/rts_structure/mining/proc/prepare_transport()
	if(metal < 2000)
		return
	var/obj/structure/overmap/rts_structure/refinery/RF = locate(/obj/structure/overmap/rts_structure/refinery) in get_area(src)
	if(!RF) //No need to spawn a tug with no refinery alive.
		return
	metal -= 2000 //take some metal and let's head off
	var/obj/structure/overmap/ship/AI/tug/transport
	transport = new /obj/structure/overmap/ship/AI/tug(get_turf(src))
	if(transport)
		transport.faction = faction

/obj/structure/overmap/rts_structure/mining/proc/prepare_transport_dilithium()
	var/obj/structure/overmap/rts_structure/refinery/RF = locate(/obj/structure/overmap/rts_structure/refinery) in get_area(src)
	if(!RF) //No need to spawn a tug with no refinery alive.
		return
	if(dilithium >= 10)
		dilithium -= 10
		var/obj/structure/overmap/ship/AI/tug/dilithium/morecrystalisrequired = null
		morecrystalisrequired = new /obj/structure/overmap/ship/AI/tug/dilithium(get_turf(src))
		if(morecrystalisrequired)
			morecrystalisrequired.faction = faction

/obj/structure/overmap/rts_structure/mining/romulan/prepare_transport()
	if(metal < 2000)
		return
	var/obj/structure/overmap/rts_structure/refinery/RF = locate(/obj/structure/overmap/rts_structure/refinery) in get_area(src)
	if(!RF) //No need to spawn a tug with no refinery alive.
		return
	metal -= 2000 //take some metal and let's head off
	var/obj/structure/overmap/ship/AI/tug/romulan/transport
	transport = new /obj/structure/overmap/ship/AI/tug/romulan(get_turf(src))
	if(transport)
		transport.faction = faction

/obj/structure/overmap/rts_structure/mining/romulan/prepare_transport_dilithium()
	var/obj/structure/overmap/rts_structure/refinery/RF = locate(/obj/structure/overmap/rts_structure/refinery) in get_area(src)
	if(!RF) //No need to spawn a tug with no refinery alive.
		return
	if(dilithium >= 10)
		dilithium -= 10
		var/obj/structure/overmap/ship/AI/tug/dilithium/romulan/morecrystalisrequired = null
		morecrystalisrequired = new /obj/structure/overmap/ship/AI/tug/dilithium/romulan(get_turf(src))
		if(morecrystalisrequired)
			morecrystalisrequired.faction = faction

/obj/structure/overmap/rts_structure/refinery
	name = "Amazon class ore refinery"
	desc = "A small station with a massive array of silos attached, designed for storing and refining ore. It requires a mining station to operate."
	icon_state = "refinery"
	var/metal = 0 //How much metal have we mined?
	var/dilithium = 0 //how much dilithium have we mined?

/obj/structure/overmap/rts_structure/refinery/romulan
	name = "Industrious class ore refinery"
	desc = "A small station with a massive array of silos attached, designed for storing and refining ore. It requires a mining station to operate."
	icon_state = "romfinery"
	faction = "romulan empire"

/obj/structure/overmap/ship/AI/tug
	name = "Fortunate class ore freighter"
	desc = "A small ship designed to ferry ore from mining outposts to refineries. It has a class 1 mining laser installed, which is probably too low powered to penetrate even navigational shields"
	max_health = 2000 //Squishy as fuck.
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "freighter"
	faction = "starfleet"
	damage = 5
	acceleration = 1
	var/obj/structure/overmap/rts_structure/refinery/target_refinery
	var/metal = 2000 //How many mats are on this tug?
	var/dilithium = 0
	agressive = FALSE
	pixel_z = -48
	pixel_w = -48
	var/transferred = FALSE //have we dumped our mats yet?

/obj/structure/overmap/ship/AI/tug/dilithium
	name = "Dilithium hauler"
	dilithium = 5

/obj/structure/overmap/ship/AI/tug/dilithium/romulan
	name = "Dilithium hauler"
	faction = "romulan empire"


/obj/structure/overmap/ship/AI/tug/romulan
	name = "Ore freighter"
	faction = "romulan empire"

/obj/structure/overmap/ship/AI/tug/Initialize()
	. = ..()
	var/obj/structure/overmap/rts_structure/refinery/RF = locate(/obj/structure/overmap/rts_structure/refinery) in get_area(src)
	if(RF)
		rally_point = get_turf(RF)
		target_refinery = RF

/obj/structure/overmap/ship/AI/tug/on_reach_rally()
	if(!target_refinery)
		return
	if(!transferred)
		target_refinery.metal += metal
		target_refinery.dilithium += dilithium
		transferred = TRUE
	qdel(src) //Thank you for your service o7

/obj/structure/overmap/ship/AI
	var/cost_metal = 0 //Construction cost
	var/cost_dilithium = 0

/obj/structure/overmap/ship/AI/turret
	name = "Charon class defense platform"
	desc = "A self-contained turret solution that offers solid protection for bases"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	icon_state = "turret"
	max_health = 15000 //Designed to hold off decent sized swarms of roflstompers
	max_speed = 0
	acceleration = 0
	faction = "starfleet"
	spawn_random = FALSE
	damage = 500 //A solid deterrant, but not overly lethal. We can add a photon torpedo upgrade for it later
	agressive = TRUE //Turret KILLLLL
	pixel_z = -78
	pixel_w = -78

/obj/structure/overmap/ship/AI/turret/romulan
	name = "'Early strike' class defense platform"
	desc = "A self-contained turret solution that offers solid protection for bases"
	icon = 'StarTrek13/icons/trek/overmap_rts.dmi'
	faction = "romulan empire"
	icon_state = "romturret"

//Ships!

/obj/structure/overmap/ship/AI/federation
	name = "Miranda class patrol cruiser"
	desc = "A lightweight cruiser which specializes in border control, whilst it's not the strongest it can rapidly respond to threats with its solid engines"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "destroyer"
	max_health = 9500 //Player controlled miranda has 15000 HP
	max_speed = 8.5
	acceleration = 1.5
	faction = "starfleet"
	spawn_random = FALSE
	damage = 900 //This should be low, as it will ALWAYS hit for this much damage
	agressive = FALSE //Do we attack on sight? admirals can change this!
	pixel_z = -48
	pixel_w = -48

/obj/structure/overmap/ship/AI/federation/sovereign
	name = "Sovereign class heavy cruiser"
	desc = "A technologically unrivalled battlecruiser armed with a ridiculous amount of weaponry. Its sole purpose in the design phase was to combat the borg however it's fallen into more common use."
	icon = 'StarTrek13/icons/trek/large_ships/sovreign.dmi'
	icon_state = "sovreign"
	warp_capable = TRUE
	max_health = 50000
	pixel_z = -128
	pixel_w = -120
	max_speed = 6
	acceleration = 2 //These things are fucking rapid, too

/obj/structure/overmap/ship/AI/federation/galaxy
	name = "Galaxy class cruiser"
	desc = "A massive cruiser that allows for ultra-extended voyages as the crew ship with their family members."
	icon = 'StarTrek13/icons/trek/large_ships/galaxy.dmi'
	icon_state = "galaxy"
	warp_capable = TRUE
	max_health = 28000 //real galaxy has 35K HP
	pixel_z = -128
	pixel_w = -120
	max_speed = 7
	acceleration = 1.2 //Pretty damn fast

/obj/structure/overmap/ship/AI/romulan/cruiser
	name = "Romulan bird of prey class light cruiser"
	desc = "A light cruiser with an impressive armament, it is ideal for border skirmishes"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "birdofprey"
	max_health = 12000 //No player controlled analogue just yet :(
	max_speed = 5
	acceleration = 1.15
	faction = "romulan empire"
	spawn_random = FALSE
	damage = 920 //This should be low, as it will ALWAYS hit for this much damage
	agressive = FALSE //Do we attack on sight? admirals can change this!
	pixel_z = -48
	pixel_w = -48

/obj/structure/overmap/ship/AI/romulan
	name = "Dderidex class warbird"
	desc = "The pride of the romulan fleet, this ship dwarfs most of the starfleet lineup but will find its match against other capital class ships."
	icon = 'StarTrek13/icons/trek/large_ships/dderidex.dmi'
	icon_state = "dderidex"
	max_health = 25000 //Player controlled dderi has 30K
	max_speed = 5
	acceleration = 0.5
	faction = "romulan empire"
	spawn_random = FALSE
	damage = 1500 //This should be low, as it will ALWAYS hit for this much damage --This is a fucking warbird they hit HARD
	agressive = FALSE //Do we attack on sight? admirals can change this!
	pixel_z = -128
	pixel_w = -128