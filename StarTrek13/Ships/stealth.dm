#define SNAKE_SPAM_TICKS 600

/mob/living/carbon/human
	var/next_spot_time = 0
	var/datum/faction/player_faction

/mob/living/carbon/human/Move(Newloc, direct)
	. = ..()
	if(client)
		player_faction = client.prefs.player_faction
	else
		player_faction = pick(SSfaction.factions)

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/M = user
		if(!player_faction)
			return
		if(player_faction != M.player_faction)
			spot() //Spotted! Invalidating SUPER STEALTH missions

/mob/living/carbon/human/proc/spot() //Spot an enemy, used for sneaky missions
	if(stat == DEAD || IsSleeping())
		return 0
	if(incapacitated(ignore_restraints = 1))
		return 0
	var/list/alerted = null
	if(next_spot_time < world.time)
		alerted = viewers(7,src)
	if(LAZYLEN(alerted))
		next_spot_time = world.time + SNAKE_SPAM_TICKS
		playsound(loc, 'StarTrek13/sound/trek/alert.ogg',50,1)
		for(var/mob/living/L in alerted)
			if(!L.stat)
				if(!L.incapacitated(ignore_restraints = 1))
					L.face_atom(src)
				L.do_alert_animation(L)
		return 1


#undef SNAKE_SPAM_TICKS