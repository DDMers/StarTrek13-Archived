
#define TINY 2
#define SMALL 1
#define MEDIUM 0.7
#define LARGE 0.5
#define HUGE 0.3

/obj/structure/overmap/proc/click_action(mob/user)
	fire(user)

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

/obj/structure/overmap/proc/target_subsystem(mob/user)
	if(target_ship)
		var/list/ourlist = target_ship.SC.systems
		for(var/datum/shipsystem/S in ourlist)
			if(S.failed)
				ourlist -= S
		to_chat(pilot, "List of subsystems and functions:")
		to_chat(pilot, "The engines subsystem allows a ship to move | The sensors subsystem is not added yet | The hull subsystem (when targeted) will deal heavy physical damage to the target at the expense of not hitting a critical system | The weapons system will fail when damaged, preventing the enemy from firing | The shields subsystem allows a ship to project a shield")
		var/datum/shipsystem/V = input("Select subsystem to target", "Scan of [target_ship] (failed systems are not shown)", null) in ourlist
	//	var/datum/shipsystem/V = ourlist[A]
		target_subsystem = V
		to_chat(pilot, "Weapons targeting the [V] subsystem")
	else
		to_chat(pilot, "Target a ship first!")

/obj/structure/overmap/proc/fire(obj/structure/overmap/target,mob/user) //Try to get a lock on them, the more they move, the harder this is.
	if(wrecked)
		return 0
	if(target)
		if(isOVERMAP(target))
			target.agressor = src
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
		if(istype(target, /obj/structure/overmap)) //Click floors = target lost? :thinking:
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
	if(wrecked)
		return
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

/obj/screen/alert/charge/Initialize(timeofday)
	. = ..()
	START_PROCESSING(SSobj, src)
	if(mob_viewer)
		theship = mob_viewer.overmap_ship

/obj/screen/alert/charge/process()
	theship = mob_viewer.overmap_ship
	var/goal = theship.SC.weapons.max_charge
	var/progress = theship.SC.weapons.charge
	progress = CLAMP(progress, 0, goal)
	icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"

/obj/screen/alert/charge/hull
	icon = 'StarTrek13/icons/trek/overmap_indicators3.dmi'
	icon_state = "prog_bar_0"
	obj/structure/overmap/theship
	desc = "Hull integrity and shield strength"
	var/image/damage

/obj/screen/alert/charge/hull/Initialize(timeofday)
	. = ..()
	var/image/tdamage = image('StarTrek13/icons/trek/overmap_indicators3.dmi',icon_state = "damage_0")
	damage = tdamage
	add_overlay(damage)
	if(mob_viewer)
		theship = mob_viewer.overmap_ship

