/datum/subscenario/banquet

	pickable = 1

	sub_name = "Banquet"
	sub_desc = "Today, a large banquet is sheduled. All staff members have been ordered to prepare it, but anyone may help prepare it and anyone may eat! \n "
	sub_rolefluff = list()
	sub_factionfluff = list()
	var/food
	var/food2

datum/subscenario/banquet/handle_subscenario()
	food = pick("fish based food","vegetarian food", "sweet pastries", "meaty food", "unusual food", "exotic food", "simple, cheap food", "expensive food")
	food2 = pick("cakes and candies", "plain and simple desserts", "ice creams", "raw vegetables", "bread based foods", "well decorated foods")
	sub_desc += "The banquet should include [food] and [food2]."
	..()