#define TRAIT_1 list("tname" = "Test Trait 1", "tdesc" = "This is the description text.", "tcost" = 1, "tnotes" = null)
#define TRAIT_2 list("tname" = "Test Trait 2", "tdesc" = "This is the description text number 2!.", "tcost" = 2, "tnotes" = "This is a note.")
#define TRAIT_3 list("tname" = "Test Trait 3", "tdesc" = "This is the description text number 3!.", "tcost" = -1, "tnotes" = "This is a note too.")


#define TRAIT_LIST1 list( "Test Trait 1" = TRAIT_1, "Test Trait 2" = TRAIT_2)
#define TRAIT_LIST2 list( "Test Trait 3" = TRAIT_3)


#define FULL_TRAIT_LIST (TRAIT_LIST1 + TRAIT_LIST2)


//GLOBAL_LIST_INIT(traitlistpaged, list("page1" = TRAIT_LIST1, "page2" = TRAIT_LIST2))

GLOBAL_LIST_INIT(traitlistpaged, list(
"page1" = list(
"Test Trait 1" = list("tname" = "Test Trait 1", "tdesc" = "This is the description text.", "tcost" = 1, "tnotes" = null),
"Test Trait 2" = list("tname" = "Test Trait 2", "tdesc" = "This is the description text number 2!.", "tcost" = 2, "tnotes" = "This is a note.")
),
"page2" = list(
"Test Trait 3" = list("tname" = "Test Trait 3", "tdesc" = "This is the description text number 3!.", "tcost" = -1, "tnotes" = "This is a note too.")


)


))

GLOBAL_LIST_EMPTY(alltraits)
