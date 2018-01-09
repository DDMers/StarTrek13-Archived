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

/obj/item/device/generator_fan
	name = "attachable fan"
	desc = "Attach this to a shield generator to prevent heat overloads."
	var/fanhealth = 100
	var/fanmax = 70
	var/fanmin = 0
	var/fancurrent = 0

/obj/machinery/space_battle/shield_generator
	name = "shield generator"
	desc = "An advanced shield generator, producing fields of rapidly fluxing plasma-state phoron particles."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "ecm"
	use_power = 1
	var/list/shields = list()
	var/list/active_shields = list()
	var/list/inactive_shields = list()
	var/shields_maintained = 0
	var/inactivity_time = 0
	idle_power_usage = 200
	var/on = FALSE
	var/controller = null
	var/health_addition = 1050 // added to shipsystem shields.
	var/max_health_addition = 1050
	var/flux_rate = 100
	var/flux = 1
	var/heat = 0
	var/regen = 0
	var/obj/structure/overmap/ship = null
	var/datum/shipsystem/shields/shield_system = null
//	var/efficiency = 1
//	var/heat_capacity = 20000
//	var/conduction_coefficient = 0.3
//	var/list/datum/gas_mixture/airs
//	var/temperature = 0
//	var/connected = 1

	var/obj/item/device/generator_fan/current_fan = null // lowers heat

/obj/machinery/space_battle/shield_generator/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/device/generator_fan))
		if(!current_fan)
			W.loc = src
			current_fan = W
			return
	..()

/obj/machinery/space_battle/shield_generator/proc/calculate()
	for(var/obj/effect/adv_shield/S in shields)
		S.health += regen

/obj/machinery/space_battle/shield_generator/process()
	if(!shield_system)
		return
	if(shield_system.failed)
		var/obj/effect/adv_shield/SH = pick(shields)
	//	STOP_PROCESSING(SSobj, src)
		for(var/obj/effect/adv_shield/AB in shields)
			if(SH.health <= 2000)
				AB.health += 50+flux_rate //slowly recharge
				ship.shields_active = FALSE
				return
	flux_rate = flux*100
	regen = (flux*flux_rate)
	var/obj/effect/adv_shield/SH = pick(shields)
	for(var/obj/effect/adv_shield/S in shields)
		if(SH.active)
			S.regen = regen
	if(SH.active && !SH.density) //Active means the shieldgen is turning  it on, if it's not active the shieldgen cut it off
		if(SH.health <= 2000) //once they go down, they must charge back up a bit
			for(var/obj/effect/adv_shield/A in shields)
				A.health += 50 //slowly recharge
				ship.shields_active = FALSE
		else //problem here
			for(var/obj/effect/adv_shield/A in shields)
				A.activate()
				ship.shields_active = TRUE
	if(SH.active) //we are active
		ship.shields_active = TRUE
		if(SH.health < SH.maxhealth)
			for(var/obj/effect/adv_shield/A in shields)
				A.health += regen
		//	health += regen
		else
			return
		if(SH.health <= 0)
			for(var/obj/effect/adv_shield/A in shields)
				A.health = 0
				ship.shields_active = 0
				A.deactivate()
	else if(!SH.active)
		for(var/obj/effect/adv_shield/A in shields)
			A.deactivate()
	if(current_fan)
		if(current_fan.fancurrent > 0)
			if(shield_system.heat)
				shield_system.heat -= current_fan.fancurrent/10
				current_fan.fanhealth -= current_fan.fancurrent*0.50
			if(current_fan.fancurrent > 3)
				if(current_fan.fanhealth < -50) // maintain your fans!
					explosion(get_turf(src), 0, 4, 4, flame_range = 14)
//	calculate()

/obj/effect/adv_shield/proc/percentage(damage)
	var/counter
	var/percent = health
//	for(var/obj/effect/adv_shield/S in generator.shields)
//		percent += S.health
//		maxhealth += maxhealth
	counter = maxhealth
	percent = percent/counter
	percent = percent*100
	generator.say("Shields are buckling, absorbed: [damage]: Shields at [percent]%")
	playsound(src.loc, 'StarTrek13/sound/borg/machines/bleep2.ogg', 100,1)
	return

