/datum/game_mode/conquest/incursion
	name = "romulan incursion"
	config_tag = "romulanincursion"
	announce_span = "danger"
	announce_text = "After the assasination of a key romulan senator at the hands of section-31 (a rogue starfleet organization), the Romulan star empire vows to make the federation pay\n\
	<span class='danger'>Capture system outposts and accrue credits. Factions are at war\n\
	<span class='danger'>All out war is authorized and expected. Romulans should not trust anything aliens say."
	faction_participants = list("starfleet", "romulan empire")

/datum/game_mode/conquest/incursion/generate_report()
	return "A key romulan senator has been assasinated and the Romulan empire has vowed to make the federation pay.."