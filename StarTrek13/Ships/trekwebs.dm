//:b1: GET IT BECAUSE STAR TREK TECH WEBS HAHAHAHAHHAHA ~kmc//
/datum/techweb_node/ships
	id = "ships"
	starting_node = FALSE
	display_name = "Core Starship Technology"
	description = "Contains the materials needed to build most common starship components."
	design_ids = list("phaser_board", "phaser_prefire", "shield_board")			//Core starship upgrade components, also components to outfit new ships with tech.
	export_price = 5000
	prereq_ids = list("engineering")

/datum/techweb_node/transporter
	id = "transporter_tech"
	starting_node = FALSE
	display_name = "Transporter Technology"
	description = "Allows for the construction of new transporter systems"
	design_ids = list("transporter_control", "transporter_pad")			//Core starship upgrade components, also components to outfit new ships with tech.
	export_price = 5000
	prereq_ids = list("ships")

/obj/item/stock_parts/phaser_chamber
	name = "phaser prefire chamber"
	desc = "A specially designed, self contained module used in phaser banks which induces a plasma through a nadion effect into a tight beam of directed energy."
	icon_state = "phaserprefire"
	materials = list(MAT_METAL=3000, MAT_GLASS=100)

/obj/item/circuitboard/machine/trek
	name = "Isolinear Chip"
	desc = "A data storage module, which is the most elementry part of any modern computer system"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "isolinear"

/obj/item/circuitboard/computer/transporter_console
	name = "Transporter Console Logic Chip"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "isolinear3"
	build_path = /obj/machinery/computer/camera_advanced/transporter_control/huge

