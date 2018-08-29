/obj/structure/overmap/ship/assimilated //we are the borg
	name = "assimilated ship"
	icon_state = "borgship"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	spawn_name = "borg_spawn"
	pixel_x = -32
	pixel_y = -32
	health = 20000
	max_health = 20000
	warp_capable = TRUE
	turnspeed = 3
	pixel_collision_size_x = 48
	pixel_collision_size_y = 48
	max_speed = 5
	faction = "the borg"
	var/assimilation_tier = 0 //0-4, with 4 being a dreadnought
	cost = 0 //you only get one
	soundlist = ('StarTrek13/sound/trek/borg_phaser.ogg')

/obj/structure/overmap/ship/assimilated/proc/check_assimilation()
	switch(assimilation_tier)
		if(0)
			icon_state = "borgship0"
			health += 7000 //Get out clause, so they can run
			max_health = 25000
		if(1)
			icon_state = "borgship1"
			health += 7000 //Get out clause, so they can run
			max_health = 30000
		if(2)
			icon_state = "borgship2"
			health += 7000 //Get out clause, so they can run
			max_health = 35000
			name = "Scout 554"
		if(3)
			icon_state = "borgship3" //By this point it gets borg cube abilities
			health += 7000 //Get out clause, so they can run
			max_health = 45000
			name = "Submatrix 554"
		if(4)
			icon_state = "borgship4" //fucking unit
			health += 7000 //Get out clause, so they can run
			max_health = 50000
			name = "Unimatrix 554"


/obj/machinery/borg/converter
	name = "conversion device"
	desc = "The final stage of the assimilation process of the borg. May god have mercy on your crew."
	icon_state = "converter"
	icon = 'StarTrek13/icons/borg/borg.dmi'
	var/stored_resources = 10 //click it with a borg tool to dump your resources into it, when you turn it on with the required amount it'll assimilate your ship
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/obj/structure/overmap/ship/assimilated/ship
	anchored = TRUE

/obj/machinery/borg/converter/Initialize()
	. = ..()
	var/obj/structure/fluff/helm/desk/tactical/F = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
	ship = F.theship

/obj/machinery/borg/converter/examine(mob/user)
	. = ..()
	to_chat(user, "-It has [stored_resources] M2 of raw material stored.")

/obj/machinery/borg/converter/attack_hand(mob/user)
	icon_state = "converter"
	if(!ship)
		var/obj/structure/fluff/helm/desk/tactical/F = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
		ship = F.theship
	if(ishuman(user))
		var/mode = alert("Select mode",,"Fabricate Parts", "Assimilate Vessel")
		switch(mode)
			if("Fabricate Parts")
				var/mode2 = alert("Fabricate what",,"Advanced power cell (50 R)", "Advanced Capacitor (50 R)", "Part exchanger (150 R)")
				switch(mode2)
					if("Advanced power cell (50 R)")
						if(stored_resources > 50)
							var/obj/item/stock_parts/cell/high/cell = new(src.loc)
							cell.name = "High capacity energy storage module"
							playsound(src.loc, 'StarTrek13/sound/borg/machines/borgtransport.ogg', 100,1)
							stored_resources -= 50
					if("Advanced Capacitor (50 R)")
						if(stored_resources > 50)
							var/obj/item/stock_parts/capacitor/super/s = new(src.loc)
							s.name = "Flux-state Trans-Capacitor"
							playsound(src.loc, 'StarTrek13/sound/borg/machines/borgtransport.ogg', 100,1)
							stored_resources -= 50
					if("Part exchanger (150 R)")
						if(stored_resources > 150)
							var/obj/item/storage/part_replacer/bluespace/s = new(src.loc)
							s.name = "Part Exchange Matrix"
							playsound(src.loc, 'StarTrek13/sound/borg/machines/borgtransport.ogg', 100,1)
							stored_resources -= 150
			if("Assimilate Vessel")
				switch(ship.assimilation_tier)
					if(0)
						if(stored_resources >= 200) //First one's cheap
							icon_state = "converter-on"
							stored_resources -= 200
							playsound(src.loc, 'StarTrek13/sound/borg/machines/convertx.ogg', 40, 4)
							sleep(20)
							say("Augmentation of [ship]'s hull completed. Further assimilation will require more resources")
							ship.assimilation_tier ++
							ship.check_assimilation()
					if(1)
						if(stored_resources >= 500) //Slightly more expensive, 5 resources per turf, so 60 turfs assimilated is the required amt.
							icon_state = "converter-on"
							stored_resources -= 500
							playsound(src.loc, 'StarTrek13/sound/borg/machines/convertx.ogg', 40, 4)
							sleep(20)
							say("Augmentation of [ship]'s hull completed. Further assimilation will require more resources")
							ship.assimilation_tier ++
							ship.check_assimilation()
					if(2)
						if(stored_resources >= 800) //Once they hit this tier, they've already become REALLY dangerous, with classical borg abilities.
							icon_state = "converter-on"
							stored_resources -= 800
							playsound(src.loc, 'StarTrek13/sound/borg/machines/convertx.ogg', 40, 4)
							sleep(20)
							say("Augmentation of [ship]'s hull completed. Further assimilation will require more resources")
							ship.assimilation_tier ++
							ship.check_assimilation()
							var/ping = "<font color='green' size='2'><B><i>Borg Collective: </b> <b>Hivemind Notice:</b></i>Use of photonic torpedoes is deprecated. We have replaced [src]'s photon torpedo systems with a shield draining beam.</font></span>"
							for(var/mob/living/carbon/human/H in SSfaction.borg_hivemind.borgs)
								for(var/obj/item/organ/borgNanites/B in H.internal_organs)
									B.receive_message(ping)
							for(var/mob/M in GLOB.dead_mob_list)
								to_chat(M, ping)
					if(3)
						if(stored_resources >= 1200) //The apex borg ship, once it reaches this point, it is extremely difficult to stop.
							icon_state = "converter-on"
							stored_resources -= 1200
							playsound(src.loc, 'StarTrek13/sound/borg/machines/convertx.ogg', 40, 4)
							sleep(20)
							say("Augmentation of [ship]'s hull fully complete. No further assimilation is possible.")
							ship.assimilation_tier ++
							ship.check_assimilation()
					if(4)
						to_chat(user, "[ship] is already fully assimilated")
						return

