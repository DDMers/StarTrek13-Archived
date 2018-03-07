/obj/structure/overmap/ship/fighter
	name = "Starfury"
	icon_state = "fighter"
	icon = 'StarTrek13/icons/trek/overmap_fighter.dmi'
	spawn_name = "NT_SHIP"
	pixel_x = 0
	pixel_y = 0
	var/fuel = 0
	health = 500 //Somewhat hardy but not really
	spawn_random = 0
	can_move = 0
	pixel_x = -15
	vehicle_move_delay = 0
	var/starting = 0
	var/obj/structure/overmap/carrier_ship = null
	take_damage_traditionally = FALSE
	var/turf/origin_turf = null //For re-teleporting the ship back when it's done docking.
	damage = 100
	recharge_max = 1.2
	var/exiting = FALSE
	//Add a communcations box sometime ok cool really neat.

/obj/structure/overmap/ship/fighter/attack_hand(mob/user)
	enter(user)

/obj/structure/overmap/ship/fighter/enter(mob/user)
	origin_turf = get_turf(src)
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
		to_chat(user, "Docking systems: Disengaged. Entering normal space.")
		if(carrier_ship)
			forceMove(carrier_ship.loc)
		else
			to_chat(user, "Error. You shouldn't be seeing this")

/obj/structure/overmap/ship/fighter/exit()
	if(!starting)
		if(carrier_ship)
			to_chat(pilot, "Moving to re-dock with [carrier_ship]")
			nav_target = carrier_ship
			exiting = TRUE
			starting = 0
	else
		. = ..()

/obj/structure/overmap/ship/fighter/relaymove()
	if(!starting)
		return ..()
	else
		to_chat(pilot, "Cannot engage engines: Pre-flight checks still in progress!")
		return 0


/obj/structure/overmap/ship/fighter/attempt_fire()
	if(recharge <= 0 && charge >= phaser_fire_cost && target_ship)
		recharge = recharge_max //-1 per tick
		var/obj/item/projectile/beam/laser/ship_turret_laser/A = new /obj/item/projectile/beam/laser/ship_turret_laser(loc)
		A.starting = loc
		A.preparePixelProjectile(target_ship,pilot)
		A.fire()
		playsound(src,'StarTrek13/sound/trek/ship_effects/flak.ogg',40,1)
		charge -= phaser_fire_cost
	else
		return 0

/obj/structure/overmap/ship/fighter/navigate()
	update_turrets()
	if(world.time < next_vehicle_move)
		return 0
	next_vehicle_move = world.time + vehicle_move_delay
	step_to(src,nav_target)
	var/d = get_dir(src, nav_target)
	if(d & (d-1))//not a cardinal direction
		setDir(d)
		step(src,dir)
	if(exiting && src in orange(2, nav_target))
		exiting = FALSE
		navigating = 0
		to_chat(pilot, "Movement towards [nav_target] complete. Engaging auto-dock subsystem.")
		forceMove(origin_turf)
	if(src in orange(4, nav_target))
		navigating = 0
		to_chat(pilot, "Movement towards [nav_target] complete. Engaging auto-dock subsystem.")

/obj/structure/overmap/ship/fighter/destroy()
	to_chat(pilot, "The cabin of [src] explodes into a ball of flames!")
//	pilot.forceMove(loc)
	qdel(pilot)
	pilot = null
	. = ..()

/obj/structure/overmap/ship/fighter/linkto()	//Overriding this, as fighters are just an object in themselves!
	return 0
/obj/structure/overmap/ship/fighter/update_weapons()	//Fighters only have their onboard weapon systems.
	return 0
	/*
	damage = 0	//R/HMMM


		damage += P.damage
		phaser_fire_cost += P.fire_cost
		counter ++
		temp = P.charge
	max_charge += counter*temp //To avoid it dropping to 0 on update, so then the charge spikes to maximum due to process()
	*/
