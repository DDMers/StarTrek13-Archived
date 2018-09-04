/obj/structure/fluff/helm/desk/tactical
	var/voiceCooldown = FALSE //did we just say a voice line? avoids spam

/obj/structure/fluff/helm/desk/tactical/proc/resetvoice()
	voiceCooldown = FALSE

/obj/structure/fluff/helm/desk/tactical/proc/voiceline(var/what = "hull")//remove the =="hull" or it won't work, this is for testing!
	var/mob/living/speaker //who's going to be saying the voice line?
	if(voiceCooldown)
		return FALSE //Spam begone!
	for(var/mob/living/carbon/human/M in orange(src, 7))
		if(ishuman(M) && M.stat != DEAD)
			if(M.mind)
				if(M.mind.assigned_role == "captain" || M.mind.assigned_role == "admiral") //Don't want these guys sir-ing themselves
					continue
			if(M.gender == "male") //male voice lines coming from women characters = WEIRD
				speaker = M
				break
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
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull100.ogg',100,0)
					speaker.say("Hull integrity at 100%")
					sound = 'StarTrek13/sound/voice/Hull100.ogg'
				if(75 to 80)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull75.ogg',100,0)
					speaker.say("Hull integrity at 75%")
					sound = 'StarTrek13/sound/voice/Hull75.ogg'
				if(50 to 74)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull50.ogg',100,0)
					speaker.say("Hull integrity at 50%")
					sound = 'StarTrek13/sound/voice/Hull50.ogg'
				if(30 to 49)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull25.ogg',100,0)
					speaker.say("Hull integrity at 25%")
					sound = 'StarTrek13/sound/voice/Hull25.ogg'
				if(20 to 29)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull20.ogg',100,0)
					speaker.say("Microfractures are starting to form in the hull!")
					sound = 'StarTrek13/sound/voice/Hull20.ogg'
				if(10 to 19)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull15.ogg',100,0)
					speaker.say("We have a breach! force-fields in place and holding")
					sound = 'StarTrek13/sound/voice/Hull15.ogg'
				if(3 to 9)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull10.ogg',100,0)
					speaker.say("Captain! we have hull breaches on multiple decks!")
					sound = 'StarTrek13/sound/voice/Hull10.ogg'
				if(0 to 2)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull05.ogg',100,0)
					speaker.say("Our hull is severely damaged, sir.")
					sound = 'StarTrek13/sound/voice/Hull05.ogg'
		if("shieldshp")
			var/goal = theship.SC.shields.max_health
			var/progress = theship.SC.shields.health
			progress = CLAMP(progress, 0, goal)
			var/num = round(((progress / goal) * 100), 10)
			switch(num)
				if(90 to 100)
					playsound(speaker.loc,'StarTrek13/sound/voice/shields100.ogg',100,0)
					speaker.say("Shields are at 100%")
					sound = 'StarTrek13/sound/voice/shields100.ogg'
				if(50 to 89)
					playsound(speaker.loc,'StarTrek13/sound/voice/shields50.ogg',100,0)
					speaker.say("Our shields are buckling sir")
					sound = 'StarTrek13/sound/voice/shields50.ogg'
				if(5 to 49)
					playsound(speaker.loc,'StarTrek13/sound/voice/MultipleShieldsOffline.ogg',100,0)
					speaker.say("Multiple shields are offline!")
					sound = 'StarTrek13/sound/voice/MultipleShieldsOffline.ogg'
				if(0 to 5)
					playsound(speaker.loc,'StarTrek13/sound/voice/ShieldsFailed.ogg',100,0)
					speaker.say("Our shields have failed!")
					sound = 'StarTrek13/sound/voice/ShieldsFailed.ogg'
		if("shieldsinteg")
			if(theship.SC.shields.integrity)
				playsound(speaker.loc,'StarTrek13/sound/voice/shields100.ogg',100,0)
				speaker.say("Shields are at 100%")
				sound = 'StarTrek13/sound/voice/shields100.ogg'
			else
				playsound(speaker.loc,'StarTrek13/sound/voice/ShieldsDisabled.ogg',100,0)
				speaker.say("Captain our shield system has been disabled.")
				sound = 'StarTrek13/sound/voice/ShieldsDisabled.ogg'
		if("photon")
			if(theship.photons)
				playsound(speaker.loc,'StarTrek13/sound/voice/LoadingPhoton.ogg',100,0)
				speaker.say("Switching to photon torpedoes captain.")
				sound = 'StarTrek13/sound/voice/LoadingPhoton.ogg'
			else
				playsound(speaker.loc,'StarTrek13/sound/voice/OutOfTorpedoes.ogg',100,0)
				speaker.say("We're out of torpedoes captain.")
				sound = 'StarTrek13/sound/voice/OutOfTorpedoes.ogg'
		if("warpengines")
			if(!theship.SC.engines.integrity)
				playsound(speaker.loc,'StarTrek13/sound/voice/WarpDisabled.ogg',100,0)
				speaker.say("Captain, they've disabled our warp engines.")
				sound = 'StarTrek13/sound/voice/WarpDisabled.ogg'
		if("phasers")
			if(!theship.SC.weapons.integrity)
				playsound(speaker.loc,'StarTrek13/sound/voice/PhasersDisabled.ogg',100,0)
				speaker.say("Our phaser system has been disabled.")
				sound = 'StarTrek13/sound/voice/PhasersDisabled.ogg'
		if("targetdead")
			playsound(speaker.loc,'StarTrek13/sound/voice/targetdestroyed.ogg',100,0)
			speaker.say("Target destroyed.")
			sound = 'StarTrek13/sound/voice/targetdestroyed.ogg'
	if(sound)
		SEND_SOUND(theship.pilot, sound)
	voiceCooldown = TRUE
	addtimer(CALLBACK(src, .proc/resetvoice), 20) //small delay to stop spam