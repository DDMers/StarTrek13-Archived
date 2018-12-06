/*
Please don't sue me donsley corporation :)
In this mode the nondescript evil empire must cut their way through rebel strongholds whilst also keeping the death orb plans safe whilst the rebel spies try to complete objectives and steal the plans by delivering them to rebel agents on Jedda.
*/
//Stations

#define EMPIRE_WIN = 1
#define REBEL_WIN = 2
#define REBEL_WIN_MAJOR = 3

/obj/structure/overmap/away/station/rebel1
	name = "Crait station"
	health = 50000 //No destroy snek :(
	max_health = 50000

/obj/structure/overmap/planet
	name = "Crait"
	icon = 'StarTrek13/icons/trek/space_objects.dmi'
	icon_state = "4"
	spawn_name = "crait_spawn"
	layer = 2
	can_move = FALSE
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/dqar
	name = "D'qar"
	spawn_name = "dqar_spawn"
	icon_state = "1"
	layer = 2
	can_move = FALSE
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/hoth
	name = "Hoth"
	spawn_name = "hoth_spawn"
	icon_state = "6"
	layer = 2
	can_move = FALSE
	max_health = 1000000000
	health = 1000000000

/obj/structure/overmap/planet/jedda
	name = "Jedha"
	spawn_name = "jedha_spawn"
	icon_state = "3"
	layer = 2
	can_move = FALSE
	max_health = 1000000000
	health = 1000000000

/area/overmap/planet
	name = "Crait"

/area/overmap/planet/dqar
	name = "D'qar"

/area/overmap/planet/hoth
	name = "Hoth"

/area/overmap/planet/jedda
	name = "Jedha"

/area/ship/barnardstar
	name = "Barnard's star outpost"

/area/ship/ds9
	name = "Deep Space 9"

/area/overmap/wars
	name = "Kuat system"

/area/overmap/wars/rebel
	name = "Crait system"

/area/overmap/wars/rebel/penultimate
	name = "D'qar system"

/area/overmap/wars/rebel/final
	name = "Hoth system"

/area/overmap/wars/rebel/jedda
	name = "Jedda system"

/obj/item/death_star_plans
	name = "highly classified plans"
	desc = "They seem to show a massive prototype battlestation similar to that nondescript one you saw that one time over a generic planet, you get the feeling that many bothan spies would die to get their hands on it..."
	icon = 'StarTrek13/icons/wars/wars.dmi'
	icon_state = "deathstarplans"

/datum/objective/deathstarplans
	explanation_text = "Steal the highly classified death star plans and deliver them to our contact, Mustafa Ratoz on Jeddah. Only do this when your other objectives are finished as your other agents may still have business to conduct." //Add this in lol
	martyr_compatible = 1

/datum/game_mode
	var/result

/datum/game_mode/traitor/wars
	name = "rebel spies"
	config_tag = "rebelspies"
	announce_span = "danger"
	announce_text = "An imperial warship has been dispatched to crush the rebel threat once and for all\n\
	<span class='danger'>The empire must clear the rebel bases and capture them to unlock the next.\n\
	<span class='danger'>Keep an eye on your crew..there may be rebel spies aboard."
	faction_participants = list("the empire")
	delaywarp = 2500 //Short bit of prep time to get your shit together
	traitor_name = "rebel spy"


/datum/game_mode/conquest/wars/send_intercept() //Overriding the "security level elevated thing" because we don't really use it :)
	priority_announce("By the order of the galactic empire, all available ships will mount an assault to break rebel supply lines. Eradicate each rebel base and move on to the next, failure will not be tolerated. Your captain has been given a set of documents of the utmost importance: see that these reach their destination safely.")
	to_chat(world,"<span class='warning'>-You cannot advance till you have captured the enemy bases, once captured look for the coordinates of the next base - They will be on a blue console which you need to click.</span>")

/datum/game_mode/traitor/wars/check_win()
	return ..()

/datum/game_mode/traitor/wars/special_report()
	var/feedback = "Stalemate! Nobody won!"
	switch(result)
		if(1)
			feedback = "Empire victory! The death star plans were kept secure and the rebel strongholds were eradicated."
		if(2)
			feedback = "Rebel phyrric victory! The empire destroyed a station before receiving the coordinates of the next one, this will buy them some time but it can't last forever..."
		if(3)
			feedback = "Rebel major victory! The classified plans were stolen and delivered to the contact, a new hope is brewing in the galaxy.."
	return "<div class='panel greenborder'><span class='header'>[feedback]</div>"//TODO add in some extra win conditions for the rebels :)

