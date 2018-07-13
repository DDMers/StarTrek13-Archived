/obj/structure/overmap/ship/fighter
	name = "Starfury"
	icon_state = "fighter"
	icon = 'StarTrek13/icons/trek/overmap_fighter.dmi'
	spawn_name = "NT_SHIP"
	pixel_x = 0
	pixel_y = 0
	var/fuel = 0
	health = 1500 //They can take a few bursts, but not many, this is around 4 fighter weapon salvos
	max_health = 1500
	spawn_random = 0
	can_move = 0
	pixel_x = -15
	vehicle_move_delay = 0
	var/starting = 0
	var/obj/structure/overmap/carrier_ship = null
	take_damage_traditionally = FALSE
	var/turf/origin_turf = null //For re-teleporting the ship back when it's done docking.
	damage = 500
	recharge_max = 1.2
	var/exiting = FALSE
	turnspeed = 5 //SWISH
	max_speed = 5
	var/next_fire
	var/fire_delay = 3
	pixel_collision_size_x = -32
	pixel_collision_size_y = -32
	//Add a communcations box sometime ok cool really neat.
	engine_sound = 'StarTrek13/sound/fighter/fighterengine.ogg'
	engine_prob = 5
	var/damage_state = TRUE
	warp_capable = FALSE

/obj/structure/overmap/ship/fighter/viper
	icon_state = "viper"
	name = "Viper"


/obj/structure/overmap/ship/fighter/raider
	icon_state = "raider"
	name = "Cylon Raider"
	engine_sound = 'StarTrek13/sound/fighter/raiderengine.ogg'
	engine_prob = 5


/obj/structure/overmap/ship/fighter/attack_hand(mob/user)
	enter(user)

/obj/structure/overmap/ship/fighter/enter(mob/user)
	SC.weapons.chargeRate = 200
	SC.weapons.charge = 500
	SC.weapons.max_charge = 5000
	if(!carrier_ship)
		to_chat(user, "Error! There's no carrier ship!")
		exit()
		return
	origin_turf = loc
	if(user.client)
		if(carrier_ship)
			forceMove(carrier_ship.loc)
		if(pilot)
			to_chat(user, "you kick [pilot] off the ship controls!")
		//	M.revive(full_heal = 1)
			exit()
			return 0
		initial_loc = user.loc
		user.loc = src
		pilot = user
		pilot.overmap_ship = src
		GrantActions()
		pilot.throw_alert("Weapon charge", /obj/screen/alert/charge)
		pilot.throw_alert("Hull integrity", /obj/screen/alert/charge/hull)
		pilot.whatimControllingOMFG = src
		pilot.client.pixelXYshit()
		while(pilot)
			stoplag()
			ProcessMove()
			parallax_update() //Need this to be on SUPERSPEED or it'll look awful
			if(damage_state)
				switch(health)
					if(0 to 500)
						icon_state = "[initial(icon_state)]-d4"
						max_speed = 1
					if(500 to 700)
						icon_state = "[initial(icon_state)]-d3"
						max_speed = 2
					if(700 to 1000)
						icon_state = "[initial(icon_state)]-d2"
					if(1000 to 1300)
						icon_state = "[initial(icon_state)]-d1"
				if(health >= max_health)
					icon_state = "[initial(icon_state)]"
	else
		to_chat(user, "You need to be logged in to do this")
		exit()
	to_chat(user, "Systems: ONLINE.")
	to_chat(user, "Docking systems: Disengaged. Entering normal space.")

/obj/structure/overmap/ship/fighter/exit()
	to_chat(pilot, "Engaging bluespace re-docking engine.")
	forceMove(origin_turf)
	to_chat(pilot,"you have stopped controlling [src]")
	pilot.forceMove(origin_turf)
	pilot.client.pixelXYshit()
	pilot.clear_alert("Weapon charge", /obj/screen/alert/charge)
	pilot.clear_alert("Hull integrity", /obj/screen/alert/charge/hull)
	RemoveActions()
	initial_loc = null
	pilot.overmap_ship = null
	pilot.whatimControllingOMFG = null
	pilot.client.pixelXYshit()
	pilot.incorporeal_move = 1 //Refresh movement to fix an issue
	pilot.incorporeal_move = 0
	pilot = null
	SC.weapons.charge = SC.weapons.max_charge
	vel = 0
//	pilot.status_flags -= GODMODE


/*
/obj/structure/overmap/ship/fighter/relaymove()
	if(!starting)
		return ..()
	else
		to_chat(pilot, "Cannot engage engines: Pre-flight checks still in progress!")
		return 0
*/


/obj/item/projectile/bullet/fighter_round
	name = ".50 Cal vulcan round"
	icon_state = "bullet"
	damage = 70//There are a LOT of these to fire


/obj/structure/overmap/ship/fighter/fire(atom/target,mob/user) //Try to get a lock on them, the more they move, the harder this is.
	attempt_fire(target)

/obj/structure/overmap/ship/fighter/attempt_fire(atom/target)
	if(!SC.weapons.attempt_fire())
		return
	SC.weapons.charge -= 250
	for(var/i = 1 to 3)
		var/obj/item/projectile/bullet/fighter_round/A = new /obj/item/projectile/bullet/fighter_round(loc)
		A.starting = loc
		A.preparePixelProjectile(target,pilot)
		A.fire()
		playsound(src,'StarTrek13/sound/fighter/fighterfire.ogg',60,1)
		//	A.pixel_x = target_ship.pixel_x
		//	A.pixel_y = target_ship.pixel_y
		A = null


/obj/item/projectile/beam/laser/fightergun
	name = "photon torpedo"
	icon_state = "pulse0_bl"
	damage = 3500//It has to actually dent ships tbh.

/obj/structure/overmap/ship/fighter/destroy()
	to_chat(pilot, "The cabin of [src] explodes into a ball of flames!")
	pilot.forceMove(origin_turf)
	pilot.client.pixelXYshit()
	pilot.clear_alert("Weapon charge", /obj/screen/alert/charge)
	pilot.clear_alert("Hull integrity", /obj/screen/alert/charge/hull)
	RemoveActions()
	initial_loc = null
	pilot.overmap_ship = null
	pilot.whatimControllingOMFG = null
	pilot.client.pixelXYshit()
	pilot.incorporeal_move = 1 //Refresh movement to fix an issue
	pilot.incorporeal_move = 0
	pilot = null
	for(var/datum/shipsystem/S in SC)
		qdel(S)
	qdel(SC)
	qdel(src)
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
