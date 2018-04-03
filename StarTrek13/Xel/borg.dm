//datum/game_mode
#define isborg(A) (BORG_DRONE in A.dna.species.species_traits)

/datum/game_mode
	var/list/borgs = list()
	var/datum/borg_hivemind/hivemind = null

/datum/game_mode/borg
	name = "borg invasion"
	config_tag = "borg"
	antag_flag = ROLE_BORG
	required_players = 4 //For tests, this will be 4.
	required_enemies = 2// For testing purposes, this will be changed to 2.
	recommended_enemies = 5
	restricted_jobs = list("Cyborg", "AI")
	var/borgs_to_make = 1
	var/borgs_to_win = 0
	var/escaped_borg = 0
	var/players_per_borg = 2 // Probably should be 3.
	var/const/drones_possible = 5
	var/finished = 0
	var/borgwin = 0

/datum/game_mode/proc/equip_borg(mob/living/carbon/human/borg_mob)
	var/mob/living/carbon/human/H = borg_mob
	H.add_skills(110, 110, 110, 110, 110) //Borg are the perfectly enhanced humanoids. I'll probably add something to make it so we don't need to keep coming back here every time a new skill is added.
	H.set_species(/datum/species/human, 1) //or the lore makes 0% sense
	hivemind.BORGinitialname = borg_mob.name
	for(var/obj/item/W in H)
		qdel(W)
	H.equipOutfit(/datum/outfit/borg, visualsOnly = FALSE)
	H.skin_tone = "albino"
	H.update_body()
	for(var/obj/item/organ/O in H.internal_organs) //what if the borg to make already has the organ? :thonkig:
		if(istype(O, /obj/item/organ/body_egg/borgNanites))
			return
		else
			var/obj/item/organ/body_egg/borgNanites/G = new(borg_mob)
			G.Insert(borg_mob)

/datum/game_mode/proc/remove_borg(mob/living/carbon/human/borg_mob)
	hivemind.borgs -= borg_mob
	var/mob/living/carbon/human/H = borg_mob
	H.set_species(/datum/species/human, 1) //or the lore makes 0% sense
	H.skin_tone = "caucasian"
	H.dna.species.species_traits -= BORG_DRONE
	H.update_body()
	H.equipOutfit(/datum/outfit, visualsOnly = FALSE)
	for(var/obj/item/W in H)
		qdel(W)
	for(var/obj/item/organ/O in H.internal_organs)
		if(istype(O, /obj/item/organ/body_egg/borgNanites))
			O = null
		else
			return

/datum/game_mode/proc/greet_borg(datum/mind/borg)
	var/greeting = "<font style = 3><B><span class = 'notice'>We are the borg. One of many.</B></font> <br>"
	greeting += "<b>We are a scouting party.We must prepare this sector for an invasion.</b> <br>"
	greeting += "<b>We are weak alone. We must assimilate the species here.</b> <br>"
	greeting += "<b>We have detected multiple vessels in the sector, we must assimilate them aswell.</b> <br>"
	greeting += "<b>We can communicate with the collective via :l, you are but a drone, the queen is your overseer </b> <br>"
	greeting += "<b>We have detected <span class='warning'>Species 5618 (or humans)</span>in this sector, but also some unknown species including silicon based life forms, they should prove useful.</b> <br>"
	greeting += "<b>We have a borg tool, it can be used to <span class='warning'>assimilate</span> objects, and people.</b> <br>"
	greeting += "<b>Use it on a victim, and after 5 seconds you will inject borg nanites into their bloodstream, making them a <span class='warning'>half drone</span>, once they are a half drone (with grey skin) take them to a conversion table (buildable)</b> <br>"
	greeting += "<b>Buckle them into the conversion table and keep them down for 10 seconds, after this they will join the collective as a full drone</b> <br>"
	greeting += "<b>Half drones are loyal to the collective, we should use them to remain somewhat discreet in our kidnapping of the crew as our drones build a base.</b> <br>"
	greeting += "<b>Killing is an absolute last resort, a dead human cannot be assimilated.</b> <br>"
	greeting += "<b>We do not require food, but we can't heal ourselves through conventional means, we require a <span class='warning'>specialized recharger (buildable)</span> </b> <br>"
	greeting += "<b>We must construct a new ship in a suitably large room on this station, only begin this when we are ready to take on the crew.</b> <br>"
	greeting += "<b>We can assimilate turfs (walls and floors) by clicking them with the borg tool on ASSIMILATE MODE, these are upgradeable by our queen later</b> <br>"
	greeting += "<b>Finally, If you are struggling, refer to this guide: LINK GOES HERE.com</b>"
	to_chat(borg.current, greeting)

