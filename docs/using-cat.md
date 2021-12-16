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


## Write to a file

`cat > file`

It will let you write the text on terminal which will be saved in a file named _file_.

`cat >>file`

will do the same, except it will append the text to the end of the file.


A here document can be used to inline the contents of a file into a command line or a script:

```shell
cat <<END >file
Hello, World.
END
```

The token after the `<<` redirection symbol is an arbitrary string which needs to occur alone on a line to indicate the end
of the here document. You can add quoting to prevent the shell from performing command substitution and variable interpolation.

```shell
cat <<'fnord'
Nothing in 'here' will be $changed
fnord
```


## Read from standard input

`cat < file.txt`

Output is same as `cat file.txt`, but it reads the contents of the file from standard input instead of directly from the file.


## Display line numbers with output

Using the `--number` flag to print line numbers before each line. Alternatively, `-n` does the same thing.

`cat --number file`

To skip empty lines when counting lines, use the `--number-nonblank`, or simply `-b`.


## Concatenate gzipped files

Files compressed by `gzip` can be directly [concatenated](#concatenate-files) into larger gzipped files.