/obj/item/circuitboard/machine/trek/transporter
	name = "Transporter Pad Logic Chip"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "isolinear"
	build_path = /obj/machinery/trek/transporter
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/cell = 1,
		/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/machine/trek/phase_cannon
	name = "Weapons Control Module"
	desc = "Essential for the construction of phaser arrays, and most standard weapon systems."
	icon_state = "isolinear2"
	build_path = /obj/machinery/ship/phaser
	req_components = list(
		/obj/item/stock_parts/capacitor = 6,
		/obj/item/stock_parts/cell = 5,
		/obj/item/stock_parts/phaser_chamber = 1,
		/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/machine/trek/shield_generator
	name = "Weapons Control Module"
	desc = "Essential for the construction of phaser arrays, and most standard weapon systems."
	icon_state = "isolinear2"
	build_path = /obj/machinery/ship/phaser
	req_components = list(
		/obj/item/stock_parts/capacitor = 6,
		/obj/item/stock_parts/cell = 10,
		/obj/item/stack/cable_coil = 30)

/datum/design/board/phaser
	name = "Phaser array isolinear chip"
	desc = "The core piece of a phaser array"
	id = "phaser_board"
	build_path = /obj/item/circuitboard/machine/trek/phase_cannon
	category = list("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/shield
	name = "Shield generator isolinear chip"
	desc = "The core logic chip of a shield generator"
	id = "shield_board"
	build_path = /obj/item/circuitboard/machine/trek/shield_generator
	category = list("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/phaser_prefire
	name = "Phaser prefiring chamber"
	desc = "An essential component in phaser production, allowing for intake plasma to be fired as a high energy beam."
	id = "phaser_prefire"
	build_path = /obj/item/stock_parts/phaser_chamber
	category = list("Stock Parts")
	departmental_flags = DEPARTMENTAL_FLAG_ALL
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 100, MAT_GLASS = 100)
	lathe_time_factor = 0.2

/datum/design/board/transporter_comp
	name = "Transporter control chip"
	desc = "The central processor of any transporter computer"
	id = "transporter_control"
	build_path = /obj/item/circuitboard/computer/transporter_console
	category = list("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/transporter_pad
	name = "Transporter pad logic chip"
	desc = "An all in one logic system for transporter pads, containing their pattern buffers pre-installed"
	id = "transporter_pad"
	build_path = /obj/item/circuitboard/machine/trek/transporter
	category = list("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/obj/machinery/ship/phaser
	name = "phaser array"
	desc = "A powerful weapon designed to take down shields.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon = 'StarTrek13/icons/trek/phaser.dmi'
	icon_state = "phaserarray"
	dir = 4
	density = 0
	anchored = TRUE
	can_be_unanchored = TRUE
	var/charge = 2500 //buffed to match faster recharge speeds
	var/charge_rate = 100
	var/state = 1
	var/locked = 0
	var/obj/structure/cable/attached		// the attached cable
	var/max_power = 1000		// max power it can hold
	var/fire_cost = 200
	var/percentage = 0 //percent charged
	var/list/shipareas = list()
	var/target = null
	var/obj/machinery/space_battle/shield_generator/shieldgen
	var/damage = 400
	use_power = 1500

/obj/machinery/ship/phaser/opposite
	dir = 8
	pixel_x = 64

/obj/machinery/ship/phaser/examine(mob/user)
	. = ..()
	percentage = (charge / max_power) * 100
	to_chat(user, "it is [percentage]% full")

/obj/machinery/ship/phaser/RefreshParts()
	damage = 0
	charge_rate = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		damage += C.rating*60//rating of 1 is stock, rating of 4 gives insane power
	for(var/obj/item/stock_parts/cell/P in component_parts)
		charge_rate += (P.chargerate+50) //They were getting wayyyy heyy HEYYYYY too strong for my tastes alright?

/obj/machinery/ship/phaser/ex_act(severity)
	return 0

/obj/machinery/ship/phaser/process()
	RefreshParts()
	if(!powered())
		damage = 0
	else
		damage = initial(damage)

/obj/machinery/ship/phaser/Initialize(timeofday)
	. = ..()
	START_PROCESSING(SSmachines,src)
	var/obj/item/circuitboard/machine/trek/phase_cannon/B = new /obj/item/circuitboard/machine/trek/phase_cannon(src)
	B.apply_default_parts(src)
	RefreshParts()
	var/obj/structure/fluff/helm/desk/tactical/t = locate(/obj/structure/fluff/helm/desk/tactical) in get_area(src)
	if(t)
		if(t.theship && t.theship.SC)
			var/datum/shipsystem/weapons/S = t.theship.SC.weapons
			S.getphasers()

/obj/item/generator_fan
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
	var/obj/structure/overmap/ship = null
	var/datum/shipsystem/shields/shield_system = null
	use_power = 2000
	var/obj/item/generator_fan/current_fan = null // lowers heat
	var/chargerate = 500 //Balance me!
	anchored = TRUE
	can_be_unanchored = TRUE


/obj/machinery/space_battle/shield_generator/RefreshParts()
	chargerate = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		chargerate += C.rating*100 //rating of 1 is stock, rating of 4 gives insane power


/obj/machinery/space_battle/shield_generator/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/generator_fan))
		if(!current_fan)
			W.loc = src
			current_fan = W
			return
	..()

/obj/machinery/space_battle/shield_generator/ui_interact(mob/user)
	. = ..()
	if(user.stat == DEAD || istype(user, /mob/dead/observer))
		return
	if(shield_system.failed)
		to_chat(user, "Shield Systems have failed.")
		return
	var/dat = "<B>CONTROL PANEL</B><BR>"
	dat += "<A href='?src=\ref[src];toggle=1;clicker=\ref[user]'>Toggle Power</A><BR><BR>"

	dat += "Fan Power: [current_fan ? current_fan.fancurrent : "?"]<BR>"
	dat += "<A href='?src=\ref[src];fandecrease=1;clicker=\ref[user]'>-</A> -------- <A href='?src=\ref[src];fanincrease=1;clicker=\ref[user]'>+</A><BR><BR>"

	dat += "<B>STATISTICS</B><BR>"
	dat += "Shields Maintained: [shields_maintained]<BR>"
	dat += "Power Usage: [use_power]<BR>"
	if(current_fan)
		dat += "Fan Utility: [current_fan.fanhealth]"

	var/datum/browser/popup = new(user, "Shield Generator Options", name, 360, 350)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/space_battle/shield_generator/Topic(href, href_list)
	..()
	var/client/user = locate(href_list["clicker"])
	if(href_list["toggle"])
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

/obj/machinery/space_battle/shield_generator/process()
	RefreshParts()

/obj/machinery/space_battle/shield_generator/proc/toggle(mob/user)
	if(shield_system.failed)
		to_chat(user, "Shield Systems have failed.")
		return
	if(on)
		to_chat(user, "shields dropped")
		ship.SC.shields.toggled = FALSE
		on = 0 //turn off
		for(var/obj/effect/adv_shield/S in shields)
			S.deactivate()
			S.active = 0
		ship.SC.shields.active = FALSE
		return
	if(!on)
		if(ship.SC.shields.integrity >= 5000)
			to_chat(user, "shields activated")
			on = 1
			ship.SC.shields.toggled = TRUE
			for(var/obj/effect/adv_shield/S in shields)
				S.activate()
				S.active = 1
			return
		else
			on = 0
			to_chat(user, "error, shields have failed!")
			return

/obj/machinery/space_battle/shield_generator/Initialize(timeofday)
	. = ..()
	START_PROCESSING(SSmachines,src)
	var/obj/item/circuitboard/machine/trek/shield_generator/B = new /obj/item/circuitboard/machine/trek/shield_generator(src)
	B.apply_default_parts(src)
	RefreshParts()

/obj/machinery/space_battle/shield_generator/take_damage(var/damage)
	if(shield_system)
		shield_system.integrity -= damage
	if(current_fan)
		current_fan.fanhealth -= damage*0.10
	return 1