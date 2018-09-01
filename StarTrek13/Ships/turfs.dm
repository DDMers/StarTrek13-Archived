
/turf/closed/wall/ship
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/trek_wall.dmi'
	icon_state = "wall"
	smooth = 1
	canSmoothWith = list(/turf/closed/wall/ship,/obj/structure/window/trek/rom,/turf/closed/wall/ship/rom,/obj/machinery/door/airlock/trek/tng/voy/single,/obj/machinery/door/airlock/trek/tng,/obj/machinery/door/airlock/trek/tng/voy,/turf/closed/wall/ship/voy,/turf/closed/wall/ship/tng,/obj/machinery/door/airlock/trek, /obj/structure/window,/obj/structure/grille,/obj/structure/window/trek,/turf/closed/wall/ship/steel,/obj/structure/window/trek/steel)

/turf/closed/wall/ship/tng
	name = "Corridor"
	icon = 'StarTrek13/icons/trek/trek_tng_wall.dmi'
	icon_state = "wall"

/turf/closed/wall/ship/voy //Voyager style walls
	name = "Corridor"
	icon = 'StarTrek13/icons/trek/trek_voy_wall.dmi'
	icon_state = "wall"


/turf/closed/wall/ship/rom //Rommies be crazy
	name = "Corridor"
	icon = 'StarTrek13/icons/trek/trek_wall_rom.dmi'
	icon_state = "wall"

/obj/structure/window/trek/rom
	name = "window"
	desc = "A window."
	icon = 'StarTrek13/icons/trek/trek_wall_rom.dmi'
	icon_state = "window"
	density = 1
	layer = ABOVE_OBJ_LAYER //Just above doors
	CanAtmosPass = 0

/turf/closed/wall/ship/voy/Initialize(timeofday)
	. = ..()

/turf/closed/wall/ship/rom/Initialize(timeofday)
	. = ..()

/turf/closed/wall/ship/tng/Initialize(timeofday)
	. = ..()

/turf/closed/wall/ship/steel
	name = "steel hull"
	desc = "a more dull and grey ship hull, how boring..."
	icon = 'StarTrek13/icons/trek/NT_trek_wall.dmi'
	icon_state = "wall"
	smooth = 1

/obj/effect/mob_spawn/human/alive/trek
	icon_state = "sleeper"
	death = FALSE
	roundstart = FALSE
//	outfit = /datum/outfit/job/crewman


/obj/machinery/door/airlock/trek/tng
	name = "airlock"
	icon = 'StarTrek13/icons/trek/trek_door.dmi'
	icon_state = "closed"
	overlays_file = 'StarTrek13/icons/trek/trek_door.dmi'
	desc = "An advanced door designed in the future, now having relieved bipedal sentients the need to suffer the horror of raising their hands to go into another room."

/obj/machinery/door/airlock/trek/tng/voy/single
	name = "airlock"
	icon = 'StarTrek13/icons/trek/door_voy_single.dmi'
	icon_state = "closed"
	overlays_file = 'StarTrek13/icons/trek/door_voy_single.dmi'
	desc = "An advanced door designed in the future, now having relieved bipedal sentients the need to suffer the horror of raising their hands to go into another room."


/obj/machinery/door/airlock/trek/tng/jeffries
	name = "hatch"
	icon = 'StarTrek13/icons/trek/flaksim_jeffriestube_door.dmi'
	icon_state = "closed"
	overlays_file = 'StarTrek13/icons/trek/flaksim_jeffriestube_door.dmi'
	desc = "An advanced hatch designed in the future, now having relieved bipedal sentients the need to suffer the horror of raising their hands to go into another room."

/obj/machinery/door/airlock/trek/tng/voy
	name = "airlock"
	icon = 'StarTrek13/icons/trek/voy_door.dmi'
	icon_state = "closed"
	overlays_file = 'StarTrek13/icons/trek/voy_door.dmi'
	desc = "An advanced door designed in the future, now having relieved bipedal sentients the need to suffer the horror of raising their hands to go into another room."


