#define PHYSICAL 1

/obj/structure/window/trek
	name = "window"
	desc = "A window."
	icon = 'StarTrek13/icons/trek/trek_wall.dmi'
	icon_state = "window"
	density = 1
	layer = ABOVE_OBJ_LAYER //Just above doors
	CanAtmosPass = 0

/obj/structure/window/trek/steel
	name = "steel plated window"
	desc = "A window, how dull and grey."
	icon = 'StarTrek13/icons/trek/NT_trek_wall.dmi'


/obj/structure/window/trek/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return 1
	if(istype(mover, /obj/structure/window))
		var/obj/structure/window/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/structure/windoor_assembly))
		var/obj/structure/windoor_assembly/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/machinery/door/window) && !valid_window_location(loc, mover.dir))
		return FALSE
	return 0

/obj/effect/landmark/shield
	name = "shield marker"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"

/obj/effect/adv_shield
	name = "Flux Shield"
	desc = "A rapid flux field, you feel like touching it would end very badly."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwalloff"
	density = 0
	anchored = 1
	var/obj/machinery/space_battle/shield_generator/generator
	var/health = 1050 //charge them up
	var/maxhealth = 20000
	var/in_dir = 2
	var/list/friendly = list() //friendly phasers that are linked, have this change ON DISMANTLE ok?
	var/regen = 100 //inherited from generator
	var/active = 0

/obj/effect/adv_shield/CanAtmosPass(turf/T)
	if(density)
		return 0
	else
		return 1

/obj/effect/adv_shield/Initialize(timeofday)
	. = ..()

//	START_PROCESSING(SSobj, src)

/obj/effect/adv_shield/proc/activate()
	icon_state = "shieldwall"
	density = 1
	START_PROCESSING(SSobj,src)

/obj/effect/adv_shield/proc/deactivate()
	icon_state = "shieldwalloff"
	density = 0
	if(src in generator.active_shields)
		generator.active_shields.Remove(src)
		generator.inactive_shields.Add(src)
//	if(num == 1) //safely powered down from shieldgen
	//	STOP_PROCESSING(SSobj,src)
	else
		return

/obj/effect/adv_shield/ex_act(severity)
	var/damage = 300*severity
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	take_damage(damage)

/obj/effect/adv_shield/bullet_act(obj/item/projectile/P)
	. = ..()
	take_damage(P.damage)
	/*
	for(var/obj/effect/adv_shield/S in generator.shields)
		S.health -= P.damage //tank all shields
	percentage(P.damage)
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	return 1
	*/
//obj/effect/adv_shield/attackby(/obj/item/weapon/I)
//	. = ..()
//	var/obj/item/weapon/A = I
//	take_damage(A.force)

/obj/effect/adv_shield/take_damage(amount)
//	if(!CanPass(mover))
//		return
	if(amount > 0)
		if(density)
			for(var/obj/effect/adv_shield/S in generator.shields)
				S.health -= amount //tank all shields
			var/datum/effect_system/spark_spread/s = new
			s.set_up(2, 1, src)
			s.start()
			playsound(src.loc, 'StarTrek13/sound/borg/machines/shieldhit.ogg', 100,1)
			return 1
		else
			return 0
	else
		return 0

/obj/effect/adv_shield/proc/pass_check(atom/movable/mover)
	if(mover in friendly)
		return 1
	else
		return 0

//obj/effect/adv_shield/Bump(atom/A) // Gets flung out.
//	if(pass_check(A))
//		continue
//	else
	//	return
//obj/effect/adv_shield/CanPass(atom/movable/mover, turf/target, height=0) // Shields are one-way: Shit can leave, but shit can't enter
//	if(density)
//		if(istype(loc, /turf/open/space/transit))
//			return 0
	//	if(get_dir(src, target) == in_dir)
	//		return 1
	//	return 0
//	else
	//	return 1


#undef PHYSICAL

//guns
//current_beam = new(user,current_target,time=6000,beam_icon_state="medbeam",btype=/obj/effect/ebeam/medical)




