//

//structure of thought:
//"Thoughtname"
//->"name" name of the thought in the list
//->"name_menu" a nicer, maybe longer name for the menu
//->"desc" description of what causes it
//->"default_duration" the duration in miliseconds it lasts
//->"duration" working variable, if REALTIMEOFDAY > than this, the thought disappears
//->"severity" a number value that adjusts the total mood
//->"protected" a thought with this cannot be removed by modify/transform unless forced, still disappears if duration runs out

GLOBAL_LIST_INIT(default_moods, list(

"pain mild" = list(
"name" = "pain mild",
"name_menu" = "Pain(Mild)",
"desc" = "You are feeling mild pain, unpleasant.",
"default_duration" = 150,
"duration" = 0,
"severity" = -2,
"protected" = FALSE
),

"pain strong" = list(
"name" = "pain strong",
"name_menu" = "Pain(Strong)",
"desc" = "You are feeling strong pain, ow!",
"default_duration" = 200,
"duration" = 0,
"severity" = -3,
"protected" = FALSE
),

"pain very strong" = list(
"name" = "pain very strong",
"name_menu" = "Pain(Very Strong)",
"desc" = "You are feeling enormous pain!",
"default_duration" = 300,
"duration" = 0,
"severity" = -5,
"protected" = FALSE
),

"embarassed" = list(
"name" = "embarassed",
"name_menu" = "Embarassment",
"desc" = "You have been seen by someone else in your underwear... or worse!",
"default_duration" = 3000,
"duration" = 0,
"severity" = -5,
"protected" = FALSE
),

"wet" = list(
"name" = "wet",
"name_menu" = "Wet",
"desc" = "Your clothes have been drenched in water.",
"default_duration" = 3000,
"duration" = 0,
"severity" = -2,
"protected" = FALSE
),

"soaked" = list(
"name" = "soaked",
"name_menu" = "Soaked",
"desc" = "Your clothes got really soaked from water. Very unpleasant!",
"default_duration" = 3000,
"duration" = 0,
"severity" = -2,
"protected" = FALSE
),

"hungry" = list(
"name" = "hungry",
"name_menu" = "Hungry",
"desc" = "You are hungry!",
"default_duration" = 300,
"duration" = 0,
"severity" = -4,
"protected" = FALSE
),

"very hungry" = list(
"name" = "very hungry",
"name_menu" = "Very Hungry",
"desc" = "You really want to eat now.",
"default_duration" = 300,
"duration" = 0,
"severity" = -5,
"protected" = FALSE
),



"well fed" = list(
"name" = "well fed",
"name_menu" = "Well Fed",
"desc" = "You feel sated.",
"default_duration" = 600,
"duration" = 0,
"severity" = 3,
"protected" = FALSE
),

"drunk happy" = list(
"name" = "drunk happy",
"name_menu" = "Happy From Drinking",
"desc" = "You had a drink and feel better.",
"default_duration" = 300,
"duration" = 0,
"severity" = 2,
"protected" = FALSE
),

"drunk tipsy" = list(
"name" = "drunk tipsy",
"name_menu" = "Tipsy",
"desc" = "You had a few drinks and forgot about some problems for now. Drink responsibly or else...",
"default_duration" = 600,
"duration" = 0,
"severity" = 2,
"protected" = FALSE
),

"well dressed" = list(
"name" = "well dressed",
"name_menu" = "Well Dressed",
"desc" = "You're wearing very fancy clothes, you feel more confident and happy.",
"default_duration" = 600,
"duration" = 0,
"severity" = 1,
"protected" = FALSE
)

))