/obj/machinery/space_battle/shield_generator/attack_hand(mob/user)
	if(shield_system.failed)
		to_chat(user, "Shield Systems have failed.")
		return
	var/obj/machinery/space_battle/shield_generator/s = ""

	s += "<B>CONTROL PANEL</B><BR>"

	s += "<A href='?src=\ref[src];toggle=1;clicker=\ref[user]'>Toggle Power</A><BR><BR>"

	s += "Fan Power: [current_fan ? current_fan.fancurrent : "?"]<BR>"
	s += "<A href='?src=\ref[src];fandecrease=1;clicker=\ref[user]'>-</A> -------- <A href='?src=\ref[src];fanincrease=1;clicker=\ref[user]'>+</A><BR><BR>"

	s += "<B>STATISTICS</B><BR>"
	s += "Shields Maintained: [shields_maintained]<BR>"
	s += "Flux Rate: [flux_rate]<BR>"
	s += "Power Usage: [idle_power_usage]<BR>"
	s += "Heat: [heat]<BR>"
	if(current_fan)
		s += "Fan Utility: [current_fan.fanhealth]"

	var/datum/browser/popup = new(user, "Shield Generator Options", name, 360, 350)
	popup.set_content(s)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	if(user.canUseTopic(src))
		addtimer(CALLBACK(src,/atom/proc/attack_hand, user), 20)

/obj/machinery/space_battle/shield_generator/Topic(href, href_list)
	..()
	var/client/user = locate(href_list["clicker"])
	if(href_list["toggle"] )
		toggle(user)
		return

	if(!current_fan)
		to_chat(user, "There are no fans attached to the shield generator.")
		return

	// TODO: Add cool sound effects
	// For future coders: current_fan is meant to be hidden. you're suppose t
	if(href_list["fandecrease"])
		current_fan.fancurrent = max(current_fan.fanmin, current_fan.fancurrent - 5)

	if(href_list["fanincrease"])
		current_fan.fancurrent = min(current_fan.fanmax, current_fan.fancurrent + 5)

/obj/machinery/space_battle/shield_generator/proc/toggle(mob/user)
	if(shield_system.failed)
		to_chat(user, "Shield Systems have failed.")
		return
	if(on)
		to_chat(user, "shields dropped")
		on = 0 //turn off
		for(var/obj/effect/adv_shield/S in shields)
			S.deactivate()
			S.active = 0
			ship.shields_active = 0
		shield_system.integrity -= health_addition
		health_addition = max_health_addition
		return
	if(!on)
		var/sample
		if(!shields.len) //no shields, for some reason....
			sample = ship.shield_health
		for(var/obj/effect/adv_shield/S in shields)
			sample = S.health
		if(sample > 1000)
			to_chat(user, "shields activated")
			on = 1
			for(var/obj/effect/adv_shield/S in shields)
				S.activate()
				S.active = 1
				ship.shields_active = 1
			shield_system.integrity += min(shield_system.integrity + health_addition, shield_system.max_integrity)
			health_addition = 0
			return
		else
			on = 0
			to_chat(user, "error, shields regenerating after an attack")
			return

/obj/machinery/space_battle/shield_generator/New()
	..()
	initialize()

/obj/machinery/space_battle/shield_generator/proc/initialize()
	var/area/thearea = get_area(src)
//	var/i
//	var/datum/gas_mixture/A = new
//	A.volume = 200
//	airs[i] = A
	for(var/obj/effect/landmark/shield/marker in thearea)
		if(!marker in thearea)
			return
		var/obj/effect/adv_shield/shield = new(src)
		shield.dir = marker.dir
		shield.forceMove(get_turf(marker))
		shield.generator = src
		shield.icon_state = "shieldwalloff"
		shields += shield


/obj/machinery/space_battle/shield_generator/take_damage(var/damage, damage_type = PHYSICAL)
	src.say("Shield taking damage: [damage] : [damage_type == PHYSICAL ? "PHYSICAL" : "ENERGY"]")
	var/obj/effect/adv_shield/S = pick(shields)
	if(shield_system)
		shield_system.integrity -= damage
	if(current_fan)
		current_fan.fanhealth -= damage*0.10
	if(!S.density)
		return 0
	else
		S.take_damage(damage)
	return 1

