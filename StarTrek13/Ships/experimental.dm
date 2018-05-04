/*
	These are simple defaults for your project.
 */

/obj/structure/overmap
	animate_movement = 0 //set it
	pixel_z = -128
	pixel_w = -120
	appearance_flags = PIXEL_SCALE //to make sprite look smooth when rotating... sorta
	var/angle = 0 //the angle
	var/vel = 5 //the velocity
	/*
	The part below is no longer useless
	*/
	proc/EditAngle()
		var/matrix/M = matrix() //create matrix
		M.Turn(-angle) //reverse angle
		src.transform = M //set matrix

	proc/ProcessMove()
		EditAngle() //we need to edit the transform just incase

		var/x_speed = 5 * cos(angle)
		var/y_speed = 5 * sin(angle)

		PixelMove(x_speed,y_speed)

/obj/structure/overmap/enter(mob/user)
	if(user.client)
		if(pilot)
			to_chat(user, "you kick [pilot] off the ship controls!")
		//	M.revive(full_heal = 1)
			exit()
			return 0
		initial_loc = user.loc
		user.loc = src
		pilot = user
		pilot.overmap_ship = src
		GrantActions()
		pilot.throw_alert("Weapon charge", /obj/screen/alert/charge)
		pilot.throw_alert("Hull integrity", /obj/screen/alert/charge/hull)
		pilot.whatimControllingOMFG = src
		pilot.client.pixelXYshit()

/obj/structure/overmap/exit(mob/user)
	if(pilot.client)
		pilot.clear_alert("Weapon charge", /obj/screen/alert/charge)
		pilot.clear_alert("Hull integrity", /obj/screen/alert/charge/hull)
		RemoveActions()
		stop_firing() //to stop the firing indicators staying with the pilot
		to_chat(pilot,"you have stopped controlling [src]")
		pilot.forceMove(initial_loc)
		initial_loc = null
	//	pilot.status_flags -= GODMODE
		pilot.overmap_ship = null
		pilot = null
		pilot.whatimControllingOMFG = null
		pilot.client.pixelXYshit()

mob
	var/obj/structure/overmap/whatimControllingOMFG = null
	animate_movement = 2 //just to have the mob have smooth movement, I guess
	var/nextmove = 0

client
	perspective = EYE_PERSPECTIVE //Use this perspective or else shit will break! (sometimes screen will turn black)
	proc/pixelXYshit()
		if(mob.whatimControllingOMFG)
			pixel_x = mob.whatimControllingOMFG.pixel_x
			pixel_y = mob.whatimControllingOMFG.pixel_y
			eye = mob.whatimControllingOMFG
		else
			pixel_x = 0
			pixel_y = 0
			eye = mob

	North() //dont use what I did here, make a verb or some thing and add that to macros, or do a istype and check for the stuff being controlled
		if(mob.whatimControllingOMFG)
			mob.whatimControllingOMFG.vel = 5
			mob.whatimControllingOMFG.ProcessMove()
			pixelXYshit()
		else
			..()
	South()
		if(mob.whatimControllingOMFG)
			mob.whatimControllingOMFG.vel = -5
			mob.whatimControllingOMFG.ProcessMove()
			pixelXYshit()
		else
			..()
	East()
		if(mob.whatimControllingOMFG)
			mob.whatimControllingOMFG.angle = mob.whatimControllingOMFG.angle - 5
			mob.whatimControllingOMFG.EditAngle()
		else
			..()
	West()
		if(mob.whatimControllingOMFG)
			mob.whatimControllingOMFG.angle = mob.whatimControllingOMFG.angle + 5
			mob.whatimControllingOMFG.EditAngle()
		else
			..()

atom/movable
	var
		real_pixel_x = 0 //variables for the real pixel_x
		real_pixel_y = 0 //variables for shit
	proc
		PixelMove(var/x_to_move,var/y_to_move) //FOR THIS TO LOOK SMOOTH, ANIMATE_MOVEMENT needs to be 0!
			real_pixel_x = real_pixel_x + x_to_move
			real_pixel_y = real_pixel_y + y_to_move
			while(real_pixel_x > 32) //Modulo doesn't work with this kind of stuff, don't know if there's a better method.
				real_pixel_x = real_pixel_x - 32
				x = x + 1
			while(real_pixel_x < -32)
				real_pixel_x = real_pixel_x + 32
				x = x - 1
			while(real_pixel_y > 32) //Modulo doesn't work with this kind of stuff, don't know if there's a better method.
				real_pixel_y = real_pixel_y - 32
				y = y + 1
			while(real_pixel_y < -32)
				real_pixel_y = real_pixel_y + 32
				y = y - 1
			pixel_x = real_pixel_x
			pixel_y = real_pixel_y