/obj/effect/landmark/warp_beacon/rebel //Special warp markers for rebel bases, the imperials must cut their way thru each base to unlock the next
	name = "Warp beacon"
	distance = 1000

/obj/effect/landmark/warp_beacon/rebel/penultimate //Specialised
	name = "Warp beacon"
	distance = 3000
	warp_restricted = TRUE

/obj/effect/landmark/warp_beacon/rebel/final //Specialised
	name = "Warp beacon"
	distance = 5000
	warp_restricted = TRUE

/obj/structure/rebel_capture
	name = "Hyperspace registrar"
	desc = "A device which passes restricted hyperspace coordinates on to nearby ships. It is currently locked but you could probably bypass it to find out where the coordinates lead...."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "systemdominator"
	var/beingcaptured = FALSE
	var/hacktime = 200 //20 seconds to capture
	var/obj/structure/overmap/away/station/system_outpost/station
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE


/obj/structure/rebel_capture/Destroy() //Don't do this. If you blow up a station it's a stalemate because you can never find the others!
	SSticker.mode.result = 2
	SSticker.mode.check_finished(TRUE)
	SSticker.force_ending = 1
	SSticker.mode.check_win()

/obj/structure/rebel_capture/penultimate
	name = "Advanced hyperspace registrar"

/obj/structure/rebel_capture/penultimate/pass_coordinates()
	var/obj/effect/landmark/warp_beacon/rebel/final/S = locate(/obj/effect/landmark/warp_beacon/rebel/final) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/structure/rebel_capture/final
	name = "Hyperspace Registrar (final)"

/obj/structure/rebel_capture/final/pass_coordinates()
	SSticker.mode.result = 1
	SSticker.mode.check_win()
	SSticker.mode.check_finished(TRUE)
	SSticker.force_ending = 1

/obj/structure/rebel_capture/CtrlClick(mob/user)
	attack_hand(user)

/obj/structure/rebel_capture/attack_hand(mob/living/carbon/human/user)
	if(!beingcaptured)
		to_chat(user, "You begin bypassing [src]'s security protocols, you should buckle in to a chair to prevent people pushing you.")
		beingcaptured = TRUE
		if(do_after(user,hacktime, target = src))
			to_chat(user, "Hyperspace coordinates transferred to imperial network. Long live the empire!")
			SSticker.mode.check_win()
		beingcaptured = FALSE
		pass_coordinates()
	else
		to_chat(user, "Someone is already attempting a network breach!")
		return

/obj/structure/rebel_capture/proc/pass_coordinates()//Write a new one for each variant, unlocks the next base for the impies to go raid :)
	var/obj/effect/landmark/warp_beacon/rebel/penultimate/S = locate(/obj/effect/landmark/warp_beacon/rebel/penultimate) in GLOB.landmarks_list
	S.warp_restricted = FALSE

/obj/structure/rebel_informant
	name = "Mustafa Ratoz"
	desc = "A slightly shifty looking guy in a cloak, he has a badge saying: not a member of the resistance. He looks like he wants you to give him something, but you can't guess what..."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "informant"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	density = TRUE
	can_be_unanchored = FALSE

/obj/structure/rebel_informant/attackby(obj/item/I, mob/living/M)
	if(istype(I, /obj/item/death_star_plans))
		to_chat(M, "[name] Whispers to you: Thank you, you've done a great thing today, long live the rebellion, brother!")
		var/datum/objective/deathstarplans/S = locate(/datum/objective/deathstarplans) in M.mind.objectives
		if(S)
			S.completed = TRUE
		SSticker.mode.result = 3
		SSticker.mode.check_win()
		SSticker.mode.check_finished(TRUE)
		SSticker.force_ending = 1

	else
		if(prob(50))
			say("Hm? what? stop bothering me")
		else
			say("Can't you see I'm having a drink over here?")
		return

#undef EMPIRE_WIN
#undef REBEL_WIN
#undef REBEL_WIN_MAJOR