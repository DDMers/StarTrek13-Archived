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
	hull_integrity = new
	hull_integrity.controller = src
	systems += hull_integrity

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
	var/integrity = 20000 //Will be a percentage, if this drops too low the shipsystem will fail, affecting the ship. EG sensors going down means goodbye sight for the pilot of the ship.
	var/max_integrity = 20000 //maximum susbsytem health, so that I can do percentage calculations.
	var/power_draw = 0 //Not used yet
	var/overclock = 0 //Overclock a shipsystem to get better performance, at a higher power draw. Numbers pending warp core and power code
	var/efficiency = 40 //as a percent, we take our desired effect, such as weapons power, and divide it by this, so a 600 damage rated phaser would be 600*40%, so 40% of 600, in other words; 240 damage. You'll want to be overclocking tbh.
	var/failed = FALSE //If failed, do not process, cut the shipsystem and other such scary things.
	var/list/linked_objects()
	var/integrity_sensitive = TRUE
	var/datum/shipsystem_controller/controller
	var/power_supplied = 0 //How much power is available right now? until we connect these to the powernet, it'll just be done by snowflake EPS conduits.
 //How hot has it got? if this heat goes above 100, expect performance decreases
	var/name = "subsystem"
	var/heat = 0
	var/icon = 'StarTrek13/icons/trek/subsystem_icons.dmi'
	var/icon_state
	var/power_modifier = 1 //How much of the allocated power do we have?
	var/heat_loss_bonus = 0
	var/voiceline
	var/power = 0 //Power available thru relays. 		Power is arbitrary, every relay gives 1 power.
	var/power_required = 1 //how much we need to run
	var/power_use = 0.8 //how much power we use
	var/stored_power = 0
	var/max_power = 1000 //To stop infinite charging
	var/list/relays = list() //how much of a boost we'll get depends on the active relays in this

/datum/shipsystem/New()
	. = ..()
	start()

/datum/shipsystem/proc/start()
	START_PROCESSING(SSobj, src)
	failed = 0

/datum/shipsystem/proc/lose_heat(amount)
	if(heat) //  < 0
		heat -= amount

/datum/shipsystem/proc/check_power()
	if(stored_power < max_power)
		stored_power += power //Add on the power we get from the relays
	if(stored_power > 10)
		stored_power -= power_use
		if(stored_power < power_required)
			fail(TRUE)
		else
			if(integrity > 5000)
				failed = FALSE
	else
		fail(TRUE)

/datum/shipsystem/proc/check_power_bonus()
	var/thebonus = 1
	for(var/T in relays)
		if(istype(T, /obj/structure/ship_component/subsystem_relay))
			var/obj/structure/ship_component/subsystem_relay/P = T
			if(P.powered)
				thebonus += P.power_rating
	return thebonus

/datum/shipsystem/process()//Here's where the magic happens.
	check_power()
	if(integrity > max_integrity)
		integrity = max_integrity
	if(heat < 0)
		heat = 0
	if(integrity < 0)
		integrity = 0
	if(!failed)
		if(integrity <= 5000) //Subsystems will autofail when they're this fucked
			fail()
			//So stop processing
		if(overclock > 0) //Drain power.
			power_draw += overclock //again, need power stats to fiddle with.
	else
		if(integrity > 5000) //reactivate
			failed = FALSE

/datum/shipsystem/proc/fail(var/silent = FALSE)
	if(!failed) //captain they've disabled our warp engines (x55)
		if(voiceline)
			if(controller.theship.weapons && !silent)
				controller.theship.weapons.voiceline(voiceline)
	failed = TRUE
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
	var/maths_damage = 0 //After math is applied, how much damage? in relation to how much charge they have etc.
	var/nextfire = 0
	var/fire_delay = 2 //2 seconds to fully recharge the  phasers, to prevent spam
	var/times_fired = 0 //times fired without letting them fully charge
	icon_state = "weapons"
	voiceline = "phasers"
	var/list/phasers = list()

/datum/shipsystem/weapons/New()
	. = ..()
	if(controller)
		getphasers()

/datum/shipsystem/weapons/proc/getphasers()
	phasers = list()
	for(var/PS in controller.theship.linked_ship)
		if(istype(PS, /obj/machinery/ship/phaser))
			var/obj/machinery/ship/phaser/P = PS
			if(P)
				phasers += P


//	theship.damage = 0	//R/HMMM
//	theship.phaser_fire_cost = 0
///	theship.max_charge = 0
//	theship.phaser_charge_rate = 0

