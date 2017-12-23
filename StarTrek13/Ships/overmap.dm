
//Movement system and upgraded ship combat!

//	face_atom(A)//////

/area/ // fuck your idea of shoving everything into one file
	var/current_overmap = "none" // current map an area is on.

var/global/list/overmap_objects = list()

/area/overmap
	name = "generic overmap area"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	flags_1 = NONE
	requires_power = FALSE

/area/overmap/starbase
	name = "starbase 59"

/area/overmap/starbase
	name = "starbase 59"

#define TORPEDO_MODE 1//1309
#define PHASER_MODE 2

/obj/structure/overmap
	name = "generic structure"
//	var/linked_ship = /area/ship //change me
	var/datum/beam/current_beam = null //stations will be able to fire back, too!
	var/health = 20000 //pending balance, 20k for now
	var/obj/machinery/space_battle/shield_generator/generator
	var/obj/structure/fluff/helm/desk/tactical/weapons
	var/shield_health = 1050 //How much health do the shields have left, for UI type stuff and icon_states
	var/mob/living/carbon/human/pilot
	var/view_range = 7 //change the view range for looking at a long range.
	anchored = 0
	can_be_unanchored = 0 //Don't anchor a ship with a wrench, these are going to be people sized
	density = 1
	var/list/interactables_near_ship = list()
	var/area/linked_ship //CHANGE ME WITH THE DIFFERENT TYPES!
	var/max_shield_health = 20000 //default max shield health, changes on process
	var/shields_active = 0
	pixel_y = -32
	var/next_vehicle_move = 0 //used for move delays
	var/vehicle_move_delay = 4 //tick delay between movements, lower = faster, higher = slower
	var/mode = 0 //add in two modes ty
	var/damage = 800 //standard damage for phasers, this will tank shields really quickly though so be warned!
	var/atom/targetmeme = null //for testing
	var/weapons_charge_time = 60 //6 seconds inbetween shots.
	var/in_use1 = 0 //firing weapons?
	var/initial_icon_state = "generic"
	var/obj/machinery/computer/camera_advanced/transporter_control/transporters = list()//linked transporter CONTROLLER
	var/spawn_name = "ship_spawn"
	var/spawn_random = 1
	var/turf/initial_loc = null //where our pilot was standing upon entry
	var/station = 0 // are we a station
	var/notified = 1 //notify pilot of visitable structures
	var/recharge = 0 //
	var/recharge_max = 1.4 //not quite spam, but not prohibitive either
	var/sensor_range = 10 //radius in which ships can be beamed to, amongst other things
	var/area/transport_zone = null
	var/marker = "cadaver"
	var/atom/movable/nav_target = null
	var/navigating = 0

/obj/structure/overmap/New()
	. = ..()
	overmap_objects += src
	START_PROCESSING(SSfastprocess,src)
	linkto()
	linked_ship = get_area(src)
	var/list/thelist = list()
	for(var/obj/effect/landmark/A in GLOB.landmarks_list)
		if(A.name == spawn_name)
			thelist += A
			continue
//	for(var/obj/effect/landmark/transport_zone/T in world)
	//	transport_zone = get_area(T)
	var/obj/effect/landmark/A = pick(thelist)
	var/turf/theloc = get_turf(A)
	forceMove(theloc)


/obj/structure/overmap/proc/toggle_shields(mob/user)
	generator.toggle(user)

/obj/structure/overmap/away/station
	name = "space station 13"
	icon = 'StarTrek13/icons/trek/large_overmap.dmi'
	icon_state = "station"
	spawn_random = 0
	station = 1
	spawn_name = "station_spawn"
	initial_icon_state = "station"

/obj/structure/overmap/away/station/starbase
	name = "starbase59"
	spawn_name = "starbase_spawn"
	marker = "starbase"

/obj/structure/overmap/ship
	name = "USS Cadaver"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "generic"

/obj/structure/overmap/away/station/nanotrasen/shop
	name = "NSV Mercator trading outpost"
	icon = 'StarTrek13/icons/trek/large_overmap.dmi'
	icon_state = "shop"
	spawn_name = "shop_spawn"
	initial_icon_state = "shop"

/obj/structure/overmap/away/station/nanotrasen/research_bunker
	name = "NSV Woolf research outpost"
	icon = 'StarTrek13/icons/trek/large_overmap.dmi'
	icon_state = "research"
	spawn_name = "research_spawn"
	initial_icon_state = "research"

/obj/structure/overmap/ship/target //dummy for testing woo
	name = "USS Entax"
	icon_state = "destroyer"
	initial_icon_state = "destroyer"
	spawn_name = "ship_spawn"


/obj/structure/overmap/ship/nanotrasen
	name = "NSV Muffin"
	icon_state = "whiteship"
	initial_icon_state = "whiteship"
	spawn_name = "NT_SHIP"