/area/ship/borg/borgship
	name = "Borg mothership"
	icon_state = "xel"
	requires_power = 0
	has_gravity = 1
	noteleport = 1
	blob_allowed = 0

/datum/game_mode/borg/pre_setup() //changing this to the aliens code to spawn a load in maint
	hivemind = new /datum/borg_hivemind(src)
	to_chat(world, "borg hivemind established")
//	var/n_players = num_players()
	var/n_drones = 1 //min(round(n_players / 10, 1), drones_possible)
//	var/n_drones = 5
	for(var/obj/structure/overmap/ship/S in overmap_objects)
		if(S.flagship)
			to_chat(world, "<big> FOUND A FLAGSHIP! Flagship: [S.name]. </big>")
			hivemind.active_flagships += S
	if(antag_candidates.len < n_drones) //In the case of having less candidates than the selected number of borgs
		n_drones = antag_candidates.len
	var/list/datum/mind/borg_drone = list()
	if(antag_candidates.len > 0)
		for(var/i = 0, i < n_drones, i++)
			borg_drone += pick(antag_candidates)///pick_candidate(amount = n_drones)
		for(var/v in borg_drone)
			var/datum/mind/new_borg = v
			hivemind.borgs += new_borg
			new_borg.assigned_role = "borg"
			new_borg.special_role = "borg"//So they actually have a special role
		if(!hivemind)
			new /datum/borg_hivemind
		return 1
	else
		return 0

/datum/objective/assimilate
	explanation_text = "Assimilate all flagships and the federation starbase.<br> The following flagships are currently active: <br>"//borked up

/datum/objective/assimilate/check_completion() // Objective: Assimilate all flagships, and the federation starbase
	for(var/datum/game_mode/borg/G in world)
		if(G.hivemind.flagships_assimilated && G.hivemind.starbase_assimilated)
			return TRUE
		return FALSE

/datum/game_mode/proc/forge_borg_objectives(datum/mind/borg_mind)
	var/datum/objective/O
	O = new /datum/objective/assimilate()
	O.explanation_text = "Prepare the sector for an invasion by assimilating all flagships, and the federation starbase."
	borg_mind.objectives += O

/datum/game_mode/borg/post_setup()
	for(var/obj/effect/landmark/A in GLOB.landmarks_list)
		if(A.name == "borg_spawn")
			hivemind.borgspawn2 = A.loc
			to_chat(world, "<b> Found a borg spawn! </b>")
			continue
	for(var/datum/mind/borg_mind in hivemind.borgs)
		greet_borg(borg_mind)
		equip_borg(borg_mind.current)
		SSticker.mode.forge_borg_objectives(borg_mind)
		borg_mind.current.loc = hivemind.borgspawn2
//		var/obj/item/organ/body_egg/borgNanites/G = new(borg_mind.current)
	..()

/datum/game_mode/borg/announce()
	to_chat(world, "<B>The current game mode is - Borg!</B>")
	to_chat(world, "<B>A massive temporal rift has been detected, a large green object suddenly appeared on galactic sensors. \
				You must destroy ALL borg. Borg; assimilate the sector!</B>")

//species 4678 (or unathi)</span> and <span class='warning'>Species 4468 (or phytosians) 5618 (or humans)

