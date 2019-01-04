/datum/job/trek
	total_positions = 500
/*
Assistant
*/
/datum/job/trek/crewman
	title = "Crewman"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the captain. As a crewman, you don't have a specific role, but you could become: A janitor | A communications officer | An away team member | A bridge crew member, speak to your supervisors and ask for an assignment."
	selection_color = "#dddddd"
	access = list()			//See /datum/job/trek/assistant/get_access()
	minimal_access = list()	//See /datum/job/trek/assistant/get_access()
	outfit = /datum/outfit/job/crewman


/datum/job/trek/crewman/get_access()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/job/trek/crewman/config_check()
	var/ac = CONFIG_GET(number/overflow_cap)
	if(ac != 0)
		total_positions = ac
		spawn_positions = ac
		return 1
	return 0


/datum/outfit/job/crewman
	name = "Crewman"
	jobtype = /datum/job/trek/crewman
	uniform = /obj/item/clothing/under/trek/medsci/ent
	belt = /obj/item/ship_repair_tool
	accessory = /obj/item/clothing/accessory/rank_pips

/datum/outfit/job/crewman/pre_equip(mob/living/carbon/human/H)
	if(istype(H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/grey/sov
	if(istype(H.player_faction, /datum/faction/romulan))
		uniform = /obj/item/clothing/under/romulan
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	..()


//ADD SPAWNS FOR THE NEW JOBS!
/*
Captain
*/
/datum/job/trek/captain
	title = "Captain"
	flag = CAPTAIN
	department_head = list("Federation Central Command")
	department_flag = ENGSEC
	faction = "Station"

	total_positions = 1 //3 is a round number, change it with testing data.
	spawn_positions = 3
	supervisors = "Federation officials and Space law"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW		//There will be multiple captains in one round

	outfit = /datum/outfit/job/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/trek/captain/get_access()
	return get_all_accesses()

/datum/job/trek/captain/announce(mob/living/carbon/human/H)
	..()
//	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/trek/captain

	id = /obj/item/card/id/gold
//	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/black
	uniform =  /obj/item/clothing/under/trek/command/ent
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
//	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/tricorder=1, /obj/item/ship_repair_tool=1, /obj/item/encryptionkey/headset_com=1)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank_pips/capt

/datum/outfit/job/captain/pre_equip(mob/living/carbon/human/H)
	..()
	if(istype(H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/command/sov
	if(istype(H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/H)
	if(H.skills)
		H.skills.add_skill("piloting", 5)
	else
		H.skills = new
		H.skills.add_skill("piloting", 5)
	H.grant_kirkfu()
	. = ..()

/datum/job/trek/admiral
	title = "Admiral"
	flag = ADMIRAL
	department_head = list("the Federation")
	department_flag = ENGSEC
	faction = "Station"

	total_positions = 3 //3 is a round number, change it with testing data.
	spawn_positions = 3
	supervisors = "The Federation"
	selection_color = "#B22222"
	req_admin_notify = 1
	minimal_player_age = 17
	exp_requirements = 280
	exp_type = EXP_TYPE_CREW		//There will be multiple captains in one round

	outfit = /datum/outfit/job/admiral

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/trek/admiral/get_access()
	return get_all_accesses()


/datum/job/trek/admiral/announce(mob/living/carbon/human/H)
	..()
//	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

/datum/outfit/job/admiral
	name = "Admiral"
	jobtype = /datum/job/trek/admiral

	id = /obj/item/card/id/gold
//	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/black
	uniform =  /obj/item/clothing/under/trek/command/ent
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
//	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/station_charter=1,/obj/item/modular_computer/tablet/preset/advanced=1,/obj/item/encryptionkey/headset_com=1)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank_pips/admiral

/datum/outfit/job/admiral/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/command/sov
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars/admiral
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	..()


/datum/outfit/job/admiral/post_equip(mob/living/carbon/human/H)
	if(H.skills)
		H.skills.add_skill("piloting", 5)
		H.skills.add_skill("micromanagement", 10)//So they can use the RTS consoles
	else
		H.skills = new
		H.skills.add_skill("micromanagement", 10)
	. = ..()
/*
/datum/outfit/job/admiral/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	var/datum/job/trek/aide/L= SSjob.GetJobType(jobtype)
	L.admirals++
	L.total_positions = L.admirals //admirals require aides.
	H.add_skill(rand(40, 59), rand(60, 70), rand(0, 28), rand(0, 28), rand(50, 65))*/
/*
Head of Personnel
*/
/datum/job/trek/firstofficer
	title = "First Officer"
	flag = FIRSTOFFICER
	department_head = list("Captain")
	department_flag = CIVILIAN
	head_announce = list("Supply", "Service")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SUPPLY

	outfit = /datum/outfit/job/firstofficer

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
			            ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
			            ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
			            ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_VAULT, ACCESS_MINING_STATION,
			            ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
			            ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
			            ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
			            ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_VAULT, ACCESS_MINING_STATION,
			            ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM)


/datum/outfit/job/firstofficer
	name = "First officer"
	jobtype = /datum/job/trek/firstofficer

	id = /obj/item/card/id/silver
	belt = /obj/item/ship_repair_tool
	ears = /obj/item/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/trek/command/ent
	shoes = /obj/item/clothing/shoes/jackboots
	accessory = /obj/item/clothing/accessory/rank_pips/cmdr
	backpack_contents = list(/obj/item/storage/box/ids=1,\
		/obj/item/modular_computer/tablet/preset/advanced = 1,/obj/item/tricorder,/obj/item/encryptionkey/headset_com=1)

/datum/outfit/job/firstofficer/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/command/sov
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	..()

/datum/outfit/job/firstofficer/post_equip(mob/living/carbon/human/H)
	if(H.skills)
		H.skills.add_skill("piloting", 5)
	else
		H.skills = new
		H.skills.add_skill("piloting", 5)
	. = ..()

/datum/outfit/job/curator/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return
	H.grant_all_languages(omnitongue=TRUE)
/*
Shaft Miner
*/
/datum/job/trek/mining
	title = "Miner"
	flag = MINER
	department_head = list("First officer")
	department_flag = CIVILIAN
	faction = "Station"

	total_positions = 3
	spawn_positions = 3
	supervisors = "the first officer"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/miner

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/miner
	name = "Shaft Miner (Lavaland)"
	jobtype = /datum/job/trek/mining

	ears = /obj/item/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/trek/engsec/ent
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/survival
	r_pocket = /obj/item/flashlight/seclite
	backpack_contents = list(
		/obj/item/storage/bag/ore=1,\
		/obj/item/kitchen/knife/combat/survival=1,\
		/obj/item/mining_voucher=1,\
		/obj/item/tricorder=1,\
		/obj/item/stack/marker_beacon/ten=1)

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag
	box = /obj/item/storage/box/survival_mining
	accessory = /obj/item/clothing/accessory/rank_pips

/datum/outfit/job/miner/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/grey/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	..()

/datum/outfit/job/miner/post_equip(mob/living/carbon/human/H) //So they can fly to and from lavaland
	if(H.skills)
		H.skills.add_skill("piloting", 5)
	else
		H.skills = new
		H.skills.add_skill("piloting", 5)
	. = ..()

/datum/outfit/job/miner/asteroid
	name = "Shaft Miner (Asteroid)"
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/workboots

/datum/outfit/job/miner/equipped
	name = "Shaft Miner (Lavaland + Equipment))"
	suit = /obj/item/clothing/suit/hooded/explorer
	mask = /obj/item/clothing/mask/gas/explorer
	glasses = /obj/item/clothing/glasses/meson
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = SLOT_S_STORE
	backpack_contents = list(
		/obj/item/storage/bag/ore=1,
		/obj/item/kitchen/knife/combat/survival=1,
		/obj/item/mining_voucher=1,
		/obj/item/t_scanner/adv_mining_scanner/lesser=1,
		/obj/item/gun/energy/kinetic_accelerator=1,\
		/obj/item/tricorder=1,\
		/obj/item/stack/marker_beacon/ten=1)

/datum/outfit/job/miner/equipped/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	if(istype(H.wear_suit, /obj/item/clothing/suit/hooded))
		var/obj/item/clothing/suit/hooded/S = H.wear_suit
		S.ToggleHood()

/datum/outfit/job/miner/equipped/asteroid
	name = "Shaft Miner (Asteroid + Equipment))"
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/suit/space/hardsuit/mining
	mask = /obj/item/clothing/mask/breath


/*
Chief Engineer
*/
/datum/job/trek/chief_engineer
	title = "Chief Engineering Officer"
	flag = CHIEF
	department_head = list("Captain")
	department_flag = ENGSEC
	head_announce = list("Engineering")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffeeaa"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_ENGINEERING

	outfit = /datum/outfit/job/ce

	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
			            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_MINISAT,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
			            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_MINISAT,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/ce
	name = "Chief Engineering Officer"
	jobtype = /datum/job/trek/chief_engineer

	id = /obj/item/card/id/silver
	belt = /obj/item/storage/belt/utility/chief/full
	l_pocket = /obj/item/ship_repair_tool
	ears = /obj/item/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/trek/engsec/ent
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black/ce
	accessory = /obj/item/clothing/accessory/rank_pips/lt/cmdr
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1,/obj/item/tricorder,/obj/item/encryptionkey/headset_com=1)

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/engineer

/datum/outfit/job/ce/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/engsec/sov
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	if(H.skills)
		H.skills.add_skill("piloting", 5)
	else
		H.skills = new
		H.skills.add_skill("piloting", 5)
	H.skills.add_skill("construction and maintenance", 7)
	..()

/*
Station Engineer
*/
/datum/job/trek/engineer
	title = "Engineer"
	flag = ENGINEER
	department_head = list("Chief Engineer")
	department_flag = ENGSEC
	faction = "Station"

	total_positions = 5
	spawn_positions = 5
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	exp_requirements = 60
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/engineer

	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
									ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_TCOMSAT)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
									ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_TCOMSAT)

/datum/outfit/job/engineer
	name = "Ship technician"
	jobtype = /datum/job/trek/engineer

	belt = /obj/item/storage/belt/utility/full/engi
	l_pocket = /obj/item/ship_repair_tool
	ears = /obj/item/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/trek/engsec/ent
	shoes = /obj/item/clothing/shoes/jackboots
	r_pocket = /obj/item/tricorder
	accessory = /obj/item/clothing/accessory/rank_pips/lt

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/engineer
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/engineer/pre_equip(mob/living/carbon/human/H)
	H.skills.add_skill("construction and maintenance", 5)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/engsec/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	..()

/*
Chief Medical Officer
*/
/datum/job/trek/cmo
	title = "Surgical Chief"
	flag = CMO_JF
	department_head = list("Captain")
	department_flag = MEDSCI
	head_announce = list("Medical")
	faction = "Station"

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddf0"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_MEDICAL

	outfit = /datum/outfit/job/cmo

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS)