/obj/machinery/borg/converter/attackby(obj/item/I, mob/user)
	var/transfer = 0
	if(istype(I, /obj/item/borg_tool))
		var/obj/item/borg_tool/W = I
		to_chat(user, "Transferring stored resources to [src]")
		if(W.resource_amount)
			transfer = W.resource_amount
			if(do_after(user, 50, target = src)) //5 seconds to make sure you don't do it accidentally
				to_chat(user, "Resource transfer complete, increased [src]'s storage by [transfer]")
				W.resource_amount = 0
				stored_resources += transfer
		else
			to_chat(user, "[I] has no stored resources to transfer to [src]")
	else
		. = ..()

/obj/structure/overmap/ship/assimilated/attempt_fire()
	update_weapons()
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
		if(1)
			if(SC.weapons.attempt_fire())
				var/source = get_turf(src)
				if(!current_beam)
					current_beam = new(source,target_ship,time=1000,beam_icon_state="romulanbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					var/chosen_sound = pick(soundlist)
					playsound(src,chosen_sound,100,1)
					if(S.pilot)
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
		if(2)
			if(assimilation_tier < 3)
				if(photons > 0)
					if(target_ship && locked == target_ship)
						photons --
						var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
						A.starting = loc
						A.preparePixelProjectile(target_ship,pilot)
						A.pixel_x = rand(0, 5)
						A.color = "#008000"
						A.fire()
						playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',100,1)
						sleep(1)
						A.pixel_x = target_ship.pixel_x
						A.pixel_y = target_ship.pixel_y
				else
					to_chat(pilot, "No photon torpedoes remain.")
			else
				var/datum/shipsystem/engines/E = locate(/datum/shipsystem/engines) in(S.SC.systems)
				E.charge = 0
				S.vel = 0
				var/datum/shipsystem/shields/SS = locate(/datum/shipsystem/shields) in(S.SC.systems)
				SS.health -= 1000
				if(!current_beam)
					playsound(src,'StarTrek13/sound/trek/borg_tractorbeam.ogg',100,1) //this is where the fun begins
					var/turf/source = get_turf(src)
					current_beam = new(source,target_ship,time=1000,beam_icon_state="romulanbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					spawn(0)
						current_beam.Start()
					to_chat(pilot, "Tractor beam established.")
				current_beam.origin = src
				return TRUE