/*
/obj/machinery/space_battle/shield_generator/process_atmos()
	..()
	if(!on)
		return
	var/datum/gas_mixture/air1 = airs[1]
	if(/*!nodes[1]*/!connected|| !airs[1] || !air1.gases.len || air1.gases[/datum/gas/oxygen][MOLES] < 5) // Turn off if the machine won't work.
		on = FALSE
		update_icon()
		return
	if(on)
		var/cold_protection = 0
		var/temperature_delta = air1.temperature - temperature // Heat generated - temperature of the gas mix
		if(abs(temperature_delta) > 1)
			var/air_heat_capacity = air1.heat_capacity()
			var/heat = ((1 - cold_protection) * 0.1 + conduction_coefficient) * temperature_delta * (air_heat_capacity * heat_capacity / (air_heat_capacity + heat_capacity))

			air1.temperature = max(air1.temperature - heat / air_heat_capacity, TCMB)
			temperature = max(heat / heat_capacity, TCMB)

		air1.gases[/datum/gas/oxygen][MOLES] -= 0.5 / efficiency // Magically consume gas? why not, I don't get atmos code

*/


		//S.calculate()
//	to_chat(world, "calculating:")
//	to_chat(world, "regen rate[regen]")
//	to_chat(world, "maxhealth: [S.maxhealth]")
//	to_chat(world, "health: [S.health]")
	//to_chat(world, "________________")


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

/obj/effect/adv_shield/New()
	. = ..()
	var/area/thearea = get_area(src)
	for(var/obj/machinery/power/ship/phaser/P in thearea)
		if(!P in thearea)
			return
		for(var/obj/item/gun/shipweapon/W in P.contents)
			if(!istype(W))
				return
			friendly += W //link a phaser in, these phasers can through shields
		for(var/obj/structure/photon_torpedo/A in thearea)
			friendly += A
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
	percentage(damage)
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
			percentage(amount)
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

/obj/item/gun/shipweapon/New()
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
	current_target = target
	active = 1
	current_beam = new(source,current_target,time=30,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
	spawn(0)
		current_beam.Start()

	//feedback_add_details("gun_fired","[src.type]")

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

/obj/item/gun/shipweapon/proc/on_beam_release(var/atom/target)
	return

/obj/effect/ebeam/phaser
	name = "high density photon beam"
	var/datum/effect_system/trail_follow/ion/ion_trail
//	max_distance = "5000"

/obj/effect/ebeam/phaser/New()
	..()
	ion_trail = new
	ion_trail.set_up(src)

/obj/item/circuitboard/machine/phase_cannon
	name = "phaser array circuit board"
	build_path = /obj/machinery/borg/ftl
	req_components = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 2)
/obj/machinery/power/ship/phaser
	name = "phaser array"
	desc = "A powerful weapon designed to take down shields.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon = 'StarTrek13/icons/trek/phaser.dmi'
	icon_state = "phaserarray"
	anchored = 1
	dir = 4
	density = 0
	pixel_x = -64
	var/charge = 1000 //current power levels
	var/charge_rate = 300
	var/state = 1
	var/locked = 0
	var/obj/item/gun/shipweapon/phaser
	var/obj/structure/cable/attached		// the attached cable
	var/max_power = 1000		// max power it can hold
	var/fire_cost = 700
	var/percentage = 0 //percent charged
	var/list/shipareas = list()
	var/target = null
	var/obj/machinery/space_battle/shield_generator/shieldgen
	var/damage = 500

/obj/machinery/power/ship/phaser/opposite
	dir = 8
	pixel_x = 64

//obj/machinery/power/ship/phaser/attack_hand(mob/user)
//	to_chat(user, "input now")
//	input_target(user)

/obj/machinery/power/ship/phaser/proc/input_target(mob/user) //unused now
	var/A
	A = input("Area to fire on", "Open Fire", A) as anything in shipareas
	var/area/thearea = shipareas[A]
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T
	var/location = pick(L)
	attempt_fire(location)

//	explosion(loc,2,5,11)

