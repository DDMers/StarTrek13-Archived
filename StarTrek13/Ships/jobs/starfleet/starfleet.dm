/datum/job/fed
	starting_faction = "starfleet"


/*
Assistant
*/
/datum/job/fed/crewman
	title = "Crewmember"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"

	total_positions = -1
	spawn_positions = -1
	supervisors = "all other crew members of higher rank."
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/fed/crewman


/datum/job/fed/crewman/get_access()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/job/fed/crewman/config_check()
	var/ac = CONFIG_GET(number/assistant_cap)
	if(ac != 0)
		total_positions = ac
		spawn_positions = ac
		return 1
	return 0


/datum/outfit/job/fed/crewman
	name = "Crewman"
	jobtype = /datum/job/fed/crewman

/datum/outfit/job/fed/crewman/pre_equip(mob/living/carbon/human/H)
	..()
	if (CONFIG_GET(flag/grey_assistants))
		uniform = /obj/item/clothing/under/trek/grey
	else
		uniform = /obj/item/clothing/under/trek/grey

//ADD SPAWNS FOR THE NEW JOBS!
/*
Captain
*/
/datum/job/fed/captain
	title = "Starfleet Captain"
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

	outfit = /datum/outfit/job/fed/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/fed/captain/get_access()
	return get_all_accesses()

/datum/job/fed/captain/announce(mob/living/carbon/human/H)
	..()
//	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

/datum/outfit/job/fed/captain
	name = "Starfleet Captain"
	jobtype = /datum/job/fed/captain

	id = /obj/item/card/id/gold
	belt = /obj/item/device/pda/captain
//	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/black
	uniform =  /obj/item/clothing/under/trek/command/next
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
//	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/station_charter=1,/obj/item/device/modular_computer/tablet/preset/advanced)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/medal/gold/captain

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/H)
	H.skills.add_skill("piloting", 5)


/datum/job/fed/admiral
	title = "Starfleet Admiral"
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

	outfit = /datum/outfit/job/fed/admiral

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/admiral/get_access()
	return get_all_accesses()

/datum/job/fed/admiral/announce(mob/living/carbon/human/H)
	..()
//	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

/datum/outfit/job/fed/admiral
	name = "Starfleet Admiral"
	jobtype = /datum/job/fed/admiral

	id = /obj/item/card/id/gold
	belt = /obj/item/device/pda/captain
//	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/black
	uniform =  /obj/item/clothing/under/trek/command/next
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
//	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/station_charter=1,/obj/item/device/modular_computer/tablet/preset/advanced)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/medal/gold/captain

/*
/datum/outfit/job/fed/admiral/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	var/datum/job/aide/L= SSjob.GetJobType(jobtype)
	L.admirals++
	L.total_positions = L.admirals //admirals require aides.
	H.add_skill(rand(40, 59), rand(60, 70), rand(0, 28), rand(0, 28), rand(50, 65))*/
/*
Head of Personnel
*/
/datum/job/fed/firstofficer
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

	outfit = /datum/outfit/job/fed/firstofficer

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
			            ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
			            ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
			            ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_HEADS_VAULT, ACCESS_MINING_STATION,
			            ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
			            ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
			            ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
			            ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_HEADS_VAULT, ACCESS_MINING_STATION,
			            ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM)


/datum/outfit/job/fed/firstofficer
	name = "First officer"
	jobtype = /datum/job/fed/firstofficer

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/hop
	ears = /obj/item/device/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/trek/command/next
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/storage/box/ids=1,\
		/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced = 1,/obj/item/device/tricorder)

/datum/outfit/job/firstofficer/post_equip(mob/living/carbon/human/H)
	H.skills.add_skill("piloting", 3)


/datum/outfit/job/fed/curator/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	H.grant_all_languages(omnitongue=TRUE)
/*
Shaft Miner
*/
/datum/job/fed/mining
	title = "Federation Miner"
	flag = MINER
	department_head = list("First officer")
	department_flag = CIVILIAN
	faction = "Station"

	total_positions = 3
	spawn_positions = 3
	supervisors = "the first officer"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/fed/miner

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/fed/miner
	name = "Shaft Miner (Lavaland)"
	jobtype = /datum/job/fed/mining

	belt = /obj/item/device/pda/shaftminer
	ears = /obj/item/device/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/trek/grey
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/survival
	r_pocket = /obj/item/device/flashlight/seclite
	backpack_contents = list(
		/obj/item/storage/bag/ore=1,\
		/obj/item/kitchen/knife/combat/survival=1,\
		/obj/item/mining_voucher=1,\
		/obj/item/device/tricorder=1,\
		/obj/item/stack/marker_beacon/ten=1)

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag
	box = /obj/item/storage/box/survival_mining

