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
			if(istype(S, /obj/structure/ladder/unbreakable/lift))
				var/obj/structure/ladder/unbreakable/lift/V = S
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

/obj/structure/overmap/shipwreck/Initialize()
	. = ..()
	announcedanger()

/obj/structure/overmap/proc/announcedanger()//GET THE FUCK OUTTA THAT WRECK BOYOH
	message_admins("a [true_name] class ship has been destroyed, it will respawn in about 2 mins")
	addtimer(CALLBACK(src, .proc/respawn), 400)

/obj/structure/overmap/proc/respawn() //Time's up to ditch the wreck, respawn time!
	weapons.deletearea()
	for(var/obj/effect/landmark/ShipSpawner/S in world)
		if(S.templatename == true_name)
			qdel(weapons)
			S.load()
			to_chat(world, "Respawning [true_name]..")
			qdel(src)
			return

/obj/structure/overmap/Destroy(var/severity = 1)
	if(faction)
		var/datum/faction/F
		for(var/datum/faction/S in SSfaction.factions)
			if(S.name == faction)
				F = S
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

/obj/effect/landmark/ShipSpawner/romulan
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	templatename = "dderidex"

/obj/effect/landmark/ShipSpawner/defiant
	name = "Ship spawning warp beacon"
	desc = "Spawns new ships!"
	templatename = "defiant"

/obj/effect/landmark/ShipSpawner/proc/load()
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/datum/map_template/template = SSmapping.ship_templates[templatename]
	if(!template)
		return FALSE
	template.load(T, centered = FALSE)
	return TRUE