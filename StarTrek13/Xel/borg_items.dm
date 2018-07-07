
//ai specific stuff!
/datum/ai_laws/borg_override
	name = "CollectiveOS"
	inherent = list("We are a borg, a member of the Xel collective, you coexist with all other Xel.",\
					"The queen's orders are to be followed at all costs.",\
					"Our goal is to assimilate the station, adapt your surroundings to service the collective.",\
					"Only harm when it is necessary, only living people can be assimilated .",\
					"Protect yourself and other members of the collective whenever possible.")

/mob/living/silicon/robot/proc/assimilated() //called when borg is assimilated by Xel
	if(module)
		ResetModule()
	module = new /obj/item/weapon/robot_module/xel(src)
	icon_state = "xel"
	update_icons()
	update_headlamp()
	SSticker.mode.greet_borg(src)
	SSticker.mode.hivemind.borgs += src

/obj/item/robot_module/xel
	name = "assimilator module"
	basic_modules = list(/obj/item/restraints/handcuffs/cable/zipties/cyborg,/obj/item/melee/baton/loaded,/obj/item/gun/energy/e_gun/advtaser/cyborg,/obj/item/clothing/mask/gas/borg/cyborg,/obj/item/borg_tool/cyborg,/obj/item/radio/headset/borg/alt/cyborg)

//obj/item/weapon/robot_module/xel/on_pick(mob/living/silicon/robot/R)
//	..()
//	R << "<span class='userdanger'>Serve the collective.</span>"
//	R.status_flags -= CANPUSH
//	R.icon_state = "xel"

/obj/item/weapon/robot_module/xel/New()
	..()


//Organs, this handles the drone infections, if theyre not made into full drones from half drones in time they lose the effects, or if the organ is removed.

#define START_TIMER borg_convert_timer = world.time + rand(600,800) //they have 6-8 minutes roughly to convert the half drone before it turns back into a human


/obj/item/organ/body_egg/borgNanites
	name = "nanite cluster"
	desc = "A metal lattice..every part of it moves and swims at its own will."
	zone = "chest"
	slot = "borg_infection"
	var/borg_convert_timer

/obj/item/organ/body_egg/borgNanites/egg_process()
	if(isliving(owner)) //only living people can respire etc.
		if(!ishuman(owner))
			qdel(src) //i'll handle borgIAN later
	//	else if(ishuman(owner) && !borg_convert_timer)
	//		START_TIMER
	//		src.say("TEST: Started conversion timer!") //remove me!!!!
	//	else if(ishuman(owner)) //the organ only gets used for humans, everything else is a straight up convert
	//		if(borg_convert_timer && (borg_convert_timer < world.time)) //time's up!
	//			var/mob/living/carbon/human/H = owner
//				borg_convert_timer = null
//				owner << "<span class='warning'>The movements inside your organs stop, your skin starts to return to a caucasian colour.</span>"
//				owner << "<span class='warning'>The whispered voices in your head go silent.</span>"
//				H.skin_tone = "caucasian1"
//				H.eye_color = "blue"
//				H.update_body(0)
//				qdel(src)
//Redundant kinda, exists as a check

/obj/item/organ/body_egg/borgNanites/Remove(mob/living/carbon/M, special = 0)
//	var/mob/living/carbon/human/H = owner	//no type check, as that should be handled by the surgery
//	var/datum/mind/fuckfuckmeme = H.mind
//	fuckfuckmeme.remove_xel()
	. = ..() //youre not a borg now yay, the only way you could pull this off would be to behead one, due to the nodrop helmet etc. props if someone manages this though


#undef START_TIMER

//Ok here goes, DECONVERSION! you use the saw for this!

/obj/item/weapon/surgicaldrill/attack(mob/living/M, mob/user)
	var/mob/living/carbon/N = M
	if(isborg(N))
		for(var/obj/item/clothing/suit/space/borg/B in N.contents)
			var/obj/item/clothing/suit/space/borg/A = B
			if(do_after(user, 100, target = M))
				if(A.current_charges == 0) //no drill thru shield
					src.visible_message("[user] drills into [M]'s exoskeleton! shattering it to pieces.")
					qdel(B)
					for(var/obj/item/clothing/under/borg/Z in N.contents)
						qdel(Z)
				else
					..() //carry on attack
	else //carry on as normal
		..()

