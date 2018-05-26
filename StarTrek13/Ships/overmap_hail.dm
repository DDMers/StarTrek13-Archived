/proc/hail(var/text, var/sound, var/obj/structure/overmap/sender, var/obj/structure/overmap/target)
	if(!text)
		return
	if(!sound)
		sound = 'StarTrek13/sound/trek/ship_effects/bosun.ogg'

	var/announcement
	announcement += "<br><h2 class='alert'>Ship hail: [sender] -> [target]</h2>"

	announcement += "<br><span class='alert'>[html_encode(text)]</span><br>"
	announcement += "<br>"

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