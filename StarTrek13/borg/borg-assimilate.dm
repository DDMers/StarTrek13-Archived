#define MODE_ASSIMILATE 1
#define MODE_ATTACK 2
#define MODE_BUILD 3

/mob/living/carbon/human/proc/make_borg()
	var/obj/item/organ/borgNanites/biglongtube = new
	biglongtube.Insert(src)
	skin_tone = "albino"
	to_chat(src, "<span_class='warning'>We have been assimilated! We should find a conversion suite to augment ourselves. All other drones are to be obeyed, all past lives and memories are forgotten.</span>")
	if(!(src in SSfaction.borg_hivemind.borgs))
		SSfaction.borg_hivemind.borgs += src //They're in the collective, but need the conversion table for all their upgrades like the tool etc.
	dna.species.species_traits |= TRAIT_NOCLONE
	dna.species.species_traits |= TRAIT_CLUMSY
	dna.species.species_traits |= TRAIT_NOHUNGER
	dna.species.species_traits |= TRAIT_NOGUNS
	dna.species.species_traits |= TRAIT_NOBREATH
	dna.species.species_traits |= TRAIT_RESISTCOLD
	mind.special_role = "Borg-Drone" //Placing this last so that it only runtimes after completion, so you can convert AFK mobs
	eye_color = "red"
	underwear = "Nude"
	undershirt = "Nude"
	socks = "Nude"
	hair_style = "Bald"
	update_body()
	//	meme //change me



/mob/living/carbon/human/proc/remove_borg()
	if(src in SSfaction.borg_hivemind.borgs)
		SSfaction.borg_hivemind.borgs -= src
	dna.species.species_traits -= TRAIT_NOCLONE
	dna.species.species_traits -= TRAIT_CLUMSY
	dna.species.species_traits -= TRAIT_NOHUNGER
	dna.species.species_traits -= TRAIT_NOGUNS
	dna.species.species_traits -= TRAIT_NOBREATH
	dna.species.species_traits -= TRAIT_RESISTCOLD
	unequip_everything()
	mind.special_role = null


/obj/item/borg_tool
	name = "borg tool"
	desc = "a huge arm based prosthesis, click it to change mode. Alt click it in build mode for different buildable objects and control click it in buildmode to select what structure you wish to build."
	item_state = "borgtool"
	icon_state = "borgtool"
	resistance_flags = UNACIDABLE
	var/mode = 1 //can assimilate or build mode
	var/convert_time = 50 //5 seconds
	item_flags = NODROP
	force = 18 //hella strong
	var/removing_airlock = FALSE
	var/dismantling_machine = 0
	var/blacklistedmachines = list(/obj/machinery/computer/communications, /obj/machinery/computer/card)
	var/saved_time
	var/cooldown = 10
	var/resource_amount = 10 //Starts with a bit so you can build a structure from the get-go
	var/resource_cost = 10
	var/building = FALSE //We building summ't? if so stop trying to break things and spam it


/obj/item/borg_tool/attackby(obj/item/stack/I, mob/user)
	if(istype(I, /obj/item/stack))
		resource_amount += I.amount
		to_chat(user, "We have inserted [I] into our [src], its current resource count is: [resource_amount]")
		qdel(I)

/obj/item/borg_tool/proc/build_on_turf(turf/open/T, mob/user)
	if(!building)
		var/obj/structure/CP = locate() in T
		var/obj/machinery/CA = locate() in T
		if(CP || CA)
			user << "<span class='danger'>[T] already has a structure on it.</span>"
			return
		var/mode = input("Borg construction.", "Build what?")in list("conversion suite", "borg alcove","cancel")
		var/obj/structure/chair/borg/suite
		switch(mode)
			if("conversion suite")
				suite = /obj/structure/chair/borg/conversion
			if("borg alcove")
				suite = /obj/structure/chair/borg/charging
			if("cancel")
				return
		if(resource_amount >= resource_cost)
			building = TRUE //stop spamming
			to_chat(user, "<span class='danger'>We are building a structure ontop of [T].</span>")
			if(do_after(user, convert_time, target = T)) //doesnt get past here
				new suite(get_turf(T))
				building = FALSE
				to_chat(user, "We have built a [suite]")
				resource_amount -= resource_cost
				return
			building = FALSE //Catch
		else
			to_chat(user, "Our borg tool does not have enough stored material, it has [resource_amount], but it needs [resource_cost] to build a structure")

/obj/item/borg_tool/New()
	. = ..()

/obj/item/ammo_casing/energy/disabler/borg
	projectile_type = /obj/item/projectile/beam/disabler/borg
	fire_sound = 'StarTrek13/sound/borg/machines/laz2.ogg'

/obj/item/projectile/beam/disabler/borg
	icon_state = "borglaser"

	//1 is assim, 2 build, 3 attack, 4 shoot

/obj/item/borg_tool/cyborg //fucking run NOW
	flags = null //not nodrop or that will break borg invs

