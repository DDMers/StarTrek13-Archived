/datum/game_mode/conquest
	name = "galactic conquest"
	config_tag = "conquest"
	announce_span = "danger"
	announce_text = "A romulan incursion into the neutral zone has put starfleet on red alert\n\
	<span class='danger'>Capture system outposts and accrue credits\n\
	<span class='danger'>The winning faction shall be the one with the most remaining credits."

/datum/game_mode/conquest/pre_setup()
	return ..()//We can add borg into this later, but no real need

/datum/game_mode/conquest/post_setup()
	return ..()

/datum/game_mode/conquest/generate_report()
	return "An advanced Romulan scout fleet has made an incursion into the neutral zone, if they prove to be hostile, engage with lethal force - Ensure you retain control of all outposts within our systems."

/datum/game_mode/conquest/special_report()
	for(var/datum/faction/F in SSfaction.factions)
		if(F.credits > 0)
			to_chat(world, "<span class='danger'>[F] finished the round with [F.credits] credits.</span>")
	return