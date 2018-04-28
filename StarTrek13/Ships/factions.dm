/////////////
//Nothing to see here yet, but I'm going to note down a cool thing I saw on the byond forums:

/*
var/list/teams = list()     // a global list of teams

team
  var/name
  var/list/players
  var/score = 0

  var/colorrgb
  var/teamicon

  New(mob/M, nm, r, g, b)   // player M starts a new team
    name = nm
    players = list()
    SetColor(r, g, b)
    Add(M)          // add M to the team
    teams += src    // add this team to the global list

  Del()
    teams -= src    // take this off the global teams list
    for(var/mob/M in players)
        M << "[name] disbands."
        M.team = null
        M.icon = initial(M.icon)
    ..()    // always call this at the end of Del()

  proc/SetColor(r,g,b)
    colorrgb = rgb(r, g, b)
    var/icon/ic = new('team_player.dmi')
    ic.Blend(colorrgb, ICON_MULTIPLY)
    teamicon = fcopy_rsc(ic)    // convert the /icon to a .dmi
    for(var/mob/M in players)
      M.icon = teamicon         // change color

  proc/Add(mob/M)
    if(M.team)
      if(M.team == src) return
      M.team.Remove(M)
    players << "[M.name] joins the team."
    players += M
    M << "You [(players.len>1)?"join":"form"] [name]."
    M.team = src
    M.icon = teamicon

  proc/Remove(mob/M)
    if(M.team == src)
      M.team = null
      M.icon = initial(M.icon)
      players -= M
      players << "[M.name] leaves the team."
      M << "You [(players.len)?"leave":"disband"] [name]."
      if(!players.len) del(src)     // if the team is empty, delete it

mob
  icon='player.dmi'
  var/team/team     // which team am I on?
*/

//Star Trek 13

var/global/list/factionRosters[][] = list(list("Independent Roster"),
									  list("Starfleet Roster"),
									  list("Klingon Roster"))
//first bracket contains the actual rosters of the factions, second brackets contain the mobs
//eg factionRosters[1][1] would get the first member of the first faction
//   factionRosters[2][1] would get the first member of the second faction

/datum/faction	//a holder datum for sorting players
	var/name = "a faction"
	var/mob/living/members = list()
	var/description = "why are you seeing this."
	var/datum/species/required_race = null //Framework for having race only empires, IE if you want to be klingon you have to be klingon.
	var/flavourtext = "you shouldnt be here" //Sent to all new members upon recruitment.
	var/player_requirement = 0 //Is this population locked?
	var/pref_colour = "green" //Color that the background goes if this faction is selected in preferences
	var/obj/effect/spawns = list()
	var/datum/objective/objectives = list()
	var/credits = 0 //:( i'm just a poor boy from a poor family

/datum/faction/independant	//a holder datum for sorting players
	name = "independant"
	description = "An independant faction, freelancers, traders, or even pirates, these people choose their own path and forge their own journey."
	flavourtext = "You are your own person, and no power hungry faction will tell you otherwise. You are in a group of likeminded people, to call your organization a true faction would be inapropriate. Create your own path" //Sent to all new members upon recruitment.
	pref_colour = "green"

//"<FONT color='blue'><B>As this station was initially staffed with a [CONFIG_GET(flag/jobs_have_minimal_access) ? "full crew, only your job's necessities" : "skeleton crew, additional access may"] have been added to your ID card.</B></font>")

/datum/faction/starfleet
	name = "starfleet"
	description = "The military arm of the federation, its officers are disciplined and intelligent but there is plenty of room for ensigns and other inexperienced officers"
	flavourtext = "Starfleet is a stable career path, with luck you can work your way up the ranks all while protecting the values of the federation"
	pref_colour = "red"

/datum/faction/nanotrasen
	name = "nanotrasen"
	description = "Nanotrasen, or more specifically, their main corporate arm. Their goal is to make money and maintain the colonies, no matter who opposes them."
	flavourtext = "Nanotrasen is an oligarchy, but with merit you should be able to climb the ranks...up to a point."
	pref_colour = "blue"

/datum/faction/proc/num_players()
	for(var/mob/P in GLOB.player_list)
		if(P.client)
			. ++

/datum/faction/New()
	var/players = num_players()
	get_spawns()
	if(player_requirement > players)
		qdel(src)
		log_game("[name] faction could not be created, as there were not enough players")
	else
		. = ..()

/datum/faction/proc/get_spawns() //override this for each
	for(var/obj/effect/landmark/faction_spawn/F in world)
		if(F.name == name)
			spawns += F

/datum/faction/proc/broadcast(var/ping)	//broadcast4reps
//	if(!ping)
//		return 0 //No message was input..somehow
	for(var/mob/living/M in members)
		to_chat(M, ping)

/datum/faction/proc/addMember(mob/living/D)
//	if(D in members)
//	if(isliving(D))
	members += D
	to_chat(D, "<FONT color='blue'><B>You have been recruited into [name]!</B></font>")
	to_chat(D, "<FONT color='[pref_colour]'><B>[flavourtext]</B></font>")
	onspawn(D)

/datum/faction/proc/onspawn(mob/living/carbon/human/D) //If you want things to happen to someone as they join a faction, put it here
	return

var/list/global/faction_spawns = list()

/obj/effect/landmark/faction_spawn
	name = "starfleet"

/obj/effect/landmark/faction_spawn/nanotrasen
	name = "nanotrasen"

/obj/effect/landmark/faction_spawn/independant
	name = "independant"

/obj/effect/landmark/faction_spawn/borg
	name = "the borg"

