#define TRAIT_1 list("tname" = "Test Trait 1", "tdesc" = "This is the description text.", "tcost" = 1, "tnotes" = null)
#define TRAIT_2 list("tname" = "Test Trait 2", "tdesc" = "This is the description text number 2!.", "tcost" = 2, "tnotes" = "This is a note.")
#define TRAIT_3 list("tname" = "Test Trait 3", "tdesc" = "This is the description text number 3!.", "tcost" = -1, "tnotes" = "This is a note too.")


#define TRAIT_LIST1 list( "Test Trait 1" = TRAIT_1, "Test Trait 2" = TRAIT_2)
#define TRAIT_LIST2 list( "Test Trait 3" = TRAIT_3)

//GLOBAL_LIST_INIT(traitlistpaged, list("page1" = TRAIT_LIST1, "page2" = TRAIT_LIST2))

GLOBAL_LIST_INIT(traitlistpaged, list(
"page1" = list(
"Afraid of Darkness" = list("tname" = "Afraid of Darkness", "tdesc" = "You don't like darkness at all. It scares you and sometimes odd things happen...", "tcost" = -1, "tnotes" = null),
"Rampage" = list("tname" = "Rampage", "tdesc" = "You are a violent person. Mental breaks from your character are more likely to involve fighting", "tcost" = 1, "tnotes" = null),
"Stalker" = list("tname" = "Stalker", "tdesc" = "Sometimes you pick a person and obsess over them. Makes you more likely to get a stalking related fluff objective.", "tcost" = 1, "tnotes" = null),
"Clumsy Hands" = list("tname" = "Clumsy Hands", "tdesc" = "You are pretty clumsy. Sometimes, you will mess up when doing things that require precision.", "tcost" = -1, "tnotes" = null),
"Cleaning Obsession" = list("tname" = "Cleaning Obsession", "tdesc" = "You hate seeing dirt. It brings down your mood.", "tcost" = -2, "tnotes" = null),
"Positive" = list("tname" = "Positive", "tdesc" = "Your thinking is more positive than usual and your average mood is better.", "tcost" = 2, "tnotes" = null),
"Near Sighted" = list("tname" = "Near Sighted", "tdesc" = "Your vision is pretty bad without glasses.", "tcost" = -1, "tnotes" = "You start with a pair of glasses."),
"Bad Luck" = list("tname" = "Bad Luck", "tdesc" = "You seem to attract bad events a lot. You have really bad luck. You are more likely to be the victim of fluff objectives.", "tcost" = 0, "tnotes" = null),
"Glutton" = list("tname" = "Glutton", "tdesc" = "You love eating. A lot! You will feel bad if you aren't overeating.", "tcost" = -1, "tnotes" = null),
"Shaky" = list("tname" = "Shaky", "tdesc" = "For some reason, your hands shake a lot. Maybe it's an illness or maybe you are just nervous. You'll end up dropping a lot of things.", "tcost" = -1, "tnotes" = null)
),
"page2" = list(
"Narcolepsy" = list("tname" = "Narcolepsy", "tdesc" = "You have an illness that randomly makes you fall asleep. It gets worse if you are in a bad mood.", "tcost" = -4, "tnotes" = null),
"Oni Liver" = list("tname" = "Oni Liver", "tdesc" = "For some reason, you have the liver of an oni. You need to drink far more to get drunk, and when you are, you get sober much faster.", "tcost" = 2, "tnotes" = null),
"Master Chemist" = list("tname" = "Master Chemist", "tdesc" = "You have worked a lot with chemicals. Just looking at a liquid allows you to tell what's inside.", "tcost" = 2, "tnotes" = "This does not apply to liquids in opaque containers."),
"Red Sparrow Martial Artist" = list("tname" = "Red Sparrow Martial Artist", "tdesc" = "You have mastered the Red Sparrow fighting style and have access to special combat moves.", "tcost" = 3, "tnotes" = null),
"Maid Fashion Obsession" = list("tname" = "Maid Fashion Obsession", "tdesc" = "You love maid fashion! So much that not wearing them makes you upset, even if you are not staff.", "tcost" = -1, "tnotes" = "A full uniform includes any of the uniforms, any type of shoe and one of the maid headdresses."),
"Combat Clothes" = list("tname" = "Combat Clothes", "tdesc" = "Your starting clothes are actually armored.", "tcost" = 1, "tnotes" = null),
"Poison Sting" = list("tname" = "Poison Sting", "tdesc" = "Through some bizzare mutation, you have a stealthy poison stinger that can inject weakening poison into others.", "tcost" = 4, "tnotes" = null),
"Heavy Bag" = list("tname" = "Heavy Bag", "tdesc" = "You start with a bag for carrying a lot of items. It slows you down however.", "tcost" = 1, "tnotes" = null),
"Criminal Ties" = list("tname" = "Criminal Ties", "tdesc" = "You have ties to the main criminal organizations in this area.", "tcost" = 1, "tnotes" = null),
"Spider Web Glands" = list("tname" = "Spider Web Glands", "tdesc" = "A special mutation in your stomach allows you to spit webs. It makes you hungry however.", "tcost" = 2, "tnotes" = null)
),

"page3" = list(
"Maid Box Lunch" = list("tname" = "Maid Box Lunch", "tdesc" = "You start with a special magical lunchbox that never runs out. However, only you can eat from it.", "tcost" = 1, "tnotes" = null),
"Loud Voice" = list("tname" = "Loud Voice", "tdesc" = "Once per minute, you can yell really loud. Anyone in a certain range will hear your yellings, even behind walls.", "tcost" = 2, "tnotes" = null),
"Strong Fate" = list("tname" = "Strong Fate", "tdesc" = "It seems that fate likes to play with you. Random fluff events that involve you tend to be more extreme than usual, both good and bad.", "tcost" = 1, "tnotes" = null)
)






))

GLOBAL_LIST_EMPTY(alltraits)
GLOBAL_LIST_INIT(random_traits_presets, list())