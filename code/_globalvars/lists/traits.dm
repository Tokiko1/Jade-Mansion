
//GLOBAL_LIST_INIT(traitlistpaged, list("page1" = TRAIT_LIST1, "page2" = TRAIT_LIST2))

//So you want to make a new trait? Not too difficult!
//Simply add it to the list below.
//If it's a trait that is meant to process constantly, like to check for a condition, make a datum/trait and put its type under "active"
//If it's a static thing that other stuff checks, no need for this
//If this is a trait that is meant to grant an ability or give out an ability at roundstart, handle it in /datum/controller/subsystem/ticker/proc/handle_join_traits() in trait_roundstarts.dm
//Don't put too many traits on a page or stuff might crash on slower computers, and will be annoying to scroll through.
//If you need a new page, number it properly and the game will handle everything else automatically.

//Where are all the trait related files?

//subsystem/traits_roundstarts.dm
//This is where items and abilities associated with traits are given out and where active traits are assigned
//client/traits.dm
//The trait menu.
//modules/traits/processingtraits.dm
//This is where active traits that process stuff are.
//modules/traits/traitabilities.dm
//Here are abilities that are given by traits.
//modules/traits/traititems.dm
//Here are items that are given by traits.
//_globalvars/lists/traits.dm
//This file here.


GLOBAL_LIST_INIT(traitlistpaged, list(
"page1" = list(
"Afraid of Darkness" = list("tname" = "Afraid of Darkness", "tdesc" = "You don't like darkness at all. It scares you and sometimes odd things happen...", "tcost" = -1, "tnotes" = null, "active" = /datum/trait/afraid_of_darkness),
"Injury Dislike" = list("tname" = "Injury Dislike", "tdesc" = "Just looking at injuries makes you feel awful, even if they aren't yours.", "tcost" = -1, "tnotes" = null, "active" = /datum/trait/injury_dislike),
"Trouble Maker" = list("tname" = "Trouble Maker", "tdesc" = "You get a lot of bad ideas.", "tcost" = 1, "tnotes" = null, "active" = null),
"Clumsy Hands" = list("tname" = "Clumsy Hands", "tdesc" = "You are pretty clumsy. Sometimes, you will mess up when doing things that require precision.", "tcost" = 0, "tnotes" = null, "active" = null),
"Cleaning Obsession" = list("tname" = "Cleaning Obsession", "tdesc" = "You hate seeing dirt. It brings down your mood.", "tcost" = -2, "tnotes" = null, "active" = /datum/trait/neat_freak),
"Positive" = list("tname" = "Positive", "tdesc" = "Your thinking is more positive than usual and your average mood is better.", "tcost" = 2, "tnotes" = null, "active" = /datum/trait/positive),
"Near Sighted" = list("tname" = "Near Sighted", "tdesc" = "Your vision is pretty bad without glasses.", "tcost" = -1, "tnotes" = "You start with a pair of glasses.", "active" = null),
"Bad Luck" = list("tname" = "Bad Luck", "tdesc" = "You seem to attract bad events a lot. You have really bad luck. You are more likely to be the victim of fluff objectives.", "tcost" = 0, "tnotes" = null, "active" = null),
"Glutton" = list("tname" = "Glutton", "tdesc" = "You love eating. A lot! You will feel bad if you aren't overeating.", "tcost" = -1, "tnotes" = null, "active" = /datum/trait/glutton),
"Shaky" = list("tname" = "Shaky", "tdesc" = "For some reason, your hands shake a lot. Maybe it's an illness or maybe you are just nervous. You'll end up dropping a lot of things.", "tcost" = -1, "tnotes" = null, "active" = /datum/trait/shaky)
),
"page2" = list(
"Narcolepsy" = list("tname" = "Narcolepsy", "tdesc" = "You have an illness that randomly makes you fall asleep. It gets worse if you are in a bad mood.", "tcost" = -4, "tnotes" = null, "active" = /datum/trait/narcolepsy),
"Oni Liver" = list("tname" = "Oni Liver", "tdesc" = "For some reason, you have the liver of an oni. You need to drink far more to get drunk, and when you are, you get sober much faster.", "tcost" = 2, "tnotes" = null, "active" = /datum/trait/oni_liver),
"Master Chemist" = list("tname" = "Master Chemist", "tdesc" = "You have worked a lot with chemicals. Just looking at a liquid allows you to tell what's inside.", "tcost" = 1, "tnotes" = "This does not apply to liquids in opaque containers.", "active" = null),
"Red Sparrow CQC" = list("tname" = "Red Sparrow CQC", "tdesc" = "For whatever reason, you know Red Sparrow CQC. This combat style is pragmatic and non-lethal. A good choice for bodyguards.", "tcost" = 5, "tnotes" = null, "active" = null),
"Maid Fashion Obsession" = list("tname" = "Maid Fashion Obsession", "tdesc" = "You love maid fashion! So much that not wearing them makes you upset, even if you are not staff.", "tcost" = -2, "tnotes" = "A full uniform includes any of the uniforms, any type of shoe and one of the maid headdresses.", "active" = /datum/trait/maidfashion),
"Combat Clothes" = list("tname" = "Combat Clothes", "tdesc" = "Your starting clothes are armored.", "tcost" = 1, "tnotes" = null, "active" = null),
"Poison Sting" = list("tname" = "Poison Sting", "tdesc" = "Through some bizzare mutation, you have a stealthy poison stinger that can inject weakening poison into others.", "tcost" = 3, "tnotes" = null, "active" = null),
"Heavy Bag" = list("tname" = "Heavy Bag", "tdesc" = "You start with a bag for carrying a lot of items. It slows you down however.", "tcost" = 1, "tnotes" = null, "active" = null),
"Criminal Ties" = list("tname" = "Criminal Ties", "tdesc" = "You have ties to the main criminal organizations in this area.", "tcost" = 0, "tnotes" = null, "active" = null),
"Spider Web Glands" = list("tname" = "Spider Web Glands", "tdesc" = "A special mutation in your stomach allows you to spit webs. It makes you very hungry however.", "tcost" = 2, "tnotes" = null, "active" = null)
),

"page3" = list(
"Maid Box Lunch" = list("tname" = "Maid Box Lunch", "tdesc" = "You start with a special magical lunchbox that never runs out. However, only you can eat from it.", "tcost" = 1, "tnotes" = null, "active" = null),
"Mind Shock" = list("tname" = "Mind Shock", "tdesc" = "You have gained strange telepathic powers, but you have only learned to use them for pranks. Confuses nearby people.", "tcost" = 1, "tnotes" = null, "active" = null),
"Strong Fate" = list("tname" = "Strong Fate", "tdesc" = "It seems that fate likes to play with you. Random fluff events that involve you tend to be more extreme than usual, both good and bad.", "tcost" = 1, "tnotes" = null, "active" = null),
"Weak Fate" = list("tname" = "Weak Fate", "tdesc" = "Fate seems to ignore you. Random fluff events involving you are usually less intense, both good and bad.", "tcost" = 0, "tnotes" = null, "active" = null),
"Hardy" = list("tname" = "Hardy", "tdesc" = "Your body is stronger than usual. +25 HP", "tcost" = 1, "tnotes" = null, "active" = null),
"Frail" = list("tname" = "Frail", "tdesc" = "Your body is frail. -30 HP", "tcost" = -1, "tnotes" = null, "active" = null)


)






))

GLOBAL_LIST_EMPTY(alltraits)
GLOBAL_LIST_INIT(random_traits_presets, list())