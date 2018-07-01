
/turf/closed/wall/borg
	name = "assimilated wall"
	desc = "A wall with odd parts, pipes and green LEDs bolted to it."
	icon = 'StarTrek13/icons/borg/borg_wall.dmi'
	icon_state = "wall"
	smooth = SMOOTH_FALSE //change this when I make a smoothwall proper version

/turf/open/floor/borg
	name = "assimilated floor"
	desc = "A deck plate with odd parts, pipes and green LEDs bolted to it."
	icon_state = "xelfloor"
	smooth = SMOOTH_FALSE //change this when I make a smooth proper version


/turf/open/floor/borg/trek
	name = "deck plates"
	desc = "A big lump of metal to keep you from falling through the ship."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "trek"
	smooth = FALSE
	//canSmoothWith = list(/turf/open/floor/borg/trek,/turf/open/floor/borg/trek/light,/turf/open/floor/borg/trek/blue,/turf/open/floor/borg/trek/red,/turf/open/floor/borg/trek/dark,/turf/open/floor/borg/trek/beige)


/turf/open/floor/borg/trek/light
	name = "carpet"
	desc = "A carpeted floor that matches the surroundings."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "trek3"
	smooth = SMOOTH_FALSE //change this when I make a smooth proper version

/turf/open/floor/borg/trek/blue
	name = "blue carpet"
	desc = "A carpeted floor that matches the surroundings."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "trek4"
	smooth = FALSE //change this when I make a smooth proper version
//	canSmoothWith = list(/turf/open/floor/borg/trek/blue)

/turf/open/floor/borg/trek/red
	name = "red carpet"
	desc = "A carpeted floor that matches the surroundings."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "trek2"
	smooth = SMOOTH_FALSE //change this when I make a smooth proper version


/turf/open/floor/borg/trek/dark
	name = "carpet"
	desc = "A carpeted floor that matches the surroundings."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "trekfloor"
	smooth = SMOOTH_FALSE //change this when I make a smooth proper version

/turf/open/floor/borg/trek/beige
	name = "carpet"
	desc = "A carpeted floor that matches the surroundings."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "trek5"
	smooth = SMOOTH_FALSE //change this when I make a smooth proper version

/obj/machinery/door/airlock/trek
	name = "airlock"
	icon = 'StarTrek13/icons/trek/door_trek.dmi'
	icon_state = "closed"
	doorOpen = 'StarTrek13/sound/borg/machines/tngdooropen.ogg'
	doorClose = 'StarTrek13/sound/borg/machines/tngdoorclose.ogg'
	boltUp = 'StarTrek13/sound/borg/machines/tngchime.ogg' // i'm thinkin' Deni's
	doorDeni = 'StarTrek13/sound/borg/machines/tngchime.ogg'
	boltDown = 'StarTrek13/sound/borg/machines/tngchime.ogg'
	overlays_file = 'StarTrek13/icons/trek/door_trek.dmi'
	layer = 4.5
	open_door_layer = 4.5 //so people go below it for added coolness
	closed_door_layer = CLOSED_DOOR_LAYER

/obj/structure/fluff/helm/desk/noisy //makes star trek noises!
	name = "captain's display"
	desc = "An LCARS display showing all shipboard systems, status: NOMINAL"
	var/datum/looping_sound/trek/bridge/soundloop
	icon_state = "miniconsole"

/obj/structure/fluff/helm/desk/captain2 //makes star trek noises!
	name = "captain's display"
	desc = "An LCARS display showing all shipboard systems, status: NOMINAL"
	icon_state = "miniconsole"

/obj/structure/fluff/helm/desk/noisy/New()
	. = ..()
	soundloop = new(list(src), TRUE)


/obj/structure/sign/viewscreen
	icon = 'StarTrek13/icons/borg/borg.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = SIGN_LAYER
	name = "viewscreen"

/obj/structure/fluff/helm/desk/noisy/Destroy()
	. = ..()
	QDEL_NULL(soundloop)


/obj/structure/sign/viewscreen/lcars
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	layer = SIGN_LAYER
	icon_state = "lcars"

/obj/structure/sign/viewscreen/lcars_tactical
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	layer = SIGN_LAYER
	icon_state = "lcars2"

/obj/structure/sign/viewscreen/lcars_redalert
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	layer = SIGN_LAYER
	icon_state = "redalertlcars"




//Coding standards? what the hell are those//


