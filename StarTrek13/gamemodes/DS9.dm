/datum/game_mode/conquest/deepspacenine
	name = "deep space 9"
	config_tag = "deepspacenine"
	announce_span = "danger"
	announce_text = "A key outpost in the Bajor system is in need of repairs\n\
	<span class='danger'>Capture system outposts and accrue credits. Factions are not at war\n\
	<span class='danger'>Prepare deep space 9 for an assault by the end of the round. Build a fleet and ensure DS9's station core does not fall."
	faction_participants = list(/datum/faction/starfleet, /datum/faction/romulan)

/datum/game_mode/conquest/deepspacenine/generate_report()
	return "The Federation outpost (on loan from bajor) Deep Space 9 is a key outpost next to the only stable worm-hole known to us, it is not fully operational. A defiant class warship has been assigned to the station. Use it to acquire resources to set up DS9. We have unconfirmed reports of a new alien empire in the delta quadrant with access to the wormhole. Shore up her defenses as much as possible."