/datum/game_mode/proc/auto_declare_completion_borg()
	var/list/living_mob_list = list()
	for(var/mob/living/carbon/human/H in world)
		living_mob_list += H //TEMPORARY. FIX ME.
	if(hivemind.borgs.len || (SSticker && istype(SSticker.mode,/datum/game_mode/borg)) )
		var/text = "<br><font size=3><b>The borg drones were:</b></font>"
		for(var/datum/mind/borg in hivemind.borgs)
			text += printplayer(borg)
		text += "<br> <font size=2>Players who escaped assimilation: </font> <br>"
		for(var/mob/living/carbon/human/H in living_mob_list)
			text += printplayer(H)
		text += "<br>"
		to_chat(world, "[text]")


/datum/game_mode/borg/check_win()
	if(check_borg_victory())
		SSticker.current_state = GAME_STATE_FINISHED
		finished = 1

/datum/game_mode/borg/proc/check_borg_victory()
	if(hivemind.flagships_assimilated && hivemind.starbase_assimilated)
		return TRUE
	return FALSE

datum/game_mode/borg/proc/declare_completion()
	if(check_borg_victory()) //add in the other once i've made their structures
		SSticker.mode_result = "Major Victory - The borg collective"
		to_chat(world, "<span class='greentext'>The borg collective has successfully prepared the sector for an invasion!</span>")
		return
	else
		SSticker.mode_result = "loss - The borg collective have failed!"
		to_chat(world, "<span class='userdanger'><FONT size = 3>The borg collective has been halted in their assault!</FONT></span>")
		return
	return 0



//HIVEMIND//

//Alright, so I'm gonna handle upgrades here instead of on the borg tool, and also notifying people when someone's being converted. Also I'm gonna have a proc to broadcast events to the borg because I'm a good coder... right? HAHAHHA//
//Thanks to cruix, I stole some ideas from your code

/datum/borg_hivemind
	var/upgrade_progress
	var/upgrade_tier // what tier are they at?
	var/mob/living/carbon/human/borgqueen/queen
	var/sci_points = 0 //generated by assimilating people, and ships.
	var/cons_points = 0 //generated by living drones, and by assimilating turfs. Defines what you can build, nad how much.
	var/rate_of_cons_points = 1 // points per borg, per TICK. Assimilating turfs will give them a good deal of their points.
	var/max_cons_points = 500
	var/message // what message to broadcast.
	var/list/datum/mind/borg_minds = list()
	var/list/datum/mind/borgs = list() //make our borgs list accessible via SSticker.mode hopefully!
	var/BORGinitialname //stores names of drones so we can rename them back to what they should be
	var/borgspawn2 //where will we spawn our borg drones?
	var/list/active_flagships = list() //List of all currently active flagships
	var/flagships_assimilated = FALSE //Are all flagships assimilated?
	var/starbase_assimilated = FALSE //And so is the federation starbase?

/datum/borg_hivemind/New()
	SSticker.mode.hivemind = src
	START_PROCESSING(SSobj, src)
	message_admins("Borg hivemind initiated.")

/datum/borg_hivemind/proc/message_collective(message)
	var/ping = "<font color='green' size='2'><B><i>Borg collective</i> Hivemind notice: [message]</B></font></span>"
	for(var/mob/living/I in world)
		if(I.mind in borgs)
			to_chat(I, "[ping]")
			continue
	for(var/mob/M in GLOB.dead_mob_list)
		to_chat(M, "[ping]")

/datum/borg_hivemind/proc/use_cons_points(amount)
	var/A
	A = cons_points -= amount
	if(A < 0)
		return FALSE
	cons_points -= A
	return TRUE

//upgrades! materials! Upgrade points/materials are given per tile assimilated, person assimilated, and ship assimilated. Also has a rate of gain, and will factor in construction points.
/datum/borg_hivemind/process()
	var/obj/structure/overmap/ship/S
	for(S in active_flagships)
		if(S.assimilated)
			active_flagships -= S
			message_collective("The flagship [S] has been assimilated.")
	if(active_flagships == null && !flagships_assimilated)
		message_collective("All flagships have been assimilated.")
		flagships_assimilated = TRUE
	for(var/mob/living/I in SSticker.mode.hivemind.borgs)
		cons_points += rate_of_cons_points
	if(cons_points > max_cons_points)
		var/excess = cons_points - max_cons_points
		cons_points -= excess