/obj/item/clothing/under/trek/captrek
	name = "captain's suit"
	desc = "A stylish jumpsuit worn by the captain, waaaaait a minute you've seen this before somewhere."
	icon_state = "capttrek"
	item_color = "capttrek"
	can_adjust = 1

/obj/item/clothing/under/trek/hostrek
	name = "security officer's jumpsuit"
	desc = "A stylish jumpsuit worn by the security team, waaaaait a minute you've seen this before somewhere."
	icon_state = "hostrek"
	item_color = "hostrek"
	can_adjust = 1

/obj/item/clothing/under/trek/medtrek
	name = "medical officer's jumpsuit"
	desc = "A stylish jumpsuit worn by the medical and science staff, waaaaait a minute you've seen this before somewhere."
	icon_state = "scitrek"
	item_color = "scitrek"
	can_adjust = 1

/obj/item/clothing/under/trek/greytrek
	name = "cadet jumpsuit"
	desc = "A stylish jumpsuit given to those officers still in training, otherwise known as assistants, waaaaait a minute you've seen this before somewhere."
	icon_state = "greytrek"
	item_color = "greytrek"
	can_adjust = 1

/obj/item/clothing/under/trek/comttrek
	name = "command officer's jumpsuit"
	desc = "A stylish jumpsuit worn by the heads of staff, waaaaait a minute you've seen this before somewhere."
	icon_state = "comttrek"
	item_color = "comttrek"
	can_adjust = 1


/obj/machinery/computer/shuttle/white_ship/trek
	name = "Helm Control"
	desc = "make it so."
	shuttleId = "trekship"
	possible_destinations = "trek_custom"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	anchored = TRUE
	density = 1
	opacity = 0
	layer = 4.5
	icon_keyboard = null
	icon_screen = null

/obj/machinery/computer/shuttle/white_ship/trek/attackby()
	return 0

/obj/machinery/computer/shuttle/white_ship/trek/emp_act()
	return 0

/obj/docking_port/mobile/trek //aaaa
	name = "uss something xd"
	id = "trekship"
	dwidth = 14
	height = 22
//	travelDir = 180
	dir = 2
	width = 35
	dheight = 0
/*
	dwidth = 20
	dheight = 0
	width = 38
	height = 19
	dir = 8
*/

/obj/machinery/computer/camera_advanced/shuttle_docker/trek
	name = "Helm Control"
	z_lock = 1
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	shuttleId = "trekship"
	shuttlePortId = "trek_custom"
	shuttlePortName = "warp beacon"
	jumpto_ports = list("trekshipaway", "syndicate_ne", "syndicate_nw", "trek_custom", "syndicate_se", "syndicate_sw", "syndicate_s")
	x_offset = 0
	y_offset = 3
	rotate_action = null
	anchored = TRUE
	density = 1
	opacity = 0
	layer = 4.5
	icon_keyboard = null
	icon_screen = null
	rotate_action = null
	dir = 8
//	view_range = 20 DO NOT CHANGE THIS BREAKS SHIT


/obj/machinery/computer/camera_advanced/shuttle_docker/trek/attackby()
	return 0

/obj/machinery/computer/camera_advanced/shuttle_docker/trek/emp_act()
	return 0

/obj/machinery/computer/camera_advanced/shuttle_docker/trek/checkLandingTurf(turf/T)
	return ..() && isspaceturf(T) //dont crash the fukken ship wesley FUCKING



/obj/machinery/computer/shuttle/white_ship/trek/shuttlepod
	name = "Helm Control"
	desc = "make it so."
	shuttleId = "trekshuttle"
	possible_destinations = "trekshuttlestarbase;trekshuttlecadaver"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	anchored = TRUE
	density = 1
	opacity = 0
	layer = 4.5
	icon_keyboard = null
	icon_screen = null

/obj/docking_port/mobile/trek/shuttlepod //aaaa
	name = "shuttlepod 1"
	id = "trekshuttle"
	dwidth = 6
	height = 7
//	travelDir = 180
	dir = 1
	width = 9
	dheight = 3


/turf/closed/trekshield
	name = "interior shields"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "shield"
	blocks_air = 1
	density = 0
	opacity = 0

/turf/closed/trekshield/CanPass(atom/movable/AM)
	return 1

/turf/closed/trekshield/CanAtmosPass()
	if(density)
		return 0
	return 1

/turf/closed/trekshield/attackby()
	return 0

