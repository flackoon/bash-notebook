# Introduction

To make a script **executable** we need to run the command

```shell
chmod +x filename.sh
```

The first line of the script must start with the character sequence `#!`,
referred to as **_shebang1_**. The shebang instructs the operating system to run
`/bin/**bash**`, the Bash shell, passing it the script's path as an argument.

> E.g /bin/bash filename.sh

Then you can execute the shell script file from the command line using one of the following:

```shell
./filename.sh – Most commonly used, and recommended
/bin/bash filename.sh
bash filename.sh – assuming /bin is in your $PATH
sh hello-world.sh 
```

> For real production use, you would omit the `.sh` extension (which is misleading anyway,
> since this is a Bash script, not a sh script) and perhaps move the file to a directory
> within your PATH so that it is available to you regardless of your current working directory,
> just like a system command such as `cat` or `ls`.

#### Common mistakes include

1.Forgetting to make the file executable

2.Editing the script on Windows, which produces incorrect line ending characters
   that Bash cannot handle.

The script can be fixed using the `dos2unix` program.

An example use: `dos2unix filename.sh`

3.Using `sh ./filename.sh`, not realizing that **bash** and **sh** are distinct shells
with distinct features (though since Bash is backwards-compatible, the opposite mistake is harmless).

Anyway, simply relying on the script's shebang is vastly **preferable** to explicitly writing `bash` 
or `sh` (or `python` or `perl` or `awk` or `ruby` or...) before each script's file name.

> A common shebang line to use in order to make your script more portable is to use 
> `#!/usr/bin/env bash` instead of hard-coding a path to Bash. That way, `/usr/bin/env` has to exist, but
> beyond that point **bash** just needs to be in your PATH. On many systems, 
> `/bin/bash` doesn't exist, and you should use `/usr/local/bin/bash` or some other
> absolute path; this change avoids having to figure out the details of that.

You can see more pitfalls [here](http://mywiki.wooledge.org/BashPitfalls).

## Security Note

> Read this [article](https://unix.stackexchange.com/questions/171346/security-implications-of-forgetting-to-quote-a-variable-in-bash-posix-shells)
> to understand the importance of placing text within double quotes.
> 
> When you forget to put double quotes around variables you basically have got a vulnerability when 
> there's a path for privilege escalation, that is when someone (let's call him the attacker) is able 
> to do something he is not meant to.


## Importance of Quoting in Strings

With these, you can control how the bash parses and expands your strings.

> There are two types of quoting:
> - **Weak**: uses double quotes: "
> - **Strong**: uses single quotes: '

If you want bash to **expand** your argument, you can use **Weak Quoting**:
```shell
world="World"
echo "Hello $world"
```

If you don't want Bash to expand your argument, you can use **Strong Quoting**:

```shell
world="World"
echo 'Hello $world'
# You can also use escape to prevent expansion:
echo "Hello \$world"
```

## Handling Named Arguments

```shell
#!/bin/bash

deploy=false
uglify=false

while (( $# > 1)); do case $1 in
  --deploy) deploy="$2";;
  --uglify) uglify="$2";;
  esac; shift 2
done

# ./script.sh --deploy true --uglify false
```