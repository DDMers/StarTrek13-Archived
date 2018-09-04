/obj/structure/shipbuilder
	name = "Ship purchasing console"
	desc = "An advanced interface system linked to a spacedock, on command, it'll fabricate a new ship using a faction's credits as payment."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "shipbuilder"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE
	var/list/templates = list()
	var/datum/ship_template/selected

/obj/structure/shipbuilder/Initialize()
	. = ..()
	templates = list()
	for(var/F in subtypesof(/datum/ship_template/federation))
		var/datum/ship_template/tt = F
		var/datum/faction/instance = new tt
		templates += instance

/obj/structure/shipbuilder/romulan
	name = "Romulan ship purchasing console"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE

/obj/structure/shipbuilder/Initialize()
	. = ..()
	templates = list()
	for(var/F in subtypesof(/datum/ship_template/federation))
		var/datum/ship_template/tt = F
		var/datum/faction/instance = new tt
		templates += instance

/obj/structure/shipbuilder/romulan/Initialize()
	. = ..()
	templates = list()
	for(var/F in subtypesof(/datum/ship_template/romulan))
		var/datum/ship_template/tt = F
		var/datum/faction/instance = new tt
		templates += instance

/obj/structure/shipbuilder/attack_hand(mob/user)
	if(!user.skills.skillcheck(user, "piloting", 5)) //stop normal crewmen from building ships and blowing all their faction's cash.
		return
	if(user in orange(1, src))
		var/A
		A = input("Please select a ship design", "Shipyard", A) as null|anything in templates//overmap_objects
		if(!A)
			return
		var/datum/ship_template/O = A
		selected = O
		var/datum/faction/FF
		if(user.player_faction)
			FF = user.player_faction
		var/s = ""
		s += "<A href='?src=\ref[src];flush=1;clicker=\ref[user]'>Clear selection</A><BR>"
		s += "<B>[selected.name] analysis:</B><BR>"
		s += "<B>Information:</B><BR>"
		s += "class: [selected.templatename] <BR>"
		s += "description:[selected.desc]<BR>"
		if(FF)
			s += "available credits: [FF.credits]<BR>"
		s += "construction cost: [selected.cost]<BR>"
		s += "<A href='?src=\ref[src];buildit=1;clicker=\ref[user]'>Begin Construction</A><BR>"
		if(selected)
			s += "[icon2html(selected.icon, user, selected.icon_state)]<BR>"
		var/datum/browser/popup = new(user, "Ship construction", name, 550, 550)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
	else
		user = null
		return

/obj/structure/shipbuilder/Topic(href, href_list) //For some reason, S is null
	..()
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	if(user.canUseTopic(src))
		updateUsrDialog()
	if(user in orange(1, src))
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		if(href_list["flush"])
			to_chat(L, "Cleared template selection")
			selected = null
		if(href_list["buildit"])
			load(selected,L.player_faction)
	else
		selected = null
		to_chat(user, "Move closer to [src]")


/obj/structure/shipbuilder/proc/load(var/datum/ship_template/template,var/datum/faction/whospaying) //remember! add a way to check that that ship isn't already in use!
	for(var/obj/structure/overmap/S in world) //remind me: add a global list for this because :vomit:
		if(istype(S, template.checktype) && !S.wrecked)
			say("Error: One of those type of ship already exists!")
			return 0
	if(whospaying.credits >= template.cost)
		for(var/obj/effect/landmark/ShipSpawner/S in world)
			if(S.templatename == template.templatename)
				S.load()
				say("Construction in progress!")
				whospaying.credits -= template.cost
				return
	else
		say("Construction failed! Insufficient credits.")

/datum/ship_template
	var/name = "A template"
	var/desc = "This doesnt exist!"
	var/cost = 1
	var/templatename = "nope"
	var/loaded
	var/icon
	var/icon_state
	var/checktype = null

/datum/ship_template/federation/sovereign
	name = "Sovereign class heavy cruiser"
	desc = "A recently prototyped battleship with cutting edge technology, developed to face the ongoing Dominion threat, it is a truly a force to be reckoned with."
	templatename = "sovereign"
	loaded
	cost = 80000 ///SUUUUUUUUPER expensive, the average faction earns 300K over two hours
	icon = 'StarTrek13/icons/trek/large_ships/sovreign.dmi'
	icon_state = "sovreign-full"
	checktype = /obj/structure/overmap/ship/federation_capitalclass/sovreign

/datum/ship_template/romulan/dderidex
	name = "D'deridex class warbird"
	desc = "The might of the Romulan star empire given form. This design has seen such astounding success, that the Romulan empire doesn't officially employ any other military ships apart from it."
	templatename = "dderidex"
	cost = 70000 //This ship can take on a sovereign
	icon = 'StarTrek13/icons/trek/large_ships/dderidex.dmi'
	icon_state = "dderidex"
	checktype = /obj/structure/overmap/ship/romulan

/datum/ship_template/romulan/dderidex/alt //just so the list isnt empty, until I add more romulan ships.
	name = "D'deridex class warbird"
	desc = "The might of the Romulan star empire given form. This design has seen such astounding success, that the Romulan empire doesn't officially employ any other military ships apart from it."
	templatename = "dderidex"
	cost = 70000 //This ship can take on a sovereign
	icon = 'StarTrek13/icons/trek/large_ships/dderidex.dmi'
	icon_state = "dderidex"

/datum/ship_template/federation/defiant
	name = "Defiant class light cruiser"
	desc = "The defiant class is a prototype warship developed exclusively for military roles, due to an agreement with the Romulan empire, it does not feature a cloaking device. This ship is ideal for rapid travel, escort missions and general patrols"
	templatename = "defiant"
	cost = 20000 //Here's your true workhorse of the fleet
	icon = 'StarTrek13/icons/trek/large_ships/defiant.dmi'
	icon_state = "defiant"
	checktype = /obj/structure/overmap/ship/defiant

/datum/ship_template/federation/galaxy
	name = "Galaxy class cruiser"
	desc = "A huge ship with average armaments, it is suited for capital ship combat, if a little underpowered."
	templatename = "galaxy"
	cost = 50000 //Powerful, but also not
	icon = 'StarTrek13/icons/trek/large_ships/galaxy.dmi'
	icon_state = "galaxy"
	checktype = /obj/structure/overmap/ship/federation_capitalclass/galaxy

/datum/ship_template/federation/miranda //ADD ME! I'm not in the game yet!
	name = "Miranda class light cruiser"
	desc = "A reliant design that is tried and trusted. While this class is extremely old, it's compact, cheap, and easy to use, making it an ideal ship for patrolling and pirate hunting."
	templatename = "miranda"
	cost = 10000 //Really cute little ship, not powerful at ALL
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "destroyer-full"
	checktype = /obj/structure/overmap/ship/target

/datum/ship_template/federation/diy
	name = "Build your own ship (miranda class)"
	desc = "For vast interstellar civilisations on a budget, this will allow you to manufacture your own ship. It comes equipped with a shield generator, one phaser and a transporter as well as some complementary RCDs. Walls not included. The rest is up to you"
	templatename = "mirandaDIY"
	cost = 5000 //For the budding shipbuilders out there
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "destroyer-full"
	checktype = /obj/structure/overmap/ship/target/diy