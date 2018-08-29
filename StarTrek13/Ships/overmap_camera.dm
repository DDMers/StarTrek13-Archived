/obj/structure/overmap
	var/mob/camera/observers = list()
	var/mob/living/users = list()

/datum/action/innate/camera_off/overmap
	name = "Stop observing"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"
	var/mob/camera/aiEye/remote/overmap_observer/remote_eye
	var/mob/living/user

/datum/action/innate/camera_off/overmap/Activate()
	if(!target || !isliving(target))
		return
	var/obj/structure/overmap/ship = remote_eye.origin
	if(!target)
		return
	ship.observers -= remote_eye
	qdel(remote_eye)
	target = null
	user.remote_control = null
	if(user.client)
		user.reset_perspective(null)
	user = null
	qdel(src)

/obj/structure/overmap/proc/GrantEye(mob/user)
	var/mob/camera/aiEye/remote/overmap_observer/eyeobj = new
	eyeobj.origin = src
	observers += eyeobj
	eyeobj.off_action = new
	eyeobj.off_action.remote_eye = eyeobj
	eyeobj.eye_user = user
	eyeobj.name = "[name] observer"
	eyeobj.off_action.target = user
	eyeobj.off_action.user = user
	eyeobj.off_action.Grant(user)
	eyeobj.setLoc(eyeobj.loc)
	eyeobj.forceMove(get_turf(src))
	users += user
	user.remote_control = eyeobj
	user.reset_perspective(eyeobj)

/mob/camera/aiEye/remote/overmap_observer
	name = "Inactive Camera Eye"
	/obj/structure/overmap/origin
	var/datum/action/innate/camera_off/overmap/off_action

/obj/structure/overmap/proc/update_observers() //So cameras follow it
	for(var/R in observers)
		var/mob/RR = R
		RR.forceMove(get_turf(src))


/mob/camera/aiEye/remote/overmap_observer/relaymove(mob/user,direct)
	return 0

/mob/camera/aiEye/remote/overmap_observer/Destroy()
	off_action.target = null
	off_action.Remove(eye_user)
	qdel(off_action)
	eye_user = null
	RemoveImages()

/obj/structure/overmap/proc/remove_eye_control(mob/living/user)


/obj/structure/viewscreen
	name = "LCARS display"
	desc = "It is some kind of monitor which allows you to look at the health of the ship."
	icon = 'StarTrek13/icons/trek/viewscreen.dmi'
	icon_state = "viewscreen"
	var/obj/structure/overmap/ship/our_ship
	pixel_x = -5
	pixel_y = -6

/obj/structure/viewscreen/mini
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "viewscreen_mini"

/obj/structure/viewscreen/examine(mob/user)
	if(!our_ship)
		var/obj/structure/fluff/helm/desk/tactical/F = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
		our_ship = F.theship
	var/area/A = get_area(our_ship)
	A.Entered(user)
	if(isliving(user))
		our_ship.GrantEye(user)
	else
		user.forceMove(our_ship.loc)
		user.orbit(our_ship)
