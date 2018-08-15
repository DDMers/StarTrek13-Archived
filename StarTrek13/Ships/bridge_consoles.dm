/obj/structure/weapons_console
	name = "Tactical console"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "weapons"
	var/active = FALSE
	var/damage
	var/heat //Inherited from the subsystem
	var/charge
	var/datum/shipsystem/weapons/subsystem
	var/list/ships = list()
	var/obj/structure/overmap/ship/our_ship
	var/list/theicons = list()
	var/target_window
	density = 1
	anchored = 1
	var/obj/structure/overmap/target

/obj/structure/weapons_console/defiant
	icon = 'StarTrek13/icons/trek/defianttactical.dmi'
	name = "weapons station"
	icon_state = "weapons"

/obj/structure/helm/desk/functional/defiant
	icon = 'StarTrek13/icons/trek/defianttactical.dmi'
	icon_state = "shields"
	name = "shields station"

/obj/structure/weapons_console/romulan
	name = "Tactical console"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "rom-weapons"

/obj/structure/weapons_console/alt
	icon_state = "weapons_alt"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	pixel_x = -16
	pixel_y = -16
	density = 0
	anchored = 1

/obj/structure/weapons_console/Initialize(timeofday)
	. = ..()
	START_PROCESSING(SSobj,src)
	if(our_ship)
		subsystem = our_ship.SC.weapons
	if(subsystem)
		damage = subsystem.damage
		heat = subsystem.heat
		charge = subsystem.charge


/obj/structure/weapons_console/proc/get_ship_icon(atom/item,mob/user)
	return icon2html(item, user, EAST)
//	return icon2html(initial(item.icon), usr, state, NORTH)

/obj/structure/weapons_console/Topic(href, href_list) //For some reason, S is null
	..()
	//var/client/user = locate(href_list["clicker"])
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	if(user in orange(1, src))
	//	var/obj/structure/overmap/ship/S = locate(href_list["target"])
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		var/datum/shipsystem/SS = locate(href_list["system"])
	//	if(href_list["target"])
		//	target_window(S, L,1) //Clicker references the user
		if(href_list["system"])
			to_chat(L, "<span class='notice'>Now targeting: [SS] subsystem.</span>")
			our_ship.target_subsystem = SS
		if(href_list["flush"])
			to_chat(L, "Target reset.")
			target = null
	else
		target = null
		to_chat(user, "Move closer to [src]")


/obj/structure/weapons_console/attack_hand(mob/user)
	if(winget(user,"Weapons control","is-visible") == "false")
		target = null
	if(!target)
		var/list/L = list()
		for(var/obj/structure/overmap/OM in get_area(our_ship))
			if(istype(OM, /obj/structure/overmap))
				L += OM
		var/obj/structure/overmap/V = input("What ship shall we analyze?", "Weapons console)", null) in L
		target = V
		if(!V)
			return
	if(user in orange(1, src))
		for(var/obj/structure/overmap/ship/s in theicons)
			qdel(s)
		theicons = list()
		var/s = ""
		ships = list()
		for(var/obj/structure/overmap/D in get_area(our_ship)) //having to get close to ships was too irritating.
			ships += D
		subsystem = our_ship.SC.weapons
		damage = subsystem.damage
		heat = subsystem.heat
		charge = subsystem.charge
		s += "<B>CONTROL PANEL</B><BR>"
		s += "<A href='?src=\ref[src];flush=1;clicker=\ref[user]'>Reset Target</A><BR>"
		s += "<B>STATISTICS</B><BR>"
		s += "[our_ship] weapons subsystem:<BR>"
		s += "Heat: [heat] |"
		s += " Weapon power (Gigawatts): [damage] |"
		s += " Weapon charge: [charge] / [subsystem.max_charge]<BR>"
		var/ss = ""
		if(target)
			s += "<B> Target: [target] | Target Subsystem: [our_ship.target_subsystem]</B><BR>"
		var/thing = "Inactive"
		if(our_ship.target_subsystem)
			if(!istype(our_ship.target_subsystem, /datum/shipsystem))
				our_ship.target_subsystem = null
			if(!our_ship.target_subsystem.failed)
				thing = "Active"
			s += "Target subsystem health: [our_ship.target_subsystem.integrity] / [our_ship.target_subsystem.max_integrity] | Status: [thing]<BR>"
		if(target)
			s += "[icon2html(target.icon, user, target.icon_state, EAST)]<BR>"
		if(target)
			for(var/datum/shipsystem/S in target.SC.systems)
				ss += "<A href='?src=\ref[src];system=\ref[S];clicker=\ref[user]'>[icon2html(S.icon, user, S.icon_state, SOUTH)]</A>" //Subsystem icon things done by FTL, modified slightly be me
			s += ss
		var/datum/browser/popup = new(user, "Weapons control", name, 550, 550)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
		if(user.canUseTopic(src))
			addtimer(CALLBACK(src,/atom/proc/attack_hand, user), 20)
	else
		user = null
		return
