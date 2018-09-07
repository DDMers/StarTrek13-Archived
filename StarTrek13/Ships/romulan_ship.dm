/obj/structure/overmap/ship/romulan
	name = "dderidex"
	icon = 'StarTrek13/icons/trek/large_ships/dderidex.dmi'
	icon_state = "dderidex"
	spawn_name = "romulan_spawn"
//	pixel_x = -100
//	pixel_y = -100
//	var/datum/shipsystem_controller/SC
	warp_capable = TRUE
	max_health = 40000
	pixel_z = -128
	pixel_w = -120
	faction = "romulan empire"
	cost = 10000
	soundlist = ('StarTrek13/sound/borg/machines/disruptor.ogg')
	var/datum/crew/romulan/crew = new

/obj/structure/overmap/ship/romulan/attempt_fire()
	update_weapons()
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
			if(SC.weapons.attempt_fire())
				var/source = get_turf(src)
				if(!current_beam)
					current_beam = new(source,target_ship,time=1000,beam_icon_state="romulanbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					var/chosen_sound = pick(soundlist)
					playsound(src,chosen_sound,100,1)
					SEND_SOUND(S.pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
					to_chat(pilot, "You successfully hit [S]")
					var/list/L = list()
					if(S.linked_ship)
						var/area/thearea = S.linked_ship
						for(var/turf/T in get_area_turfs(thearea.type))
							L+=T
					in_use1 = 0
					spawn(0)
						current_beam.Start()
				current_beam.origin = src
				damage = SC.weapons.update_weapons()
				damage -= SC.weapons.gimp_damage()
				S.take_damage(damage, TRUE)
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
				A.pixel_x = rand(0, 5)
				A.fire()
				playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',100,1)
				sleep(1)
				if(target_ship)
					A.pixel_x = target_ship.pixel_x
					A.pixel_y = target_ship.pixel_y
				return TRUE
			else
				to_chat(pilot, "No photon torpedoes remain.")

/obj/structure/overmap/ship/process()
	. = ..()
	if(cloaked)
		if(SC.engines.charge <= 100) //Engines completely drained, forcibly decloak!
			cloak()
		SC.engines.charge -= 150
		if(SC.shields.health)
			SC.shields.health -= 100 //Can't run both shields and cloak now can we?


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
		check_assimilation()
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