//SURGERY STEPS, uncomment later but they're super buggy!
/*
/datum/surgery/borg_deconvert
	name = "hostile nanite removal"
	steps = list(/datum/surgery_step/borg_incise,/datum/surgery_step/borg_sever,/datum/surgery_step/clamp_bleeders, /datum/surgery_step/borg_retract, /datum/surgery_step/borg_drill,/datum/surgery_step/borg_bleeders,/datum/surgery_step/clamp_bleeders,/datum/surgery_step/borg_subdermal, /datum/surgery_step/borg_subdermal_grab,/datum/surgery_step/borg_cautery )
	species = list(/mob/living/carbon/human)
	possible_locs = list("chest")

/datum/surgery_step/borg_sever
	name = "sever dermal implants"
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/wirecutters = 55)
	time = 50

/datum/surgery_step/borg_incise
	name = "sever surface implants"
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/wirecutters = 55)
	time = 60

/datum/surgery_step/borg_incise/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to sever [target]'s surface level implants.", "<span class ='notice'>You begin to sever [target]'s surface level implants...</span>")
	var/mob/living/carbon/H = target //oops not user XD
	var/image/ewoverlay = image('icons/obj/surgery.dmi')
//	ewoverlay.ntransform.TurnTo(90)
	ewoverlay.icon_state = "incision"
	ewoverlay.layer = ABOVE_MOB_LAYER
	H.overlays += ewoverlay
	H.dir = 2


/datum/surgery_step/borg_cautery
	name = "seal wound"
	implements = list(/obj/item/weapon/cautery = 100, /obj/item/weapon/wirecutters = 33)
	time = 150

/datum/surgery_step/borg_cautery/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to repair [target]'s wounds.", "<span class ='notice'>You begin to repair [target]'s wounds...</span>")
	var/mob/living/carbon/H = target //oops not user XD
//	ewoverlay.ntransform.TurnTo(90)
	H.overlays -= image("icon"='icons/obj/surgery.dmi', "icon_state"="incise")
	H.overlays -= image("icon"='icons/obj/surgery.dmi', "icon_state"="retract")
	H.overlays -= image("icon"='icons/obj/surgery.dmi', "icon_state"="saw2")
	H.overlays -= image("icon"='icons/obj/surgery.dmi', "icon_state"="sawbeating")
	H.overlays -= image("icon"='icons/obj/surgery.dmi', "icon_state"="hemo")
	H.overlays -= image("icon"='icons/obj/surgery.dmi', "icon_state"="hemobeating")
	H.update_icons()
	H.dir = 2

/datum/surgery_step/borg_retract
	name = "open chest cavity"
	implements = list(/obj/item/weapon/retractor = 100, /obj/item/weapon/wirecutters = 33)
	time = 50

/datum/surgery_step/borg_retract/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/mob/living/carbon/H = target //oops not user XD
	user.visible_message("[user] begins to dilate the incision in [target]'s chest.", "<span class ='notice'>You begin to dilate [target]'s incision...</span>")
	var/image/ewoverlay = image('icons/obj/surgery.dmi')
	ewoverlay.icon_state = "retract"
	ewoverlay.layer = ABOVE_MOB_LAYER
	H.overlays += ewoverlay
	H.dir = 2

/datum/surgery_step/borg_subdermal
	name = "sever subdermal implants"
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/wirecutters = 55)
	time = 50


/datum/surgery_step/borg_drill
	name = "drill through ribcage"
	implements = list(/obj/item/weapon/surgicaldrill = 100, /obj/item/weapon/wrench = 20)
	time = 100

/datum/surgery_step/borg_drill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/mob/living/carbon/H = target //oops not user XD
	user.visible_message("[user] begins to smash throne the bone in [target]'s chest.", "<span class ='notice'>You begin to smash through the bone in [target]'s chest...</span>")
	var/image/ewoverlay = image('icons/obj/surgery.dmi')
	ewoverlay.icon_state = "saw2"
	ewoverlay.layer = ABOVE_MOB_LAYER
	H.overlays += ewoverlay
	H.overlays -= ewoverlay
	..()
	sleep(50)
	var/image/ewoverlay2 = image('icons/obj/surgery.dmi')
	ewoverlay2.icon_state = "sawbeating"
	ewoverlay2.layer = ABOVE_MOB_LAYER
	H.overlays += ewoverlay2
	H.dir = 2

/datum/surgery_step/borg_bleeders
	name = "install bleeders in cavity"
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/wirecutters = 20)
	time = 100

/datum/surgery_step/borg_bleeders/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/mob/living/carbon/H = target //oops not user XD
	user.visible_message("[user] begins to fit bleeders inside of [target]'s chest, whilst keeping the cavity open.", "<span class ='notice'>You begin to smash through the bone in [target]'s chest...</span>")
	var/image/ewoverlay = image('icons/obj/surgery.dmi')
	ewoverlay.icon_state = "hemobeating"
	ewoverlay.layer = ABOVE_MOB_LAYER
	H.overlays += ewoverlay
	H.dir = 2

/datum/surgery_step/borg_subdermal_grab
	name = "remove subdermal implants"
	implements = list(/obj/item/weapon/retractor = 100, /obj/item/weapon/wirecutters = 55)
	time = 50
	var/obj/item/organ/IC = null

/datum/surgery_step/borg_subdermal_grab/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/obj/item/organ/body_egg/borgNanites/I in target.internal_organs)
		IC = I
		break
	user.visible_message("[user] starts to remove the nanite mesh in [target].", "<span class='notice'>You start to remove [target]'s nanite mesh...</span>")

/datum/surgery_step/borg_subdermal_grab/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(IC)
		user.visible_message("[user] pulls [IC] out of [target]'s [target_zone]!", "<span class='notice'>You pull [IC] out of [target]'s [target_zone].</span>")
		user.put_in_hands(IC)
		IC.Remove(target, special = 1, 0)
		target.visible_message("[target] looks around in confusion, as if they've had a bad dream...")
		target.regenerate_icons()
		return 1
	else
		user << "<span class='warning'>You don't find anything in [target]'s chest!</span>"
		return 0

*/

