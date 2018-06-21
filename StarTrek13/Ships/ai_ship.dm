#define SIMPLIFY_DEGREES(degrees) (Modulus((degrees), 360))
#define TO_DEGREES(radians) ((radians) * 57.2957795)

/obj/structure/overmap/ship/AI
	name = "USS Sovreign"
	icon = 'StarTrek13/icons/trek/large_ships/sovreign.dmi'
	icon_state = "sovreign"
//	pixel_x = -100
//	pixel_y = -100
//	var/datum/shipsystem_controller/SC
	warp_capable = TRUE
	max_health = 30000
	pixel_z = -128
	pixel_w = -120
	var/obj/structure/overmap/stored_target
	max_speed = 1
	acceleration = 0.1
	damage = 5000

/obj/structure/overmap/missile
	name = "missile"
	desc = "You should probably run away."
	max_health = 100
	SC = null
	var/obj/structure/overmap/stored_target
	max_speed = 4
	var/burntime = 50 //5 seconds before the missile blows
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "missile"
	var/missile_damage = 1000

/obj/structure/overmap/missile/New()
	if(!stored_target)
		stored_target = pick(orange(src, 10))
		if(!istype(stored_target, /obj/structure/overmap))
			stored_target = null
	QDEL_IN(src, burntime)
	while(src)
		stoplag()
		vel = max_speed
		ProcessMove()
		SC.weapons.damage = 5000 - SC.weapons.heat

/obj/structure/overmap/missile/process()
	if(!stored_target)
		stored_target = pick(orange(src, 10))
		if(!istype(stored_target, /obj/structure/overmap))
			stored_target = null
	if(stored_target in orange(src, 1))
		stored_target.take_damage(missile_damage)
		qdel(src)
	if(!health)
		qdel(src)
	TurnTo(stored_target)
	EditAngle()
	ProcessMove()

/obj/structure/overmap/ship/AI/New()
	. = ..()
	while(1)
		stoplag()
		ProcessMove()
		EditAngle()
		TurnTo(stored_target)

/obj/structure/overmap/ship/AI/process()
	. = ..()
	if(prob(50)) //Allow it time to recharge
		if(SC.weapons.charge > 2000)
			fire(stored_target)
	if(!stored_target)
		PickRandomShip()
	if(vel < max_speed)
		vel += acceleration

/obj/structure/overmap/ship/AI/proc/PickRandomShip()
	if(!nav_target)
		for(var/obj/structure/overmap/S in orange(src, 5))
			if(istype(S, /obj/structure/overmap))
				stored_target = S
				break
		return

/obj/structure/overmap/ship/AI/fire(obj/structure/overmap/target) //Try to get a lock on them, the more they move, the harder this is.
	if(wrecked)
		return 0
	if(target)
		if(istype(target, /obj/structure/overmap))
			target.agressor = src
	attempt_fire() //Time to fire then
	return

/obj/structure/overmap/ship/AI/attempt_fire()
	if(wrecked)
		return
	var/obj/structure/overmap/S = stored_target
	if(stored_target)
		stored_target.agressor = src
	switch(fire_mode)
		if(FIRE_PHASER)
			if(SC.weapons.attempt_fire())
				if(S) //Is the locked target the one we're clicking?
				//	if(!target_subsystem)
					//	target_subsystem = pick(S.SC.systems) //Redundant, but here just in case it
					if(prob(10))
						var/source = get_turf(src)
					//	SEND_SOUND(pilot, sound('StarTrek13/sound/borg/machines/alert1.ogg'))
						var/turf/T = pick(orange(2, S))
						current_beam = new(source,T,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
						//to_chat(pilot, "You missed [S]")
						return 0 //Miss! they're too fast for YOU suckah
					S.take_damage(SC.weapons.damage, null, src)
					var/source = get_turf(src)
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
					current_beam = new(source,S,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
					S.take_damage(damage)
					if(!S.has_shields())
						var/obj/effect/explosion/explosion = new(get_turf(S))
						var/matrix/ntransform = matrix(transform)
						ntransform.Scale(0.5)
						explosion.layer = 4.5
						explosion.pixel_x = S.pixel_x + rand(50,100)
						explosion.pixel_y = S.pixel_y + rand(50,100)
						animate(explosion, transform = ntransform, time = 0.5,easing = EASE_IN|EASE_OUT)
					spawn(0)
						current_beam.Start()
					return
		if(FIRE_PHOTON)
			if(photons > 0)
				if(S)
					photons --
					var/obj/item/projectile/beam/laser/photon_torpedo/A = new /obj/item/projectile/beam/laser/photon_torpedo(loc)
					A.starting = loc
					A.preparePixelProjectile(S,pilot)
					A.pixel_x = rand(-20, 50)
					A.fire()
					playsound(src,'StarTrek13/sound/borg/machines/torpedo1.ogg',40,1)
					sleep(1)
					A.pixel_x = S.pixel_x
					A.pixel_y = S.pixel_y
			else
				to_chat(pilot, "No photon torpedoes remain")


/obj/structure/overmap/proc/TurnTo(atom/target)
	var/obj/structure/overmap/ship/self = src //I'm a reel cumputer syentist :)
	EditAngle()
	angle = 450 - SIMPLIFY_DEGREES(Atan2((32*target.y+target.pixel_y) - (32*self.y+self.pixel_y), (32*target.x+target.pixel_x) - (32*self.x+self.pixel_x)))

/obj/structure/overmap/proc/Orbit(atom/target)
	var/obj/structure/overmap/ship/self = src //I'm a reel cumputer syentist :)
	EditAngle()
	angle = 360 - SIMPLIFY_DEGREES(Atan2((32*target.y+target.pixel_y) - (32*self.y+self.pixel_y), (32*target.x+target.pixel_x) - (32*self.x+self.pixel_x)))