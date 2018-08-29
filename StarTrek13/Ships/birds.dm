//////////////////////////////////////////////////////////////////////////
// Credit to haine from goonstation for this, they're really nice birds!//
//////////////////////////////////////////////////////////////////////////

/obj/effect/landmark/bird_spawner
	name = "bird spawning device"

/obj/effect/landmark/bird_spawner/Initialize()
	. = ..()
	var/mob/living/simple_animal/bird/B = pick(subtypesof(/mob/living/simple_animal/bird))
	new B(get_turf(src))

/mob/living/simple_animal/bird
	name = "parrot"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "parrot"
	icon_living = "parrot"
	icon_dead = "parrot-dead"
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	speak = list("Skraa!","Chirp!","Bwaak bwak.")
	speak_emote = list("squawks","chirrups")
	emote_hear = list("squawks.")
	emote_see = list("ruffles its feathers.","flaps its wings.")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "thwacks"
	ventcrawler = VENTCRAWLER_ALWAYS
	health = 30
	maxHealth = 30
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	gold_core_spawnable = FRIENDLY_SPAWN
	//© Haine


/mob/living/simple_animal/bird/Life()
	. = ..()
	if(prob(20))
		visible_message("[src] flaps its wings")
		icon_state = "[icon_living]-flap"
		sleep(30)
		icon_state = initial(icon_state)
	//© Haine

/mob/living/simple_animal/bird/kea
	name = "kea"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "kea"
	icon_living = "kea"
	icon_dead = "kea-dead"
	//© Haine

/mob/living/simple_animal/bird/eclectus
	name = "eclectus"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "eclectus"
	icon_living = "eclectus"
	icon_dead = "eclectus-dead"
	//© Haine

/mob/living/simple_animal/bird/eclectus/female
	name = "eclectus"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "eclectusf"
	icon_living = "eclectusf"
	icon_dead = "eclectusf-dead"
	//© Haine

/mob/living/simple_animal/bird/grey
	name = "african grey parrot"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "agrey"
	icon_living = "agrey"
	icon_dead = "agrey-dead"
	emote_see = list("stares inquisitively.","flaps its wings.")
	//© Haine

/mob/living/simple_animal/bird/caique
	name = "caique"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "bcaique"
	icon_living = "bcaique"
	icon_dead = "bcaique-dead"
	//© Haine

/mob/living/simple_animal/bird/caique/white
	name = "caique"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "wcaique"
	icon_living = "wcaique"
	icon_dead = "wcaique-dead"
	//© Haine

/mob/living/simple_animal/bird/budgie
	name = "budgie"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "gbudge"
	icon_living = "gbudge"
	icon_dead = "gbudge-dead"
	//© Haine

/mob/living/simple_animal/bird/budgie/blue
	name = "budgie"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "bbudge"
	icon_living = "bbudge"
	icon_dead = "bbudge-dead"
	//© Haine

/mob/living/simple_animal/bird/budgie/bluegreen
	name = "budgie"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "bgbudge"
	icon_living = "bgbudge"
	icon_dead = "bgbudge-dead"
	//© Haine

/mob/living/simple_animal/bird/tiel
	name = "cockatiel"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "tiel"
	icon_living = "tiel"
	icon_dead = "tiel-dead"

/mob/living/simple_animal/bird/tiel/white
	name = "cockatiel"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "wtiel"
	icon_living = "wtiel"
	icon_dead = "wtiel-dead"

/mob/living/simple_animal/bird/tiel/white/alt
	name = "cockatiel"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "luttiel"
	icon_living = "luttiel"
	icon_dead = "luttiel-dead"

/mob/living/simple_animal/bird/tiel/white/wblue
	name = "cockatiel"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "blutiel"
	icon_living = "blutiel"
	icon_dead = "blutiel-dead"

/mob/living/simple_animal/bird/too
	name = "sulphur crested cockatoo"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "too"
	icon_living = "too"
	icon_dead = "too-dead"

/mob/living/simple_animal/bird/too/umbrella
	name = "umbrella cockatoo"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "utoo"
	icon_living = "utoo"
	icon_dead = "utoo-dead"

/mob/living/simple_animal/bird/too/mollucan
	name = "mollucan cockatoo"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "mtoo"
	icon_living = "mtoo"
	icon_dead = "mtoo-dead"

