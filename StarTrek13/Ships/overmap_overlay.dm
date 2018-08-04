/obj/effect/ship_overlay
	name = "engines"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "engines"
	var/obj/structure/overmap/ship
	var/datum/shipsystem/system

/obj/effect/ship_overlay/weapons
	name = "phaser banks"

/obj/effect/ship_overlay/take_damage(amount)
	ship.take_damage(amount)

/obj/effect/ship_overlay/hull
	name = "hull plates" //Target this one to cause extra breaches and hull damage

/obj/effect/ship_overlay/shield
	name = "shield" //This becomes more and more transparent based on shield health


/obj/structure/overmap
	var/obj/effect/ship_overlay/engines = new
	var/obj/effect/ship_overlay/weapons/weaponsoverlay = new
	var/datum/shipsystem/target_subsystem
	var/obj/effect/ship_overlay/hull/hulloverlay = new
	var/obj/effect/ship_overlay/shield/shieldoverlay = new

/obj/structure/overmap/Initialize(timeofday)
	. = ..()
	overmap_objects += src
	soundloop = new(list(src), TRUE)
	START_PROCESSING(SSobj,src)
	linkto()
	linked_ship = get_area(src)
	var/list/thelist = list()
	for(var/obj/effect/landmark/A in GLOB.landmarks_list)
		if(A.name == spawn_name)
			thelist += A
			continue
//	for(var/obj/effect/landmark/transport_zone/T in world)
	//	transport_zone = get_area(T)
	if(thelist.len)
		var/obj/effect/landmark/A = pick(thelist)
		var/turf/theloc = get_turf(A)
		if(spawn_random)
			forceMove(theloc)
	check_overlays()

/obj/structure/overmap/proc/check_overlays()
	cut_overlays()
	engines.ship = src
	engines.system = SC.engines
	engines.icon = icon
	var/goal = SC.engines.max_integrity
	var/progress = SC.engines.integrity
	progress = CLAMP(progress, 0, goal)
	engines.icon_state = "[icon_state]-engines-[round(((progress / goal) * 100), 50)]"
	add_overlay(engines)
	//weapons
	weaponsoverlay.ship = src
	weaponsoverlay.system = SC.weapons
	weaponsoverlay.icon = icon
	var/goal1 = SC.weapons.max_integrity
	var/progress1 = SC.weapons.integrity
	progress1 = CLAMP(progress1, 0, goal1)
	weaponsoverlay.icon_state = "[icon_state]-weapons-[round(((progress1 / goal1) * 100), 50)]"
	add_overlay(weaponsoverlay)
	//Hull
	hulloverlay.ship = src
	hulloverlay.system = SC.hull_integrity
	hulloverlay.icon = icon
	var/goal2 = max_health
	var/progress2 = health
	progress2 = CLAMP(progress2, 0, goal2)
	hulloverlay.icon_state = "[icon_state]-hull-[round(((progress2 / goal2) * 100), 50)]"
	add_overlay(hulloverlay)
	//shield
	shieldoverlay.ship = src
	shieldoverlay.system = SC.shields
	shieldoverlay.icon = icon
	var/goal3 = max_health
	var/progress3 = health
	progress3 = CLAMP(progress3, 0, goal3)
//	hulloverlay.icon_state = "[icon_state]-hull-[round(((progress3 / goal3) * 100), 50)]"
	shieldoverlay.icon_state = "[icon_state]-shield-0"//This will mean the shield goes invisible, as such an icon state does not exist
	if(has_shields())
		shieldoverlay.icon_state = "[icon_state]-shield" //If we HAVE shields, make it the right iconstate so it's visible.
	shieldoverlay.alpha = round(((progress3 / goal3) * 100), 25)
	shieldoverlay.alpha += 50 //Even 100 alpha is really transparent, so give it a boost here
	shieldoverlay.layer = 4.5
	add_overlay(shieldoverlay)