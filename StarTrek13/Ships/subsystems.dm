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
	var/power_supplied = 0 //How much power is available right now? until we connect these to the powernet, it'll just be done by snowflake EPS conduits.
	var/temperature = 0 //How hot has it got? if this heat goes above 100, expect performance decreases
	var/name = "subsystem"

/datum/shipsystem/New()
	. = ..()
	start()

/datum/shipsystem/proc/start()
	START_PROCESSING(SSobj, src)
	failed = 0

/datum/shipsystem/proc/lose_heat(amount)
	if(temperature) //  < 0
		temperature -= amount

/datum/shipsystem/process()//Here's where the magic happens.
	var/health = calculate_percentages()
	if(temperature)
		integrity -= temperature
	if(health <= 30) //30% health means you're pretty beat up, take it down for repairs.
		failed = 1
		fail()
		//So stop processing
	if(overclock > 0) //Drain power.
		power_draw += overclock //again, need power stats to fiddle with.

/datum/shipsystem/proc/fail()
	STOP_PROCESSING(SSobj, src)
	for(var/obj/structure/shipsystem_console/T in linked_objects)
		T.fail()

/datum/shipsystem/proc/take_damage(amount)
	integrity -= amount

/datum/shipsystem/proc/calculate_percentages()
	var/thenumber = round(100* integrity / max_integrity) //aka, percentage for ease of reading
	return thenumber

/datum/shipsystem/proc/repair_damage(amount)
	integrity += amount
	if(integrity >= max_integrity)
		integrity = max_integrity


/datum/shipsystem/weapons
	power_draw = 0//just so it's not an empty type TBH. We can tweak this later when we get power in.
	name = "weapons"
	var/damage = 1
	var/fire_cost = 1
	var/max_charge = 1
	var/chargeRate = 1
	var/delay = 0
	var/max_delay = 2 //2 ticks to fire again, this is ontop of phaser charge times
	var/charge = 0

//	theship.damage = 0	//R/HMMM
//	theship.phaser_fire_cost = 0
///	theship.max_charge = 0
//	theship.phaser_charge_rate = 0

/datum/shipsystem/weapons/proc/update_weapons()
	damage = initial(damage)
	fire_cost = initial(fire_cost)
	max_charge = initial(max_charge)
	chargeRate = initial(chargeRate)
	var/counter = 0
	var/temp = 0
	for(var/obj/machinery/power/ship/phaser/P in controller.theship.weapons.weapons)
		chargeRate += P.charge_rate
		damage += P.damage
		fire_cost += P.fire_cost
		counter ++
		temp = P.charge
	max_charge += counter*temp //To avoid it dropping to 0 on update, so then the charge spikes to maximum due to process()

/datum/shipsystem/weapons/process()
	. = ..()
	if(delay > 0)
		delay --
	if(charge < max_charge)
		charge = max_charge

/datum/shipsystem/weapons/proc/attempt_fire()
	if(delay <= 0 && charge >= fire_cost)
		delay = max_delay //-1 per tick
		return 1
	else
		return 0


/datum/shipsystem/sensors
	power_draw = 0//just so it's not an empty type TBH.
	name = "sensors"

/datum/shipsystem/engines
	power_draw = 0//just so it's not an empty type TBH.
	name = "engines"

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

/obj/structure/subsystem_component
	name = "EPS Conduit"
	desc = "this supplies power to a subsystem."
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "conduit"
	anchored = 1
	density = 0
	can_be_unanchored = 0


/obj/structure/fluff/helm/desk
	name = "desk computer"
	desc = "A generic deskbuilt computer"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "desk"
	anchored = TRUE
	density = 1 //SKREE
	opacity = 0
	layer = 4.5

/obj/structure/fluff/helm/desk/functional
	name = "shield station"
	var/obj/structure/overmap/ship/our_ship
	var/datum/shipsystem/shields/subsystem
	var/mob/living/carbon/human/crewman


/obj/structure/fluff/helm/desk/functional/New()
	. = ..()
	for(var/datum/shipsystem/shields/S in our_ship.SC.systems)
		subsystem = S

/obj/structure/fluff/helm/desk/functional/attack_hand(mob/living/user)
	to_chat(user, "You are now manning [src], with your expertise you'll provide a boost to the [subsystem] subsystem. You need to remain still whilst doing this.")
	crewman = user
	START_PROCESSING(SSobj, src)

/obj/structure/fluff/helm/desk/functional/process() //A good mini boost to a subsystem which will help keep your ship alive just a liiil longer.
	subsystem.integrity += 5
	subsystem.heat -= 5
	if(!crewman in view(src,1))
		to_chat(crewman, "You are too far away from [src], and have stopped managing the [subsystem] subsystem.")
		crewman = null
		STOP_PROCESSING(SSobj, src)