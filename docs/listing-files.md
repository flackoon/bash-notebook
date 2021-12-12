# Listing files

## Options

|Option|Description|
|------|-----------|
|-a, --all|List all entries including ones that start with a dot|
|-A, --almost-all|List all entries excluding `.` and `..`|
|-c|Sort files by change time|
|-d, --directory|List directory entries|
|-h, --human-readable|Show sizes in human readable format (i.e. K, M)|
|-H|Same as above only with powers of 1000 instead of 1024|
|-l|Show contents in long-listing format|
|-o|Long-listing format without group info|
|-r, --reverse|Show contents in reverse order|
|-s, --size|Print size of each file in blocks|
|-S|Sort by file size|
|--sort=WORD|Sort contents by a word (i.e. size, version, status)|
|-t|Sort by modification time|
|-u|Sort by last access time|
|-v|Sort by version|
|-1|List one file per line|

## File Type

|Character|File Type|
|---|---|
|-|Regular file|
|b|Block special file|
|c|Character special file|
|C|High performance ("contiguous data") file|
|d|Directory|
|D|Door (special IPC file in Solaris 2.5+ only)|
|l|Symbolic link|
|M|Off-line ("migrated") file (Cray DMF)|
|n|Network special file (HP-UX)|
|p|FIFO (named pipe)|
|P|Port (special system file in Solaris 10+ only)|
|s|Socket|
|?|Some other file type|

### List the 10 most recently modified files

```shell
ls -lt | head
```

`head` reads the first 10 lines of the file/output.

### List files without using `ls`

Use the Bash shell's filename expansion and brace expansion capabilities to obtain the filenames:

```shell
# display the files and directories that are in the current directory
printf "%s\n" *

# display only the directories in the current directory
printf "%s\n" */

# display only (some) image files
printf "%s\n" *.{gif,jpg,png}
```

To capture a list of files into a variable for processing, it is typically good practice to use 
a bash array.

```shell
files=( * )

# iterate over them
for file in "$(files[@])"; do
  echo "$file"
done
```

### List files in a tree-like format

The `tree` command lists the contents of a specified directory in a tree-like format.
If no directory is specified then, by default, the contents of the current directory
are listed.

```shell
$ tree /tmp
/tmp
|-- 5037
|-- adb.log
|__ evince-20965
   |__ image.FPWTJY.png
```

Use the `tree` command's `-L` option to limit the display depth and the option `-d` 
option to list only directories.

```shell
$ tree -L 1 -d /tmp
/tmp
|__ evince-20965
```

