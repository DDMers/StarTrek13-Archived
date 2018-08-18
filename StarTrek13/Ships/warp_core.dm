/* Get ready for some high level nerd shit y'all

WHAT IS WARP?
Distorting space, measured in cochranes, more distortion = faster

Warp Factor 1 = 1 cochrane
Warp Factor 2 = 10 cochranes
Warp Factor 3 = 39 cochranes
Warp Factor 4:102 cochranes
Warp Factor 5 214 cochranes
Warp Factor 6 392 cochranes
Warp Factor 7 656 cochranes
Warp Factor 8:1024 cochranes
Warp Factor 9 1516 cochranes

1 mj = 0.277777778 KW, ss13 PNs operate in KW
1 cochrane takes 200 MJ to maintain

http://www.unitconversion.org/energy/megajoules-to-kilowatt-hours-conversion.html

Matter tank, deuterium
Antimatter tank, if this is ever fucked with it'll explode

1 matter unit + 1 antimatter unit = 100 MJ of energy

*/
#define WARP_1 1
#define WARP_2 10
#define WARP_3 39
#define WARP_4 102
#define WARP_5 214
#define WARP_6 392
#define WARP_7 656
#define WARP_8 1024
#define WARP_9 1516
#define WARP_10 2000 //This is translated to warp 9.99996 instead, because warp 10 is impossible

/obj/machinery/power/warpcore
	name = "warp core"
	desc = "It hums lowly, it runs on dilithium"
	icon = 'StarTrek13/icons/borg/borg.dmi'
	icon_state = "warp"
	anchored = TRUE
	density = 1
	opacity = 0 //I AM LOUD REEE WATCH OUT
	layer = 4.5
	var/ambience = 'StarTrek13/sound/trek/engines/engine.ogg'
	var/cooldown2 = 116 //11 second cooldown
	var/saved_time = 0
	var/datum/looping_sound/trek/engine_hum/soundloop
	var/obj/item/dilithium_crystal/crystal
	var/obj/machinery/atmospherics/components/binary/pump/outlet
	var/matter = 150 //give the engis a little time to set everything up before all power dies
	var/antimatter = 150
	var/anihilation_rate = 0 //how powerful is this reaction ? (matter : antimatter balance)
	var/containment = 100 //How strong is the containment field? only way to fix this is replacing the isolinear chips inside it
	var/breaching = FALSE //Is the core about to die?
	var/max_antimatter = 5000 //You'll need to refuel very, very rarely. Unless engi suck and want warp 10 INSTANTLY
	var/max_matter = 5000
	var/obj/structure/overmap/ship
	var/WF = "impulse" //Text representation of our maximum warp.
	var/power = 0
	var/stored_cochranes = 0
	var/obj/structure/overmap/theship

/obj/machinery/power/warpcore/massive
	name = "high powered warp core"
	desc = "This massive machine will propel your starship to unheard of speeds."
	icon = 'StarTrek13/icons/trek/warp_core_huge.dmi'
	icon_state = "warpcore"

/obj/machinery/power/warpcore/smaller
	icon_state = "warpcore_smaller"
	icon = 'StarTrek13/icons/trek/warp_core_huge.dmi'
	pixel_x = 16


/obj/item/dilithium_crystal/crystal
	name = "Dilithium Crystal"
	desc = "A huge chunk of crystal which serves as a balancing agent in warp reactions, it's been the basis of interstellar travel for centuries."
	icon = 'StarTrek13/icons/trek/engineering.dmi'
	icon_state = "dilithium"

/obj/machinery/power/warpcore/proc/Start() //Once started, you can't stop it without draining it out first.
	if(!outlet)
		say("<span class='warning'>ERROR: No outlet found, please attach a standard atmospherics pump to the left of the warp core, one tile above it.</span>")
	if(!powernet)
		connect_to_network()
	START_PROCESSING(SSmachines,src)

/obj/machinery/power/warpcore/examine(mob/user)
	. = ..()
	to_chat(user, "It has [matter] units of deuterium reacting against [antimatter] units of antideuterium")
	to_chat(user, "The current maximum warp of this ship is [WF]")

