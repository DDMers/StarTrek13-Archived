/*
Concept for our new mode! RTS
One player per faction becomes an admiral, though captains can use this console too in times of dire need.

This gives you an RTS like view (THINK: STELLARIS, red alert etc.) where you can:

Build stations:
Stations allow you to build other structures in a 10 tile radius of the station, they cost a lot initially but are VITAL. You will get a maximum of about 5 stations per game.
Refineries generate metal, which is used for starships and can tip the balance of power
Mining outposts generate dilithium which is a pre requisite for construction starships

Repair bays, which heal ships at the cost of a LOT of metal
Defense turrets which can be set to attack anything that isnt your faction, or just retaliate.
Shipyards, which allow you to build new ships
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

This way, to see past fog of war, you must build structures
You will NOT be able to jump to systems with ENEMY BASES IN THEM. You must send your ships in to clear them first

*/

//Let's begin!//

//The most important of all...the RTS eye//
/obj/machinery/computer/camera_advanced/rts_control
	name = "transporter control station"
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
	var/obj/structure/overmap/theship
	var/mob/living/carbon/operator
	var/mob/camera/aiEye/remote/rts/RTSeye
	var/faction = "starfleet" //Which ships are we allowed to control? the operator does NOT change this! so you can sabotage enemy bases!

/obj/machinery/computer/camera_advanced/rts_control/romulan
	faction = "romulan empire"

/obj/machinery/computer/camera_advanced/rts_control/attack_hand(mob/user)
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

/obj/machinery/computer/camera_advanced/rts_control/give_eye_control(mob/living/carbon/user, var/turf/TT)
	if(user == operator)
		GrantActions(user)
		current_user = user
		RTSeye.eye_user = user
		RTSeye.name = "Camera Eye ([user.name])"
		user.remote_control = RTSeye
		user.reset_perspective(RTSeye)
		RTSeye.forceMove(TT)
		user.sight = 60 //see through walls
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

/obj/machinery/computer/camera_advanced/rts_control/proc/RemoveActions(mob/living/carbon/user)
	if(off_action)
		off_action.Remove(user)
		off_action.target = null
	if(rally_action)
		rally_action.Remove(user)
		rally_action.RTSeye = null
		rally_action.target = null

//ACTIONS!//

/datum/action/innate/rally
	name = "Set rally point"
	icon_icon = 'StarTrek13/icons/actions/rts_actions.dmi'
	button_icon_state = "rally"
	var/mob/camera/aiEye/remote/rts/RTSeye //Set this!

/datum/action/innate/rally/Activate()
	RTSeye.rally(RTSeye.loc) //Rally the selected fleet to this location

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

/mob/camera/aiEye/remote/rts/proc/rally(turf/T)
	if(!T)
		return
	new /obj/effect/temp_visual/trek/shieldhit(T.loc)
	for(var/obj/structure/overmap/ship/AI/S in fleet)
		S.rally_point = T

/mob/camera/aiEye/remote/rts/proc/fleet_attack(obj/structure/overmap/OM)
	if(!OM)
		return
	//if(OM.faction != console.faction) RE-ADD ME WHEN WE'RE DONE TESTING FOR THE LOVE OF ALL THAT IS HOLY JESUSUUUSUSUDUADJASKXMJNDKMASDKMAN
	if(OM)
		to_chat(console.operator, "Command confirmed, moving in to attack!")
		new /obj/effect/temp_visual/trek/shieldhit(OM.loc)
		for(var/obj/structure/overmap/ship/AI/S in fleet)
			S.force_target = OM
			S.rally_point = null
			S.stored_target = null
			message_admins("DEBUG! [S] is now hunting [OM]")

/mob/camera/aiEye/remote/rts/proc/onMouseDown(object, location, params)
	var/list/modifiers = params2list(params)
	to_chat(console.operator, "click")
	if(modifiers["middle"])
		to_chat(console.operator, "middle-click")
		if(istype(object, /turf/open))
			rally(object)
		else
			if(istype(object, /obj/structure/overmap)) //For now, you can't attack your own stuff. We may need to change this!
				var/obj/structure/overmap/om = object
				fleet_attack(om)
	if(modifiers["shift"])
		if(istype(object, /obj/structure/overmap/ship/AI))
			var/obj/structure/overmap/ship/AI/om = object
			if(om.faction == console.faction)
				if(om in fleet)
					fleet -= om
					to_chat(console.operator, "[om] has been removed your command group")
	if(modifiers["ctrl"])
		if(istype(object, /obj/structure/overmap/ship/AI))
			var/obj/structure/overmap/ship/AI/om = object
			if(om.faction == console.faction)
				fleet += om
				to_chat(console.operator, "[om] has been added to your command group")
	if(modifiers["alt"])
		if(istype(object, /obj/structure/overmap))
			return //ADD COMMS CODE HERE WEEE
		//	var/obj/structure/overmap/om = object
		return

/obj/structure/overmap/ship/AI/federation
	name = "Miranda class light cruiser"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "destroyer"
	max_health = 9500 //Player controlled miranda has 15000 HP
	max_speed = 3
	acceleration = 0.5
	faction = "starfleet"
	spawn_random = FALSE
	damage = 1500 //This should be low, as it will ALWAYS hit for this much damage
	agressive = FALSE //Do we attack on sight? admirals can change this!

/obj/structure/overmap/ship/AI/romulan
	name = "Dderidex class warbird"
	icon = 'StarTrek13/icons/trek/large_ships/dderidex.dmi'
	icon_state = "dderidex"
	max_health = 30000 //Player controlled miranda has 15000 HP
	max_speed = 3
	acceleration = 0.5
	faction = "romulan empire"
	spawn_random = FALSE
	damage = 3000 //This should be low, as it will ALWAYS hit for this much damage --This is a fucking warbird they hit HARD
	agressive = FALSE //Do we attack on sight? admirals can change this!