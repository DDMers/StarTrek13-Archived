/datum/species/klingon
	name = "Klingon"
	id = "klingon"
	default_color = "FFFFFF"
	exotic_blood = null
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = JUNKFOOD //PEH'TAQ, WE EAT OUR MEAT RAW
	attack_verb = "smash"
	armor = 1 //Klingons strong

/datum/species/klingon/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	var/obj/item/storage/backpack/BP = locate(/obj/item/storage/backpack) in H.GetAllContents()
	if(BP)
		var/obj/item/clothing/accessory/sash/wharf = new
		wharf.forceMove(BP)

/datum/species/klingon/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	addtimer(CALLBACK(src, .proc/give_language, C), 3)

/datum/species/klingon/proc/give_language(mob/living/carbon/C)
	C.grant_language(/datum/language/klingon)
	C.mind.language_holder.omnitongue = TRUE
	to_chat(C, "<font size=3 color=red>You are playing a roleplay heavy race! As a Klingon, you should be agressive and short tempered, you despise romulans and tribbles in particular.</font>")


/datum/species/klingon/qualifies_for_rank(rank, list/features)
	return TRUE	//Dog! A Klingon qualifies for any job a human does!

/datum/language/klingon
	name = "klingon"
	desc = "tlhIngan maH!, Heghlu'meH QaQ jajvam."
	speech_verb = "yells"
	whisper_verb = "whispers"
	ask_verb = "scoffs"
	exclaim_verb = "roars"
	key = "K"
	flags = TONGUELESS_SPEECH
	default_priority = 100
	icon_state = "klingon"
	syllables = list(
		"a", "b", "ch", "D", "e", "gh", "H", "I", "j", "l", "m", "n",
		"ng", "o", "p", "q", "Q", "r", "S", "t", "tlh", "u", "v", "w",
		"y", "'", "reh", "B", "s", "h", "G", "O", "P", "ul","P"
	)



/*
/datum/language/klingon
	name = "Klingon"
	desc = "tlhIngan maH!, Heghlu'meH QaQ jajvam."
	speech_verb = "yells"
	ask_verb = "scoffs"
	exclaim_verb = "roars"
	key = "K"
	space_chance = 5
	syllables = list(
		"a", "b", "ch", "D", "e", "gh", "H", "I", "j", "l", "m", "n",
		"ng", "o", "p", "q", "Q", "r", "S", "t", "tlh", "u", "v", "w",
		"y", "'", "reh", "B", "s", "h", "G", "O", "P", "ul","P"
	)
	icon_state = "klingon"
	default_priority = 90
	flags = TONGUELESS_SPEECH | LANGUAGE_HIDE_ICON_IF_UNDERSTOOD
*/

/obj/item/clothing/accessory/sash
	name = "klingon sash"
	desc = "A metal sash for klingon officers to pin the insignia of their houses on."
	icon_state = "sash"
	item_color = "sash"