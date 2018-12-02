
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
	var/photons = 5 //10 of 10 photons to start, this will link into the torpedo launcher later tm
	var/max_photons = 5

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
	if(cloaked)
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


/mob/living/carbon/canMobMousedown(atom/object, location, params)
	. = ..()
	if(istype(src.loc, /obj/structure/overmap))
		var/obj/structure/overmap/o = loc
		. = o

/obj/structure/overmap
	var/firinginprogress = FALSE //are we shooting something by holding our mouse down?
	var/stopclickspammingshezza = 10 //1 second cooldown to prevent megalag
	var/saved_time_fuckoff_shezza

/obj/structure/overmap/proc/onMouseDown(object, location, params, mob/mob)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"])
		if(istype(object, /obj/structure/overmap))
			nav_target = object
			return
	if(modifiers["shift"])
		if(istype(object, /obj/structure/overmap))
			var/obj/structure/overmap/om = object
			to_chat(pilot, "Shield health: [om.SC.shields.health] / [om.SC.shields.max_health] | Hull integrity: [om.health] / [om.max_health]")
		return
	if(modifiers["ctrl"])
		if(istype(object, /obj/structure/overmap))
			var/obj/structure/overmap/om = object
			if(!om.comms)
				to_chat(pilot, "[om]'s comms systems are nonfunctional, perhaps they do not have a hailing console?")
				return FALSE
			to_chat(pilot, "Attempting to hail [object] | Forwarding request to comms console")
			om.comms.hail_request(src)
		return
	if(modifiers["alt"])
		return
	if(world.time >= saved_time_fuckoff_shezza + stopclickspammingshezza)
		saved_time_fuckoff_shezza = world.time
		if(object == src)
			return
		if(istype(object, /obj/screen) && !istype(object, /obj/screen/click_catcher))
			return
		if(istype(object, /turf/closed/mineral))
			var/turf/closed/mineral/minecraft = object
			mine(minecraft)
		if(istype(object, /obj/structure/overmap))
			target_ship = object
		if(istype(object, /turf))
			target_turf = object
		if((object in pilot.contents) || (object == mob))
			return
		if(!target_ship)
			return
		firinginprogress = TRUE
		damage = SC.weapons.update_weapons()
	else
		to_chat(mob, "Weapons are recharging ! (You need to click and hold to fire)")
		firinginprogress = FALSE
		return 0

/obj/structure/overmap/proc/onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	return

/obj/structure/overmap/proc/onMouseUp(object, location, params, mob/M)
	damage = SC.weapons.update_weapons()
	firinginprogress = FALSE
	firecount = 0
	if(current_beam)
		qdel(current_beam) //Aka finish the attack, and ready the SFX for another one. This saves my eardrums :b1:
	current_beam = null
	target_turf = null

/obj/structure/overmap/fire(obj/structure/overmap/target,mob/user) //Try to get a lock on them, the more they move, the harder this is.
	if(wrecked)
		return 0
	if(cloaked)
		return 0
	if(target)
		if(isOVERMAP(target))
			target.agressor = src
	return TRUE

/obj/structure/overmap
	var/firecount  = 0

/turf/closed/mineral/gets_drilled(obj/structure/overmap/overmap_miner = null)
	if(overmap_miner)
		if(mineralType && (mineralAmt > 0))
			new mineralType(overmap_miner.weapons.loc, mineralAmt)
			SSblackbox.record_feedback("tally", "ore_mined", mineralAmt, mineralType)
	else
		if(mineralType && (mineralAmt > 0))
			new mineralType(src, mineralAmt)
			SSblackbox.record_feedback("tally", "ore_mined", mineralAmt, mineralType)
	for(var/obj/effect/temp_visual/mining_overlay/M in src)
		qdel(M)
	var/flags = NONE
	if(defer_change) // TODO: make the defer change var a var for any changeturf flag
		flags = CHANGETURF_DEFER_CHANGE
	ScrapeAway(null, flags)
	addtimer(CALLBACK(src, .proc/AfterChange), 1, TIMER_UNIQUE)
	playsound(src, 'sound/effects/break_stone.ogg', 50, 1) //beautiful destruction

/turf/closed/mineral/bullet_act(obj/item/projectile/P)
	if(P.damage >= 2000) //It's a photon torpedo
		explosion(src,5,10,5) //Mood honestly
	else
		return ..()

