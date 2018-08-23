/obj/machinery/computer/camera_advanced/transporter_control
	name = "transporter control station"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	dir = 4
	icon_keyboard = null
	icon_screen = null
	layer = 4.5
	anchored = TRUE
	can_be_unanchored = TRUE
	var/area/target_area
	var/list/retrievable = list()
	var/list/linked = list()
	var/list/tricorders = list()
	var/area/list/destinations = list() //where can we go, relates to overmap.dm
	var/turf/open/available_turfs = list()
	var/datum/action/innate/jump_area/area_action = new
	var/datum/action/innate/beamdown/down_action = new
	var/datum/action/innate/beamup/up_action = new
	var/obj/structure/overmap/theship
//	var/datum/action/innate/movedown/movedown_action = new
//	var/datum/action/innate/moveup/moveup_action = new
	var/mob/living/carbon/operator
	//var/datum/action/innate/togglelock/lock_action = new
	//	var/turf/open/teleport_target = null

/obj/machinery/computer/camera_advanced/transporter_control/Initialize()
	. = ..()
	link_by_range()

/obj/machinery/computer/camera_advanced/transporter_control/proc/link_by_range()
	for(var/obj/machinery/trek/transporter/A in orange(10,src))
		if(istype(A, /obj/machinery/trek/transporter))
			linked += A

/obj/machinery/computer/camera_advanced/transporter_control/huge
	name = "transporter control station"
	icon = 'StarTrek13/icons/trek/transporter.dmi'
	icon_state = "console"
	bound_height = 64

/obj/machinery/trek/transporter/huge
	name = "transporter pad"
	icon = 'StarTrek13/icons/trek/transporter.dmi'
	icon_state = "pad"


/obj/machinery/computer/camera_advanced/transporter_control/proc/activate_pads()
	if(!powered())
		return
	if(eyeobj.eye_user)
		for(var/obj/machinery/trek/transporter/T in linked)
			var/turf/open/Tu = get_turf(pick(orange(1, get_turf(eyeobj))))
			T.send(Tu)
		playsound(loc, 'StarTrek13/sound/borg/machines/transporter.ogg', 40, 4)

/obj/machinery/computer/camera_advanced/transporter_control/proc/retrieve_item(atom/I)
	if(!powered())
		return
	say("Remote transport signal accepted!")
	playsound(loc, 'StarTrek13/sound/borg/machines/transporter.ogg', 40, 4)
	var/obj/machinery/trek/transporter/T = pick(linked)
	T.retrieve_obj(I)

/obj/machinery/computer/camera_advanced/transporter_control/proc/transporters_retrieve()
	if(!powered())
		return
	playsound(loc, 'StarTrek13/sound/borg/machines/transporter.ogg', 40, 4)
	for(var/mob/living/thehewmon in orange(eyeobj,1))
		var/obj/machinery/trek/transporter/T = pick(linked)
		T.retrieve(thehewmon)

/obj/machinery/computer/camera_advanced/transporter_control/proc/get_available_turfs(var/area/A)
	available_turfs = list()
	for(var/turf/open/T in A)
		available_turfs += T

/obj/machinery/computer/camera_advanced/transporter_control/CreateEye()
	if(eyeobj)
		qdel(eyeobj)
	eyeobj = new()
	eyeobj.use_static = FALSE
	eyeobj.origin = src
	eyeobj.visible_icon = 1
	eyeobj.icon = 'icons/obj/abductor.dmi'
	eyeobj.icon_state = "camera_target"

/obj/machinery/computer/camera_advanced/transporter_control/give_eye_control(mob/living/carbon/user, list/L)
	if(user == operator)
		GrantActions(user)
		current_user = user
		eyeobj.eye_user = user
		eyeobj.name = "Camera Eye ([user.name])"
		user.remote_control = eyeobj
		user.reset_perspective(eyeobj)
		eyeobj.loc = pick(L)
		user.sight = 60 //see through walls
		//user.lighting_alpha = 0 //night vision (doesn't work for some reason)
	else
		to_chat(user, "This is already in use!")


/obj/machinery/computer/camera_advanced/transporter_control/attack_hand(mob/user)
	link_by_range()
	if(!theship)
		var/obj/structure/fluff/helm/desk/tactical/AA = locate(/obj/structure/fluff/helm/desk/tactical) in get_area(src)
		theship = AA.theship
	destinations = theship.interactables_near_ship
