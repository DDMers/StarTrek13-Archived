///See credits for who made these!///
/turf/closed/wall/trek
	name = "Starship hull" //Right click, generate instances by dir, then by icon_state
	desc = "It's like something out of star trek!"
	smooth = FALSE
	icon = 'StarTrek13/icons/trek/flaksim_walls.dmi'

/obj/structure/window/specialtrek
	name = "Starship viewport"
	icon = 'StarTrek13/icons/trek/flaksim_walls.dmi'
	icon_state = "window"
	smooth = FALSE

/obj/structure/table/trek
	name = "futuristic table"
	desc = "It's so futuristic, and smooth. You could really put things on it"
	icon = 'StarTrek13/icons/trek/flaksim_structures.dmi'
	smooth = FALSE

/turf/open/floor/hallway
	name = "Starship hull" //Right click, generate instances by dir, then by icon_state
	desc = "It's like something out of star trek!"
	smooth = FALSE
	icon = 'StarTrek13/icons/trek/flaksim_walls.dmi'
	icon_state = "hallway"
	CanAtmosPass = FALSE


/obj/structure/ladder/unbreakable/lift
	name = "turbolift"
	desc = "Suffer not a human to climb, this model of lift has phased out the primitive turboladders of yore, allowing rapid movement up and down!"
	icon = 'StarTrek13/icons/trek/flaksim_structures.dmi'

/obj/structure/ladder/unbreakable/Destroy(var/sev = 0)
	switch(sev)
		if(0)
			return 0
		else
			GLOB.ladders -= src
			. = ..()
			qdel(src)


/obj/structure/ladder/unbreakable/lift/show_fluff_message(going_up, mob/user)
	shake_camera(user, 2, 10)
	if(going_up)
		user.visible_message("[src] ascends.","<span class='notice'>The lift ascends.</span>")
	else
		user.visible_message("[src] descends.","<span class='notice'>The lift descends</span>")