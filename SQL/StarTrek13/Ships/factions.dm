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

/datum/faction/independant	//a holder datum for sorting players
	name = "the coalition of independant pilots"
	description = "An independant faction, freelancers, traders, or even pirates, these people choose their own path and forge their own journey."
	flavourtext = "You are your own person, and no power hungry faction will tell you otherwise. You are in a group of likeminded people, to call your organization a true faction would be inapropriate. Create your own path" //Sent to all new members upon recruitment.
	pref_colour = "green"

//"<FONT color='blue'><B>As this station was initially staffed with a [CONFIG_GET(flag/jobs_have_minimal_access) ? "full crew, only your job's necessities" : "skeleton crew, additional access may"] have been added to your ID card.</B></font>")

/datum/faction/starfleet
	name = "starfleet"
	description = "The military arm of the federation, its officers are disciplined and intelligent but there is plenty of room for ensigns and other inexperienced officers"
	flavourtext = "Starfleet is a stable career path, with luck you can work your way up the ranks all while protecting the values of the federation"
	pref_colour = "blue"

/datum/faction/proc/num_players()
	for(var/mob/P in GLOB.player_list)
		if(P.client)
			. ++

/datum/faction/New()
	var/players = num_players()
	if(player_requirement > players)
		qdel(src)
		log_game("[name] faction could not be created, as there were not enough players")
	else
		. = ..()

/datum/faction/proc/broadcast(var/ping)	//broadcast4reps
	if(!ping)
		return 0 //No message was input..somehow
	for(var/mob/living/M in members)
		to_chat(M, ping)

/datum/faction/proc/addMember(mob/living/D)
//	if(D in members)
//	if(isliving(D))
	members += D
	to_chat(D, "<FONT color='blue'><B>You have been recruited into [name]!</B></font>")
	to_chat(D, "<FONT color='[pref_colour]'><B>[flavourtext]</B></font>")

/datum/faction/proc/removeMember(mob/living/D)
	if(D in members)
		if(isliving(D))
			members -= D
			to_chat(D, "<FONT color='red'><B>You have been removed from [name]!</B></font>")

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