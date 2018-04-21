/obj/item/clothing/under/borg
	name = "grey flesh"
	desc = "Grotesque grey flesh with veins visibly poking through."
	item_state = null
	icon_state = "syndicate"
	has_sensor = 0
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flags_1 = NODROP_1

/obj/item/clothing/suit/space/borg
	name = "borg exoskeleton"
	desc = "A thick suit which will protect us ."
	icon_state = "borg"
	item_state = null
	body_parts_covered = FULL_BODY
	cold_protection = FULL_BODY
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	slowdown = 2
	flags_1 = NODROP_1 | ABSTRACT_1 | THICKMATERIAL_1
	heat_protection = null //burn the borg
	max_heat_protection_temperature = null
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 15, bio = 100, rad = 70) //they can't react to bombs that well, and emps will rape them
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/current_charges = 3
	var/max_charges = 3 //How many charges total the shielding has
	var/recharge_delay = 200 //How long after we've been shot before we can start recharging. 20 seconds here
	var/recharge_cooldown = 0 //Time since we've last been shot
	var/recharge_rate = 1 //How quickly the shield recharges once it starts charging
	var/shield_state = "borgshield"
	var/shield_on = "borgshield"
	allowed = list(/obj/item/device/flashlight)

/obj/item/clothing/suit/space/borg/New()
	. = ..()


/obj/item/clothing/suit/space/borg/hit_reaction(mob/living/carbon/human/owner, attack_text) //stolen from shielded hardsuit
	if(current_charges > 0)
		var/datum/effect_system/spark_spread/s = new
		s.set_up(2, 1, src)
		s.start()
		owner.visible_message("<span class='danger'>[owner]'s shields deflect [attack_text] in a shower of sparks!</span>")
		var/sound = pick('StarTrek13/sound/borg/machines/shieldadapt.ogg','StarTrek13/sound/borg/machines/borg_adapt.ogg','StarTrek13/sound/borg/machines/borg_adapt2.ogg','StarTrek13/sound/borg/machines/borg_adapt3.ogg','StarTrek13/sound/borg/machines/borg_adapt4.ogg')
		playsound(loc, sound, 50, 1)
		current_charges--
		recharge_cooldown = world.time + recharge_delay
		START_PROCESSING(SSobj, src)
		if(current_charges <= 0)
			owner.visible_message("[owner]'s shield overloads!")
			shield_state = "broken"
			owner.update_inv_wear_suit()
		return 1
	return 0

/obj/item/clothing/suit/space/borg/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/space/borg/process()
	if(world.time > recharge_cooldown && current_charges < max_charges)
		current_charges = Clamp((current_charges + recharge_rate), 0, max_charges)
		playsound(loc, 'sound/effects/stealthoff.ogg', 50, 1)
		if(current_charges == max_charges)
			STOP_PROCESSING(SSobj, src)
		shield_state = "[shield_on]"
		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/C = loc
			C.update_inv_wear_suit()


/obj/item/clothing/suit/space/borg/worn_overlays(isinhands)
    . = list()
    if(!isinhands)
        . += image(icon = 'icons/effects/effects.dmi', icon_state = "[shield_state]")

/obj/item/clothing/shoes/magboots/borg
	name = "borg shoes"
	desc = "These will ensure that we can grip the floor at all times."
	icon_state = "borg0"
	magboot_state = "borg1"
	item_state = null
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flags_1 = NODROP_1

/obj/item/clothing/head/borg
	name = "borg helmet"
	desc = "This will keep our head safe."
	icon_state = "borg"
	item_state = null
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flags_1 = ABSTRACT_1 | NODROP_1 | STOPSPRESSUREDMAGE_1

/obj/item/clothing/head/borg/New()
	for(var/obj/item/clothing/suit/space/borg/B in world)
		armor = B.armor //inherit armour stats from the borg suits.


/obj/item/clothing/glasses/night/borg
	name = "occular prosthesis"
	desc = "A freaky cyborg eye linked directly to the brain allowing for massively enhanced vision, they are extremely light sensitive."
	icon_state = "borg"
	item_state = null
	vision_flags = SEE_MOBS
	darkness_view = 8
	invis_view = 2
	flash_protect = -1
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flags_1 = ABSTRACT_1 | NODROP_1
	alpha = 0

/obj/item/clothing/glasses/night/borg/New()
	. = ..()
//con_state = pick("borg","borg2","borg3","borg4") // coloured eyes

/obj/item/clothing/head/borg/queen
	name = "queen's helmet"
	item_state = null
	icon_state = null

/datum/outfit/borg
	name = "borg drone"
	glasses = /obj/item/clothing/glasses/night/borg
//ars = /obj/item/device/radio/headset/borg/alt
	uniform =  /obj/item/clothing/under/borg
	suit = /obj/item/clothing/suit/space/borg
	shoes = /obj/item/clothing/shoes/magboots/borg
	head = /obj/item/clothing/head/borg
	l_hand = /obj/item/borg_tool
	mask = /obj/item/clothing/mask/gas/borg

/datum/outfit/borg/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/possible_names1 = list("First of","Second of","Third of","Fourth of","Five of","Six of","Seven of","Eight of","Nine of","Ten of","Eleven of","Twelve of","Thirteen of","Fourteen of","Fifteen of")
	var/possible_names2 = list("one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen","fourteen","fifteen")
	H.skin_tone = "albino"
	H.real_name = pick(possible_names1)+" "+pick(possible_names2)
	H.name = H.real_name
	H.eye_color = "red"
	H.underwear = "Nude"
	H.undershirt = "Nude"
	H.socks = "Nude"
	H.hair_style = "Bald"
	H.dna.species.species_traits |= NOCLONE
	H.dna.species.species_traits |= CLUMSY
	H.dna.species.species_traits |= NOHUNGER
	H.dna.species.species_traits |= NOGUNS
	H.dna.species.species_traits |= NOBREATH
	H.update_body()

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

/obj/item/clothing/mask/gas/borg
	name = "borg mask"
	desc = "A built in respirator that covers the face of a borg, it is dark purple."
	icon_state = "borg"
	item_state = null
	siemens_coefficient = 0
	flags_1 = NODROP_1 | MASKINTERNALS_1
	var/cooldown2 = 60 //6 second cooldown
	var/saved_time = 0
	actions_types = list(/datum/action/item_action/futile)

/obj/item/clothing/mask/gas/borg/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/futile)
		futile(user)

/obj/item/clothing/mask/gas/borg/cyborg
	flags_1 = null
	name = "intimidator"

/obj/item/clothing/mask/gas/borg/proc/futile(mob/user)
	if(world.time >= saved_time + cooldown2)
		saved_time = world.time
		var/phrase_text = "Resistance is futile"
		var/phrase_sound = 'StarTrek13/sound/borg/voice_lines/futile.ogg'
		src.audible_message("[user]'s Voice synthesiser: <font color='green' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "StarTrek13/StarTrek13/sound/borg/[phrase_sound].ogg", 100, 0, 4)
	else
		user << "<span class='danger'>[src] is not recharged yet.</span>"