/datum/outfit/job/fed/miner/asteroid
	name = "Shaft Miner (Asteroid)"
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/workboots

/datum/outfit/job/fed/miner/equipped
	name = "Shaft Miner (Lavaland + Equipment)"
	suit = /obj/item/clothing/suit/hooded/explorer
	mask = /obj/item/clothing/mask/gas/explorer
	glasses = /obj/item/clothing/glasses/meson
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = slot_s_store
	backpack_contents = list(
		/obj/item/storage/bag/ore=1,
		/obj/item/kitchen/knife/combat/survival=1,
		/obj/item/mining_voucher=1,
		/obj/item/device/t_scanner/adv_mining_scanner/lesser=1,
		/obj/item/gun/energy/kinetic_accelerator=1,\
		/obj/item/device/tricorder=1,\
		/obj/item/stack/marker_beacon/ten=1)

/datum/outfit/job/fed/miner/equipped/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	if(istype(H.wear_suit, /obj/item/clothing/suit/hooded))
		var/obj/item/clothing/suit/hooded/S = H.wear_suit
		S.ToggleHood()

/datum/outfit/job/fed/miner/equipped/asteroid
	name = "Shaft Miner (Asteroid + Equipment)"
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/suit/space/hardsuit/mining
	mask = /obj/item/clothing/mask/breath


/*
Chief Engineer
*/
/datum/job/fed/chief_engineer
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

	outfit = /datum/outfit/job/fed/ce

	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
			            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_MINISAT,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
			            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_MINISAT,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/fed/ce
	name = "Chief Engineering Officer"
	jobtype = /datum/job/fed/chief_engineer

	id = /obj/item/card/id/silver
	belt = /obj/item/storage/belt/utility/chief/full
	l_pocket = /obj/item/device/pda/heads/ce
	ears = /obj/item/device/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/trek/engsec/next
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black/ce
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced=1,/obj/item/device/tricorder)

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/engineer
	pda_slot = slot_l_store

/datum/outfit/job/fed/ce/pre_equip(mob/living/carbon/human/H)
	..()
	H.skills.add_skill("piloting", 5)
	H.skills.add_skill("construction and maintenance", 7)

/*
Station Engineer
*/
/datum/job/fed/engineer
	title = "Ship technician"
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

	outfit = /datum/outfit/job/fed/engineer

	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
									ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_TCOMSAT)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
									ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_TCOMSAT)

/datum/outfit/job/fed/engineer
	name = "Ship technician"
	jobtype = /datum/job/fed/engineer

	belt = /obj/item/storage/belt/utility/full/engi
	l_pocket = /obj/item/device/pda/engineering
	ears = /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/trek/engsec/next
	shoes = /obj/item/clothing/shoes/jackboots
	r_pocket = /obj/item/device/tricorder
	accessory = /obj/item/clothing/accessory/pocketprotector/full

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/engineer
	pda_slot = slot_l_store
	backpack_contents = list(/obj/item/device/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/fed/engineer/pre_equip(mob/living/carbon/human/H)
	..()
	H.skills.add_skill("construction and maintenance", 5)

/*
Chief Medical Officer
*/
/datum/job/fed/cmo
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

	outfit = /datum/outfit/job/fed/cmo

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS)

/datum/outfit/job/fed/cmo
	name = "Surgical Chief"
	jobtype = /datum/job/fed/cmo

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/cmo
	l_pocket = /obj/item/pinpointer/crew
	ears = /obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/trek/medsci/next
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

/datum/outfit/job/fed/cmo/pre_equip(mob/living/carbon/human/H)
	..()
	H.skills.add_skill("medicine", 8)
	H.skills.add_skill("piloting", 3)
//NOTICE: ALL SCIENCE RElATED JOBS/RESEARCH WILL WORK ON STARBASES, ONLY MEDICAL DOCTORS ETC. WILL WORK ON THE SHIPS.


