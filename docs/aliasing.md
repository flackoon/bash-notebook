# Aliasing

## Bypass an alias

Sometimes you may want to bypass an alias temporarily, without disabling it. To work with a concrete example, consider this alias:

`alias ls='ls --color=auto'`

If you want to use the `ls`z command without disabling the alias, you have several options:

- Use the `command` builtin: `command ls`
- Use the full path of the command: `/bin/ls`
- Add a `\` anywhere in the command name, for example: `\ls`, or `l\s`
- Quote the command


## Create an Alias

`alias word='command'`

Invoking **word** will run **command**. Any arguments to the alias are simply appended to the target of the alias.

To include multiple commands in the same alias, you can string them with `&&`.


## Removing an alias 

To remove an existing alias

`unalias {alias_name}`


# The BASH_ALIASES is an internal bash assoc array

Aliases are named shortcuts of commands, one can define and use in interactive bash instances. They are held in an associative array named 
BASH_ALIASES. To use this var in a script, it must be run within an interactive shell.

```shell
#!/bin/bash -li
# note the -li above! -l makes this behave like a login shell
# -i makes it behave like an interactive shell
#
# shopt -s expanded_aliases will not work in most cases

echo There are ${#BASH_ALIASES[*]} aliases defined.

for ali in "${!BASH_ALIASES[@]}"; do
  printf "alias: %-10s triggers: %s\n" "$ali" "${BASH_ALIASES[$ali]}"
done
```


## Expand alias

Assuming that `bar` is an alias for `someCommand -flag1`

Type `bar` on the command line and press Cmd + Alt + e.

you will get `someCommand -flag1` where `bar was standing`.



## List all Aliases

`alias-p`
