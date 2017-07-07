/datum/bad_idea/
	var/idea_name
	var/desc_text
	var/bvictim

/datum/bad_idea/proc/setup_bad_idea(victim_input, mob/living/carbon/human/player, type_idea)
	if(type_idea == "target")
		bvictim = victim_input
		setup_victim()
		announce_bad_idea(player)
	else
		announce_bad_idea(player)

/datum/bad_idea/proc/setup_victim()


/datum/bad_idea/proc/announce_bad_idea(mob/living/carbon/human/player)
	to_chat(player, "<span class='notice'>You have a new bad idea: [idea_name].</span>")
	to_chat(player, "<span class='notice'>[desc_text]</span>")

//########GENERAL BAD IDEAS#########

//################minor#############
/datum/bad_idea/confuse_talk
	idea_name = "Confusing Communication"
	desc_text = "You don't feel like communicating normally today. Speak in riddles, haiku, miming or some other strange way."

/datum/bad_idea/eccentric_outfit
	idea_name = "Eccentric Outfit"
	desc_text = "You don't get enough attention. Pick an eccentric outfit to get people to talk about you."

/datum/bad_idea/no_work
	idea_name = "Work Avoiding"
	desc_text = "You absolutely don't want to work or do any of your other duties today. Try to do some non-productive things with others."

//###############medium#############

/datum/bad_idea/mansion_owner
	idea_name = "Mansion Owning"
	desc_text = "This is your mansion and you are the most important person here, make sure everyone knows this and acts accordingly."

/datum/bad_idea/opposite
	idea_name = "Opposite"
	desc_text = "Always do the opposite of what people tell you to. Well, atleast if you want to."

/datum/bad_idea/forced_hide_seek
	idea_name = "Forced Hide and Seek"
	desc_text = "Go and hide important things from people, then tell them to play hide and seek for them!"

/datum/bad_idea/trap
	idea_name = "Trap"
	desc_text = "Turn a room into a trap and catch someone in it."

/datum/bad_idea/room_swapper
	idea_name = "Swap Rooms"
	desc_text = "You believe that some rooms just aren't in the right place. Pick two or more rooms, then swap all things inside them. Atleast those you can carry..."

//#############verybad##########

/datum/bad_idea/doorlocker
	idea_name = "Door Locker"
	desc_text = "What if you randomly locked doors and other people had no keys to open them again? Time to find out! Maybe find a masterkey first if you can."


/datum/bad_idea/too_clean
	idea_name = "Mansion Uncleaner"
	desc_text = "The mansion is way, way too clean, there is no work to do. Change this."

/datum/bad_idea/winter_miss
	idea_name = "Missing Winter and Slipping"
	desc_text = "You miss winter. The nice snow and the people falling down after slipping. Thankfully, you can make the floors slippery enough to bring that feeling back."

/datum/bad_idea/fortress
	idea_name = "Fortification"
	desc_text = "What if there was a suddenly assault on the mansion by monsters and criminals? You need to build some fortifications out of wood. Don't worry about blocking off rooms or paths..."

//############extreme##########


/datum/bad_idea/poisonfood
	idea_name = "Special Food Seasoning"
	desc_text = "The food here is boring. Improve it by adding special poisonous seasonings."

/datum/bad_idea/acid
	idea_name = "Acid Cleaner"
	desc_text = "You read that caustic acid is a really good way to clean stuff. Go and clean furniture, clothing and items with acid! Don't use up too much acid though, try to only clean the most important things..."

/datum/bad_idea/takeover
	idea_name = "Takeover"
	desc_text = "It's time to take over the mansion. It's not truly yours unless everyone that isn't you is locked up!"

/datum/bad_idea/fighting
	idea_name = "Combat Day"
	desc_text = "Today is combat day, the day where you beat up everyone. Get to work!"


//###### TARGETTED BAD IDEAS ########

//##########minor###################

/datum/bad_idea/lecture/setup_victim()
	idea_name = "Lecture"
	desc_text = "[bvictim] was very rude yesterday. Go give them a lenghty, annoying lecture about proper behaviour."

/datum/bad_idea/follow/setup_victim()
	idea_name = "Follower"
	desc_text = "[bvictim] is really interesting. Follow them around everywhere."

/datum/bad_idea/too_thin/setup_victim()
	idea_name = "Too Thin"
	desc_text = "[bvictim] is too thin. Help them gain some weight."

/datum/bad_idea/riddle/setup_victim()
	idea_name = "Give a Riddle"
	desc_text = "[bvictim] loves solving puzzles. Think up some puzzle for them to solve and if they can't..."

/datum/bad_idea/be_me/setup_victim()
	idea_name = "Admiration"
	desc_text = "Oh how much you wish you could be [bvictim]! Try to impersonate them as best as you can in whichever way you want."

//############medium###########

/datum/bad_idea/frame_them/setup_victim()
	idea_name = "Framing Someone"
	desc_text = "[bvictim] needs to be taught a lesson. Frame them for some mishap or prank!"

/datum/bad_idea/chemical_tests/setup_victim()
	idea_name = "Chemical Test"
	desc_text = "[bvictim] looks like a good candidate for your mad scientist ideas. Make them drink some weird but harmless chemicals!"

/datum/bad_idea/pranking/setup_victim()
	idea_name = "Play a Prank"
	desc_text = "Play a prank on [bvictim]!"

/datum/bad_idea/personal_maid/setup_victim()
	idea_name = "Helpful Admiration"
	desc_text = "[bvictim] looks in need of a maid or butler, you! Follow them everywhere and always offer your help, even if they refuse."

/datum/bad_idea/get_stuff/setup_victim()
	idea_name = "Object of Desire"
	desc_text = "[bvictim] has something you really want. Maybe their key? Or their hat? Either way, you want it really bad. Go and ask for a trade, gamble for it or even consider stealing it."

//##############VERYBAD##########

/datum/bad_idea/preventing_evil/setup_victim()
	idea_name = "Preventing Evil"
	desc_text = "You just know that [bvictim] is evil! You should capture and lock them away to prevent them from harming others!"

/datum/bad_idea/teach_sadness/setup_victim()
	idea_name = "Teach Sadness"
	desc_text = "[bvictim] doesn't care about the feelings of others. Teach them how it's like to be sad or angry!"

/datum/bad_idea/oni_catcher/setup_victim()
	idea_name = "Oni Catcher"
	desc_text = "[bvictim] is most likely an oni. Make them drink alcohol until they pass out and reveal their oni form!"

/datum/bad_idea/wanted_criminal/setup_victim()
	idea_name = "Wanted Criminal"
	desc_text = "[bvictim] is the leader of a criminal organization. And a wanted criminal. Catch them and get your reward."

//#############EXTREME

/datum/bad_idea/duel_honor/setup_victim()
	idea_name = "Duel"
	desc_text = "[bvictim] asked you for a honorable duel yesterday. Give them a duel, even if they pretend not to know anything about that."

/datum/bad_idea/poisoners/setup_victim()
	idea_name = "Taste of Poison"
	desc_text = "You believe that [bvictim] has been slipping poison into the food. Give them a taste of their own medicine, poison them!"


/datum/bad_idea/fight_dirty/setup_victim()
	idea_name = "Fight"
	desc_text = "You want to fight [bvictim]. No need for honor, in fact, ambush them if you can!"

