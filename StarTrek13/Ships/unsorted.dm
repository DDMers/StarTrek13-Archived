/obj/item/clothing/neck/combadge
	name = "combadge"
	icon = 'icons/obj/clothing/neck.dmi'
	desc = "Standard issue communications device issued by starfleet, you must alt click it first, which will allow you to use it on that ship, to link it to another ship, just alt click it again. Ctrl click it to toggle transmission and receipt of messages"
	icon_state = "combadge"
	var/obj/item/clothing/neck/combadge/ping //If we're pinging a specific person
	var/area/ship/linked
	var/mob/living/stored_user
	var/on = FALSE
	var/next_talk = 0 //used for move delays
	var/talk_delay = 0.1
	var/comms_sound = 'StarTrek13/sound/borg/machines/combadge.ogg'
	var/command_allowed = FALSE //upgrade it with a encryption key
	var/obj/item/encryptionkey/thekey

/obj/item/clothing/neck/combadge/examine(mob/user)
	. = ..()
	if(command_allowed)
		to_chat(user, "Its command frequency is enabled, use :c to speak on it")

/obj/item/clothing/neck/combadge/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/encryptionkey/headset_com) || istype(I, /obj/item/encryptionkey/heads))
		I.forceMove(src)
		thekey = I
		to_chat(user, "You slot [I] into [src]")
		command_allowed = TRUE
	if(istype(I, /obj/item/screwdriver))
		if(thekey)
			thekey.forceMove(get_turf(src))
			to_chat(user, "You remove [thekey] from [src]")
			thekey = null
			command_allowed = FALSE

/obj/item/clothing/neck/combadge/wars
	name = "stormtrooper helmet radio"
	comms_sound = 'StarTrek13/sound/trek/radioclick.ogg'

/obj/item/clothing/neck/combadge/Initialize()
	. = ..()
	var/mob/living/theuser = locate(/mob/living) in get_turf(src)
	if(theuser && ismob(theuser))
		if(!linked) //Yeah. People got confused
			to_chat(theuser, "Activating comms")
			stored_user = theuser
			link_to_area(theuser)
			if(!on)
				CtrlClick(theuser)

/obj/item/clothing/neck/combadge/CtrlClick(mob/user)
	playsound(loc, comms_sound, 30, 1)
	stored_user = user
	if(on)
		to_chat(user, "Broadcasting disabled")
		on = FALSE
		return
	if(!on)
		to_chat(user, "Broadcasting enabled")
		on = TRUE
		return

/obj/item/clothing/neck/combadge/AltClick(mob/user)
	link_to_area(user)

/obj/item/clothing/neck/combadge/proc/link_to_area(mob/user)
	playsound(loc, comms_sound, 30, 1)
	on = TRUE
	if(linked)
		linked.combadges -= src
	linked = null
	var/area/A = get_area(src)
	if(istype(A, /area/ship))
		var/area/ship/S = A
		linked = S
		S.combadges += src
		to_chat(user, "Combadge linked to [linked] comms network.")


/obj/item/clothing/neck/combadge/proc/send_message(var/message, mob/living/user)
	if(user.stat == DEAD)
		return 0
	if(!linked) //Yeah. People got confused
		link_to_area(user)
		if(!on)
			CtrlClick(user)
	if(world.time < next_talk)
		return 0
	next_talk = world.time + talk_delay
	stored_user = user
//	to_chat(stored_user, "<span class='warning'><b>[linked] ship comms: </b><b>[user]</b> <b>([user.mind.assigned_role])</b>: [message]</span>")
	for(var/obj/item/clothing/neck/combadge/C in linked.combadges)
		if(C != src && C.stored_user == stored_user)
			C.stored_user = null
		if(C.on && C.stored_user)
			playsound(C.loc, C.comms_sound, 20, 1)
			to_chat(C.stored_user, "<span class='warning'><b>[linked] ship comms:</b><b>[user]</b> <b>([user.mind.assigned_role])</b>: [message]</span>")
	for(var/mob/O in GLOB.dead_mob_list)
		to_chat(O, "<span class='warning'><b>[linked] ship comms:</b><b>[user]</b> <b>([user.mind.assigned_role])</b>: [message]</span>")