/*
Medical Doctor
*/
/datum/job/fed/doctor
	title = "Doctor"
	flag = DOCTOR
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"

	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/fed/doctor

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CLONING)

/datum/outfit/job/fed/doctor
	name = "Doctor"
	jobtype = /datum/job/fed/doctor

	belt = /obj/item/device/pda/medical
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/trek/medsci/next
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

/datum/outfit/job/fed/doctor/pre_equip(mob/living/carbon/human/H)
	..()
	H.skills.add_skill("medicine", 6)

/*
Research Director
*/
/datum/job/fed/rd
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

	outfit = /datum/outfit/job/fed/rd

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

/datum/outfit/job/fed/rd
	name = "Research Overseer"
	jobtype = /datum/job/fed/rd

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/rd
	ears = /obj/item/device/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/trek/medsci/next
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/clipboard
	l_pocket = /obj/item/device/laser_pointer
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced=1)

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

/*
Scientist
*/
/datum/job/fed/scientist
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

	outfit = /datum/outfit/job/fed/scientist

	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GENETICS)
	minimal_access = list(ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/fed/scientist
	name = "Researcher"
	jobtype = /datum/job/fed/scientist

	belt = /obj/item/device/pda/toxins
	ears = /obj/item/device/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/trek/medsci/next
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/toggle/labcoat/science

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox
	accessory = /obj/item/clothing/accessory/pocketprotector/full

//Warden and regular officers add this result to their get_access()
/datum/job/fed/proc/check_config_for_sec_maint()
	if(CONFIG_GET(flag/security_has_maint_access))
		return list(ACCESS_MAINT_TUNNELS)
	return list()

/*
Head of Security
*/
/datum/job/fed/hos
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

	outfit = /datum/outfit/job/fed/hos

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS)

/datum/outfit/job/fed/hos
	name = "Ship Security Coordinator"
	jobtype = /datum/job/fed/hos

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/hos
	ears = /obj/item/device/radio/headset/heads/hos/alt
	uniform = /obj/item/clothing/under/trek/engsec/next
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/hos/trenchcoat
	gloves = /obj/item/clothing/gloves/color/black/hos
	head = /obj/item/clothing/head/HoS/beret
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	suit_store = /obj/item/gun/energy/e_gun
	r_pocket = /obj/item/device/assembly/flash/handheld
	l_pocket = /obj/item/restraints/handcuffs
	backpack_contents = list(/obj/item/melee/baton/loaded=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield)

/*
Security Officer
*/
/datum/job/fed/officer
	title = "Security Officer"
	flag = OFFICER
	department_head = list("Ship Security Coordinator")
	department_flag = ENGSEC
	faction = "Station"

	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the ship security coordinator, and the head of your assigned department (if applicable)"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/fed/security

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS) //BUT SEE /DATUM/JOB/WARDEN/GET_ACCESS()


/datum/job/fed/officer/get_access()
	var/list/L = list()
	L |= ..() | check_config_for_sec_maint()
	return L

