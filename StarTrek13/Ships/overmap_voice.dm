/obj/structure/fluff/helm/desk/tactical
	var/voiceCooldown = FALSE //did we just say a voice line? avoids spam

/obj/structure/fluff/helm/desk/tactical/proc/resetvoice()
	voiceCooldown = FALSE

/obj/structure/fluff/helm/desk/tactical/proc/voiceline(var/what = "hull")//remove the =="hull" or it won't work, this is for testing!
	if(voiceCooldown)
		return FALSE //Spam begone!
	if(!what)
		return //nothing's been said
	var/sound
	switch(what)
		if("hull")
			var/goal = theship.max_health
			var/progress = theship.health
			progress = CLAMP(progress, 0, goal)
			var/num = round(((progress / goal) * 100), 5)
			switch(num)
				if(90 to 100)
					playsound(loc,'StarTrek13/sound/voice/Hull100.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull100.ogg'
				if(65 to 80)
					playsound(loc,'StarTrek13/sound/voice/Hull75.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull75.ogg'
				if(45 to 60)
					playsound(loc,'StarTrek13/sound/voice/Hull50.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull50.ogg'
				if(30 to 40)
					playsound(loc,'StarTrek13/sound/voice/Hull25.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull25.ogg'
				if(29 to 29)
					playsound(loc,'StarTrek13/sound/voice/Hull20.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull20.ogg'
				if(10 to 19)
					playsound(loc,'StarTrek13/sound/voice/Hull15.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull15.ogg'
				if(3 to 9)
					playsound(loc,'StarTrek13/sound/voice/Hull10.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull10.ogg'
				if(0 to 2)
					playsound(loc,'StarTrek13/sound/voice/Hull05.ogg',100,0)
					sound = 'StarTrek13/sound/voice/Hull05.ogg'
		if("shieldshp")
			var/goal = theship.SC.shields.max_health
			var/progress = theship.SC.shields.health
			progress = CLAMP(progress, 0, goal)
			var/num = round(((progress / goal) * 100), 10)
			switch(num)
				if(90 to 100)
					if(prob(50))
						playsound(loc,'StarTrek13/sound/voice/shields100.ogg',100,0)
						sound = 'StarTrek13/sound/voice/shields100.ogg'
				if(40 to 60)
					playsound(loc,'StarTrek13/sound/voice/shields50.ogg',100,0)
					sound = 'StarTrek13/sound/voice/shields50.ogg'
				if(5 to 39)
					playsound(loc,'StarTrek13/sound/voice/MultipleShieldsOffline.ogg',100,0)
					sound = 'StarTrek13/sound/voice/MultipleShieldsOffline.ogg'
				if(0 to 5)
					if(prob(50))
						playsound(loc,'StarTrek13/sound/voice/ShieldsFailed.ogg',100,0)
						sound = 'StarTrek13/sound/voice/ShieldsFailed.ogg'
		if("shieldsinteg")
			if(theship.SC.shields.integrity)
				playsound(loc,'StarTrek13/sound/voice/shields100.ogg',100,0)
				sound = 'StarTrek13/sound/voice/shields100.ogg'
			else
				playsound(loc,'StarTrek13/sound/voice/ShieldsDisabled.ogg',100,0)
				sound = 'StarTrek13/sound/voice/ShieldsDisabled.ogg'
		if("photon")
			if(theship.photons)
				playsound(loc,'StarTrek13/sound/voice/LoadingPhoton.ogg',100,0)
				sound = 'StarTrek13/sound/voice/LoadingPhoton.ogg'
			else
				playsound(loc,'StarTrek13/sound/voice/OutOfTorpedoes.ogg',100,0)
				sound = 'StarTrek13/sound/voice/OutOfTorpedoes.ogg'
		if("warpengines")
			if(!theship.SC.engines.integrity)
				playsound(loc,'StarTrek13/sound/voice/WarpDisabled.ogg',100,0)
				sound = 'StarTrek13/sound/voice/WarpDisabled.ogg'
		if("phasers")
			if(!theship.SC.weapons.integrity)
				playsound(loc,'StarTrek13/sound/voice/PhasersDisabled.ogg',100,0)
				sound = 'StarTrek13/sound/voice/PhasersDisabled.ogg'
		if("targetdead")
			playsound(loc,'StarTrek13/sound/voice/targetdestroyed.ogg',100,0)
			sound = 'StarTrek13/sound/voice/targetdestroyed.ogg'
	if(sound)
		SEND_SOUND(theship.pilot, sound)
	voiceCooldown = TRUE
	addtimer(CALLBACK(src, .proc/resetvoice), 20) //small delay to stop spam