/*
	var/obj/ship_marker/A = shipcores[B]
	var/area/thearea = get_area(A)
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T
	var/loc = pick(L)
*/


/obj/machinery/power/ship/phaser/examine(mob/user)
	. = ..()
	percentage = (charge / max_power) * 100
	to_chat(user, "it is [percentage]% full")

/obj/machinery/power/ship/phaser/process()
	if(!attached)
	//	state = 0
		return
	var/datum/powernet/PN = attached.powernet
	if(PN)
		// found a powernet, so drain up to max power from it
		percentage = (charge / max_power) * 100
		var/drained = min ( charge_rate, PN.avail )
		PN.load += drained
		charge += drained
		if(drained < charge_rate)
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				if(istype(T.master, /obj/machinery/power/apc))
					var/obj/machinery/power/apc/A = T.master
					if(A.operating && A.cell)
						A.cell.charge = max(0, A.cell.charge - 50)
						charge += 50
						if(A.charging == 2) // If the cell was full
							A.charging = 1 // It's no longer full

/obj/machinery/power/ship/phaser/New()
	..()
	var/obj/item/circuitboard/machine/B = new /obj/item/circuitboard/machine/phase_cannon(null)
	B.apply_default_parts(src)
	RefreshParts()
	phaser = new /obj/item/gun/shipweapon(src)
	phaser.mounted = 1
	find_cores()
	find_generator()

/obj/machinery/power/ship/phaser/proc/find_generator()
	var/area/thearea = get_area(src)
	for(var/obj/machinery/space_battle/shield_generator/S in thearea)
		shieldgen = S

/obj/machinery/power/ship/phaser/proc/find_cores()
	var/area/thearea = get_area(src)
	for(var/area/AR in world)
		if(istype(AR, /area/ship)) //change me
			shipareas += AR.name
			shipareas[AR.name] = AR
			if(AR == thearea)
				shipareas -= AR.name
				shipareas[AR.name] = null
	if(shipareas.len)
		src.say("Target located")
	else
		src.say("No warp signatures detected")
	for(var/obj/structure/fluff/helm/desk/tactical/T in thearea)
		if(!src in T.weapons)
			T.weapons += src

/obj/machinery/power/ship/phaser/proc/can_fire()
	if(state == 1)
		if(charge >= 200)
			return 1
		else
			return 0
	else
		return 0

/obj/machinery/power/ship/phaser/proc/attempt_fire(atom/target) //TEST remove /atom if no work
	find_generator()
	if(can_fire())
		phaser.LoseTarget()
		charge -= fire_cost
		phaser.current_target = target
		phaser.process_fire(target = target,  source = src)
	else
		src.say("error")
		return 0

//DEFINE TARGET

/area/ship
	name = "USS Cadaver"
	icon_state = "ship"
	requires_power = 0 //fix
	has_gravity = 1
	noteleport = 0
	blob_allowed = 0 //Should go without saying, no blobs should take over centcom as a win condition.

/area/ship/bridge
	name = "A starship bridge"
	icon_state = "ship"

/area/ship/engineering
	name = "A starship engineering"
	icon_state = "ship"

/area/ship/overmap/starbase
	name = "starbase 1"
	icon_state = "ship"

/area/ship/target
	name = "USS Entax"
	icon_state = "ship"


/area/ship/nanotrasen
	name = "NSV Muffin"
	icon_state = "ship"

/area/ship/nanotrasen/freighter
	name = "NSV Crates"
	icon_state = "ship"

/area/ship/nanotrasen/capital_class
	name = "NSV Annulment"
	icon_state = "ship"

/area/ship/overmap/nanotrasen
	name = "Nanotrasen station"
	icon_state = "ship"

/area/ship/overmap/nanotrasen/research
	name = "NSV Woolf research outpost"
	icon_state = "ship"

/area/ship/overmap/nanotrasen/trading_outpost
	name = "NSV Mercator trade station."
	icon_state = "ship"



/obj/ship_marker
	invisibility = INVISIBILITY_ABSTRACT
	icon = 'icons/obj/device.dmi'
	//icon = 'icons/dirsquare.dmi'
	icon_state = "pinonfar"
	name = "ship core"
	resistance_flags = ACID_PROOF
	anchored = 1

