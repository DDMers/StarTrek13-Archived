/obj/structure/overmap/proc/click_action(atom/target,mob/user)
	if(src != target)
		target_ship = target
		target_ship.agressor = src
		if(user.incapacitated())
			return
		if(istype(target, /obj/structure/overmap))
			var/obj/structure/overmap/thetarget = target
			target = thetarget
			if(target == src)
				return
			fire(thetarget,user)
		else
			to_chat(user, "Unable to lock phasers, this weapon mode only targets large objects")
			return


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

/obj/structure/overmap
	var/obj/effect/ship_overlay/engines = new
	var/obj/effect/ship_overlay/weapons/weaponsoverlay = new
	var/datum/shipsystem/target_subsystem
	var/obj/effect/ship_overlay/hull/hulloverlay = new

/obj/structure/overmap/New()
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
	progress = Clamp(progress, 0, goal)
	engines.icon_state = "[icon_state]-engines-[round(((progress / goal) * 100), 50)]"
	engines.layer = 4.5
	add_overlay(engines)
	//weapons
	weaponsoverlay.ship = src
	weaponsoverlay.system = SC.weapons
	weaponsoverlay.icon = icon
	var/goal1 = SC.weapons.max_integrity
	var/progress1 = SC.weapons.integrity
	progress1 = Clamp(progress1, 0, goal1)
	weaponsoverlay.icon_state = "[icon_state]-weapons-[round(((progress1 / goal1) * 100), 50)]"
	add_overlay(weaponsoverlay)
	//Hull
	hulloverlay.ship = src
	hulloverlay.system = SC.hull_integrity
	hulloverlay.icon = icon
	var/goal2 = max_health
	var/progress2 = health
	progress2 = Clamp(progress2, 0, goal2)
	hulloverlay.icon_state = "[icon_state]-hull-[round(((progress2 / goal2) * 100), 50)]"
	add_overlay(hulloverlay)