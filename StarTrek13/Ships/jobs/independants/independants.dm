/*
Assistant
*/
/datum/job/ind/crewman
	title = "Crewman"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "all other crew members of higher rank."
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/ind/crewman


/datum/job/ind/crewman/get_access()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/outfit/job/ind/crewman
	name = "Crewman"
	jobtype = /datum/job/ind/crewman

	id = /obj/item/card/id
	belt = /obj/item/device/pda
	gloves = /obj/item/clothing/gloves/color/black
	uniform =  /obj/item/clothing/under/independant
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag



//ADD SPAWNS FOR THE NEW JOBS!
/*
Captain
*/
/datum/job/ind/captain
	title = "Independant Captain"
	flag = CAPTAIN
	department_head = list("Nobody")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3 //3 is a round number, change it with testing data.
	spawn_positions = 3
	supervisors = "Space law"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW		//There will be multiple captains in one round

	outfit = /datum/outfit/job/ind/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/ind/captain/get_access()
	return get_all_accesses()

/datum/job/ind/captain/announce(mob/living/carbon/human/H)
	..()
//	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))
/datum/outfit/job/ind/captain
	name = "Independant Captain"
	jobtype = /datum/job/ind/captain

	id = /obj/item/card/id/gold
	belt = /obj/item/device/pda/captain
	ears = /obj/item/device/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/black
	uniform =  /obj/item/clothing/under/independant/captain
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/ind/captain/post_equip(mob/living/carbon/human/H)
	H.add_skills(rand(40, 59), rand(60, 70), rand(0, 28), rand(0, 28), rand(50, 65))


/*
Head of Personnel
*/
/datum/job/ind/firstofficer
	title = "Independant First Officer"
	flag = HOP
	department_head = list("Captain")
	department_flag = CIVILIAN
	head_announce = list("Supply", "Service")
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SUPPLY

	outfit = /datum/outfit/job/ind/firstofficer

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


/datum/outfit/job/ind/firstofficer
	name = "Independant First officer"
	jobtype = /datum/job/ind/firstofficer

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/hop
	ears = /obj/item/device/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/independant
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(/obj/item/storage/box/ids=1,\
		/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced = 1,/obj/item/device/tricorder)

/datum/outfit/job/ind/firstofficer/post_equip(mob/living/carbon/human/H)
	H.add_skills(rand(40, 59), rand(60, 70), rand(0, 28), rand(0, 28), rand(50, 65))
	..()