/obj/item/clothing/combadge
	name = "combadge"
	desc = "A clip on communication device, alt click it to broadcast, ctrl click it to mute the radio."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "combadge"
	item_state = ""	//no inhands
	item_color = "combadge"
	slot_flags = 15
	w_class = 2
	var/obj/item/device/radio/embedded
	actions_types = list(/datum/action/item_action/combadge,/datum/action/item_action/combadge/turn_off)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/datum/action/item_action/combadge/broadcast_action = new
	var/datum/action/item_action/combadge/turn_off/mute_action = new

/datum/action/item_action/combadge
	name = "toggle combadge broadcast"

/datum/action/item_action/combadge/turn_off
	name = "toggle combadge receive"

/obj/item/clothing/combadge/attackby(obj/item/W)
	if(istype(W, /obj/item/screwdriver))
		return embedded.attackby(W)
	else
		return

/obj/item/clothing/combadge/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/combadge)
		activate(user)
	else if(actiontype == /datum/action/item_action/combadge/turn_off)
		deactivate(user)

/obj/item/clothing/combadge/tie/CtrlClick(mob/user)
	deactivate(user)

/obj/item/clothing/combadge/tie/AltClick(mob/user)
	activate(user)

/obj/item/clothing/combadge/proc/activate(mob/user)
	playsound(loc, 'StarTrek13/sound/borg/machines/combadge.ogg', 50, 1)
	if(embedded.broadcasting)
		embedded.broadcasting = 0
		user << "Combadge broadcasting disabled."
	else
		embedded.broadcasting = 1
		user << "Combadge broadcasting enabled."

/obj/item/clothing/combadge/proc/deactivate(mob/user)
	playsound(loc, 'StarTrek13/sound/borg/machines/combadge.ogg', 50, 1)
	if(embedded.listening)
		embedded.listening = 0
		user << "Disabled combadge radio receiver."
	else
		embedded.listening = 1
		user << "Enabled combadge radio receiver."

/obj/item/clothing/combadge/New()
	. = ..()
	embedded = new/obj/item/device/radio(src)

//tricord//

#define NO_SCANNER 0
#define HAS_SCANNER 1
#define OPEN 1
#define CLOSED 0
#define MEDICAL_MODE 1
#define SCIENCE_MODE 2

//tricorder scanner.Doesn't actually do anything, it's just required to be able to scan.
/obj/item/weapon/tricordscanner
	name = "tricorder scanner"
	desc = "A tricorder scanner. Hold a tricorder in one hand to recieve the results."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "tricorder_scn"
	w_class = 1
	var/obj/item/device/t_scanner/rayscan //attack
	var/obj/item/device/t_scanner/adv_mining_scanner/miningscan //attackself
	var/obj/item/device/analyzer/gasscan //attackself
	var/obj/item/device/detective_scanner/detscan //attackself to print, afterattack to scan
	var/medical = 0
	var/obj/machinery/computer/camera_advanced/transporter_control/transporter_controller

/obj/item/weapon/tricordscanner/New()
	. = ..()
	rayscan = new /obj/item/device/t_scanner(src)
	miningscan =  new /obj/item/device/t_scanner/adv_mining_scanner(src) //attackself
	gasscan = new /obj/item/device/analyzer(src) //attackself
	detscan = new /obj/item/device/detective_scanner(src) //attackself to print, afterattack to scan

/obj/item/weapon/tricordscanner/proc/tricorder_med()


/obj/item/weapon/tricordscanner/afterattack(atom/I, mob/user)
	medical = 0
	if(istype(I, /obj/item/device/tricorder))
		return I.attackby(src, user)
	if(tricorder_science_mode(I, user))
		var/B
		B = input(user, "Select mode:","Tricorder scanner",B) in list("t ray scanner","mining scanner","gas analyzer","detective scanner","transporter tag", "cancel") //this is broken
		switch(B)
			if("t ray scanner")
				rayscan.attack_self(user)
			if("mining scanner")
				miningscan.attack_self(user)
			if("gas analyzer")
				gasscan.attack_self(user)
			if("detective scanner")
				detscan.scan(I, user)
				sleep(40)
				detscan.attack_self(user)
			if("transporter tag")
				if(!I in transporter_controller.retrievable)
					to_chat(user,"[I] has been tagged for transportation and can now be beamed up")
					transporter_controller.retrievable += I
				else
					to_chat(user,"[I] has already been tagged for transportation.")
			if("cancel")
				return
	else if(medical)
		if(ismob(I))
			var/mob/living/M = I
			healthscan(user, M)
			chemscan(user, M)
			medical = 0
			return
		else
			return
	else
		user << "You need a tricorder set to science mode in your inventory to use this!"
	//	if(!B.len)
	//		. = ..()