/obj/item/clothing/neck/combadge/proc/send_message_command(var/message, mob/living/user)
	if(user.stat == DEAD)
		return 0
	if(!linked) //Yeah. People got confused
		link_to_area(user)
		if(!on)
			CtrlClick(user)
	if(world.time < next_talk)
		return 0
	next_talk = world.time + talk_delay
	stored_user = user
	for(var/obj/item/clothing/neck/combadge/C in linked.combadges)
		if(C != src && C.stored_user == stored_user)
			C.stored_user = null
		if(C.on && C.command_allowed && C.stored_user) //LEMME GET IT STARTED LOOKIN ALL RETARDED
			playsound(C.loc, C.comms_sound, 20, 1)
			to_chat(C.stored_user, "<span class='notice'><b>[linked] command frequency: </b><b>[user]</b> <b>([user.mind.assigned_role])</b>: <i>[message]</i></span>")
	for(var/mob/O in GLOB.dead_mob_list)
		to_chat(O, "<span class='notice'><b>[linked] command frequency: </b><b>[user]</b> <b>([user.mind.assigned_role])</b>: <i>[message]</i></span>")


/obj/item/clothing/neck/combadge/proc/pm_user(var/message, mob/living/user)
	if(world.time < next_talk)
		return 0
	next_talk = world.time + talk_delay
//	for(var/obj/item/clothing/neck/combadge/C in linked.combadges)
//		if(C.stored_user)
//			if(findtext(message, "[C.stored_user.first_name()] "))
//				to_chat(world, "HAHAHAHA")

/*

/obj/effect/proc_holder/spell/aoe_turf/rage //I'm bored
	name = "Force Rage"
	desc = "Unleash your fury, tear down the walls, crush those in your way"
	charge_max = 400
	clothes_req = 0
	invocation = "FEAR ME"
	invocation_type = "shout"
	range = 10
	cooldown_min = 150
	selection_type = "view"
	sound = 'sound/magic/repulse.ogg'
	var/maxthrow = 5
	var/sparkle_path = /obj/effect/temp_visual/gravpush

	action_icon_state = "repulse"

/obj/effect/proc_holder/spell/aoe_turf/rage/cast(list/targets,mob/user = usr, var/stun_amt = 40)
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	playMagSound()
	for(var/turf/T in targets) //Done this way so things don't get thrown all around hilariously.
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue
		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(isliving(AM))
			var/mob/living/M = AM
			do_knockdown(M)


/obj/effect/proc_holder/spell/aoe_turf/rage/proc/do_knockdown(mob/living/carbon/M)
	to_chat(M, "mrmem forces you up into the air!")
//	M.stun(50)
	M.pixel_y += 10
	sleep(50)
	M.pixel_y += 10
	to_chat(M, "<span class='userdanger'>You feel a crushing force bear down on you as eee slams you into the deck plates!</span>")
	M.pixel_y = initial(M.pixel_y)
	M.Knockdown(100)
	shake_camera(M, 1, 20)
	M.adjustBruteLoss(5)

*/
/obj/item/clothing/suit/space/nanosuit
	name = "MT-X0F Nanosuit"
	desc = "A suit fusing borg technology with a highly advanced hardsuit, it contains several attachment points which are designed to interface with a borg, which will allow direct control over the nanites in their bloodstream. Using this exerts enormous physical strain on the user"
	icon_state = "skulls"
	item_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = FULL_BODY
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	slowdown = 2
	item_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 0, bomb = 30, bio = 100, rad = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	allowed = list(/obj/item/flashlight)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	var/InUse = FALSE

/obj/item/clothing/suit/space/nanosuit/ShiftClick(mob/user)
	. = ..()
	SpeedBoost()

/obj/item/clothing/suit/space/nanosuit/AltClick(mob/user)
	ArmourBoost()

/obj/item/clothing/suit/space/nanosuit/Initialize(timeofday)
	START_PROCESSING(SSobj,src)

/obj/item/clothing/shoes/combat/nanosuit
	name = "Nanofibre combat boots"

/obj/item/clothing/shoes/combat/nanosuit/step_action()
	. = ..()
	playsound(src,'StarTrek13/sound/trek/heavywalk.ogg',40,1)

/obj/item/clothing/suit/space/nanosuit/process()
	var/mob/living/carbon/human/user = src.loc
	if(ismob(user))
		if(InUse)
			user.adjustStaminaLoss(8)