//	interact(user)
	if(!powered())
		to_chat(user, "Insufficient power!")
		return
	var/A
	var/B
	if(operator)
		remove_eye_control(operator)
	operator = user

	B = input(user, "Mode:","Transporter Control",B) in list("Visual Scanner", "cancel")
	switch(B)
		if("Visual Scanner")
			if(linked.len)
				A = input(user, "Target", "Transporter Control", A) as obj in destinations //activate_pads works here!
				if(!A)
					to_chat(user, "<span class='notice'>Scanner cannot locate any locations to beam to.</span>")
					return
				var/list/L = list()
				var/obj/structure/overmap/O = A

				if(O.has_shields())
					to_chat(user, "<span class='notice'>Cannot sustain a lock, target has their shield up</span>")
					return

				for(var/turf/T in O.linked_ship)
					L += T
				target_area = O.linked_ship
				if(!eyeobj)
					CreateEye()
				give_eye_control(user, L)
			else
				to_chat(user, "<span class='notice'>There are no linked transporter pads</span>")
				return
		if("cancel")
			if(operator)
				remove_eye_control(operator)
			return

// TGUI

/obj/machinery/computer/camera_advanced/transporter_control/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state) // Remember to use the appropriate state.
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "transporter_control", name, 300, 300, master_ui, state)
		ui.open()

/obj/machinery/computer/camera_advanced/transporter_control/ui_data(mob/user)
	var/list/data = list()
	data["tricorders"] = tricorders

	return data

/obj/machinery/computer/camera_advanced/transporter_control/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("copypasta")
			. = TRUE
	update_icon() // Not applicable to all objects.


/obj/machinery/computer/camera_advanced/transporter_control/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "transporter_console", name, 300, 300, master_ui, state)
		ui.open()

/obj/machinery/computer/camera_advanced/transporter_control/ui_data(mob/user)
	var/list/data = list()
	data += destinations
	data += tricorders
	data += linked
	data += retrievable

	return data

/obj/machinery/computer/camera_advanced/transporter_control/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("removeTricorder")
			tricorders -= params["tricorder"]
			. = TRUE
	update_icon()

 // TGUI

/obj/machinery/computer/camera_advanced/transporter_control/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tricorder))
		var/obj/item/tricorder/S = I
		if(S.buffer)
			if(istype(S.buffer, /obj/machinery/trek/transporter) && !(S.buffer in linked))
				linked += S.buffer
				S.buffer = null
				to_chat(user, "<span class='notice'>Transporter successfully connected to the console.</span>")
		S.transporter_controller = src
		tricorders += S
		to_chat(user, "<span class='notice'>Successfully linked [I] to [src], you may now tag items for transportation</span>")
	else
		return 0

/obj/machinery/computer/camera_advanced/transporter_control/GrantActions(mob/living/user)
	//dont need jump cam action
	if(user != operator)
		to_chat(user, "This is already in use!")
	if(off_action)
		off_action.target = user
		off_action.Grant(user)
		actions += off_action

	if(down_action)
		down_action.target = user
		down_action.Grant(user)
		down_action.console = src
		actions += down_action

	if(up_action)
		up_action.target = user
		up_action.Grant(user)
		up_action.console = src
		actions += up_action
/*
	if(lock_action)
		lock_action.target = user
		lock_action.Grant(user)
		lock_action.console = src
		actions += lock_action

Might find a use for this later

/datum/action/innate/togglelock
	name = "Lock"
	icon_icon = 'StarTrek13/icons/actions/actions_transporter.dmi'
	button_icon_state = "target_lock"
	var/obj/machinery/computer/camera_advanced/transporter_control/console
	var/locked = 0

/datum/action/innate/togglelock/Activate()
	if(locked)
		locked = 0
		name = "Unlock"
		button_icon_state = "target_unlock"
		UpdateButtonIcon()
	else
		locked = 1
		name = "Lock"
		button_icon_state = "target_lock"
		UpdateButtonIcon()
		*/

