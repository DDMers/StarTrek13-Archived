/obj/structure/overmap/ship/federation_capitalclass/executor
	name = "executor class dreadnought"
	icon = 'StarTrek13/icons/trek/large_ships/executor.dmi'
	icon_state = "executor"
//	pixel_x = -100
//	pixel_y = -100
//	var/datum/shipsystem_controller/SC
	warp_capable = FALSE // No warp coils
	max_health = 80000
	pixel_z = -200
	pixel_w = -250
	turnspeed = 0.1 //This ship is a titan, it should be slow as shit, unwieldy, but an utter monster in battle.
	cost = 200000
	max_speed = 0.2
	acceleration = 0.02
	soundlist = ('StarTrek13/sound/trek/turbolaser.ogg')
	var/datum/crew/executor/crew = new
	spawn_name = "executor_spawn"
	faction = "the empire"

/area/ship/executor
	name = "super star destroyer"

/obj/structure/fluff/helm/desk/tactical/wars
	redalertsounds = list('StarTrek13/sound/borg/machines/warsredalert.ogg')
	icon_state = "computer"

/obj/structure/overmap/ship/federation_capitalclass/executor/attempt_fire()
	update_weapons()
	check_assimilation()
	if(cloaked)
		to_chat(pilot, "<span_class = 'notice'>You cannot fire whilst cloaked.</span>")
		firinginprogress = FALSE
		return 0
	if(wrecked)
		firinginprogress = FALSE
		return
	if(SC.weapons.damage <= 0)
		to_chat(pilot, "<span_class = 'warning'>Weapon systems are depowered!</span>")
		firinginprogress = FALSE
		return FALSE
	var/obj/structure/overmap/S = target_ship
	if(target_ship)
		target_ship.agressor = src
	switch(fire_mode)
		if(FIRE_PHASER)
			if(assimilation_tier > 1)
				if(borg_fire(S, 1))
					return TRUE
				else
					return FALSE //:(
			if(SC.weapons.charge >= 2000) //Alright charge is good..try firing
				if(SC.weapons.attempt_fire()) //We're doing this because I need a custom charge check
					var/chosen_sound = pick(soundlist)
					playsound(src,chosen_sound,100,1)
					if(prob(50)) //:scp: Choose between a volley or a single shot high damage one
						SC.weapons.charge -= 2000
						var/obj/item/projectile/beam/laser/turbolaser/A = new /obj/item/projectile/beam/laser/turbolaser(loc)
						A.starting = loc
						A.preparePixelProjectile(target_ship,pilot)
						A.pixel_x = rand(0, 5)
						A.fire()
						return TRUE
					else
						SC.weapons.charge -= 2000 //stop firing whilst we do the loop
						if(target_turf && mode == FIRE_PHOTON)
							for(var/I = 0 to 5)
								var/obj/item/projectile/beam/laser/miniturbolaser/A = new /obj/item/projectile/beam/laser/miniturbolaser(loc)
								A.starting = loc
								A.preparePixelProjectile(target_turf,pilot)
								A.pixel_x = rand(0,20)
								A.pixel_y = rand(0,20)
								A.fire()
							return
						else
							for(var/I = 0 to 5)
								var/obj/item/projectile/beam/laser/miniturbolaser/A = new /obj/item/projectile/beam/laser/miniturbolaser(loc)
								A.starting = loc
								A.preparePixelProjectile(target_ship,pilot)
								A.pixel_x = rand(0,20)
								A.pixel_y = rand(0,20)
								A.fire()

						return TRUE
					return TRUE
		if(FIRE_PHOTON)
			if(assimilation_tier >= 3)
				if(borg_fire(S, 2))
					return TRUE
				else
					return FALSE
			if(photons > 0)
				photons --
				var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
				A.starting = loc
				A.preparePixelProjectile(target_ship,pilot)
				A.pixel_x = rand(0, 20)
				A.fire()
				playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',100,1)
				sleep(1)
				if(target_ship)
					A.pixel_x = target_ship.pixel_x
					A.pixel_y = target_ship.pixel_y
				return TRUE
			else
				to_chat(pilot, "No photon torpedoes remain.")