/obj/screen/alert/charge/hull/process()
	theship = mob_viewer.overmap_ship
	var/goal = theship.SC.shields.max_health
	var/progress = theship.SC.shields.health
	progress = CLAMP(progress, 0, goal)
	icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	cut_overlays()
	var/image/tdamage = image('StarTrek13/icons/trek/overmap_indicators3.dmi',icon_state = "damage_0")
	var/damage = theship.health
	var/damagegoal = theship.max_health
	progress = CLAMP(progress, 0, damagegoal)
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
	progbar.bar.pixel_x = current.pixel_x //Bar is the physical object that the progbar datum creates
	progbar.bar.pixel_y = current.pixel_y
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
	if(wrecked)
		return
	var/obj/structure/overmap/S = target_ship
	if(target_ship)
		target_ship.agressor = src
	switch(fire_mode)
		if(FIRE_PHASER)
			if(SC.weapons.attempt_fire())
				if(target_ship && locked == target_ship) //Is the locked target the one we're clicking?
				//	if(!target_subsystem)
					//	target_subsystem = pick(S.SC.systems) //Redundant, but here just in case it
					if(prob(10))
						var/source = get_turf(src)
						SEND_SOUND(pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
						var/turf/T = pick(orange(2, S))
						current_beam = new(source,T,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
						to_chat(pilot, "You missed [S]")
						return 0 //Miss! they're too fast for YOU suckah
					var/source = get_turf(src)
					S.take_damage(SC.weapons.damage,1)
					var/list/L = list()
					if(S.linked_ship)
						var/area/thearea = S.linked_ship
						for(var/turf/T in get_area_turfs(thearea.type))
							L+=T
				//	S.take_damage(SC.weapons.maths_damage,theturf)
					in_use1 = 0
					var/chosen_sound = pick(soundlist)
					SEND_SOUND(pilot, sound(chosen_sound))
					SEND_SOUND(S.pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
					SC.weapons.charge -= SC.weapons.fire_cost
					current_beam = new(source,target_ship,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
				//	current_beam.beam.pixel_x = target_ship.pixel_x
				//	current_beam.beam.pixel_y = target_ship.pixel_y
					to_chat(pilot, "You successfully hit [S]")
					target_ship.take_damage(damage)
					if(!S.has_shields())
						var/obj/effect/explosion/explosion = new(get_turf(target_ship))
						var/matrix/ntransform = matrix(transform)
						ntransform.Scale(0.5)
						explosion.layer = 4.5
						explosion.pixel_x = target_ship.pixel_x + rand(50,100)
						explosion.pixel_y = target_ship.pixel_y + rand(50,100)
						animate(explosion, transform = ntransform, time = 0.5,easing = EASE_IN|EASE_OUT)
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
					A.pixel_x = rand(-20, 50)
					A.fire()
					playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',40,1)
					sleep(1)
					A.pixel_x = target_ship.pixel_x
					A.pixel_y = target_ship.pixel_y
			else
				to_chat(pilot, "No photon torpedoes remain.")

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
	progress = CLAMP(progress, 0, goal)
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



/obj/structure/photon_torpedo
	name = "photon torpedo"
	desc = "A casing for a powerful explosive, I wouldn't touch it if I were you..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "torpedo"
	anchored = FALSE
	density = 1 //SKREE
	opacity = 0
	layer = 4.5
	var/armed = 0
	var/damage = 400 //Quite damaging, but not really for battering shields
	var/timer = 0
	var/timing = FALSE
	//var/obj/structure/torpedo_launcher/launcher

/obj/structure/photon_torpedo/attack_hand(mob/user)
	if(!timing)
		timer = input("Countdown to explosion (THIS ARMS THE TORPEDO!!!)", "Set a countdown timer in seconds (set it to 0 or less to cancel, minimum time is 10 seconds)") as num
		if(timer > 0)
			armed = TRUE
			timing = TRUE
			timer *= 10
			to_chat(user, "You set [src] to detonate in [timer/10] seconds")
			desc += "Its trigger is set for a delayed detonation of [timer] seconds!"
			addtimer(CALLBACK(src, .proc/force_explode), timer)
		else
			return 0
	else
		to_chat(user, "It's already been primed, throw it out an airlock!")

/obj/structure/photon_torpedo/bullet_act()
	if(armed)
		force_explode()

/obj/structure/photon_torpedo/proc/force_explode()
	var/area/thearea = get_area(src)
	for(var/mob/M in thearea)
		shake_camera(M, 20, 1)
		SEND_SOUND(M, 'StarTrek13/sound/trek/ship_effects/torpedoimpact.ogg')
		explosion(src.loc,2,5,20,8)

/obj/structure/photon_torpedo/Bump(atom/movable/AM)
	if(armed)
		if(istype(AM, /obj/effect/adv_shield))
			var/obj/effect/adv_shield/S = AM
			S.take_damage(damage)
			var/area/thearea = get_area(S)
			qdel(src)
			for(var/mob/M in thearea)
				shake_camera(M, 20, 1)
		else
			explosion(src.loc,2,5,20,8)
			var/area/thearea = get_area(AM)
			for(var/mob/M in thearea)
				shake_camera(M, 30, 2)
	else
		. = ..()

//this code bumped into the shield and carried on bumping them until they died, may be cool as a bunker buster torpedo
/*
/obj/structure/photon_torpedo/Bump(atom/movable/AM)
	if(armed)
		if(istype(AM, /obj/effect/adv_shield))
			var/obj/effect/adv_shield/S = AM
			S.take_damage(damage)
			var/area/thearea = get_area(S)
			for(var/mob/M in thearea)
				shake_camera(M, 20, 1)
		else
			explosion(src.loc,2,5,20,8)
			var/area/thearea = get_area(AM)
			for(var/mob/M in thearea)
				shake_camera(M, 30, 3)
	else
		. = ..()
*/

obj/structure/torpedo_launcher
	name = "torpedo launcher"
	desc = "launch the clown at high velocity"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "torpedolauncher"
	var/list/loaded = list()
	var/list/sounds = list('StarTrek13/sound/borg/machines/torpedo1.ogg','StarTrek13/sound/borg/machines/torpedo2.ogg')
	var/obj/machinery/space_battle/shield_generator/shieldgen
//	var/atom/target = null
	density = 1
	anchored = 1

obj/structure/torpedo_launcher/CollidedWith(atom/movable/AM)
	if(istype(AM, /obj/structure/photon_torpedo))
		var/obj/structure/overmap/our_ship = shieldgen.ship
		if(our_ship.photons < our_ship.max_photons)
			loaded += AM
			AM.loc = src
			src.say("[AM] has been loaded into the tube")
			icon_state = "torpedolauncher-fire"
			our_ship.photons ++
			qdel(AM)
		else
			src.say("[our_ship] is at full capacity already.")
			return ..()

obj/structure/torpedo_launcher/Initialize(timeofday)
	find_generator()

obj/structure/torpedo_launcher/attack_hand(mob/user)
	icon_state = "torpedolauncher"
	to_chat(user, "you start unloading [src]")
	if(do_after(user, 50, target = src))
		icon_state = "torpedolauncher-fire"
		for(var/atom/movable/I in loaded)
			var/turf/theturf = get_turf(user)
			I.forceMove(theturf)
			loaded -= I
			if(istype(I, /obj/structure/photon_torpedo))
				var/obj/structure/photon_torpedo/T = I
				T.armed = 0
				T.icon_state = "torpedo"


obj/structure/torpedo_launcher/proc/find_generator()
	var/area/thearea = get_area(src)
	for(var/obj/machinery/space_battle/shield_generator/S in thearea)
		shieldgen = S

obj/structure/torpedo_launcher/proc/fire(atom/movable/target, mob/user, overriden_start_loc)
	icon_state = "torpedolauncher"
	var/sound = pick(sounds)
	find_generator()
	playsound(src.loc, sound, 300,1)
	if(!overriden_start_loc)
		for(var/atom/movable/A in loaded)
			var/obj/effect/adv_shield/S = pick(shieldgen.shields) //new shield each time, prevent spam
			A.forceMove(get_turf(S))
		//	if(istype(A,/mob/living/))
	//			var/mob/living/M = A
		//		M.Weaken(5)
			if(istype(A, /obj/structure/photon_torpedo))
				var/obj/structure/photon_torpedo/T = A
				T.armed = 1
				T.icon_state = "torpedo_armed"
			var/atom/throw_at = get_turf(target)
		//	A.forceMove(throw_at)
			A.throw_at(throw_at, 1000, 1)
			loaded = list()
			to_chat(user, "Success")
		if(!loaded.len)
			src.say("Nothing is loaded")
	else
		find_generator()
		if(loaded.len)
			for(var/atom/movable/A in loaded)
				var/atom/movable/our_ship = shieldgen.ship
				A.forceMove(our_ship.loc)
				var/atom/movable/targetship = shieldgen.ship.target_ship
				A.throw_at(targetship, 1000, 1)
			return 1
		else
			to_chat(shieldgen.ship.pilot, "Unable to launch torpedoes! nothing is loaded!")
