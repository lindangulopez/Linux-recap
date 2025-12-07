# **visual cheat sheet diagram** 

Linux basic commands and utilities, grouped by category and included primary use cases.


```
+-------------------------------------------------------------+
|                 LINUX COMMANDS CHEAT SHEET                  |
+----------------------+--------------------------------------+
| CATEGORY             | COMMANDS / USAGE                     |
+----------------------+--------------------------------------+
| File Compression     | gzip, gunzip      -> compress/decompress files
|                      | bzip2, bunzip2    -> better compression ratio
|                      | zip, unzip        -> archive multiple files
|                      | xz, unxz          -> high compression for backups
|                      | zcat, bzcat       -> view compressed files
|                      | zless, bzless     -> paginate compressed files
+----------------------+--------------------------------------+
| File Ownership &     | chmod 755 file.txt -> set permissions
| Permissions          | chown user:group file.txt -> change owner
|                      | chgrp group file.txt -> change group
|                      | attr/getfattr      -> extended attributes
+----------------------+--------------------------------------+
| Files / Text         | cat file.txt       -> view file contents
| Processing           | less/more          -> paginate through files
|                      | head/tail          -> view first/last lines
|                      | grep/egrep/fgrep   -> search text
|                      | awk, sed, cut      -> process text columns/patterns
|                      | cp, mv, rm         -> copy/move/delete files
|                      | tar -czvf archive  -> archive and compress
|                      | file filename      -> identify file type
+----------------------+--------------------------------------+
| Filesystem           | ls, ls -l          -> list directory
| Management           | cd, mkdir, rmdir   -> navigate/create/remove dirs
|                      | df -h, du -sh      -> check disk usage
|                      | ln -s              -> create symbolic links
|                      | fsck               -> check/repair filesystem
|                      | fuser              -> show processes using files
+----------------------+--------------------------------------+
| Networking           | ip addr, ip link   -> view interfaces
|                      | ifconfig           -> legacy interface management
|                      | ping               -> test connectivity
|                      | netstat -tuln      -> view ports/connections
|                      | route/ip route     -> view/change routing table
|                      | arp, hostname      -> MAC/IP info, hostname
|                      | ftp                -> file transfer
+----------------------+--------------------------------------+
| Job Control          | ps aux             -> view processes
|                      | kill, killall      -> terminate processes
|                      | at, atrm           -> schedule one-time jobs
|                      | crontab -e         -> schedule recurring tasks
|                      | exec, exit         -> execute commands / exit shell
|                      | ipcs / ipcrm       -> IPC resources
+----------------------+--------------------------------------+
| Expression Eval      | expr 5 + 3         -> integer arithmetic
| & Scripting Logic    | bc                 -> floating-point calculations
|                      | eval               -> evaluate expressions dynamically
|                      | factor             -> factor integers into primes
|                      | true / false       -> logical control in scripts
+----------------------+--------------------------------------+
```


Do you want me to create that?