/obj/structure/overmap/ship/nanotrasen/freighter
	name = "NSV Crates"
	icon_state = "freighter"
	initial_icon_state = "freighter"
	spawn_name = "FREIGHTER_SPAWN"

//So basically we're going to have ships that fly around in a box and shoot each other, i'll probably have the pilot mob possess the objects to fly them or something like that, otherwise I'll use cameras.

/obj/structure/overmap/ship/relaymove(mob/user,direction)
	if(user.incapacitated())
		return //add things here!
	if(!Process_Spacemove(direction) || world.time < next_vehicle_move || !isturf(loc))
		return
	if(navigating)
		navigating = 0
	step(src, direction)
	next_vehicle_move = world.time + vehicle_move_delay
	//use_power

//obj/structure/overmap/ship/Move(atom/newloc, direct)
//	. = ..()
//	if(.)
	//	events.fireEvent("onMove",get_turf(src))

/obj/structure/overmap/ship/Process_Spacemove(movement_dir = 0)
	return 1 //add engines later

/obj/structure/overmap/proc/enter(mob/user)
	if(pilot)
		to_chat(user, "you kick [pilot] off the ship controls!")
	//	M.revive(full_heal = 1)
		exit()
		return 0
	initial_loc = user.loc
	user.loc = src
	pilot = user
//	pilot.status_flags |= GODMODE

/obj/structure/overmap/AltClick()
	exit()

/obj/structure/overmap/proc/exit(mob/user)
	to_chat(pilot,"you have stopped controlling [src]")
	pilot.forceMove(initial_loc)
	initial_loc = null
//	pilot.status_flags -= GODMODE
	pilot = null


//obj/structure/overmap/ship/GrantActions(mob/living/user, human_occupant = 0)
//	internals_action.Grant(user, src)
//	var/datum/action/innate/mecha/strafe/strafing_action = new

/obj/structure/overmap/proc/linkto()	//weapons etc. don't link!
	for(var/obj/structure/fluff/helm/desk/tactical/T in linked_ship)
		weapons = T
		T.theship = src
	for(var/obj/machinery/space_battle/shield_generator/G in linked_ship)
		generator = G
		G.ship = src
	for(var/obj/machinery/computer/camera_advanced/transporter_control/T in linked_ship)
		transporters += T

/obj/structure/overmap/take_damage(amount,turf/target)
	if(has_shields())
		generator.take_damage(amount)//shields now handle the hit
		var/datum/effect_system/spark_spread/s = new
		s.set_up(2, 1, src)
		s.start() //make a better overlay effect or something, this is for testing
		return
	else//no shields are up! take the hit
		icon_state = initial_icon_state
		var/turf/theturf = get_turf(target)
		explosion(theturf,2,5,11)
		var/datum/effect_system/spark_spread/s = new
		s.set_up(2, 1, src)
		s.start() //make a better overlay effect or something, this is for testing
		health -= amount
		playsound(src.loc, 'StarTrek13/sound/borg/machines/shiphit.ogg',100,0) //clang
		return

/obj/structure/overmap/proc/update_transporters()
	var/list/L = range(5, src)

	for(var/obj/machinery/computer/camera_advanced/transporter_control/TC in transporters)
		TC.destinations = L
		//var/list/thelist = list(OM.transporter,OM.weapons,OM.generator,OM.initial_loc)
		//for(var/obj/machinery/trek/transporter/T in OM.transporter.linked)
		//	transporter.available_turfs += get_turf(T)

/obj/structure/overmap/CtrlClick(mob/user)
	if(pilot == user)
		set_nav_target(user)

/obj/structure/overmap/ShiftClick(mob/user)
	if(pilot == user) //don't change the firing mode of enemy ships etc.
		if(mode != TORPEDO_MODE)
			mode = TORPEDO_MODE
			to_chat(pilot, "switched to torpedo firing mode")
		else
			mode = PHASER_MODE
			to_chat(pilot, "switched to phaser firing mode")

/obj/structure/overmap/process()
	recharge --
	linkto()
	location()
	if(navigating)
		navigate()
	get_interactibles()
	//transporter.destinations = list() //so when we leave the area, it stops being transportable.
	var/obj/effect/adv_shield/theshield = pick(generator.shields) //sample a random shield for health and stats.
	shield_health = theshield.health
	max_shield_health = theshield.maxhealth
//	if(!generator || !generator.shields.len)
	if(has_shields())
		shields_active = 1
		icon_state = initial_icon_state + "-shield"
	else
		shields_active = 0
		icon_state = initial_icon_state
	if(health <= 0)
		destroy(1)
	//	transporter.destinations = list()
	if(pilot.loc != src)
		exit() //pilot has been tele'd out, remove them!



