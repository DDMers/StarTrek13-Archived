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
	var/integrity = 30000 //Will be a percentage, if this drops too low the shipsystem will fail, affecting the ship. EG sensors going down means goodbye sight for the pilot of the ship.
	var/max_integrity = 30000 //maximum susbsytem health, so that I can do percentage calculations.
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

/datum/shipsystem/New()
	. = ..()
	start()

/datum/shipsystem/proc/start()
	START_PROCESSING(SSobj, src)
	failed = 0

/datum/shipsystem/proc/lose_heat(amount)
	if(heat) //  < 0
		heat -= amount

/datum/shipsystem/process()//Here's where the magic happens.
	if(integrity > max_integrity)
		integrity = max_integrity
	if(heat < 0)
		heat = 0
	if(integrity < 0)
		integrity = 0
	if(!failed)
		if(heat)
			integrity -= heat
		if(integrity <= 5000) //Subsystems will autofail when they're this fucked
			failed = TRUE
			fail()
			//So stop processing
		if(overclock > 0) //Drain power.
			power_draw += overclock //again, need power stats to fiddle with.
	else
		if(integrity > 5000) //reactivate
			failed = FALSE

/datum/shipsystem/proc/fail()
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


//	theship.damage = 0	//R/HMMM
//	theship.phaser_fire_cost = 0
///	theship.max_charge = 0
//	theship.phaser_charge_rate = 0

/datum/shipsystem/weapons/proc/update_weapons()
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
	var/counter = 0
	var/temp = 0
	if(istype(controller.theship, /obj/structure/overmap/ship/fighter))
		chargeRate = 100
		fire_cost = 150
		return TRUE
	for(var/PS in controller.theship.linked_ship)
		if(istype(PS, /obj/machinery/ship/phaser))
			var/obj/machinery/ship/phaser/P = PS
			chargeRate += P.charge_rate
			damage += P.damage
			fire_cost += P.fire_cost
			counter ++
			temp = P.charge
	maths_damage = damage
	maths_damage -= round(max_charge - charge)/2 //Damage drops off heavily if you don't let them charge
	damage = maths_damage
	max_charge += counter*temp //To avoid it dropping to 0 on update, so then the charge spikes to maximum due to process()
	if(damage > 0)
		damage = damage+(200*power_modifier)
	chargeRate = chargeRate*power_modifier

/datum/shipsystem/weapons/process()
	. = ..()
	if(charge < 0)
		charge = 0
	charge += chargeRate
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
		failed = 1
		fail()
		//So stop processing
	if(overclock > 0) //Drain power.
		power_draw += overclock //again, need power stats to fiddle with.

/datum/shipsystem/weapons/proc/attempt_fire(var/firemode)
	if(!failed)
		if(istype(controller.theship, /obj/structure/overmap/ship/AI))
			if(charge >= fire_cost)
				return 1
		if(controller.theship.fire_mode == 1)
			if(charge >= fire_cost || charge > 0)
				if(world.time < nextfire) //Spam blocker! spam your phasers and expect shit damage.
					var/quickmafs = world.time - nextfire
					times_fired ++
					maths_damage = damage
					maths_damage -= round(max_charge - charge)/1.5 //Damage drops off heavily if you don't let them charge
					charge -= fire_cost
					heat += (fire_cost/30) //And a bit more heat for being spammy
					maths_damage -= quickmafs * 1000 //Phasers take 2 seconds to become fully effective again, if you spam them that's fine but the damage will get fucking MERC'D //Eg, 2 seconds * 200 -> -400 damage
					damage = maths_damage
					return 1
				else
					nextfire = world.time + fire_delay
					maths_damage = damage
					maths_damage -= round(max_charge - charge)/1.5 //Damage drops off heavily if you don't let them charge
					damage = maths_damage
					charge -= fire_cost
					heat += (fire_cost/30)
					return 1
		else
			return 1 //We already check photon numbers in the actual ship procs, this is to check if we can fire.
	else
		to_chat(controller.theship.pilot, "<span class='userdanger'>CRITICAL SYSTEM FAILURE: The [name] subsystem has failed.</span>")
		return 0


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
	var/chargeRate = 100 //Warp coils drain all the powernet power, this is to prevent infinite spams, and infinite cloaks.


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
	. = ..()
	if(charge < max_charge)
		charge += chargeRate
	if(integrity > max_integrity)
		integrity = max_integrity
	if(heat < 0)
		heat = 0
	if(heat)
		integrity -= heat
	if(integrity <= 4000) //This equates to the engine being visibly shot off
		controller.theship.max_speed = initial(controller.theship.max_speed)*0.4
		return
		if(integrity <= 0)
			failed = 1
			controller.theship.max_speed = 0
			fail()
			controller.theship.can_move = FALSE
	else
		if(controller.theship)
			controller.theship.max_speed = initial(controller.theship.max_speed)
	if(overclock > 0) //Drain power.
		power_draw += overclock //again, need power stats to fiddle with.
	if(controller.theship)
		controller.theship.can_move = TRUE

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
	var/breakingpoint = 500 //at 500 heat, shields will take double damage
	var/heat_resistance = 50 // how much we resist gaining heat
	power_draw = 0//just so it's not an empty type TBH.
	var/list/obj/machinery/space_battle/shield_generator/linked_generators = list()
	var/regen_bonus = 10 //Bonus health gained per tick for having shield systems in-tact.
	var/active = FALSE
	var/obj/structure/ship_component/capbooster/boosters = list()
	icon_state = "shields"
	var/chargeRate = 500 // per tick
	var/health = 30000
	var/max_health = 30000 //This will become shield health, integrity is subsystem integrity
	integrity = 20000
	max_integrity = 20000
	var/max_integrity_bonus = 0 //From capboosters
	var/toggled = FALSE //Shieldgencode, Ship.dm

