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
		if(istype(P,/obj/machinery/power/ship/phaser))
			var/obj/machinery/power/ship/phaser/PP = P
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
		"swiss911.ttf"		= 'UI/starmap/Swiss911UCmBT.ttf'
	)

/obj/structure/fluff/helm/desk/tactical/attack_hand(mob/user)
	playsound(src.loc, 'StarTrek13/sound/borg/machines/alert2.ogg', 100,1)
	get_weapons()
	get_shieldgen()
	if(!theship)
		to_chat(user, "Your ship has been destroyed!")
	if(!user.skills.skillcheck(user, "piloting", 5))
		return

	playsound(src.loc, 'StarTrek13/sound/borg/machines/alertbuzz.ogg', 100,1)
	var/mode = input("Tactical console.", "Do what?")in list("fly ship", "remove pilot", "shield control", "red alert siren", "starmap")
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

/obj/structure/fluff/helm/desk/tactical/Topic(href, href_list)
	..()
	if(href_list["warp"] && targetBeacon)
		theship.do_warp(targetBeacon, targetBeacon.distance)
		targetBeacon = null

	if(href_list["beacon"])
		targetBeacon = locate(href_list["beacon"])

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