/datum/shipsystem/weapons/proc/update_weapons()
	if(!phasers.len)
		getphasers()
	if(istype(controller.theship, /obj/structure/overmap/ship/AI))
		var/obj/structure/overmap/ship/AI/theship2 = controller.theship
		damage = theship2.dam
		fire_cost = theship2.firecost
		max_charge = theship2.maxcharge
		chargeRate = theship2.chargerate
		return
	damage = initial(damage)
	fire_cost = initial(fire_cost)
	max_charge = initial(max_charge)
	chargeRate = initial(chargeRate)
	chargeRate += chargeRate*check_power_bonus()
	var/counter = 0
	var/temp = 0
	for(var/obj/machinery/ship/phaser/PS in phasers)
		var/obj/machinery/ship/phaser/P = PS
		chargeRate += P.charge_rate
		damage += P.damage
		fire_cost += P.fire_cost
		counter ++
		temp = P.charge
	max_charge += counter*temp //To avoid it dropping to 0 on update, so then the charge spikes to maximum due to process()
	chargeRate = chargeRate*power_modifier
	return damage

/datum/shipsystem/weapons/process()
	check_power()
	charge += chargeRate
	if(charge < 0)
		charge = 0
	heat -= 30
	if(integrity > max_integrity)
		integrity = max_integrity
	if(heat < 0)
		heat = 0
	if(charge > max_charge)
		charge = max_charge
	if(heat)
		integrity -= heat
	if(integrity <= 2000) //Subsystems will autofail when they're this fucked
		fail()
	. = ..()

/datum/shipsystem/weapons/proc/gimp_damage()
	return (max_charge-charge)/5

/datum/shipsystem/weapons/proc/attempt_fire(var/firemode)
	if(failed || integrity <= 0)
		if(controller)
			if(controller.theship)
				if(controller.theship.pilot)
					to_chat(controller.theship.pilot, "<span class='userdanger'>CRITICAL SYSTEM FAILURE: The [name] subsystem has failed.</span>")
					return FALSE
	if(!failed)
		if(istype(controller.theship, /obj/structure/overmap/ship/AI))
			if(charge >= fire_cost)
				return TRUE
		if(controller.theship.fire_mode == 1)
			if(charge >= fire_cost || charge > 0)
				if(damage > 0)
					charge -= fire_cost
					return TRUE
				else
					return FALSE
		else
			return TRUE //We already check photon numbers in the actual ship procs, this is to check if we can fire.


/datum/shipsystem/sensors
	power_draw = 0//just so it's not an empty type TBH.
	name = "sensors"
	icon_state = "sensors"

/datum/shipsystem/engines
	power_draw = 0//just so it's not an empty type TBH.
	name = "engines"
	icon_state = "engines"
	var/charge = 0
	var/max_charge = 7000 //This should NickVr proof warping rather nicely :)
	var/chargeRate = 400 //Warp coils drain all the powernet power, this is to prevent infinite spams, and infinite cloaks.
	voiceline = "warpengines"

/datum/shipsystem/engines/proc/try_warp() //You can't warp if your engines are down
	controller.theship.can_move = initial(controller.theship.can_move)
	if(!controller.theship.can_move)
		fail()
		integrity = 0
		return
	if(!failed)
		if(charge >= 3000)
			charge -= 3000
			return 1

/datum/shipsystem/engines/process()
	check_power()
	if(charge < max_charge)
		charge += chargeRate*check_power_bonus()
	if(integrity > max_integrity)
		integrity = max_integrity
	if(heat < 0)
		heat = 0
	if(heat)
		integrity -= heat
	if(integrity <= 4000) //This equates to the engine being visibly shot off
		controller.theship.max_speed = initial(controller.theship.max_speed)*0.4
		if(integrity <= 0 || failed)
			controller.theship.max_speed = 0
			fail()
			controller.theship.can_move = FALSE
			return
	else
		if(controller.theship)
			controller.theship.max_speed = initial(controller.theship.max_speed)
	if(overclock > 0) //Drain power.
		power_draw += overclock //again, need power stats to fiddle with.
	if(controller.theship)
		controller.theship.can_move = TRUE
	. = ..()

/datum/shipsystem/integrity
	name = "hull plates"
	icon_state = "hull"
	max_integrity = 20000
	integrity = 20000

/datum/shipsystem/integrity/process()
	. = ..()
	heat -= 10

