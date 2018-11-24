#define WARP1 5

/obj/structure/fluff/helm/desk/tactical
	name = "tactical"
	desc = "A computer built into a desk, showing ship manifests, weapons, tactical systems, anything you could want really, the manifest shows a long list but the 4961 irradiated haggis listing catches your eye..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "desk"
	anchored = TRUE
	density = 1 //SKREE
	opacity = 0
	layer = 4.5
	var/list/weapons = list()
	var/list/redalertsounds = list('StarTrek13/sound/borg/machines/redalert.ogg')
	var/target = null
	var/cooldown2 = 190 //18.5 second cooldown
	var/saved_time = 0
	var/list/shipareas = list()
	var/obj/machinery/space_battle/shield_generator/shieldgen
	var/REDALERT = 0
	var/redalertsound
	var/area/target_area = null
	var/list/torpedoes = list()
	var/obj/structure/overmap/theship = null
	var/obj/effect/landmark/warp_beacon/targetBeacon = null
	anchored = 1
	var/starmapUI
	var/datum/looping_sound/trek/bridge/soundloop
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF //it's very bad if this dies
	var/list/zaps = list('StarTrek13/sound/trek/ship_effects/consolehit.ogg','StarTrek13/sound/trek/ship_effects/consolehit2.ogg','StarTrek13/sound/trek/ship_effects/consolehit3.ogg','StarTrek13/sound/trek/ship_effects/consolehit4.ogg')
	var/datum/effect_system/spark_spread/spark_system
	flags = HEAR

/obj/structure/fluff/helm/desk/tactical/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	if(theship && theship.pilot)
		message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mode)
		to_chat(theship.pilot,message)

/obj/structure/fluff/helm/desk/tactical/proc/explode_effect()
	var/sound = pick(zaps)
	playsound(src.loc, sound, 70,1)
	spark_system.start()
	playsound(src.loc, 'StarTrek13/sound/borg/machines/bleep1.ogg', 100,1)

/obj/structure/fluff/helm/desk/tactical/nanotrasen
	name = "tactical"
	desc = "Used to control all ship functions...this one looks slightly retro."
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"

/obj/structure/fluff/helm/desk/tactical/defiant
	name = "weapon control computer"
	desc = "Used to control all ship functions, this one looks extra sleek"
	icon = 'StarTrek13/icons/trek/defianttactical.dmi'
	icon_state = "tactical"

/obj/structure/fluff/helm/desk/tactical/galaxy
	name = "Helm"
	icon_state = "galaxytac"


/obj/structure/fluff/helm/desk/tactical/defiant/romulan
	redalertsounds = list('StarTrek13/sound/borg/machines/romulanredalert.ogg')
	cooldown2 = 50 //romulan alarm is really short
	pixel_x = -5
	icon_state = "rom-tactical"

/obj/structure/fluff/helm/desk/tactical/alt //only use this on runabouts...please
	icon_state = "tactical_nt_alt"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	pixel_x = 15
	pixel_y = 16
	density = 0
	layer = 4.6
	anchored = 1
	obj/structure/overmap/ship/runabout/theship

/obj/structure/fluff/helm/desk/tactical/alt/AltClick(mob/user)
	theship.exit(TRUE,TRUE,user)

/obj/structure/fluff/helm/desk/tactical/alt/ShiftClick(mob/user)
	theship.exit(TRUE,TRUE,user)

/obj/structure/fluff/helm/desk/tactical/process()
	if(!soundloop)
		soundloop = new(list(src), TRUE)
	var/area/thearea = get_area(src)
	if(REDALERT)
		if(world.time >= saved_time + cooldown2)
			saved_time = world.time
			for(var/mob/M in thearea)
				M << redalertsound

/obj/structure/fluff/helm/desk/tactical/Initialize(mapload)
	. = ..()
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(4,1,src)
	spark_system.attach(src)
	get_weapons()
	get_shieldgen()
	START_PROCESSING(SSobj,src)
//	var/area/thearea = get_area(src)

