/obj/structure/chair/borg/charging
	name = "recharging alcove"
	desc = "We must recharge to regain"
	icon_state = "borgcharger"
	icon = 'StarTrek13/icons/borg/chairs.dmi'
	anchored = 1
	can_buckle = 1
	can_be_unanchored = 0
	max_buckled_mobs = 1
	resistance_flags = FIRE_PROOF
	buildstacktype = null
	item_chair = null // if null it can't be picked up
	var/cooldown2 = 110 //music loop cooldowns
	var/saved_time2 = 0
	var/sound = 'StarTrek13/sound/borg/machines/alcove.ogg'
	var/mob/living/carbon/human/user
	var/charge_time = 0
	var/charge_amount = 10 //10 per tick, with a max charge storage of 1000

/obj/structure/chair/borg/charging/New()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/chair/borg/charging/process()
	if(user)
		user.adjustBruteLoss(-3)
		user.adjustFireLoss(-3)
		user.adjustOxyLoss(-3)
		if(user.nutrition <= NUTRITION_LEVEL_HUNGRY)
			user.nutrition = NUTRITION_LEVEL_WELL_FED
			to_chat(user, "Caloric deficiency detected! - Replenishing energy stores.")
		if(user.stat == DEAD)
			user.updatehealth() // Previous "adjust" procs don't update health, so we do it manually.
			user.set_heartattack(FALSE)
			user.revive()
			user.adjustBruteLoss(-20) //give them a real kick so they do actually revive
			user.adjustFireLoss(-20)
			user.adjustOxyLoss(-20)

	if(world.time >= saved_time2 + cooldown2)
		saved_time2 = world.time
		playsound(src,sound,20,0)
	else
		return

/obj/structure/chair/borg/charging/user_buckle_mob(mob/living/M, mob/User)
	if(ishuman(M) && M.loc == loc)
		var/mob/living/carbon/human/H = M
		if(H in SSfaction.borg_hivemind.borgs)
			user = H
			to_chat(H, "<span class='warning'>Establishing connection...</span>")
			to_chat(H, "<span class='warning'>Success!</span>")
			to_chat(H, "<span class='warning'>Connection established with [src]</span>")
			. = ..()
	//		to_chat(H, "<span class='warning'>Estimated regeneration cycle time: [get_chargetime()]</span>") finish this later
			user = H
		else
			src.visible_message("<span class='warning'>[M] cannot be recharged as they are not borg.</span>")
			unbuckle_mob(M)
			return 0
	else
		src.visible_message("<span class='warning'>[M] cannot be recharged.</span>")
		unbuckle_mob(M)
		return 0

/obj/structure/chair/borg/charging/proc/get_chargetime() //how long to charge, then?
	return
//	for(var/obj/item/organ/borgNanites/B in user)
//		var/obj/item/organ/borgNanites/N = B
//	var/current = N.current_charge
//	var/goal = N.max_charge
//	var/time = goal-current
//	var/amount = time / charge_amount
//	current = CLAMP(current, 0, goal)
//	icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"


/obj/structure/chair/borg/charging/user_unbuckle_mob(mob/h, mob/User)
	to_chat(h, "We have been disconnected from [src]")
	user = null
	return ..()