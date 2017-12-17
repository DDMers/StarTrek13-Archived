
/obj/machinery/computer/camera_advanced/transporter_control
	name = "transporter control station"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "helm"
	dir = 4
	icon_keyboard = null
	icon_screen = null
	layer = 4.5
	var/list/retrievable = list()
	var/list/linked = list()
	var/list/tricorders = list()
	var/area/list/destinations = list() //where can we go, relates to overmap.dm
	var/turf/open/available_turfs = list()
//	var/turf/open/teleport_target = null

/obj/machinery/computer/camera_advanced/transporter_control/New()
	. = ..()
	link_by_range()

/obj/machinery/computer/camera_advanced/transporter_control/proc/link_by_range()
	for(var/obj/machinery/trek/transporter/A in orange(10,src))
		if(istype(A, /obj/machinery/trek/transporter))
			linked += A


/obj/machinery/computer/camera_advanced/transporter_control/proc/activate_pads()
	if(!available_turfs)
		to_chat(usr, "<span class='notice'>Target has no linked transporter pads</span>")
	for(var/obj/machinery/trek/transporter/T in linked)
		T.teleport_target = pick(available_turfs)
		T.Send()

/obj/machinery/computer/camera_advanced/transporter_control/proc/get_available_turfs(var/area/A)
	available_turfs = list()
	for(var/turf/open/T in A)
		available_turfs += T

/obj/machinery/computer/camera_advanced/transporter_control/CreateEye()
	eyeobj = new()
	eyeobj.use_static = FALSE
	eyeobj.origin = src

/obj/machinery/computer/camera_advanced/transporter_control/give_eye_control(mob/living/carbon/user, var/list/L)
	GrantActions(user)
	current_user = user
	eyeobj.eye_user = user
	eyeobj.name = "Camera Eye ([user.name])"
	user.remote_control = eyeobj
	user.reset_perspective(eyeobj)
	eyeobj.loc = pick(L)
	user.sight = 60 //see through walls
	user.lighting_alpha = 0 //night vision

/obj/machinery/computer/camera_advanced/transporter_control/attack_hand(mob/user)
	if(current_user)
		to_chat(user, "The console is already in use!")
		return

	var/A
	var/B
	available_turfs = list()

	B = input(user, "Mode:","Transporter Control",B) in list("Manual Beam","Automatic Beam","retrieve away team member", "cancel")
	switch(B)
		if("Manual Beam")
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
				if(!eyeobj)
					CreateEye()
				give_eye_control(user, L)
				to_chat(user, "WARNING, automatic beaming will occur in 10 seconds! once you have found a suitable location, stop moving the camera PS. Sorry for that!")
				sleep(100) // 10 seconds to get that fuck sticc targeted.
				var/turf/theturf = get_turf(eyeobj)
				for(var/turf/open/T in orange(3,theturf))	//get a 3x3 grid of tiles to teleport people on, so you don't just get a weird stack.
					available_turfs += T
				available_turfs += theturf
				activate_pads()
			else
				to_chat(user, "<span class='notice'>There are no linked transporter pads</span>")
		if("Automatic Beam")
			//this bit is dependent on power networks (ie APCs) depending on how it works
			to_chat(user, "<span class='danger'>!!! not yet implemented because bucket has deadlines and is totally not lazy !!!</span>")
		if("retrieve away team member")
			if(linked.len)
				A = input(user, "Retrieve from where", "Transporter Control", A) as obj in destinations //activate_pads works here!
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
				if(!eyeobj)
					CreateEye()
				give_eye_control(user, L)
				sleep(100) // 2 seconds to get that fuck sticc targeted.
				to_chat(user, "WARNING, automatic beaming will occur in 10 seconds! once you have found a suitable location, stop moving the camera PS. Sorry for that!")
				var/turf/theturf = get_turf(eyeobj)
				for(var/atom/movable/T in orange(3,theturf))	// grab all mobs in a 3x3 radius.
					if(istype(T, /mob) || istype(T, /obj/structure/closet))
						retrievable += T //so within a range of the camera it'll beam up PEOPLE. (only people
				playsound(src.loc, 'StarTrek13/sound/borg/machines/transporter.ogg', 40, 4)
				for(var/atom/movable/M in retrievable)	//need to add beaming up crates
					M.alpha = 255
					var/atom/movable/target = M
					for(var/obj/machinery/trek/transporter/T in linked)
						animate(target,'StarTrek13/icons/trek/star_trek.dmi',"transportout")
						playsound(target.loc, 'StarTrek13/sound/borg/machines/transporter2.ogg', 40, 4)
						playsound(src.loc, 'StarTrek13/sound/borg/machines/transporter.ogg', 40, 4)
						var/obj/machinery/trek/transporter/Z = pick(linked)
						target.forceMove(Z.loc)
						target.alpha = 255
						//Z.rematerialize(target)
						animate(Z,'StarTrek13/icons/trek/star_trek.dmi',"transportin")
						retrievable -= target
		if("cancel")
			return

