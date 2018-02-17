/obj/structure/shipsystem_console
	name = "a shipsystem console"
	desc = "A console that sits over a chair, how are you seeing this?."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	anchored = TRUE
	density = 1
	opacity = 0
	layer = 4.5
	var/datum/subsytem/system //shipsystems are a datum, will also attach onto ships, one console controls one shipsystem.
	var/list/linked_objects = list()
	var/object_type = /obj/item //redundant, waiting on super here

/obj/structure/shipsystem_console/proc/fail()
	for(var/atom/movable/T in linked_objects)
		if(istype(T, object_type))
			qdel(T)

/datum/shipsystem_controller
	var/current_subsytems = 0 //How many shipsystems are attached to the controller?
	var/fail_rate = 0 //this will be a %age
	var/obj/structure/overmap/theship
	var/datum/shipsystem/shields/shields
	var/datum/shipsystem/weapons/weapons
	var/datum/shipsystem/integrity/hull_integrity
	var/datum/shipsystem/sensors/sensors
	var/datum/shipsystem/engines/engines
	var/list/systems = list()

/datum/shipsystem_controller/proc/generate_shipsystems()
	shields = new()
	shields.controller = src
	weapons = new()
	weapons.controller = src
	sensors = new()
	sensors.controller = src
	engines = new()
	engines.controller = src
	systems += shields
	systems += weapons
	systems += sensors
	systems += engines

/datum/shipsystem_controller/proc/take_damage(amount) ///if the shipsystem controller takes damage, that means the enemy ship didn't pick a system to disable. So pick one at random, there is a chance that the hull will glance off the hit.
	var/list/thesystems() = systems
	var/datum/shipsystem/thetarget = pick(thesystems)//Don't want to damage the hull twice!
	thetarget.take_damage(amount)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Alrighty, so our shipsystem controller will hold all the shipsystems, you'll be able to monitor it through the shipsystem monitors, where you can overclock and such, play with the power draw and all that goodness.	//
//  Then it's just a case of adding the shipsystem controller to the overmap ship, it'll handle the rest																													//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Begin shipsystems!//

/datum/shipsystem
	var/integrity = 10000 //Will be a percentage, if this drops too low the shipsystem will fail, affecting the ship. EG sensors going down means goodbye sight for the pilot of the ship.
	var/max_integrity = 10000 //maximum susbsytem health, so that I can do percentage calculations.
	var/power_draw = 0 //Not used yet
	var/overclock = 0 //Overclock a shipsystem to get better performance, at a higher power draw. Numbers pending warp core and power code
	var/efficiency = 40 //as a percent, we take our desired effect, such as weapons power, and divide it by this, so a 600 damage rated phaser would be 600*40%, so 40% of 600, in other words; 240 damage. You'll want to be overclocking tbh.
	var/failed = FALSE //If failed, do not process, cut the shipsystem and other such scary things.
	var/list/linked_objects()
	var/integrity_sensitive = TRUE
	var/datum/shipsystem_controller/controller

/datum/shipsystem/New()
	. = ..()
	start()

/datum/shipsystem/proc/start()
	START_PROCESSING(SSobj, src)
	failed = 0

/datum/shipsystem/process()//Here's where the magic happens.
	if(integrity <= 30) //30% means you're pretty shat up, take it down for repairs.
		failed = 1
		fail()
		//So stop processing
	if(overclock > 0) //Drain power.
		power_draw += 0*overclock //again, need power stats to fiddle with.

/datum/shipsystem/proc/fail()
	STOP_PROCESSING(SSobj, src)
	for(var/obj/structure/shipsystem_console/T in linked_objects)
		T.fail()

/datum/shipsystem/proc/take_damage(amount)
	to_chat(world, "shipsystem just took damage! TEST")
	integrity -= amount
	var/thenumber = calculate_percentages()
	to_chat(world, "is now at [thenumber]% integrity TEST")

/datum/shipsystem/proc/calculate_percentages()
	var/thenumber = round(100* integrity / max_integrity) //aka, percentage for ease of reading
	return thenumber

/datum/shipsystem/proc/repair_damage(amount)
	to_chat(world,  "has just been repaired by [amount] damage! TEST")
	var/thenumber = calculate_percentages()
	to_chat(world, "is now at [thenumber]% integrity TEST")

/datum/shipsystem/weapons
	power_draw = 0//just so it's not an empty type TBH. We can tweak this later when we get power in.

/datum/shipsystem/sensors
	power_draw = 0//just so it's not an empty type TBH.

/datum/shipsystem/engines
	power_draw = 0//just so it's not an empty type TBH.

/datum/shipsystem/shields
	integrity = 40 // start off
	max_integrity = 20000
	var/heat = 0
	var/breakingpoint = 50 //at 50 heat, shields will take double damage
	var/heat_resistance = 0.5 // how much we resist gaining heat
	power_draw = 0//just so it's not an empty type TBH.
	var/list/obj/machinery/space_battle/shield_generator/linked_generators = list()

/datum/shipsystem/shields/fail()
	..()
	for(var/obj/machinery/space_battle/shield_generator/S in linked_generators)
		for(var/obj/effect/adv_shield/S2 in S.shields)
			S2.deactivate()
			S2.active = FALSE
		S.ship.shields_active = FALSE
	failed = TRUE

//round(100 * value / max_value PERCENTAGE CALCULATIONS, quick maths.
//U3VwZXIgaXMgYmFk