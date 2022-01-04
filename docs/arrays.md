# Arrays

## Array Assignments

#### List Assignment

Bash uses spaces to separate array elements.

```shell
# Array in Bash
array=(1 2 3 4)
strings_array=('first element' 'second element' 'third element')
```


#### Subscript Assignment

Create an array with explicit element indicies:

`array=([3]='fourth element' [4]='fifth element')`


#### Assignment by index

```shell
array[0]='first element'
array[1]='second element'
```


#### Assignment by name (associative array)

```shell
# version >= 4.0
declare -A array
array[first]='First element'
array[second]='Second element'
```


#### Dynamic Assignment

Create an array from the output of other command, for example use **seq** to get a range from 1 to 10:

```array=(`seq 1 10`)```

Assignment from script's input arguments:

`array=("$@")`

Assignment within loops:

```shell
while read -r; do
  # array+=("$REPLY")     # Array append
  array[$i]="$REPLY"      # Assignment by index
  let i++                 # Increment index
done < <(seq 1 10)        # Command substitution

echo ${array[@]}          # output: 1 2 3 4 5 6 7 8 9 10
```

where `$REPLY` is always the current input


## Accessing Array Elements

Print element at index 0
`echo "${array[0]}"`
_version < 4.3_

Print last element using substring expansion syntax
`echo "${arr[@]: -1}`
_version >= 4.3_

Print last element using subscript syntax:
`echo "${array[-1]}"`

Print all elements, each quoted separately
`echo "${array[@]}`

Print all elements as a single quoted string
`echo "${array[*]}"`

Print all elements from index 1, each quoted separately
`echo "${array[@]:1}"`

Print 3 elements from index 1, each quoted separately
`echo "${array[@]:1:3}""`


#### String Operations

If referring to a single element, string operations are permitted:
```shell
array=(zero one two)
echo "${array[0]:0:3}"  # prints "zer" (chars at position 0, 1 and 2 in the string zero)
echo "${array[0]:1:3}"  # prints "ero" (chars at position 1, 2 and 3 in the string zero)
```


## Array Modification

#### Change Index

Initialize or update particular element in the array

`array[10]="eleventh element`
_version >= 3.1_


#### Append

Modify array, adding elements to the end if no subscript is specified.
`array+=('fourth element' 'fifrth element')`

Replace the entire array with a new parameter list.
`array=("${array[@]}" "fourth element" "fifth element")`

Add an element at the beginning
`array=("new element" "${array[@]}")`


#### Insert

Insert an element at a given index:
```shell
arr=(a b c d)
i=2
arr=("${arr[@]:0:$i}" 'new' "${arr[@]:$i}")
echo "${arr[2]}"    # output: new
```


#### Delete

Delete array indexes using the `unset` builtin:
```shell
arr=(a b c)
unset -v 'arr[1]'
echo "${arr[@]}"  # outputs: a c
```


#### Merge

`array3=("${array1[@]}" "${array2[@]}")`

This works for sparse arrays as well.


#### Re-indexing an array

This can be useful if elements have been removed from an array, or if you're unsure whether there are gaps in the array.
To recreate the indecies without gaps:

`array=("${array[@]}")`


## Array Iteration

Array iteration comes in two flavors, foreach and the classic for-loop:

```shell
a=(1 2 3 4)

# foreach loop
for y in "${a[@]}"; do
  echo "$y"
done

# classic for-loop
for ((idx=0; idx < ${#a[@]}; ++idx)); do
  echo "${a[$idx]}"
done
```

You can also iterate over the output of a command:

```shell
a=($(tr ',' ' ' <<< "a, b, c, d"))    # tr can transform one char to another
for y in "${a[@]}"; do
  echo "$y"
done
```


## Array Length

`${#array[@]}` gives the length of the array `${array[@]}`

```shell
array=('first element' 'second element' 'third element')
echo "${#array[@]}"   # 3
```

Also works with Strings in single elements:
`echo ${#array[0]}`   # Prints the length of the string at element 0: 13


## Associative Arrays

_version >= 4.0_

#### Declare an Associative Array

`declare -A aa`

Declaring an associative array **before** initialization or use is mandatory.


#### Initialize Elements

You can initialize elements one at a time as follows:

```shell
aa[hello]=world
aa[ab]=cd
aa["key with space"]="hello world"
```

You can also initialize an entire associative array in a single statement:

`aa=([hello]=world [ab]=cd ["key with space"]="hello world")`


#### Access an associative array element

```shell
echo ${aa[hello]}
# Out: world
```

#### Listing associative array keys

```shell
echo "${!aa[@]}"
# Prints: hello ab key with space
```


#### Iterate over associative array keys and values

```shell
for key in "${!aa[@]}"; do
  echo "Key: ${key}"
  echo "Value: ${aa[$key]}"
done
```


#### Count associative array elements

`echo "${#aa[@]}`


## Destroy, Delete, or Unset an Array

To destroy, delete, or unset an array:
`unset array`

To destroy, delete, or unset a single array element:
`unset array[10]`


## Array from string

```shell
stringVar="Apple Orange Banana Mango"
arrayVar=(${stringVar// / })
```

Each space in the string denotes a new item in the resulting array.
```shell
echo ${arrayVar[0]} # will print Apple
echo ${arrayVar[3]} # will print Mango
```


## Reading an entire file into an array

Reading in a single step:

`IFS=$'\n' read -r -a arr < file`

Reading in a loop:

```shell
# Version >= 4.0
arr=()
while IFS= read -r line; do
  arr+=("$line")
done
```

Using `mapfile` or `readarray` (which are synonymous):
```shell
mapfile -t arr < file
readarray -t arr < file
```


## Array insert

This function will insert an element into an array at a given index:

```shell
insert(){
  h='
  ################## insert ########################
  # Usage:
  #   insert arr_name index element
  #
  # Parameters:
  #     arr_name    : Name of the array variable
  #     index       : Index to insert at
  #     element     : Element to insert
  ##################################################
  '
  [[ $1 = -h ]] && { echo "$h" >/dev/stderr; return 1; }
  declare -n __arr__=$1   # reference to the array variable
  i=$2                    # index to insert at
  el="$3"                 # element to insert
  # handle errors
  [[ ! "$i" =~ ^[0-9]+$ ]] && { echo "E: insert: index must be a valid integer" >/dev/stderr; return 1; }
  (( $1 < 0 )) && { echo "E: insert: index can not be negative" >/dev/stderr; return 1; }
  # Now insert $el at $i
  __arr__("$(__arr__[@]:0:$i)" "$el" "$(__arr__[@]:$i)")
}
```

Usage: 
`insert array_variable_name index element`

Example:
```shell
arr=(a b c d)
echo "${arr[2]}"  # output: c
insert arr 2 'New Element'
echo "${arr[2]}"  # output: New Element
echo "${arr[3]}"  # output: c
```