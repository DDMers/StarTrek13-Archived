//datum/game_mode
#define isborg(A) (BORG_DRONE in A.dna.species.species_traits)


/datum/game_mode
	var/list/borgs = list()
	var/datum/borg_hivemind/hivemind = null

/datum/game_mode/borg
	name = "borg invasion"
	config_tag = "borg"
	antag_flag = ROLE_BORG
	required_players = 1 //change me
	required_enemies = 1//3
	recommended_enemies = 5
	restricted_jobs = list("Cyborg", "AI")
	var/borgs_to_make = 1
	var/borgs_to_win = 0
	var/escaped_borg = 0
	var/players_per_borg = 1
	var/const/drones_possible = 5
	var/finished = 0

/datum/game_mode/proc/equip_borg(mob/living/carbon/human/borg_mob)
	var/mob/living/carbon/human/H = borg_mob
	H.add_skills(110, 110, 110, 110, 110) //Borg are the perfectly enhanced humanoids. I'll probably add something to make it so we don't need to keep coming back here every time a new skill is added.
	H.set_species(/datum/species/human, 1) //or the lore makes 0% sense
//	var/datum/mind/fuckfuckmeme = H.mind
//	if(!fuckfuckmeme in borgs)
	//	borgs += fuckfuckmeme
	hivemind.BORGinitialname = borg_mob.name
	world << "reeee!!" //SKREE
	for(var/obj/item/W in H)
		qdel(W)
	H.equipOutfit(/datum/outfit/borg, visualsOnly = FALSE)
	world << "reee"//SKREE
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
	borg.current << "<font style = 3><B><span class = 'notice'>We don't belong here...not in this universe</B></font>"
	borg.current << "<b>The last thing the collective remembers is a flash of white light and a quiet whooshing sound.</b>"
	borg.current << "<b>Our ship was damaged, we must construct a new one.</b>"
	borg.current << "<b>We have detected a medium sized space station nearby, we must use the last remaining energy reserves to plough our damaged ship into their station, and assimilate them.</b>"
	borg.current << "<b>We can communicate with the collective via :l, you are but a drone, the queen is your overseer </b>"
	borg.current << "<b>We have detected <span class='warning'>Species 5618 (or humans)</span>on this station, but also some unknown species including silicon based life forms, they should prove useful.</b>"
	borg.current << "<b>We have a borg tool, it can be used to <span class='warning'>assimilate</span> objects, and people.</b>"
	borg.current << "<b>Use it on a victim, and after 5 seconds you will inject borg nanites into their bloodstream, making them a <span class='warning'>half drone</span>, once they are a half drone (with grey skin) take them to a conversion table (buildable)</b>"
	borg.current << "<b>Buckle them into the conversion table and keep them down for 10 seconds, after this they will join the collective as a full drone</b>"
	borg.current << "<b>Half drones are loyal to the collective, we should use them to remain somewhat discreet in our kidnapping of the crew as our drones build a base.</b>"
	borg.current << "<b>Killing is an absolute last resort, a dead human cannot be assimilated.</b>"
	borg.current << "<b>We do not require food, but we can't heal ourselves through conventional means, we require a <span class='warning'>specialized recharger (buildable)</span> </b>"
	borg.current << "<b>We must construct a new ship in a suitably large room on this station, only begin this when we are ready to take on the crew.</b>"
	borg.current << "<b>We can assimilate turfs (walls and floors) by clicking them with the borg tool on ASSIMILATE MODE, these are upgradeable by our queen later</b>"
	borg.current << "<b>Finally, If you are struggling, refer to this guide: LINK GOES HERE.com</b>"

/area/borgship
	name = "Xel mothership"
	icon_state = "xel"
	requires_power = 0
	has_gravity = 1
	noteleport = 1
	blob_allowed = 0 //Should go without saying, no blobs should take over centcom as a win condition.