/datum/action/innate/moveup
	name = "Move Up"
	icon_icon = 'StarTrek13/icons/actions/actions_transporter.dmi'
	button_icon_state = "z_up"
	var/obj/machinery/computer/camera_advanced/transporter_control/console

/datum/action/innate/moveup/Activate()
	console.eyeobj.z++
	var/area/thearea = get_area(console.eyeobj)
	if(thearea == console.target_area)
		return
	else //If it's not in the same area. Return the eye back to whence it came
		console.eyeobj.z--


/datum/action/innate/movedown
	name = "Move Down"
	icon_icon = 'StarTrek13/icons/actions/actions_transporter.dmi'
	button_icon_state = "z_down"
	var/obj/machinery/computer/camera_advanced/transporter_control/console

/datum/action/innate/movedown/Activate()
	console.eyeobj.z--
	var/area/thearea = get_area(console.eyeobj)
	if(thearea == console.target_area)
		return
	else //If it's not in the same area. Return the eye back to whence it came
		console.eyeobj.z++

/datum/action/innate/beamup
	name = "Beam Up"
	icon_icon = 'StarTrek13/icons/actions/actions_transporter.dmi'
	button_icon_state = "beam_up"
	var/obj/machinery/computer/camera_advanced/transporter_control/console

/datum/action/innate/beamup/Activate()
	console.transporters_retrieve()

/datum/action/innate/beamdown
	name = "Beam Down"
	icon_icon = 'StarTrek13/icons/actions/actions_transporter.dmi'
	button_icon_state = "beam_down"
	var/obj/machinery/computer/camera_advanced/transporter_control/console

/datum/action/innate/beamdown/Activate()
	console.activate_pads()

/datum/action/innate/jump_area //jumps to different power networks ie engineering, bridge, security
	name = "Jump To Area"
	icon_icon = 'StarTrek13/icons/actions/actions_transporter.dmi'
	button_icon_state = "area_jump"
	var/obj/machinery/computer/camera_advanced/transporter_control/console

/datum/action/innate/jump_area/Activate()
	return 0

/obj/effect/temp_visual/transporter
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "beamup"
	duration = 10

/obj/effect/temp_visual/transporter/mob
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "beamout"
	duration = 20


/obj/machinery/trek/transporter
	name = "transporter pad"
	density = 0
	anchored = 1
	can_be_unanchored = 1
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "transporter"
	anchored = TRUE
	var/obj/machinery/computer/camera_advanced/transporter_control/transporter_controller = null

/obj/machinery/trek/transporter/proc/send(turf/open/teleport_target)
	if(!powered())
		return
	flick("alien-pad", src)
	var/mob/living/target = locate(/mob/living) in loc
	if(target != src)
		new /obj/effect/temp_visual/transporter(get_turf(target))
		target.forceMove(teleport_target)
		new /obj/effect/temp_visual/transporter/mob(get_turf(target))
		playsound(target.loc, 'StarTrek13/sound/borg/machines/transporter2.ogg', 40, 4)

/obj/machinery/trek/transporter/proc/retrieve(mob/living/target)
	if(!powered())
		return
	flick("alien-pad", src)
	if(!target.buckled)
		new /obj/effect/temp_visual/transporter(get_turf(target))
		playsound(target.loc, 'StarTrek13/sound/borg/machines/transporter2.ogg', 40, 4)
		target.forceMove(get_turf(src))
		new /obj/effect/temp_visual/transporter/mob(get_turf(target))

/obj/machinery/trek/transporter/proc/retrieve_obj(obj/target)
	if(!powered())
		return
	flick("alien-pad", src)
	if(!target.anchored)
		new /obj/effect/temp_visual/transporter(get_turf(target))
		playsound(target.loc, 'StarTrek13/sound/borg/machines/transporter2.ogg', 40, 4)
		target.loc = get_turf(src)
		new /obj/effect/temp_visual/transporter(get_turf(target))

/obj/machinery/trek/transporter/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tricorder))
		var/obj/item/tricorder/T = I
		T.buffer = src
		to_chat(user, "<span class='notice'>Transporter data successfully stored in the tricorder buffer.</span>")


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
	var/obj/item/t_scanner/rayscan //attack
	var/obj/item/t_scanner/adv_mining_scanner/miningscan //attackself
	var/obj/item/analyzer/gasscan //attackself
	var/obj/item/detective_scanner/detscan //attackself to print, afterattack to scan
	var/medical = 0
	var/obj/machinery/computer/camera_advanced/transporter_control/transporter_controller

