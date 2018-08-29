/datum/species/infiltrator
	name = "hybrid borg"
	id = "infiltrator"
	say_mod = "says"
	species_traits = list(NOBLOOD)
	species_traits = list(HAIR)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	use_skintones = TRUE
	inherent_traits = list(TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOFIRE,TRAIT_PIERCEIMMUNE,TRAIT_NOHUNGER,TRAIT_LIMBATTACHMENT)
	inherent_biotypes = list(MOB_HUMANOID)
	meat = null
	damage_overlay_type = "infiltrator"
	mutanttongue = /obj/item/organ/tongue/robot
	limbs_id = "human"
	punchdamagelow = 15 //you don't want to get punched by this
	punchdamagehigh = 20 //the lengths you have to go to do to do this are...pretty high
	armor = 25
	speedmod = 1.6// Slow
	blacklisted = 1

/datum/species/infiltrator/movement_delay(mob/living/carbon/human/H)
	. = ..()
	playsound(H.loc, 'sound/effects/servostep.ogg', 50, 1)