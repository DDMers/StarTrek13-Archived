#define MODE_ASSIMILATE 1
#define MODE_ATTACK 2

/obj/item/borg_tool
	name = "borg tool"
	desc = "a huge arm based prosthesis, click it to change mode. Alt click it in build mode for different buildable objects and control click it in buildmode to select what structure you wish to build."
	item_state = "borgtool"
	icon_state = "borgtool"
	resistance_flags = UNACIDABLE
	var/mode = 1 //can assimilate or build mode
	var/convert_time = 50 //5 seconds
	flags_1 = NODROP_1
	force = 18 //hella strong
	var/removing_airlock = FALSE
	var/dismantling_machine = 0
	var/blacklistedmachines = list(/obj/machinery/computer/communications, /obj/machinery/computer/card)
	var/saved_time
	var/cooldown = 10


/obj/item/borg_tool/New()
	. = ..()

/obj/item/ammo_casing/energy/disabler/borg
	projectile_type = /obj/item/projectile/beam/disabler/borg
	fire_sound = 'StarTrek13/sound/borg/machines/laz2.ogg'

/obj/item/projectile/beam/disabler/borg
	icon_state = "borglaser"

	//1 is assim, 2 build, 3 attack, 4 shoot

/obj/item/borg_tool/cyborg //fucking run NOW
	flags_1 = null //not nodrop or that will break borg invs

/obj/item/borg_tool/attack_self(mob/user, params)
	user << sound('StarTrek13/sound/borg/machines/mode.ogg')
	switch(mode)
		if(MODE_ASSIMILATE)
			mode = MODE_ATTACK
			to_chat(user,"<span class='warning'>[src] is now set to <b>RANGED</b> mode.</span>")
			force = 18
		if(MODE_ATTACK)
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
						if(do_after(user, 50, target = M)) //5 seconds
							var/obj/item/organ/borgNanites/biglongtube = new(M)
							biglongtube.Insert(M)
							M.skin_tone = "albino"
							M.update_body()
							to_chat(M, "<span class='warning'>You don't feel very good. You should probably find a doctor.</span>")
							return
			else if(istype(I, /turf/open))
				var/turf/open/A = I
				to_chat(user, "<span class='danger'>We are assimilating [I].</span>")
				if(do_after(user, convert_time, target = A))
					A.ChangeTurf(/turf/open/floor/borg)
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
							A.ChangeTurf(/turf/closed/wall/borg)
			else if(istype(I, /obj/machinery/door/airlock) && !istype(I, /obj/machinery/door/airlock/borg))
				var/obj/machinery/door/airlock/G = I
				to_chat(user,"We are assimilating [I]")
				playsound(src.loc, 'StarTrek13/sound/borg/machines/convertmachine.ogg', 40, 4)
				if(do_after(user, 100, target = G)) //twice as long to convert a door
					new /obj/machinery/door/airlock/borg(G.loc)
					qdel(G)
	if(mode == MODE_ATTACK) //ranged mode
		if(istype(I, /obj/machinery/door/airlock) && !removing_airlock)
			tear_airlock(I, user)
			return
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
	else
		. = ..()

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

/obj/item/organ/borgNanites
	name = "Nanite mesh"
	desc = "A metallic lattice of nanobots which seem to be constantly constructing metallic rods"

/obj/item/organ/borgNanites/process()
	if(!(src in owner.internal_organs))
		Remove(owner)
		owner = null
		return

/obj/item/organ/borgNanites/New()
	. = ..()
	to_chat(owner, "You can feel shifting inside your [zone]")
	addtimer(CALLBACK(src, .proc/borgify), 1500) //2 and a half minutes to get the eggs out before you fully turn

/obj/item/organ/borgNanites/proc/borgify()
	to_chat(owner, "We are the borg, you have been adapted to service us. Your life for the collective")
	owner.mind.make_Borg()