/obj/item/borg_tool/attack_self(mob/user, params)
	user << sound('StarTrek13/sound/borg/machines/mode.ogg')
	switch(mode)
		if(MODE_ASSIMILATE)
			mode = MODE_ATTACK
			to_chat(user,"<span class='warning'>[src] is now set to <b>COMBAT</b> mode.</span>")
			force = 18
		if(MODE_ATTACK)
			mode = MODE_BUILD
			to_chat(user, "<span class='warning'>[src] is now set to <b>BUILD</b> mode, it will now build structures.</span>")
			force = 0
		if(MODE_BUILD)
			mode = MODE_ASSIMILATE
			to_chat(user, "<span class='warning'>[src] is now set to <b>ASSIMILATE</b> mode, it will convert people and structures.</span>")
			force = 0

/obj/item/borg_tool/afterattack(atom/I, mob/living/user, proximity)
	if(proximity)
		if(mode == MODE_ASSIMILATE) //assimilate
			if(ishuman(I))
				var/mob/living/carbon/human/M = I
				if(user == M)
					to_chat(user, "<span class='warning'>There is no use in assimilating ourselves.</span>")
					return
				else
					if(M in SSfaction.borg_hivemind.borgs)
						to_chat(user, "<span class='warning'>They are already in the collective.</span>")
						return
					else //Not a borg already, so convert them.
						to_chat(M, "<span class='warning'>[user] pierces you with two long probosces!</span>")
						playsound(I.loc, 'sound/effects/megascream.ogg', 50, 1, -1)
						if(do_after(user, 50, target = M)) //5 seconds
							var/obj/item/organ/borgNanites/biglongtube = new(M)
							biglongtube.Insert(M)
							M.skin_tone = "albino"
							M.update_body()
							M.make_borg()
							return
			else if(istype(I, /turf/open))
				if(!istype(I, /turf/open/floor/borg))
					var/turf/open/A = I
					to_chat(user, "<span class='danger'>We are assimilating [I].</span>")
					if(do_after(user, convert_time, target = A))
						A.ChangeTurf(/turf/open/floor/borg)
						resource_amount += 5
			else if(istype(I, /turf/closed/wall))
				if(!istype(I, /turf/closed/indestructible))
					if(istype(I, /turf/closed/wall/borg)) //convert wall to door
						playsound(src.loc, 'StarTrek13/sound/borg/machines/convertx.ogg', 40, 4)
						to_chat(user,"<span class='danger'>We are making an opening in [I].</span>")
						var/turf/closed/wall/A = I
						if(do_after(user, 100, target = A))
							A.ChangeTurf(/turf/open/floor/borg)
							var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock/borg( A )
							T.electronics = new/obj/item/electronics/airlock( src.loc )
							to_chat(user,"We have made an opening in the wall")
					else
						playsound(src.loc, 'StarTrek13/sound/borg/machines/convertx.ogg', 40, 4)
						to_chat(user, "<span class='danger'>We are assimilating [I].</span>")
						var/turf/closed/wall/A = I
						if(do_after(user, convert_time, target = A))
							var/storedd = A.dir //for directional walls
							A.ChangeTurf(/turf/closed/wall/borg)
							A.dir = storedd
							resource_amount += 5
			else if(istype(I, /obj/machinery/door/airlock) && !istype(I, /obj/machinery/door/airlock/borg))
				var/obj/machinery/door/airlock/G = I
				to_chat(user,"We are assimilating [I]")
				playsound(src.loc, 'StarTrek13/sound/borg/machines/convertmachine.ogg', 40, 4)
				if(do_after(user, 100, target = G)) //twice as long to convert a door
					new /obj/machinery/door/airlock/borg(G.loc)
					qdel(G)
					resource_amount += 5
		if(mode == MODE_ATTACK) //ranged mode
			if(istype(I, /obj/machinery/door/airlock) && !removing_airlock)
				tear_airlock(I, user)
				return
			else if(istype(I, /mob/living/carbon/human))
				if(world.time >= saved_time + cooldown)
					saved_time = world.time
					var/mob/living/carbon/human/target = I
					visible_message("[user] pierces [target] with two huge probosces")
					target.Knockdown(40) //Equivalent to a telebaton
		if(mode == MODE_BUILD)
			if(istype(I, /turf/open))
				var/turf/open/T = I
				build_on_turf(T, user)
				return
	else
		. = ..()

/*
		if(world.time >= saved_time + cooldown)
			var/obj/item/projectile/beam/disabler/borg/A = new
			saved_time = world.time
			A.starting = loc
			A.preparePixelProjectile(I,user)
			A.fire()
			playsound(src,'StarTrek13/sound/borg/machines/borg_phaser_clean.ogg',20,1) //Change me
			return
		else
			to_chat(user,"<span class='danger'>The [src] is not ready to fire again.</span>")
*/

/obj/item/borg_tool/proc/tear_airlock(obj/machinery/door/airlock/A, mob/user)
	removing_airlock = TRUE
	to_chat(user,"<span class='notice'>You start tearing apart the airlock...\
		</span>")
	playsound(src.loc, 'StarTrek13/sound/borg/machines/borgforcedoor.ogg', 100, 4)
	A.audible_message("<span class='italics'>You hear a loud metallic \
		grinding sound.</span>")
	if(do_after(user, delay=80, needhand=FALSE, target=A, progress=TRUE))
		A.audible_message("<span class='danger'>[A] is ripped \
			apart by [user]!</span>")
		qdel(A)
	removing_airlock = FALSE