/datum/shipsystem/shields/fail() //Failed as in subsystem has failed, can no longer generate shields
	..()
	for(var/obj/machinery/space_battle/shield_generator/S in linked_generators)
		for(var/obj/effect/adv_shield/S2 in S.shields)
			S2.deactivate()
			S2.active = FALSE
//	controller.theship.shields_active = FALSE
	health = 0
	failed = TRUE

/datum/shipsystem/shields/process()
	if(controller)
		if(controller.theship)
			if(controller.theship.generator)
				chargeRate = controller.theship.generator.chargerate
			if(controller.theship.generator)
				if(!controller.theship.generator.powered())
					health = 0
	if(!failed && toggled)
		health += chargeRate*power_modifier
		heat -= heat_loss_bonus
	if(heat < 0)
		heat = 0
	if(integrity < 0)
		integrity = 0
	health -= heat
	integrity -= heat
	heat -= 5
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
		L.chosen = SC.shields

//Sparks, smoke, fire, breaches, roof falls on heads


/obj/structure/ship_component		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "coolant manifold"
	desc = "a large manifold carrying supercooled coolant gas to the ship's subsystems, you should take care to maintain it to avoid malfunctions!"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "coolant"
	var/damage_message = "ruptures!"
	var/health = 100
	var/obj/structure/overmap/our_ship
	var/datum/shipsystem/shields/chosen
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
	else if(health <100 && health >20)
		icon_state = "[initial(icon_state)]-damaged"
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


/obj/structure/ship_component/attackby(obj/item/I,mob/living/user)
	if(istype(I, /obj/item/wrench))
		to_chat(user, "You're repairing [src] with [I]")
		if(do_after(user, 5, target = src))
			to_chat(user, "You patch up some of the dents in [src]!")
			health += 10


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


/obj/structure/subsystem_panel		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "ODN Relay (Shields)"
	anchored = TRUE
	desc = "A breaker box housing an ODN relay which bridges the ship's power-grid to the shields subsystem"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel"
	var/obj/structure/overmap/our_ship
	var/datum/shipsystem/chosen
	var/open = FALSE
	var/obj/effect/panel_overlay/cover = new
	var/powered = TRUE //Used for repairs, replace me with bitflags asap.

/obj/structure/subsystem_panel/proc/check_ship()
	var/area/a = get_area(src) //If you're making a new subsystem panel, copy this and change vvvvv
	for(var/obj/structure/fluff/helm/desk/tactical/T in a)
		var/obj/structure/overmap/S = T.theship
		if(T.theship)
			chosen = S.SC.shields //This line


/obj/structure/subsystem_panel/weapons		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "ODN Relay (Weapons)"
	desc = "A breaker box housing an ODN relay which bridges the ship's power-grid to the weapons subsystem"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel"

/obj/structure/subsystem_panel/weapons/check_ship()
	var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
	if(W.theship && W.theship.SC && W.theship.SC.weapons)
		chosen = W.theship.SC.weapons

/obj/structure/subsystem_panel/engines		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "ODN Relay (engines)"
	desc = "A breaker box housing an ODN relay which bridges the ship's power-grid to the engines subsystem"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel"

/obj/structure/subsystem_panel/engines/check_ship()
	var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
	if(W.theship && W.theship.SC && W.theship.SC.engines)
		chosen = W.theship.SC.engines

