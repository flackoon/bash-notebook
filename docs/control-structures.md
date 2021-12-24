# Control Structures

**Parameter to [ or test**

|File Operators|Details|
|---|---|
|`-e "$file"`|Returns true if the file exists|
|`-d "$file"`|Returns true if the file exists and is a directory|
|`-f "$file"`|Returns true if the file exists and is a regular file|
|`-h "$file"`|Returns true if the file exists and is a symbolic link|

|String Operators|Details|
|---|---|
|`-z "$str"`|True if length of string is zero|
|`-n "$str"`|True if length of string is non-zero|
|`"$str" = "$str2"`|True if string $str is equal to string $str2. Not best for integers. It may work but it'll be inconsistent|
|`"$str" != "$str2"`|True if the strings are not equal|

|Integer Operators|Details|
|---|---|
|`"$int1" -eq "$int2"`|True if integers are equal|
|`"$int1" -ne "$int2"`|True if integers are not equal|
|`"$int1" -gt "$int2"`|True if int1 is greater than int2|
|`"$int1" -ge "$int2"`|True if int1 is greater or equal to int2|
|`"$int1" -lt "$int2"`|True if int1 is less than int2|
|`"$int1" -le "$int2"`|True if int1 is less than or equal to int2|


## Conditional Execution of Command Lists

#### How to Use Conditional Execution of Command Lists

Any builtin command, expression, or function, as well as any external command or script can be executed conditionally
using the `&&`(and) or `||`(or) operators.

For example, this will only print the current directory if the `cd` command was successful.

`cd my_directory && pwd`

Likewise, this will exit if the `cd` command fails, preventing catastrophe:

```shell
cd my_directory || exit
rm -rf *
```

> When combining multiple statements in this manner, it's important to remember that these operators have no precedence
> and are left-associative.


#### Why use conditional execution of command lists

Conditional execution is a hair faster than `if...then` but its main advantage is allowing functions and scripts to exit
early, or "short circuit".

Unlike many languages like C where memory is explicitly allocated for structs and variables and such (and thus must be
deallocated), **bash** handles this under the covers. In most cases, we don't have to clean up anything before leaving 
the function. A `return` statement will deallocate everything local to the function and pickup execution at the return 
address on the stack.

Returning from functions or exiting scripts asap can thus significantly improve performance and reduce system load by
avoiding the unnecessary execution of code.


## If statement

```shell
if [[ $1 -eq 1 ]]; then
  echo "1 was passed in the first parameter"
elif [[ $1 -gt 2 ]]; then
  echo "2 was not passed in the first parameter"
else
  echo "The first parameter was not 1 and is not greater than 2."
fi 
```

The closing `fi` is necessary, but the `elif` and/or the `else` clauses can be omitted.

The semicolons before the `then` are standard syntax for combining two commands on a single line; they can be omitted 
only if `then` is moved to the next line.

The brackets `[[` are **not** part of the syntax, but are treated as a command; it is the exit code from his command that
is being tested. Therefore, you must always include spaces around the brackets.
This also means the result of any command can be tested. If the exit code from the command is a zero, the statement is
considered true.

```shell
if grep "foo" bar.txt; then
  echo "foo was found"
else
  echo "foo was not found"
fi
```

Mathematical expressions, when placed inside double parentheses, also return 0 or 1 in the same way, and can also be tested.

```shell
if (( $1 + 5 > 91 )); then
  echo "$1 is greater than 86"
fi
```

You may also come across if statements with single brackets. These are defined in the POSIX standard and are guaranteed
to work in all POSIX-compliant shells including Bash. The syntax is very similar to that in Bash:

```shell
if [ "$1" -eq 1 ]; then
  # ...
elif [ "$1" -gt 2 ]; then
  # ...
else 
  # ...
fi
```


## Looping over an array

### **for** loop:

```shell
arr=(a b c d e f)
for i in "${arr[@]}"; do
  echo "$i"
done
```

Or 

```shell
for ((i=0;i<${#arr[@};i++)); do
  echo "${arr[$i]}"
done
```

#### **while** loop:

```shell
i=0
while [$i -lt ${#arr[@]} ]; do
  echo "${arr[$i]}"
  i=$(expr $i + 1)
done
```

or

```shell
i=0
while (( $i < ${#arr[@]} )); do
  echo "${arr[$i]}"
  ((i++))
done
```


## Using For Loop to List Iterate Over Numbers

```shell
#! /bin/bash

for i in {1..10}; do  # {1..10} expands to "1 2 3 4 5 6 7 8 9 10"
  echo $i
done
```


## `continue` and `break`

Example for `continue`

```shell
for i in [series]
do
  command 1
  command 2
  if (condition) # Condition to jump over command 3
    continue  # Skip to the next value in "series"
  fi
  command 3
```

Example for `break`

```shell
for i in [series]
do
  command 4
  if (condition) # Condition to break the loop
  then
    command 5   # Command if the loop needs to be broken
    break
  fi
  command 6
```

> Use `break` followed by a number, to break out of that many levels of nesting.


The basic format of C-style **for** loop is:

`for (( variable assignment; condition; iteration process ))`

Notes:
- The assignment of the variable inside C-style **for** loop can contain spaces unlike the usual assignment
- Variables inside C-style **for** loop aren't preceded with `$`

Example:

```shell
for (( i = 0; i < 10; i++ )); do
  echo "Number is $i"
done
```

Also we can process multiple variables inside a C-style **for** loop:

```shell
for (( i = 0, j = 0; i -le 10; i++, j = i * i )); do
  echo "The square of $i is $j"
done
```


## Until Loop

Until loop executes until condition is true

```shell
i=5
until [[ i -eq 10 ]]; do
  echo "i=$i"
  i=$((i+1))
done
```


## Switch Statement with Case

With the `case` statement you can match values against one variable.

The argument passed to `case` is expanded and try to match against each patterns.

If a match is found, the commands up to `;;` are executed.

```shell
case "$BASH_VERSION" in
  [34]*)
    echo {1..4}
    ;;
  *)
    seq -s" " 1 4
esac
```

Patterns are not regex but shell pattern matching (aka globs).


## For Loop without a List-of-Words parameter

```shell
for arg; do
  echo arg=$arg
done
```

A `for` loop without a list of words parameter will iterate over the positional parameters instead. In other words, the
above example is equivalent to this code:

```shell
for arg in "$@"; do
  echo arg=$arg
done
```

In other words, if you catch yourself writing `for i in "$@"; do ...; done`, just drop the `in` part, and write simply
`for i; do ...; done`.



