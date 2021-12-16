# Grep

## How to search a file for a pattern

To find the word **foo** in the file _bar_:

`grep foo ~/Desktop/bar`

To find all lines that **do not** contain foo in the file _bar_:

`grep -v foo ~/Desktop/bar`

To use find all words containing foo in the end (Wildcard Expansion):

`grep "*foo" ~/Desktop/bar`