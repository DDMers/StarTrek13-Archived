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
	name = "communications console"
	desc = "Allows interstellar communication, it has two modes: Narrow and wide band. Narrow band allows you to directly hail one ship, and wide band messages all nearby ships. Alt click it to open hailing frequencies with just one ship."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "shields"
	var/hail_open = TRUE //are hails muted right now?
	var/obj/structure/overmap/DMpartner //ktlwjec can we dm please via BBM ok thank you :!!!!!!:))
	var/wideband = FALSE //Are we transmitting on all frequencies?
	var/obj/structure/overmap/theship
	var/obj/structure/overmap/requester
	anchored = TRUE
	density = TRUE

/obj/structure/hailing_console/defiant
	icon = 'StarTrek13/icons/trek/defianttactical.dmi'
	icon_state = "shields"

/obj/structure/hailing_console/romulan
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "rom-shields"

/obj/structure/hailing_console/galaxy
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "galaxycom"

/obj/structure/hailing_console/Initialize()
	. = ..()
	var/obj/structure/fluff/helm/desk/tactical/weapons = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src)) //why the hell did I think using for loops for everything was ever a good idea :blobthinking:
	theship = weapons.theship
	theship.comms = src

/obj/structure/hailing_console/proc/receive_hail(var/message, var/obj/structure/overmap/sender)
	var/fluff = "Open Frequency (Wide band):"
	if(DMpartner)
		if(sender)//byond sux
			if(DMpartner == sender)
				fluff = "<b>Closed Frequency (Narrow band)</b>:"
	if(theship)
		if(theship.pilot)
			to_chat(theship.pilot, "<span class='alert'>[fluff] <I>[sender]</I>: [message]</span>")
	for(var/mob/living/M in get_area(src))
		to_chat(M, "<span class='alert'>[fluff] <I>[sender]</I>: [message]</span>") //IM A FUCKING IDIOT

/obj/structure/hailing_console/proc/hail_request(var/obj/structure/overmap/sender)
	playsound(loc, 'StarTrek13/sound/trek/hail_incoming.ogg', 100)
	visible_message("<span class='alert'><I>Incoming hail from: [sender]</I></span>")
	requester = sender

/obj/structure/hailing_console/AltClick(mob/user)
	if(DMpartner)
		to_chat(user, "Hailing frequency closed")
		DMpartner.comms.visible_message("<span class='alert'><I>[theship] has closed hailing frequencies.</I></span>")
		DMpartner = null
	var/list/L = list()
	for(var/obj/structure/overmap/OM in get_area(theship))
		if(OM.comms)
			L += OM
	var/obj/structure/overmap/V = input("Open a channel to which ship?", "Hailing Options", null) in L
	if(!V)
		to_chat(user, "No recipient selected.")
		return
	if(!V.comms)
		return
	to_chat(user,"Hail request sent to [V]")
	V.comms.hail_request(theship)

/obj/structure/hailing_console/attack_hand(mob/user)
	if(!theship)
		var/obj/structure/fluff/helm/desk/tactical/weapons = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src)) //why the hell did I think using for loops for everything was ever a good idea :blobthinking:
		theship = weapons.theship
		theship.comms = src
	if(requester)
		var/mode = input("Incoming hail from [requester]", "Open a channel?")in list("yes","no")
		switch(mode)
			if("yes")
				playsound(loc, 'StarTrek13/sound/trek/hail_open.ogg',100)
				DMpartner = requester
				to_chat(user, "Channel opened. Messages will be sent to [DMpartner].")
				playsound(DMpartner.comms.loc, 'StarTrek13/sound/trek/hail_open.ogg',100)
				DMpartner.comms.visible_message("<span class='alert'><I>hailing channel opened with [theship]</I></span>")
				DMpartner.comms.DMpartner = theship
				requester = null
				return
			if("no")
				to_chat(user, "Hail denied. Transmitting on wide band as normal")
				requester.comms.visible_message("<span class='alert'><I>[theship] is not responding to hails.</I></span>")
				requester = null
				return
	if(DMpartner)
		var/message = stripped_input(user,"Hailing channel open with [DMpartner].","Transmit message on narrow band frequency.")
		if(!message)
			DMpartner.comms.visible_message("Hailing frequencies closed with [theship]")
			DMpartner.comms.DMpartner = null
			DMpartner = null
			return
		DMpartner.comms.receive_hail(message, theship)
		for(var/mob/O in GLOB.dead_mob_list)
			to_chat(O, "<span class='alert'><I>Narrow band transmission:</I> <b>[theship]</b>, [html_encode(message)]</span>")
	else
		var/message = stripped_input(user,"Communications.","Transmit message on all frequencies.")
		if(!message)
			return
		for(var/mob/O in GLOB.dead_mob_list)
			to_chat(O, "<span class='alert'><I>Open band transmission:</I> <b>[theship]</b>, [html_encode(message)]</span>")
		for(var/obj/structure/overmap/OM in get_area(theship))
			if(!OM.comms)
				continue
			if(OM.comms)
				OM.comms.receive_hail(message, theship)