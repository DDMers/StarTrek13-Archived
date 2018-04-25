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

/obj/structure/weapons_console/New()
	. = ..()
	START_PROCESSING(SSobj,src)
	subsystem = our_ship.SC.weapons
	damage = subsystem.damage
	heat = subsystem.heat
	charge = subsystem.charge

//obj/structure/fluff/helm/desk/functional/weapons_console/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
//	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
//	if(!ui)
//		ui = new(user, src, ui_key, "transporter_console", name, 300, 300, master_ui, state)
//		ui.open()
/obj/structure/weapons_console/proc/get_ship_icon(atom/item,mob/user)
	return icon2html(item, user, EAST)
//	return icon2html(initial(item.icon), usr, state, NORTH)

/obj/structure/weapons_console/proc/get_ships_list(obj/thing,mob/user)
	var/Ss = ""
	for(var/obj/structure/overmap/D in ships)
		Ss += "<A href='?src=\ref[thing];target=1;clicker=\ref[user]'>[D]</A><BR>"
		var/sate = "[D.icon_state]-full"
		Ss += "<span data-tooltip='Placeholder'>[get_ship_icon(D, sate)]</span><BR>"
	return Ss

/obj/structure/weapons_console/attack_hand(mob/user)
	if(user in orange(1, src))
		if(winget(user,"Subsystem-Targeting","is-visible") == "false")
			target_window = FALSE //Thanks byond forums
		if(winget(user,"Weapons control","is-visible") == "false") //Returnif window is not visible to prevent it spamming you
			if(target_window)
				return
		if(!target_window)
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
			s += "<A href='?src=\ref[src];toggle=1;clicker=\ref[user]'>Toggle Power</A><BR>"
			s += "<B>STATISTICS</B><BR>"
			s += "[our_ship] weapons subsystem:<BR>"
			s += "Heat: [heat] |"
			s += " Weapon power (Gigawatts): [damage] |"
		//	s += damage_disp
			s += " Weapon charge: [charge] / [subsystem.max_charge]<BR>"
			s += "<B>Dradis ship targeting:</B><BR>"
			var/ss = ""
			for(var/obj/structure/overmap/D in ships)
				var/obj/structure/overmap/P = new
				if(!D in our_ship.interactables_near_ship) //Ship no longer available for targeting
					target_window = FALSE
					return attack_hand(user) //refresh
				P.icon = D.icon
				P.icon_state = "[D.icon_state]-full"
				ships -= P
				theicons += P
				ss += "<span data-tooltip='Placeholder'>[icon2html(P.icon, user, P.icon_state, EAST)]</span><BR>"
				ss += "<A href='?src=\ref[src];target=\ref[D];clicker=\ref[user]'>[D]</A><BR>"
				qdel(P)
			s += ss
			var/datum/browser/popup = new(user, "Weapons control", name, 900, 900)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
			if(user.canUseTopic(src))
			//	if(winget(user,"Weapons control","is-visible") == "true") //I.E, the window is open, so carry on refreshing it.
				addtimer(CALLBACK(src,/atom/proc/attack_hand, user), 20)
	else
		user = null
		return



/obj/structure/weapons_console/Topic(href, href_list) //For some reason, S is null
	..()
	//var/client/user = locate(href_list["clicker"])
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	if(user in orange(1, src))
		var/obj/structure/overmap/ship/S = locate(href_list["target"])
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		var/datum/shipsystem/SS = locate(href_list["system"])
		if(href_list["target"])
			target_window(S, L,1) //Clicker references the user
		if(href_list["system"])
			to_chat(L, "<span class='notice'>Now targeting: [SS] subsystem.</span>")
			our_ship.target_subsystem = SS
	else
		to_chat(user, "Move closer to [src]")


/obj/structure/weapons_console/proc/target_window(obj/structure/overmap/D, mob/user, var/calledfrom)
	if(user in orange(1, src))
		target_window = TRUE
		to_chat(D.pilot, "WARNING, scan detected, origin: [our_ship]!")
		var/s = ""
		s += "<B>CONTROL PANEL:</B><BR>"
		var/obj/structure/overmap/P = new
		P.icon = D.icon
		P.icon_state = "[D.icon_state]-full"
		s += "<A href='?src=\ref[src];target=\ref[D];clicker=\ref[user]'>Target: [D]</A>"
		s += "<A href='?src=\ref[src];target=\ref[D];clicker=\ref[user]'>Target subsystem: [our_ship.target_subsystem]</A>"
		s += "<A href='?src=\ref[src];target=\ref[D];clicker=\ref[user]'>Target subsystem health: [our_ship.target_subsystem.integrity] / [our_ship.target_subsystem.max_integrity]</A><BR>"
		s += "<span data-tooltip='Placeholder'>[icon2html(P.icon, user, P.icon_state, EAST)]</span><BR>"
		qdel(P)
		subsystem = our_ship.SC.weapons
		damage = subsystem.damage
		heat = subsystem.heat
		charge = subsystem.charge
		s += "<B>STATISTICS</B><BR>"
		s += "[our_ship] weapons subsystem:<BR>"
		s += "Heat: [heat] |"
		s += " Weapon power (Gigawatts): [damage] |"
		s += " Weapon charge: [charge] / [subsystem.max_charge]<BR>"
		var/ss = ""
		for(var/datum/shipsystem/S in D.SC.systems)
	//	ss += "<span data-tooltip='Placeholder'>[icon2html(S.icon, user, S.icon_state, SOUTH)]</span><BR>"
			ss += "<A href='?src=\ref[src];system=\ref[S];clicker=\ref[user]'>[icon2html(S.icon, user, S.icon_state, SOUTH)]</A>"
		s += ss
		var/datum/browser/popup = new(user, "Subsystem-Targeting", name, 470, 500)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
		if(winget(user,"Subsystem-Targeting","is-visible") == "false")
			if(!calledfrom) //Calledfrom is only done when newly selecting window from attackhand
				target_window = FALSE //Thanks byond forums
				popup.close()
				qdel(popup)
				return
		if(!D in our_ship.interactables_near_ship) //Ship no longer available for targeting
			target_window = FALSE
			popup.close()
			qdel(popup)
			return
		if(user.canUseTopic(src))
			addtimer(CALLBACK(src,.proc/target_window, D,user,0), 20)
	else
		target_window = FALSE //Thanks byond forums
		user = null
		return

//	if(!current_fan)
//		to_chat(user, "There are no fans attached to the shield generator.")
//		return

	// TODO: Add cool sound effects
	// For future coders: current_fan is meant to be hidden. you're suppose t
//	if(href_list["fandecrease"])
//		current_fan.fancurrent = max(current_fan.fanmin, current_fan.fancurrent - 5)

//	if(href_list["fanincrease"])
//		current_fan.fancurrent = min(current_fan.fanmax, current_fan.fancurrent + 5)