/obj/item/weapon/tricordscanner/proc/tricorder_science_mode(atom/I, mob/living/carbon/human/user)
//	var/obj/item/weapon/tricordscanner/F
	for(var/obj/item/device/tricorder/T in user.contents)
		if(!istype(T))
			return 0
		if(T.open == CLOSED)
			return 0
		if(T.setting == MEDICAL_MODE)
			medical = 1
			return 0
		//	healthscan(user, M)
		//	chemscan(user, M)
		//	return 0 //not in science mode! return to sender
		if(T.setting == SCIENCE_MODE)
		//	user << "<span class='notice'>Function currently unavailible. We apologise for the inconvenience. </span>"
			return 1 //OK they want to scan stuff, continue on afterattack
	user << "<span class=`warning`>You must have a tricorder in your inventory to use this!</span>" //not in science mode! return to sender
	return


/obj/item/device/tricorder
	name = "tricorder"
	desc = "Utilized in the fields of repairwork, analyzing, and containing a variety of useful information. Set it to science mode to access scanning capabilities"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "tricorder"
	slot_flags = SLOT_BELT
	materials = list(MAT_METAL=55, MAT_GLASS=45)
	w_class = 2
	var/open = 0
	var/setting = MEDICAL_MODE
	var/scannerstatus = HAS_SCANNER
	var/obj/item/weapon/tricordscanner/tscanner
	var/obj/machinery/computer/camera_advanced/transporter_control/transporter_controller
	var/obj/machinery/buffer

/obj/item/device/tricorder/New()
	..()
	open = CLOSED
	update_icon()
	tscanner = new /obj/item/weapon/tricordscanner(src)
//	else
//		update_icon()
//		return new /obj/item/weapon/tricordscanner


/obj/item/device/tricorder/update_icon()
	switch(open)
		if(CLOSED)
			icon_state = "tricorder_closed"
		else if(OPEN)
			icon_state = "tricorder"
		else
			return


/obj/item/device/tricorder/AltClick()
	toggle_open()

/obj/item/device/tricorder/proc/toggle_open(mob/user) // Open/close it for muh ARPEEEEEEE
	var/mob/living/carbon/human/M = user
//	if(user != M) //ehhh redundant
	//	return
	add_fingerprint(M)
	if(open == CLOSED)
		open = OPEN
		update_icon()
	else
		open = CLOSED
		update_icon()


/obj/item/device/tricorder/attack_self(mob/user)
	if(open == CLOSED)
		toggle_open()
	switch(setting)
		if(MEDICAL_MODE)
			setting = SCIENCE_MODE
			user << "<span class=`notice`> You enable the science analyzer.</span>"
			update_icon()
		if(SCIENCE_MODE)
			setting = MEDICAL_MODE
			user << "<span class=`notice`> You enable the medical scanner.</span>"
			update_icon()
		else
			return

/obj/item/device/tricorder/attack_hand(mob/user)
	switch(open)
		if(CLOSED)
			..()
			return
		if(OPEN)
			remove_scanner(user)
			update_icon()
			return
	..()

/obj/item/device/tricorder/proc/remove_scanner(mob/user) // remove scanner
	tscanner.transporter_controller = transporter_controller
	if(loc == user) //you already sorta defined that, but redundancy doesnt hurt
		if(open == CLOSED)
			return
		if(scannerstatus == NO_SCANNER)
			user << "<span class='warning'> The scanner compartment is empty!</span>"
			return
		else if(scannerstatus == HAS_SCANNER)
			if(!usr.put_in_hands(tscanner))
				user << "You need a free hand to carry the [tscanner]"
				update_icon()
				return
			tscanner.loc = user
			tscanner = null
			update_icon()
	..()

/obj/item/device/tricorder/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/weapon/tricordscanner))
		if(C in user.contents)
			tscanner = new /obj/item/weapon/tricordscanner(src)
			user << "<span class='notice'>You put the [C] into \the [src]'s slot.</span>"
			qdel(C)
			scannerstatus = HAS_SCANNER
			update_icon()
		return
	..()






#undef NO_SCANNER
#undef HAS_SCANNER
#undef OPEN
#undef CLOSED
#undef MEDICAL_MODE
#undef SCIENCE_MODE