/obj/item/clothing/suit/space/nanosuit/proc/CheckValidity() //Can we use this power?
	var/mob/living/carbon/human/user = src.loc
	user.update_inv_wear_suit()
	if(!/obj/item/clothing/shoes/combat/nanosuit in user.shoes)
		to_chat(user, "ERROR: No combat boots detected with a suitable interface.")
		return 0
	if(InUse)
		to_chat(user, "\[ <span style='color: #00ff00;'>ok</span> \] Nanoprobes returning to body.")
		InUse = FALSE
		armor = list(melee = 40, bullet = 30, laser = 30, energy = 0, bomb = 30, bio = 100, rad = 100)
		slowdown = initial(slowdown)
		icon_state = initial(icon_state)
		return 1
	else
		if(!InUse)
			to_chat(user, "\[ <span style='color: #00ff00;'>ok</span> \] Sending command to nanoprobes ..{}")
			to_chat(user, "\[ <span style='color: #00ff00;'>ok</span> \] Success!")
			return 1
		else
			to_chat(user, "\[ <span style='color: #00ff00;'>FAIL</span> \] ERROR: Nanoprobes already in distribution points.")
			return 0


/obj/item/clothing/suit/space/nanosuit/proc/SpeedBoost()
	armor = list(melee = 80, bullet = 50, laser = 45, energy = 20, bomb = 50, bio = 100, rad = 100)
	slowdown = 2
	icon_state = "skulls"
	if(CheckValidity())
		if(InUse)
			slowdown = initial(slowdown)
			InUse = FALSE
		else
			slowdown = 0 //Successfully active
			InUse = TRUE

/obj/item/clothing/suit/space/nanosuit/proc/ArmourBoost()
	if(CheckValidity())
		if(InUse)
			armor = list(melee = 40, bullet = 30, laser = 30, energy = 0, bomb = 30, bio = 100, rad = 100)
			slowdown = initial(slowdown)
			icon_state = initial(icon_state)
			InUse = TRUE
		else
			armor = list(melee = 80, bullet = 50, laser = 45, energy = 20, bomb = 50, bio = 100, rad = 100)
			slowdown = 5
			icon_state = "skulls-armour"
			InUse = FALSE


/obj/structure/replicator
	name = "replicator"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "replicator-off"
	desc = "It invariably produces something that's almost (but not quite) entirely unlike tea"
	var/power = 100
	var/power_cost = 10 //Burgers are pricy yo
	var/recharge_rate = 3
	anchored = TRUE
	density = TRUE

/obj/structure/replicator/huge
	name = "Advanced Replicator"
	desc = "Now with a built-in subroutine designed to answer why Arthur Dent likes tea to prevent operational runtimes."
	icon = 'StarTrek13/icons/trek/large_replicator.dmi'

/obj/structure/replicator/Initialize()
	. = ..()
	START_PROCESSING(SSobj,src)


/obj/structure/replicator/process()
	if(power < 100)
		power += recharge_rate
	else
		power = 100

/obj/structure/replicator/attack_hand(mob/user)
	icon_state = "replicator-on"
	if(power < power_cost)
		to_chat(user, "[src]'s matter synthesisers are still recharging")
		return 0
	if(ishuman(user))
		var/mode = alert("What kind of food would you like?",,"Burger", "Pizza", "Tea, earl grey", "Sandwich")
		var/temp = alert("How hot do you want it?",,"Cold", "Warm", "Hot")
		if(!mode || !temp)
			return 0
		user.say("[mode], [temp]")
		icon_state = "replicator-replicate"
		power -= power_cost
		switch(mode)
			if("Burger")
				var/obj/item/reagent_containers/food/snacks/burger/plain/thefood = new(src.loc)
				playsound(src.loc, 'StarTrek13/sound/trek/replicator.ogg', 100,1)
				thefood.name = "[temp] [thefood.name]"
			if("Pizza")
				var/obj/item/reagent_containers/food/snacks/pizza/margherita/thefood = new(src.loc)
				playsound(src.loc, 'StarTrek13/sound/trek/replicator.ogg', 100,1)
				thefood.name = "[temp] [thefood.name]"
			if("Tea, earl grey")
				var/obj/item/reagent_containers/food/drinks/mug/tea/thefood = new(src.loc)
				playsound(src.loc, 'StarTrek13/sound/trek/replicator.ogg', 100,1)
				thefood.name = "[temp] [thefood.name]"
			if("Sandwich")
				var/obj/item/reagent_containers/food/snacks/sandwich/thefood = new(src.loc)
				playsound(src.loc, 'StarTrek13/sound/trek/replicator.ogg', 100,1)
				thefood.name = "[temp] [thefood.name]"
	sleep(40)
	icon_state = "replicator-off"

/obj/item/ammo_casing/energy/electrode/phaserstun
	e_cost = 100
	fire_sound = 'StarTrek13/sound/borg/machines/phaser.ogg'
	select_name = "stun"

/obj/item/ammo_casing/energy/laser/phaserkill
	select_name = "kill"
	fire_sound = 'StarTrek13/sound/borg/machines/phaser.ogg'