/datum/outfit/job/cmo
	name = "Surgical Chief"
	jobtype = /datum/job/trek/cmo

	id = /obj/item/card/id/silver
	l_pocket = /obj/item/pinpointer/crew
	ears = /obj/item/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/trek/medsci/ent
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/storage/firstaid/regular
	suit_store = /obj/item/flashlight/pen
	backpack_contents = list(/obj/item/encryptionkey/headset_com=1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	accessory = /obj/item/clothing/accessory/rank_pips/lt/cmdr

/datum/outfit/job/cmo/pre_equip(mob/living/carbon/human/H)
	H.skills.add_skill("medicine", 8)
	if(H.skills)
		H.skills.add_skill("piloting", 3)
	else
		H.skills = new
		H.skills.add_skill("piloting", 3)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/medsci/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	..()
//NOTICE: ALL SCIENCE RElATED JOBS/RESEARCH WILL WORK ON STARBASES, ONLY MEDICAL DOCTORS ETC. WILL WORK ON THE SHIPS.


/*
Medical Doctor
*/
/datum/job/trek/doctor
	title = "Doctor"
	flag = DOCTOR
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"

	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/doctor

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CLONING)

/datum/outfit/job/doctor
	name = "Doctor"
	jobtype = /datum/job/trek/doctor

	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/trek/medsci/ent
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/storage/firstaid/regular
	suit_store = /obj/item/flashlight/pen

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	accessory = /obj/item/clothing/accessory/rank_pips/lt

