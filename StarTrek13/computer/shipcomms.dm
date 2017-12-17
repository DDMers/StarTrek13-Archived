var/global/stsc[0]

/obj/machinery/computer/shipcomms
	name = "STSC Console"
	desc = "A console used for ship to ship communications (STSC)."
	icon_screen = "comm"
	icon_keyboard = "tech_key"
	var/ship_name = "USS Cadaver"//		Whomst'dve sent the message

	//circuit = /obj/item/weapon/circuitboard/computer/stsccircuit	DEFINE THIS LATER
	var
		const
			STATE_DEFAULT = 1
			STATE_VIEWMESSAGELOGS = 2
			STATE_SENDMESSAGE = 3
		state = STATE_DEFAULT

		id //must assigned in New() and not to be changed
		messages[0]
		obj/machinery/computer/shipcomms/connectedConsole

		//auth_id = "Unknown" //Who is currently logged in?

	/*	for access restriction. Enable later.
	req_access = list(access_heads)
	var/authenticated = 0
	*/

/obj/machinery/computer/shipcomms/New()
	id = stsc.len+1
	stsc += src
	..()

/obj/machinery/computer/shipcomms/attack_hand(mob/user)
	if(..())
		return

	user.set_machine(src)
	var/dat = ""

	var/datum/browser/popup = new(user, "shipcomms", "STSC Console", 400, 500)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))

	switch(src.state)
		if(STATE_DEFAULT)
			dat += "<ul>"
			for(var/obj/machinery/computer/shipcomms/sc in stsc)
				if(sc.id != src.id)
					//dat += "<center><li>ID: [sc.id]"
					dat += "<center><li>[sc.ship_name]"
					dat += "<A HREF='?src=\ref[src];action=viewmessagelogs;target=\ref[sc]'>Message Logs</A> | "
					dat += "<A HREF='?src=\ref[src];action=sendmessage;target=\ref[sc]'>Send Message</A></li></center><BR>"

			dat += "</ul>"
		if(STATE_VIEWMESSAGELOGS)
			dat += "<A HREF='?src=\ref[src];action=default' align='left'>Back</A>"
			dat += "<A HREF='?src=\ref[src];action=sendmessage;target=\ref[connectedConsole]' align='center'>Send Message</A></li></center><BR>"
			dat += "<A HREF='?src=\ref[src];action=refresh' align='right'>Refresh</A>"
			for(var/datum/Message/M in messages)
				if((M.receiver == connectedConsole) & (M.sender == src))
					dat += "<div align=right>[M.body]</div><BR>"
				if((M.receiver == src) & (M.sender == connectedConsole))
					dat += "<div align=left>[M.body]</div><BR>"
		if(STATE_SENDMESSAGE)
			var/input = stripped_multiline_input("Enter what you want the body of the message to contain:", "STSC Console Message")

			if(!input)
				return
				state = STATE_DEFAULT

			var/datum/Message/M = new
			M.body = input
			M.sender = src
			M.receiver = src.connectedConsole

			src.connectedConsole.messages += M
			messages += M

			state = STATE_VIEWMESSAGELOGS

	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/shipcomms/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)

	if(!href_list["action"])
		return

	connectedConsole = locate(href_list["target"])

	switch(href_list["action"])
		if("default")
			state = STATE_DEFAULT
		if("viewmessagelogs")
			state = STATE_VIEWMESSAGELOGS
		if("sendmessage")
			state = STATE_SENDMESSAGE
		if("refresh") //just go to the end
			src.updateUsrDialog()

	src.updateUsrDialog()

/obj/machinery/computer/shipcomms/Del()
	stsc -= src
	..()