/obj/item/gun/shipweapon //guns go inside ship mounting things, like turrets
	name = "inner phaser array"
	desc = "I wouldn't stand in front of this if I were you..."
	icon = 'icons/obj/chronos.dmi'
	icon_state = "chronogun"
	item_state = "chronogun"
	w_class = 3.0
	var/atom/current_target
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 1000 //it's a ship gun after all
	var/active = 0
	var/datum/beam/current_beam = null
	var/mounted = 1 //Denotes if this is a handheld or mounted version
	var/damage = 1500
	var/cooldown = 20 //2 second beam duration
	var/saved_time = 0
	weapon_weight = WEAPON_MEDIUM
	var/list/fire_sounds = list('StarTrek13/sound/borg/machines/phaser.ogg','StarTrek13/sound/borg/machines/phaser2.ogg','StarTrek13/sound/borg/machines/phaser3.ogg')

/obj/item/gun/shipweapon/Initialize(timeofday)
	..()
	START_PROCESSING(SSobj, src)

/obj/item/gun/shipweapon/attack_self(mob/user)
	to_chat(user,"<span class='notice'>You disable the beam.</span>")
	LoseTarget()

/obj/item/gun/shipweapon/proc/LoseTarget()
	if(active)
		qdel(current_beam)
		active = 0
		on_beam_release(current_target)
	current_target = null

