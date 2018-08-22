/mob/living/carbon/human

/mob
	var/datum/faction/player_faction

/mob/living/carbon/human/Move(Newloc, direct)
	. = ..()
	if(client)
		player_faction = client.prefs.player_faction
	else
		player_faction = pick(SSfaction.factions)
