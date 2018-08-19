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

/obj/structure/overmap/proc/receive_hail(obj/structure/hailing_console/V)
	if(comms.hail_target != V.theship)
		playsound(comms.loc, 'StarTrek13/sound/trek/hail_incoming.ogg')
		comms.say("Narrow band hail request received from [V.theship].")
		comms.requester = V.theship

/obj/structure/hailing_console/proc/receive_hail(var/message, var/obj/structure/overmap/sender)
	if(hail_target == sender)
		visible_message("<span class='alert'>Narrow-band communication from [sender], [html_encode(message)]</span>")
		for(var/mob/O in GLOB.dead_mob_list)
			to_chat(O,"<span class='alert'>Narrow-band communication from [sender] -> [theship], [html_encode(message)]</span>")
		return
	for(var/mob/living/M in theship.linked_ship)
		if(!istype(M, /mob/living))
			continue
		to_chat(M, "<span class='alert'>Open band transmission: [sender], [html_encode(message)]</span>")
	for(var/mob/O in GLOB.dead_mob_list)
		to_chat(O, "<span class='alert'>Open band transmission: [sender], [html_encode(message)]</span>")

/obj/structure/hailing_console/attack_hand(mob/user)
	if(!theship)
		var/obj/structure/fluff/helm/desk/tactical/weapons = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src)) //why the hell did I think using for loops for everything was ever a good idea :blobthinking:
		theship = weapons.theship
		theship.comms = src
	if(requester)
		var/mode = alert("[requester] wants to hail your ship",,"accept", "deny")
		switch(mode)
			if("accept")
				hail_target = requester
				to_chat(user, "Hail accepted. Frequencies open.")
				playsound(loc, 'StarTrek13/sound/trek/hail_open.ogg')
				wideband = FALSE
			if("deny")
				requester = null
				to_chat(user, "Hail rejected.")
	if(wideband)
		var/message = stripped_input(user,"Communications.","Transmit message on all frequencies (leave message box empty to close frequencies).")
		if(!message)
			wideband = FALSE
			return
		for(var/obj/structure/overmap/OM in get_area(theship))
			OM.comms.receive_hail(message, theship)
	if(hail_target)
		wideband = FALSE
		var/message = stripped_input(user,"Communications.","Transmit message on narrow band frequencies (leave message box empty to close frequencies).")
		if(!message)
			hail_target = null
			return
		hail_target.comms.receive_hail(message, theship)
	else
		var/mode = alert("Hailing options:",,"switch frequency", "open/close hailing frequencies")
		switch(mode)
			if("switch frequency")
				var/freq = alert("Which frequency?",,"narrow band (direct messages)","wide band (message all ships in sector)")
				switch(freq)
					if("narrow band (direct messages)")
						wideband = FALSE
						var/list/L = list()
						for(var/obj/structure/overmap/OM in get_area(theship))
							if(istype(OM, /obj/structure/overmap))
								L += OM
						var/obj/structure/overmap/V = input("Open a channel to which ship?", "Hailing Options", null) in L
						if(!V)
							to_chat(user, "No recipient selected.")
							return
						hail_target = V
						to_chat(user, "Opening narrow band frequency for [V]")
						return
					if("wide band (message all ships in sector)")
						to_chat(user, "Wide band hailing frequencies open")
						hail_target = null
						wideband = TRUE
			//			if("mute hails")
				//