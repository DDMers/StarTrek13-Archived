
#define TINY 5
#define SMALL 3
#define MEDIUM 2
#define LARGE 1
#define HUGE 0.7

/obj/structure/overmap
	var/size = LARGE
	var/datum/progressbar/targeting/progbar
	var/obj/structure/overmap/locked = null
	var/locking = FALSE
	var/fire_mode = FIRE_PHASER
	var/photons = 3 //10 of 10 photons to start, this will link into the torpedo launcher later tm
	var/max_photons = 3

/mob
	var/obj/structure/overmap/overmap_ship


/obj/structure/overmap/proc/fire(obj/structure/overmap/target,mob/user) //Try to get a lock on them, the more they move, the harder this is.
	if(target == target_ship) //We've already got a target /
		if(!locking)
			if(locked)
				attempt_fire() //Time to fire then
				locking = FALSE
				return
			else //We're selecting a new target
				if(!locked)
					target_ship = target
					to_chat(pilot, "Attempting signal lock on [target] (If you want to change target, use the disengage weapons lock button first!)")
					try_lockon(target,100)
					return
				else
					to_chat(pilot, "You're already targeting [target]")
	else //We're selecting a new target
		stop_firing()
		target_ship = target
		to_chat(pilot, "Attempting signal lock on [target]")
		try_lockon(target,100)
		return


/obj/structure/overmap/proc/lose_lock()
	locking = FALSE
	qdel(progbar)
	progbar = null
	locked = null
	target_ship = null
	return


/obj/structure/overmap/proc/try_lockon(atom/target,lockon_speed) //Lockon in MS
	if(!locking)
		locking = TRUE
		lockon_speed = lockon_speed*target_ship.size
		addtimer(CALLBACK(src,.proc/lock_on, src), lockon_speed)
		if(special_do_after(pilot,lockon_speed,target)) //We'll need to change the stuff below if we want multiple people observing the ship etc.
			return
	else
		return

/obj/structure/overmap/proc/lock_on()
	to_chat(pilot, "Target lock established on [target_ship]!")
	locking = FALSE
	locked = target_ship

//Charge indicator
/obj/structure/overmap/proc/check_charge(atom/target)
//	qdel(chargebar)
	target = src



/obj/screen/alert/charge
	icon = 'StarTrek13/icons/trek/overmap_indicators2.dmi'
	icon_state = "prog_bar_0"
	var/obj/structure/overmap/theship
	desc = "The amount of charge your weapon system has"

/obj/screen/alert/charge/New()
	. = ..()
	START_PROCESSING(SSobj, src)
	theship = mob_viewer.overmap_ship

/obj/screen/alert/charge/process()
	theship = mob_viewer.overmap_ship
	var/goal = theship.SC.weapons.max_charge
	var/progress = theship.SC.weapons.charge
	progress = Clamp(progress, 0, goal)
	icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"

/obj/screen/alert/charge/hull
	icon = 'StarTrek13/icons/trek/overmap_indicators3.dmi'
	icon_state = "prog_bar_0"
	obj/structure/overmap/theship
	desc = "Hull integrity and shield strength"
	var/image/damage

/obj/screen/alert/charge/hull/New()
	. = ..()
	var/image/tdamage = image('StarTrek13/icons/trek/overmap_indicators3.dmi',icon_state = "damage_0")
	damage = tdamage
	add_overlay(damage)
	theship = mob_viewer.overmap_ship

/obj/screen/alert/charge/hull/process()
	theship = mob_viewer.overmap_ship
	var/goal = theship.SC.shields.max_integrity
	var/progress = theship.SC.shields.integrity
	progress = Clamp(progress, 0, goal)
	icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	cut_overlays()
	var/image/tdamage = image('StarTrek13/icons/trek/overmap_indicators3.dmi',icon_state = "damage_0")
	var/damage = theship.health
	var/damagegoal = theship.max_health
	progress = Clamp(progress, 0, damagegoal)
	tdamage.icon_state = "damage_[round(((damage / damagegoal) * 100), 5)]"
	add_overlay(tdamage)


/obj/structure/overmap/proc/special_do_after(mob/user, var/delay, atom/target)
	var/obj/structure/overmap/ship/current = target
	var/atom/Tloc = null
	if(target && !isturf(target))
		Tloc = target.loc
	progbar = new(user, delay, target)
	var/endtime = world.time + delay
	var/starttime = world.time
	mainloop:
		while (world.time < endtime)
			stoplag(1)
			if(world.time > endtime)
				locked = current
				to_chat(pilot, "Target lock established on [current]!")
				progbar = progbar
				locking = FALSE //Ready to fire
				break mainloop
				return 1
			if(!target_ship)
				qdel(progbar)
				stop_firing()
				break mainloop
				return 0
			if(current != target_ship) //they just switched their target or it was destroyed, cancel the lock
				locked = null
				stop_firing()
				qdel(progbar)
				break mainloop
			if(Tloc != target.loc) //Have they moved?
				endtime += 5 //Increase lock times by moving rapidly.
				Tloc = target.loc //update the loc again
			progbar.update(world.time - starttime)

