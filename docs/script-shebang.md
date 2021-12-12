# Script shebang

## Env shebang

To execute a script file with the `bash` executable found in the PATH environment variable by
using the executable `env`, the **first line** of the script file must indicate the absolute path
to the `env` executable with argument `bash`:

`#!/usr/bin/env bash`

The `env` path in the shebang is resolved and used only if a script is directly launched like this:

`script.sh`

The script must have execution permission.

The shebang is **ignored** when a `bash` interpreter is explicitly indicated to execute a script:

`bash script.sh`

## Direct shebang

To execute a script file with the `bash` interpreter, the **first line** of a script file must
indicate the absolute path to the `bash` executable to use:

`#!/bin/bash`

The `bash` path in the shebang is resolved and used only if a script is directly launch like this:

`./script.sh`

The script must have exec. permission.

Again, the shebang is **ignored** when a `bash` interpreter is explicitly indicated to execute
the script:

`bash script.sh`

## Other shebangs

There are 2 kinds of programs the kernel knows of. A binary program is identified by it's ELF (**E**xtendable**L**oadable**F**ormat)
header, which is usually produced by a compiler. The second one are scripts of any kind.

If a file starts in the very first line with the sequence `#!` then the next string has to be a 
pathname of an interpreter. If the kernel reads this line, it calls the interpreter named by this pathname 
and gives all of the following words in this line as arguments to the interpreter. If there is no file named
"something" or "wrong":

```shell
#!/bin/bash something wrong
echo "This line never gets printed"
```

bash tries to execute its argument "something wrong" which doesn't exist. The name of the script
file is added too:

```shell
#!/bin/echo something wrong
# and now call this script named "thisscript" like so:
# thisscript one two
# the output will be:
something wrong ./thisscript one two
```

Some programs like **awk** use this technique to run longer scripts residing in a disk file.