/datum/outfit/job/doctor/pre_equip(mob/living/carbon/human/H)
	H.skills.add_skill("medicine", 6)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/medsci/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	..()
/*
Research Director
*/
/datum/job/trek/rd
	title = "Science Officer"
	flag = RD_JF
	department_head = list("Captain")
	department_flag = MEDSCI
	head_announce = list("Science")
	faction = "Station"

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_type_department = EXP_TYPE_SCIENCE
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/rd

	access = list(ACCESS_RD, ACCESS_HEADS, ACCESS_TOX, ACCESS_GENETICS, ACCESS_MORGUE,
			            ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS,
			            ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD,
			            ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM,
			            ACCESS_TECH_STORAGE, ACCESS_MINISAT, ACCESS_MAINT_TUNNELS, ACCESS_NETWORK)
	minimal_access = list(ACCESS_RD, ACCESS_HEADS, ACCESS_TOX, ACCESS_GENETICS, ACCESS_MORGUE,
			            ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS,
			            ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD,
			            ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM,
			            ACCESS_TECH_STORAGE, ACCESS_MINISAT, ACCESS_MAINT_TUNNELS, ACCESS_NETWORK)

/datum/outfit/job/rd
	name = "Science Officer"
	jobtype = /datum/job/trek/rd

	id = /obj/item/card/id/silver
	ears = /obj/item/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/trek/medsci/ent
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/clipboard
	l_pocket = /obj/item/laser_pointer
	accessory = /obj/item/clothing/accessory/rank_pips/lt/cmdr
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1,/obj/item/encryptionkey/headset_com=1)

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