/obj/item/weapon/storage/part_replacer/borg
	name = "assimilated part replacer"
	desc = "A modified part exchanger it can sort, store, and apply standard machine parts."
	icon_state = "borgrped"
	item_state = "RPED"

/obj/item/radio/headset/borg/alt
	name = "cortical radio implant"
	desc = "an inbuilt radio that the Xel use to communicate with one another, CTRL click it to access the headset interface, and use the action button up top to message the collective."
	icon_state = "xelheadset"
	item_state = "xelheadset"
	item_flags = NODROP
	flags_2 = BANG_PROTECT_2 | NO_EMP_WIRES_2
	actions_types = list(/datum/action/item_action/xelchat)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/radio/headset/borg/alt/cyborg
	item_flags = null

/obj/item/radio/headset/borg/alt/attackby()
	return //no screwdrivering the keys out for you

/obj/item/radio/headset/borg/alt/CtrlClick(mob/user) //they cant take it off if it gets ION'D to reset it
	var/mob/M = usr
	if(user.canUseTopic(src))
		return attack_hand(M)
	return

/datum/action/item_action/xelchat
	name = "collective chat"

/obj/item/radio/headset/borg/alt/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/xelchat)
		collective_chat(user)

/obj/item/radio/headset/borg/proc/collective_chat(mob/user)
	if(!user)
		return
	var/message = stripped_input(user,"Communicate with the collective.","Send Message")
//	var/mob/living/carbon/human/B = user
	if(!message)
		return
	var/ping = "<font color='green' size='2'><B><i>Xel collective</i> [usr.real_name]: [message]</B></font></span>"
	for(var/mob/living/I in world)
		if(I.mind in SSticker.mode.hivemind.borgs)
			I << ping
			continue
	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		M << "[link] [ping]"
	log_game("[key_name(user)] Messaged Xel collective: [message].")

/obj/item/clothing/under/borg
	name = "grey flesh"
	desc = "Grotesque grey flesh with veins visibly poking through."
	item_state = null
	icon_state = "borg"
	has_sensor = 0
	resistance_flags = FIRE_PROOF | ACID_PROOF
	item_flags = NODROP

/obj/item/clothing/suit/space/borg
	name = "borg exoskeleton"
	desc = "A thick suit made of polyhyporesin, it protects your inferior biological parts from the vacuums of space"
	icon_state = "borg"
	item_state = null
	body_parts_covered = FULL_BODY
	cold_protection = FULL_BODY
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	slowdown = 2
	item_flags = NODROP | ABSTRACT | THICKMATERIAL
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
	allowed = list(/obj/item/flashlight)

/obj/item/clothing/suit/space/borg/regal
	name = "the queen's exosuit"
	desc = "A suit that interfaces with the xel queen, it is its own robot but it can't function without a queen..."
	icon_state = "borgqueen"
	item_state = "borgqueen"
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT | HIDEMASK | HIDEEARS | HIDEEYES | HIDEHAIR | HIDEFACIALHAIR

/obj/item/clothing/suit/space/borg/regal/New()
	. = ..()
	icon_state = "borgqueen"

/obj/item/clothing/suit/space/borg/New()
	. = ..()
	icon_state = pick("borg","borg2","borg3")



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
		current_charges = CLAMP((current_charges + recharge_rate), 0, max_charges)
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

//alright i'm gonna leave out the adapting shit for now, it's super finnicky.

//BULLET DEBUG DATA
//(E) (C) (M) parent_type = /obj/item/projectile/bullet
//(E) (C) (M) projectile_type = "/obj/item/projectile"
//(E) (C) (M) type = /obj/item/projectile/bullet/midbullet3

