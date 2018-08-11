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