/obj/machinery/computer/camera_advanced/transporter_control/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/tricorder))
		var/obj/item/device/tricorder/S = I
		if(istype(S.buffer, /obj/machinery/trek/transporter))
			linked += S.buffer
			S.buffer = null
			to_chat(user, "<span class='notice'>Transporter successfully connected to the console.</span>")
		else if(!I in tricorders)
			S.transporter_controller = src
			tricorders += S
			user << "Successfully linked [I] to [src], you may now tag items for transportation"
		else
			user << "[I] is already linked to [src]!"
	else
		return 0

/obj/machinery/trek/transporter
	name = "transporter pad"
	density = 0
	anchored = 1
	can_be_unanchored = 0
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "transporter"
	layer = 2
	anchored = TRUE
	var/turf/open/teleport_target = null
	var/obj/machinery/computer/camera_advanced/transporter_control/transporter_controller = null

/obj/machinery/trek/transporter/proc/Warp(mob/living/target)
	if(!target.buckled)
		target.forceMove(get_turf(src))

/obj/machinery/trek/transporter/proc/Send()
	flick("alien-pad", src)
	for(var/atom/movable/target in loc)
		if(istype(target, /mob) || istype(target, /obj/structure/closet))
			if(target != src)
				target.forceMove(teleport_target)
			//	transporter_controller.retrievable += target

/obj/machinery/trek/transporter/proc/Retrieve(mob/living/target)
	flick("alien-pad", src)
	new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target), target.dir)
	Warp(target)

/obj/machinery/trek/transporter/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/tricorder))
		var/obj/item/device/tricorder/T = I
		T.buffer = src
		to_chat(user, "<span class='notice'>Transporter data successfully stored in the tricorder buffer.</span>")

/*
/obj/structure/trek/transporter
	name = "transporter pad"
	density = 0
	anchored = 1
	can_be_unanchored = 0
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "transporter"
	var/target_loc = list() //copied
	var/obj/machinery/computer/transporter_control/transporter_controller = null

/obj/structure/trek/transporter/proc/teleport(var/mob/M, available_turfs)
	animate(M,'StarTrek13/icons/trek/star_trek.dmi',"transportout")
	usr << M
	M.dir = 1
	transporter_controller.retrievable += M
	if(M in transporter_controller.retrievable)
		transporter_controller.retrievable -= M
	M.alpha = 0
	M.forceMove(pick(available_turfs))
//	animate(M)
	if(ismob(M))
		var/mob/living/L = M
		L.Stun(3)
		animate(M,'StarTrek13/icons/trek/star_trek.dmi',"transportin") //test with flick, not sure if it'll work! SKREE
	icon_state = "transporter"

/obj/structure/trek/transporter/proc/teleport_all(available_turfs)
	icon_state = "transporter_on"
	for(var/mob/M in get_turf(src))
		if(M != src)
			//anim(M.loc,'icons/obj/machines/borg_decor.dmi',"transportin")
			teleport(M, available_turfs)
			rematerialize(M)
	icon_state = "transporter"


/obj/structure/trek/transporter/proc/rematerialize(var/atom/movable/thing)
	//var/atom/movable/target = Target
	icon_state = "transporter_on"
	thing.alpha = 255
	playsound(thing.loc, 'StarTrek13/sound/borg/machines/transporter2.ogg', 40, 4)
	icon_state = "transporter"*/