/*
	var/state = 1
	var/state_open = 2
	var/state_closed = 4
	var/state_wrenched = 6
	var/state_crowbar = 8
	var/state_screwdriver = 10
	var/state_rewire = 12
*/

/obj/structure/subsystem_panel/New()
	. = ..()
	check_ship()
	START_PROCESSING(SSobj,src)

/obj/structure/subsystem_panel/process()
	if(!chosen)
		check_ship()
	check_overlays()

/obj/structure/subsystem_panel/attack_hand(mob/user)
	if(!chosen)
		check_ship()
	switch(open)
		if(TRUE)
			cut_overlays()
			to_chat(user, "You close [src]'s lid")
			cover.icon_state = "[icon_state]-cover"
			open = FALSE
			add_overlay(cover)
		if(FALSE)
			cut_overlays()
			to_chat(user, "You open [src]'s lid")
			cover.icon_state = "[icon_state]-cover-open"
			open = TRUE
			add_overlay(cover)
	check_overlays()

/obj/structure/subsystem_panel/attackby(obj/item/I, mob/user)
	if(chosen)
		if(open)
			if(istype(I, /obj/item/wirecutters) && powered)
				to_chat(user, "You are deactivating the [chosen] subsystem for repair, this will avoid shocks but the ship's [chosen] will be down until you're done.")
				if(do_after(user, 500, target = src))
					to_chat(user, "You've depowered the [chosen] subsystem, use a wrench to begin repairs")
					powered = FALSE
					chosen.failed = TRUE
					STOP_PROCESSING(SSobj, chosen)
			if(istype(I, /obj/item/wrench) && powered)
				to_chat(user, "I can't afford to depower the [chosen] subsystem, i'll have to take the risk, you begin prodding at live electrical wires and plasma tubes in a desperate attempt to repower the [chosen] subsystem") //You can chance it, but if you fuck up it'll get even worse.
				if(do_after(user, 250, target = src))
					if(prob(60))
						to_chat(user, "You successfully repair the [chosen] subsystem, thank God you didn't touch any of the live wires with your metallic wrench.")
						chosen.integrity = chosen.max_integrity
						chosen.failed = FALSE
						chosen.heat = 0
						START_PROCESSING(SSobj, chosen)
						powered = TRUE
					else
						to_chat(user, "You accidentally slip with your [I] and rupture a plasma conduit! sending a huge arc of charged plasma into the air!")
						var/turf/t = get_turf(src)
						t.atmos_spawn_air("plasma=30;TEMP=5000")
						tesla_zap(src, 5, 30000) //That'll seriously fuck things up.
						chosen.failed = TRUE
						chosen.integrity -= 2000 //You seriously fucked up
						powered = TRUE
						START_PROCESSING(SSobj, chosen)
			if(open && !powered)
				if(istype(I, /obj/item/wrench))
					to_chat(user, "You begin a complicated bout of rewiring, ripping out bits of [src] and hastily replacing them with others, this is no substitute for a good stay in spacedock, but it'll have to do.... Luckily you cut the power beforehand")
					if(do_after(user, 300, target = src))
						to_chat(user, "You've finished jury-rigging [src], the [chosen] subsystem should now come back online. You may now close [src]'s cover.")
						chosen.integrity = chosen.max_integrity
						chosen.heat = 0
						chosen.failed = FALSE
						powered = TRUE
						START_PROCESSING(SSobj, chosen)
		if(!open)
			to_chat(user, "Try opening [src]'s panel first")

/obj/effect/panel_overlay
	name = "subsystem panel cover"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel-cover"
	var/obj/structure/overmap/ship
	anchored = TRUE

/obj/structure/subsystem_panel/proc/check_overlays()
	if(chosen)
		cut_overlays()
		cover.icon = icon
		var/goal = chosen.max_integrity
		var/progress = chosen.integrity
		progress = CLAMP(progress, 0, goal)
		icon_state = "subsystem_panel-[round(((progress / goal) * 100), 25)]" //Get more fucked as our subsystem is damaged
		switch(open)
			if(TRUE)
				cover.icon_state = "subsystem_panel-cover-open"
			if(FALSE)
				cover.icon_state = "subsystem_panel-cover"
	//	cover.icon_state = "[icon_state]-cover-[round(((progress / goal) * 100), 50)]"
		cover.layer = 4.5
		add_overlay(cover)
	else
		STOP_PROCESSING(SSobj,src)

// var/thenumber1 = rand(20,40)
// var/thenumber2 = rand(20,50)
// var/theanswer = number1 + number2
// to_chat(user, "Enemy ship unsigned vector X : Mark unsigned vector Y. Phase drift modulation: X + Y = [theanswer].