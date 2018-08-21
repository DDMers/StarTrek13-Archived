//NOTE TO SELF:
//Make destroy do something, otherwise it seriously glitches out the pilot!

/area/ // fuck your idea of shoving everything into one file
	var/current_overmap = "none" // current map an area is on.

var/global/list/overmap_objects = list()
var/global/list/global_ship_list = list()

/area/overmap
	name = "Sector 417542 (Federation space)"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	flags = NONE
	requires_power = FALSE
	var/jumpgate_position = 1 //Change me! whenever you add a new system, incriment this by 1!

/area/overmap/s2
	name = "Sector 417543 (Neutral zone)"

/*E
/area/overmap/Entered(A)
	set waitfor = FALSE
	if(!isliving(A))
		return

	var/mob/living/L = A
	if(!L.ckey)
		return

	// Ambience goes down here -- make sure to list each area separately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(L.client && !L.client.ambience_playing && L.client.prefs.toggles & SOUND_SHIP_AMBIENCE)
		L.client.ambience_playing = 1

	if(!(L.client && (L.client.prefs.toggles & SOUND_AMBIENCE)))
		return //General ambience check is below the ship ambience so one can play without the other

	if(prob(100))
		var/sound = pick(ambientsounds)

		if(!L.client.played)
			SEND_SOUND(L, sound(sound, repeat = 0, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))
			L.client.played = TRUE
			addtimer(CALLBACK(L.client, /client/proc/ResetAmbiencePlayed), 800)
*/

/area/overmap/hyperspace
	name = "hyperspace"
	parallax_movedir = 8

/area/overmap/system
	name = "Sol (NT)"
	jumpgate_position = 2
	music = 'StarTrek13/sound/ambience/bsgtheme2.ogg'

/area/overmap/system/z2
	name = "Amann" //Test
	jumpgate_position = 3

/area/overmap/system/z3
	name = "Reb'ase" //Test
	jumpgate_position = 4

/area/overmap/system/z4
	name = "Neutral Zone (Romulan)" //Test
	jumpgate_position = 5

/area/overmap/system/z5
	name = "Ursa minor (BORG)" //Test
	jumpgate_position = 6


/area/overmap/system/z6
	name = "Ursa major (FED)" //Test
	jumpgate_position = 7
	music = 'StarTrek13/sound/ambience/trektheme1.ogg'

/obj/structure/space_object
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	name = "Sun"
	desc = "Don't get too close to it...."
	anchored = 1
	can_be_unanchored = 0
	icon_state = "sun"
	layer = 2

/obj/structure/space_object/supernova
	name = "Supernova"
	desc = "A star that has gone nova."
	icon_state = "supernova"

/obj/structure/space_object/earth
	name = "Earth"
	desc = "An utterly uninteresting little blue green planet situated in the unfashionable end of the western spiral arm of the galaxy."
	icon_state = "earth"

/obj/structure/space_object/rocky
	name = "Class D planetoid"
	desc = "A lifeless chunk of rock"
	icon_state = "rockyplanet"


/obj/structure/space_object/planet
	name = "Uncharted planet"
	desc = "A planet whose composition is unknown."
	icon_state = "1"


/obj/structure/space_object/nebula
	name = "Nebula"
	desc = "I wouldn't fly into that if I were you."
	icon_state = "nebula"

/obj/structure/overmap/lavaland
	name = "VY Canis Minoris XXIV"
	desc = "A lizard infested infernal shithole of a rock. Why the hell would anyone but /tg/ EVER want to set foot on it?"
	icon_state = "lavaland"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	spawn_name = "lavaland_spawn"
	layer = 2
	can_move = FALSE
	max_health = 1000000
	health = 1000000

/obj/structure/space_object/simulated
	name = "star"
	desc = "Flying into this always end up with horridly amazing fun!"
	var/cooldown = 30 //once every three seconds, to prevent it from just spamming the shit out of it
	var/time_elapse
	pixel_x = -128
	pixel_y = -128

/obj/structure/space_object/simulated/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/space_object/simulated/process()
	if(time_elapse > world.time)
		return

	for(var/obj/structure/overmap/S in orange(src, 6))
		if(!S.shields_active)
			to_chat(S.pilot, "Warning: hull temperature rising.")
			var/turf/open/floor/picked_turf = pick(get_area_turfs(S.linked_ship))
			picked_turf.atmos_spawn_air("plasma=60;TEMP=3000")
			time_elapse = world.time + cooldown

/area/ship
	parallax_movedir = FALSE
	name = "USS Cadaver"
	icon_state = "ship"
	requires_power = 1 //what have i unleashed unto this world
	has_gravity = 1 //Grav plates will stay on as long as the area is powered.
	noteleport = 0
	blob_allowed = 0
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	var/obj/item/clothing/neck/combadge/combadges = list()

//Starfleet
/area/ship/test
	name = "USS Runtime"

/area/ship/federation/starbase
	name = "Starbase 1"
	icon_state = "ship"

/area/ship/romulan
	name = "Decius"
	icon_state = "ship"

/area/ship/federation/entax
	name = "USS Entax"
	icon_state = "ship"

/area/ship/federation/sovreign
	name = "USS Sovereign"
	icon_state = "ship"

/area/ship/borg_freighter


//Nanotrasen

/area/ship/nanotrasen
	name = "NSV Muffin"
	icon_state = "ship"

/area/ship/nanotrasen/fighter
	name = "NSV Hagan"
	icon_state = "ship"

/area/ship/nanotrasen/cruiser
	name = "NSV Hyperion"
	icon_state = "ship"

/area/ship/nanotrasen/freighter
	name = "NSV Crates"
	icon_state = "ship"

/area/ship/nanotrasen/capital_class
	name = "NSV Annulment"
	icon_state = "ship"

/area/ship/nanotrasen/ss13
	name = "Space Station 13"
	icon_state = "ship"

/area/ship/overmap/nanotrasen/research
	name = "NSV Woolf research outpost"
	icon_state = "ship"

/area/ship/overmap/nanotrasen/trading_outpost
	name = "NSV Mercator trade station."
	icon_state = "ship"

//Borg

/area/ship/borg
	name = "Unimatrix 1-3"
	icon_state = "ship"