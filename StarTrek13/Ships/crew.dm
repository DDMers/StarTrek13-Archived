#define LOW 1
#define MED 2
#define HIGH 3

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

/datum/crew/proc/Add(mob/M)
	candidates += M

/mob/proc/addme()
	var/datum/crew/S = pick(SSfaction.crews)
	S.Add(src)
	S.FillRoles()
	S.SanityCheck()

/datum/crew/proc/addbyforce(mob/I) //Two mobs because job equip code seems to make two mobs when switching the client over, so one has no client. WHO CAN IT BE NOOWWWWWW
	if(I)
		for(var/datum/crew/F in SSfaction.crews) //To stop endless spam like poor tpos got :(
			if(I in F.crewmen)
				F.count --
				F.crewmen -= I
		if(I in candidates)
			candidates -= I
		count ++
		crewmen += I
		to_chat(I, "You have been posted on a [name]! If you didn't want to be here, you probably got autobalanced.")
		SendToSpawn(I)


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
				to_chat(S, "<FONT color='red'>[unluckybastard] is your substitute pilot for this shift.</font>")

/datum/crew/proc/SendToSpawn(mob/user)
	for(var/obj/effect/landmark/crewstart/S in world)
		if(S.name == name)
			user.forceMove(S.loc)
			to_chat(user, "<FONT color='red'><B>You have been assigned to a [name], you should not crew another ship unless explicitly ordered to do so by a higher ranking officer.</B></font>")
			required.onspawn(user)

/obj/effect/landmark/crewstart
	name = "sovereign class heavy cruiser"

/obj/effect/landmark/crewstart/nerd
	name = "uss woolfe research outpost"

/obj/effect/landmark/crewstart/defiant
	name = "defiant class warship"

/obj/effect/landmark/crewstart/romulan
	name = "dderidex class warbird"

/obj/effect/landmark/crewstart/borg
	name = "submatrix class vessel"

/datum/crew/sovereign
	name = "sovereign class heavy cruiser"
	priority = MED
	faction = "starfleet"

/datum/crew/galaxy
	name = "galaxy class cruiser"
	faction = "starfleet"

/datum/crew/borg
	name = "submatrix class vessel"
	faction = "the borg collective"

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

/datum/crew/nerds
	name = "uss woolfe research outpost"
	priority = LOW
	faction = "starfleet"
	max_crewmen = 6

#undef LOW
#undef MED
#undef HIGH