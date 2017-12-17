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