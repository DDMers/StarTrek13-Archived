
//Movement system and upgraded ship combat!

//	face_atom(A)//////

//Remember: If your ship appears to have no damage, or won't charge, you probably didn't put physical phasers on the ship's map!


//NOTE TO SELF:
//Make destroy do something, otherwise it seriously glitches out the pilot!

/area/ // fuck your idea of shoving everything into one file
	var/current_overmap = "none" // current map an area is on.

var/global/list/overmap_objects = list()
var/global/list/global_ship_list = list()

/area/overmap
	name = "Teshan"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	flags_1 = NONE
	requires_power = FALSE
	var/jumpgate_position = 1 //Change me! whenever you add a new system, incriment this by 1!

/area/overmap/hyperspace
	name = "hyperspace"
	parallax_movedir = 8

/area/overmap/system
	name = "Volorr"
	jumpgate_position = 2

/area/overmap/system/z2
	name = "Amann" //Test
	jumpgate_position = 3

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
	var/atom/movable/pilot
	var/view_range = 7 //change the view range for looking at a long range.
	anchored = FALSE
	can_be_unanchored = FALSE //Don't anchor a ship with a wrench, these are going to be people sized
	density = TRUE
	var/list/interactables_near_ship = list()
	var/area/linked_ship //CHANGE ME WITH THE DIFFERENT TYPES!
	var/max_shield_health = 20000 //default max shield health, changes on process
	var/shields_active = FALSE
	pixel_y = -32
	var/next_vehicle_move = 0 //used for move delays
	var/vehicle_move_delay = 6 //tick delay between movements, lower = faster, higher = slower
	var/mode = 0 //add in two modes ty
	var/damage = 800 //standard damage for phasers, this will tank shields really quickly though so be warned!
	var/obj/structure/overmap/target_ship = null
	var/weapons_charge_time = 60 //6 seconds inbetween shots.
	var/in_use1 = FALSE //firing weapons?
	var/obj/machinery/computer/camera_advanced/transporter_control/transporters = list()//linked transporter CONTROLLER
	var/spawn_name = "ship_spawn"
	var/spawn_random = TRUE
	var/turf/initial_loc = null //where our pilot was standing upon entry
	var/can_move = TRUE // are we a station
	var/notified = TRUE //notify pilot of visitable structures
	var/recharge = FALSE //
	var/recharge_max = 1.4 //not quite spam, but not prohibitive either
	var/turret_recharge = FALSE
	var/max_turret_recharge = 0.8
	var/sensor_range = 10 //radius in which ships can be beamed to, amongst other things
	var/area/transport_zone = null
	var/marker = "cadaver"
	var/atom/movable/nav_target = null
	var/navigating = FALSE
	var/faction = "federation" //So the ai ships don't shoot it.
	var/charge = 4000 //Phaser chareg													////TESTING REMOVE ME AND PUT BME BACK TO 0 OR THIS WILL KILL ALL BALANCE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	var/phaser_charge_total = 0 //How much power all the ship phasers draw together
	var/phaser_charge_rate = 0
	var/phaser_fire_cost = 0 //How much charge to fire all the guns
	var/max_charge = 0 //Max phaser power charge
	var/counter = 0 //Testing
	var/obj/ship_turrets/fore_turrets = null
	var/obj/ship_turrets/aft_turrets/aft_turrets = null
	var/obj/item/gun/energy/laser/ship_weapon/turret_gun/fore_turrets_gun = null	//If your ship has turrets, be sure to change has_turrets!
	var/obj/item/gun/energy/laser/ship_weapon/turret_gun/aft_turrets_gun = null
	var/has_turrets = 0 //By default, NO turrets installed. I recommend you keep federation turrets invisible as shields will bug out with overlays etc. You have been warned!
	var/image/list/gun_turrets = list() //because overlays are weird.
	var/atom/movable/target_fore = null// for gun turrets
	var/atom/movable/target_aft = null
	var/list/soundlist = list('StarTrek13/sound/borg/machines/phaser.ogg','StarTrek13/sound/borg/machines/phaser2.ogg','StarTrek13/sound/borg/machines/phaser3.ogg')//The sounds made when shooting
	var/datum/shipsystem_controller/SC
	var/turret_firing_cost = 100 //How much does it cost to fire your turrets?
	var/obj/structure/overmap/ship/fighter/fighters = list()
	var/take_damage_traditionally = TRUE //Are we a real ship? that will have a shield generator and such? exceptions include fighters.
	var/datum/looping_sound/trek/engine_hum/soundloop
	var/obj/structure/overmap/agressor = null //Who is attacking us? this is done to reset their targeting systems when they destroy us!
	var/warp_capable = FALSE //Does this ship have a warp drive?
	////IMPORTANT VAR!!!////

