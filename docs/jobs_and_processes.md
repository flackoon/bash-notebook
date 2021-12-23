# Jobs and Processes

## Job handling

### Creating jobs

To create a job, just append a single `&` after the command

```shell
sleep 10 &
[1] 20024
```

You can also make a running process a job by pressing Cmd + z

```shell
^Z
[1]+  Stopped		sleep 10
```

### Background and foreground a process

To bring a Process to the foreground, the command `fg` is used together with `%`

```shell
sleep 10 &
[1] 20024

fg %1
sleep 10
```

Now you can interact with the process. To bring it back to the background, you can use the `bg` command. Due to the occupied terminal session,
you need to stop the process first.

`bg %1`

These commands also work with a single `%` if there is only one process, or for the first process in the list.

`fg %` or `bg %`

Additionally, just typing `fg` or `bg` without any argument handles the last job.



### Killing running jobs

```shell
sleep 10 &
[1] 20024

kill %1
[1]+ Terminated
```

The process runs in the background with process id(pid) 20024 and job number 1. The default kill signal sent by `kill` is **SIGTERM**, 
which allows the target process to exit gracefully.

To see a full list of kill signals, run `kill -l`.


### Start and kill specific processes

Probably the easies way of killing a running process is by selecting it through the process name as in the following example using `pkill`

`pkill -f test.py`

(or) a more fool-proof way using `pgrep` to search for the actuall PID.

`kill $(pgrep -f 'python test.py')`

The same result can be obtained using `grep` over `ps -ef  | grep name_of_process` then killing the process associated with the resulting
PID. Selecting a process using its name is convenient in a testing environment but can be really dangerous when the script is used in
production: it is virtually impossible to be sure that the name will match the process you actually want to kill. In those cases, the
following approach is actually much safer.

```shell
#!/bin/bash

if [[ ! -e /tmp/test.py.pid ]]; then	# Check if the file already exists
    python test.py &
    echo $! > /tmp/test.py.pid
else
    echo -n "ERROR: the process is already running with pid "
    cat /tmp/test.py.pid
    echo 
fi
```


## Check which process is running on specific port

To check which process is running on port `8080`:

`lsof -i :8080`


## Disowning background job

```shell
gzip extremelylargefile.txt
bg
disown %1
```

This allows a long running process to continue running once your shell is closed.


## List Current Jobs

```shell
$ tail -f /var/log/syslog > log.txt
[1]+ Stopped      tail -f /var/log/syslog > log.txt

$ sleep 10 &

$ jobs
[1]+ Stopped      tail -f /var/log/syslog > log.txt
[2]- Running      sleep 10 &
```


## Finding information about a running process

`ps aux | grep <search-term>` shows processes matching _search-term_


## List all processes

There are two common ways to list all processes on a system. Both list all processes by all users, though they differ in
the format they output (the reason for the differences is historical).

```shell
ps -ef    # lists all processes
ps aux    # lists all processes in alternative format (BSD)
```

This can be used to check if a given application is running. For example, to check if the SSH server (sshd) is running:

`ps -ef | grep sshd`