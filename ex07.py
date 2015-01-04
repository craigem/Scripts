"""Introduction to Python - Exercise 7

Name Strip
* Store your first name in a variable, but include at least two kinds of
white space on each side of your name.
* Print your name as it is stored.
* Print your name with white space stripped from the left side, then from the
right side, then from both sides."""

FIRST_NAME = "\tcraige\n"
print FIRST_NAME
print FIRST_NAME.lstrip()
print FIRST_NAME.rstrip()
print FIRST_NAME.strip()