/obj/item/ammo_casing/energy/ship_turret
	projectile_type = /obj/item/projectile/beam/laser/ship_turret_laser
	e_cost = 0 // :^)
	select_name = "fuckyou"

/obj/item/projectile/beam/laser/ship_turret_laser
	name = "turbolaser"
	icon_state = "shiplaser"
	damage = 20//It has to actually dent ships tbh.

/obj/item/projectile/beam/laser/photon_torpedo
	name = "turbolaser"
	icon_state = "shiplaser"
	damage = 1500//Monster damage because you only get a few

/obj/ship_turrets
	name = "Fore turrets"
	icon_state = null
	icon = null
	var/fire_cost = 100
	var/fire_amount = 3 //fire thrice per shot

/obj/ship_turrets/aft_turrets
	name = "Aft turrets"
	fire_cost = 100
	fire_amount = 2 //fire twice per shot

/obj/structure/overmap/New()
	. = ..()
	overmap_objects += src
	soundloop = new(list(src), TRUE)
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
	if(spawn_random)
		forceMove(theloc)
	if(has_turrets)
		fore_turrets = new /obj/ship_turrets(src.loc)
		aft_turrets = new /obj/ship_turrets/aft_turrets(src.loc)
		fore_turrets.icon_state = initial(icon_state) + "-fore_turrets"	//Remember! fore = front, if you want your turrets to visibly turn and shoot ships you need to make them their own layer.
		aft_turrets.icon_state = initial(icon_state) + "-aft_turrets"
		update_turrets()
		return
/*
		fore_turrets = new /obj/ship_turrets
		aft_turrets = new /obj/ship_turrets/aft_turrets
		fore_turrets.icon = src.icon
		aft_turrets.icon = src.icon
		fore_turrets.icon_state = initial(icon_state) + "-fore_turrets"	//Remember! fore = front, if you want your turrets to visibly turn and shoot ships you need to make them their own layer.
		aft_turrets.icon_state = initial(icon_state) + "-aft_turrets"
		fore_turrets.layer = 4.5
		overlays += fore_turrets
		aft_turrets.layer = 4.5
		overlays += aft_turrets
*/

/obj/structure/overmap/proc/toggle_shields(mob/user)
	generator.toggle(user)

/obj/structure/overmap/away/station
	name = "space station 13"
	icon = 'StarTrek13/icons/trek/huge_overmap.dmi'
	icon_state = "station"
	spawn_random = FALSE
	can_move = FALSE
	spawn_name = "station_spawn"
	var/datum/shipsystem/shields/station_shields = null

/obj/structure/overmap/away/station/New()
	station_shields = new()

/obj/structure/overmap/ship //dummy for testing woo
	name = "USS thingy"
	icon_state = "generic"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	spawn_name = "ship_spawn"
	pixel_x = 0
	pixel_y = -32
	damage = 800

/obj/structure/overmap/away/station/starbase
	name = "starbase59"
	spawn_name = "starbase_spawn"
	marker = "starbase"

/obj/structure/overmap/ship/federation_capitalclass
	name = "USS Cadaver"
	icon = 'StarTrek13/icons/trek/capitalships.dmi'
	icon_state = "cadaver"
	pixel_x = -100
	pixel_y = -100
//	var/datum/shipsystem_controller/SC
	warp_capable = TRUE

