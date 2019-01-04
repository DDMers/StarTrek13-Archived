#define LOW 1
#define MED 2
#define HIGH 3

/turf/open/floor/plating/emergencyspawnunfucker
	name = "Subspace instantaneous body debit device"
	color = "#FFC0CB"
	desc = "This remarkable device debits all the molecules in your body from your current location and credits them somewhere else! Hopefully where you wanted to end up"
	color = "#FFC0CB"
	var/list/whowehaveaskedtobeacrewman = list()
	var/list/helpme = list()

/turf/open/floor/plating/emergencyspawnunfucker/Initialize(mapload)
	START_PROCESSING(SSfastprocess, src) //It hurts so bad

/turf/open/floor/plating/emergencyspawnunfucker/process() //I hate making a turf process..
	rescue()

/turf/open/floor/plating/emergencyspawnunfucker/proc/rescue(mob/living/carbon/human/ohfuckmewhy)
	if(!ohfuckmewhy)
		ohfuckmewhy = locate(/mob/living) in loc
	var/dat
	for(var/datum/job/job in SSjob.occupations)
		if(job && IsJobUnavailable(ohfuckmewhy,job.title, TRUE) == JOB_AVAILABLE)
			dat += "<a href='byond://?src=\ref[src];SelectedJob=\ref[job];clicker=\ref[ohfuckmewhy]'>[job.title] ([job.current_positions])</a><br>"
	if(!ohfuckmewhy)
		return
	helpme += ohfuckmewhy
	to_chat(ohfuckmewhy, "We're moving you to a safe spawn whilst you pick a job, please don't be alarmed.")
	ohfuckmewhy.forceMove(pick(GLOB.prisonwarp))
	sleep(15)
	var/datum/browser/popup = new(ohfuckmewhy, "latechoices", "Choose Profession", 440, 500)
	popup.set_content(dat)
	popup.open(FALSE)


/*
	var/rank = input(ohfuckmewhy, "Select a job", "Job Selection", null) as null|anything in jobslist
	if(!rank)
		to_chat(ohfuckmewhy, "Spawning you in as a [SSjob.overflow_role]")
		SSfaction.TryToHandleJob(ohfuckmewhy)
		ohfuckmewhy.equipOutfit(/datum/outfit/job/crewman)
		return
	SSjob.EquipRank(ohfuckmewhy, rank, TRUE)
	SSfaction.TryToHandleJob(ohfuckmewhy)
	ohfuckmewhy = null
*/

/turf/open/floor/plating/emergencyspawnunfucker/Topic(href, href_list)
	if(href_list["SelectedJob"])
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		var/datum/job/F = locate(href_list["SelectedJob"])
		to_chat(world, "[F.title]")
		if(L in helpme)
			SSjob.EquipRank(L, F.title, TRUE)
			SSfaction.TryToHandleJob(L)
			helpme -= L


/turf/open/floor/plating/emergencyspawnunfucker/proc/IsJobUnavailable(mob/living/player,rank, latejoin = FALSE)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return JOB_UNAVAILABLE_GENERIC
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		if(job.title == "Assistant")
			if(isnum(player.client.player_age) && player.client.player_age <= 14) //Newbies can always be assistants
				return JOB_AVAILABLE
			for(var/datum/job/J in SSjob.occupations)
				if(J && J.current_positions < J.total_positions && J.title != job.title)
					return JOB_UNAVAILABLE_SLOTFULL
		else
			return JOB_UNAVAILABLE_SLOTFULL
	if(jobban_isbanned(player,rank))
		return JOB_UNAVAILABLE_BANNED
	if(QDELETED(player))
		return JOB_UNAVAILABLE_GENERIC
	if(!job.player_old_enough(player.client))
		return JOB_UNAVAILABLE_ACCOUNTAGE
	if(job.required_playtime_remaining(player.client))
		return JOB_UNAVAILABLE_PLAYTIME
	if(latejoin && !job.special_check_latejoin(player.client))
		return JOB_UNAVAILABLE_GENERIC
	return JOB_AVAILABLE

/mob
	var/datum/crew/crew

/datum/crew
	var/name = "crew"
	var/mob/living/carbon/human/captain //All other roles are secondary, but the captain is CRITICAL, as he can fly.
	var/list/crewmen = list() //All the other crewmen go here, if this is full with readied up players then we skip to the next ship, if that's full, switch faction and fill them up
	var/max_crewmen = 10 //10 crew total, more than enough for the sovereign.
	var/priority = LOW //How important is this ship? Romulan ships will be higher priority because nobody plays them.
	var/obj/structure/overmap/theship
	var/list/candidates = list() //People who want to join this crew
	var/faction = "starfleet"
	var/datum/faction/required //What faction is this crew for? if they get autobalanced, then force them to become a member of that faction.
	var/filled = FALSE //Stops it repeatedly filling crews.
	var/count = 0
	var/requiredtype = /datum/faction/starfleet
	var/locked = FALSE //block roundstart joins on this?

/datum/crew/New()
	. = ..()
	if(SSfaction && SSfaction.crews)
		SSfaction.crews += src
	addtimer(CALLBACK(src, .proc/pickthefaction), 200)

/datum/crew/proc/pickthefaction()
	for(var/datum/faction/F in SSfaction.factions)
		if(istype(F, /datum/faction/starfleet))
			required = F

/datum/crew/romulan/pickthefaction() //kinda sucky but hey what you gonna do. Make a snowflake check like this for your crew subtype
	for(var/datum/faction/F in SSfaction.factions)
		if(istype(F, /datum/faction/romulan))
			required = F