/datum/shipsystem/shields
	name = "shields" //in this case, integrity is shield health. If your shields are smashed to bits, it's assumed that all the control circuits are pretty fried anyways.
	var/breakingpoint = 700 //at 700 heat, shields will take double damage
	var/heat_resistance = 50 // how much we resist gaining heat
	power_draw = 0//just so it's not an empty type TBH.
	var/list/obj/machinery/space_battle/shield_generator/linked_generators = list()
	var/regen_bonus = 10 //Bonus health gained per tick for having shield systems in-tact.
	var/active = FALSE
	var/obj/structure/ship_component/capbooster/boosters = list()
	icon_state = "shields"
	var/chargeRate = 200 // per tick
	var/health = 25000 //Shields start off drained
	var/max_health = 40000 //This will become shield health, integrity is subsystem integrity ||  Buffed from 30K due to request. This will make ships a lot more robust, at 10 shield hits at sovereign damage, ignoring heat.
	integrity = 20000
	max_integrity = 20000
	var/max_integrity_bonus = 0 //From capboosters
	var/toggled = FALSE //Shieldgencode, Ship.dm
	voiceline = "shieldsinteg"

/datum/shipsystem/shields/fail() //Failed as in subsystem has failed, can no longer generate shields
	. = ..()
	for(var/obj/machinery/space_battle/shield_generator/S in linked_generators)
		for(var/obj/effect/adv_shield/S2 in S.shields)
			S2.deactivate()
			S2.active = FALSE
	health = 0

/datum/shipsystem/shields/process()
	check_power()
	if(controller)
		if(controller.theship)
			if(controller.theship.generator)
				chargeRate = controller.theship.generator.chargerate*check_power_bonus()
			if(controller.theship.generator)
				if(!controller.theship.generator.powered())
					health = 0
	if(!failed && toggled)
		health += chargeRate*power_modifier
		heat -= 10
	if(heat)
		health -= heat
	if(heat < 0)
		heat = 0
	if(integrity < 0)
		integrity = 0
	heat -= 10
	max_integrity = initial(max_integrity)
	if(integrity <= 3000)
		fail()
	if(health > max_health)
		health = max_health
	if(integrity > max_integrity)
		integrity = max_integrity


//round(100 * value / max_value PERCENTAGE CALCULATIONS, quick maths.
//U3VwZXIgaXMgYmFk

/obj/structure/subsystem_component
	name = "EPS Conduit"
	desc = "this supplies power to a subsystem."
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "conduit"
	anchored = TRUE
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
	icon_state = "shields"

/obj/structure/fluff/helm/desk/functional/romulan
	icon_state = "rom-shields"

/obj/structure/fluff/helm/desk/functional/alt
	icon_state = "shields_alt"
	density = 0
	layer = 4.6

/obj/structure/fluff/helm/desk/functional/nt
	icon_state = "computer"

/obj/structure/fluff/helm/desk/functional/weapons
	name = "weapons station"
	icon_state = "weapons"
	/datum/shipsystem/weapons/subsystem

/obj/structure/fluff/helm/desk/functional/weapons/nt
	icon_state = "computer"

/obj/structure/fluff/helm/desk/functional/New()
	. = ..()

/obj/structure/fluff/helm/desk/functional/proc/get_ship()
	subsystem = our_ship.SC.shields

/obj/structure/fluff/helm/desk/functional/weapons/get_ship()
	subsystem = our_ship.SC.weapons

/obj/structure/fluff/helm/desk/functional/attack_hand(mob/living/user)
	to_chat(user, "You are now manning [src], with your expertise you'll provide a boost to the [subsystem] subsystem. You need to remain still whilst doing this.")
	if(crewman)
		crewman = null
	crewman = user
	START_PROCESSING(SSobj, src)

/obj/structure/fluff/helm/desk/functional/process() //A good mini boost to a subsystem which will help keep your ship alive just a liiil longer.
	if(crewman in orange(1, src))
		subsystem.integrity += 30 //numbers pending balance
		subsystem.heat -= 30
		subsystem.heat_resistance = 4
		return
	else
		to_chat(crewman, "You are too far away from [src], and have stopped managing the [subsystem] subsystem.")
		crewman = null
		subsystem.heat_resistance = initial(subsystem.heat_resistance)
		STOP_PROCESSING(SSobj, src)


/obj/structure/subsystem_monitor
	name = "LCARS display"
	desc = "It is some kind of monitor which allows you to look at the health of the ship."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "lcars"
	var/datum/shipsystem/shields/subsystem //change me as you need. This one's for testing
	var/obj/structure/overmap/ship/our_ship
	anchored = TRUE

/obj/structure/subsystem_monitor/proc/get_ship()
	subsystem = our_ship.SC.shields

/obj/structure/subsystem_monitor/examine(mob/user)
	. = ..()
	if(!subsystem || !our_ship)
		var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
		our_ship = W.theship
		get_ship()
	to_chat(user, "Status of: [subsystem.name] subsystem: Integrity: [subsystem.integrity] Heat: [subsystem.heat] Current overclock factor: [subsystem.overclock]")

/obj/structure/subsystem_monitor/weapons
	icon_state = "lcars2"
	name = "tactical display"
	/datum/shipsystem/weapons/subsystem

