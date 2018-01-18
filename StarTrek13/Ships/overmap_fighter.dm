/obj/structure/overmap/ship/fighter
	name = "Starfury"
	icon_state = "fighter"
	icon = 'StarTrek13/icons/trek/overmap_fighter.dmi'
	initial_icon_state = "fighter"
	spawn_name = "NT_SHIP"
	pixel_x = 0
	pixel_y = 0
	var/fuel = 0
	health = 500 //Somewhat hardy but not really
	spawn_random = 0
	can_move = 0
	pixel_x = -15
	var/starting = 0
	//Add a communcations box sometime ok cool really neat.

/obj/structure/overmap/ship/fighter/attack_hand(mob/user)
	enter(user)

/obj/structure/overmap/ship/fighter/enter(mob/user)
	if(pilot)
		to_chat(user, "The [src] already has a pilot.")
		return 0
	to_chat(user, "You hop into [src] and close the hatch")
	can_move = 0
	starting = 1
	initial_loc = user.loc
	user.loc = src
	pilot = user
	to_chat(user, "Engaging pre-flight tests.")
	SEND_SOUND(user, sound('StarTrek13/sound/fighter/startup.ogg'))
//	bootup()
	if(do_after(user, 601, target = src))
		to_chat(user, "Systems: ONLINE.")
		can_move = 1
		starting = 0

/obj/structure/overmap/ship/fighter/exit()
	if(!starting)
		. = ..()
		starting = 0

/obj/structure/overmap/ship/fighter/relaymove()
	if(!starting)
		return ..()
	else
		to_chat(pilot, "Cannot engage engines: Pre-flight checks still in progress!")
		return 0