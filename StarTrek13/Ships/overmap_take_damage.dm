/*
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
*/

/obj/structure/overmap/proc/apply_damage(var/amount)
	if(prob(20))
		for(var/obj/structure/overmap/O in orange(30,src))
			SEND_SOUND(O.pilot,'StarTrek13/sound/trek/ship_effects/farawayexplosions.ogg')
	for(var/mob/L in linked_ship.contents)
		shake_camera(L, 1, 10)
		var/sound/thesound = pick(ship_damage_sounds)
		SEND_SOUND(L, thesound)
	icon_state = initial(icon_state)
	var/turf/open/floor/theturf1 = pick(get_area_turfs(linked_ship))
	var/turf/open/floor/theturf = get_turf(theturf1)
	if(prob(60))
		new /obj/effect/hotspot/shipfire(theturf)  //begin the fluff! as ships are damaged, they start visibly getting destroyed
		theturf.atmos_spawn_air("plasma=30;TEMP=1000")
		for(var/turf/open/floor/T in orange(5,theturf))
			new /obj/effect/hotspot/shipfire(T.loc)
		if(prob(30))
			explosion(theturf,2,4,0)
		return
	else//40% chance
		var/new_type = pick(subtypesof(/obj/structure/debris))
		theturf.visible_message("<span class='danger'>Something falls down from the ceiling above you!</span>")
		new new_type(get_turf(theturf))
	if(amount >= 1000) //That's a lotta damage
		if(prob(20))
			explosion(theturf,2,5,5) //Pretty bad hit right there
	//	for(var/turf/open/floor/T in orange(2,theturf))

	//	explosion(theturf,2,5,11)

/obj/structure/overmap/proc/get_damageable_components()
	for(var/obj/structure/ship_component/L in linked_ship)
		components += L
		L.our_ship = src
		L.SC = SC

//Sparks, smoke, fire, breaches, roof falls on heads


/obj/structure/ship_component		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "coolant manifold"
	desc = "a large manifold carrying supercooled coolant gas to the ship's subsystems, you should take care to maintain it to avoid malfunctions!"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "coolant"
	var/damage_message = "ruptures!"
	var/health = 100
	var/obj/structure/overmap/our_ship
	var/datum/shipsystem_controller/SC
	var/active = FALSE
	var/datum/shipsystem/chosen //What subsystem we're currently boosting.
	var/benefit_amount = 100 //How much will you gain in health/lose in heat with this component active?
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
	if(!chosen)
		chosen = pick(SC.systems)
	check_health()
	apply_subsystem_bonus()

/obj/structure/ship_component/take_damage(amount)
	health -= amount
	visible_message("[src] is hit!")
	check_health()

/obj/structure/ship_component/proc/check_health()
	if(health >= 100)
		icon_state = initial(icon_state)
		return
	else if(health <100 && health >20)
		icon_state = "[icon_state]-damaged"
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
		chosen.lose_heat(benefit_amount)
		return 1
	else
		return 0

/obj/structure/ship_component/attack_hand(mob/living/H)
	if(can_be_reactivated)
		if(!active)
			to_chat(H, "You activate [src]!")
			active = TRUE
		else
			to_chat(H, "You de-activate [src]!")
			active = FALSE
	else
		to_chat(H, "[src] is too badly damaged! repair it first!")

/obj/effect/hotspot/shipfire
	name = "roaring fire"
	icon = 'StarTrek13/icons/trek/debris.dmi'
	icon_state = "shipfire"


/obj/structure/debris
	name = "fallen debris"
	icon = 'StarTrek13/icons/trek/debris.dmi'
	icon_state = "debris"
	desc = "some debris that has been torn from the hull of a ship"
	layer = 4.5
	anchored = 1
	can_be_unanchored = 0

/obj/structure/debris/attackby(mob/user, obj/item/I)
	if(istype(I, /obj/item/wrench))
		to_chat(user, "You clear away [src]")
		qdel(src)

/obj/structure/debris/alt
	icon_state = "debris2"
	name = "fallen debris"

/obj/structure/debris/ceiling
	icon_state = "ceiling"
	name = "collapsed ceiling"

/obj/structure/debris/ceiling/wires
	icon_state = "ceiling2"

/obj/structure/debris/ceiling/tubes
	icon_state = "ceiling3"

/obj/structure/debris/girder
	icon_state = "girder"
	name = "smashed girder"

/obj/structure/debris/girder/alt
	icon_state = "girder2"
	name = "smashed girder"

/obj/structure/debris/girder/reallysmashed
	icon_state = "girder3"
	name = "smashed girder"

/obj/structure/debris/sparks
	icon_state = "arcingsparks"
	name = "sparks"
	desc = "sparks of electricity shooting out from exposed wires"

//new /obj/effect/hotspot(M.loc)

/datum/gas/plasma/specialFX //Special FX firestarter plasma for ship damage!
	id = "hot_air"
	gas_overlay = null

/*
	for(var/obj/machinery in linked_ship.contents)
		if(prob(70))
			var/datum/effect_system/smoke_spread/thesmoke
			thesmoke = new /datum/effect_system/smoke_spread(theturf.loc)
			thesmoke.set_up(2, theturf)
			thesmoke.start()
			var/datum/effect_system/spark_spread/s = new
			s.set_up(4, 1, src)
			s.start()
*/