/obj/structure/overmap/ship/New()
	SC = new(src)
	SC.generate_shipsystems()
	SC.theship = src
	global_ship_list += src
	..()

/obj/structure/overmap/ship/nanotrasen_capitalclass
	name = "NSV annulment"
	desc = "Contract anulled....forever"
	icon = 'StarTrek13/icons/trek/capitalships.dmi'
	icon_state = "annulment"
	spawn_name = "nt_capital"
	has_turrets = 1
	soundlist = list('StarTrek13/sound/trek/ship_gun.ogg','StarTrek13/sound/trek/ship_gun.ogg')//The sounds made when shooting

/datum/looping_sound/trek/engine_hum
	start_sound = null
	start_length = 0
	mid_sounds = list('StarTrek13/sound/trek/engines/engine.ogg'=1)
	mid_length = 133
	end_sound = null
	volume = 70

/obj/structure/overmap/away/station/nanotrasen/shop
	name = "NSV Mercator trading outpost"
	icon = 'StarTrek13/icons/trek/large_overmap.dmi'
	icon_state = "shop"
	spawn_name = "shop_spawn"

/obj/structure/overmap/away/station/nanotrasen/research_bunker
	name = "NSV Woolf research outpost"
	icon = 'StarTrek13/icons/trek/large_overmap.dmi'
	icon_state = "research"
	spawn_name = "research_spawn"

/obj/structure/overmap/ship/target //dummy for testing woo
	name = "USS Entax"
	icon_state = "destroyer"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	spawn_name = "ship_spawn"
	pixel_x = -32
	pixel_y = -32
	health = 5000
	vehicle_move_delay = 2
	warp_capable = TRUE


/obj/structure/overmap/ship/nanotrasen
	name = "NSV Muffin"
	icon_state = "whiteship"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	spawn_name = "NT_SHIP"
	pixel_x = 0
	pixel_y = -32
	health = 5000
	vehicle_move_delay = 2

/obj/structure/overmap/ship/nanotrasen/freighter
	name = "NSV Crates"
	icon_state = "freighter"
	spawn_name = "FREIGHTER_SPAWN"
	health = 3000
	vehicle_move_delay = 2

//So basically we're going to have ships that fly around in a box and shoot each other, i'll probably have the pilot mob possess the objects to fly them or something like that, otherwise I'll use cameras.

/obj/structure/overmap/ship/relaymove(mob/user,direction)
	if(can_move)
		if(user.incapacitated())
			return //add things here!
		if(!Process_Spacemove(direction) || world.time < next_vehicle_move || !isturf(loc))
			return
		if(navigating)
			navigating = 0
		step(src, direction)
		next_vehicle_move = world.time + vehicle_move_delay
		if(has_turrets)
			update_turrets()
	//use_power

//obj/structure/overmap/ship/Move(atom/newloc, direct)
//	. = ..()
//	if(.)
	//	events.fireEvent("onMove",get_turf(src))

/obj/structure/overmap/ship/Process_Spacemove(movement_dir = 0)
	return 1 //add engines later

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
		if(isovermapship(src))
			var/obj/structure/overmap/ship/S = src
			S.SC.shields.linked_generators += G
			G.shield_system = S.SC.shields
		if(isovermapstation(src))
			var/obj/structure/overmap/away/station/station = src
			station.station_shields.linked_generators += G
			G.shield_system = station.station_shields
	for(var/obj/machinery/computer/camera_advanced/transporter_control/T in linked_ship)
		transporters += T
	for(var/obj/structure/overmap/ship/fighter/F in linked_ship)
		F.carrier_ship = src
		if(!F in fighters)
			fighters += F

/obj/structure/overmap/proc/update_weapons()	//So when you destroy a phaser, it impacts the overall damage
	damage = 0	//R/HMMM
	phaser_fire_cost = 0
	max_charge = 0
	phaser_charge_rate = 0
	var/counter = 0
	var/temp = 0
	for(var/obj/machinery/power/ship/phaser/P in weapons.weapons)
		phaser_charge_rate += P.charge_rate
		damage += P.damage
		phaser_fire_cost += P.fire_cost
		counter ++
		temp = P.charge
	max_charge += counter*temp //To avoid it dropping to 0 on update, so then the charge spikes to maximum due to process()
	for(var/obj/structure/overmap/ship/fighter/F in linked_ship) //Update any fighters inside of us
		F.carrier_ship = src
		if(!F in fighters)
			fighters += F

