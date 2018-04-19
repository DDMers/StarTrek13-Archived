/obj/structure/overmap
	var/mob/camera/observers = list()
	var/mob/living/users = list()

/datum/action/innate/camera_off/overmap
	name = "Stop observing"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"

/datum/action/innate/camera_off/overmap/Activate()
	if(!target || !isliving(target))
		return
	var/mob/living/C = target
	var/mob/camera/aiEye/remote/overmap_observer/remote_eye = C.remote_control
	var/obj/structure/overmap/ship = remote_eye.origin
	ship.remove_eye_control(target)

/obj/structure/overmap/proc/GrantEye(mob/user)
	var/mob/camera/aiEye/remote/overmap_observer/eyeobj = new
	eyeobj.origin = src
	observers += eyeobj
	eyeobj.off_action = new(eyeobj)
	eyeobj.eye_user = user
	eyeobj.name = "[name] observer"
	eyeobj.off_action.target = user
	eyeobj.off_action.Grant(user)
	eyeobj.setLoc(eyeobj.loc)
	eyeobj.forceMove(get_turf(src))
	users += user
	user.remote_control = eyeobj
	user.reset_perspective(eyeobj)

/mob/camera/aiEye/remote/overmap_observer
	name = "Inactive Camera Eye"
	/obj/structure/overmap/origin
	var/datum/action/innate/camera_off/off_action


/mob/camera/aiEye/remote/overmap_observer/relaymove(mob/user,direct)
	return 0

/mob/camera/aiEye/remote/overmap_observer/Destroy()
	off_action.target = null
	off_action.Remove(eye_user)
	qdel(off_action)
	eye_user = null
	RemoveImages()

/obj/structure/overmap/proc/remove_eye_control(mob/living/user)
	if(!user)
		return
	if(user.client)
		user.reset_perspective(null)

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
	our_ship.GrantEye(user)