/obj/structure/overmap/proc/navigate()
	if(world.time < next_vehicle_move)
		return 0
	next_vehicle_move = world.time + vehicle_move_delay
	step_to(src,nav_target)
	var/d = get_dir(src, nav_target)		//thanks lummox
	if(d & (d-1))//not a cardinal direction
		setDir(d)
		step(src,dir)
	if(src in orange(4, nav_target))
		navigating = 0
		to_chat(pilot, "finished tracking [nav_target]. Autopilot disengaged")

/obj/structure/overmap/proc/set_nav_target(mob/user)
	if(!station)
		var/A
		A = input("What ship shall we track?", "Ship navigation", A) as null|anything in overmap_objects
		var/obj/structure/overmap/O = A
		nav_target = O
		//nav_target = overmap_objects[A]
		set_dir_to_target()
		to_chat(pilot, "autopilot engaged, it will be disabled if you try and move the ship again.")
	else
		to_chat(pilot, "ERROR: [src] does not have engines")

/obj/structure/overmap/proc/set_dir_to_target()
	if(!navigating)
		navigating = 1

/obj/structure/overmap/proc/get_interactibles()
	for(var/obj/structure/overmap/OM in interactables_near_ship)
		if(OM.shields_active == 0) //its shields are down
			update_transporters()
			return 1
		else
			return 0

/obj/structure/overmap/proc/location() //OK we're using areas for this so that we can have the ship be within an N tile range of an object
//	var/area/thearea = get_area(src)
	interactables_near_ship = list()
	for(var/obj/structure/overmap/A in orange(sensor_range,src))
		if(!istype(A))
			return
		interactables_near_ship += A
	if(interactables_near_ship.len > 0)
		return 1
	else//nope
		return 0

/obj/structure/overmap/proc/destroy(severity)
	STOP_PROCESSING(SSfastprocess,src)
	exit()
	switch(severity)
		if(1)
			//Here we will blow up the ship map as well, 0 is if you dont want to lag the server.
			qdel(src)
			//make explosion in ship
		if(0)
			qdel(src)

/obj/structure/overmap/proc/has_shields()
	if(shield_health > 2000 && shields_active)
		return 1
	else//no
		return 0

/obj/structure/overmap/bullet_act(var/obj/item/projectile/P)
	. = ..()
	take_damage(P.damage)

/obj/structure/overmap/ship/starfleet
	name = "USS Cadaver"
	icon_state = "cadaver"
//obj/structure/fluff/ship/helm do me later

/obj/structure/overmap/proc/click_action(atom/target,mob/user)
//add in TORPEDO MODE and PHASER MODE TO A MODE SELECT UI THING
	targetmeme = target
	if(user.incapacitated())
		return
//	if(!get_charge())
//		return
	if(istype(target, /obj/structure/overmap))
		var/obj/structure/overmap/thetarget = target
		target = thetarget
		if(target == src)
			return
		switch(mode)
			if(TORPEDO_MODE)
				fire_torpedo(thetarget,user)
			else
				fire(thetarget,user)
	else
		to_chat(user, "Unable to lock phasers, this weapon mode only targets large objects")
		return


/obj/structure/overmap/proc/fire(atom/target,mob/user)
	if(recharge <= 0)
		recharge = recharge_max //-1 per tick
		in_use1 = 1
		var/source = get_turf(src)
		targetmeme = target
		var/obj/structure/overmap/S = target
		current_beam = new(source, target,time=30,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
		var/list/L = list()
		var/area/thearea = S.linked_ship
		for(var/turf/T in get_area_turfs(thearea.type))
			L+=T
		var/location = pick(L)
		var/turf/theturf = get_turf(location)
		S.take_damage(damage,theturf)
		in_use1 = 0
		current_beam.Start()
		var/list/soundlist = list('StarTrek13/sound/borg/machines/phaser.ogg','StarTrek13/sound/borg/machines/phaser2.ogg','StarTrek13/sound/borg/machines/phaser3.ogg')
		var/chosen_sound = pick(soundlist)
		SEND_SOUND(pilot, sound(chosen_sound))
		SEND_SOUND(S.pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
		return
	else
		to_chat(user, "Weapons still charging")
		return

/obj/structure/overmap/proc/fire_torpedo(obj/structure/overmap/OM)
	var/list/thelist = list(OM.transporters,OM.weapons,OM.generator,OM.initial_loc)
	var/fuck = pick(thelist)
	var/turf/theturf = get_turf(fuck)
	weapons.fire_torpedo(theturf, pilot)
	SEND_SOUND(pilot, sound('StarTrek13/sound/borg/machines/torpedo1.ogg'))

#undef TORPEDO_MODE
#undef PHASER_MODE