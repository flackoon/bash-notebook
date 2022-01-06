# Brackets

This chapter references [this article](https://dev.to/rpalo/bash-brackets-quick-reference-4eh6).


## ( Single Parentheses )

Single parentheses will run the commands inside in a **subshell**. This means they run through all of the commands inside,
and then return a single exit code. Any variables declared or environment changes will get cleaned up and disappeared.
Because it's within a subshell, if you have it inside a loop, it will run a little slower than if you called the commands
_without_ the parentheses.

```shell
a='This string'
( a=banana; mkdir $a )
echo $a
# => 'This string'
ls
# => ...
# => banana/
```


## (( Double Parentheses ))

This is for use in integer arithmetic. You can perform assignments, logical operations, and mathematics operations like
multiplication or module inside these parentheses. However, do note that there is no output. Any variable changes that 
happen inside them will stick, but don't expect to be able to assign the result to anything.

If the result inside is **non-zero**, it returns a **zero** (success) exit code. If the result inside is a **zero**, it
returns an exit code of **1**.

```shell
i=4
(( i += 3 ))
echo $i
# => 7
(( 4 + 8 ))
# => No Output
echo $?  # Check the exit code of the last command
# => 0
(( 5 - 5 ))
echo $?
# => 1

# Strings inside get considered 'zero'.
(( i += POO ))
echo $i
# => 7

# You can't use it in an expression
a=(( 4 + 1 ))
# => bash: syntax error near unexpected token '('
```


## <( Angle Parentheses )

Also known as _process substitution_. Basically, run command in a subshell, then return it's output through a 
file-descriptor. Meaning you can do things like:
- diff two streams
- run a command within a shell to create an input-"file" for other commands that want input in the form of a file 
  rather than a stream.

Where this comes in handy is the use of the `comm` command, which spits out the lines that the files have in common.
Because `comm` needs its input files to be sorted, you could either do this:

```shell
sort file1 > file1.sorted
sort file2 > file2.sorted
comm -12 file1.sorted file2.sorted
```

Oor, you can be cool and do it this way:
```shell
comm -12 <( sort file1 ) <( sort file2 )
```


## $( Dollar Single Parentheses )

This is for interpolating a subshell command output into a string. The command inside gets run inside a subshell, and then
any output gets placed into whatever string you're building.

```shell
intro="My name is $( whoami )"
echo $intro
# => My name is whatislove
```


## $( Dollar Single Parentheses Dollar Q )$?

If you want to interpolate a command, but only the exit code and not the value this is what you use.

```shell
if [[ $( grep -q PATTERN FILE )$? ]]; then
  echo "Dat pattern was totally in dat file!"
else
  echo "Nope."
fi
```


## $(( Dollar Double Parentheses ))

You can use **$(( ))** to perform an **Arithmetic Interpolation**.

> [NOTE] This is strictly integer arithmetic. No decimals


## [ Single Square Brackets ]

This is an alternative version of the built-in `test`. The commands inside are run and checked for "truthiness". Strings
of zero length are `false`. Strings of length of 1+ (even if those chars are whitespaces) are `true`.

```shell
if [ -f somefile.txt ]; then
  echo "File exists."
else
  echo "File doesn't exist."
fi
```

> `test` and `[` are actually shell _commands_. `[[]]` is actually part of the _shell language_ itself.

The reason you'd use single square brackets is if you need to do _word splitting_ or _filename expansion_.

Here's an illustration of the difference between single and double square brackets.

```shell
[[ -f *.txt ]]
echo $?
# => 1
```

False, there's no file explicitly named "[asterisk].txt". Let's assume there are currently no `.txt` files in our 
directory.

```shell
# If there are no .txt files:
[ -f *.txt ]; echo $?
# => 1
```

`*.txt` gets expanded to a blank string, which is not a file, and then the test gets evaluated. Let's create a txt file.

```shell
touch empty_file.txt
# Now there's exactly one .txt file
[ -f *.txt ]; echo $?
# => 0
```

`.txt` gets expanded to a space-separated list of matching filenames: "empty_file.txt", and then the test gets evaluated 
with that one argument, since the file exists, the test passes. But what if there's two files?

```shell
touch i_smell_trouble.txt
# Now there are 2 files
[ -f *.txt ]
# => bash: [: too many arguments.
```

`*.txt` gets expanded to "empty_file.txt i_smell_trouble.txt", and then the test is evaluated. Bash counts each of the 
filenames as an argument, receives 3 arguments instead of the two it was expecting, and blurffs.


## [[ Double Square Brackets ]]

True/False testing. Additionally, double square brackets support extended regular expression matching. Use quotes around 
the second argument to force a raw match instead of a regex match.

```shell
pie=good
[[ $pie =~ d ]]; echo $?
# => 0, it matches the regex

[[ $pie =~ [aeiou]d ]]; echo $?
# => 0, still matches

[[ $pie =~ [aei]d ]]; echo $?
# => 1, no match

[[ $pie =~ "[aeiou]d" ]]; echo $?
# => 1, no match because there's no literal '[aeoiu]d' inside the word "good"
```

Also, inside double square brackets, `<` and `>` sort by your locale. Inside single square brackets, it's by your 
machine's sorting order, which is usually ASCII.


## { Single Curly Braces }

Single curly braces are used for expansion.

```shell
echo h{a,e,i,o,u}p
# => hap hep hip hop hup

echo "I am "{cool,great,awesome}
# => I am cool I am great I am awesome

mv friends.txt{,.bak}
# => braces are expanded first, so the command is `mv friends.txt friends.txt.bak`
```

You can make ranges as well. With leading zeros!
```shell
echo {01..10}
# 01 02 03 04 05 06 07 08 09 10

echo {01..10..3}
# 01 04 07 10
```


## ${Dollar Braces}

> [IMPORTANT] No spaces around the contents.

This is for variable interpolation. You use it when normal string interpolation could get weird.

```shell
fruit=banana
echo $fruitification
# No output because $fruitification is not a variable
echo ${fruit}ification
```

The other thing you can use **${Dollar Braces}** for is variable manipulation. 

Using a default value if the variable isn't defined.

```shell
hello() {
  echo "Hello, ${1:-World}"
}

hello Peter
# => Hello, Peter
hello
# => Hello, World
```

Getting the length of a variable

```shell
name="George"
echo "The name ${name} is ${#name} chars long."
```

Chopping off pieces that match a pattern.

```shell
url=https://assertnotmagic.com/about
echo ${url#*/}     # Remove from the front, matching the pattern */, non-greedy
# => /assertnotmagic.com/about

echo ${url##*/}    # Same, but greedy
# => about

echo ${url%/*}     # Remove from the back, matching the pattern /*, non-greedy
# => https://assertnotmagic.com

echo ${url%%/*}    # Same, but greedy
# => https:
```

You can uppercase matching letters!

```shell
echo ${url^^a}
# => https://AssertnotmAgic.com/About
```

You can get slices of strings

```shell
echo ${url:2:5}  # the pattern is ${var:start:len}.  Start is zero-based.
# => tps://
```

You can replace patterns

```shell
echo ${url/https/ftp}
# => ftp://assertnotmagic.com

# Use a double slash for the first slash to do a global replace
echo ${url//[aeiou]/X}
# => https://XssXrtnXtmXgXc.cXm
```

And, you can use variables indirectly as the name of other variables.

```shell
function grades() {
  name=$1
  alice=A
  beth=B
  charles=C
  doofus=D
  echo ${!name}
}

grades alice
# => A
grades doofus
# => D
grades "Valoth the Unforgiving"
# => bash: : bad substitution.   
# There is no variable called Valoth the Unforgiving,
# so it defaults to a blank value.  
# Then, bash looks for a variable with a name of "" and errors out.
```