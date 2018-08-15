/obj/structure/overmap/ship/romulan
	name = "dderidex"
	icon = 'StarTrek13/icons/trek/large_ships/dderidex.dmi'
	icon_state = "dderidex"
	spawn_name = "romulan_spawn"
//	pixel_x = -100
//	pixel_y = -100
//	var/datum/shipsystem_controller/SC
	warp_capable = TRUE
	max_health = 35000
	pixel_z = -128
	pixel_w = -120
	faction = "romulan empire"
	cost = 10000
	soundlist = ('StarTrek13/sound/borg/machines/disruptor.ogg')



/obj/structure/overmap/ship/romulan/attempt_fire()
	update_weapons()
	if(wrecked)
		return
	var/obj/structure/overmap/S = target_ship
	if(target_ship)
		target_ship.agressor = src
	switch(fire_mode)
		if(FIRE_PHASER)
			if(SC.weapons.attempt_fire())
				if(target_ship && locked == target_ship) //Is the locked target the one we're clicking?
					in_use1 = 0
					var/chosen_sound = pick(soundlist)
					SEND_SOUND(pilot, sound(chosen_sound))
					SEND_SOUND(S.pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
					SC.weapons.charge -= SC.weapons.fire_cost
					var/turf/source = get_turf(src)
					current_beam = new(source,target_ship,time=6,beam_icon_state="romulanbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					to_chat(pilot, "You successfully hit [S]")
					target_ship.take_damage(damage)
					spawn(0)
						current_beam.Start()
					return
		if(FIRE_PHOTON)
			if(photons > 0)
				if(target_ship && locked == target_ship)
					photons --
					var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
					A.starting = loc
					A.preparePixelProjectile(target_ship,pilot)
					A.pixel_x = rand(0, 5)
					A.fire()
					playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',100,1)
					sleep(1)
					A.pixel_x = target_ship.pixel_x
					A.pixel_y = target_ship.pixel_y
			else
				to_chat(pilot, "No photon torpedoes remain.")

/obj/structure/overmap/ship/process()
	. = ..()
	if(cloaked)
		if(SC.engines.charge <= 100) //Engines completely drained, forcibly decloak!
			cloak()
		SC.engines.charge -= 150
		SC.shields.health -= 1000 //No shields whilst cloaked


/obj/structure/overmap/proc/cloak()
	if(agressor)
		agressor.stop_firing()
		if(src == agressor.nav_target)
			agressor.nav_target = null
	if(cloaked)
		playsound(src,'StarTrek13/sound/trek/decloak.ogg',100,1)
		to_chat(pilot, "Ship decloaking...")
		alpha = 255
		icon_state = "decloak"
		sleep(10)
		icon_state = initial(icon_state)
		cloaked = FALSE
		name = linked_ship.name //Stop it appearing on any sensors and right click menus
		stored_name = null
	else
		playsound(src,'StarTrek13/sound/trek/cloak.ogg',100,1)
		to_chat(pilot, "Ship cloaking...")
		stored_name = name
		alpha = 255
		icon_state = "cloak"
		sleep(10)
		icon_state = initial(icon_state)
		alpha = 0
		cloaked = TRUE
		name = null

/obj/machinery/cloaking_device
	name = "cloaking device"
	desc = "aeh'lla-ifv"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "cloakingdevice"
	var/obj/structure/overmap/theship

/obj/machinery/cloaking_device/attack_hand(mob/user)
	if(powered())
		theship.cloak()
		to_chat(user, "Cloak toggled, WARNING: This will drain engine and shield power when in use!")
	else
		to_chat(user, "Insufficient power!")
		if(theship.cloaked)
			theship.cloak()