
///////////////////////////////////
//Xel / borg airlocks            //
////////////////////////////////// kmc is cool

/obj/machinery/door/airlock/borg
	name = "assimilated airlock"
	icon = 'StarTrek13/icons/trek/door_borg.dmi'
	overlays_file = 'StarTrek13/icons/trek/door_borg.dmi' //no overlays :^)
	hackProof = 1
	aiControlDisabled = 1
	var/friendly = FALSE

/obj/machinery/door/airlock/borg/friendly
	friendly = TRUE

/obj/machinery/door/airlock/borg/allowed(mob/M)
	var/datum/mind/meme = M.mind
	if(!density)
		return 1
	if(meme in SSticker.mode.hivemind.borgs)
		return 1
	else
		to_chat(M, "The door does not respond to you...")
		return 0

//structures!
/obj/structure/chair/borg
	name = "borgified chair"
	desc = "Assimilated chair"
	icon_state = "borg1"
	icon = 'StarTrek13/icons/borg/chairs.dmi'
	anchored = TRUE

/obj/structure/chair/borg/attackby(obj/I,mob/user,proximity, params)
	. = ..()
	if(proximity)
		if(istype(I, /obj/item/wrench))
			to_chat(user, "<b>You begin to tear down [src] with your [I]</b>")
			if(do_after(user, 100))
				playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
				qdel(src)
				return

	else
		return

/obj/structure/chair/borg/conversion
	name = "assimilation bench"
	desc = "Looking at this thing sends chills down your spine, good thing you're not being put on it..right?</span>"
	icon_state = "borg_off"
	anchored = 1
	can_buckle = 1
	can_be_unanchored = 0
	max_buckled_mobs = 1
	buildstacktype = null
	item_chair = null // if null it can't be picked up
	var/restrained = 0 //can they unbuckle easily?

/obj/structure/chair/borg/conversion/proc/check_elegibility(mob/living/carbon/human/H)
	if(isborg(H))
		src.visible_message("<span class='warning'>Error: [H] Is already a drone.</span>")
		return FALSE
	for(var/obj/item/organ/I in H.internal_organs)
		if(istype(I, /obj/item/organ/body_egg/borgNanites) && !isborg(H))
			return TRUE
	if(!istype(H))
		return FALSE

/obj/structure/chair/borg/conversion/user_buckle_mob(mob/living/M, mob/user)
	. = ..()
	if(check_elegibility(M) && loc == M.loc)
		to_chat(M, "<span class='warning'>You feel an immense wave of dread wash over you as [user] begins to strap you into [src]</span>")
		to_chat(user, "<span class='warning'>We begin to prepare [M] for assimilation into the collective.</span>")
		var/mob/living/carbon/human/H = M
		if(do_after(user, 100, target = H))
			M.unequip_everything()
			restrained = 1
			icon_state = "borg_off"
			M.do_jitter_animation(50)
			src.visible_message("<span class='warning'>[M] looks terrified as they lay on the [src]!</span>")
			sleep(60)
			to_chat(M, "<span class='warning'>You feel several sharp stings as the [src] cuts into you!</span>")
			sleep(10)
			to_chat(M, "<span class='warning'>OH GOD, THE AGONY!</span>")
			playsound(loc, 'StarTrek13/sound/borg/machines/convert_table.ogg', 50, 1, -1)
			src.visible_message("<span class='warning'>[M] screams in agony as the [src] forces grotesque metal parts onto their grey flesh!</span>")
			playsound(loc, 'sound/effects/megascream.ogg', 50, 1, -1) //https://youtu.be/5QvgLlFyeok?t=1m48s
			icon_state = "borg_on"
			var/image/armoverlay = image('StarTrek13/icons/borg/chairs.dmi')
			armoverlay.icon_state = "borg_arms"
			armoverlay.layer = ABOVE_MOB_LAYER
			overlays += armoverlay
			var/image/armoroverlay = image('StarTrek13/icons/borg/chairs.dmi')
			armoroverlay.icon_state = "borgarmour"
			armoroverlay.layer = ABOVE_MOB_LAYER
			overlays += armoroverlay
			sleep(40)
			playsound(loc, 'StarTrek13/sound/borg/machines/convert_table2.ogg', 50, 1, -1)
			sleep(20)
			if(M.client)
				var/datum/mind/borg_mind = M.mind
				borg_mind.make_xel()
			overlays -= armoverlay
			overlays -= armoroverlay
			icon_state = "borg_off"
			to_chat(M, "<span class='warning'>We feel like one as the straps binding us to the [src] release. Our new designation is [M.name].</span>")
			restrained = 0
	else //error meme
		src.visible_message("<span class='warning'>[M] is not ready to be augmented.</span>")
		restrained = 0