/obj/item/gun/energy/laser/retro
	name = "hand phaser"
	desc = "A standard issue phaser with two modes: Stun and Kill."
	icon_state = "phaser"
	ammo_x_offset = 2
	selfcharge = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/phaserstun, /obj/item/ammo_casing/energy/laser/phaserkill)

/obj/item/storage/book/skillbook
	name = "piloting field manual"
	desc = "This small book contains a myriad of complex annotated digrams which will help you learn to fly ships! After clicking this in hand, you will learn basic piloting skills and the book will disappear."

/obj/item/storage/book/skillbook/attack_self(mob/user)
	if(ishuman(user))
		var/datum/skill/S = user.skills.getskill("piloting")
		if(S.value > 4)
			to_chat(user, "You skim through the manual, but you already know this material.")
			return ..()
		user.skills.add_skill("piloting", (5 - S.value))
		to_chat(user, "After skimming through [src] you feel confident that you'll be able to fly a starship to a basic level!")
		qdel(src)
	else
		. = ..()

/obj/item/storage/book/skillbook/engi
	name = "guide to engineering"
	desc = "This small book contains a set of complex annotated blueprints and instructions which will help you learn to maintain and modify starships! After clicking this in hand, you will learn basic engineering skills and the book will disappear."

/obj/item/storage/book/skillbook/engi/attack_self(mob/user)
	if(ishuman(user))
		var/datum/skill/S = user.skills.getskill("construction and maintenance")
		if(S.value > 4)
			to_chat(user, "You skim through the manual, but you already know this material.")
			return ..()
		user.skills.add_skill("construction and maintenance", (5 - S.value))
		to_chat(user, "After skimming through [src] you feel confident that you'll be able to maintain a starship!")
		qdel(src)
	else
		. = ..()

/obj/item/storage/book/skillbook/med
	name = "doctor's guide for medical practices"
	desc = "This small book contains a set of instructions and pictures of the human body, annotated. After clicking this in hand, you will learn basic engineering skills and the book will disappear."

/obj/item/storage/book/skillbook/med/attack_self(mob/user)
	if(ishuman(user))
		var/datum/skill/S = user.skills.getskill("medicine")
		if(S.value > 4)
			to_chat(user, "You skim through the manual, but you already know this material.")
			return ..()
		user.skills.add_skill("medicine", (5 - S.value))
		to_chat(user, "After skimming through [src] you feel confident that you'll be able to work basic medicinal practices!")
		qdel(src)
	else
		. = ..()


	//Atmospherics
/obj/item/clothing/head/helmet/space/hardsuit/trek
	name = "EV suit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has thermal shielding."
	icon_state = "hardsuit0-federation"
	item_state = "federation"
	item_color = "federation"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 5, "bomb" = 10, "bio" = 100, "rad" = 25, "fire" = 100, "acid" = 75)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/trek
	name = "EV suit"
	desc = "A standard issue hardsuit developed in the 24th century, it has heat shielding and specialized enviornmental plating to protect its wearer from most hazardous situations."
	icon_state = "hardsuit-federation"
	item_state = "hardsuit-federation"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 5, "bomb" = 10, "bio" = 100, "rad" = 25, "fire" = 100, "acid" = 75)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/trek

/obj/machinery/suit_storage_unit/trek
	suit_type = /obj/item/clothing/suit/space/hardsuit/trek
	mask_type = /obj/item/clothing/mask/breath

