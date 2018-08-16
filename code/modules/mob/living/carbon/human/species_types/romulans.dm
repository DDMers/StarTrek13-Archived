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

/datum/reagent/blood/romulan
	data = list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null)
	name = "Green Blood"
	id = "romulanblood"
	color = "##008000" // Treacherous greenblood!
	glass_icon_state = "acidspitglass"
	glass_name = "glass of green blood"
	glass_desc = "Drink the blood of those peh'taqs!"
	shot_glass_icon_state = "shotglassgold"