/datum/crew/borgship/pickthefaction() //This is shitcode. Fix it.
	for(var/datum/faction/F in SSfaction.factions)
		if(istype(F, /datum/faction/borg))
			required = F

/datum/crew/executor/pickthefaction() //This is shitcode. Fix it.
	for(var/datum/faction/F in SSfaction.factions)
		if(istype(F, /datum/faction/empire))
			required = F

/datum/crew/proc/Add(mob/M)
	candidates += M

/mob/proc/addme()
	var/datum/crew/S = pick(SSfaction.crews)
	S.Add(src)
	S.FillRoles()
	S.SanityCheck()

/datum/crew/proc/addbyforce(mob/living/carbon/I)
	if(I.player_faction || I.client.prefs.player_faction)
		I.player_faction.members -= I
		I.player_faction = required
		I.client.prefs.player_faction = required
	SendToSpawn(I)
	for(var/datum/crew/F in SSfaction.crews) //To stop endless spam like poor tpos got :(
		if(I in F.crewmen)
			F.count --
			F.crewmen -= I
			continue
	if(I in candidates)
		candidates -= I
	count ++
	crewmen += I
	return TRUE


/datum/crew/proc/FillRoles()
	SanityCheck()

/datum/crew/proc/NameCheck(mob/living/M) //starfleet admiral tumok run'aat reporting :thinking:
	if(M.client)
		if(M.client.prefs.romulan_name)
			if(M.name == M.client.prefs.romulan_name)
				M.name = M.client.prefs.real_name
				M.real_name = M.name
				return TRUE
	else
		return FALSE //Funny meme!

/datum/crew/romulan/NameCheck(mob/living/M) //romulan admiral dilbert cook reporting!
	if(M.client)
		if(M.client.prefs.romulan_name)
			if(M.name != M.client.prefs.romulan_name)
				M.name = M.client.prefs.romulan_name
				M.real_name = M.name
				return TRUE
	else
		return FALSE

/datum/crew/proc/SanityCheck() //Check that someone with piloting skills has spawned.
	for(var/mob/living/M in crewmen) //Check everyone's in the correct faction
		if(!istype(M.player_faction, required.type))
			for(var/datum/faction/F in SSfaction.factions)
				if(istype(F, required.type))
					M.player_faction = F
					F.addMember(M)
					if(M.client)
						M.client.prefs.player_faction = F
			NameCheck(M)
	for(var/mob/living/MM in crewmen) //Check that there's someone who can fly the fucker. If not, make someone who can
		if(MM.skills)
			if(MM.skills.skillcheck(MM, "piloting", 5, FALSE))
				return //Good, one of them has a piloting skill and can fly.
	if(crewmen.len)
		var/mob/unluckybastard = pick(crewmen) //Nobody spawned with a piloting skill, so give someone the skill.
		to_chat(unluckybastard, "None of your crewmates had the skills to fly a [name], you have been made the designated pilot for this ship, this overrides your normal duties. If you are unable to stay / fly the ship due to inexperience, please contact an admin immediately.")
		unluckybastard.skills.add_skill("piloting", 7)
		for(var/mob/S in crewmen)
			if(unluckybastard)
				to_chat(S, "<span_class='notice'>[unluckybastard] is your substitute pilot for this shift.</span>")

/datum/crew/proc/SendToSpawn(mob/user)
	for(var/obj/effect/landmark/crewstart/S in GLOB.landmarks_list) //GUY ARE YOU FUCKING RETARDED JESUS CHRISTTTTT NOW HAVING A FOR LOOP WITH NO RETURN JESUUUUS
		if(S.name == name)
			user.forceMove(S.loc)
			to_chat(user, "<span_class='notice'><B>You have been assigned to a [name], you should not crew another ship unless explicitly ordered to do so by a higher ranking officer.</B></span>")
			required.onspawn(user)
			return TRUE

/obj/effect/landmark/crewstart
	name = "sovereign class heavy cruiser"

/obj/effect/landmark/crewstart/borgship
	name = "assimilated ship"

/obj/effect/landmark/crewstart/ds9
	name = "federation starbase class outpost"

/obj/effect/landmark/crewstart/nerd
	name = "uss woolfe research outpost"

/obj/effect/landmark/crewstart/defiant
	name = "defiant class warship"

/obj/effect/landmark/crewstart/romulan
	name = "dderidex class warbird"

/obj/effect/landmark/crewstart/borg
	name = "submatrix class vessel"

/obj/effect/landmark/crewstart/wars
	name = "executor class dreadnought"

/datum/crew/sovereign
	name = "sovereign class heavy cruiser"
	priority = MED
	faction = "starfleet"

/datum/crew/ds9
	name = "federation starbase class outpost"
	priority = MED
	faction = "starfleet"

/datum/crew/galaxy
	name = "galaxy class cruiser"
	faction = "starfleet"

/datum/crew/borg
	name = "submatrix class vessel"
	faction = "the borg collective"
	locked = TRUE

/datum/crew/cruiser
	name = "defiant class warship"
	priority = LOW
	max_crewmen = 6
	faction = "starfleet"

/datum/crew/romulan
	name = "dderidex class warbird"
	priority = HIGH
	faction = "romulan empire"
	requiredtype = /datum/faction/romulan
	locked = FALSE

/datum/crew/borgship
	name = "assimilated ship"
	priority = MED
	faction = "the borg collective"
	requiredtype = /datum/faction/borg

/datum/crew/nerds
	name = "uss woolfe research outpost"
	priority = LOW
	faction = "starfleet"
	max_crewmen = 6

/datum/crew/executor
	name = "executor class dreadnought"
	priority = MED
	faction = "the empire"

#undef LOW
#undef MED
#undef HIGH