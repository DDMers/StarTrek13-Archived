/obj/structure/holoemitter
	name = "holographic emitter"
	desc = "This bulky machine simulates a real-life human being, minus the real part."

	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "holoemitter"

	var/mob/living/carbon/human/linked_hologram
	var/range = 8

/obj/structure/holoemitter/attack_hand(var/mob/living/carbon/user)
	if(!linked_hologram)
		var/I = input("Please select a hologram to activate;.", "Hologram Control") as null|anything in list("Medical", "Piloting", "security")
		var/mob/living/carbon/human/species/holographic/H = new (loc)
		switch(I)
			if("Medical")
				H.skills.add_skill("medical", 7)
			if("Security")
				H.skills.add_skill("", 6)
			if("Piloting")
				H.skills.add_skill("piloting", 7)
			else
				return
		H.real_name = "Emergency [I] Hologram"
		H.say("Please state the nature of your [I] emergency.")
	else
		..()

/datum/species/holographic
	name = "Hologram"
	id = "human" //Because we need an emergency reference (for such like limbs).
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	use_skintones = 1
	skinned_type = null
	species_traits = list(NOBLOOD)
	inherent_traits = list(TRAIT_RADIMMUNE,TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOFIRE,TRAIT_PIERCEIMMUNE,TRAIT_NOHUNGER,TRAIT_NODISMEMBER)
	inherent_biotypes = list(MOB_HUMANOID)
	meat = null
	mutantlungs = null
	mutantliver = null
	mutantstomach = null
	brutemod = 2
	heatmod = 2
	breathid = "" //You don't need air, you're a hologram.
	damage_overlay_type = ""//You're a hologram, you don't bleed.

	var/obj/structure/holoemitter/linked_emitter = null


/datum/species/holographic/spec_death(gibbed, mob/living/carbon/human/H)
	to_chat(H, "You fade away, as if never having existed. You wonder if you will be remembered.")
	H.unequip_everything()
	qdel(H)

/datum/species/holographic/spec_life(mob/living/carbon/human/H)
	if(!linked_emitter)
		for(var/obj/structure/holoemitter/E in orange(8, H))
			linked_emitter = E
		if(!linked_emitter)
			H.death()
			return
		linked_emitter.linked_hologram = H
	if(linked_emitter in orange(linked_emitter.range, H))
		var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in (get_area(H))
		if(H != W.theship.pilot)
			linked_emitter.linked_hologram = null
			linked_emitter = null
	.=..()
