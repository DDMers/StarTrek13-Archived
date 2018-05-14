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
	if(amount >= 1000)
		for(var/mob/L in linked_ship.contents)
			shake_camera(L, 1, 10)
			var/sound/thesound = pick(ship_damage_sounds)
			SEND_SOUND(L, thesound)
		var/maths = 5
		if(istype(agressor.target_subsystem, /datum/shipsystem/integrity)) //If they target the hull subsystem, they deal heavy physical damage
			maths += 20 //Heavily increase physical damage
		if(prob(20))
			for(var/obj/structure/overmap/O in orange(30,src))
				SEND_SOUND(O.pilot,'StarTrek13/sound/trek/ship_effects/farawayexplosions.ogg')
		icon_state = initial(icon_state)
		var/turf/open/floor/theturf1 = pick(get_area_turfs(linked_ship))
		var/turf/open/floor/theturf = get_turf(theturf1)
		if(prob(60+maths))
			new /obj/effect/hotspot/shipfire(theturf)  //begin the fluff! as ships are damaged, they start visibly getting destroyed
			theturf.atmos_spawn_air("plasma=30;TEMP=1000")
			for(var/turf/open/floor/T in orange(5,theturf))
				new /obj/effect/hotspot/shipfire(T.loc)
			if(prob(30+maths))
				explosion(theturf,2,4,0)
			return
		else//40% chance
			var/new_type = pick(subtypesof(/obj/structure/debris))
			theturf.visible_message("<span class='danger'>Something falls down from the ceiling above you!</span>")
			new new_type(get_turf(theturf))
		if(amount >= 1000) //That's a lotta damage
			if(prob(20+maths))
				explosion(theturf,2,5,5) //Pretty bad hit right there

	//	for(var/turf/open/floor/T in orange(2,theturf))

	//	explosion(theturf,2,5,11)

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