/obj/item/gun/shipweapon/process_fire(atom/target as mob|obj|turf, atom/source as mob|obj, message = 0, params, zone_override)
	var/sound = pick(fire_sounds)
	playsound(src.loc,sound, 200,1)
	if(isliving(source))
		var/mob/living/L = source
		add_fingerprint(L)
	if(current_target)
		LoseTarget()
	active = 1
	current_beam = new(source,current_target,time=30,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
	spawn(0)
		current_beam.Start()

	//feedback_add_details("gun_fired","[src.type]")
/*
/obj/item/gun/shipweapon/process()
	var/source = loc
	if(!mounted && !isliving(source))
		LoseTarget()
		return

	if(!current_target)
		LoseTarget()
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(get_dist(source, current_target)>max_range || !los_check(source, current_target))
		LoseTarget()
		if(ishuman(source))
			to_chat(source, "<span class='warning'>You lose control of the beam!</span>")
		return
	if(current_target)
		on_beam_tick(current_target)
	if(world.time >= saved_time + cooldown)
		LoseTarget()
		saved_time = 0
		return

/obj/item/gun/shipweapon/proc/los_check(atom/movable/user, atom/target)
	var/turf/user_turf = user.loc
	if(mounted)
		user_turf = get_turf(user)
	else if(!istype(user_turf))
		return 0
	var/obj/dummy = new(user_turf)
	dummy.pass_flags |= PASSTABLE|PASSGLASS|PASSGRILLE //Grille/Glass so it can be used through common windows
	for(var/turf/turf in getline(user_turf,target))
		if(mounted && turf == user_turf)
			continue //Mechs are dense and thus fail the check
		for(var/atom/movable/AM in turf)
			if(!ismob(AM) && !isturf(AM))
				if(istype(AM, /obj/effect/adv_shield))
					var/obj/effect/adv_shield/S = AM
					if(S.pass_check(src)) ///pass check being it's ALLOWED to go through
						continue
					else //not a friendly bullet, no go thru!
						S.take_damage(damage)
						qdel(dummy) //oK so this called that's good!
						return 0
				if(!AM.CanPass(dummy,turf,1))
				//	explosion(AM.loc,1,1,1,2)
					qdel(dummy)
					AM.ex_act(1)
					return 0
			if(ismob(AM))
				var/mob/living/C = AM
				C.adjustBruteLoss(damage) //AAAAAA FUCK OUCH AAAA
				C.adjustFireLoss(damage)
				qdel(dummy)
				return 0
			else
				if(!AM.CanPass(dummy,turf,1))
					qdel(dummy)
					return 0
		if(turf.density)
			var/turf/theturf = get_turf(turf)
			explosion(theturf,2,5,11)
			qdel(dummy)
			return 0
		for(var/obj/effect/ebeam/phaser/B in turf)// Don't cross the str-beams!
			if(B.owner != current_beam)
				explosion(B.loc,0,3,5,8)
				qdel(dummy)
				return 0
	qdel(dummy)
	return 1
/obj/item/gun/shipweapon/proc/on_beam_hit(var/atom/target)
	saved_time = world.time
	return


/obj/item/gun/shipweapon/proc/on_beam_tick(var/atom/target)
	//PoolOrNew(/obj/effect/overlay/temp/heal, list(get_turf(target), "#80F5FF"))
//	if(istype(target, /obj/effect/adv_shield))
	//	to_chat(world, "it's a shield lol")
//		var/obj/effect/adv_shield/S = target
//		S.take_damage(damage)
	//	return
	if(isliving(target))
		var/mob/living/C = target
		C.adjustBruteLoss(damage) //AAAAAA FUCK OUCH AAAA
		C.adjustFireLoss(damage)
		return

*/

/obj/item/gun/shipweapon/proc/on_beam_release(var/atom/target)
	return

/obj/effect/ebeam/phaser
	name = "high density photon beam"
	var/datum/effect_system/trail_follow/ion/ion_trail
//	max_distance = "5000"

/obj/effect/ebeam/phaser/Initialize(timeofday)
	..()
	ion_trail = new
	ion_trail.set_up(src)


//DEFINE TARGET

/obj/structure/fluff/helm
	name = "helm control"
	desc = "A console that sits over a chair, allowing one to fly a starship."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	anchored = TRUE
	density = 1
	opacity = 0
	layer = 4.5

/obj/structure/sign/trek
	name = "ship markings"
	icon_state = "trek1"

/obj/structure/sign/trek/ncc
	name = "ship markings"
	icon_state = "trek3"

/obj/structure/sign/trek/ncc/a
	name = "ship markings"
	icon_state = "trek4"

/obj/machinery/shieldgen/wallmounted
	name = "structural integrity field generator"
	desc = "Can be activated to seal off hull breaches, don't expect the emergency fields it creates to last long though...."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "shieldoff"
	density = 1
	opacity = 0
	anchored = 1
	can_be_unanchored = 0
	shield_range = 10

/obj/structure/fluff/ship
	name = "wall panel"
	desc = "a wall mounted screen"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "conduit"
	layer = 4.5
	anchored = 1
	density = 0
	can_be_unanchored = 0
	pixel_y = -8

/obj/structure/fluff/ship/panel		//TO DO DIRECTIONS, TRY FOR(VAR/THISTYPE/P in GETLINE to area you want to go to, then update icon states?
	name = "wall panel"
	desc = "a wall mounted screen"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "panel_both"
	layer = 4.5

/obj/structure/fluff/ship/panel/blank
	name = "wall panel"
	desc = "a wall mounted screen"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "panel_blank"

/obj/structure/fluff/ship/panel/frame
	name = "wall panel"
	desc = "a wall mounted screen"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "panel_frame"

/obj/structure/fluff/ship/panel/drawer
	name = "drawers"
	desc = "what could they contain?"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "drawer_two"
	pixel_y = -6

/obj/structure/fluff/ship/panel/drawer/single
	name = "drawer"
	desc = "what could it contain?"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "drawer"

/obj/structure/fluff/ship/sticker
	name = "red sticker"
	desc = "It reads: do not feed the clown"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "sticker_red"
	pixel_y = 0

/obj/structure/fluff/ship/panel/red
	name = "red panel"
	desc = "it hums lightly..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "strip_both"

/obj/structure/fluff/ship/panel/type1
	name = "panel"
	desc = "it hums lightly..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "panel_1"

/obj/structure/fluff/ship/panel/type2
	name = "panel"
	desc = "it hums lightly..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "panel_2"

/obj/structure/fluff/ship/panel/type3
	name = "panel"
	desc = "it hums lightly..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "panelwall"

/obj/structure/fluff/ship/attackby(mob/user)
	return 0
/obj/structure/fluff/ship/ex_act(severity)
	return 0


// Based on catwalk.dm from https://github.com/Endless-Horizon/CEV-Eris

//Copied from YawnWiderstation https://github.com/Repede/YawnWiderStation
/obj/structure/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'StarTrek13/icons/trek/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these things."
	density = 0
	anchored = 1.0

/obj/structure/catwalk/Initialize()
	. = ..()
	for(var/obj/structure/catwalk/O in range(1))
		O.update_icon()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			warning("Duplicate [type] in [loc] ([x], [y], [z])")
			return INITIALIZE_HINT_QDEL
	update_icon()

/obj/structure/catwalk/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/catwalk/L in orange(location, 1))
		L.update_icon()

/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
	return

