# Using `cat`

|Option|Details|
|---|---|
|-n|Print line numbers|
|-v|Show non-printing characters using ^ and M- notation except LFD and TAB|
|-T|Show TAB characters as ^|
|-E|Show linefeed(LF) characters as $|
|-e|Same as `-vE`|
|-b|Number nonempty output lines, overrides `-n`|
|-A|Equivalent to `-vET`|
|-s|Suppress repeated empty output lines, s refers to squeeze|


## Concatenate files

This is the primary purpose of `cat`

`cat file1 file2 file3 > file_all`

`cat` can also be used similarly to concatenate files as part of a pipeline, e.g

`cat file1 file2 file3 | grep foo`


## Printing the Contents of a File

`cat file.txt` will print the contents of a file.

If a file contains non-ASCII chars, you can display those characters symbolically with `cat -v`. This can be quite useful
for situations where control chars would otherwise be invisible.

`cat -v unicode.txt`

For interactive use, you are better off using an interactive pager like `less` or `more`. 

`less file.txt`

To pass the contents of a file as input to a command. An approach usually seen as better 
([UUOC](https://en.wikipedia.org/wiki/Cat_(Unix)#Useless_use_of_cat)) is to use redirection.

```shell
tr A-Z a-z < file.txt # alternative to "cat file.txt | tr A-Z a-z"
``` 

In case the content needs ot be listed backwards from its end the command `tac` can be used.

`tac file.txt`

If you want to print the contents with line numbers, use `-n` with `cat`.

`cat -n file.txt`

