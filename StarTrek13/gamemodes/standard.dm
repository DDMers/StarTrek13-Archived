/datum/game_mode
	var/list/faction_participants = list("starfleet", "romulan empire", "the borg collective")
	var/delaywarp = 0 //Some modes like DS9 allow extra time to prepare.

/datum/game_mode/conquest
	name = "galactic conquest"
	config_tag = "conquest"
	announce_span = "danger"
	announce_text = "A romulan incursion into the neutral zone has put starfleet on red alert\n\
	<span class='danger'>Capture system outposts and accrue credits\n\
	<span class='danger'>The winning faction shall be the one with the most remaining credits."

/datum/game_mode/pre_setup()
	for(var/datum/faction/F in SSfaction.factions)
		if(F.name in faction_participants)
			message_admins("DEBUG: [F] has been enabled for the round.")
			F.locked = FALSE
		else
			F.locked = TRUE //Lock specific factions out of gamemodes
	if(delaywarp)
		SSfaction.warpdelay = delaywarp
	return ..()//We can add borg into this later, but no real need

/datum/game_mode/conquest/post_setup()
	return ..()

/datum/game_mode/conquest/generate_report()
	return "An advanced Romulan scout fleet has made an incursion into the neutral zone, if they prove to be hostile, engage with lethal force - Ensure you retain control of all outposts within our systems."

/datum/game_mode/conquest/special_report()
	var/list/ships = list()
	var/list/metal = list()
	var/list/dilithium = list()
	for(var/obj/structure/overmap/rts_structure/refinery/rss in overmap_objects)
		if(rss.faction)
			for(var/datum/faction/FF in SSfaction.factions)
				if(FF.name == rss.faction)
					FF.metal += rss.metal
					FF.dilithium += rss.dilithium
					metal += FF.metal
					dilithium += FF.dilithium
	for(var/datum/faction/F in SSfaction.factions)
		ships += F.ships
	var/most_ships = max(ships)
	var/most_metal = max(metal)
	var/most_dilithium = max(dilithium)
	var/datum/faction/highest
	var/datum/faction/richest_d
	var/datum/faction/richest_m
	var/datum/faction/military
	var/topscore
	for(var/datum/faction/F in SSfaction.factions) //Hierarchical win system, the overall winner
		if(F.ships >= most_ships)
			F.points += 10
			military = F
		if(F.metal >= most_metal)
			F.points += 10
			richest_m = F
		if(F.dilithium >= most_dilithium)
			F.points += 10
			richest_d = F
		if(F.points > topscore)
			highest = F
	var/output = "<div class='panel greenborder'><span class='header'><i>[highest] finished the round as the most powerful faction!</i></div>"
	output += "<br> <b>[richest_m] mined the most metal that round.</b>"
	output += "<br><b>[richest_d] mined the most dilithium that round.</b>"
	output += "<br><b>[military] had the most military assets at the end of that round</b>"

	return output