/client/verb/looc(message as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view. Remember: Just because you see someone that doesn't mean they see you. Abuse of this will lead to a ban!"
	set category = "OOC"
	if(message)
		try_looc(message)

/client/proc/try_looc(var/message as text)
	var/mob/M = mob
	if(!M)
		to_chat(src, "<span class='danger'>You cannot use LOOC without a mob.</span>")
		return FALSE
	if(!get_turf(M))
		to_chat(src, "<span class='danger'>You cannot use LOOC while in nullspace. Ahelp this!</span>")
		return FALSE
	if(!GLOB.ooc_allowed)
		to_chat(src, "<span class='danger'>OOC is globally muted.</span>")
		return
	if(!GLOB.dooc_allowed && (mob.stat == DEAD))
		to_chat(usr, "<span class='danger'>OOC for dead mobs has been turned off.</span>")
		return
	if(prefs.muted & MUTE_OOC)
		to_chat(src, "<span class='danger'>You cannot use LOOC or OOC (muted).</span>")
		return
	if(jobban_isbanned(src.mob, "OOC"))
		to_chat(src, "<span class='danger'>You have been banned from LOOC & OOC.</span>")
		return
	log_talk(mob,"[key_name(src)] : [message]",LOGOOC)
	message = emoji_parse(message)
	to_chat(src, "<font color='#3a9696'><b>(LOOC)</b>: <b>[mob]</b> ([ckey]):[message]</font>")
	for(var/mob/MM in orange(mob, 10))
		to_chat(MM, "<font color='#3a9696'><b>(LOOC)</b>: <b>[mob]</b> ([ckey]):[message]</font>")
	for(var/mob/O in GLOB.dead_mob_list)
		if(!O in orange(mob, 10))
			to_chat(M, "<font color='#3a9696'><b>(LOOC)</b>: <b>[mob]</b> ([ckey]):[message]</font>")

/obj/item/gun/energy/laser/e11 //Sprite credit goes to reddit
	name ="E-11 Blaster pistol"
	icon_state = "ec11"
	desc = "A strangely shaped blaster from a superior universe."
	ammo_x_offset = 3
	fire_sound = 'StarTrek13/sound/borg/machines/laz2.ogg'
	selfcharge = TRUE

/obj/item/clothing/under/wars
	name = "Navy officer uniform"
	icon_state = "SWofficer"

/obj/item/clothing/under/wars/admiral
	name = "Navy admiral uniform"
	icon_state = "SWadmiral"

/obj/item/clothing/head/wars
	name = "Navy cap"
	desc = "Worn by high ranking officers in the imperial navy"
	icon_state = "SWofficer"
	var/obj/item/clothing/neck/combadge/wars/radio

/obj/item/clothing/head/wars/Initialize()
	. = ..()
	radio = new /obj/item/clothing/neck/combadge/wars(src)
	radio.forceMove(src)

/obj/item/clothing/head/wars/attackby(obj/I, mob/user)
	. = ..()
	if(radio)
		radio.attackby(I, user)

/obj/item/clothing/suit/armor/wars
	name = "neopolymer armour"
	desc = "A suit of semi-flexible polycarbonate body armor. For the glory of the empire!"
	icon_state = "SWtrooper"
	item_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list("melee" = 10, "bullet" = 10, "laser" = 20, "energy" = 10, "bomb" = 10, "bio" = 100, "rad" = 80, "fire" = 80, "acid" = 80)
	strip_delay = 80
	equip_delay_other = 60

/obj/item/clothing/suit/armor/wars/scout
	name = "light-neopolymer armour"
	desc = "A suit of very-flexible polycarbonate body armor. For the glory of the empire!"
	icon_state = "SWscout"
	item_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list("melee" = 10, "bullet" = 10, "laser" = 20, "energy" = 10, "bomb" = 10, "bio" = 100, "rad" = 80, "fire" = 80, "acid" = 80)
	strip_delay = 80
	equip_delay_other = 60

/obj/item/clothing/head/helmet/wars
	name = "neopolymer helmet"
	desc = "A strange white helmet that looks very sad. It has an inbuilt radio"
	icon_state = "SWtrooper"
	item_state = "helmet"
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 100, "rad" = 80, "fire" = 50, "acid" = 50)
	var/obj/item/clothing/neck/combadge/wars/radio

/obj/item/clothing/head/helmet/wars/attackby(obj/I, mob/user)
	. = ..()
	if(radio)
		radio.attackby(I, user)

/obj/item/clothing/head/helmet/wars/Initialize()
	. = ..()
	radio = new /obj/item/clothing/neck/combadge/wars(src)
	radio.forceMove(src)

/obj/item/clothing/head/helmet/wars/CtrlClick(mob/user)
	radio.CtrlClick(user)

/obj/item/clothing/head/helmet/wars/AltClick(mob/user)
	radio.AltClick(user)

/obj/item/clothing/head/helmet/wars/scout
	name = "scouting helmet"
	desc = "A strange white helmet with inbuilt binocular attachment holes, but they contain no binoculars...damn cheapskates. It has an inbuilt radio"
	icon_state = "SWscout"

/mob/verb/get_overmap()
	set name = "Get ship/overmap object"
	set desc = "Teleport an overmap object to you (ships, stations, planets etc.)"
	set category = "Admin"
	if(!check_rights(R_ADMIN, TRUE)) //We may want to change this to R_VAREDIT when we launch but for now I'd quite like mentors to have this too.
		return
	var/A
	A = input("Teleport which ship?", "Admin tools", A) as null|anything in overmap_objects
	if(!A)
		return
	var/obj/structure/overmap/O = A
	O.forceMove(get_turf(src))
	log_admin("([worldtime2text()]):[src] / [client.ckey] teleported [O] to themselves")