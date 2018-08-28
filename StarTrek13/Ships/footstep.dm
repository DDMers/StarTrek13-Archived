//Ported and modified from: https://github.com/Baystation12/Baystation12/blob/2297ebd06c3831d191d4c14745396595a0b48e35/code/game/turfs/open/footsteps.dm//


#define FOOTSTEP_CARPET 	"carpet"
#define FOOTSTEP_TILES 		"tiles"
#define FOOTSTEP_PLATING 	"plating"
#define FOOTSTEP_WOOD 		"wood"
#define FOOTSTEP_ASTEROID 	"asteroid"
#define FOOTSTEP_GRASS 		"grass"
#define FOOTSTEP_WATER		"water"
#define FOOTSTEP_BLANK		"blank"
#define FOOTSTEP_CATWALK	"catwalk"
#define FOOTSTEP_LAVA		"lava"

/turf/open/floor/var/global/list/footstep_sounds = list(
	FOOTSTEP_WOOD = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'),
	FOOTSTEP_TILES = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'),
	FOOTSTEP_PLATING =  list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'),
	FOOTSTEP_CARPET = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'),
	FOOTSTEP_ASTEROID = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'),
	FOOTSTEP_GRASS = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'),
	FOOTSTEP_WATER = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'),
	FOOTSTEP_LAVA = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'),
	FOOTSTEP_BLANK = list(
		'sound/effects/footstep/blank.ogg')
)

/turf/open/floor/proc/get_footstep_sound()
	if(istype(src, /turf/open/floor/plating))
		return safepick(footstep_sounds[FOOTSTEP_PLATING])

/turf/open/floor/asteroid/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_ASTEROID])

/turf/open/floor/fixed/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_PLATING])

/turf/open/floor/borg/trek/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_CARPET])

/turf/open/floor/Entered(var/mob/living/carbon/human/H)
	..()
	if(istype(H))
		var/footsound = get_footstep_sound()
		playsound(src, footsound, 50, 1, 5)