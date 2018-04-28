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

/obj/structure/weapons_console/New()
	. = ..()
	START_PROCESSING(SSobj,src)
	subsystem = our_ship.SC.weapons
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
			if(!subsystem.failed)
				if(subsystem.charge > 3000)
					to_chat(L, "<span class='notice'>Flushing weapons system.</span>")
					to_chat(our_ship.pilot, "<span class='notice'>Reycling weapons ./--</span>")
					subsystem.heat -= 20
					subsystem.charge = 0
					return
				else
					to_chat(L, "<span class='notice'>You cannot do this now.</span>")

	else
		to_chat(user, "Move closer to [src]")


/obj/structure/weapons_console/attack_hand(mob/user)
	if(winget(user,"Weapons control","is-visible") == "false")
		target = null
	if(user in orange(1, src))
		for(var/obj/structure/overmap/ship/s in theicons)
			qdel(s)
		theicons = list()
		var/s = ""
		ships = list()
		for(var/obj/structure/overmap/D in our_ship.interactables_near_ship)
			ships += D
		subsystem = our_ship.SC.weapons
		damage = subsystem.damage
		heat = subsystem.heat
		charge = subsystem.charge
		s += "<B>CONTROL PANEL</B><BR>"
		s += "<A href='?src=\ref[src];flush=1;clicker=\ref[user]'>Reycle weapon system (Recycles the weapons to cool them)</A><BR>"
		s += "<B>STATISTICS</B><BR>"
		s += "[our_ship] weapons subsystem:<BR>"
		s += "Heat: [heat] |"
		s += " Weapon power (Gigawatts): [damage] |"
		s += " Weapon charge: [charge] / [subsystem.max_charge]<BR>"
		var/ss = ""
		if(!target)
			var/obj/structure/overmap/V = input("What ship shall we analyze?", "Weapons console)", null) in our_ship.interactables_near_ship
			target = V
		var/obj/structure/overmap/P = new
		try:
			P.icon = target.icon
			P.icon_state = "[target.icon_state]-full"
		catch:
			qdel(P)
		s += "<B> Target: [target] | Target Subsystem: [our_ship.target_subsystem]</B><BR>"
		var/thing = "Inactive"
		if(our_ship.target_subsystem)
			if(!our_ship.target_subsystem.failed)
				thing = "Active"
			s += "Target subsystem health: [our_ship.target_subsystem.integrity] / [our_ship.target_subsystem.max_integrity] | Status: [thing]<BR>"
		s += "[icon2html(P.icon, user, P.icon_state, EAST)]<BR>"
		qdel(P)
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