/obj/structure/overmap/proc/mine(turf/closed/mineral/herobrine)
	switch(fire_mode)
		if(FIRE_PHASER)
			if(SC.weapons.attempt_fire())
				var/source = get_turf(src)
				if(!current_beam)
					current_beam = new(source,get_turf(herobrine),time=1000,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					spawn(0)
						current_beam.Start()
					var/chosen_sound = pick(soundlist)
					playsound(src,chosen_sound,200,1)
					for(var/turf/closed/T in getline(get_turf(src), get_turf(herobrine))) //mine DIIIIIIIIIIIIIIIAMONDS
						if(istype(T, /turf/closed/mineral))
							var/turf/closed/mineral/TT = T
							TT.gets_drilled(src)
		if(FIRE_PHOTON)
			if(assimilation_tier > 3)
				to_chat(pilot, "Assimilating [herobrine] would be useless. Try using your phasers instead")
				return FALSE //Nope you're borg
			if(photons > 0)
				photons --
				var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
				A.starting = loc
				A.preparePixelProjectile(herobrine,pilot)
				A.pixel_x = rand(0, 5)
				A.fire()
				return

/obj/structure/overmap/proc/attempt_fire()
	check_assimilation() //Check for special borg weapon attachments
	if(prob(20))
		update_weapons()
	if(wrecked)
		firinginprogress = FALSE
		return FALSE
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
					current_beam = new(source,target_ship,time=1000,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					var/chosen_sound = pick(soundlist)
					playsound(src,chosen_sound,100,1)
					if(S && S.pilot)
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
			else
				return FALSE
		if(FIRE_PHOTON)
			if(assimilation_tier > 3)
				borg_fire(S, 2)
				return TRUE
			if(photons > 0)
				photons --
				if(target_turf && mode == FIRE_PHOTON)
					var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
					A.starting = loc
					A.preparePixelProjectile(target_turf,pilot)
					A.pixel_x = rand(0, 5)
					A.fire()
					return
				else
					var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
					A.starting = loc
					A.preparePixelProjectile(target_ship,pilot)
					A.pixel_x = rand(0, 5)
					A.fire()
					if(target_ship)
						A.pixel_x = target_ship.pixel_x
						A.pixel_y = target_ship.pixel_y
				playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',100,1)
				sleep(1)
				return TRUE
			else
				to_chat(pilot, "No photon torpedoes remain.")
				return FALSE


/obj/structure/overmap/proc/borg_fire(var/obj/structure/overmap/S, var/fire_mode) //change me this doesnt work
	if(!fire_mode)
		return FALSE
	if(fire_mode == 1)
		if(assimilation_tier > 1)
			if(S)
				if(SC.weapons.attempt_fire())
					var/source = get_turf(src)
					if(!current_beam)
						current_beam = new(source,target_ship,time=1000,beam_icon_state="romulanbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
						var/chosen_sound = 'StarTrek13/sound/borg/machines/borgphaser.ogg'
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
	else
		if(assimilation_tier >= 3)
			if(S.SC)
				var/datum/shipsystem/engines/E = locate(/datum/shipsystem/engines) in(S.SC.systems)
				E.charge = 0
				var/datum/shipsystem/shields/SS = locate(/datum/shipsystem/shields) in(S.SC.systems)
				if(SS.health <= 0)
					return
				else
					SS.health -= 1000
			S.vel = 0
			if(!current_beam)
				playsound(src,'StarTrek13/sound/trek/borg_tractorbeam.ogg',100,1) //this is where the fun begins
				var/turf/source = get_turf(src)
				current_beam = new(source,target_ship,time=1000,beam_icon_state="romulanbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
				spawn(0)
					current_beam.Start()
				to_chat(pilot, "Tractor beam established.")
			current_beam.origin = src
			return TRUE
	return FALSE

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
	desc = "A casing for a powerful explosive, you can AltClick it to set it to detonate after a set time."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "torpedo"
	anchored = FALSE
	density = 1 //SKREE
	opacity = 0
	layer = 4.5
	var/armed = 0
	var/damage = 400 //Quite damaging, but not really for battering shields
	var/timing = FALSE
	//var/obj/structure/torpedo_launcher/launcher

/obj/structure/photon_torpedo/AltClick(mob/living/user)
	if(!iscarbon(user) || user.stat == DEAD)
		return
	if(!timing)
		var/mode = input("Arm the torpedo?.", "Are you sure?")in list("yes","no")
		if(mode == "yes")
			var/timer = input("Countdown to explosion (THIS ARMS THE TORPEDO!!!)", "Set a countdown timer in seconds ( minimum time is 10 seconds)") as num
			if(timer > 0)
				message_admins("[key_name(user)] just armed a torpedo for detonation in [get_area(src)]")
				armed = TRUE
				timing = TRUE
				timer *= 10
				to_chat(user, "You set [src] to detonate in [timer/10] seconds")
				desc += "Its trigger is set for a delayed detonation!"
				addtimer(CALLBACK(src, .proc/force_explode), timer)
		if(mode == "no" || !mode)
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