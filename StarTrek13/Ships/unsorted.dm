/obj/item/clothing/neck/combadge
	name = "combadge"
	icon = 'icons/obj/clothing/neck.dmi'
	desc = "Standard issue communications device issued by starfleet, you must alt click it first, which will allow you to use it on that ship, to link it to another ship, just alt click it again. Ctrl click it to toggle transmission and receipt of messages"
	icon_state = "combadge"
	var/obj/item/clothing/neck/combadge/ping //If we're pinging a specific person
	var/area/ship/linked
	var/mob/living/stored_user
	var/on = FALSE

/obj/item/clothing/neck/combadge/CtrlClick(mob/user)
	playsound(loc, 'StarTrek13/sound/borg/machines/combadge.ogg', 50, 1)
	stored_user = user
	if(on)
		to_chat(user, "Broadcasting disabled")
		on = FALSE
		return
	if(!on)
		to_chat(user, "Broadcasting enabled")
		on = TRUE
		return

/obj/item/clothing/neck/combadge/AltClick(mob/user)
	link_to_area(user)

/obj/item/clothing/neck/combadge/proc/link_to_area(mob/user)
	if(linked)
		linked.combadges -= src
	var/area/A = get_area(src)
	if(istype(A, /area/ship))
		var/area/ship/S = A
		if(src in S.combadges)
			S.combadges -= src
		linked = S
		S.combadges += src
		to_chat(user, "You've linked [src] to the [linked] comms subsystem")


/obj/item/clothing/neck/combadge/proc/send_message(var/message, mob/living/carbon/user)
	if(!linked)
		link_to_area(user)
	stored_user = user
	for(var/obj/item/clothing/neck/combadge/C in linked.combadges)
	//	if(C in stored_user.contents) //Stops you hearing yourself
	//		return
		C.receive_message(message,user)

/obj/item/clothing/neck/combadge/proc/receive_message(var/message, mob/living/carbon/sender)
	if(on)
		to_chat(stored_user, "<span class='warning'><b>[sender]</b> <b>([sender.mind.assigned_role])</b>: [message]</span>")
		playsound(loc, 'StarTrek13/sound/borg/machines/combadge.ogg', 10, 1)