/obj/item/organ/borgNanites //Remove the organ, sever the collective.
	name = "Hivemind receiver"
	desc = "As borg technology grew, the demands on the host did too, thus this central processor was born, in parts to help manage the drone's implants, as well as allowing it to contact the collective."
	var/charge = 0
	var/max_charge = 1000
	var/augmented = FALSE //Are they a fully fledged, augmented drone?
	var/datum/action/innate/message_collective/message_action = new

/datum/action/innate/message_collective
	name = "Message the collective"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "message_collective"
	var/obj/item/organ/borgNanites/B

/datum/action/innate/message_collective/Activate()
	B.message_collective()

/obj/item/organ/borgNanites/Insert()
	. = ..()
	for(var/obj/item/organ/borgNanites/B in owner)
		if(B.message_action)
			if(B != src)
				var/datum/action/innate/message_collective/M = B.message_action
				M.Remove(B.owner)
				M.target = null
				qdel(B.message_action)
	START_PROCESSING(SSobj, src)
	message_action.B = src
	message_action.Grant(owner)
	message_action.target = owner

/obj/item/organ/borgNanites/proc/message_collective()
	if(!owner)
		return
	var/message = stripped_input(owner,"Communicate with the collective.","Send Message")
	if(!message)
		return
	SSfaction.borg_hivemind.message_collective(message, owner.real_name)

/obj/item/organ/borgNanites/process()
	if(charge >= max_charge)
		charge -= 1
//	switch(charge)
//		if(charge
	if(owner)
		if(!(src in owner.internal_organs))
			to_chat(owner, "We feel our link to the collective weaken...")
			to_chat(owner, "The voices in your head stop, you are no longer a borg, despite the hideous modifications they made to you.")
			message_action.Remove(owner)
			message_action.target = null
			Remove(owner)
			owner = null
			return

/obj/item/organ/borgNanites/proc/receive_message(var/ping)
	to_chat(owner, ping) //Ping is created in message_collective in borg.dm
	return

/obj/item/organ/borgNanites/New()
	. = ..()
	to_chat(owner, "You can feel shifting inside your [zone]")
	to_chat(owner, "<span class='userdanger'>We are the borg. We are a drone. The nanobots in our bloodstream have augmented us to be stronger, but we are not fully ready yet. We require external upgrades, so we should find a drone to augment us at an augmentation table.</span>")
	borgify()


/obj/item/organ/borgNanites/proc/borgify()
	sleep(20) //2second anti runtime delay
	if(owner)
		to_chat(owner, "We are being made into a borg...")
		if(owner.mind)
			owner.mind.make_borg()

/obj/structure/chair/borg/conversion
	name = "assimilation bench"
	desc = "Looking at this thing sends chills down your spine, good thing you're not being put on it..right?</span>"
	icon_state = "borg_off"
	icon = 'StarTrek13/icons/borg/chairs.dmi'
	anchored = 1
	can_buckle = 1
	can_be_unanchored = 0
	max_buckled_mobs = 1
	buildstacktype = null
	item_chair = null // if null it can't be picked up
	var/restrained = 0 //can they unbuckle easily?

/obj/structure/chair/borg/conversion/user_buckle_mob(mob/living/carbon/human/M, mob/user)
	if(M in SSfaction.borg_hivemind.borgs)
		for(var/obj/item/organ/borgNanites/B in M.internal_organs)
			if(!B.augmented)
				. = ..()
				M.unequip_everything()
				icon_state = "borg_off"
				visible_message("parts of [src] start to shift and move")
				to_chat(M, "<span class='warning'>We feel pain.</span>")
				playsound(loc, 'StarTrek13/sound/borg/machines/convert_table.ogg', 50, 1, -1)
				var/image/armoverlay = image('StarTrek13/icons/borg/chairs.dmi')
				armoverlay.icon_state = "borg_arms"
				armoverlay.layer = ABOVE_MOB_LAYER
				overlays += armoverlay
				var/image/armoroverlay = image('StarTrek13/icons/borg/chairs.dmi')
				armoroverlay.icon_state = "borgarmour"
				armoroverlay.layer = ABOVE_MOB_LAYER
				overlays += armoroverlay
				sleep(35)
				playsound(loc, 'StarTrek13/sound/borg/machines/convert_table2.ogg', 50, 1, -1)
				icon_state = "borg_off"
				M.equipOutfit(/datum/outfit/borg, visualsOnly = FALSE) //Outfit handles name etc.
				to_chat(M, "We have been upgraded. Our designation is: [M.name].")
				cut_overlays()
				overlays -= armoverlay
				overlays -= armoroverlay
				qdel(armoroverlay)
				qdel(armoverlay)
			else
				to_chat(user, "They have already been augmented")
				return 0
	else
		to_chat(user, "They are not ready. Assimilate them first.")
		return 0