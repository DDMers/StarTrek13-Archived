/obj/structure/elevator_controller
	name = "turbolift console"
	desc = "it takes you up to different floors of whatever structure you're in, this one works."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "elevator"
	var/floor_num = 0
	var/area/elevator/elevator_area
	var/area/elevator/elevators = list()
	var/obj/machinery/door/airlock/lift/door
	var/turf/open/floor/elevator/floors = list()
	var/atom/movable/in_elevator = list()
	var/turf/open/destination

/obj/structure/elevator_controller/attack_hand(mob/user)
	elevator_area.target_floor = 2
	to_chat(user, "going to floor 2")
	find_target(src,2)//change 2 later

//Many thanks to Baystation 12 for these doors.
/obj/machinery/door/airlock/lift
	name = "Elevator Door"
	desc = "Ding."
	opacity = 1
	autoclose = 0
	glass = 0
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "closed"
	var/obj/structure/elevator_controller/lift //the controller handles the doors

/obj/machinery/door/airlock/lift/New()
	var/area/thearea = get_area(src)
	for(var/obj/structure/elevator_controller/L in thearea)
		lift = L
		L.door = src
		to_chat(world, "dong")
		return

/obj/machinery/door/airlock/lift/Destroy()
	if(lift)
		lift.door -= src
	return ..()

/obj/machinery/door/airlock/lift/bumpopen(var/mob/user)
	return // No accidental sprinting into open elevator shafts.

/obj/machinery/door/airlock/lift/allowed(mob/M)
	return FALSE //only the lift machinery is allowed to operate this door

/obj/machinery/door/airlock/lift/close(var/forced=0)
	for(var/turf/turf in locs)
		for(var/mob/living/LM in turf)
			if(LM.mob_size <= MOB_SIZE_TINY)
				to_chat(src, "[LM] is crushed by [src].")
				LM.gib()
			else // the mob is too big to just move, so we need to give up what we're doing
				to_chat(src, "\The [src]'s motors grind as they quickly reverse direction, unable to safely close.")
			//	cur_command = null // the door will just keep trying otherwise
				return 0
	return ..()


/obj/structure/elevator_controller/New()
	. = ..()
	var/area/thearea = get_area(src)
	elevator_area = thearea
	get_components()


/obj/structure/elevator_controller/proc/get_components()
	var/area/thearea = get_area(src)
	for(var/area/elevator/E in world)
		if(!istype(E))
			return
	//	if(E.id == elevator_area.id)
		elevators += E
		to_chat(world, "ding")
	for(var/turf/open/floor/elevator/E in thearea)
		floors += E

obj/structure/elevator_controller/proc/find_target(floor) //problem is here, destination is always null.
//	source.elevator_area.current_floor = 1
	to_chat(world, "elevator1")
	if(try_find_floor(floor))
	//	if(E.elevator_area.floor_num == floor)
		travel(destination)

obj/structure/elevator_controller/proc/try_find_floor(floor)
	for(var/obj/structure/elevator_controller/E in elevators)
		to_chat(world, "elevator2")
		var/area/elevator/thearea = get_area(E)
		if(thearea.name == "floor [floor]")
			destination = pick(E.floors)
			to_chat(world, "success")
			return 1
	return 0

obj/structure/elevator_controller/proc/override_destination()
	var/obj/structure/elevator_controller/E = pick(elevators)
	destination = E
	travel(destination)

obj/structure/elevator_controller/proc/travel(var/turf/open/destination)
	var/area/thearea = get_area(src)
	for(var/atom/movable/M in thearea)
		to_chat(world, "[M]")
		M.forceMove(destination)

//turf/open/floor/elevator/Crossed(atom/movable/mover)
//	if(!mover in elevator.in_elevator)
//		elevator.in_elevator += mover
//		return ..()
//	return ..()

/turf/open/floor/elevator_shaft
	name = "elevator shaft"
	desc = "AAAHHHH!!!!"
	icon_state = "plating"


/area/elevator
	name = "floor 1"
	icon_state = "ship"
	requires_power = 0 //fix
	has_gravity = 1
	noteleport = 0
	blob_allowed = 0 //Should go without saying, no blobs should take over centcom as a win condition.
	var/floor_num = 1
	var/id = "cadaver" //set this to link lifts
	var/current_floor = 0 //are we the floor the elevator is on
	var/target_floor = 0 //what floor are we targeting

/area/elevator/floor_2
	name = "floor 2"
	floor_num = 2

/area/elevator/floor_3
	name = "floor 3"
	floor_num = 3

/area/elevator/floor_4
	name = "floor 3"
	floor_num = 4

/area/elevator/floor_5
	name = "floor 3"
	floor_num = 5

/area/elevator/floor_6
	name = "floor 3"
	floor_num = 6

/turf/open/floor/elevator
	name = "turbolift floor"
	desc = "you're in a turbolift then."
	icon_state = "floor"







/*

/obj/structure/elevator_controller/proc/update_turfs(num) //Num as in, are we going up and then making the new turfs (removing the shaft)
	if(num)//we are being turned into a shaft
		for(var/turf/T in elevator_turfs)
			T.ChangeTurf(/turf/open/floor/elevator_shaft) //Elevator shaft, ie go in this and fall down
	else
		for(var/turf/T in elevator_turfs)
			T.ChangeTurf(/turf/open/floor/elevator)

/obj/structure/elevator_controller/proc/get_position(floor)
	floors = list()
	floor_total = 0
	to_chat(world,"arrrrgggg")
	var/area/thearea = get_area(src)
	for(var/obj/structure/elevator_controller/E in thearea) //In subtypes of as ship areas will vary.
		to_chat(world,"yee")
		floor_total ++
		if(E.floor_num == floor)
			to_chat(world, "floor")
			target = E
			return

/obj/structure/elevator_controller/proc/travel()
	get_position()
	var/turf/up_turf = get_turf(target) //so they dont land in the console itself
	to_chat(world, "ar")
	var/area/thearea = get_area(src)
	for(var/atom/movable/M as mob|obj in thearea)
		if(istype(M, /obj/structure/elevator_controller))
			return
		else
			to_chat(world,"fuck all of you")
			M.forceMove(up_turf)

/obj/structure/elevator_controller/proc/yeet()
	to_move = list()
	for(var/atom/movable/A as mob|obj in to_move)
		to_chat(A, "fuck you")
		to_chat(world, "forcemove") //OK! it works, now make it not teleport E V E R Y T H I N G

/obj/structure/elevator_controller/attack_hand(mob/user)
	get_position()
	var/A
	A = input(user, "Go to what floor", "you are on:[floor_num] / [floor_total]", A) as num
	if(A > floor_total)
		to_chat(user, "there are not that many floors")
		return
	if(A < 1)
		to_chat(user, "enter a valid floor number")
		return
	if(A == floor_num)
		to_chat(user, "you are already on floor [A]")
	var/floor = A
	to_chat(world, "[floor]")
	go(user, floor)

/obj/structure/elevator_controller/proc/go(mob/user,floor)
	to_chat(user, "you press a button on the lift, it's also not complete kek")
	travel(floor)
	src.say("travelling to floor [floor]")



/*	for(var/obj/structure/elevator_controller/E in floors)
		if(E == target)
			E.locked = 0
		//	E.update_turfs(0)
			up = E
			to_chat(world, "this is src")
		else
			E.locked = 1 //going up
		//	E.update_turfs(1) //change turfs to elevator shaft.
			locked = 1
		//	update_turfs(1) //the current elevator tile just moved up/down, so we need to change it too
			to_chat(world, "going up")
*/

*/