GLOBAL_LIST_INIT(toolnames, world.file2list("strings/names/toolnames.txt"))

//TREK TOOL
/obj/item/wirecutters/trek
	desc = "A label on it reads: for the energization of duophasic relays ."

/obj/item/wirecutters/trek/examine(var/mob/user)
	..()
	var/datum/skill/skill = user.skills.getskill("construction and maintenance")
	if(skill.value < 4)
		to_chat(user, "<span class='info'><b>What in God's name is this...</b></span>")
		return
	to_chat(user, "<span class='info'><b>the instructions clearly state it's a pair of wirecutters.</b></span>")

/obj/item/wirecutters/trek/Initialize()
	. = ..()
	name = SSfaction.Wirecuttername
	icon_state = "trek[rand(1,4)]"
	cut_overlays()

//TREK TOOL
/obj/item/wrench/trek
	desc = "A label on it reads: for the destruction of anomalies in graviton resonance fields."
	usesound = 'StarTrek13/sound/trek/tools/spanner.ogg'
	toolspeed = 2

/obj/item/wrench/trek/examine(var/mob/user)
	..()
	var/datum/skill/skill = user.skills.getskill("construction and maintenance")
	if(skill.value < 4)
		to_chat(user, "<span class='info'><b>what the hell does it do...?</b></span>")
		return
	to_chat(user, "<span class='info'><b>the instructions clearly state it's a wrench.</b></span>")

/obj/item/wrench/trek/Initialize()
	. = ..()
	name = SSfaction.Wrenchname
	icon_state = "trek[rand(1,4)]"
	cut_overlays()

//TREK TOOL
/obj/item/screwdriver/trek
	desc = "A label on it reads: tool for realignment of lepton wave signatures via a metaphasic trichloric pulse.."
	usesound = 'StarTrek13/sound/trek/tools/screwdriver.ogg'
	toolspeed = 4

/obj/item/screwdriver/trek/Initialize()
	. = ..()
	name = SSfaction.Screwdrivername
	icon_state = "trek[rand(1,4)]"
	cut_overlays()

/obj/item/screwdriver/trek/examine(var/mob/user)
	..()
	var/datum/skill/skill = user.skills.getskill("construction and maintenance")
	if(skill.value < 4)
		to_chat(user, "<span class='info'><b>What on earth is this? do I use the pointy end?!</b></span>")
		return
	to_chat(user, "<span class='info'><b>The instructions clearly state that it's a screwdriver.</b></span>")


//TREK TOOL
/obj/item/crowbar/trek
	desc = "A label on it reads: Tool for the re-alignment of metaphasic relays"

/obj/item/crowbar/trek/Initialize()
	. = ..()
	name = SSfaction.Crowbarname
	icon_state = "trek[rand(1,4)]"

/obj/item/crowbar/trek/examine(var/mob/user)
	..()
	var/datum/skill/skill = user.skills.getskill("construction and maintenance")
	if(skill.value < 4)
		to_chat(user, "<span class='info'><b>Sadly, you are no such engineer.</b></span>")
		return
	to_chat(user, "<span class='info'><b>The instructions clearly state that it's a crowbar.</b></span>")

/obj/item/crowbar/trek/New()
	icon_state = "trek[rand(1,4)]"
	..()