/obj/machinery/door/airlock/trek/tng/single
	name = "airlock"
	icon = 'StarTrek13/icons/trek/trek_door_single.dmi'
	icon_state = "closed"

/obj/machinery/door/airlock/trek/tng/single/defiant
	name = "bulkhead"
	icon = 'StarTrek13/icons/trek/defiant_door.dmi'
	icon_state = "closed"

/obj/machinery/door/airlock/trek/tng/double
	name = "airlock"
	icon = 'StarTrek13/icons/trek/trek_door_double.dmi'
	icon_state = "closed"


/obj/effect/turf_decal/trek
	icon_state = "trek_edge"
	icon = 'StarTrek13/icons/trek/trek_turfs.dmi'

/obj/effect/turf_decal/trek
	icon_state = "trek_edge2"

/obj/effect/turf_decal/trek/grey
	icon_state = "trek_edge3"

/obj/effect/turf_decal/trek/cargo
	icon_state = "trek_edge_cargo"

/obj/effect/turf_decal/trek/warp
	icon_state = "trek_edge_warp"

/obj/effect/turf_decal/trek/number
	icon_state = "02"

//ALL THE THINGS BELOW WERE CREATED BY FLAKSIM, MANY THANKS TO THEM FOR ALLOWING ME TO USE THEM! ~Kmc//

/obj/structure/lattice/catwalk/cargo
	layer = TURF_LAYER + 0.5
	icon = 'StarTrek13/icons/trek/trek_turfs.dmi'
	icon_state = "cargogrille"
	name = "loading grille"
	desc = "Looks like a shuttle would land here."
	density = 0
	anchored = 1.0

/turf/closed/trek_raised
	density = 1
	opacity = 0
	blocks_air = 0
	name = "raised platform"
	desc = "You can't get up here...yet"
	icon = 'StarTrek13/icons/trek/trek_turfs.dmi'
	icon_state = "raised1"

/turf/closed/trek_raised/alt
	icon_state = "raised2"

/turf/closed/trek_raised/lift
	icon_state = "lift"
	name = "turbolift shaft"
	opacity = 1

/turf/open/floor/trek_cargo
	icon = 'StarTrek13/icons/trek/trek_turfs.dmi'
	icon_state = "cargofloor"

/turf/open/floor/borg/trek/lit
	name = "space carpet"
	desc = "the merits of a static charge generating material for flooring on a highly sensitive starship is questionable, but can you question that threadcount?"
	smooth = SMOOTH_FALSE //change this when I make a smooth proper version

/turf/open/floor/borg/trek/lit/Initialize()
	. = ..()

/obj/structure/fluff/ship/warpbooster
	name = "wall panel"
	desc = "a blue panel"
	icon = 'StarTrek13/icons/trek/trek_turfs.dmi'
	icon_state = "warpbooster"
	layer = 4.5
	anchored = 1
	density = 0
	can_be_unanchored = 0


/turf/closed/trek_raised/engineering
	icon_state = "1"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/trek_engineering.dmi'
	opacity = 0


/turf/closed/trek_raised/engineering/a
	icon_state = "2"


/turf/closed/trek_raised/engineering/b
	icon_state = "3"

/turf/closed/trek_raised/engineering/c
	icon_state = "4"

/turf/closed/trek_raised/engineering/d
	icon_state = "5"

/turf/closed/trek_raised/engineering/e
	icon_state = "6"

/turf/closed/trek_raised/engineering/f
	icon_state = "7"

/turf/closed/trek_raised/engineering/g
	icon_state = "8"

/turf/closed/trek_raised/engineering/h
	icon_state = "9"

/turf/closed/trek_raised/engineering/i
	icon_state = "10"

/turf/closed/trek_raised/engineering/j
	icon_state = "11"

/turf/closed/trek_raised/engineering/k
	icon_state = "12"

/turf/closed/trek_raised/engineering/l
	icon_state = "13"