/obj/ship_marker/bridge
	name = "bridge"

/obj/ship_marker/crew
	name = "crew quaters"


/obj/structure/fluff/helm/desk
	name = "desk computer"
	desc = "A generic deskbuilt computer"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "desk"
	anchored = TRUE
	density = 1 //SKREE
	opacity = 0
	layer = 4.5

/obj/structure/fluff/helm/desk/tactical
	name = "tactical"
	desc = "A computer built into a desk, showing ship manifests, weapons, tactical systems, anything you could want really, the manifest shows a long list but the 4961 irradiated haggis listing catches your eye..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "desk"
	anchored = TRUE
	density = 1 //SKREE
	opacity = 0
	layer = 4.5
	var/list/weapons = list()
	var/list/redalertsounds = list('StarTrek13/sound/borg/machines/redalert.ogg','StarTrek13/sound/borg/machines/redalert2.ogg')
	var/target = null
	var/cooldown2 = 190 //18.5 second cooldown
	var/saved_time = 0
	var/list/shipareas = list()
	var/obj/machinery/space_battle/shield_generator/shieldgen
	var/REDALERT = 0
	var/redalertsound
	var/area/target_area = null
	var/list/torpedoes = list()
	var/obj/structure/overmap/theship = null

/obj/structure/fluff/helm/desk/tactical/nanotrasen
	name = "tactical"
	desc = "Used to control all ship functions...this one looks slightly retro."
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"


/obj/structure/fluff/helm/desk/tactical/process()
	var/area/thearea = get_area(src)
	get_weapons()
	if(world.time >= saved_time + cooldown2)
		saved_time = world.time
		for(var/mob/M in thearea)
			M << redalertsound

/obj/structure/fluff/helm/desk/tactical/New()
	. = ..()
	get_weapons()
	get_shieldgen()
//	var/area/thearea = get_area(src)
	for(var/area/AR in world)
		if(istype(AR, /area/ship)) //change me
			shipareas += AR.name
			shipareas[AR.name] = AR

/obj/structure/fluff/helm/desk/tactical/proc/get_shieldgen()
	var/area/thearea = get_area(src)
	for(var/obj/machinery/space_battle/shield_generator/S in thearea)
		shieldgen = S
		S.controller = src
		return 1
	return 0


/obj/structure/fluff/helm/desk/tactical/proc/get_weapons()
	weapons = list()
	torpedoes = list()
	var/area/thearea = get_area(src)
	for(var/obj/machinery/power/ship/phaser/P in thearea)
		weapons += P
	for(var/obj/structure/torpedo_launcher/T in thearea)
		torpedoes += T

/obj/structure/fluff/helm/desk/tactical/attack_hand(mob/user)
	get_weapons()
	get_shieldgen()
	var/area/current = get_area(src)
	for(var/area/AR in world)
		if(istype(AR, /area/ship)) //change me
			if(!AR in shipareas)
				shipareas += AR.name
				shipareas[AR.name] = AR
				if(AR == current)
					shipareas -= AR.name
					shipareas -= AR
	var/mode = input("Tactical console.", "Do what?")in list("fly ship", "remove pilot", "shield control", "red alert siren","fire torpedo","turret control")
	switch(mode)
		if("choose target")
			theship.exit(user)
		//	var/A
	//		A = input("Area to fire on", "Tactical Control", A) as anything in shipareas
	//		target_area = shipareas[A]
	//		new_target()
	//		for(var/obj/machinery/power/ship/phaser/P in weapons)
	//			P.target = target
	//		for(var/obj/structure/torpedo_launcher/T in torpedoes)
	//			T.target = target
		if("fly ship")
			theship.enter(user)
		//	fire_phasers(target, user)
		if("shield control")
			shieldgen.toggle(user)
		if("red alert siren")
			redalertsound = pick(redalertsounds)
			if(REDALERT)
				src.say("RED ALERT DEACTIVATED")
				REDALERT = 0
				STOP_PROCESSING(SSobj,src)
			else
				src.say("RED ALERT ACTIVATED")
				REDALERT = 1
				START_PROCESSING(SSobj,src)
		if("fire torpedo")
			fire_torpedo(target,user)
		if("turret control")
			set_gun_turret_target(user)