/obj/structure/fluff/helm/desk/tactical/proc/get_shieldgen()
	var/area/thearea = get_area(src)
	for(var/obj/machinery/space_battle/shield_generator/S in thearea)
		shieldgen = S
		S.controller = src
		return 1
	return 0


/obj/structure/fluff/helm/desk/tactical/proc/get_weapons()
	weapons = list()
	torpedoes = list()
	var/area/thearea = get_area(src)
	for(var/P in thearea)
		if(istype(P,/obj/machinery/ship/phaser))
			var/obj/machinery/ship/phaser/PP = P
			weapons += PP
	for(var/T in thearea)
		if(istype(T, /obj/structure/torpedo_launcher))
			var/obj/structure/torpedo_launcher/TT = T
			torpedoes += TT

/datum/asset/simple/starmap
	assets = list(
		"background.png"	= 'UI/starmap/helm_background_nogrid.png',
		"system.png"		= 'UI/starmap/system.png',
		"system_select.png" = 'UI/starmap/system_select.png',
		"swiss911.ttf"		= 'UI/starmap/Swiss911UCmBT.ttf',
		"navcomp.gif"		= 'StarTrek13/icons/trek/navcomp.gif',
		"tactical.gif"		= 'StarTrek13/icons/trek/tactical.gif'
	)

