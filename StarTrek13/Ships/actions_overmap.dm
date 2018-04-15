/datum/action/innate/exit
	name = "Exit ship"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "exit"
	var/obj/structure/overmap/ship

/datum/action/innate/exit/Activate()
	ship.exit()

#define FIRE_PHASER 1
#define FIRE_PHOTON 2

/datum/action/innate/weaponswitch
	name = "Switch weapon"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "phaser"
	var/obj/structure/overmap/ship
	var/selected = 1

/datum/action/innate/weaponswitch/Trigger()
	ship.AltClick(ship.pilot)
	switch(ship.fire_mode)
		if(1)
			button_icon_state = "phaser"
		if(2)
			button_icon_state = "photon"


/datum/action/innate/subsystemtarget
	name = "Target a subsystem"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "subsystemtarget"
	var/obj/structure/overmap/ship

/datum/action/innate/subsystemtarget/Trigger()
	ship.target_subsystem(ship.pilot)

/datum/action/innate/warp
	name = "Engage warp drive"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "warp"
	var/obj/structure/overmap/ship

/datum/action/innate/warp/Activate()
	//ship.exit()
	return //Not finished with this yet...

/datum/action/innate/stopfiring
	name = "Disengage weapons lock"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "stopfiring"
	var/obj/structure/overmap/ship

/datum/action/innate/stopfiring/Activate()
	ship.stop_firing()

/datum/action/innate/redalert
	name = "Toggle red alert"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "redalert"
	var/obj/structure/overmap/ship

/datum/action/innate/redalert/Activate()
	ship.weapons.redalert()

/datum/action/innate/autopilot
	name = "Engage autopilot"
	icon_icon = 'StarTrek13/icons/actions/overmap_ui.dmi'
	button_icon_state = "autopilot"
	var/obj/structure/overmap/ship

/datum/action/innate/autopilot/Activate()
	ship.set_nav_target(ship.pilot)

//input_warp_target(user)



/obj/structure/overmap/proc/GrantActions()
	//dont need jump cam action
	if(exit_action)
		exit_action.target = pilot
		exit_action.Grant(pilot)
		exit_action.ship = src

	if(weaponswitch)
		weaponswitch.target = pilot
		weaponswitch.Grant(pilot)
		weaponswitch.ship = src

	if(systemtargeter)
		systemtargeter.target = pilot
		systemtargeter.Grant(pilot)
		systemtargeter.ship = src

	if(warp_action)
		warp_action.target = pilot
		warp_action.Grant(pilot)
		warp_action.ship = src


	if(stopfiring_action)
		stopfiring_action.target = pilot
		stopfiring_action.Grant(pilot)
		stopfiring_action.ship = src


	if(redalert_action)
		redalert_action.target = pilot
		redalert_action.Grant(pilot)
		redalert_action.ship = src


	if(autopilot_action)
		autopilot_action.target = pilot
		autopilot_action.Grant(pilot)
		autopilot_action.ship = src


/obj/structure/overmap/proc/RemoveActions()
	//dont need jump cam action
	if(exit_action)
		exit_action.target = null
		exit_action.Remove(pilot)
	if(warp_action)
		warp_action.target = null
		warp_action.Remove(pilot)
	if(stopfiring_action)
		stopfiring_action.target = null
		stopfiring_action.Remove(pilot)
	if(redalert_action)
		redalert_action.target = null
		redalert_action.Remove(pilot)
	if(autopilot_action)
		autopilot_action.target = null
		autopilot_action.Remove(pilot)
	if(weaponswitch)
		weaponswitch.target = null
		weaponswitch.Remove(pilot)
	if(systemtargeter)
		systemtargeter.target = null
		systemtargeter.Remove(pilot)