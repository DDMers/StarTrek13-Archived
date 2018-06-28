/mob/living/carbon/human/borgqueen
	name = "Xel Queen"
	voice_name = "xel queen"
	verb_say = "states"
	icon = 'StarTrek13/icons/borg/borgqueen.dmi'
//	base_icon_state = "queen_s"
	icon_state = "queen_s"
	languages_spoken = HUMAN | BINARY
	languages_understood = HUMAN | BINARY
	gender = NEUTER
	ventcrawler = 0

/datum/species/xelqueen
	name = "Xel queen"
	id = "xelqueen"
	say_mod = "states"
	default_color = "59CE00"
	sexes = 0
	species_traits = list(VIRUSIMMUNE)
	skinned_type = /obj/item/stack/sheet/animalhide/human

/mob/living/carbon/human/borgqueen/New()
	. = ..()
	//THERE CAN BE ONLY ONE
	for(var/mob/living/carbon/human/borgqueen/Q in GLOB.living_mob_list)
		if(Q == src)
			continue
		if(Q.stat == DEAD)
			continue
		if(Q.client)
			src.gib()
			return

	real_name = src.name
	hair_color = "000"
	hair_style = "Bald"
	facial_hair_color = "000"
	facial_hair_style = "Shaved"
	set_species(/datum/species/xelqueen)
	if(icon_state != "queen_s")
		icon_state = "queen_s"
	update_icons()
	name = "Xel Queen"
	equipOutfit(/datum/outfit/borg/queen, visualsOnly = FALSE)
	internal_organs += new /obj/item/organ/body_egg/borgNanites(src)
//	AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/repulse/xeno(src))
//	AddAbility(new/obj/effect/proc_holder/alien/royal/queen/promote()
	var/datum/mind/meme = src.mind
	meme.special_role = "Xel"
	SSticker.mode.greet_borg(meme)
	SSticker.mode.forge_borg_objectives(meme)
	if(!(src in SSticker.mode.hivemind.borgs))
		SSticker.mode.hivemind.borgs += src

/datum/outfit/borg/queen
	name = "borg queen"
	//id = /obj/item/weapon/card/id/gold
//	belt = /obj/item/pda/captain
	glasses = /obj/item/clothing/glasses/night/borg
	ears = /obj/item/radio/headset/borg/alt
	uniform =  /obj/item/clothing/under/borg
	suit = /obj/item/clothing/suit/space/borg/regal
	shoes = /obj/item/clothing/shoes/magboots/borg
	head = /obj/item/clothing/head/borg/queen
	r_hand = /obj/item/borg_tool/queen
	mask = /obj/item/clothing/mask/gas/borg



/datum/outfit/borg/queen/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	H.eye_color = "red"
	H.underwear = "Nude"
	H.undershirt = "Nude"
	H.socks = "Nude"
	H.hair_style = "Bald"
	H.set_species(/datum/species/xelqueen)
	H.dna.species.species_traits |= NOCLONE
	H.dna.species.species_traits |= CLUMSY
	H.dna.species.species_traits |= BORG_DRONE
	H.dna.species.species_traits |= NOHUNGER
	H.dna.species.species_traits |= NOGUNS
	H.dna.species.species_traits |= NOBREATH
	H.name = "Xel Queen"
	if(!src in SSticker.mode.hivemind.borgs)
		SSticker.mode.hivemind.borgs += H



/mob/living/carbon/human/borgqueen/emp_act(severity)
	. = ..()

/mob/living/carbon/human/borgqueen/check_ear_prot()
	return 1

/mob/living/carbon/human/borgqueen/Stat()
	..()
	statpanel("Status")
	stat(null, text("Intent: []", a_intent))
	stat(null, text("Move Mode: []", m_intent))
	return

/mob/living/carbon/human/borgqueen/IsAdvancedToolUser()
	return 1

/mob/living/carbon/human/borgqueen/canBeHandcuffed()
	return 1

/mob/living/carbon/human/borgqueen/assess_threat(var/obj/machinery/bot/secbot/judgebot, var/lasercolor)

/mob/living/carbon/human/borgqueen/say(message, bubble_type)
//	playsound(src.loc, 'sound/predators/predator_clicking.ogg', 100, 1)
	return ..(message, bubble_type)

/mob/living/carbon/human/borgqueen/say_quote(var/text)
	return "[verb_say], \"[text]\"";