/obj/structure/fluff/helm/desk/tactical/attack_hand(mob/user)
	get_weapons()
	get_shieldgen()
	if(!theship)
		to_chat(user, "Your ship has been destroyed!")
	if(!user.skills.skillcheck(user, "piloting", 5))
		return
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/starmap)
	assets.send(user)
	var/s = "\
	<!-- Image Map Generated by http://www.image-map.net/ -->\
	<img src='tactical.gif' usemap='#image-map'>\
	<style>body{background-color:#000000}</style>\
	<map name='image-map'>\
	<area target='' alt='Helm' title='Helm' href='?src=\ref[src];helm=1;clicker=\ref[user]' coords='52,112,126,158' shape='rect'>\
	<area target='' alt='Red alert' title='Red alert' href='?src=\ref[src];redalert=1;clicker=\ref[user]' coords='334,62,383,83' shape='rect'>\
	<area target='' alt='Long range warp' title='Long range warp' href='?src=\ref[src];starmap=1;clicker=\ref[user]' coords='240,87,382,165' shape='rect'>\
	<area target='' alt='Announce' title='Announce' href='?src=\ref[src];announce=1;clicker=\ref[user]' coords='223,217,377,260' shape='rect'>\
	</map>"
	var/datum/browser/popup = new(user, "Operations", name, 700, 350)
	popup.set_content(s)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/structure/fluff/helm/desk/tactical/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/weaponsconsole)
	assets.send(user)
	if(user in orange(1, src))
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		if(href_list["fly"])
			theship.enter(user)
		if(href_list["warp2"])
			var/obj/machinery/power/warpcore/W = locate(/obj/machinery/power/warpcore) in get_area(src)
			var/cochranes
			var/list/warplist = list()
			var/maxwarp
			if(W)
				W.get_warp_factor()
				cochranes = W.cochranes
				if(!cochranes)
					to_chat(user, "Unable to warp, please check warp coil alignment.")
					return
				if(cochranes < WARP_1)
					warplist += 0
					return
				warplist += 0 //option to cancel
				if(cochranes >WARP_1)
					warplist += 1
				if(cochranes >WARP_2)
					warplist += 2
				if(cochranes >WARP_3)
					warplist += 3
				if(cochranes >WARP_4)
					warplist += 4
				if(cochranes >WARP_5)
					warplist += 5
				if(cochranes >WARP_6)
					warplist += 6
				if(cochranes >WARP_7)
					warplist += 7
				if(cochranes >WARP_8)
					warplist += 8
				if(cochranes >WARP_9)
					warplist += 9
				if(cochranes >WARP_10)
					warplist += 9.99999996
			else
				to_chat(L, "No warp core is present! Warping is not possible")
			if(!warplist.len)
				to_chat(L, "Insufficient warp power, ensure the warp coils are functional")
			var/speed = input(L,"Set warp factor", "Helm", null) in warplist
			switch(speed)
				if(0)
					return
				if(1)
					maxwarp = 1
				if(2)
					maxwarp = 3
				if(3)
					maxwarp = 5
				if(4)
					maxwarp = 7
				if(5)
					maxwarp = 9
				if(6)
					maxwarp = 11
				if(7)
					maxwarp = 13
				if(8)
					maxwarp = 20
				if(9)
					maxwarp = 30
				if(9.99999996)
					maxwarp = 35
			say(maxwarp)
			if(theship.SC.engines.try_warp())
				L.say("Ahead, warp [speed]")
				if(theship.pilot)
					to_chat(theship.pilot, "Helm has engaged warp factor [speed]")
				theship.max_speed = maxwarp //Speed limiter, or increaser
				for(var/mob/LT in theship.linked_ship)
					SEND_SOUND(LT, 'StarTrek13/sound/trek/ship_effects/warp.ogg')
			else
				to_chat(L, "Warping failed! Engines may not be recharged.")
			src.updateUsrDialog()
	else
		to_chat(user, "Move closer to [src]")
	if(href_list["helm"])
		var/s = ""
		s+= "<!-- Image Map Generated by http://www.image-map.net/ -->"
		s+= "<img src='navcomp.gif' usemap='#image-map'>"
		s+= "<style>body{background-color:#000000}</style>"
		s+= "<map name='image-map'>"
		s+="<area target='' alt='Warp' title='Warp' href='?src=\ref[src];warp2=1;clicker=\ref[user]' coords='76,210,0,301' shape='rect'>"
		s+="<area target='' alt='Pilot' title='Pilot ship' href='?src=\ref[src];fly=1;clicker=\ref[user]' coords='75,335,2,455' shape='rect'>"
		s+="</map>"
		var/datum/browser/popup1 = new(user, "Helm control", name, 661, 500)
		popup1.set_content(s)
		popup1.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup1.open()
	if(href_list["redalert"])
		redalert()
	if(href_list["announce"])
		if(user)
			var/message = stripped_input(user,"Communications.","Send a shipwide announcement:")
			if(!message)
				return
			var/announcement
			var/sound = 'StarTrek13/sound/trek/ship_effects/bosun.ogg'
			announcement += "<br><h2 class='alert'>Attention crew of [theship]:</h2>"
			announcement += "<br><span class='alert'>[html_encode(message)]</span><br>"
			announcement += "<br>"
			var/list/list = list()
			list += theship.pilot
			for(var/mob/living/M in theship.linked_ship)
				list += M
			for(var/mob/O in GLOB.dead_mob_list)
				list += O
			var/s = sound(sound)
			for(var/mob/M in list)
				if(!isnewplayer(M) && M.can_hear())
					to_chat(M, announcement)
					if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
						SEND_SOUND(M, s)
	if(href_list["starmap"])
		if(!theship.warp_capable || theship.max_warp <= 1)
			return
		var/mob/living/carbon/human/L = locate(href_list["clicker"]) //Bad client...WTF?
		if(L)
			var/list/beacon = list()
			for(var/obj/effect/landmark/warp_beacon/wb in warp_beacons)
				if(wb.z)
					beacon += wb.name
			beacon += "cancel"
			var/A = input(L,"Warp where?", "Weapons console", null) as anything in beacon
			if(!A)
				return
			if(A == "cancel")
				return
			var/obj/effect/landmark/warp_beacon/B
			for(var/obj/effect/landmark/warp_beacon/ww in warp_beacons)
				if(ww.name == A)
					B = ww
			if(A)
				theship.do_warp(B, B.distance)
			return
		var/datum/asset/assetsmap = get_asset_datum(/datum/asset/simple/starmap)
		assetsmap.send(user)
		starmapUI = "\
		<!DOCTYPE html>\
		<html>\
			<style>\
				@font-face {\
					font-family: 'swiss911 UCm BT';\
					src: url('swiss.ttf') format('truetype');\
					font-weight: normal;\
					font-style: normal;\
				}\
				html {\
					background-image: url('background.png');\
					background-repeat: no-repeat;\
					font-family: 'swiss911 UCm BT', 'Comic Sans MS';\
					background-color: black;\
					font-size: 18px;\
				}\
				#StarMap {\
					height: auto;\
					width: auto;\
				}\
				#StarMapGrid {\
					border-collapse: collapse;\
					position: absolute;\
					left: 80px;\
					top: 170px;\
					width: 459px;\
					height: 185px;\
					table-layout: fixed;\
					text-align: center;\
				}\
				td {\
					background-color: black;\
					border-collapse: collapse;\
					color: white;\
					border: 1px solid #9c6b29;\
					height: 50px;\
					width: 140px;\
				}\
				a:hover td {\
					background-color: #3e2a10;\
				}\
				a td div{\
					text-align: left;\
					height: 40px;\
					width: 100%;\
					background-image: url('system.png');\
					background-repeat: no-repeat;\
				}\
				a td div span{\
					position: relative;\
					top: 15px;\
					left: 48px;\
				}\
				#btn {\
					position: absolute;\
					left: 4px;\
					top: 262px;\
					background-color: #ce6363;\
					height: 119px;\
					width: 53px;\
					color: black;\
					text-decoration: none;\
				}\
				#btn:hover {\
					background-color: #cd7c76;\
				}\
				#btn span {\
					position: absolute;\
					bottom:0;\
					right:0;\
				}\
				#error {\
					position: absolute;\
					left: 170px;\
					top: 50%;\
					height: 30px;\
					width: 300px;\
					color: black;\
					background-color: red;\
					text-align: center;\
					padding-top: 10px;\
				}\
			</style>\
			<body>\
				<div id=\"StarMap\">\
					<table id=\"StarMapGrid\">\
						<tr>"
		var/r=0 //row
		var/c=0 //column
		if(!SSfaction.jumpgates_forbidden)
			//populate <table data> with star system info
			for(var/obj/effect/landmark/warp_beacon/wb in warp_beacons)
				if(wb.z)
					starmapUI += "<a href='?src=[REF(src)];beacon=[REF(wb)]' onclick=\"selectSystem(id)\" id=\"system[r][c]\"><td id=\"system\"><div id=\"system[r][c]img\"><span>[wb.name]</span></div> </td></a>"
					c++

				if(c==4)
					starmapUI += "</tr> <tr>"
					r++
					c=0

			//add the rest of the rows+columns to keep the elements tidy
		while(r!=4)
			c++
			starmapUI += "<td></td>"

			if(c==4)
				starmapUI += "</tr> <tr>"
				r++
				c=0

		starmapUI += 		"</tr>\
					</table>\
				</div>"
		if(!SSfaction.jumpgates_forbidden)
			starmapUI +=	"<a href='?src=[REF(src)];warp=1' onclick=\"deselectSystem()\">\
								"

		starmapUI += "<div id=\"btn\">\
						<span>\
							WARP\
						</span>\
					</div>\
				</a>"
		if(SSfaction.jumpgates_forbidden)
			starmapUI += "<div id=\"error\">ERROR: Subspace distortions prevent warping at this time</div>"

		starmapUI += "\
				<script>\
					var img;\
					function selectSystem(id) {\
						if(img)\
						{\
							img.style.backgroundImage = \"url('system.png')\";\
						}\
						img = document.getElementById(id+\"img\");\
						img.style.backgroundImage = \"url('system_select.png')\";\
					}\
					function deselectSystem() {\
						if(img)\
						{\
							img.style.backgroundImage = \"url('system.png')\"\
						}\
					}\
				</script>\
			</body>\
		</html>"
		var/datum/browser/popupss = new(user, "Long range warp", name, 661, 500)
		popupss.set_content(starmapUI)
		popupss.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popupss.open()
