#!/usr/bin/env bash

# Note that spaces cannot be used around the '=' assignment operator
whom_variable="World"

# Use printf to safely output the data
printf "Hello, %s\n" "$whom_variable"

#> Hello, World

# The following code accepts an argument $1, which is the first command
# line argument, and outputs it in a formatted string, following Hello,.
printf "Hello, %s\n" "$1"

# It is important to note that $1 has to be quoted in double quote, not single
# quote. "$1" expands to the first command line argument, as desired, while '$1'
# evaluates to literal string $1.

echo "Who are you?"
read name
echo "Hello, $name."