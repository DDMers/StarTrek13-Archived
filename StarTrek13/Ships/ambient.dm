GLOBAL_LIST_INIT(trek_music, world.file2list("strings/trekmusic.txt"))
GLOBAL_LIST_INIT(trek_battle_music, world.file2list("strings/trekmusic_battle.txt"))

/obj/effect/landmark/music_controller
	name = "music controller"
	desc = "A landmark which will send web sounds to any players in the same system as it, allowing for le epic battle music!!!"
	var/list/possible_sounds = list()
	var/roundstarted = FALSE //so the factions system doesnt constantly spam music to infinity!
	var/playing = FALSE //stop battlemusic spam!
	var/playing_danger = FALSE

/obj/effect/landmark/music_controller/Initialize()
	. = ..()
	if(SSfaction)
		SSfaction.music_controllers += src

/obj/effect/landmark/music_controller/proc/stop()
	for(var/obj/structure/overmap/M in get_area(src))
		if(M.pilot)
			if(M.pilot.client)
				var/client/CCE = M.pilot.client
				CCE.chatOutput.stopMusic()


/obj/effect/landmark/music_controller/proc/play(var/danger = FALSE)
	if(danger && !playing_danger)
		playing = FALSE //Switch to battle music instead! High priority!
		for(var/datum/timedevent/S in active_timers)
			qdel(S) //stop it quickswitching at random
	if(!playing) //no random switching to calm orchestral music mid fight!
		stop()
		playing = TRUE
		var/web_sound_input
		web_sound_input= "[pick(GLOB.trek_music)]"
		if(danger)
			web_sound_input = "[pick(GLOB.trek_battle_music)]"
			playing_danger = TRUE
			for(var/obj/structure/overmap/SS in get_area(src))
				if(SS && SS.linked_ship)
					var/obj/machinery/computer/camera_advanced/rts_control/rts = locate(/obj/machinery/computer/camera_advanced/rts_control) in(SS.linked_ship)
					if(rts)
						if(rts.RTSeye && rts.operator)
							SEND_SOUND(rts.operator, 'StarTrek13/sound/voice/rts/beeps/smallredalert.ogg')
							to_chat(rts.operator, "Ships engaging in combat in [get_area(src)]!")
							rts.RTSeye.play_voice('StarTrek13/sound/voice/rts/combat/engaged.ogg')
		var/ytdl = CONFIG_GET(string/invoke_youtubedl)
		if(!ytdl)
			to_chat(src, "<span class='boldwarning'>Youtube-dl was not configured, action unavailable</span>") //Check config.txt for the INVOKE_YOUTUBEDL value
			return
		if(istext(web_sound_input))
			var/web_sound_url = ""
			var/pitch
			if(length(web_sound_input))
				web_sound_input = trim(web_sound_input)
				if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
					to_chat(src, "<span class='boldwarning'>Non-http(s) URIs are not allowed.</span>")
					to_chat(src, "<span class='warning'>For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website.</span>")
					return
				var/shell_scrubbed_input = shell_url_scrub(web_sound_input)
				var/list/output = world.shelleo("[ytdl] --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
				var/errorlevel = output[SHELLEO_ERRORLEVEL]
				var/stdout = output[SHELLEO_STDOUT]
				var/stderr = output[SHELLEO_STDERR]
				if(!errorlevel)
					var/list/data
					try
						data = json_decode(stdout)
					catch(var/exception/e)
						to_chat(src, "<span class='boldwarning'>Youtube-dl JSON parsing FAILED:</span>")
						to_chat(src, "<span class='warning'>[e]: [stdout]</span>")
						return

					if (data["url"])
						web_sound_url = data["url"]
				else
					to_chat(src, "<span class='boldwarning'>Youtube-dl URL retrieval FAILED:</span>")
					to_chat(src, "<span class='warning'>[stderr]</span>")

			if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
				return
			if(web_sound_url)
				for(var/obj/structure/overmap/om in get_area(src))
					if(om.pilot)
						if(om.pilot.client)
							var/client/CCE = om.pilot.client
							if((CCE.prefs.toggles & SOUND_MIDI) && CCE.chatOutput && !CCE.chatOutput.broken && CCE.chatOutput.loaded)
								CCE.chatOutput.sendMusic(web_sound_url, pitch)
					for(var/mob/M in om.linked_ship)
						if(M.client)
							var/client/C = M.client
							if((C.prefs.toggles & SOUND_MIDI) && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
								C.chatOutput.sendMusic(web_sound_url, pitch)
				for(var/mob/M in get_area(src))
					if(M.client)
						var/client/C = M.client
						if((C.prefs.toggles & SOUND_MIDI) && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
							C.chatOutput.sendMusic(web_sound_url, pitch)
		addtimer(CALLBACK(src, .proc/replay), 2000) //6 mins is the longest track length, this means it'll keep spamming songs every 6 minutes until someone gets into a fight and overrides it

/obj/effect/landmark/music_controller/proc/replay()
	playing = FALSE
	playing_danger = FALSE
	play()