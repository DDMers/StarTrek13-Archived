/turf/closed/wall/trek
	icon_state = "black"



turf/NonObjects
	heart
		icon = 'Images and icons/smallitems.dmi'
		icon_state = "heart"

turf
	open
		floor
			flaksim_trek
				start
					icon = 'Images and icons/smallitems.dmi'
					icon_state = "start"

				EraserSPOT
					layer = -2

				LightBlocker
					icon = 'Images and icons/smallitems.dmi'
					icon_state = "Light Blocker"
					alpha = 0
					opacity = 1
					density = 1
					layer = 9

				LightBlockerDoor
					icon = 'Images and icons/smallitems.dmi'
					icon_state = "Light Blocker Door"
					opacity = 1
					layer = 9

				DoorwayGlow
					icon = 'Images and icons/smallitems.dmi'
					icon_state = "DoorwayGlow"
					layer = 9

				Overlay1
					icon = 'Images and icons/Overlays.dmi'
					icon_state = "1"
					layer = 9

				Overlay2
					icon = 'Images and icons/Overlays.dmi'
					icon_state = "2"
					layer = 9

				Overlay3
					icon = 'Images and icons/Overlays.dmi'
					icon_state = "3"
					layer = 9

				Overlay4
					icon = 'Images and icons/Overlays.dmi'
					icon_state = "4"
					layer = 9

				Overlay5
					icon = 'Images and icons/Overlays.dmi'
					icon_state = "5"
					layer = 9

				CargoBay
					icon = 'Images and icons/Cargo Bay5.dmi'
					density = FALSE
					opacity = FALSE

				CargoBayOverlay
					icon = 'Images and icons/Cargo Bay Overlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE

				WarpRoom9
					icon = 'Images and icons/WarpRoom9.dmi'
					density = FALSE
					opacity = FALSE

				Brig5
					icon = 'Images and icons/Brig5.dmi'
					density = FALSE
					opacity = FALSE

				BrigOverlays
					icon = 'Images and icons/BrigOverlays.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE
				Library
					icon = 'Images and icons/Library3.dmi'

				Libraryoverlay
					icon = 'Images and icons/Library Overlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE

				Armory
					icon = 'Images and icons/Armory5.dmi'
					density = FALSE
					opacity = FALSE

				Armoryoverlay
					icon = 'Images and icons/Armory Overlay.dmi'
					layer = 9


				Maproom
					icon = 'Images and icons/Map room5.dmi'
					density = FALSE
					opacity = FALSE


				Doorways
					icon = 'Images and icons/Doorways.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE


				MedicalBay5
					icon = 'Images and icons/Medical Bay5.dmi'
					density = FALSE
					opacity = FALSE

obj
	structure
		table
			flaksim_trek
				Table
					icon = 'Images and icons/Table.dmi'
					density = FALSE
					opacity = FALSE
					smooth = FALSE

				Tableoverlay
					icon = 'Images and icons/Table Overlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE
					smooth = FALSE

				Table2
					icon = 'Images and icons/Table2.dmi'
					density = FALSE
					opacity = FALSE
					smooth = FALSE

				Table2overlay
					icon = 'Images and icons/Table2 Overlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE
					smooth = FALSE

				Table3
					icon = 'Images and icons/Table3.dmi'
					density = FALSE
					opacity = FALSE
					smooth = FALSE

				Table3overlay
					icon = 'Images and icons/Table3 Overlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE
					smooth = FALSE

				Table4
					icon = 'Images and icons/Table4.dmi'
					density = FALSE
					opacity = FALSE
					smooth = FALSE

				Table4overlay
					icon = 'Images and icons/Table4 Overlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE
					smooth = FALSE

/obj/structure/table/Desk1
	icon = 'Images and icons/Desk1.dmi'
	density = FALSE
	opacity = FALSE
	smooth = FALSE

/obj/structure/table/Desk1overlay
	icon = 'Images and icons/Desk1 Overlay.dmi'
	layer = 9
	density = FALSE
	opacity = FALSE
	smooth = FALSE


/turf/closed/wall/flaksim_trek/CanAtmosPass()
	if(density)
		return 0
	return 1

