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

/datum/species/romulan/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	C.grant_language(/datum/language/romulan)
	C.mind.language_holder.omnitongue = TRUE
	to_chat(C, "<span_class='notice'>You are playing a roleplay heavy race! As a Romulan, you should be distrustful of aliens with a reserved, calculated attitude.</span>")

/datum/language/romulan
	name = "romulan"
	desc = "Jolan'tru! Veisa notht?"
	speech_verb = "says"
	whisper_verb = "whispers"
	ask_verb = "demands"
	exclaim_verb = "shouts"
	key = "R"
	flags = TONGUELESS_SPEECH
	default_priority = 100
	icon_state = "romulan"
	syllables = list(
		"Ve", "Ai", "ao", "mn", "al", "a", "ah", "Mn", "Fh", "lh", "vh", "hl",
		"ef", "veh", "st", "re", "te", "le", "ik", "ra", "Ll", "ea", "v", "w",
		"y", "'", "mar", "b", "s", "h", "g", "o", "p", "ul","P"
	)