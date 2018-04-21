/datum/borg_hivemind
	var/name = "Borg hivemind controller"
	var/mob/living/carbon/human/borgs = list()

/datum/borg_hivemind/New()
//	SSticker.mode.hivemind = src
	SSfaction.borg_hivemind = src
	START_PROCESSING(SSobj, src)
	message_admins("Borg hivemind datum created")

/datum/borg_hivemind/proc/message_collective(var/message, mob/sender)
	var/ping = "<font color='green' size='2'><B><i>Borg Collective: </b> <b>[sender] </b></i>[message]</font></span>"
	for(var/mob/living/carbon/human/H in borgs)
		for(var/obj/item/organ/borgNanites/B in H.internal_organs)
			B.receive_message(ping)
	for(var/mob/M in GLOB.dead_mob_list)
		to_chat(M, ping)

//datum/borg_hivemind/process()


/datum/faction/borg
	name = "the borg"
	description = "We are the borg. Your biological and technological distinctiveness will be added to our own. You will be adapted to service us."
	flavourtext = "We are the borg. Your biological and technological distinctiveness will be added to our own. You will be adapted to service us. Assimilate them all."
	pref_colour = "green"


/datum/faction/borg/onspawn(mob/living/carbon/human/D)
	to_chat(D, "You are a borg drone")
	D.unequip_everything()
	D.make_borg()
	D.equipOutfit(/datum/outfit/borg, visualsOnly = FALSE)