/turf/closed/trek_raised/engineering/m
	icon_state = "14"

/turf/closed/trek_raised/engineering/n
	icon_state = "15"

/turf/closed/trek_raised/engineering/o
	icon_state = "16"

/turf/closed/trek_raised/engineering/p
	icon_state = "17"

/turf/closed/trek_raised/engineering/q
	icon_state = "18"

/turf/closed/trek_raised/engineering/r
	icon_state = "19"

/turf/closed/trek_raised/engineering/s
	icon_state = "20"

/turf/closed/trek_raised/engineering/t
	icon_state = "21"

/turf/closed/trek_raised/engineering/u
	icon_state = "22"

/turf/closed/trek_raised/engineering/v
	icon_state = "23"

/turf/closed/trek_raised/engineering/w
	icon_state = "24"

/turf/closed/trek_raised/engineering/x
	icon_state = "25"

/turf/closed/trek_raised/engineering/y
	icon_state = "26"

/turf/closed/trek_raised/engineering/z
	icon_state = "27"

/turf/closed/trek_raised/engineering/za
	icon_state = "28"

/turf/closed/trek_raised/engineering/zb
	icon_state = "29"



/turf/open/warp_room_overlay
	icon = 'StarTrek13/icons/trek/warp_room_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1


/obj/structure/promenade_overlay
	icon = 'StarTrek13/icons/trek/promenade_overlay.PNG'
	name = "promenade"
	density = 1
	CanAtmosPass = FALSE
	layer = 4.5
	anchored = 1
	can_be_unanchored = 0
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/turf/open/generic_overlay
	icon = 'StarTrek13/icons/trek/generic_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1

/turf/open/transporterblack
	icon = 'StarTrek13/icons/trek/transporter_black.PNG'
	name = "black"

/obj/structure/transporter_overlay
	icon = 'StarTrek13/icons/trek/transporterroom_overlay.PNG'
	name = "floor"
	density = 1
	CanAtmosPass = FALSE
	layer = 4.5
	anchored = 1
	can_be_unanchored = 0
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/turf/open/fighter_overlay
	icon = 'StarTrek13/icons/trek/fighter_interior_overlay.PNG'
	name = "floor"
	density = 1
	layer = 4.5
	blocks_air = 1

/obj/structure/helm/desk/tactical/nt/alt
	icon_state = "tactical_nt_alt"
	pixel_x = 14
	pixel_y = 16

/turf/open/bridge_overlay
	icon = 'StarTrek13/icons/trek/bridge_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1

/turf/open/bridge_overlay/alt
	icon = 'StarTrek13/icons/trek/bridge_voy_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1

/turf/open/bridge_overlay/galaxy
	icon = 'StarTrek13/icons/trek/galaxy_bridge_overlay.png'
	name = "floor"
	density = 1
	blocks_air = 1


/turf/open/bridge_overlay/defiant
	icon = 'StarTrek13/icons/trek/bridge_defiant_overlay.PNG'
	name = "bridge"
	density = 1
	blocks_air = 1

/turf/open/bridge_overlay/romulan
	icon = 'StarTrek13/icons/trek/romulan_bridge_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1

/turf/open/cargobay_overlay
	icon = 'StarTrek13/icons/trek/cargobay_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1


/turf/closed/messhall
	icon = 'StarTrek13/icons/trek/messhalloverlay.PNG'
	name = "windows"
	desc = "huge windows, wow.."
	density = 1
	blocks_air = 1


/turf/closed/trophies
	icon = 'StarTrek13/icons/trek/trophyoverlay.PNG'
	name = "trophy rack"
	desc = "A huge wall with a tasteful collection of miniature starships adorning it."
	density = 1
	blocks_air = 1


/turf/open/brig_overlay
	icon = 'StarTrek13/icons/trek/brig_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1
	layer = 2.8

/turf/open/storagebay_overlay
	icon = 'StarTrek13/icons/trek/storagebay_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1
	layer = 2.8

