# **Everyday Linux Commands**

* **File management**: `ls, cp, mv, rm, tar`
* **Permissions**: `chmod, chown, chgrp`
* **Networking**: `ip, ping, netstat`
* **Job control**: `kill, crontab, at`
* **Text processing**: `grep, awk, sed, cut`
* **Compression**: `gzip, bzip2, zip`
* **Evaluation**: `expr, bc, factor`

These commands are foundational for Linux system administration, scripting, and everyday tasks.

## **1. File Compression Utilities**

| Command             | Usage / Example                                                  | Use Case                                    |
| ------------------- | ---------------------------------------------------------------- | ------------------------------------------- |
| `gzip` / `gunzip`   | `gzip file.txt` → compress, `gunzip file.txt.gz` → decompress    | Compress large text files to save space     |
| `bzip2` / `bunzip2` | `bzip2 file.txt` → compress, `bunzip2 file.txt.bz2` → decompress | Better compression than gzip                |
| `zip` / `unzip`     | `zip archive.zip file1 file2`<br>`unzip archive.zip`             | Package multiple files into one archive     |
| `xz` / `unxz`       | `xz file.txt` → compress, `unxz file.txt.xz` → decompress        | Very high compression ratio for backups     |
| `zcat` / `bzcat`    | `zcat file.gz`                                                   | View compressed files without decompressing |
| `zless` / `bzless`  | `zless file.gz`                                                  | Paginate through compressed files           |

**Example:**

```bash
gzip report.txt        # compress
gunzip report.txt.gz   # decompress
zip project.zip file1 file2  # archive multiple files
unzip project.zip
```

---

## **2. File Ownership, Permissions, Attributes**

| Command | Example                          | Use Case                                  |
| ------- | -------------------------------- | ----------------------------------------- |
| `chown` | `sudo chown user:group file.txt` | Change owner and group of a file          |
| `chmod` | `chmod 755 script.sh`            | Set file permissions (read/write/execute) |
| `chgrp` | `sudo chgrp developers file.txt` | Change the group ownership                |
| `attr`  | `getfattr -d file.txt`           | Get/set extended filesystem attributes    |

**Example:**

```bash
chmod +x run.sh     # make script executable
sudo chown alice file.txt
sudo chgrp staff file.txt
```

---

## **3. File Utilities**

| Command                    | Example                                          | Use Case                                  |
| -------------------------- | ------------------------------------------------ | ----------------------------------------- |
| `cat`                      | `cat file.txt`                                   | View file contents                        |
| `less` / `more`            | `less file.txt`                                  | Paginate through large files              |
| `head` / `tail`            | `head -n 10 file.txt` / `tail -n 10 file.txt`    | View first/last lines                     |
| `grep` / `egrep` / `fgrep` | `grep "error" logfile`                           | Search text in files                      |
| `cut`                      | `cut -d',' -f1 file.csv`                         | Extract columns from text                 |
| `awk`                      | `awk '{print $2}' file.txt`                      | Process text files by columns or patterns |
| `cp` / `mv` / `rm`         | `cp file1 file2`, `mv file1 dir/`, `rm file.txt` | Copy, move, delete files                  |
| `tar`                      | `tar -czvf archive.tar.gz dir/`                  | Create compressed archives                |
| `file`                     | `file filename`                                  | Determine file type                       |

**Example:**

```bash
grep "ERROR" /var/log/syslog
head -n 20 /var/log/syslog
tail -f /var/log/syslog    # follow live updates
tar -xvzf backup.tar.gz    # extract archive
```

---

## **4. Filesystem Commands**

| Command           | Example                                | Use Case                           |
| ----------------- | -------------------------------------- | ---------------------------------- |
| `ls`              | `ls -l`                                | List directory contents            |
| `cd`              | `cd /home/user`                        | Change directory                   |
| `mkdir` / `rmdir` | `mkdir new_folder`, `rmdir old_folder` | Create or remove directories       |
| `df`              | `df -h`                                | Check disk space usage             |
| `du`              | `du -sh /home/user`                    | Check size of directories          |
| `ln`              | `ln -s /path/to/file linkname`         | Create symbolic links              |
| `fsck`            | `sudo fsck /dev/sda1`                  | Check and repair filesystem        |
| `fuser`           | `fuser -v /dev/sda1`                   | Show processes using a file/system |
| `mv` / `rm`       | Move or delete files/directories       |                                    |

**Example:**

```bash
mkdir projects
cd projects
ls -lh
du -sh *
df -h
```

---

## **5. Networking Commands**

| Command    | Example               | Use Case                             |
| ---------- | --------------------- | ------------------------------------ |
| `ip`       | `ip addr show`        | Show network interfaces              |
| `ifconfig` | `ifconfig eth0`       | View/bring up network interfaces     |
| `ping`     | `ping google.com`     | Test network connectivity            |
| `netstat`  | `netstat -tuln`       | Show listening ports and connections |
| `route`    | `ip route show`       | View routing table                   |
| `arp`      | `arp -n`              | View MAC to IP mappings              |
| `hostname` | `hostname`            | Show or set hostname                 |
| `ftp`      | `ftp ftp.example.com` | Transfer files over FTP              |

**Example:**

```bash
ip addr show
ping -c 4 google.com
netstat -tuln
sudo ip route add 192.168.1.0/24 via 192.168.1.1
```

---

## **6. Job Control Commands**

| Command            | Example                        | Use Case                                   |                         |
| ------------------ | ------------------------------ | ------------------------------------------ | ----------------------- |
| `ps`               | `ps aux`                       | Show running processes                     |                         |
| `kill` / `killall` | `kill 1234`, `killall firefox` | Terminate processes                        |                         |
| `at` / `atrm`      | `echo "ls"                     | at 14:00`                                  | Schedule one-time tasks |
| `crontab`          | `crontab -e`                   | Schedule recurring tasks                   |                         |
| `exec`             | `exec bash`                    | Replace current shell with another command |                         |
| `exit`             | `exit`                         | Exit a shell                               |                         |
| `ipcs` / `ipcrm`   | `ipcs -m`, `ipcrm -m 1234`     | View and remove IPC resources              |                         |

**Example:**

```bash
ps aux | grep python
kill 4321
crontab -l
```

---

## **7. Expression Evaluation**

| Command          | Example                      | Use Case                               |                             |
| ---------------- | ---------------------------- | -------------------------------------- | --------------------------- |
| `expr`           | `expr 5 + 3`                 | Simple arithmetic evaluation           |                             |
| `bc`             | `echo "3.14*2"               | bc`                                    | Floating-point calculations |
| `eval`           | `eval echo \$HOME`           | Evaluate shell expressions dynamically |                             |
| `factor`         | `factor 56`                  | Factor integers into primes            |                             |
| `true` / `false` | `if true; then echo yes; fi` | Shell scripting logic                  |                             |

**Example:**

```bash
expr 10 / 2
echo "scale=2; 10/3" | bc
factor 120
```




Do you want me to do that?