/obj/structure/chair/borg/conversion/user_unbuckle_mob(mob/living/buckled_mob/M)
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			if(restrained)
				return
			else
				unbuckle_mob(m)



/obj/structure/chair/borg/charging
	name = "recharging alcove"
	desc = "It hums with familiar sounds, a friend to the Xel."
	icon_state = "borgcharger"
	anchored = 1
	can_buckle = 1
	can_be_unanchored = 0
	max_buckled_mobs = 1
	resistance_flags = FIRE_PROOF
	buildstacktype = null
	item_chair = null // if null it can't be picked up
	var/cooldown = 12
	var/saved_time = 0
	var/cooldown2 = 120 //music loop cooldowns
	var/saved_time2 = 0
	var/valid = 0
	var/sound = 'StarTrek13/sound/borg/machines/alcove.ogg'

/obj/structure/chair/borg/charging/New()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/chair/borg/charging/process()
	if(valid)
		if(world.time >= saved_time + cooldown)
			saved_time = world.time
			if(has_buckled_mobs())
				for(var/A in buckled_mobs)
					if(ishuman(A))
						var/mob/living/carbon/human/H = A
						H.adjustBruteLoss(-3)
						H.adjustFireLoss(-3)
					if(world.time >= saved_time2 + cooldown2)
						saved_time2 = world.time
						A << sound(sound)
		else
			return

/obj/structure/chair/borg/charging/user_buckle_mob(mob/living/M, mob/user)
	. = ..()
	if(ishuman(M) && M.loc == loc)
		var/mob/living/carbon/human/H = M
		if(isborg(H))
			valid = 1
			to_chat(H, "<span class='warning'>We plug into [src] and feel a soothing current wash over us as our wounds are knitted up by our nanobots.</span>")
		else
			src.visible_message("<span class='warning'>[M] cannot be recharged as they are not Xel.</span>")
			unbuckle_mob(M)
			return

	else
		src.visible_message("<span class='warning'>[M] cannot be recharged.</span>")
		unbuckle_mob(M)
		return


/obj/machinery/borg
	name = "massive xel thing"
	desc = "woa"
	icon = 'StarTrek13/icons/borg/borg.dmi'
	icon_state = "proto"
	anchored = 1
	density = 1
	can_be_unanchored = 0
	var/alreadyonehere = 0
	var/parts = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 2,
							/obj/item/stock_parts/borg/dilithium = 1)

/obj/machinery/borg/ftl
	name = "assimilated stellar drive"
	desc = "The green structure looms over you as it hums with a low purr. It carries ships far and wide, and in this case has been assimilated by the Xel."
	icon_state = "ftl"
	anchored = 1
	pixel_x = -32
	layer = 4.5
	parts = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 1,
							/obj/item/stock_parts/borg = 3)


/obj/structure/fluff/helm/desk/tactical/borg
	name = "xel cube helm control"
	desc = "Symbols flash on its holographic display as it constantly flickers and hums."
	icon = 'StarTrek13/icons/borg/borg.dmi'
	icon_state = "navicomp"
	pixel_x = -32
	bound_width = 96
	layer = 4.5

