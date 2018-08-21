/obj/structure/fluff/helm/desk/tactical
	var/voiceCooldown = FALSE //did we just say a voice line? avoids spam

/obj/structure/fluff/helm/desk/tactical/proc/voiceline(var/what = "hull")//remove the =="hull" or it won't work, this is for testing!
	var/mob/living/speaker //who's going to be saying the voice line?
	for(var/mob/living/carbon/human/M in orange(src, 7))
		if(M.mind)
			if(M.mind.assigned_role == "captain" || M.mind.assigned_role == "admiral") //Don't want these guys sir-ing themselves
				continue
		if(M.gender == "male") //male voice lines coming from women characters = WEIRD
			speaker = M
			break
	if(!what)
		return //nothing's been said
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
				if(75 to 80)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull75.ogg',100,0)
					speaker.say("Hull integrity at 75%")
				if(50 to 74)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull50.ogg',100,0)
					speaker.say("Hull integrity at 50%")
				if(25 to 49)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull25.ogg',100,0)
					speaker.say("Hull integrity at 25%")
				if(20 to 24)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull20.ogg',100,0)
					speaker.say("Microfractures are starting to form in the hull!")
				if(15 to 19)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull15.ogg',100,0)
					speaker.say("We have a breach! force-fields in place and holding")
				if(10 to 15)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull10.ogg',100,0)
					speaker.say("Captain! we have hull breaches on multiple decks!")
				if(0 to 5)
					playsound(speaker.loc,'StarTrek13/sound/voice/Hull05.ogg',100,0)
					speaker.say("Our hull is severely damaged, sir.")
		if("shieldshp")
			var/goal = theship.SC.shields.max_health
			var/progress = theship.SC.shields.health
			progress = CLAMP(progress, 0, goal)
			var/num = round(((progress / goal) * 100), 10)
			switch(num)
				if(51 to 100)
					playsound(speaker.loc,'StarTrek13/sound/voice/shields100.ogg',100,0)
					speaker.say("Shields are at 100%")
				if(20 to 50)
					playsound(speaker.loc,'StarTrek13/sound/voice/shields50.ogg',100,0)
					speaker.say("Our shields are buckling sir")
				if(10 to 19)
					playsound(speaker.loc,'StarTrek13/sound/voice/MultipleShieldsOffline.ogg',100,0)
					speaker.say("Multiple shields are offline!")
				if(0 to 1)
					playsound(speaker.loc,'StarTrek13/sound/voice/ShieldsFailed.ogg',100,0)
					speaker.say("Our shields have failed!")
		if("shields")
			if(!theship.SC.shields.failed)
				playsound(speaker.loc,'StarTrek13/sound/voice/shields100.ogg',100,0)
				speaker.say("Shields are at 100%")
			else
				playsound(speaker.loc,'StarTrek13/sound/voice/ShieldsDisabled.ogg',100,0)
				speaker.say("Captain our shield system has been disabled.")
		if("photon")
			if(theship.photons)
				playsound(speaker.loc,'StarTrek13/sound/voice/LoadingPhoton.ogg',100,0)
				speaker.say("Switching to photon torpedoes captain.")
			else
				playsound(speaker.loc,'StarTrek13/sound/voice/OutOfTorpedoes.ogg',100,0)
				speaker.say("We're out of torpedoes captain.")
		if("warpengines")
			if(theship.SC.engines.failed)
				playsound(speaker.loc,'StarTrek13/sound/voice/WarpDisabled.ogg',100,0)
				speaker.say("Captain, they've disabled our warp engines.")
		if("phasers")
			if(theship.SC.weapons.failed)
				playsound(speaker.loc,'StarTrek13/sound/voice/PhasersDisabled.ogg',100,0)
				speaker.say("Our phaser system has been disabled.")
	sleep(20) //cooldown to stop megaspam