var/global/list/jumpgates = list()

/obj/structure/jumpgate
	name = "Jumpgate"
	icon = 'StarTrek13/icons/trek/jumpgate.dmi'
	desc = "A massive ring of metal, it is the cutting edge culmination of Nanotrasen's bluespace research, and can be used for long range FTL jumps."
	icon_state = "jumpgate"
	var/obj/structure/jumpgate/target_gate
	var/being_used = FALSE
	var/destination_locked = FALSE
	var/area/hyperspace_area = null
	var/obj/effect/landmark/hyperspace_marker = null

/obj/structure/jumpgate/ShiftClick(mob/user)
	if(!destination_locked && !being_used)
		activate(user)

/obj/structure/jumpgate/New()
	. = ..()
	jumpgates += src
	find_hyperspace()

/obj/structure/jumpgate/proc/find_hyperspace()
	for(var/obj/effect/landmark/L in GLOB.landmarks_list)
		if(L.name == "hyperspace")
			hyperspace_area = get_area(L)
			hyperspace_marker = L

/obj/structure/jumpgate/proc/activate(mob/user)
	if(!being_used)
		being_used = TRUE
		var/A
		A = input("Select jumpgate target:", "Jumpgate control", A) as null|anything in jumpgates
		if(!A)
			being_used = FALSE
			return
		if(!destination_locked)
			var/obj/structure/jumpgate/J = A
			target_gate = J
			destination_locked = TRUE
			to_chat(user, "Beginning activation sequence.")
			icon_state = "jumpgate_active" //now play a spoolup sequence and add fluff here. TODO!
			density = TRUE
	else
		to_chat(user, "ERROR: Jumpgate is already being programmed.")

/obj/structure/jumpgate/CollidedWith(atom/movable/mover) //This isn't running for some reason?
	find_hyperspace()
	if(destination_locked)
		var/list/temp = list()
		for(var/turf/open/T in get_area_turfs(hyperspace_area))
			temp += T
		var/turf/theturf = pick(temp)
		mover.forceMove(theturf)
		if(isovermapship(mover))
			var/obj/structure/overmap/ship/S = mover
			S.do_warp(target_gate, 100)