//	if(href_list["warp"] && targetBeacon)
	if(href_list["warp"]) //Bootstrap fix until I can unfuck things
		var/mob/living/carbon/human/L = locate(href_list["clicker"]) //Bad client...WTF?
		var/obj/effect/landmark/warp_beacon/A = input(L,"Warp where?", "Weapons console)", null) as obj in warp_beacons
		if(A)
			theship.do_warp(A, A.distance)
	if(href_list["beacon"])
		targetBeacon = locate(href_list["beacon"])


/*
/obj/structure/fluff/helm/desk/tactical/attack_hand(mob/user)
	get_weapons()
	get_shieldgen()
	if(!theship)
		to_chat(user, "Your ship has been destroyed!")
	if(!user.skills.skillcheck(user, "piloting", 5))
		return
	playsound(src.loc, 'StarTrek13/sound/borg/machines/alertbuzz.ogg', 100,1)
	var/mode = input("Tactical console.", "Do what?")in list("fly ship", "remove pilot", "shield control", "red alert siren", "starmap", "announce")
	starmapUI = "\
	<!DOCTYPE html>\
	<html>\
		<style>\
			@font-face {\
				font-family: 'swiss911 UCm BT';\
				src: url('swiss.ttf') format('truetype');\
				font-weight: normal;\
				font-style: normal;\
			}\
			html {\
				background-image: url('background.png');\
				background-repeat: no-repeat;\
				font-family: 'swiss911 UCm BT', 'Comic Sans MS';\
				background-color: black;\
				font-size: 18px;\
			}\
			#StarMap {\
				height: auto;\
				width: auto;\
			}\
			#StarMapGrid {\
				border-collapse: collapse;\
				position: absolute;\
				left: 80px;\
				top: 170px;\
				width: 459px;\
				height: 185px;\
				table-layout: fixed;\
				text-align: center;\
			}\
			td {\
				background-color: black;\
				border-collapse: collapse;\
				color: white;\
				border: 1px solid #9c6b29;\
				height: 50px;\
				width: 140px;\
			}\
			a:hover td {\
				background-color: #3e2a10;\
			}\
			a td div{\
				text-align: left;\
				height: 40px;\
				width: 100%;\
				background-image: url('system.png');\
				background-repeat: no-repeat;\
			}\
			a td div span{\
				position: relative;\
				top: 15px;\
				left: 48px;\
			}\
			#btn {\
				position: absolute;\
				left: 4px;\
				top: 262px;\
				background-color: #ce6363;\
				height: 119px;\
				width: 53px;\
				color: black;\
				text-decoration: none;\
			}\
			#btn:hover {\
				background-color: #cd7c76;\
			}\
			#btn span {\
				position: absolute;\
				bottom:0;\
				right:0;\
			}\
			#error {\
				position: absolute;\
				left: 170px;\
				top: 50%;\
				height: 30px;\
				width: 300px;\
				color: black;\
				background-color: red;\
				text-align: center;\
				padding-top: 10px;\
			}\
		</style>\
		<body>\
			<div id=\"StarMap\">\
				<table id=\"StarMapGrid\">\
					<tr>"
	var/r=0 //row
	var/c=0 //column
	if(!SSfaction.jumpgates_forbidden)
		//populate <table data> with star system info
		for(var/obj/effect/landmark/warp_beacon/wb in warp_beacons)
			if(wb.z)
				starmapUI += "<a href='?src=[REF(src)];beacon=[REF(wb)]' onclick=\"selectSystem(id)\" id=\"system[r][c]\"><td id=\"system\"><div id=\"system[r][c]img\"><span>[wb.name]</span></div> </td></a>"
				c++

			if(c==4)
				starmapUI += "</tr> <tr>"
				r++
				c=0

		//add the rest of the rows+columns to keep the elements tidy
	while(r!=4)
		c++
		starmapUI += "<td></td>"

		if(c==4)
			starmapUI += "</tr> <tr>"
			r++
			c=0

	starmapUI += 		"</tr>\
				</table>\
			</div>"
	if(!SSfaction.jumpgates_forbidden)
		starmapUI +=	"<a href='?src=[REF(src)];warp=1' onclick=\"deselectSystem()\">\
							"

	starmapUI += "<div id=\"btn\">\
					<span>\
						WARP\
					</span>\
				</div>\
			</a>"
	if(SSfaction.jumpgates_forbidden)
		starmapUI += "<div id=\"error\">ERROR: Subspace distortions prevent warping at this time</div>"

	starmapUI += "\
			<script>\
				var img;\
				function selectSystem(id) {\
					if(img)\
					{\
						img.style.backgroundImage = \"url('system.png')\";\
					}\
					img = document.getElementById(id+\"img\");\
					img.style.backgroundImage = \"url('system_select.png')\";\
				}\
				function deselectSystem() {\
					if(img)\
					{\
						img.style.backgroundImage = \"url('system.png')\"\
					}\
				}\
			</script>\
		</body>\
	</html>"

	switch(mode)
		if("choose target")
			theship.exit(user)
		//	var/A
	//		A = input("Area to fire on", "Tactical Control", A) as anything in shipareas
	//		target_area = shipareas[A]
	//		new_target()
	//		for(var/obj/machinery/power/ship/phaser/P in weapons)
	//			P.target = target
	//		for(var/obj/structure/torpedo_launcher/T in torpedoes)
	//			T.target = target
		if("fly ship")
			var/datum/skill/piloting/S = user.skills.getskill("piloting")
			if(!S.value >= theship.pilot_skill_req)//This should change per-ship
				to_chat(user, "<span class='warning'>You're not skilled enough to pilot this vessel!<span>")
				return
			theship.enter(user)
		//	fire_phasers(target, user)
		if("shield control")
			shieldgen.toggle(user)
		if("red alert siren")
			redalert()
		if("fire torpedo")
			fire_torpedo(target,user)
		if("starmap")
			var/datum/asset/assets = get_asset_datum(/datum/asset/simple/starmap)
			assets.send(user)
			user << browse(starmapUI, "window=StarMap;size=660x420")
		if("announce")
			var/message = stripped_input(user,"Communications.","Send a shipwide announcement:")
			if(!message)
				return
			var/announcement
			var/sound = 'StarTrek13/sound/trek/ship_effects/bosun.ogg'
			announcement += "<br><h2 class='alert'>Shipwide announcement:</h2>"
			announcement += "<br><span class='alert'>[html_encode(message)]</span><br>"
			announcement += "<br>"
			var/list/list = list()
			list += theship.pilot
			for(var/mob/living/M in theship.linked_ship)
				list += M
			for(var/mob/O in GLOB.dead_mob_list)
				list += O
			var/s = sound(sound)
			for(var/mob/M in list)
				if(!isnewplayer(M) && M.can_hear())
					to_chat(M, announcement)
					if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
						SEND_SOUND(M, s)
*/

