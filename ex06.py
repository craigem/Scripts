"""Introduction to Python - Exercise 6

About This Person
* Choose a person you look up to. Store their first and last names in separate
variables.
* Use concatenation to make a sentence about this person, and store that
sentence in a variable.
* Print the sentence."""

FIRST_NAME = "ada"
LAST_NAME = "lovelace"
FULL_NAME = FIRST_NAME + " " + LAST_NAME

MESSAGE = FULL_NAME.title() + " " + "was considered the world's first " \
    "computer programmer."

print MESSAGE