/datum/outfit/job/rd/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/medsci/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	..()
/*
Scientist
*/
/datum/job/trek/scientist
	title = "Junior Science Officer"
	flag = SCIENTIST
	department_head = list("Research Director")
	department_flag = MEDSCI
	faction = "Station"

	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	exp_requirements = 60
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/scientist

	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GENETICS)
	minimal_access = list(ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/scientist
	name = "Researcher"
	jobtype = /datum/job/trek/scientist

	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/trek/medsci/ent
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/toggle/labcoat/science

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox
	accessory = /obj/item/clothing/accessory/rank_pips/lt

/datum/outfit/job/scientist/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/medsci/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	..()

//Warden and regular officers add this result to their get_access()
/datum/job/trek/proc/check_config_for_sec_maint()
	if(CONFIG_GET(flag/security_has_maint_access))
		return list(ACCESS_MAINT_TUNNELS)
	return list()

/*
Head of Security
*/
/datum/job/trek/hos
	title = "Chief of security"
	flag = HOS
	department_head = list("Captain")
	department_flag = ENGSEC
	head_announce = list("Security")
	faction = "Station"

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffdddd"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/hos

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS)

/datum/outfit/job/hos
	name = "Chief of security"
	jobtype = /datum/job/trek/hos

	id = /obj/item/card/id/silver
	ears = /obj/item/radio/headset/heads/hos/alt
	uniform = /obj/item/clothing/under/trek/engsec/ent
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black/hos
	head = /obj/item/clothing/head/HoS/beret
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	suit_store = /obj/item/gun/energy/e_gun
	r_pocket = /obj/item/assembly/flash/handheld
	l_pocket = /obj/item/restraints/handcuffs
	backpack_contents = list(/obj/item/melee/baton/loaded=1,/obj/item/encryptionkey/headset_com=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security
	accessory = /obj/item/clothing/accessory/rank_pips/lt/cmdr

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/hos/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/engsec/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	H.grant_kirkfu()
	..()
/*
Security Officer
*/
/datum/job/trek/officer
	title = "Security Officer"
	flag = OFFICER
	department_head = list("Chief Of Security")
	department_flag = ENGSEC
	faction = "Station"

	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the ship security coordinator, and the head of your assigned department (if applicable)"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/security

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS) //BUT SEE /datum/job/trek/WARDEN/GET_ACCESS()