/obj/item/weapon/tricordscanner/New()
	. = ..()
	rayscan = new /obj/item/t_scanner(src)
	miningscan =  new /obj/item/t_scanner/adv_mining_scanner(src) //attackself
	gasscan = new /obj/item/analyzer(src) //attackself
	detscan = new /obj/item/detective_scanner(src) //attackself to print, afterattack to scan

/obj/item/weapon/tricordscanner/proc/tricorder_med()


/obj/item/weapon/tricordscanner/afterattack(atom/I, mob/user)
	medical = 0
	if(istype(I, /obj/item/tricorder))
		return I.attackby(src, user)
	if(tricorder_science_mode(I, user))
		var/B
		B = input(user, "Select mode:","Tricorder scanner",B) in list("t ray scanner","mining scanner","gas analyzer","detective scanner","transporter tag", "cancel") //this is broken
		switch(B)
			if("t ray scanner")
				rayscan.attack_self(user = user)
			if("mining scanner")
				miningscan.attack_self(user = user)
			if("gas analyzer")
				gasscan.attack_self(user = user)
			if("detective scanner")
				detscan.scan(I, user = user)
				sleep(40)
				detscan.attack_self(user = user)
			if("transporter tag")
				if(transporter_controller)
					if(istype(I, /obj))
						var/obj/II = I
						if(II.anchored)
							to_chat(user, "You must unanchor [I] before it can be transported!")
							return ..()
					if(!istype(I, /mob)) //need someone to beam you up
						var/mode = input(user, "Beam up [I]?","Tricorder Scanner") in list("yes","no")
						if(mode == "yes")
							to_chat(user,"Sending remote beamout command for [I]")
							transporter_controller.retrieve_item(I)
						else
							return
					else
						to_chat(user, "This method of transport is too risky for biological lifeforms")
				else
					to_chat(user, "You must link the tricorder to a transporter first!")
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
		to_chat(user,"You need a tricorder set to science mode in your inventory to use this!")
	//	if(!B.len)
	//		. = ..()

/obj/item/weapon/tricordscanner/proc/tricorder_science_mode(atom/I, mob/living/carbon/human/user)
//	var/obj/item/weapon/tricordscanner/F
	for(var/obj/item/tricorder/T in user.contents)
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


/obj/item/tricorder
	name = "tricorder"
	desc = "Utilized in the fields of repairwork, analyzing, and containing a variety of useful information. You can open / close it by clicking it in hand, and you can toggle its scanning modes by alt clicking it. Ctrl click it to access its tricorder scanner module."
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

/obj/item/tricorder/New()
	..()
	open = CLOSED
	update_icon()
	tscanner = new /obj/item/weapon/tricordscanner(src)
//	else
//		update_icon()
//		return new /obj/item/weapon/tricordscanner


/obj/item/tricorder/update_icon()
	switch(open)
		if(CLOSED)
			icon_state = "tricorder_closed"
		else if(OPEN)
			icon_state = "tricorder"
		else
			return


/obj/item/tricorder/attack_self()
	toggle_open()

/obj/item/tricorder/proc/toggle_open(mob/user) // Open/close it for muh ARPEEEEEEE
	var/mob/living/carbon/human/M = user
	add_fingerprint(M)
	if(open == CLOSED)
		open = OPEN
		update_icon()
	else
		open = CLOSED
		update_icon()

/obj/item/tricorder/CtrlClick(mob/user)
	remove_scanner(user)
	update_icon()
	return

/obj/item/tricorder/AltClick(mob/user)
	switch(setting)
		if(MEDICAL_MODE)
			setting = SCIENCE_MODE
			to_chat(user,"<span class='notice'> You enable the science analyzer.</span>")
			update_icon()
		if(SCIENCE_MODE)
			setting = MEDICAL_MODE
			to_chat(user,"<span class='notice'> You enable the medical scanner.</span>")
			update_icon()
		else
			return

/obj/item/tricorder/proc/remove_scanner(mob/user) // remove scanner
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

/obj/item/tricorder/attackby(obj/item/C, mob/user, params)
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
