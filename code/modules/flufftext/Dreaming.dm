/mob/living/carbon/proc/dream()
	set waitfor = 0
	dreaming = 1
	var/list/dreams = list(
		"maids","a bottle","a familiar face","a fellow staff member","a bird","a guest","the Porcelain Empire",
		"voices from all around","the city of Senzai","a doctor","Toritamegahara","a rude person","a friend","darkness",
		"light","Toubatai","Zouge-toshi","a catastrophe","a loved one","a spider","warmth","freezing","the sun",
		"a hat","molten gold springs","a feather duster","a lot of gold bars","a shrine","air","fashion","the kitchen","a theatre play",
		"a blue light","an abandoned library","the Wood Empire","The Black Crane Syndicate","a nice warm pool","healing","power","respect",
		"riches","Mount Meru","a sudden success","happiness","compassion","a leap of faith","water","flames","ice","eggs","flying"
		)
	for(var/i = rand(1,4),i > 0, i--)
		var/dream_image = pick(dreams)
		dreams -= dream_image
		to_chat(src, "<span class='notice'><i>... [dream_image] ...</i></span>")
		sleep(rand(40,70))
		if(paralysis <= 0)
			dreaming = 0
			return 0
	dreaming = 0
	return 1

/mob/living/carbon/proc/handle_dreams()
	if(prob(5) && !dreaming) dream()

/mob/living/carbon/var/dreaming = 0