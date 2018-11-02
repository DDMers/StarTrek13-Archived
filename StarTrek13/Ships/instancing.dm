GLOBAL_LIST_INIT(ship_names, world.file2list("strings/names/ships.txt"))
GLOBAL_LIST_INIT(romulan_ship_names, world.file2list("strings/names/romulan_ship_names.txt"))

/atom/proc/deletearea(var/area/A)
	if(!A)
		A = get_area(src)
	for(var/atom/S in A) //We're adding istypes here to force the game to check for specific troublemakers
		if(istype(S, /obj/structure/girder))
			qdel(S)
		if(istype(S, /turf/open))
			var/turf/T = S
			T.ChangeTurf(/turf/open/space/basic)
		if(istype(S, /obj/structure))
			if(istype(S, /obj/structure/ladder/unbreakable))
				var/obj/structure/ladder/unbreakable/V = S
				V.Destroy(1)
			qdel(S)
		if(istype(S, /obj/machinery))
			qdel(S)
		if(istype(S, /obj/item))
			if(istype(S, /obj/item/radio))
				qdel(S)
			if(istype(S, /obj/item/stack))
				qdel(S)
			if(istype(S, /obj/item/stack/sheet/metal))
				qdel(S)
			else
				qdel(S)
		if(istype(S, /mob))
			if(!istype(S, /mob/dead))
				to_chat(S, "you're filled with an overwhelming sense of dread as the wreck around you deteriorates completely.")
				qdel(S)
	return TRUE

/obj/structure/overmap
	var/respawning = FALSE

/obj/structure/overmap/shipwreck/proc/announcedanger()//GET THE FUCK OUTTA THAT WRECK BOYOH
	message_admins("a [true_name] class ship has been destroyed, it will respawn in about 2 mins")
	addtimer(CALLBACK(src, .proc/respawn), 400)

/obj/structure/overmap/shipwreck/proc/respawn() //Time's up to ditch the wreck, respawn time!
	if(!respawning)
		respawning = TRUE
		if(weapons.deletearea())
			for(var/obj/effect/landmark/ShipSpawner/S in world)
				if(S.templatename == true_name)
					if(weapons)
						qdel(weapons)
					to_chat(world, "Respawning [true_name]..")
					if(S.load())
						qdel(src)
					return

/obj/structure/overmap/Destroy(var/severity = 1)
	SSticker.mode.check_win()
	if(faction)
		var/datum/faction/F
		for(var/datum/faction/S in SSfaction.factions)
			if(S.name == faction)
				F = S
		if(F)
			priority_announce("[name] has been destroyed! we are dispatching a replacement. [cost] credits has been deducted from your allowance to pay for the replacement ship.", "Communication from: [F]", 'StarTrek13/sound/trek/ship_effects/bosun.ogg')
			F.credits -= cost
	. = ..()

/obj/structure/overmap/proc/SetName(var/string)
	if(!string)
		string = pick(GLOB.ship_names)
	name =  string //Keep true name seperate for respawning
	linked_ship.name = "[string] ([true_name] class)"
	message_admins("[true_name] has been renamed to [name]")

/obj/structure/overmap/ship/romulan/SetName(string)
	if(!string)
		string = pick(GLOB.romulan_ship_names)
	name = string //Keep true name seperate for respawning
	linked_ship.name = "[string] ([true_name] class)"
	message_admins("[true_name] has been renamed to [name]")

/datum/map_template/ship/sovereign
	name = "sovereign"
	mappath = "_maps/templates/StarTrek13/sov2.dmm"

/datum/map_template/ship/defiant
	name = "defiant"
	mappath = "_maps/templates/StarTrek13/defiant.dmm"

/datum/map_template/ship/galaxy
	name = "galaxy"
	mappath = "_maps/templates/StarTrek13/galaxy.dmm"

/datum/map_template/ship/miranda
	name = "miranda"
	mappath = "_maps/templates/StarTrek13/miranda.dmm"