/datum/job/trek/officer/get_access()
	var/list/L = list()
	L |= ..() | check_config_for_sec_maint()
	return L

/datum/outfit/job/security
	name = "Ship Security Officer"
	jobtype = /datum/job/trek/officer

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/trek/engsec/ent
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/beret/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld
	suit_store = /obj/item/gun/energy/e_gun/advtaser
	backpack_contents = list(/obj/item/melee/baton/loaded=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security
	accessory = /obj/item/clothing/accessory/rank_pips/lt

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/security/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/engsec/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	H.grant_kirkfu()
	..()

/obj/item/radio/headset/headset_sec/alt/department/Initialize()
	. = ..()
	wires = new/datum/wires/radio(src)
	secure_radio_connections = new
	recalculateChannels()

/obj/item/radio/headset/headset_sec/alt/department/engi
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_sec/alt/department/supply
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_sec/alt/department/med
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_sec/alt/department/sci
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_sci

//When adding new jobs, go to jobs.dm

/datum/job/trek/soldier
	title = "Combat Specialist"
	flag = SOLDIER
	department_head = list("Admirals")
	department_flag = ENGSEC
	faction = "Station"

	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "anyone of a higher rank than yourself."
	selection_color = "#ffeeee"
	minimal_player_age = 3
	exp_requirements = 100
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/soldier

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS) //BUT SEE /datum/job/trek/WARDEN/GET_ACCESS()

/datum/outfit/job/soldier
	name = "Starfleet Infantry"
	jobtype = /datum/job/trek/soldier

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/trek/engsec/ent
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/beret/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	suit_store = /obj/item/gun/energy/laser/retro //change this shit
	backpack_contents = list(/obj/item/melee/baton/loaded=1,/obj/item/gun/energy/laser/retro=1,/obj/item/kitchen/knife/combat=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security
	accessory = /obj/item/clothing/accessory/rank_pips/lt/cmdr

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/soldier/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/engsec/sov
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	..()

/datum/outfit/job/soldier/post_equip(mob/living/carbon/human/H)
	H.grant_kirkfu()
	if(prob(5)) //5% chance to be a legendary soldier
//		H.add_skill(110, rand(60, 68), rand(24, 32), ..(), ..())
		to_chat(H, "<big>You are a legendary soldier! You've had some experience, and are well versed in the arts of close-quarters combat.</big>")
		return
	. = ..()

/datum/job/trek/pilot
	title = "Helmsman"
	flag = PILOT
	department_head = list("Captain")
	department_flag = ENGSEC
	head_announce = list("captain")
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the captain"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_CREW

	outfit = /datum/outfit/job/pilot

	access = list()
	minimal_access = list()

/datum/outfit/job/pilot
	name = "Ship Helmsman"
	jobtype = /datum/job/trek/pilot

	id = /obj/item/card/id
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/trek/command/ent
	shoes = /obj/item/clothing/shoes/laceup
	accessory = /obj/item/clothing/accessory/rank_pips/lt
	backpack_contents = list(/obj/item/encryptionkey/headset_com=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/pilot/pre_equip(mob/living/carbon/human/H)
	if(istype( H.player_faction, /datum/faction/starfleet))
		uniform = /obj/item/clothing/under/trek/engsec/sov
	if(istype( H.player_faction, /datum/faction/romulan))
		shoes = /obj/item/clothing/shoes/jackboots
		uniform = /obj/item/clothing/under/romulan
	if(istype( H.player_faction, /datum/faction/empire))
		uniform = /obj/item/clothing/under/wars
	..()

/datum/outfit/job/pilot/post_equip(mob/living/carbon/human/H)
	if(H.skills)
		H.skills.add_skill("piloting", 7)
	else
		H.skills = new
		H.skills.add_skill("piloting", 7)
	. = ..()