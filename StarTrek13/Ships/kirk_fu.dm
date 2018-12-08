///stolen from a cool PR i saw guppy make :b1:///

/mob/living/carbon/human/proc/grant_kirkfu()
	var/art = pick("Flip","Block","Punch","Headbutt","Grab","Disarm")
	switch(art)
		if("Block")
			var/datum/martial_art/kirkfu/blocker/martialart = new
			martialart.teach(src)
			martialart.themind = mind
			addtimer(CALLBACK(martialart, /datum/martial_art/kirkfu.proc/explain, src), 3)
		if("Punch")
			var/datum/martial_art/kirkfu/puncher/martialart = new
			martialart.teach(src)
			martialart.themind = mind
			addtimer(CALLBACK(martialart, /datum/martial_art/kirkfu.proc/explain, src), 3)
		if("Headbutt")
			var/datum/martial_art/kirkfu/headbutter/martialart = new
			martialart.teach(src)
			martialart.themind = mind
			addtimer(CALLBACK(martialart, /datum/martial_art/kirkfu.proc/explain, src), 3)
		if("Grab")
			var/datum/martial_art/kirkfu/grabber/martialart = new
			martialart.teach(src)
			martialart.themind = mind
			addtimer(CALLBACK(martialart, /datum/martial_art/kirkfu.proc/explain, src), 3)
		if("Disarm")
			var/datum/martial_art/kirkfu/disarmer/martialart = new
			martialart.teach(src)
			martialart.themind = mind
			addtimer(CALLBACK(martialart, /datum/martial_art/kirkfu.proc/explain, src), 3)
		if("Flip")
			var/datum/martial_art/kirkfu/flipper/martialart = new
			martialart.teach(src)
			martialart.themind = mind
			addtimer(CALLBACK(martialart, /datum/martial_art/kirkfu.proc/explain, src), 3)

/mob/living/carbon/human/verb/recall_kirkfu()
	set name = "recall kirkfu"
	set desc = "Recalls the ancient teachings of captain kirk's famous martial arts."
	set category = "IC"
	if(!mind)
		return
	if(mind.martial_art || istype(mind.martial_art, /datum/martial_art/kirkfu))
		var/datum/martial_art/kirkfu/KF = mind.martial_art
		if(KF)
			KF.explain(src)
	else
		return

/datum/martial_art
	var/constant_block = 0 // CONSTANT block chance, rather than requiring to have thrown mode on

/mob/living/carbon/human/check_block()  // i dont wanna make a whole new fucking file just for this
	if(mind)
		if(mind.martial_art && prob(mind.martial_art.constant_block) && mind.martial_art.can_use(src) && !incapacitated(FALSE, TRUE))
			return TRUE
	..()

/datum/martial_art/kirkfu/
 	name = "Kirk Fu"
 	constant_block = 5
 	var/desc = ""
 	var/datum/mind/themind

/datum/martial_art/kirkfu/New()
	. = ..()

/datum/martial_art/kirkfu/proc/explain(mob/living/M)
	to_chat(M, "<span class='warning'>You have received elite training in CQC, as a consequence [desc]</span>")

/datum/martial_art/kirkfu/flipper
	name = "Dropkick"
	desc = "You've mastered the kirk dropkick technique, and will use it at random when punching people"

/datum/martial_art/kirkfu/flipper/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(prob(30))
		A.emote("flip")
		A.emote("spin")
		A.visible_message("<span class = 'danger'><B>[A] hops in the air and rams his legs into [D]!</B></span>")
		playsound(A.loc, "swing_hit", 50, 1)
		D.apply_damage(15, BRUTE)
		D.Knockdown(35) //3.5 ms stun, because why not
		A.Knockdown(15) //1.5 ms stun, because kirk always falls overa fter doing this
		return TRUE
	..()

/datum/martial_art/kirkfu/blocker
	name = "Block Affinity"
	constant_block = 25
	desc = "You are much better at blocking attacks than the rank and file."