/obj/machinery/borg/converter
	name = "conversion device"
	desc = "The final stage of the assimilation process of the borg. May god have mercy on your crew."
	icon_state = "converter"
	bound_width = 96
	layer = 5.5
	var/running
	var/required_points = 100 // Different converters require different ammounts of recources to function.

/obj/machinery/borg/converter/update_icon()
	if(running)
		icon_state = "converter_active"
	else
		icon_state = "converter"

/obj/machinery/borg/converter/attack_hand(mob/living/carbon/human/user)
	if(running)
		to_chat(user, "<span class='userdanger'> The device is already running!</span>")
	if(!isborg(user))
		to_chat(user, "<span class='warning'>You don't know how to use this.. Yet.</span>")
		return
	var/area = get_area(src)
	for(var/obj/structure/fluff/helm/desk/tactical/T in area)
		if(T.theship.assimilated)
			to_chat(user, "<span class='warning'>This ship has already been assimilated!</span>")
			return
		if(SSticker.mode.hivemind.cons_points < required_points)
			to_chat(user, "<span_class='warning'>We do not have enough material to assimilate this ship. Asimilate more floors and walls.</span>")
			return
		SSticker.mode.hivemind.cons_points -= 80
		to_chat(user, "<span class='notice'>We begin to initiate assimilation protocols for the [T.theship.name].</span>")
		if(!do_after(user, 150, target = src))
			return
		SSticker.mode.hivemind.message_collective("We have begun assimilation protocols onboard the [T.theship.name].")
		var/surviving_humans
		for(var/mob/living/carbon/human/H in area)
			if(isliving(H))
				if(!isborg(H))
					++surviving_humans
					to_chat(world, "<big>Surviving human found! Non-borg humans: [surviving_humans].</big>")
		var/timer = 600 * surviving_humans + 600 // A minute for every living human in the ship, with the default minute..
		icon_state = "converter_active"
		to_chat(world, "<big>icon updated!</big>")
		if(!process_timer(timer))
			SSticker.mode.hivemind.message_collective("We have failed to assimilate the [T.theship.name].")
			running = FALSE
			icon_state = "converter"
			return
		running = FALSE
		icon_state = "converter"
		if(T.theship.assimilate())
			SSticker.mode.hivemind.message_collective("We have successfully assimilated the [T.theship.name].")
		else
			SSticker.mode.hivemind.message_collective("We have failed to assimilate the [T.theship.name].")

/obj/machinery/borg/proc/process_timer(var/delay)//Shameless copy of do_after, this is for attempting to assimilate the ship.
	if(!src)
		return FALSE
	var/endtime = world.time + delay
	while(world.time < endtime)
		sleep(1)
		//input failure requirements here.
	return TRUE



/*

/obj/machinery/borg/throne
	name = "queen's throne"
	desc = "A massive structure fit for a queen"
	icon_state = "throne"
	anchored = 1
//	pixel_x = -32
	bound_width = 96
	layer = 4.5
	var/obj/machinery/computer/camera_advanced/borg/computer = null
	can_buckle = 1
	buckle_lying = 0
	max_buckled_mobs = 1
	parts = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 3,
							/obj/item/stock_parts/borg = 5)

/obj/machinery/borg/throne/user_unbuckle_mob(mob/living/buckled_mob/M)
	. = ..()
	for(var/m in buckled_mobs)
		var/mob/living/carbon/human/borgqueen/P = m
		unbuckle_mob(m)
		icon_state = "throne"
		P.alpha = 255

/obj/machinery/borg/throne/user_buckle_mob(mob/living/carbon/human/borgqueen/M, mob/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human/borgqueen))
		return
	if(!isborg(M))
		return
	var/mob/living/carbon/human/borgqueen/P = M
	P.alpha = 0 //:^)
	icon_state = "queenboltin"
	sleep(20)
	icon_state = "thronequeen"
	buckle_mob(P)
//	P.computer.attack_hand(user)



/obj/machinery/borg/throne/New()
	. = ..()
	var/area/A = get_area(src)
	if(SSticker.mode.borg_machines_room_has_throne == 0)
		if(istype(A, SSticker.mode.borg_target_area))
			computer = new(src) //obj/machinery/computer/camera_advanced/borg(src)
			SSticker.mode.borg_machines_room_has_throne = 1
		//	src.say(SSticker.mode.borg_machines_in_area)
		else
			src.say("not in the right area")
	else
		src.say("there is already one of those here")
		qdel(src)

/obj/machinery/borg/throne/Destroy()
	. = ..()
	if(!alreadyonehere)
		SSticker.mode.borg_machines_room_has_throne = 0 //when you delete it, if there is already one, means that you cant make infinite ones.

//camera stuff, testing!

*/