/*
Shaft Miner
*/
/datum/job/ind/mining
	title = "Miner"
	flag = MINER
	department_head = list("First officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the captain"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/ind/miner

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/ind/miner
	name = "Miner (lavaland)"
	jobtype = /datum/job/ind/mining

	belt = /obj/item/device/pda/shaftminer
	ears = /obj/item/device/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/independant
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

/datum/outfit/job/ind/miner/asteroid
	name = "Miner (Asteroid)"
	uniform = /obj/item/clothing/under/independant
	shoes = /obj/item/clothing/shoes/workboots

/datum/outfit/job/ind/miner/equipped
	name = "Miner (Lavaland + Equipment)"
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

/datum/outfit/job/ind/miner/equipped/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	if(istype(H.wear_suit, /obj/item/clothing/suit/hooded))
		var/obj/item/clothing/suit/hooded/S = H.wear_suit
		S.ToggleHood()

/datum/outfit/job/ind/miner/equipped/asteroid
	name = "Shaft Miner (Asteroid + Equipment)"
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/suit/space/hardsuit/mining
	mask = /obj/item/clothing/mask/breath


//Due to how large this one is it gets its own file
/*
Chaplain
*/
/datum/job/ind/chaplain
	title = "Preacher"
	flag = CHAPLAIN
	department_head = list("First Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your diety, and your captain"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/ind/chaplain

	access = list(ACCESS_MORGUE, ACCESS_CHAPEL_OFFICE, ACCESS_CREMATORIUM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_MORGUE, ACCESS_CHAPEL_OFFICE, ACCESS_CREMATORIUM, ACCESS_THEATRE)

/datum/job/ind/chaplain/after_spawn(mob/living/H, mob/M)
	if(H.mind)
		H.mind.isholy = TRUE

	var/obj/item/storage/book/bible/booze/B = new

	if(SSreligion.religion)
		B.deity_name = SSreligion.deity
		B.name = SSreligion.bible_name
		B.icon_state = SSreligion.bible_icon_state
		B.item_state = SSreligion.bible_item_state
		to_chat(H, "There is already an established religion onboard the station. You are an acolyte of [SSreligion.deity]. Defer to the Chaplain.")
		H.equip_to_slot_or_del(B, slot_in_backpack)
		var/nrt = SSreligion.holy_weapon_type || /obj/item/nullrod
		var/obj/item/nullrod/N = new nrt(H)
		H.put_in_hands(N)
		return

	var/new_religion = "Christianity"
	if(M.client && M.client.prefs.custom_names["religion"])
		new_religion = M.client.prefs.custom_names["religion"]

	var/new_deity = "Space Jesus"
	if(M.client && M.client.prefs.custom_names["deity"])
		new_deity = M.client.prefs.custom_names["deity"]

	B.deity_name = new_deity


	switch(lowertext(new_religion))
		if("christianity")
			B.name = pick("The Holy Bible","The Dead Sea Scrolls")
		if("satanism")
			B.name = "The Unholy Bible"
		if("cthulu")
			B.name = "The Necronomicon"
		if("islam")
			B.name = "Quran"
		if("scientology")
			B.name = pick("The Biography of L. Ron Hubbard","Dianetics")
		if("chaos")
			B.name = "The Book of Lorgar"
		if("imperium")
			B.name = "Uplifting Primer"
		if("toolboxia")
			B.name = "Toolbox Manifesto"
		if("homosexuality")
			B.name = "Guys Gone Wild"
		if("lol", "wtf", "gay", "penis", "ass", "poo", "badmin", "shitmin", "deadmin", "cock", "cocks", "meme", "memes")
			B.name = pick("Woodys Got Wood: The Aftermath", "War of the Cocks", "Sweet Bro and Hella Jef: Expanded Edition")
			H.setBrainLoss(100) // starts off retarded as fuck
		if("science")
			B.name = pick("Principle of Relativity", "Quantum Enigma: Physics Encounters Consciousness", "Programming the Universe", "Quantum Physics and Theology", "String Theory for Dummies", "How To: Build Your Own Warp Drive", "The Mysteries of Bluespace", "Playing God: Collector's Edition")
		else
			B.name = "The Holy Book of [new_religion]"

	SSreligion.religion = new_religion
	SSreligion.bible_name = B.name
	SSreligion.deity = B.deity_name

	H.equip_to_slot_or_del(B, slot_in_backpack)

	SSblackbox.record_feedback("text", "religion_name", 1, "[new_religion]", 1)
	SSblackbox.record_feedback("text", "religion_deity", 1, "[new_deity]", 1)


/datum/outfit/job/ind/chaplain
	name = "Preacher"
	jobtype = /datum/job/ind/chaplain

	belt = /obj/item/device/pda/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain
	backpack_contents = list(/obj/item/device/camera/spooky = 1)
	accessory = /obj/item/clothing/accessory/pocketprotector/cosmetology
	backpack = /obj/item/storage/backpack/cultpack
	satchel = /obj/item/storage/backpack/cultpack

/*
Chief Engineer
*/
/datum/job/ind/chief_engineer
	title = "Engineering Officer"
	flag = CHIEF
	department_head = list("Captain")
	department_flag = ENGSEC
	head_announce = list("Engineering")
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the captain"
	selection_color = "#ffeeaa"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_ENGINEERING

	outfit = /datum/outfit/job/ind/ce

	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
			            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_MINISAT,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
			            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_MINISAT,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)

/datum/outfit/job/ce
	name = "Engineering Officer"
	jobtype = /datum/job/ind/chief_engineer

	id = /obj/item/card/id/silver
	belt = /obj/item/storage/belt/utility/chief/full
	l_pocket = /obj/item/device/pda/heads/ce
	ears = /obj/item/device/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/independant
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black/ce
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced=1,/obj/item/device/tricorder)

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/engineer
	pda_slot = slot_l_store

/datum/outfit/job/ind/ce/rig
	name = "Engineering Officer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine/elite
	shoes = /obj/item/clothing/shoes/magboots/advance
	suit_store = /obj/item/tank/internals/oxygen
	gloves = /obj/item/clothing/gloves/color/yellow
	head = null
	internals_slot = slot_s_store

/datum/outfit/job/ind/ce/pre_equip(mob/living/carbon/human/H)
	..()
	H.add_skills(..(), ..(), ..(), rand(60, 90), 25)