/obj/structure/fluff/helm/desk/tactical/proc/redalert()
	redalertsound = pick(redalertsounds)
	if(REDALERT)
		src.say("RED ALERT DEACTIVATED")
		REDALERT = FALSE
		var/area/a = theship.linked_ship
		a.fire = FALSE
		for(var/obj/machinery/light/L in a)
			L.update()
		return 0
	else
		src.say("RED ALERT ACTIVATED")
		REDALERT = TRUE
		var/area/a = theship.linked_ship
		a.fire = TRUE
		for(var/obj/machinery/light/L in a)
			L.update()
		return 1

/obj/structure/fluff/helm/desk/tactical/proc/fire_phasers(atom/target, mob/user)
	playsound(src.loc, 'StarTrek13/sound/borg/machines/bleep1.ogg', 100,1)

/obj/structure/fluff/helm/desk/tactical/proc/fire_torpedo(turf/target,mob/user)
	for(var/obj/structure/torpedo_launcher/T in torpedoes)
		src.say("firing torpedoes at [target_area.name]")
		T.fire(target, user)
		playsound(src.loc, 'StarTrek13/sound/borg/machines/bleep2.ogg', 100,1)
		to_chat(user, "attempting to fire torpedoes")



/obj/structure/fluff/helm/desk/tactical/proc/new_target()
	var/list/L = list()
	for(var/turf/T in get_area_turfs(target_area.type))
		L+=T
	var/location = pick(L)
	target = location