/obj/machinery/computer/camera_advanced/borg/throne //:^)
	name = "queen's throne"
	desc = "A massive structure fit for a queen"
	icon_state = "throne"
	icon = 'StarTrek13/icons/borg/borg.dmi'
	icon_screen = null
	icon_keyboard = null
	anchored = 1
//	pixel_x = -32
	bound_width = 96
	layer = 4.5
	can_buckle = 1
	buckle_lying = 0
	var/alreadyonehere = 0
	max_buckled_mobs = 1
	/*
	parts = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 3,
							/obj/item/stock_parts/borg = 5) */

/*
/obj/machinery/computer/camera_advanced/borg/throne/attack_hand(mob/living/carbon/human/borgqueen/M, mob/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human/borgqueen))
		return
	if(!isborg(M))
		return
	var/mob/living/carbon/human/borgqueen/P = M
	P.alpha = 0 //:^)
	icon_state = "queenboltin"
	sleep(20)
	icon_state = "thronequeen"
	buckle_mob(P)
//	P.computer.attack_hand(user)
*/ //shitcode, fix
/*
/obj/machinery/computer/camera_advanced/borg/throne/New()
	. = ..()
	if(var/obj/machinery/computer/camera_advances/borg/throne/T in world)
		audible_message(src, "<span class='warning'><b>ERROR; A THRONE CURRENTLY EXISTS AT [T.get_area]</b></span>")
		qdel(src)
*/
/obj/item/stock_parts/borg
	name = "gravimetric interspatial manifold field manipulator"
	desc = "oh, it's a gravimetric field interspatial manifold used to regenerate transphasic presequenced waves, DUH!"
	icon_state = "borg_mani"


/obj/item/stock_parts/borg/capacitor
	name = "transphasic autonomous regeneration sequencer"
	desc = "oh, it's an Intramolecular processor manifold used to harmonize interspacial transwarp waves, what else would it be?"
	icon_state = "borg_capacitor"

/obj/item/stock_parts/borg/bin
	name = "central plexonomic sequencer conduit"
	desc = "oh, it's mass storage device for gravimetric field waves converging around its hypercapacitation EPS matrix, what do you think it does?"
	icon_state = "borg_gravitron"

/obj/item/stock_parts/borg/dilithium
	name = "dilithium convergence module"
	desc = "oh, it's a big fucking lump of dilithium, what else would it be?"
	icon_state = "dilithium"

/obj/item/circuitboard/machine/borg/FTL
	name = "assimilated circuit-board (ftl drive)"
	build_path = /obj/machinery/borg/ftl
	req_components = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 2,
							/obj/item/stock_parts/borg/dilithium = 1)
/*
/obj/item/circuitboard/machine/borg/navicomp
	name = "assimilated circuit-board (navigational computer)"
	build_path = /obj/structure/fluff/helm/desk/tactical/borg
	req_components = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 1,
							/obj/item/stock_parts/borg = 3)
*/
/obj/item/circuitboard/machine/borg/throne
	name = "assimilated circuit-board (queen throne)"
	build_path = /obj/machinery/computer/camera_advanced/borg/throne
	req_components = list(
							/obj/item/stock_parts/borg/bin = 2,
							/obj/item/stock_parts/borg/capacitor = 1,
							/obj/item/stock_parts/borg = 3)

