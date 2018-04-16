
/turf/closed/wall/ship
	name = "hull"
	desc = "it makes you feel like you're on a starship"
	icon = 'StarTrek13/icons/trek/trek_wall.dmi'
	icon_state = "wall"
	smooth = 1
	canSmoothWith = list(/turf/closed/wall/ship,/obj/machinery/door/airlock/trek/tng,/turf/closed/indestructible/riveted,/turf/closed/wall/ship/tng,/obj/machinery/door/airlock/trek, /obj/structure/window,/obj/structure/grille,/obj/structure/window/trek,/turf/closed/wall/ship/steel,/obj/structure/window/trek/steel)

/turf/closed/wall/ship/tng
	name = "Corridor"
	icon = 'StarTrek13/icons/trek/trek_tng_wall.dmi'
	icon_state = "wall"

/turf/closed/wall/ship/tng/New()
	. = ..()
	set_light(5)

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
	outfit = /datum/outfit/job/crewman


/obj/machinery/door/airlock/trek/tng
	name = "airlock"
	icon = 'StarTrek13/icons/trek/trek_door.dmi'
	icon_state = "closed"
	overlays_file = 'StarTrek13/icons/trek/trek_door.dmi'

/obj/effect/turf_decal/trek
	icon_state = "trek_edge"
	icon = 'StarTrek13/icons/trek/trek_turfs.dmi'

/obj/effect/turf_decal/trek/cargo
	icon_state = "trek_edge_cargo"

/obj/effect/turf_decal/trek/warp
	icon_state = "trek_edge_warp"

/obj/effect/turf_decal/trek/number
	icon_state = "02"

//ALL THE THINGS BELOW WERE CREATED BY FLAKSIM, MANY THANKS TO THEM FOR ALLOWING ME TO USE THEM! ~Kmc//

/obj/structure/catwalk/cargo
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

/obj/structure/fluff/warpcore/massive
	name = "high powered warp core"
	desc = "This massive machine will propel your starship to unheard of speeds."
	icon = 'StarTrek13/icons/trek/warp_core_huge.dmi'
	icon_state = "warpcore"

/turf/open/floor/borg/trek/lit
	name = "lit carpet"
	desc = "it's lit up"
	smooth = SMOOTH_FALSE //change this when I make a smooth proper version

/turf/open/floor/borg/trek/lit/New()
	. = ..()
	set_light(10)

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


/turf/open/bridge_overlay
	icon = 'StarTrek13/icons/trek/bridge_overlay.PNG'
	name = "floor"

/turf/open/cargobay_overlay
	icon = 'StarTrek13/icons/trek/cargobay_overlay.PNG'
	name = "floor"

/turf/open/brig_overlay
	icon = 'StarTrek13/icons/trek/brig_overlay.PNG'
	name = "floor"

/turf/open/storagebay_overlay
	icon = 'StarTrek13/icons/trek/storagebay_overlay.PNG'
	name = "floor"

/obj/structure/trek_table
	name = "table"
	desc = "not to be confused with a functional table"
	icon = 'StarTrek13/icons/trek/hugetable.dmi'
	icon_state = "table"
	bound_x = 160
	bound_y = 96

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