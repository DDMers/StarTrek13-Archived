#define SIMPLIFY_DEGREES(degrees) (MODULUS((degrees), 360))
#define TO_DEGREES(radians) ((radians) * 57.2957795)

/obj/structure/overmap/ship/AI
	name = "Rogue Omega Class Destroyer"
	icon = 'StarTrek13/icons/trek/large_ships/hyperion.dmi'
	icon_state = "hyperion"
//	pixel_x = -100
//	pixel_y = -100
//	var/datum/shipsystem_controller/SC
	warp_capable = TRUE
	max_health = 20000
	pixel_z = -128
	pixel_w = -120
	var/obj/structure/overmap/stored_target
	max_speed = 1
	acceleration = 0.1
	damage = 5000
	spawn_name = "ai_spawn"

/obj/structure/overmap/ship/AI/small
	name = "Pirate Reaver"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "pirateship"
	max_health = 8000
	max_speed = 2
	acceleration = 0.5

/area/ship/ai
	name = "Uss AI ship"

/area/ship/ai/two
	name = "Uss AI ship 2: Electric boogaloo"

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
	if(weapons)
		weapons.shieldgen.toggle(src)
	while(1)
		stoplag()
		ProcessMove()
		EditAngle()
		if(!stored_target in orange(src, 6))
			stored_target = null
		if(stored_target)
			TurnTo(stored_target)

/obj/structure/overmap/ship/AI/process()
	. = ..()
	if(!stored_target)
		PickRandomShip()
	if(stored_target in orange(src, 6))
		if(prob(60)) //Allow it time to recharge
			fire(stored_target)
	else
		stored_target = null
	if(vel < max_speed)
		vel += acceleration

/obj/structure/overmap/ship/AI/proc/PickRandomShip()
	if(!stored_target)
		for(var/obj/structure/overmap/S in orange(src, 5))
			if(istype(S, /obj/structure/overmap) && !istype(S, /obj/structure/overmap/ship/AI) && !istype(S, /obj/structure/overmap/shipwreck)) //No ai megaduels JUST yet!
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
		if(SC.weapons.attempt_fire())
			if(S) //Is the locked target the one we're clicking?
			//	if(!target_subsystem)
				//	target_subsystem = pick(S.SC.systems) //Redundant, but here just in case it
				S.take_damage(SC.weapons.damage,1)
				var/source = get_turf(src)
				var/list/L = list()
				if(S.linked_ship)
					var/area/thearea = S.linked_ship
					for(var/turf/T in get_area_turfs(thearea.type))
						L+=T
				SC.weapons.charge -= SC.weapons.fire_cost
				current_beam = new(source,S,time=10,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
				spawn(0)
				current_beam.Start()
				return

/obj/structure/overmap/ship/AI/TurnTo(atom/target)
	if(stored_target in orange(src, 2))
		vel = 0
		return
	if(target)
		var/obj/structure/overmap/ship/self = src //I'm a reel cumputer syentist :)
		EditAngle()
		angle = 450 - SIMPLIFY_DEGREES(ATAN2((32*target.y+target.pixel_y) - (32*self.y+self.pixel_y), (32*target.x+target.pixel_x) - (32*self.x+self.pixel_x)))
	else
		vel = 0

/obj/structure/overmap/proc/TurnTo(atom/target)
	if(target)
		var/obj/structure/overmap/ship/self = src //I'm a reel cumputer syentist :)
		EditAngle()
		angle = 450 - SIMPLIFY_DEGREES(ATAN2((32*target.y+target.pixel_y) - (32*self.y+self.pixel_y), (32*target.x+target.pixel_x) - (32*self.x+self.pixel_x)))

/obj/structure/overmap/proc/Orbit(atom/target)
	var/obj/structure/overmap/ship/self = src //I'm a reel cumputer syentist :)
	EditAngle()
	angle = 360 - SIMPLIFY_DEGREES(ATAN2((32*target.y+target.pixel_y) - (32*self.y+self.pixel_y), (32*target.x+target.pixel_x) - (32*self.x+self.pixel_x)))