/turf/closed/wall/flaksim_trek/CanPass(atom/movable/AM)
	if(density)
		return 0
	return 1

turf
	closed
		wall
			flaksim_trek
				density = TRUE //Hereeee we gooo
				opacity = TRUE
				icon='Images and icons/Turfs.dmi'
				name = "hull"
				TrekWall1
					icon = 'Images and icons/TrekWall1.dmi'

				TrekWall3
					icon = 'Images and icons/TrekWall3.dmi'

				Panels1
					icon = 'Images and icons/Panels1.dmi'

				Panels2
					icon = 'Images and icons/Panels2.dmi'

				TrekWall2
					icon = 'Images and icons/TrekWall2.dmi'

				TrekHall1
					icon = 'Images and icons/TrekHall1.dmi'

				sovereignwall
					icon = 'Images and icons/sovereign wall.dmi'

				RoomWall
					icon = 'Images and icons/RoomWall.dmi'

				TeleportPad
					icon = 'Images and icons/TeleportPad.PNG'

				Bridge
					icon = 'Images and icons/Bridge.dmi'

				Panels3
					icon = 'Images and icons/Panels3.dmi'
					density = 1
					density = TRUE

				Panels4
					icon = 'Images and icons/Panels4.dmi'
					density = TRUE

				MapPanel
					icon = 'Images and icons/MapPanel.dmi'
					density = TRUE

				CoreOverlay
					icon = 'Images and icons/CoreOverlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE

				StairsOverlay
					icon = 'Images and icons/StairsOverlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE

				DockingBayOverlay
					icon = 'Images and icons/Docking Bay Overlay.dmi'
					layer = 9
					density = FALSE
					opacity = FALSE

				DockingBay5
					icon = 'Images and icons/Docking Bay5.dmi'
					density = FALSE
					opacity = FALSE

				Captainchair
					icon = 'Images and icons/Chair.dmi'

				Warpdoor
					icon = 'Images and icons/Warp Door.dmi'
					density = TRUE

				Warpdoor2
					icon = 'Images and icons/Warp Door 2.dmi'
					density = 1
					density = TRUE

				Turbolift
					icon = 'Images and icons/Lift2.PNG'

				TurboliftB
					icon = 'Images and icons/LiftB.PNG'

				TurboliftC
					icon = 'Images and icons/LiftC.PNG'

				TurboliftOverlay
					icon = 'Images and icons/Lift Overlay.PNG'
					layer = 9

				TurboliftOverlayB
					icon = 'Images and icons/Lift OverlayB.PNG'
					layer = 9

				TrophyWall
					icon = 'Images and icons/Trophies5.dmi'

				Replicator
					icon = 'Images and icons/replicator2.PNG'

				Bed
					icon = 'Images and icons/Bed.dmi'
					density = FALSE
					opacity = FALSE

				BedDouble
					icon = 'Images and icons/BedDouble.dmi'

				Crates
					icon = 'Images and icons/shipcrates.dmi'

				StationRoom2
					icon = 'Images and icons/StationRoom2.dmi'

				Stationwall
					icon = 'Images and icons/StationWall.dmi'

				Shuttle
					icon = 'Images and icons/Shuttle.PNG'

				SmallItems
					icon = 'Images and icons/smallitems.dmi'

GLOBAL_LIST_INIT(elevators, list())

