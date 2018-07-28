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

/*
/datum/game_mode/conquest/special_report()
	var/datum/faction/winner
	var/datum/faction/faction1
	var/datum/faction/faction2
	var/datum/faction/faction3 //band aid fix, please rewrite later
	var/datum/faction/faction4
	for(var/datum/faction/F in SSfaction.factions)
		if(F.credits > 0)
			if(!faction1)
				faction1 = F
			if(!faction2)
				faction2 = F
			if(!faction3)
				faction3 = F
			if(!faction4)
				faction4 = F
	winner = max(faction1.credits,faction2.credits,faction3.credits,faction4.credits)
	to_chat(world, "<span class='danger'>[winner] has won the round!</span>")
	return
*/