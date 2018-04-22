var/global/list/jumpgates = list()
var/global/list/warp_beacons = list()
#define DEFAULT_TIME 1400	//2 minute jump time.
#define MEDIUM_TIME 1800
#define FAR_TIME 2600
#define DEADSPACE_TIME 4000 //Looooooong way away

//A note on jumpgates:
/*
Jumpgates are vastly more limited than warp speed, as they can only lock on to another jumpgate. A warp capable vessel can lock in on any starsystem and jump. Whereas ones without warp drive must follow the chain of jumpgates.
*/

/obj/structure/jumpgate
	name = "Jumpgate (Nanotrasen space)"
	icon = 'StarTrek13/icons/trek/jumpgate.dmi'
	desc = "A massive ring of metal, it is the cutting edge culmination of Nanotrasen's bluespace research, and can be used for long range FTL jumps."
	icon_state = "jumpgate"
	var/obj/structure/jumpgate/target_gate
	var/being_used = FALSE
	var/destination_locked = FALSE
	var/area/hyperspace_area = null
	var/obj/effect/landmark/hyperspace_marker = null
	var/position = 1 //Position in the jumpgate network. Jumpgates can only lock on in incriments of 1.
	var/transit_time = 10

/obj/effect/landmark/warp_beacon //These are used for warp capable vessels
	name = "Warp beacon"
	var/distance = DEFAULT_TIME //Distance as in how remote this jump-beacon is.
	var/warp_restricted = FALSE //Add in warp inhibitors for faction home space.

/obj/effect/landmark/warp_beacon/New()
	. = ..()
	var/area/thearea = get_area(src)
	name = "[thearea.name]"
	warp_beacons += src

/obj/structure/jumpgate/ShiftClick(mob/user)
	if(!destination_locked && !being_used)
		activate(user)

/obj/structure/jumpgate/New()
	. = ..()
	jumpgates += src
	find_hyperspace()
	var/area/thearea = get_area(src)
	var/area/overmap/A = thearea
	name = "Jumpgate: [thearea.name]"
	position = A.jumpgate_position
	for(var/obj/effect/landmark/warp_beacon/W in thearea)
		var/obj/effect/landmark/warp_beacon/L = W
		transit_time = L.distance

/obj/structure/jumpgate/proc/find_hyperspace()
	for(var/obj/effect/landmark/L in GLOB.landmarks_list)
		if(L.name == "hyperspace")
			hyperspace_area = get_area(L)
			hyperspace_marker = L

/obj/structure/jumpgate/proc/activate(mob/user)
	if(!SSfaction.jumpgates_forbidden)
		if(!being_used)
			being_used = TRUE
			var/list/thelist = list()
			for(var/obj/structure/jumpgate/J in jumpgates)
				if(position - J.position == 1 || -1)		//If i'm at jumpgate 4, going to 5, it's 4-5. -1. If I'm at jumpgate 2 going BACK to  1, it's 1. If I'm at jumpgate 3 trying to go back to 1, it's not 1 or -1
					thelist += J
				else
					thelist -= J
			var/A
			A = input("Select jumpgate target:", "Jumpgate control", A) as null|anything in thelist
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
	else
		to_chat(user, "Jumpgate is charging up!")


/obj/structure/jumpgate/proc/deactivate()
	target_gate = null
	destination_locked = FALSE
	density = FALSE
	icon_state = initial(icon_state)
	being_used = FALSE
	return

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

#undef DEFAULT_TIME
#undef MEDIUM_TIME
#undef FAR_TIME
#undef DEADSPACE_TIME //Looooooong way away