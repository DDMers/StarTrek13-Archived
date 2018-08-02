/obj/machinery/computer/camera_advanced/transporter_control
	name = "transporter control station"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	dir = 4
	icon_keyboard = null
	icon_screen = null
	layer = 4.5
	var/area/target_area
	var/list/retrievable = list()
	var/list/linked = list()
	var/list/tricorders = list()
	var/area/list/destinations = list() //where can we go, relates to overmap.dm
	var/turf/open/available_turfs = list()
	var/datum/action/innate/jump_area/area_action = new
	var/datum/action/innate/beamdown/down_action = new
	var/datum/action/innate/beamup/up_action = new
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
	if(eyeobj.eye_user)
		for(var/obj/machinery/trek/transporter/T in linked)
			for(var/mob/living/L in T.loc)
				if(!(L in retrievable))
					retrievable += L
			var/turf/open/Tu = get_turf(pick(orange(1, get_turf(eyeobj))))
			T.send(Tu)
	else if(available_turfs)
		for(var/obj/machinery/trek/transporter/T in linked)
			for(var/mob/living/L in T.loc)
				retrievable += L
			T.send(pick(available_turfs))
	else
		to_chat(usr, "<span class='notice'>Target has no linked transporter pads</span>")

/obj/machinery/computer/camera_advanced/transporter_control/proc/transporters_retrieve()
	for(var/mob/living/thehewmon in orange(eyeobj,1))
		var/obj/machinery/trek/transporter/T = pick(linked)
		T.retrieve(thehewmon)
//	var/i=retrievable.len
//	for(var/obj/machinery/trek/transporter/T in linked)
	//	T.retrieve(retrievable[i])
	//	retrievable -= retrievable[i]
	//	i--

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
//	interact(user)
	var/A
	var/B
	if(operator)
		remove_eye_control(operator)
	operator = user

	B = input(user, "Mode:","Transporter Control",B) in list("Visual Scanner","retrieve away team member", "cancel")
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
		if("retrieve away team member")
			var/C = input(user, "Beam someone back", "Transporter Control") as anything in retrievable
			if(!C in retrievable)
				return
			var/atom/movable/target = C
			playsound(src.loc, 'StarTrek13/sound/borg/machines/transporter.ogg', 40, 4)
			retrievable -= target
			for(var/obj/machinery/trek/transporter/T in linked)
				animate(target,'StarTrek13/icons/trek/star_trek.dmi',"transportout")
				if(target)
					playsound(target.loc, 'StarTrek13/sound/borg/machines/transporter2.ogg', 40, 4)
				playsound(src.loc, 'StarTrek13/sound/borg/machines/transporter.ogg', 40, 4)
				var/obj/machinery/trek/transporter/Z = pick(linked)
				target.forceMove(Z.loc)
				target.alpha = 255
				//Z.rematerialize(target)
				animate(Z,'StarTrek13/icons/trek/star_trek.dmi',"transportin")
                        //        Z.alpha = 255
				break
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
		if(istype(S.buffer, /obj/machinery/trek/transporter) && !(S.buffer in linked))
			linked += S.buffer
			S.buffer = null
			to_chat(user, "<span class='notice'>Transporter successfully connected to the console.</span>")
		else if(!I in tricorders)
			S.transporter_controller = src
			tricorders += S
			to_chat(user, "<span class='notice'>Successfully linked [I] to [src], you may now tag items for transportation</span>")
		else
			to_chat(user, "<span class='notice'>The transporter is already linked to this console.</span>")
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
/*
	if(movedown_action)
		movedown_action.target = user
		movedown_action.Grant(user)
		movedown_action.console = src
		actions += movedown_action

	if(moveup_action)
		moveup_action.target = user
		moveup_action.Grant(user)
		moveup_action.console = src
		actions += moveup_action
*/
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



/obj/machinery/trek/transporter
	name = "transporter pad"
	density = 0
	anchored = 1
	can_be_unanchored = 0
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "transporter"
	anchored = TRUE
	var/obj/machinery/computer/camera_advanced/transporter_control/transporter_controller = null

/obj/machinery/trek/transporter/proc/send(turf/open/teleport_target)
	flick("alien-pad", src)
	for(var/atom/movable/target in loc) //test
		if(target != src)
			new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target), target.dir)
			target.forceMove(teleport_target)

/obj/machinery/trek/transporter/proc/retrieve(mob/living/target)
	flick("alien-pad", src)
	new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target), target.dir)
	if(!target.buckled)
		target.forceMove(get_turf(src))

/obj/machinery/trek/transporter/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tricorder))
		var/obj/item/tricorder/T = I
		T.buffer = src
		to_chat(user, "<span class='notice'>Transporter data successfully stored in the tricorder buffer.</span>")
