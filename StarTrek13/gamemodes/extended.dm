/datum/game_mode/conquest/extended
	name = "free roam"
	config_tag = "freeroam"
	announce_span = "notice"
	announce_text = "There are no credible threats to the alpha quadrant, resume normal duties and respect existing treaties."
	faction_participants = list("starfleet", "romulan empire", "the borg collective")

/datum/game_mode/conquest/extended/generate_report()
	return "There are no credible threats to the alpha quadrant, resume normal duties and respect existing treaties."