/datum/martial_art/kirkfu/puncher
	name = "Gorn punch"
	desc = "You are able to deliver a heavy blow to your opponents."

/datum/martial_art/kirkfu/puncher/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(prob(50))
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='danger'>[A] sucker punches [D]!</span>", \
				  "<span class='userdanger'>[A] sucker punches you!</span>")     // hoping for more punch names or whatever, but no idea for now
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 40, 1, -1)
		D.apply_damage(rand(10,15), BRUTE)
		if(prob(20))
			D.Stun(20) //minimal stun
		return TRUE
	..()

/datum/martial_art/kirkfu/headbutter
	name = "Double fisted back blow"
	desc = "You can slam both your fists into someone's spine to send them flying! Aim at their chest on harm intent."

/datum/martial_art/kirkfu/headbutter/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(prob(50) && A.zone_selected == BODY_ZONE_CHEST)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='danger'>[A] slams both their fists into [D]'s back!</span>", \
				  "<span class='userdanger'>[A] slams both their fists into your back!</span>")
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 40, 1, -1)
		var/throwtarget = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
		A.emote("spin")
		D.throw_at(throwtarget, 1, 2, A)
		D.apply_damage(12, BRUTE, BODY_ZONE_CHEST)
		D.Knockdown(rand(5,30))
		return TRUE
	..()

/datum/martial_art/kirkfu/grabber
	name = "Vulcan nerve grip"
	desc = "You can attempt a vulcan nerve pinch, aim for the head and grab to attempt this difficult manouvre"
	var/success_rate = 10

/datum/martial_art/kirkfu/grabber/super
	name = "Vulcan nerve pinch"
	desc = "You've learned the Vulcan nerve grip technique by having spent decades practicing."
	success_rate = 100

/datum/martial_art/kirkfu/grabber/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A.grab_state >= GRAB_AGGRESSIVE)  // this isnt stolen from sleeping carp code, i dont know what you're talking about
		D.grabbedby(A, 1)
	else
		A.start_pulling(D, 1)
		if(A.pulling)
			D.drop_all_held_items()
			D.stop_pulling()
			if(A.a_intent == INTENT_GRAB)
				D.visible_message("<span class='warning'>[A] grips [D]'s shoulder!</span>", \
				  "<span class='userdanger'>[A] pinches your shoulder!</span>")
				D.apply_damage(5, BRUTE, BODY_ZONE_HEAD)
				if(prob(success_rate)) //Kirk was never any good at this one..
					D.Knockdown(rand(5,30))
					D.SetSleeping(100)
				else
					D.visible_message("<span class='warning'>[D] counters [A]'s vulcan nerve pinch!</span>", \
				 	 "<span class='userdanger'>You counter [A]'s nerve pinch!</span>")
					A.grab_state = GRAB_PASSIVE
			else
				A.grab_state = GRAB_PASSIVE
	return TRUE

/datum/martial_art/kirkfu/disarmer
	name = "One two chop"
	desc = "You can do a karate chop! then another one! grabbing the enemy's weapon by clicking someone on disarm intent."

/datum/martial_art/kirkfu/disarmer/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(prob(50))
		var/obj/item/I = D.get_active_held_item()
		if(I)
			if(D.temporarilyRemoveItemFromInventory(I))
				A.put_in_hands(I)
		D.visible_message("<span class='danger'>[A] karate chops [D] in the stomach!</span>", \
						"<span class='userdanger'>[A] has karate chopped [D] in the stomach!</span>")
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 40, 1, -1)
		playsound(D, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.visible_message("<span class='danger'>[A] karate chops [D] in the stomach!</span>", \
						"<span class='userdanger'>[A] has karate chopped [D] in the stomach!</span>")
		D.apply_damage(7, BRUTE, BODY_ZONE_CHEST)
	else
		D.visible_message("<span class='danger'>[A] attempted to karate chop [D]!</span>", \
							"<span class='userdanger'>[A] attempted to karate chop [D]!</span>")
		playsound(D, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	return TRUE