/mob/living/simple_animal/bird/toucan
	name = "toucan"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "toucan"
	icon_living = "toucan"
	icon_dead = "toucan-dead"

/mob/living/simple_animal/bird/toucan/technicolour
	name = "technicolour toucan"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "kbtoucan"
	icon_living = "kbtoucan"
	icon_dead = "kbtoucan-dead"

/mob/living/simple_animal/bird/space
	name = "astro-bird"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "space"
	icon_living = "space"
	icon_dead = "space-dead"

/mob/living/simple_animal/bird/ikea
	name = "ikea"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "ikea"
	icon_living = "ikea"
	icon_dead = "ikea-dead"

/mob/living/simple_animal/hostile/retaliate/bird
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "savages"
	attack_sound = 'sound/weapons/bite.ogg'

/mob/living/simple_animal/hostile/retaliate/bird/goose
	name = "goose"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose-dead"

/mob/living/simple_animal/hostile/retaliate/bird/swan
	name = "swan"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "swan"
	icon_living = "swan"
	icon_dead = "swan-dead"

/mob/living/simple_animal/hostile/retaliate/bird/seagull
	name = "seagull"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "gull"
	icon_living = "gull"
	icon_dead = "gull-dead"

/mob/living/simple_animal/bird/owl
	name = "owl"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "owl"
	icon_living = "owl"
	icon_dead = "owl-dead"

/mob/living/simple_animal/bird/owl/chick
	name = "owl chick"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "smallowl"
	icon_living = "smallowl"
	icon_dead = "smallowl-dead"

/mob/living/simple_animal/bird/owl/tawny
	name = "tawny owl"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "hooty"
	icon_living = "hooty"
	icon_dead = "hooty-dead"

/mob/living/simple_animal/bird/lovebird
	name = "lovebird"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "love"
	icon_living = "love"
	icon_dead = "love-dead"

/mob/living/simple_animal/bird/lovebird/yellow
	name = "lovebird"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "lovey"
	icon_living = "lovey"
	icon_dead = "lovey-dead"

/mob/living/simple_animal/bird/lovebird/multi
	name = "lovebird"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "lovem"
	icon_living = "lovem"
	icon_dead = "lovem-dead"

/mob/living/simple_animal/bird/lovebird/blue
	name = "lovebird"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "loveb"
	icon_living = "loveb"
	icon_dead = "loveb-dead"

/mob/living/simple_animal/bird/lovebird/alt
	name = "lovebird"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "lovef"
	icon_living = "lovef"
	icon_dead = "lovef-dead"

/mob/living/simple_animal/bird/crow
	name = "crow"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "crow"
	icon_living = "crow"
	icon_dead = "crow-dead"

/mob/living/simple_animal/bird/gannet
	name = "gannet"
	icon = 'StarTrek13/icons/goon/bird.dmi'
	icon_state = "gannet"
	icon_living = "gannet"
	icon_dead = "gannet-dead"
	//© Gannets

/mob/living/simple_animal/bird/huge
	name = "macaw"
	icon = 'StarTrek13/icons/goon/bigbird.dmi'
	icon_state = "parrot"
	icon_living = "parrot"
	icon_dead = "parrot-dead"

/mob/living/simple_animal/bird/huge/macaw
	name = "scarlet macaw"
	icon = 'StarTrek13/icons/goon/bigbird.dmi'
	icon_state = "smacaw"
	icon_living = "smacaw"
	icon_dead = "smacaw-dead"

/mob/living/simple_animal/bird/huge/macaw/blue
	name = "scarlet macaw"
	icon = 'StarTrek13/icons/goon/bigbird.dmi'
	icon_state = "bmacaw"
	icon_living = "bmacaw"
	icon_dead = "bmacaw-dead"

/mob/living/simple_animal/bird/huge/macaw/military
	name = "military macaw"
	icon = 'StarTrek13/icons/goon/bigbird.dmi'
	icon_state = "mmacaw"
	icon_living = "mmacaw"
	icon_dead = "mmacaw-dead"

/mob/living/simple_animal/bird/huge/macaw/hyacinth
	name = "hyacinth macaw"
	icon = 'StarTrek13/icons/goon/bigbird.dmi'
	icon_state = "hmacaw"
	icon_living = "hmacaw"
	icon_dead = "hmacaw-dead"