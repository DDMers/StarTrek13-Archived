/obj/structure/overmap/ship/runabout
	name = "Danube Class Runabout"
	icon = 'StarTrek13/icons/trek/runabout.dmi'
	desc = "A small self-contained starship, you can enter it by clicking it, and exit it by either beaming out, or alt-clicking its tactical console: To dock, alt or shift click the craft."
	icon_state = "runabout"
	spawn_name = null
	var/obj/structure/overmap/ship/carrier
	photons = 0 //no :)
	turnspeed = 2
	max_speed = 5
	warp_capable = TRUE

/obj/structure/overmap/ship/runabout/process()
	. = ..()
	if(carrier)
		for(var/obj/machinery/computer/camera_advanced/transporter_control/TC in carrier.transporters)
			TC.destinations += src
			for(var/obj/machinery/computer/camera_advanced/transporter_control/TCC in transporters)
				TCC.destinations = TC.destinations

/obj/effect/landmark/runaboutdock
	name = "runabout landing point"

/area/ship/thames
	name = "USS Thames"

/obj/structure/overmap/ship/runabout/sov
	name = "USS Thames"
	spawn_name = "runaboutsov"

/area/ship/ganges
	name = "USS Ganges"

/obj/structure/overmap/ship/runabout/station
	name = "USS Ganges"
	spawn_name = "runaboutbarnard"

/obj/structure/overmap/ship/runabout/attack_hand(mob/user)
	if(!shields_active)
		to_chat(user, "You climb into the runabout")
		var/turf/open/T = pick(get_area_turfs(linked_ship))
		if(!istype(T, /turf/open))
			T = pick(get_area_turfs(linked_ship))
		user.forceMove(T)
		var/area/A = get_area(src)
		for(var/obj/structure/weapons_console/C in A)
			var/obj/structure/weapons_console/WC = C
			carrier = WC.our_ship
	else
		to_chat(user, "[src] has its shields up!")
		return ..()

/obj/structure/overmap/ship/runabout/enter(mob/user)
	if(carrier)
		if(!carrier.shields_active)
			forceMove(carrier.loc)
			carrier = null
			to_chat(user, "Undocking..")
			icon_state = "runabout-small"
			. = ..()
		else
			to_chat(user, "You cannot undock from [carrier] while its shields are raised")
			icon_state = initial(icon_state)
			exit(TRUE)
	else
		. = ..()

/obj/structure/overmap/ship/runabout/exit(var/forced = FALSE, var/runaboutexit = FALSE, var/mob/living/override = null)
	if(runaboutexit && override)
		if(carrier)
			var/obj/effect/landmark/T = pick(carrier.docks)
			override.forceMove(get_turf(T))
	. = ..()

/obj/structure/overmap/ship/runabout/proc/try_dock()
	var/obj/structure/overmap/L = list()
	for(var/obj/structure/overmap/S in orange(src, 9))
		if(!S.shields_active)
			L += S
	var/obj/structure/overmap/A = input("Docking target?", "Weapons console)", null) as obj in L
	if(!A)
		to_chat(pilot, "Unable to dock")
		icon_state = "runabout-small"
		return
	A.linkto()
	var/obj/effect/landmark/T = pick(A.docks)
	forceMove(get_turf(T))
	if(T)
		icon_state = initial(icon_state)
	carrier = A

/obj/structure/overmap/ship/runabout/CtrlClick()
	try_dock()


/obj/structure/overmap/ship/runabout/AltClick()
	try_dock()