/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in GLOB.cardinals)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	//NORTHEAST
	if(connectdir & NORTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHEAST)))
			diagonalconnect |= 1
	//SOUTHEAST
	if(connectdir & SOUTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHEAST)))
			diagonalconnect |= 2
	//NORTHWEST
	if(connectdir & NORTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHWEST)))
			diagonalconnect |= 4
	//SOUTHWEST
	if(connectdir & SOUTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHWEST)))
			diagonalconnect |= 8

	icon_state = "catwalk[connectdir]-[diagonalconnect]"

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.isOn())
			if(WT.use_tool(src, user, 40, volume=100))
				new /obj/item/stack/rods(src.loc)
				new /obj/item/stack/rods(src.loc)
				new /obj/structure/lattice(src.loc)
				qdel(src)
	if (istype(C, /obj/item/wirecutters))
		qdel(src)
		new /obj/item/stack/rods(src.loc)
	return ..()

/obj/structure/catwalk/Crossed()
	. = ..()
	if(isliving(usr))
		playsound(src, pick('StarTrek13/sound/trek/catwalk1.ogg', 'StarTrek13/sound/trek/catwalk2.ogg', 'StarTrek13/sound/trek/catwalk3.ogg', 'StarTrek13/sound/trek/catwalk4.ogg', 'StarTrek13/sound/trek/catwalk5.ogg'), 25, 1)



/*

#define CHEST 1

#define BACK 2

#define POCKETS 3

#define EARS 4

#define BELT 5

#define HANDS 6

#define ID 7

#define HEAD 8

/obj/machinery/bodyscanner
	name = "full body scanner"
	desc = "A scanning device which can detect contraband, configure it using a console, link it to a console with a multitool"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "metaldetector"
	use_power = 1
	idle_power_usage = 200
	layer = 4.5
	density = 0
	dir = 4 //default to the sidescanner
	var/list/scan_for = list(/obj/item)
	var/active = 1
	var/SIDE_SCANNER = 1 // are we a side facing scanner?
	var/scanning = 0

/obj/machinery/bodyscanner/Crossed(atom/movable/mover as mob)
	if(active)
		src.say("scanning")
		scan(mover)

/obj/machinery/bodyscanner/proc/scan(mob/living/A)
	if(istype(A, /mob/living/carbon/human))
		var/theitem = pick(scan_for)
		update_icon(A)
		var/mob/living/carbon/human/L = A
		for(var/obj/I in L.contents)
			if(istype(I, theitem))
				if(I in L.back.contents)
					update_icon(L,BACK)
				if(I in L.ears)
					update_icon(L,HEAD)
				if(I in L.l_store || L.r_store)
					update_icon(L,POCKETS)
				if(I in L.l_hand || L.r_hand)
					update_icon(L,HANDS)
				if(I in L.head || L.wear_mask)
					update_icon(L,HEAD)
				if(I in L.belt.contents || L.belt)
					update_icon(L,POCKETS)
				if(I in L.wear_id)
					update_icon(L,POCKETS)
					playsound(src.loc, 'StarTrek13/sound/borg/machines/alertbuzz.ogg', 100,1)
				return 1
	if(istype(A, /mob/living/carbon/monkey))
		return
	if(istype(A, /mob/living/silicon))
		return

/obj/machinery/bodyscanner/update_icon(mob/living/L,zone)
	overlays.Cut()
	switch(zone)
		if(CHEST)//Chest
			overlays += image('StarTrek13/icons/trek/star_trek.dmi', "zone_chest", dir = L.dir)
		if(BACK)//Chest
			overlays += image('StarTrek13/icons/trek/star_trek.dmi', "zone_back", dir = L.dir)
		if(POCKETS)//Chest
			overlays += image('StarTrek13/icons/trek/star_trek.dmi', "zone_pockets", dir = L.dir)
		if(EARS)//Chest
			overlays += image('StarTrek13/icons/trek/star_trek.dmi', "zone_ears", dir = L.dir)
		if(BELT)//Chest
			overlays += image('StarTrek13/icons/trek/star_trek.dmi', "zone_legs", dir = L.dir)
		if(ID)//Chest
			overlays += image('StarTrek13/icons/trek/star_trek.dmi', "zone_pockets", dir = L.dir)
		if(HEAD)//Chest
			overlays += image('StarTrek13/icons/trek/star_trek.dmi', "zone_head", dir = L.dir)
#undef CHEST

#undef BACK

#undef POCKETS

#undef EARS

#undef BELT

#undef HANDS

#undef ID

#undef HEAD

*/