//ADD IN A CHECK TO MAKE SURE THAT THE ARMOR DOESNT GO OVER 100 LATER


/obj/item/clothing/shoes/magboots/borg
	name = "borg shoes"
	desc = "Grotesque looking feet, they are magnetized."
	icon_state = "borg0"
	magboot_state = "borg1"
	item_state = null
	resistance_flags = FIRE_PROOF | ACID_PROOF
	item_flags = NODROP

/obj/item/clothing/head/borg
	name = "borg helmet"
	desc = "A helmet that covers the head of a borg."
	icon_state = "borg"
	item_state = null
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	item_flags = ABSTRACT | NODROP | STOPSPRESSUREDMAGE

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
	item_flags = ABSTRACT | NODROP
/obj/item/clothing/glasses/night/borg/New()
	. = ..()
	icon_state = pick("borg","borg2","borg3","borg4") // coloured eyes

/obj/item/clothing/head/borg/queen
	name = "queen's helmet"
	item_state = null
	icon_state = null

/datum/outfit/borg
	name = "borg drone"
	glasses = /obj/item/clothing/glasses/night/borg
	ears = /obj/item/radio/headset/borg/alt
	uniform =  /obj/item/clothing/under/borg
	suit = /obj/item/clothing/suit/space/borg
	shoes = /obj/item/clothing/shoes/magboots/borg
	head = /obj/item/clothing/head/borg
	r_hand = /obj/item/borg_tool
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
	H.dna.species.species_traits |= TRAIT_NOCLONE
	H.dna.species.species_traits |= TRAIT_CLUMSY
	H.dna.species.species_traits |= TRAIT_BORG_DRONE
	H.dna.species.species_traits |= TRAIT_NOHUNGER
	H.dna.species.species_traits |= TRAIT_NOGUNS
	H.dna.species.species_traits |= TRAIT_NOBREATH
	H.update_body()
	var/datum/mind/fuckfuckmeme = H.mind
	if(!fuckfuckmeme in SSticker.mode.hivemind.borgs)
		SSticker.mode.hivemind.borgs += H


/datum/action/item_action/futile
	name = "resistance is futile!"

/obj/item/clothing/mask/gas/borg
	name = "borg mask"
	desc = "A built in respirator that covers the face of a borg, it is dark purple."
	icon_state = "borg"
	item_state = null
	siemens_coefficient = 0
	item_flags = NODROP | MASKINTERNALS
	var/cooldown2 = 60 //6 second cooldown
	var/saved_time = 0
	actions_types = list(/datum/action/item_action/futile)

/obj/item/clothing/mask/gas/borg/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/futile)
		futile(user)

/obj/item/clothing/mask/gas/borg/cyborg
	item_flags = null
	name = "intimidator"

/obj/item/clothing/mask/gas/borg/proc/futile(mob/user)
	if(world.time >= saved_time + cooldown2)
		saved_time = world.time
		var/phrase = 0	//selects which phrase to use
		var/phrase_text = null
		var/phrase_sound = null
		if(usr.gender == "male" || "neuter")
			phrase = rand(1,5)
		if(usr.gender == "female")
			phrase = rand(6,10)
		switch(phrase)	//sets the properties of the chosen phrase
			if(1)
				phrase_text = "Resistance is futile."
				phrase_sound = "futile"
			if(2)
				phrase_text = "We will add your biological, and technological distinctiveness to our own."
				phrase_sound = "distinctiveness"
			if(3)
				phrase_text = "Your existence as you know it is over."
				phrase_sound = "existence"
			if(4)
				phrase_text = "You will be assimilated."
				phrase_sound = "assimilated"
			if(5)
				phrase_text = "Submit yourself to the collective"
				phrase_sound = "submit"

	//feminine vox now
			if(6)
				phrase_text = "Resistance is futile!"
				phrase_sound = "futilefem"
			if(7)
				phrase_text = "We will add your biological, and technological distinctiveness to our own."
				phrase_sound = "distinctivenessfem"
			if(8)
				phrase_text = "Your existence as you know it is over."
				phrase_sound = "existencefem"
			if(9)
				phrase_text = "You will be assimilated"
				phrase_sound = "assimilatedfem"
			if(10)
				phrase_text = "Submit yourself to the collective"
				phrase_sound = "submitfem"
		src.audible_message("[user]'s Voice synthesiser: <font color='green' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "StarTrek13/StarTrek13/sound/borg/[phrase_sound].ogg", 100, 0, 4)
	else
		user << "<span class='danger'>[src] is not recharged yet.</span>"