/obj/structure/overmap/take_damage(amount,turf/target)
	if(take_damage_traditionally) //Set this var to 0 to do your own weird shitcode
		if(has_shields())
			var/heat_multi = 1
			if(isovermapship(src))
				var/obj/structure/overmap/ship/S = src
				heat_multi = S.SC.shields.heat >= 50 ? 2 : 1 // double damage if heat is over 50.
				S.SC.shields.heat += round(amount/S.SC.shields.heat_resistance)
			if(isovermapstation(src))
				var/obj/structure/overmap/away/station/station = src
				heat_multi = station.station_shields.heat >= 50 ? 2 : 1
				station.station_shields.heat += round(amount/station.station_shields.heat_resistance)
			generator.take_damage(amount*heat_multi)
			var/datum/effect_system/spark_spread/s = new
			s.set_up(2, 1, src)
			s.start() //make a better overlay effect or something, this is for testing
			return
		else//no shields are up! take the hit
			icon_state = initial(icon_state)
			var/turf/theturf = pick(get_area_turfs(target_ship))
			if(prob(40))
				explosion(theturf,2,5,11)
			for(var/mob/L in linked_ship.contents)
				shake_camera(L, 1, 10)
				var/sound/thesound = pick(ship_damage_sounds)
				SEND_SOUND(L, thesound)

			var/datum/effect_system/spark_spread/s = new
			s.set_up(2, 1, src)
			s.start() //make a better overlay effect or something, this is for testing
			//health -= amount

			health -= amount
			return
	else
		shake_camera(pilot, 1, 10)
		var/sound/thesound = pick(ship_damage_sounds)
		SEND_SOUND(pilot, thesound)
		health -= amount
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

/obj/structure/overmap/ShiftClick(mob/user)//Hi my name is KMC and I don't know how to make UIs :^)
	if(pilot == user) //don't change the firing mode of enemy ships etc.
		to_chat(pilot, "RESET WEAPON TARGETING SYSTEMS, fire on a new target to begin tracking.")
		target_ship = null
		target_fore = null
		target_aft = null
		if(isovermapship(src))
			var/obj/structure/overmap/ship/theship = src
			theship.input_warp_target(user)

/obj/structure/overmap/proc/update_turrets()
	return
/*
	if(has_turrets)
		fore_turrets.forceMove(src.loc)
		aft_turrets.forceMove(src.loc)
		fore_turrets.layer = 4.5
		aft_turrets.layer = 4.5
		fore_turrets.icon = src.icon
		aft_turrets.icon = src.icon
		fore_turrets.icon_state = initial(icon_state) + "-fore_turrets"	//Remember! fore = front, if you want your turrets to visibly turn and shoot ships you need to make them their own layer.
		aft_turrets.icon_state = initial(icon_state) + "-aft_turrets"
		fore_turrets.dir = get_dir(src,target_fore)
		aft_turrets.dir = get_dir(src,target_aft)
		fore_turrets.pixel_x = src.pixel_x
		aft_turrets.pixel_x = src.pixel_x
		fore_turrets.pixel_y = src.pixel_y
		aft_turrets.pixel_y = src.pixel_y
		switch(dir)
			if(2)
				fore_turrets.icon_state = initial(icon_state) + "-fore_turrets_south"
				aft_turrets.icon_state = initial(icon_state) + "-aft_turrets_south"
				fore_turrets.dir = get_dir(src,target_fore)
				aft_turrets.dir = get_dir(src,target_aft)
			if(1)
				fore_turrets.icon_state = initial(icon_state) + "-fore_turrets_north"
				aft_turrets.icon_state = initial(icon_state) + "-aft_turrets_north"
				fore_turrets.dir = get_dir(src,target_fore)
				aft_turrets.dir = get_dir(src,target_aft)
			if(4)
				fore_turrets.icon_state = initial(icon_state) + "-fore_turrets_east"
				aft_turrets.icon_state = initial(icon_state) + "-aft_turrets_east"
				fore_turrets.dir = get_dir(src,target_fore)
				aft_turrets.dir = get_dir(src,target_aft)
			if(8)
				fore_turrets.icon_state = initial(icon_state) + "-fore_turrets_west"
				aft_turrets.icon_state = initial(icon_state) + "-aft_turrets_west"
				fore_turrets.dir = get_dir(src,target_fore)
				aft_turrets.dir = get_dir(src,target_aft)
*/ //borked