/obj/structure/fluff/helm/desk/tactical/proc/fire_phasers(atom/target, mob/user)
	playsound(src.loc, 'StarTrek13/sound/borg/machines/bleep1.ogg', 100,1)
	for(var/obj/machinery/power/ship/phaser/P in weapons)
		P.target = target
	if(target != null)
		for(var/obj/machinery/power/ship/phaser/P in weapons)
			P.attempt_fire(target)
	else
		to_chat(user, "ERROR, no target selected")

/obj/structure/fluff/helm/desk/tactical/proc/fire_torpedo(turf/target,mob/user)
	for(var/obj/structure/torpedo_launcher/T in torpedoes)
		src.say("firing torpedoes at [target_area.name]")
		T.fire(target, user)
		playsound(src.loc, 'StarTrek13/sound/borg/machines/bleep2.ogg', 100,1)
		to_chat(user, "attempting to fire torpedoes")



/obj/structure/fluff/helm/desk/tactical/proc/new_target()
	var/list/L = list()
	for(var/turf/T in get_area_turfs(target_area.type))
		L+=T
	var/location = pick(L)
	target = location

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
	//var/obj/structure/torpedo_launcher/launcher

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
	loaded += AM
	AM.loc = src
	src.say("[AM] has been loaded into the tube")
	icon_state = "torpedolauncher-fire"

obj/structure/torpedo_launcher/New()
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

obj/structure/torpedo_launcher/proc/fire(atom/movable/target, mob/user)
	icon_state = "torpedolauncher"
	var/sound = pick(sounds)
	find_generator()
	playsound(src.loc, sound, 300,1)
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


/obj/machinery/shieldgen/wallmounted/process

//Par made some sick bridge sprites, nut on them and think of Par not me whilst you do

/obj/structure/fluff/ship
	name = "wall panel"
	desc = "a wall mounted screen"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "conduit"
	layer = 4.5
	anchored = 1
	density = 0
	can_be_unanchored = 0

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


/turf/closed/wall/ship
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/trek_wall.dmi'
	icon_state = "wall"
	smooth = 1
	canSmoothWith = list(/turf/closed/wall/ship,/obj/machinery/door/airlock/trek, /obj/structure/window, /obj/structure/window/trek, /turf/closed/wall/ship/light,/turf/closed/wall/ship/light/m,/turf/closed/wall/ship/steel,/obj/structure/window/trek/steel)


/turf/closed/wall/ship/steel
	name = "steel hull"
	desc = "a more dull and grey ship hull, how boring..."
	icon = 'StarTrek13/icons/trek/NT_trek_wall.dmi'
	icon_state = "wall"
	smooth = 1

/turf/closed/wall/ship/light
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "lightleft"

/turf/closed/wall/ship/light/m
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "lightmiddle"

/turf/closed/wall/ship/light/c2
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "lightright"

/turf/closed/wall/ship/flat
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "middleflat"

/turf/closed/wall/ship/flat/c1
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "leftflatcorner"

/turf/closed/wall/ship/flat/m
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "middleflat"

/turf/closed/wall/ship/flat/c2
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "rightflatcorner"

/turf/closed/wall/ship/light/New()
	. = ..()
	set_light(1)

/turf/closed/wall/ship/c1
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "leftcorner"

/turf/closed/wall/ship/m
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "middlecorner"

/turf/closed/wall/ship/c2
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "rightcorner"


/turf/closed/wall/ship/horiz
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "horizsmooth"


/turf/closed/wall/ship/light/horiz
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "lightleftup"

/turf/closed/wall/ship/light/horiz2
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "lightmiddleup"

/turf/closed/wall/ship/light/horiz3
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "lightrightup"


/obj/effect/mob_spawn/human/alive/trek
	icon_state = "sleeper"
	death = FALSE
	roundstart = FALSE
	outfit = /datum/outfit/job/crewman



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

/obj/structure/catwalk/New()
	. = ..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			warning("Duplicate [type] in [loc] ([x], [y], [z])")
			qdel(C)
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

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.isOn())
			if(WT.remove_fuel(0, user))
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