/obj/item/clothing/neck/tie/faction_tag //I hate myself for doing this, but I don't have the time to mess around with antag huds...yet...
	name = "federation dogtag"
	desc = "Wear this to not get shot by your friends!."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "federationdogtag"
	item_state = ""	//no inhands
	item_color = "federationdogtag"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/tie/faction_tag/nanotrasen //I hate myself for doing this, but I don't have the time to mess around with antag huds...yet...
	name = "Nanotrasen dogtag"
	desc = "Wear this to not get shot by your friends!."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "nanotrasendogtag"
	item_state = ""	//no inhands
	item_color = "nanotrasendogtag"
	w_class = WEIGHT_CLASS_SMALL

/datum/faction/proc/removeMember(mob/living/D)
	if(D in members)
		if(isliving(D))
			members -= D
			to_chat(D, "<FONT color='red'><B>You have been removed from [name]!</B></font>")

/datum/faction/proc/addCredits(amount)
	credits += amount
	broadcast("Our faction has just earned [amount] credits!")

/datum/objective/faction
	completed = 0
	explanation_text = "lead your faction to greatness"
	var/datum/faction/faction

/datum/objective/faction/escort
	explanation_text = ""
	var/mob/living/vip //The person who you're meant to protect.
	var/datum/faction/vipfaction //The faction that the VIP is in
	var/mob/living/lover //The agent's lover.
	var/datum/faction/target_faction


//Factions have a ranking
/*
This ranking is based on (hierarchically):
number of claimed systems
total value of all their ships
money accrued
objectives completed
raw material wealth

So they can do mini objectives for fast cash, or mine, collect bounties off NPCs, trade etc. For alpha we're just gonna have it be that the richest faction wins.

*/

/datum/objective/faction/escort/New()
	claim_the_waifu()
	. = ..()

/datum/objective/faction/escort/proc/claim_the_waifu() //Kmc's patented waifu finding technology.
	for(var/mob/living/M in faction.members) //Faction will be assigned on creation of this objective by SSfaction
		if(M.client && !M in SSfaction.vips)
			vip = M
			SSfaction.vips += M
			break
	var/datum/faction/F = list()
	F = SSfaction.factions
	if(faction in F)
		F -= vipfaction //Can't kidnap someone from the same faction as the defector.
	var/datum/faction/thetargetfaction = pick(F)
	for(var/mob/living/M in thetargetfaction.members)
		if(M.client && !M in SSfaction.vips && !M in SSfaction.lovers)
			lover = M
			SSfaction.lovers += M
			break
	explanation_text = "[vip] has recently defected from another faction, but before they give up their secrets, they have insisted that their lover, [lover] (who is loyal to their faction) is kidnapped from [thetargetfaction]. They must be caught ALIVE!."
	inform_the_people()
	target_faction = thetargetfaction

/datum/objective/faction/escort/proc/inform_the_people()
	to_chat(vip, "<span class='danger'>You have just defected from [target_faction]!, but before you went you learned many dark secrets that they're hiding...</span>")
	to_chat(vip, "<span class='danger'>Your lover, [lover] is still with [target_faction]!, you are not to reveal your information to [vipfaction] UNTIL they bring [lover] back to you safely!.</span>")
	var/thing = pick("the head of [target_faction]'s mother is gay","[target_faction] has a money laundering program","[target_faction] eats dogs")
	to_chat(vip, "<span class='danger'>In your time working for [target_faction], you discovered that: [thing] amongst other things</span>")
	to_chat(vip, "<span class='danger'>Once [lover] comes within a few meters of you, you'll feel magically compelled to SPILL THE BEANS, netting your new faction-mates a nice credit bonus.</span>")
	to_chat(vip, "<span class='danger'>Unfortunately, it seems that [lover] is siphoning money from your bank account! the longer they're away from you, the more money [target] will make! so be SURE to catch her!.</span>")

	//BEGIN WAIFU EXPLANATION!

	to_chat(vip, "<span class='danger'>Your crazy ex-lover, [vip] has decided to abandon their duties and sell off our secrets!</span>")
	to_chat(vip, "<span class='danger'>Your faction members will try to keep him away from you, the longer they do, the more money [target_faction] will earn!</span>")
	to_chat(vip, "<span class='danger'>If you see [vip], don't get too close! or they'll consider you theirs again (what a creep), completing the sale of secrets and humiliating [target].</span>")
	to_chat(vip, "<span class='danger'>[vip] has defected to [faction], you should keep away from their ships. You're free to play normally, but do not allow yourself to be captured.</span>")

/datum/objective/faction/escort/check_completion()
	if(lover in orange(vip, 2)) //If the lover's within about 2 meters of the VIP
		var/thing = pick("the head of [target]'s mother is gay","[target] has a money laundering program","[target] eats dogs", "REPLICATED FOOD IS MADE OF PEOPLE!!!!!!")
		vip.say(thing)
		vip.say("We'll always have Paris, [lover]")
		faction.broadcast("VIP mission successful, we learned that [thing]")
		faction.addCredits(50000) //MOOLAH BABY
		return 1
	else
		return 0

//datum/objective/faction/



//Framework, finish this after factions are working

/datum/alliance  //A faction can ally itself with a group, so starfleet is allied to the federation, klingons allied to the federation etc.
	var/name = "the united federation of planets"
	var/decription = "Formed in 2161 this rather new entity is the governing body for a large chunk of the galaxy, it values freedom and order above all."
	var/datum/faction/member_factions = list()
	var/datum/alliance/at_war_with = list() //Enemy alliances
	var/joinMessage = "your faction has joined the federation"

/datum/alliance/proc/addMember(datum/faction/D)
	if(!D in member_factions)
		member_factions += D
		D.broadcast(joinMessage)

/datum/alliance/proc/removeMember(datum/faction/D)
	if(D in member_factions)
		member_factions -= D
		D.broadcast("Your faction has been removed from [name]!")
