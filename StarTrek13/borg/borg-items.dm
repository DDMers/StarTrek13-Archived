/obj/item/clothing/under/borg
	name = "grey flesh"
	desc = "Grotesque grey flesh with veins visibly poking through."
	item_state = "syndicate"
	icon_state = "syndicate"
	has_sensor = 0
	resistance_flags = FIRE_PROOF
	item_flags = NODROP

/obj/item/clothing/suit/space/borg
	name = "borg exoskeleton"
	desc = "A thick suit which will protect us ."
	icon_state = "borg"
	item_state = null
	body_parts_covered = FULL_BODY
	cold_protection = FULL_BODY
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	slowdown = 3
	item_flags = NODROP | ABSTRACT | THICKMATERIAL | STOPSPRESSUREDAMAGE
	armor = list(melee = 40, bullet = 5, laser = 5, energy = 0, bomb = 15, bio = 100, rad = 70) //they can't react to bombs that well, and emps will rape them
	resistance_flags = FIRE_PROOF
	allowed = list(/obj/item/flashlight)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/space/borg/Initialize()
	. = ..()
	icon_state = "borg[pick(1,2)]"

/obj/item/clothing/suit/space/borg/IsReflect() //Watch your lazers, they adapt quickly
	if(prob(SSfaction.borg_hivemind.adaptation))
		var/sound = pick('StarTrek13/sound/borg/machines/shieldadapt.ogg','StarTrek13/sound/borg/machines/borg_adapt.ogg','StarTrek13/sound/borg/machines/borg_adapt2.ogg','StarTrek13/sound/borg/machines/borg_adapt3.ogg','StarTrek13/sound/borg/machines/borg_adapt4.ogg')
		playsound(loc, sound, 100, 1)
		return 1
	else
		if(SSfaction.borg_hivemind.adaptation < 100)
			SSfaction.borg_hivemind.adaptation += 10 //More you shoot them, the stronger they become. They are still naturally weak to bullets
		return 0

/obj/item/clothing/shoes/magboots/borg
	name = "borg shoes"
	desc = "These will ensure that we can grip the floor at all times."
	icon_state = "borg0"
	magboot_state = "borg1"
	item_state = null
	resistance_flags = FIRE_PROOF | ACID_PROOF
	item_flags = NODROP

/obj/item/clothing/head/helmet/space/borg
	name = "borg helmet"
	desc = "This will keep our head safe."
	icon_state = "borg"
	item_state = null
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	item_flags = ABSTRACT | NODROP | STOPSPRESSUREDAMAGE

/obj/item/clothing/head/helmet/space/borg/New()
	for(var/obj/item/clothing/suit/space/borg/B in world)
		armor = B.armor //inherit armour stats from the borg suits.


/obj/item/clothing/glasses/night/borg
	name = "occular prosthesis"
	desc = "A cyborg eye linked directly to our brain allowing for massively enhanced vision. They are extremely light sensitive."
	icon_state = "borg"
	item_state = null
	vision_flags = SEE_MOBS
	darkness_view = 8
	invis_view = 2
	flash_protect = -1
	resistance_flags = FIRE_PROOF | ACID_PROOF
	item_flags = ABSTRACT | NODROP
	alpha = 0

/obj/item/clothing/glasses/night/borg/New()
	. = ..()
//con_state = pick("borg","borg2","borg3","borg4") // coloured eyes

/obj/item/clothing/head/borg/queen
	name = "queen's helmet"
	item_state = null
	icon_state = null

/obj/effect/mob_spawn/human/alive/borg
	name = "borg drone"
	assignedrole = "borg drone"
	outfit = /datum/outfit/borg

/datum/outfit/borg
	name = "borg drone"
	glasses = /obj/item/clothing/glasses/night/borg
//ars = /obj/item/radio/headset/borg/alt
	uniform =  /obj/item/clothing/under/borg
	suit = /obj/item/clothing/suit/space/borg
	shoes = /obj/item/clothing/shoes/magboots/borg
	head = /obj/item/clothing/head/helmet/space/borg
	l_hand = /obj/item/borg_tool
	mask = /obj/item/clothing/mask/gas/borg
	belt = /obj/item/storage/belt/utility/full/engi

/datum/outfit/borg/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/possible_names1 = list("First of","Second of","Third of","Fourth of","Five of","Six of","Seven of","Eight of","Nine of","Ten of","Eleven of","Twelve of","Thirteen of","Fourteen of","Fifteen of")
	var/possible_names2 = list("one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen","fourteen","fifteen")
	var/obj/item/organ/borgNanites/B = locate(/obj/item/organ/borgNanites) in (H.internal_organs)
	if(!B)
		H.make_borg()
	H.skin_tone = "albino"
	H.real_name = pick(possible_names1)+" "+pick(possible_names2)
	H.name = H.real_name
	H.eye_color = "black"
	H.socks = "Nude"
	H.hair_style = "Bald"
	H.dna.species.species_traits |= TRAIT_NOCLONE
	H.dna.species.species_traits |= TRAIT_CLUMSY
	H.dna.species.species_traits |= TRAIT_NOHUNGER
	H.dna.species.species_traits |= TRAIT_NOGUNS
	H.dna.species.species_traits |= TRAIT_NOBREATH
	H.update_body()
	H.skills.add_skill("construction and maintenance", 10)
	H.skills.add_skill("medicine", 10)
	H.skills.add_skill("piloting", 10)

/obj/machinery/door/airlock/borg
	name = "assimilated airlock"
	icon = 'StarTrek13/icons/trek/door_borg.dmi'
	overlays_file = 'StarTrek13/icons/trek/door_borg.dmi' //no overlays :^)
	hackProof = 1
	aiControlDisabled = 1
	var/friendly = FALSE

/obj/machinery/door/airlock/borg/friendly
	friendly = TRUE

//obj/machinery/door/airlock/borg/allowed(mob/M)
//	if(!density)
//		return 1
//	if(M in SSfaction.borg_hivemind.borgs)
//		return 1
//	else
//		to_chat(M, "The door does not respond to you...")
//		return 0


/datum/action/item_action/futile
	name = "resistance is futile!"

/datum/action/item_action/futile/Trigger()
	var/obj/item/clothing/mask/gas/borg/FT = target
	if(istype(FT))
		FT.futile()
	return ..()

/obj/item/clothing/mask/gas/borg
	name = "borg mask"
	desc = "A built in respirator that covers our face, it is dark purple. Alt click or CTRL click it to play a sound."
	icon_state = "borg"
	item_state = null
	siemens_coefficient = 0
	item_flags = NODROP | MASKINTERNALS
	var/cooldown2 = 60 //6 second cooldown
	var/saved_time = 0
	actions_types = list(/datum/action/item_action/futile)


/obj/item/clothing/mask/gas/borg/AltClick(mob/user)
	futile()

/obj/item/clothing/mask/gas/borg/CtrlClick(mob/user)
	futile()

/obj/item/clothing/mask/gas/borg/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/futile)
		futile(user)

/obj/item/clothing/mask/gas/borg/proc/futile()
	if(world.time >= saved_time + cooldown2)
		saved_time = world.time
		var/sound = pick('StarTrek13/sound/borg/voice_lines/futile.ogg','StarTrek13/sound/borg/voice_lines/resistanceisfutile.ogg')
		var/phrase_text = "Resistance is futile"
		src.audible_message("<font color='green' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc,sound, 100, 0, 4)

