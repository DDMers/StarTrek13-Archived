/datum/game_mode/conquest/borg
	name = "borg threat"
	config_tag = "borgthreat"
	announce_span = "danger"
	announce_text = "Deep space outposts have reported a borg vessel heading directly for sector 001\n\
	<span class='danger'>The federation must prepare to defend themselves against the borg\n\
	<span class='danger'>All other activities are secondary: protect Earth at all costs."
	faction_participants = list("starfleet", "the borg collective")

/datum/game_mode/conquest/borg/generate_report()
	return "Borg vessel detected in sector 41568, all available starfleet ships are to regroup in sector 001 and defend the sol system"