/datum/job/fed/officer/after_spawn(mob/living/carbon/human/H, mob/M)
	// Assign department security
	var/department
	if(M && M.client && M.client.prefs)
		department = M.client.prefs.prefered_security_department
		if(!LAZYLEN(GLOB.available_depts) || department == "None")
			return
		else if(department in GLOB.available_depts)
			LAZYREMOVE(GLOB.available_depts, department)
		else
			department = pick_n_take(GLOB.available_depts)
	var/ears = null
	var/accessory = null
	var/list/dep_access = null
	var/destination = null
	var/spawn_point = null
	switch(department)
		if(SEC_DEPT_SUPPLY)
			ears = /obj/item/device/radio/headset/headset_sec/alt/department/supply
			dep_access = list(ACCESS_MAILSORTING, ACCESS_MINING, ACCESS_MINING_STATION)
			destination = /area/security/checkpoint/supply
			spawn_point = locate(/obj/effect/landmark/start/depsec/supply) in GLOB.department_security_spawns
			accessory = /obj/item/clothing/accessory/armband/cargo
		if(SEC_DEPT_ENGINEERING)
			ears = /obj/item/device/radio/headset/headset_sec/alt/department/engi
			dep_access = list(ACCESS_CONSTRUCTION, ACCESS_ENGINE)
			destination = /area/security/checkpoint/engineering
			spawn_point = locate(/obj/effect/landmark/start/depsec/engineering) in GLOB.department_security_spawns
			accessory = /obj/item/clothing/accessory/armband/engine
		if(SEC_DEPT_MEDICAL)
			ears = /obj/item/device/radio/headset/headset_sec/alt/department/med
			dep_access = list(ACCESS_MEDICAL)
			destination = /area/security/checkpoint/medical
			spawn_point = locate(/obj/effect/landmark/start/depsec/medical) in GLOB.department_security_spawns
			accessory =  /obj/item/clothing/accessory/armband/medblue
		if(SEC_DEPT_SCIENCE)
			ears = /obj/item/device/radio/headset/headset_sec/alt/department/sci
			dep_access = list(ACCESS_RESEARCH)
			destination = /area/security/checkpoint/science
			spawn_point = locate(/obj/effect/landmark/start/depsec/science) in GLOB.department_security_spawns
			accessory = /obj/item/clothing/accessory/armband/science

	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		U.attach_accessory(new accessory)
	if(ears)
		if(H.ears)
			qdel(H.ears)
		H.equip_to_slot_or_del(new ears(H),slot_ears)

	var/obj/item/card/id/W = H.wear_id
	W.access |= dep_access

	var/teleport = 0
	if(!CONFIG_GET(flag/sec_start_brig))
		if(destination || spawn_point)
			teleport = 1
	if(teleport)
		var/turf/T
		if(spawn_point)
			T = get_turf(spawn_point)
			H.Move(T)
		else
			var/safety = 0
			while(safety < 25)
				T = safepick(get_area_turfs(destination))
				if(T && !H.Move(T))
					safety += 1
					continue
				else
					break
	if(department)
		to_chat(M, "<b>You have been assigned to [department]!</b>")
	else
		to_chat(M, "<b>You have not been assigned to any department. Patrol the halls and help where needed.</b>")



/datum/outfit/job/fed/security
	name = "Ship Security Officer"
	jobtype = /datum/job/officer

	belt = /obj/item/device/pda/security
	ears = /obj/item/device/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/trek/engsec/next
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/beret/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/device/assembly/flash/handheld
	suit_store = /obj/item/gun/energy/e_gun/advtaser
	backpack_contents = list(/obj/item/melee/baton/loaded=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield)


/obj/item/device/radio/headset/headset_sec/alt/department/Initialize()
	. = ..()
	wires = new/datum/wires/radio(src)
	secure_radio_connections = new
	recalculateChannels()

/obj/item/device/radio/headset/headset_sec/alt/department/engi
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/headset_sec/alt/department/supply
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_sec/alt/department/med
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/headset_sec/alt/department/sci
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_sci

//When adding new jobs, go to jobs.dm

/datum/job/fed/soldier
	title = "Starfleet Infantry"
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

	outfit = /datum/outfit/job/fed/soldier

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS) //BUT SEE /DATUM/JOB/WARDEN/GET_ACCESS()

/datum/outfit/job/fed/soldier
	name = "Starfleet Infantry"
	jobtype = /datum/job/fed/soldier

	belt = /obj/item/device/pda/security
	ears = /obj/item/device/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/trek/engsec/next
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

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/soldier/post_equip(mob/living/carbon/human/H)
	if(prob(5)) //5% chance to be a legendary soldier
//		H.add_skill(110, rand(60, 68), rand(24, 32), ..(), ..())
		to_chat(H, "<big>You are a legendary soldier! You've had some experience, and are well versed in the arts of close-quarters combat.</big>")
		return
	else
//		H.add_skill(rand(60, 66), rand(60, 68), rand(24, 32), ..(), ..())

/datum/job/fed/pilot
	title = "Ship Helmsman"
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

/datum/outfit/job/fed/pilot
	name = "Ship Helmsman"
	jobtype = /datum/job/pilot

	id = /obj/item/card/id
	belt = /obj/item/device/pda
	ears = /obj/item/device/radio/headset
	uniform = /obj/item/clothing/under/trek/engsec/next
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/fed/pilot/post_equip(mob/living/carbon/human/H)
	H.skills.add_skill("pilot", 7)