/*
Chief Medical Officer
*/
/datum/job/ind/cmo
	title = "Medical Officer"
	flag = CMO_JF
	department_head = list("Captain")
	department_flag = MEDSCI
	head_announce = list("Medical")
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the captain"
	selection_color = "#ffddf0"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_MEDICAL

	outfit = /datum/outfit/job/ind/cmo

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS)

/datum/outfit/job/ind/cmo
	name = "Medical Officer"
	jobtype = /datum/job/cmo

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/cmo
	l_pocket = /obj/item/pinpointer/crew
	ears = /obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/independant
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

/datum/outfit/job/ind/cmo/pre_equip(mob/living/carbon/human/H)
	..()
	H.add_skills(rand(10, 25), rand(10, 25), rand(60, 80), rand(10, 25), rand(25, 45))
//NOTICE: ALL SCIENCE RElATED JOBS/RESEARCH WILL WORK ON STARBASES, ONLY MEDICAL DOCTORS ETC. WILL WORK ON THE SHIPS.


/*
Research Director
*/
/datum/job/ind/rd
	title = "Science Officer"
	flag = RD_JF
	department_head = list("Captain")
	department_flag = MEDSCI
	head_announce = list("Science")
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the captain"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_type_department = EXP_TYPE_SCIENCE
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/ind/rd

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

/datum/outfit/job/ind/rd
	name = "Science Officer"
	jobtype = /datum/job/ind/rd

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/rd
	ears = /obj/item/device/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/independant
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/clipboard
	l_pocket = /obj/item/device/laser_pointer
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced=1)

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

/datum/outfit/job/ind/rd/rig
	name = "Science Officer (Hardsuit)"

	l_hand = null
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/rd
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = slot_s_store

/*
Head of Security
*/
/datum/job/ind/hos
	title = "Tactical Officer"
	flag = HOS
	department_head = list("Captain")
	department_flag = ENGSEC
	head_announce = list("Security")
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the captain"
	selection_color = "#ffdddd"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/ind/hos

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS)

/datum/outfit/job/ind/hos
	name = "Tactical Officer"
	jobtype = /datum/job/ind/hos

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/hos
	ears = /obj/item/device/radio/headset/heads/hos/alt
	uniform = /obj/item/clothing/under/independant/captain
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


/datum/job/ind/enforcer
	title = "Enforcer"
	flag = SOLDIER
	department_head = list("captain")
	department_flag = ENGSEC
	faction = "Station"
//	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
//	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the captain."
	selection_color = "#ffeeee"
	minimal_player_age = 3
	exp_requirements = 100
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/ind/enforcer

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS) //BUT SEE /DATUM/JOB/WARDEN/GET_ACCESS()

/datum/outfit/job/ind/enforcer
	name = "enforcer"
	jobtype = /datum/job/ind/enforcer

	belt = /obj/item/device/pda/security
	ears = /obj/item/device/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/independant/captain
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/beret/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	suit_store = /obj/item/gun/ballistic/automatic/pistol/APS
	r_pocket = /obj/item/ammo_box/magazine/pistolm9mm
	l_pocket = /obj/item/ammo_box/magazine/pistolm9mm
	backpack_contents = list(/obj/item/melee/baton/loaded=1, /obj/item/kitchen/knife/combat=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/ind/soldier/post_equip(mob/living/carbon/human/H)
	if(prob(10)) //10% chance to be a special security coordinator
		H.add_skills(110, rand(60, 68), rand(24, 32), ..(), ..())
		to_chat(H, "<big>You are a specialized enforcer! You've had some experience, and are well versed in the arts of close-quarters combat and ranged combat.</big>")
		name = "Specialized Security Coordinator"
		return
	else
		H.add_skills(rand(60, 66), rand(60, 68), rand(24, 32), ..(), ..())

/datum/job/ind/pilot
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

	outfit = /datum/outfit/job/ind/pilot

//	access = list()
//	minimal_access = list()

/datum/outfit/job/ind/pilot
	name = "Helmsman"
	jobtype = /datum/job/ind/pilot

	id = /obj/item/card/id
	belt = /obj/item/device/pda
	ears = /obj/item/device/radio/headset
	uniform = /obj/item/clothing/under/independant
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/ind/pilot/post_equip(mob/living/carbon/human/H)
	H.add_skills(rand(10, 25), rand(10, 25), rand(45, 60), rand(10, 25), rand(55, 110))
