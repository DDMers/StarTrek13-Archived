/proc/hail(var/text, var/sound, var/obj/structure/overmap/sender, var/obj/structure/overmap/target)
	if(!text)
		return
	if(!sound)
		sound = 'StarTrek13/sound/trek/ship_effects/bosun.ogg'

	var/announcement
	announcement += "<br><h2 class='alert'>Ship hail: [sender] -> [target]</h2>"

	announcement += "<br><span class='alert'>[html_encode(text)]</span><br>"
	announcement += "<br>"
	if(isOVERMAP(sender))
		var/list/list = list()
		list += sender.pilot
		list += target.pilot
		for(var/mob/M in sender.linked_ship)
			list += M
		for(var/mob/S in target.linked_ship)
			list += S

		var/s = sound(sound)
		for(var/mob/M in list)
			if(!isnewplayer(M) && M.can_hear())
				to_chat(M, announcement)
				if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
					SEND_SOUND(M, s)


/obj/structure/overmap
	var/obj/structure/hailing_console/comms

/obj/structure/hailing_console
	name = "ship to ship hailing controller"
	desc = "Allows interstellar communication, it has two modes: Narrow and wide band. Narrow band allows you to directly hail one ship, and wide band messages all nearby ships."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "shields"
	var/hail_open = TRUE //are hails muted right now?
	var/obj/structure/overmap/hail_target
	var/wideband = FALSE //Are we transmitting on all frequencies?
	var/obj/structure/overmap/theship
	var/obj/structure/overmap/requester

/obj/structure/hailing_console/defiant
	icon = 'StarTrek13/icons/trek/defianttactical.dmi'
	icon_state = "shields"

/obj/structure/hailing_console/Initialize()
	. = ..()
	var/obj/structure/fluff/helm/desk/tactical/weapons = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src)) //why the hell did I think using for loops for everything was ever a good idea :blobthinking:
	theship = weapons.theship
	theship.comms = src

/obj/structure/hailing_console/proc/receive_hail(var/message, var/obj/structure/overmap/sender)
	for(var/mob/living/M in theship.linked_ship)
		if(!istype(M, /mob/living))
			continue
		to_chat(M, "<span class='alert'>Open band transmission: [sender], [html_encode(message)]</span>")

/obj/structure/hailing_console/attack_hand(mob/user)
	if(!theship)
		var/obj/structure/fluff/helm/desk/tactical/weapons = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src)) //why the hell did I think using for loops for everything was ever a good idea :blobthinking:
		theship = weapons.theship
		theship.comms = src
	var/message = stripped_input(user,"Communications.","Transmit message on all frequencies.")
	if(!message)
		return
	for(var/obj/structure/overmap/OM in get_area(theship))
		OM.comms.receive_hail(message, theship)
	for(var/mob/O in GLOB.dead_mob_list)
		to_chat(O, "<span class='alert'>Open band transmission: [theship], [html_encode(message)]</span>")