/obj/structure/overmap/proc/stop_firing()
	if(pilot)
		to_chat(pilot, "Active target locks have been disengaged.")
		target_ship = null
		target_fore = null
		target_aft = null
		locked = null
		qdel(progbar)

/obj/structure/overmap/proc/attempt_fire()
	var/obj/structure/overmap/S = target_ship
	switch(fire_mode)
		if(FIRE_PHASER)
			if(SC.weapons.attempt_fire())
				if(target_ship && locked == target_ship) //Is the locked target the one we're clicking?
					target_subsystem = pick(S.SC.subsystems) //Change me! Allow players to target subsystems.
					if(S.speed > S.max_speed)
						S.speed = S.max_speed
					if(prob(target_ship.speed))
						var/source = get_turf(src)
						SEND_SOUND(pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
						var/turf/T = pick(orange(2, S))
						current_beam = new(source,T,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
						to_chat(pilot, "You missed [S]")
						return 0 //Miss! they're too fast for YOU suckah
					var/source = get_turf(src)
					var/list/L = list()
					var/area/thearea = S.linked_ship
					for(var/turf/T in get_area_turfs(thearea.type))
						L+=T
					var/location = pick(L)
					var/turf/theturf = get_turf(location)
					S.take_damage(SC.weapons.maths_damage,theturf)
					if(S.has_shields())
						if(target_subsystem)
							target_subsystem.integrity -= (SC.weapons.maths_damage)/3 //Shields absorbs most of the damage
					else
						if(target_subsystem)
							target_subsystem.integrity -= (SC.weapons.maths_damage)/1.5 //No shields, fry that system
							target_subsystem.heat += SC.weapons.maths_damage/10 //Heat for good measure :)
					in_use1 = 0
					var/chosen_sound = pick(soundlist)
					SEND_SOUND(pilot, sound(chosen_sound))
					SEND_SOUND(S.pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
					SC.weapons.charge -= SC.weapons.fire_cost
					current_beam = new(source,target_ship,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					to_chat(pilot, "You successfully hit [S]")
					spawn(0)
						current_beam.Start()
					return
		if(FIRE_PHOTON)
			if(photons > 1)
				if(target_ship && locked == target_ship)
					photons --
					var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
					A.starting = loc
					A.preparePixelProjectile(target_ship,pilot)
					A.pixel_x = rand(-20, 50)
					A.fire()
					playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',40,1)
					sleep(1)
					A.pixel_x = target_ship.pixel_x
					A.pixel_y = target_ship.pixel_y
			else
				to_chat(pilot, "No photon torpedoes remain")

#undef TINY
#undef SMALL
#undef MEDIUM
#undef LARGE
#undef HUGE

//Adapted do_after bars

#define PROGRESSBAR_HEIGHT 0

/datum/progressbar/targeting
	var/name = "thing"

/datum/progressbar/targeting/New(mob/User, goal_number, atom/target)
	. = ..()
	if (!istype(target))
		EXCEPTION("Invalid target given")
	if (goal_number)
		goal = goal_number
	bar = image('StarTrek13/icons/trek/overmap_indicators.dmi', target, "prog_bar_0", HUD_LAYER)
	bar.plane = HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	user = User
	if(user)
		client = user.client
	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])
	var/list/bars = user.progressbars[bar.loc]
	bars.Add(src)
	listindex = bars.len

/datum/progressbar/targeting/update(progress)
	if (!user || !user.client)
		shown = 0
		return
	if (user.client != client)
		if (client)
			client.images -= bar
		if (user.client)
			user.client.images += bar
	progress = Clamp(progress, 0, goal)
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if (!shown)
		user.client.images += bar
		shown = 1

/datum/progressbar/targeting/shiftDown() //These bars are priority
	return

/datum/progressbar/targeting/Destroy()
	for(var/I in user.progressbars[bar.loc])
		var/datum/progressbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()
	var/list/bars = user.progressbars[bar.loc]
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.progressbars, bar.loc)

	if (client)
		client.images -= bar
	qdel(bar)
	. = ..()

#undef PROGRESSBAR_HEIGHT