obj
	structure
		turbolift
			var/Floor = 1
			var/in_use = FALSE //Someone already using us? then dont let randoms spam floors
			icon = 'StarTrek13/icons/trek/flaksim_structures.dmi'
			icon_state = "lift-open"
			density = FALSE
			mouse_over_pointer = MOUSE_HAND_POINTER
			name = "Turbolift"
			anchored = TRUE
			can_be_unanchored = FALSE
			desc = "Starfleet's decision to replace the iconic turboladder was not met with unanimous praise, experts citing increased obesity figures from crewmen no longer needing to climb vertically through several miles of deck to reach their target. Click it to use it."
			var/floor_directory = "<font color=yellow>Deck 1: Bridge <br>\
			Deck 2: Atmospherics, Library, Research<br>\
			Deck 3: Engineering<br>\
			Deck 4: Operations, Medical Bay, Transporter Room 1<br>\
			Deck 5: Crew Quarters, Mess Hall, Arboretum<br>\
			Deck 6: Hangar Bay, Primary Cargo Bays<br></font>"
			attack_hand(mob/user)
				. = ..()
				if(in_use)
					to_chat(user, "Turbolift is already in use. Please wait.")
					return
				if(!user in get_turf(src))
					return
				var/list/Levels = list()
				for(var/obj/structure/turbolift/S in GLOB.elevators)
					if(S.z == z)
						if(S.Floor != src.Floor && !S.in_use)
							Levels.Add(S.Floor)
				in_use = TRUE
				to_chat(user, floor_directory)
				var/max = max(Levels)
				var/S = input(user,"Select a deck (max: [max])") as num
				if(S > max || S <= 0)
					to_chat(user, "That floor doesn't exist.")
					in_use = FALSE
					return
				if(S)
					playsound(loc, 'StarTrek13/sound/turbolift/turbolift-close.ogg')
					icon_state = "lift-closed"
					for(var/obj/structure/turbolift/O in GLOB.elevators)
						if(O.z == z)
							if(O.Floor == S)
								density = TRUE
								opacity = TRUE
								for(var/obj/machinery/door/airlock/F in get_step(src, NORTH))
									F.close()
									F.bolt()
								user.say("[O.name]")
								shake_camera(user, 10, 50)
								for(var/mob/living/M in get_turf(src))
									SEND_SOUND(M, 'StarTrek13/sound/turbolift/turbolift.ogg')
								sleep(100) //change
								in_use = FALSE
								for(var/mob/living/M in get_turf(src))
									M.forceMove(get_turf(O))
									var/atom/movable/AM
									if(M.pulling)
										AM = M.pulling
										AM.forceMove(get_turf(O))
									if(AM)
										user.start_pulling(AM)
									to_chat(M,"<font color=yellow>Now at: [O.name]</font>")
								animate_opening()
								O.animate_opening()
								return TRUE
				else
					in_use = FALSE

/obj/structure/turbolift/proc/animate_opening()
	icon_state = "lift-opening"
	for(var/obj/machinery/door/airlock/F in get_step(src, NORTH))
		if(F)
			F.unbolt()
			F.open()
	sleep(20)
	icon_state = "lift-open"
	density = FALSE
	opacity = FALSE

/obj/structure/turbolift/Initialize()
	. = ..()
	GLOB.elevators += src


/obj/structure/turbolift/Destroy()
	GLOB.elevators -= src
	. = ..()

/obj/structure/turbolift/sov
	name = "Deck 1: Bridge"
	Floor = 1

/obj/structure/turbolift/sov/alt
	name = "Deck 1: Bridge (secondary)"

/obj/structure/turbolift/sov/d2
	name = "Deck 2: Astrometrics, Library, Research"
	Floor = 2

/obj/structure/turbolift/sov/d2/alt
	name = "Deck 2: Astrometrics, Library, Research (secondary)"

/obj/structure/turbolift/sov/d3
	name = "Deck 3: Engineering"
	Floor = 3

/obj/structure/turbolift/sov/d3/alt
	name = "Deck 3: Engineering (secondary)"

/obj/structure/turbolift/sov/d4
	name = "Deck 4: Ops, Medical Bay, Transporter Room 1"
	Floor = 4

/obj/structure/turbolift/sov/d4/alt
	name = "Deck 4: Ops, Medical Bay, Transporter Room 1 (secondary)"

/obj/structure/turbolift/sov/d5
	name = "Deck 5: Crew quarters, Mess Hall"
	Floor = 5

/obj/structure/turbolift/sov/d5/alt
	name = "Deck 5: Crew quarters, Mess Hall (secondary)"

/obj/structure/turbolift/sov/d6
	name = "Deck 6: Hangar Bay, Primary Cargo Bays"
	Floor = 6

/obj/structure/turbolift/sov/d6/alt
	name = "Deck 6: Hangar Bay, Primary Cargo Bays (secondary)"