/obj/machinery/power/warpcore/process()
	if(!outlet)
		CheckPipes()
	get_warp_factor()
	var/obj/structure/warp_storage/WS = locate(/obj/structure/warp_storage) in(get_area(src))
	if(WS.matter)
		WS.matter -= WS.flow_rate
		matter += WS.flow_rate
	var/obj/structure/antimatter_storage/AS = locate(/obj/structure/antimatter_storage) in(get_area(src))
	if(AS.antimatter)
		AS.antimatter -= AS.flow_rate
		antimatter += AS.flow_rate
	if(containment < 10)
		breach()
	if(crystal) //The crystal balances the matter stream with the antimatter stream, if you don't have the crystal, the reaction becomes inert over time.
		if(matter && antimatter)
			antimatter -= 0.5 //Antimatter is rare you know?
			matter --
			power = 150000000
			add_avail(power)
			for(var/datum/gas_mixture/S in outlet.airs)
				S.temperature += 500
	else
		if(matter && antimatter) //In other words, the reaction is still going
			antimatter --
			matter --
			if(prob(20))
				playsound(loc, 'StarTrek13/sound/borg/machines/alert1.ogg', 50, 2)
				var/datum/effect_system/smoke_spread/freezing/smoke = new
				smoke.set_up(2, loc)
				smoke.start()
				visible_message("Antimatter | Matter stream reaction unregulated! Warp core containment failing!")
			containment --
	if(matter && antimatter)
		if(!soundloop) //Only runs sounds when it's active.
			soundloop = new(list(src), TRUE)
		if(world.time >= saved_time + cooldown2)
			saved_time = world.time
			var/mob/MM = locate(/mob) in(get_area(src))  //this may break stuff
			SEND_SOUND(MM, ambience)
	else
		qdel(soundloop)

/obj/machinery/power/warpcore/proc/get_warp_factor()
	var/cochranes = 0
	if(!theship)
		var/obj/structure/fluff/helm/desk/tactical/AA = locate(/obj/structure/helm/desk/tactical) in get_area(src)
		theship = AA.theship
	for(var/obj/machinery/power/warp_coil/WC in get_area(src))
		cochranes += WC.cochranes
	if(ship)
		if(cochranes < WARP_1)
			WF = "sublight travel"
			ship.max_warp = 1
		if(cochranes >WARP_1)
			WF = "warp 1"
			ship.max_warp = 3
		if(cochranes >WARP_2)
			WF = "warp 2"
			ship.max_warp = 5
		if(cochranes >WARP_3)
			WF = "warp 3"
			ship.max_warp = 7
		if(cochranes >WARP_4)
			WF = "warp 4"
			ship.max_warp = 9
		if(cochranes >WARP_5)
			WF = "warp 5"
			ship.max_warp = 11
		if(cochranes >WARP_6)
			WF = "warp 6"
			ship.max_warp = 13
		if(cochranes >WARP_7)
			WF = "warp 7"
			ship.max_warp = 20
		if(cochranes >WARP_8)
			WF = "warp 8"
			ship.max_warp = 30
		if(cochranes >WARP_9)
			WF = "warp 9"
			ship.max_warp = 35
		if(cochranes >WARP_10)
			WF = "warp 9.999999999996"
			ship.max_warp = 37 //REALLY hard to do

/obj/structure/warp_storage
	name = "Deuterium storage tank"
	desc = "A large tank which stores the raw deuterium that the warp core uses"
	icon = 'StarTrek13/icons/trek/engineering.dmi'
	icon_state = "matter"
	var/matter = 5000 //You'll need to refuel every now and then with highly toxic deuterium cells.
	var/max_matter = 5000
	var/flow_rate = 0 //Transfer it how fast?

/obj/structure/warp_storage/examine(mob/user)
	. = ..()
	to_chat(user, "It has [matter] L  stored, with a max of [max_matter]")

/obj/structure/warp_storage/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/wrench))
		to_chat(user, "You start to tweak [src]'s flow controls...")
		if(I.use_tool(src, user, 40, volume=100))
			var/t = input(user,"Set fuel transfer rate", "Deuterium Storage Tank") as num
			if(t) //No negative numbers!
				flow_rate = t

/obj/structure/antimatter_storage
	name = "Anti-Deuterium storage tank"
	desc = "A huge magnetically confined vessel which holds the ship's antimatter stores, its survival is key. The highly volatile antimatter it holds must be controlled."
	icon = 'StarTrek13/icons/trek/engineering.dmi'
	icon_state = "antimatter"
	var/antimatter = 5000 //You'll need to refuel every now and then with highly toxic deuterium cells.
	var/max_antimatter = 5000
	var/flow_rate = 0 //Transfer it how fast?

/obj/structure/antimatter_storage/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/wrench))
		to_chat(user, "You start to tweak [src]'s flow controls...")
		if(I.use_tool(src, user, 40, volume=100))
			var/t = input(user,"Set fuel transfer rate", "Anti-Deuterium Storage Tank") as num
			if(t) //No negative numbers!
				flow_rate = t

