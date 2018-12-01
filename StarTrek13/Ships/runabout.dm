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
	cost = 2000
	max_health = 6000
	health = 6000
	anchored = TRUE

/obj/structure/overmap/ship/runabout/Initialize()
	. = ..()
	var/obj/structure/fluff/helm/desk/tactical/S = locate(/obj/structure/fluff/helm/desk/tactical) in (get_area(src))
	if(S && S.theship)
		carrier = S.theship

/obj/structure/overmap/ship/runabout/process()
	. = ..()
//	var/obj/structure/fluff/helm/desk/tactical/S = locate(/obj/structure/fluff/helm/desk/tactical) in (get_area(src))
//	if(S && S.theship)
//		carrier = S.theship  we now do this as soon as someone boards the shuttle.
	if(carrier)
		for(var/obj/machinery/computer/camera_advanced/transporter_control/TC in carrier.transporters)
			TC.destinations += src
			for(var/obj/machinery/computer/camera_advanced/transporter_control/TCC in transporters)
				TCC.destinations = TC.destinations

/obj/effect/landmark/runaboutdock
	name = "runabout landing point"


/obj/effect/landmark/runaboutdock/Initialize()
	. = ..()
	var/obj/structure/fluff/helm/desk/tactical/T = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
	if(T)
		if(T.theship)
			T.theship.docks += src

/area/ship/thames
	name = "USS Thames"

/obj/structure/overmap/ship/runabout/sov
	name = "Shuttlecraft"
	spawn_name = "runaboutsov"

/obj/structure/overmap/ship/runabout/wars
	name = "T4 Shuttle"
	spawn_name = "runaboutexecutor"
	icon = 'StarTrek13/icons/trek/runabout-wars.dmi'

/obj/structure/overmap/ship/runabout/wars/secondary
	name = "T4 Shuttle"
	spawn_name = "runaboutexecutor2"
	icon = 'StarTrek13/icons/trek/runabout-wars.dmi'

/obj/structure/overmap/ship/runabout/woolfe
	name = "Shuttlecraft"
	spawn_name = "runaboutwoolfe"

/area/ship/scishuttle
	name = "USS Science"

/area/ship/ganges
	name = "USS Ganges"

/area/ship/empire
	name = "ISS Empire"

/area/ship/executorshuttle2
	name = "ISS Empirical"

/obj/structure/overmap/ship/runabout/station
	name = "Shuttlecraft"
	spawn_name = "runaboutbarnard"

/obj/structure/overmap/ship/runabout/attack_hand(mob/user)
	if(!shields_active())
		to_chat(user, "You climb into the runabout")
		var/obj/structure/weapons_console/WC = locate(/obj/structure/weapons_console) in get_area(user) //We only do this when they click on it by hand, otherwise on enter it'd bug out when the ship flies to overmap.
		if(WC && WC.our_ship)
			carrier = WC.our_ship
			to_chat(user, "[src]'s docking consoles register it as being docked to [carrier]")
		var/turf/open/T = pick(get_area_turfs(linked_ship))
		if(!istype(T, /turf/open))
			T = pick(get_area_turfs(linked_ship))
		user.forceMove(T)
	else
		to_chat(user, "You begin to bypass [src]'s shields")
		if(do_after(user, 50, target = src))
			SC.shields.toggled = FALSE
		return ..()

/obj/structure/overmap/ship/runabout/enter(mob/user)
	. = ..()
	to_chat(pilot, "<span_class='warning'>You are flying a runabout! Alt-click it to dock/undock from a ship/station providing it has a docking point.</span>")

/obj/structure/ladder/unbreakable/runabout
	name = "Runabout exit ladder"
	desc = "In the age of turbolifts and transporters people still couldn't figure out how to get out of these damned runabouts"

/obj/structure/ladder/unbreakable/runabout/attack_hand(mob/user)
	var/obj/structure/fluff/helm/desk/tactical/T = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
	if(T)
		var/obj/structure/overmap/ship/runabout/S = T.theship
		var/area/om = get_area(get_turf(S))
		if(istype(om, /area/overmap))
			to_chat(user, "Jumping out while the shuttle is moving is a bad idea!")
			return
		if(S.carrier) //Don't space yourself onto the overmap, please!
			to_chat(user, "You climb out of [S]")
			user.forceMove(get_turf(S))
		else
			to_chat(user, "You cannot exit the runabout unless it's docked to a ship.")

/obj/structure/overmap/ship/runabout/proc/try_dock()
	if(carrier)
		if(!carrier.shields_active())
			forceMove(carrier.loc)
			carrier = null
			to_chat(pilot, "Undocking..")
			icon_state = "runabout-small"
			return
		else
			to_chat(pilot, "You cannot undock from [carrier] while its shields are raised")
			icon_state = initial(icon_state)
			return
	if(!pilot)
		return
	var/obj/structure/overmap/L = list()
	for(var/obj/structure/overmap/S in orange(src, 9))
		if(!S.shields_active())
			L += S
	var/obj/structure/overmap/A = input(pilot,"Docking target?", "Weapons console)", null) as obj in L
	if(!A && !carrier)
		to_chat(pilot, "Unable to dock")
		icon_state = "runabout-small"
		return
	A.linkto()
	var/obj/effect/landmark/T
	if(A.docks.len)
		T = pick(A.docks)
	else
		for(var/obj/effect/landmark/runaboutdock/R in A.linked_ship)  //fallback, in case it fails
			T = R
	forceMove(get_turf(T))
	if(T)
		icon_state = initial(icon_state)
	carrier = A

/obj/structure/overmap/ship/runabout/CtrlClick(mob/user)
	if(user != pilot)
		return
	try_dock()

/obj/structure/overmap/ship/runabout/AltClick(mob/user)
	if(user != pilot)
		return
	try_dock()
