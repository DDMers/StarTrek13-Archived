/mob/living
	var/image/mentortag = new
	var/image/helpmetag = new

/mob/living/verb/mentor_activate()
	set category = "OOC"
	set name = "Mentor visibility"
	set desc = "Change your mentor visibility status in-game"
	if(!check_rights(R_ADMIN, TRUE))
		return
	if(mentortag.icon || mentortag.icon_state)
		cut_overlay(mentortag)
		mentortag.icon = null
		mentortag.icon_state = null
		to_chat(src, "Mentor visibility disabled")
		return
	mentortag.icon = 'StarTrek13/icons/trek/faction_icons.dmi'
	mentortag.icon_state = "mentor"
	add_overlay(mentortag)
	to_chat(src, "Mentor visibility enabled! Players can now see you're a mentor.")

/mob/living/verb/request_help()
	set category = "OOC"
	set name = "Help me"
	set desc = "Flag yourself as in need of OOC help to other players and admins, or remove the flag."
	if(client.prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>You can't ask for help any more (muted by admins).</font>")
		return
	if(helpmetag.icon || helpmetag.icon_state)
		cut_overlay(helpmetag)
		helpmetag.icon = null
		helpmetag.icon_state = null
		to_chat(src, "You're no longer visibly in need of help.")
		return
	helpmetag.icon = 'StarTrek13/icons/trek/faction_icons.dmi'
	helpmetag.icon_state = "helpme"
	add_overlay(helpmetag)
	to_chat(src, "Help requested! Admins have been notified, other players can also see this. If you wish to communicate with them OOCly, please use LOOC.")
	to_chat(src, "<span_class='notice'>While you wait for assistance, here's some common problems:\n\
	-:k Lets you talk over the radio\n\
	-LOOC allows you to communicate out of character, but locally instead of globally\n\
	-You can undock a shuttle craft by ctrl / alt clicking it\n\
	-Roleplay rules are in effect! We're medium roleplay\n\
	-Setting up power means going into maint, look for the green and red deuterium and anti deuterium tanks, then use a wrench and set the flow rate to 5\n\
	-Ship not able to warp? Did you enable the warp plasma injectors in the warp nacelle near the tanks?\n\
	-If you can't open the plasma relay UI, click it with an open hand instead!\n\
	-Click on the small button on the turbolifts to use them\n\
	-Alt click the comms console to privately hail people\n\
	-Tools are given an random name and sprite, engineers can find which is which using examine, however within the round, all 'grey crecent shaped discombobulators' will be the same tool\n\
	-Did you know you can build ships? Head to DS9 / Barnard's star (gamemode dependant) and use the purple console\n\
	-End up on the wrong ship? You were probably autobalanced\n\
	-Are you wearing the wrong uniform? This is a common problem, please ask an admin for a new set of clothes.\n\
	-To capture a system outpost, look for the blue console and click it with an empty hand\n\
	-Restart votes are enabled if rounds go on for too long\n\
	If you are stuck in a view, check for a leave camera button in the upper left of your screen, if that doesn't work, use Cancel-Camera-View in the command bar\n\
	Most engineering interactions require either the wrench or screwdriver\n\
	-Ships and crews automatically respawn, but this comes with a penalty towards win conditions.</span>")

	message_admins("MENTOR REQUEST: [client.ckey] / [name] is requesting help as a [mind.assigned_role]")


/client
	var/widescreen = FALSE //i'll make this a pref later //I lied

/mob/verb/widescreen()
	set category = "OOC"
	set name = "Toggle widescreen"
	set desc = "Toggle W I D E screen mode, if you don't have an ultrawide monitor, expect this to break things"
	if(!client.widescreen)
		client.change_view("21x15")
		client.widescreen = TRUE
		to_chat(src, "Widescreen mode enabled")
	else
		client.change_view(CONFIG_GET(string/default_view))
		client.widescreen = FALSE
		to_chat(src, "Widescreen mode disabled")