/datum/map_template/ship/mirandaDIY
	name = "mirandaDIY"
	mappath = "_maps/templates/StarTrek13/mirandaDIY.dmm"

/datum/map_template/ship/romulan
	name = "dderidex"
	mappath = "_maps/templates/StarTrek13/dderidex.dmm"

/datum/map_template/ship/yeet
	name = "yeet"
	mappath = "_maps/templates/StarTrek13/yeet.dmm"

/obj/effect/landmark/ShipSpawner
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	var/templatename = "sovereign"
	var/loading

/obj/effect/landmark/ShipSpawner/romulan
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	templatename = "dderidex"

/obj/effect/landmark/ShipSpawner/defiant
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	templatename = "defiant"

/obj/effect/landmark/ShipSpawner/miranda
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	templatename = "miranda"

/obj/effect/landmark/ShipSpawner/miranda/DIY
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	templatename = "mirandaDIY"

/obj/effect/landmark/ShipSpawner/galaxy
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	templatename = "galaxy"

/obj/effect/landmark/ShipSpawner/proc/load()
	if(!loading)
		loading = TRUE
		var/turf/T = get_turf(src)
		if(!T)
			return FALSE
		var/datum/map_template/template = SSmapping.ship_templates[templatename]
		if(!template)
			return FALSE
		if(template.load(T, centered = FALSE))
			loading = FALSE
		return TRUE


/obj/effect/landmark/crewspawnermachine //This ensures that when ships respawn, a new crew respawns with them! Mappers, ONLY place this on the TEMPLATE of your map in our templates folder, starfleet_ships.dmm etc don't need this, or they'll spawn infinity humans
	name = "crew spawning point"
	desc = "this is created alongside spawned in ships, it'll automagically spawn some humans, equip them, and offer them to ghosts!"
	var/humanstomake = 8 //human machine gotta spit out humans
	var/faction = "starfleet"
	var/datum/faction/thefaction //What's the datum ref of the faction we're spawning these jokers into :b1:

/obj/effect/landmark/crewspawnermachine/romulan
	faction = "romulan empire"

/obj/effect/landmark/crewspawnermachine/Initialize()
	. = ..()
	spawn_crew()

/obj/effect/landmark/crewspawnermachine/proc/spawn_crew() //this is a machine that spawns crew, HOW DID I LEARN TO CODE THIS?!!! -Nickvr circa 2017
	for(var/datum/faction/F in SSfaction.factions)
		if(F.name == faction)
			thefaction = F
			break
	for(var/i = 1 to humanstomake)
		var/turf/t = get_turf(src)
		var/mob/living/carbon/human/S = new(t)
		if(thefaction)
			thefaction.addMember(S) //This stops romulans getting the same rommie name they always use
		switch(i) //We're prioritising the really critical jobs first
			if(0 to 1) //we'll make a captain first shall we?
				S.equipOutfit(/datum/outfit/job/captain)
			if(2) //we need someone to set up the engines, posthaste!
				S.equipOutfit(/datum/outfit/job/ce)
			if(3)
				S.equipOutfit(/datum/outfit/job/cmo)
			if(4) //the rest are non essential
				S.equipOutfit(/datum/outfit/job/hos)
			if(5)
				S.equipOutfit(/datum/outfit/job/security)
			if(6)
				S.equipOutfit(/datum/outfit/job/engineer)
			if(7)
				S.equipOutfit(/datum/outfit/job/pilot)
			if(8)
				S.equipOutfit(/datum/outfit/job/security)
			if(9)
				S.equipOutfit(/datum/outfit/job/engineer)
		offer_control(S) //now offer them to ghosts!
		if(!S.mind || !S.client)
			qdel(S) //No players want to fill this one up, kill them.
		to_chat(S, "<span_class='warning'>All past lives are forgotten! You are a new character who has just been assigned to a new ship. You should act differently to any previous characters you've played this round.")
		i ++
	message_admins("Respawned a crew at [get_area(src)]")