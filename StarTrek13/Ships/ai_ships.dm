/obj/structure/overmap/ship/ai_controlled
	name = "USS Hal"
	faction = "nanotrasen"


/obj/structure/overmap/ship/ai_controlled/New()
	. = ..()
	pilot = new /mob/living/simple_animal/butterfly(src)


/obj/structure/overmap/ship/ai_controlled/process()
	. = ..()
	src.say("lol")
	var/list/in_range = list()
	for(var/obj/structure/overmap/O in oview())//Thanks byond forums
		in_range += O
		var/obj/structure/overmap/M = pick(in_range)
		//if(M.faction != faction) //Grrr it's an enemy, fire all the weapons.
		if(get_dist(src,M)<=1)
			setDir(get_dir(src,M))
			click_action(M,pilot)
		else
			step_to(src,M)
			break
	sleep(rand(4,8))//So it doesn't murderify you instantly with the spam click fury of a thousand suns.