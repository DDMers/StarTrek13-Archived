#define MODE_SCAN 1
#define MODE_BUILD 2

/obj/item/ship_repair_tool
	name = "Portable replicator"
	desc = "A groundbreaking new device which allows you to conduct rapid repairs on ships, click it in hand to change mode. You can change its battery cell by unscrewing it."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "shiprepair"
	var/saved_dir = 1 //What dir was the wall / floor facing in?
	var/saved_icon_state = "nothing" //And does it need a new skin applying?
	var/saved_icon
	var/saved_type = null
	var/obj/item/stock_parts/cell/battery //Replicators take power you know.
	var/mode = MODE_SCAN
	var/maint_open = FALSE //Unscrewed it?
	var/power_cost = 300 //On a normal battery, only a 3 turfs per charge. The battery will self charge and can be upgraded by science to make it less cancer.
	w_class = 1

/obj/item/ship_repair_tool/Initialize()
	. = ..()
	battery = new /obj/item/stock_parts/cell(src)
	battery.self_recharge = TRUE

/obj/item/ship_repair_tool/attack_self(mob/user)
	switch(mode)
		if(MODE_SCAN)
			to_chat(user, "You set [src] to build mode")
			mode = MODE_BUILD
		if(MODE_BUILD)
			to_chat(user, "You set [src] to scan mode")
			mode = MODE_SCAN

/obj/item/ship_repair_tool/afterattack(atom/I, mob/living/user, proximity)
	if(!proximity)
		return
	if(istype(I, /turf) && !istype(I, /turf/closed/indestructible)) //No cutting through stuff you're not meant to.
		switch(mode)
			if(MODE_SCAN)
				new /obj/effect/temp_visual/swarmer/dismantle(get_turf(I))
				to_chat(user, "Sucessfully scanned [I]!")
				playsound(loc, 'StarTrek13/sound/borg/machines/alertbuzz.ogg', 40,1)
				saved_icon_state = I.icon_state
				saved_dir = I.dir
				saved_icon = I.icon
				saved_type = I.type
				return ..()
			if(MODE_BUILD)
				if(saved_type && battery.charge > power_cost)
					battery.charge -= power_cost
					if(do_after(user, 50, target = I)) //5 seconds
						var/turf/TT = I
						playsound(loc, 'StarTrek13/sound/trek/ds9_replicator.ogg', 100,1)
						new /obj/effect/temp_visual/swarmer/disintegration(get_turf(I))
						TT.ChangeTurf(saved_type)
						I.icon = saved_icon
						I.icon_state = saved_icon_state
						I.dir = saved_dir
						to_chat(user, "Replication successful")
						return ..()
				else
					to_chat(user, "A red light blinks on [src]. Did you scan a turf into it? or is the battery dead?")
					return

/obj/item/ship_repair_tool/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/screwdriver))
		to_chat(user, "You [maint_open?"close":"open"] [src]'s access port.")
		maint_open = !maint_open
	if(istype(I, /obj/item/stock_parts/cell) && maint_open)
		if(battery)
			battery.forceMove(user.loc)
			battery.self_recharge = FALSE
			battery = null
		to_chat(user, "You swap out [src]'s battery")
		I.forceMove(src)
		battery = I
		battery.self_recharge = TRUE
		return


/obj/item/ship_repair_tool/examine(mob/user)
	. = ..()
	to_chat(user, "--It has two modes, SCAN and BUILD")
	to_chat(user, "--SCAN mode lets you clone any wall or floor that you click on.")
	to_chat(user, "--BUILD mode constructs a new wall / floor identical to the one you scanned. The original turf you choose must be in-tact when you clone it so pick a wall that isn't blown up!")
	to_chat(user, "---Its internal fuel cell reads [battery.charge] / [battery.maxcharge].---")

#undef MODE_SCAN
#undef MODE_BUILD