/obj/structure/subsystem_monitor/weapons/get_ship()
	subsystem = our_ship.SC.weapons


/obj/structure/overmap/proc/get_damageable_components()
	for(var/obj/structure/ship_component/L in linked_ship)
		components += L
		L.our_ship = src

//Sparks, smoke, fire, breaches, roof falls on heads


/obj/structure/ship_component		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "coolant manifold"
	desc = "a large manifold carrying supercooled coolant gas to the ship's subsystems, you should take care to maintain it to avoid malfunctions!"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "coolant"
	var/damage_message = "ruptures!"
	var/health = 100
	var/obj/structure/overmap/our_ship
	var/datum/shipsystem/chosen
	var/active = FALSE
	var/benefit_amount = 300 //How much will you gain in health/lose in heat with this component active?
	anchored = TRUE
	var/can_be_reactivated = TRUE

/obj/structure/ship_component/New()
	. = ..()
	START_PROCESSING(SSobj,src)

/obj/structure/ship_component/examine(mob/user)
	if(active)
		. = ..()
		to_chat(user, "it is active, and cooling the [chosen.name] subsystem by [benefit_amount] per second.")
		return
	else
		return ..()

/obj/structure/ship_component/ex_act(severity)
	health -= severity*10

/obj/structure/ship_component/process()
	if(!chosen || !our_ship)
		var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
		our_ship = W.theship
	var/area/A = get_area(src)
	if(A.requires_power) //BE SURE TO CHANGE THIS WHEN WE ADD SHIP POWER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		active = FALSE
	if(active)
		health -= 2 //Make sure to keep it in good repair
		check_health()
		apply_subsystem_bonus()
		if(health > initial(health))
			health = initial(health)
	else
		if(health >= 20)
			can_be_reactivated = TRUE

/obj/structure/ship_component/take_damage(amount)
	health -= amount
	visible_message("[src] is hit!")
	check_health()

/obj/structure/ship_component/proc/check_health()
	if(health >= 100)
		icon_state = initial(icon_state)
		return
	else
		active = FALSE
		can_be_reactivated = FALSE
		fail()

/obj/structure/ship_component/proc/fail()
	playsound(loc, 'sound/effects/bamf.ogg', 50, 2)
	visible_message("[src] [damage_message]")
	var/datum/effect_system/smoke_spread/freezing/smoke = new
	smoke.set_up(10, loc)
	smoke.start()
	playsound(loc, 'StarTrek13/sound/borg/machines/alert1.ogg', 50, 2)
	active = FALSE
	can_be_reactivated = FALSE


/obj/structure/ship_component/proc/apply_subsystem_bonus() //Each component will have a benefit to subsystems when activated, coolant manifolds will regenerate some subsystem health as long as they are alive and active.
	if(active)
		chosen.heat_loss_bonus = 20
		return 1
	else
		return 0

/obj/structure/ship_component/attack_hand(mob/living/H)
	var/area/A = get_area(src)
	if(A.requires_power)//BE SURE TO CHANGE THIS WHEN WE ADD SHIP POWER!!!!!!!!!!!!!!!!!!!!!!
		src.say("The ship is unpowered!")
		active = FALSE
	if(can_be_reactivated)
		if(!active)
			to_chat(H, "You activate [src]!")
			active = TRUE
		else
			to_chat(H, "You de-activate [src]!")
			active = FALSE
	else
		to_chat(H, "[src] is too badly damaged! repair it first!")

/*
/obj/structure/ship_component/attackby(obj/item/I,mob/living/user)
	if(istype(I, /obj/item/wrench))
		to_chat(user, "You're repairing [src] with [I]")
		if(do_after(user, 5, target = src))
			to_chat(user, "You patch up some of the dents in [src]!")
			health += 10
*/

/obj/structure/ship_component/capbooster
	anchored = TRUE
	name = "capacitor booster"
	icon_state = "capbooster"
	desc = "This component will increase the effective strength of your shields when active, at the expense of an increased heat output."

/obj/structure/ship_component/capbooster/examine(mob/user)
	. = ..()
	if(!chosen)
		var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
		our_ship = W.theship
	if(active)
		to_chat(user, "It is active")
	else
		to_chat(user, "It is not active")



// var/thenumber1 = rand(20,40)
// var/thenumber2 = rand(20,50)
// var/theanswer = number1 + number2
// to_chat(user, "Enemy ship unsigned vector X : Mark unsigned vector Y. Phase drift modulation: X + Y = [theanswer].


//Add subsystem relays! where you have to shove subsystem power through. These get damaged during battle, if one relay fails mid combat, engi can reroute power.