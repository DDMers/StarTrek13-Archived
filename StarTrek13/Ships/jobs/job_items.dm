////INDEPENDANT UNIFORMS////
/obj/item/clothing/under/independant
	name = "standard fatigues"
	desc = "Your standard fatigues. Hardly even a uniform.."
//	icon = 'StarTrek13/icons/trek/uniform.dmi'
	icon_state = "independant"
	item_state = "bl_suit"
	item_color = "independant"
	can_adjust = FALSE

/obj/item/clothing/under/independant/captain
	name = "captain's fatigues"
	desc = "A captain's fatigues. These are slightly armored."
	icon_state = "independant2"
	item_state = "bl_suit"
	item_color = "independant2"
	armor = list(melee = 10, bullet = 5, laser = 0,energy = 5, bomb = 5, bio = 0, rad = 0, fire = 0, acid = 0)

/obj/item/clothing/under/romulan
	name = "romulan uniform"
	desc = "Worn by the rank and file members of the romulan military"
	icon = 'StarTrek13/icons/trek/uniforms.dmi'
	alternate_worn_icon = 'StarTrek13/icons/trek/uniform.dmi'
	icon_state = "romulan"
	item_state = "bl_suit"
	item_color = "romulan"
	can_adjust = FALSE