/turf/open/small_engineering_overlay
	icon = 'StarTrek13/icons/trek/warp_room_small_overlay.PNG'
	name = "floor"
	density = 1
	blocks_air = 1

/obj/structure/trek_table
	name = "table"
	desc = "not to be confused with a functional table"
	icon = 'StarTrek13/icons/trek/hugetable.dmi'
	icon_state = "table"
	bound_width = 96 // 3x2
	bound_height = 64

/obj/structure/chair/trek
	name = "chair"
	desc = "a hi-tech chair"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "chair"


/obj/structure/chair/trek/bridge
	name = "bridge chair"
	desc = "an extra padded chair, with full leather upholstery."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "bridgechair"

/obj/structure/special_trek_turf/brig/wall
	icon_state = "brig1"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 4.5
	pixel_x = -3
	pixel_y = -1

/obj/structure/special_trek_turf/cargobay
	icon_state = "cargobay"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 4.5
	pixel_x = -3
	pixel_y = 4

/obj/structure/special_trek_turf/dockingbay
	icon_state = "dockingbay"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 2.8
	pixel_x = -8
	pixel_y = 10

/obj/structure/special_trek_turf/bridge
	icon_state = "bridge1"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 4.5
	pixel_x = 6
	pixel_y = -7

/obj/structure/special_trek_turf/bridge/alt
	icon_state = "bridge2"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 4.5
	pixel_x = 6
	pixel_y = -6

/obj/structure/special_trek_turf/brig
	icon_state = "brig"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 4.5
	pixel_x = 20
	pixel_y = -13

/obj/structure/special_trek_turf
	icon_state = "black"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/trek_turfs.dmi'
	layer = 4.5
	pixel_x = 0
	pixel_y = 0
	opacity = 0
	density = FALSE
	anchored = TRUE
	can_be_unanchored = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF


/obj/structure/special_trek_turf/storagebay
	icon_state = "storagebay"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 4.5

/obj/structure/special_trek_turf/engibay
	icon_state = "engi1"
	name = "wall"
	desc = "No running through me please"
	icon = 'StarTrek13/icons/trek/special_turfs.dmi'
	layer = 4.5
	pixel_x = -4
	pixel_y = -1

/obj/machinery/door/window/brigdoor/trek
	name = "force field"
	icon_state = "leftsecure"
	base_state = "leftsecure"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	id = null
	max_integrity = 10000
	reinf = 1
	explosion_block = 1
	req_access_txt = "63"
	layer = 4.5

/obj/machinery/door/window/brigdoor/trek/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'StarTrek13/sound/borg/machines/shieldhit.ogg', 90, 1)
		if(BURN)
			playsound(src.loc, 'StarTrek13/sound/borg/machines/shieldhit.ogg', 100, 1)

/obj/machinery/door/window/brigdoor/trek/attackby(obj/item/I, mob/living/user, params)
	return ..()

/obj/machinery/door/window/brigdoor/trek/open(forced=0)
	if (src.operating == 1) //doors can still open when emag-disabled
		return 0
	if(!src.operating) //in case of emag
		operating = TRUE
	do_animate("opening")
	playsound(src.loc, 'StarTrek13/sound/borg/machines/shieldhit.ogg', 100, 1)
	src.icon_state ="[src.base_state]open"
	sleep(10)

	density = FALSE
//	src.sd_set_opacity(0)	//TODO: why is this here? Opaque windoors? ~Carn
	air_update_turf(1)
	update_freelook_sight()

	if(operating == 1) //emag again
		operating = FALSE
	return 1

/obj/machinery/door/window/brigdoor/trek/close(forced=0)
	if (src.operating)
		return 0
	operating = TRUE
	do_animate("closing")
	playsound(src.loc, 'StarTrek13/sound/borg/machines/shieldhit.ogg', 100, 1)
	src.icon_state = src.base_state
	density = TRUE
	air_update_turf(1)
	update_freelook_sight()
	sleep(10)

	operating = FALSE
	return 1