/obj/structure/overmap/proc/fire(atom/target,mob/user)
	to_chat(pilot, "Target confirmed, all gun batteries locking on to [target]")
	target_ship = target

/obj/structure/overmap/proc/attempt_fire()
	if(recharge <= 0 && charge >= phaser_fire_cost)
		recharge = recharge_max //-1 per tick
		var/source = get_turf(src)
		var/obj/structure/overmap/S = target_ship
		var/list/L = list()
		var/area/thearea = S.linked_ship
		for(var/turf/T in get_area_turfs(thearea.type))
			L+=T
		var/location = pick(L)
		var/turf/theturf = get_turf(location)
		S.take_damage(damage,theturf)
		in_use1 = 0
		var/chosen_sound = pick(soundlist)
		SEND_SOUND(pilot, sound(chosen_sound))
		SEND_SOUND(S.pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
		charge -= phaser_fire_cost
		current_beam = new(source,target_ship,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
		spawn(0)
			current_beam.Start()
		return 1
	else
		return 0

/obj/structure/overmap/proc/attempt_turret_fire()
	if(charge > 0 && has_turrets && target_ship && turret_recharge <= 0) //Not ready to fire the big guns, but smaller phaser batteries can still fire
		charge -= turret_firing_cost
		var/obj/item/projectile/beam/laser/ship_turret_laser/A = new /obj/item/projectile/beam/laser/ship_turret_laser(loc)
		A.starting = loc
		A.preparePixelProjectile(target_ship,pilot)
		A.pixel_x = rand(-20, 50)
		A.fire()
		playsound(src,'StarTrek13/sound/trek/ship_gun.ogg',40,1)
		turret_recharge = max_turret_recharge
		sleep(1)
		A.pixel_x = target_ship.pixel_x
		A.pixel_y = target_ship.pixel_y
		return 1

/obj/structure/overmap/process()
	if(recharge > 0)
		recharge --
	if(turret_recharge >0)
		turret_recharge --
	attempt_fire()
	linkto()
	attempt_turret_fire()
	location()
	update_weapons()
	update_turrets()
	counter ++
	if(navigating)
		update_turrets()
		navigate()
	get_interactibles()
	//transporter.destinations = list() //so when we leave the area, it stops being transportable.
	if(take_damage_traditionally)
		var/obj/effect/adv_shield/theshield = pick(generator.shields) //sample a random shield for health and stats.
		shield_health = theshield.health
		max_shield_health = theshield.maxhealth
	//	if(!generator || !generator.shields.len)
		if(has_shields())
			shields_active = 1
			icon_state = initial(icon_state) + "-shield"
		else
			shields_active = 0
			icon_state = initial(icon_state)
	if(health <= 0)
		destroy(1)
	if(pilot)
		if(pilot.loc != src)
			exit() //pilot has been tele'd out, remove them!

	if(counter >= 10)//every 10 ticks it'll charge
		if(charge < max_charge)
			charge += phaser_charge_rate
			counter = 0
		//	if(charge > max_charge)
			//	charge = max_charge
	//	else
	//		charge = max_charge

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

/obj/structure/overmap/proc/navigate()
	update_turrets()
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

/obj/structure/overmap/ship/proc/input_warp_target(mob/user)
	if(warp_capable)
		var/list/destinations_possible = list()
		for(var/obj/effect/landmark/warp_beacon/L in warp_beacons)
			if(!L.warp_restricted)
				destinations_possible += L
		var/A
		A = input("Select destination", "Warp drive calibration.", A) as obj in warp_beacons
		if(!A)
			return
		var/obj/effect/landmark/warp_beacon/M = A
		do_warp(M, M.distance) //distance being the warp transit time.


/obj/structure/overmap/ship/proc/do_warp(destination, jump_time) //Don't want to lock this behind warp capable because jumpgates call this
	can_move = 0 //Don't want them moving around warp space.
	shake_camera(pilot, 1, 10)
	SEND_SOUND(pilot, 'StarTrek13/sound/trek/ship_effects/warp.ogg')
	to_chat(pilot, "The ship has entered warp space")
	setDir(4)
	for(var/mob/L in linked_ship.contents)
		shake_camera(L, 1, 10)
		SEND_SOUND(L, 'StarTrek13/sound/trek/ship_effects/warp.ogg')
		to_chat(pilot, "The deck plates shudder as the ship builds up immense speed.")
		linked_ship.parallax_movedir = 4
	addtimer(CALLBACK(src, .proc/finish_warp, destination),jump_time)

/obj/structure/overmap/ship/proc/finish_warp(atom/movable/destination)
	can_move = 1
	shake_camera(pilot, 4, 2)
	to_chat(pilot, "The ship has left warp space.")
	for(var/mob/L in linked_ship.contents)
		shake_camera(L, 4, 2)
		to_chat(pilot, "The ship slows.")
		linked_ship.parallax_movedir = FALSE
	forceMove(destination.loc)

/obj/structure/overmap/proc/set_nav_target(mob/user)
	if(can_move)
		var/A
		var/list/theships = list()
		for(var/obj/structure/overmap/O in overmap_objects)
			if(O.z == z)
				theships += O
		for(var/obj/structure/jumpgate/J in jumpgates)
			if(J.z == z)
				theships += J
		if(!theships.len)
			return
		A = input("What ship shall we track?", "Ship navigation", A) as null|anything in theships//overmap_objects
		if(!A)
			return
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
	if(agressor)
		agressor.target_ship = null
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

/obj/structure/overmap/ship/has_shields()
	if(SC.shields.heat >= 100)
		return 0
	else
		return ..()

/obj/structure/overmap/bullet_act(var/obj/item/projectile/P)
	. = ..()
	take_damage(P.damage)

/obj/structure/overmap/Collide(atom/movable/mover) //Collide is when this ship rams stuff, collided with is when it's rammed
	return ..()

/obj/structure/overmap/CollidedWith(atom/movable/mover)
	if(!isOVERMAP(mover))
		if(!istype(mover, /obj/structure/jumpgate))
			if(!shields_active)
				var/turf/open/space/turfs = list()
				for(var/turf/T in get_area_turfs(linked_ship))
					if(istype(T, /turf/open/space))
						turfs += T
				var/turf/theturf = pick(turfs)
				mover.forceMove(theturf) //Force them into a random turf
				if(istype(mover, /obj/structure/photon_torpedo))
					var/obj/structure/photon_torpedo/P = mover
					if(P.armed)
						sleep(10)
						P.force_explode()
	else
		return ..()

/obj/structure/overmap/ship/starfleet
	name = "USS Cadaver"
	icon_state = "cadaver"
//obj/structure/fluff/ship/helm do me later

/obj/structure/overmap/proc/click_action(atom/target,mob/user)
//add in TORPEDO MODE and PHASER MODE TO A MODE SELECT UI THING
	if(src != target)
		target_ship = target
		target_ship.agressor = src
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

/obj/structure/overmap/proc/fire_torpedo(obj/structure/overmap/OM)
	var/list/thelist = list(OM.transporters,OM.weapons,OM.generator,OM.initial_loc)
	var/fuck = pick(thelist)
	var/turf/theturf = get_turf(fuck)
	weapons.fire_torpedo(theturf, pilot)
	SEND_SOUND(pilot, sound('StarTrek13/sound/borg/machines/torpedo1.ogg'))

#undef TORPEDO_MODE
#undef PHASER_MODE