/datum/game_mode/borg/pre_setup() //changing this to the aliens code to spawn a load in maint
	hivemind = new /datum/borg_hivemind(src)
	to_chat(world, "borg hivemind established")
	var/validareas = /area/ai_monitored/nuke_storage //change me
//	var/validareas = list(/area/bridge,/area/bridge/meeting_room,/area/tcommsat,/area/crew_quarters/fitness,/area/security/brig,/area/atmos, /area/engine/engineering, /area/crew_quarters/locker) //valid areas that are large enough for the borgos to overtake
	hivemind.borg_target_area = pick(validareas)
//	var/n_players = num_players()
	var/n_drones = 1 //min(round(n_players / 10, 1), drones_possible)
//	var/n_drones = 5
	if(antag_candidates.len < n_drones) //In the case of having less candidates than the selected number of agents
		n_drones = antag_candidates.len
	var/list/datum/mind/borg_drone
	if(antag_candidates.len>0)
		for(var/i = 0, i < n_drones, i++)
			borg_drone += pick(antag_candidates)///pick_candidate(amount = n_drones)
		for(var/v in borg_drone)
			var/datum/mind/new_borg = v
			hivemind.borgs += new_borg
			new_borg.assigned_role = "xel"
			new_borg.special_role = "xel"//So they actually have a special role/N
		if(!hivemind)
			new /datum/borg_hivemind
		return 1
	else
		return 0

/datum/objective/assimilate
	explanation_text = "Convert BLANK into a borg cube by assimilating ALL turfs inside, and building an FTL drive, shield subsystem, a queen's throne and a navigational console."

/datum/objective/assimilate/check_completion()
	return

/datum/game_mode/proc/forge_borg_objectives(datum/mind/borg_mind)
	var/datum/objective/O
	O = new /datum/objective/assimilate()
	O.explanation_text = "Convert [hivemind.borg_target_area] into a borg cube by assimilating ALL turfs inside, and building an FTL drive, shield subsystem, a queen's throne and a navigational console."
	borg_mind.objectives += O

/datum/game_mode/borg/post_setup()
	for(var/obj/effect/landmark/A in GLOB.landmarks_list)
		if(A.name == "xel_spawn")
			hivemind.borgspawn2 = A.loc
			world << "<b> Found a borg spawn! </b>"
			continue
	for(var/datum/mind/borg_mind in hivemind.borgs)
	//	world << "<b> TEST! borgmind is [borg_mind] at [borg_mind.current.loc] </b>"
		//var/fuck = new /mob/living/carbon/human
		greet_borg(borg_mind)
		equip_borg(borg_mind.current)
		SSticker.mode.forge_borg_objectives(borg_mind)
	//	borg_mind.current.loc = borg_spawn// add me later[spawnpos]
		borg_mind.current.loc = hivemind.borgspawn2
//		var/obj/item/organ/body_egg/borgNanites/G = new(borg_mind.current)
	..()

/datum/game_mode/borg/announce()
	world << "<B>The current game mode is - Borg!</B>"
	world << "<B>A massive temporal rift has been detected, a large green object suddenly appeared on NT sensors.. \
				You must destroy ALL the Xel, Xel: assimilate the station!</B>"

//species 4678 (or unathi)</span> and <span class='warning'>Species 4468 (or phytosians) 5618 (or humans)

/datum/game_mode/borg/check_finished()
	if(finished)
		return 1
	else
		return 0

/datum/game_mode/proc/auto_declare_completion_borg()
	if(hivemind.borgs.len || (SSticker && istype(SSticker.mode,/datum/game_mode/borg)) )
		var/text = "<br><font size=3><b>The Xel drones were:</b></font>"
		for(var/datum/mind/xel in hivemind.borgs)
			text += printplayer(xel)
		text += "<br>"
		world << text


/datum/game_mode/borg/check_win()
	if(check_borg_victory())
		finished = 1
	return


