/datum/species/romulan
	name = "Romulan"
	id = "romulan"
	default_color = "FFFFFF"
	exotic_blood = "romulanblood"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED


/datum/species/romulan/qualifies_for_rank(rank, list/features)
	return TRUE	//Pure humans are always allowed in all roles.

