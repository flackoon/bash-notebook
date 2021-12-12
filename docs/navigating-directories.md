# Navigating directories

## Change to last directory

For the current shell, this takes you to the previous directory that you were in,
no matter where it was.

`cd -`

## Change to the directory of the Script

In general, there are 2 types of Bash scripts:

1. System tools which operate from the current working directory.
2. Project tools which modify files relative to their own place in the file system.

For the second type of scripts, it is useful to change to the directory where the script
is stored. This can be done with the following command.

```shell
cd "$(dirname "$(readlink -f "$0")")"
```

This command runs 3 commands:
1. `readlink -f "$0"` determines the path to the current script(`$0`)
2. `dirname` converts the path to script to the path to its directory.
3. `cd` changes the current work directory to the dir it receives from `dirname`