/datum/game_mode/borg/proc/check_borg_victory()
	if(hivemind.borg_completion_assimilation && hivemind.borg_machines_room_has_ftl && hivemind.borg_machines_room_has_nav && hivemind.borg_machines_room_has_throne) //add in the other once i've made their structures
		finished = 1
	//	ticker.current_state = GAME_STATE_FINISHED
	else
		finished = 0
//	var/borgwin = 0
//	if(SSticker.mode.borg_completion_assimilation == 1)
//		return 1
//	else
//		return 0

//datum/game_mode/borg/declare_completion() //Dont need this yet
//	if(hivemind.borg_completion_assimilation && hivemind.borg_machines_room_has_ftl && hivemind.borg_machines_room_has_nav && hivemind.borg_machines_room_has_throne) //add in the other once i've made their structures
//		SSticker.mode_result = "round_end_result","Major Victory - Xel"
//		to_chat(world,"<span class='greentext'>The Xel collective constructed a new cube! they now live to spread their evil throughout the sector!</span>")
//	else
//		SSticker.mode_result = "round_end_result","loss - staff defeated the borg!"
//		to_chat(world, "<span class='userdanger'><FONT size = 3>The staff managed contain the borg!</FONT></span>")

/*
	var/total_humans = 0
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.client && !isborg(H))
			total_humans++
	if(total_humans > 1)
		if((total_humans / borgs) *100 == 70) //70% of total humans are borgos, we're changing this later.
			borgwin = 1
		else // only happens in declare_completion()
			for(var/mob/living/carbon/human/H in living_mob_list)
				if(H.z == ZLEVEL_CENTCOM)
					if(isborg(H))
						if(H.stat != DEAD)
							if(!borgwin)
								borgwin = 1
								break
	else
		return 0
*/


//HIVEMIND//

//Alright, so I'm gonna handle upgrades here instead of on the borg tool, and also notifying people when someone's being converted. Also I'm gonna have a proc to broadcast events to the borg because I'm a good coder... right? HAHAHHA//
//Thanks to cruix, I stole some ideas from your code

/datum/borg_hivemind
	var/upgrade_progress
	var/upgrade_tier // what tier are they at?
	var/mob/living/carbon/human/borgqueen/queen
	var/upgrade_points = 0 //generated by living drones
	var/rate_of_upgrade = 2 //2 points per borg drone, per tick
	var/max_upgrade_points = 5000
	var/message // what message to broadcast.
	var/list/datum/mind/borg_minds = list()
	var/list/datum/mind/borgs = list() //make our borgs list accessible via SSticker.mode hopefully!
	var/borgspawn2 //where will we spawn our borg drones?
	var/BORGinitialname //stores names of drones so we can rename them back to what they should be
	var/borg_target_area //Working out what room they need to turn into the borg ship
	var/borg_completion_assimilation = 0 //have the borgs assimilated their area?
	var/borg_completion_construction = 0 //have the borgs built their shit in the room yet?
	var/borg_machines_room_has_ftl = 0 //has the target room get an FTL?
	var/borg_machines_room_has_nav = 0 //has it got a navcomp?
	var/borg_machines_room_has_throne = 0 //has it got throne?

/datum/borg_hivemind/New()
	SSticker.mode.hivemind = src
	START_PROCESSING(SSobj, src)
	message_admins("borg hivemind started up.")

/datum/borg_hivemind/proc/message_collective()
	var/ping = "<font color='green' size='2'><B><i>Xel collective</i> Hivemind notice: [message]</B></font></span>"
	for(var/mob/living/I in world)
		if(I.mind in borgs)
			I << ping
			continue
	for(var/mob/M in GLOB.dead_mob_list)
		M << ping

/datum/borg_hivemind/process() //upgrades! upgrade points are built up over time.
	for(var/mob/living/I in SSticker.mode.hivemind.borgs)
		upgrade_points += rate_of_upgrade
	if(upgrade_points == max_upgrade_points*0.2) //20% stored
		world << "ree"