/obj/structure/antimatter_storage/examine(mob/user)
	. = ..()
	to_chat(user, "It has [antimatter] L  stored, with a max of [max_antimatter]")

/obj/machinery/power/warpcore/proc/breach()
	if(!breaching)
		breaching = TRUE
		visible_message("<span class='userdanger'>Antimatter containment failing! Evacuate engineering immediately</span>")
		for(var/mob/M in get_area(src))
			M << 'StarTrek13/sound/trek/corebreach.ogg'
			to_chat(M, "<span class='userdanger'>Warp core breach imminent!</span>")
		if(!ship.wrecked)
			ship.destroy()

/obj/machinery/power/warpcore/proc/CheckPipes() //In case your pipes blow up
	outlet = locate(/obj/machinery/atmospherics/components/binary/pump) in get_step(src, NORTH)
	if(outlet)
		say("Success: Outlet pump registered as [outlet].")
		return TRUE
	else
		return FALSE

/obj/machinery/power/warpcore/Initialize(timeofday)
	. = ..()
	crystal = new(src)
	CheckPipes()

/obj/machinery/power/warp_coil
	name = "warp coil"
	desc = "A huge tungsten based ring which, when provided with high energy warp plasma, will produce a subspace distortion field rated to a maximum of 300 cochranes, you shouldn't get too close when it's active."
	var/cochranes = 0
	var/max_cochranes = 300
	icon = 'StarTrek13/icons/trek/engineering.dmi'
	icon_state = "warpcoil"
	var/spoolup_rate = 10 //How quickly does it charge up? Answer: Slowly.
	var/heat = 0
	var/heatloss = 500 //scale this to cochranes. Fear of loss always leads to the darkside...
	var/active = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	can_be_unanchored = TRUE

/obj/machinery/power/warp_coil/attackby(obj/item/W, mob/user) //replace this with a tool!
	if(istype(W, /obj/item/screwdriver))
		to_chat(user, "You begin unscrewing the access hatch on [src]")
		if(W.use_tool(src, user, 40, volume=100))
			var/t = input(user,"Set maximum subspace distortion threshold (max: 300)", "Warp Coil") as num
			if(t <= 300) //This allows you to limit the maximum warp of the ship and save an assload of power if you plan to have the coils constantly idling.
				max_cochranes = t

/obj/machinery/power/warp_coil/attack_hand(mob/user)
	switch(active)
		if(TRUE)
			to_chat(user, "You de-activate [src]")
			active = FALSE
		if(FALSE)
			to_chat(user, "You activate [src]")
			active = TRUE

/obj/machinery/power/warp_coil/examine(mob/user)
	. = ..()
	to_chat(user, "It's producing a subspace distortion field of [cochranes] cochranes, and is rated at a max distortion level of [max_cochranes] cochranes.")

/obj/machinery/power/warp_coil/Initialize()
	. = ..()
	START_PROCESSING(SSmachines,src)

/obj/machinery/power/warp_coil/process() //So our plasma provides the energy for the cochranes, then these beauties sap it all out for warp energy
	if(active && powered())
		use_power(use_power)
		CheckOutput()
		cochranes += heat / 1000
		use_power = cochranes * 5506 //Remember, 200 MJ to maintain just 1(!) cochrane
		if(cochranes > max_cochranes)
			cochranes = max_cochranes
	else
		icon_state = initial(icon_state)
		cochranes = 0
		use_power = 0

/obj/machinery/power/warp_coil/proc/CheckOutput()
	if(cochranes < max_cochranes)
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/air = T.return_air()
		if(air.temperature > 500) //It needs to be HOT
			icon_state = "warpcoil-hot"
			heat += air.temperature

/datum/looping_sound/trek/engine_hum
	start_sound = null
	start_length = 0
	mid_sounds = list('StarTrek13/sound/trek/engineloop.ogg'=1)
	mid_length = 140
	end_sound = null
	volume = 70

/datum/looping_sound/trek/bridge
	start_sound = null
	start_length = 0
	mid_sounds = list('StarTrek13/sound/borg/machines/tng_bridge_2.ogg'=1)
	mid_length = 163
	end_sound = null
	volume = 150

/datum/looping_sound/trek/warp
	start_sound = null
	start_length = 0
	mid_sounds = list('StarTrek13/sound/borg/machines/engihum.ogg'=1)
	mid_length = 115
	end_sound = null
	volume = 115

/obj/machinery/power/warpcore/Initialize(timeofday)
	. = ..()