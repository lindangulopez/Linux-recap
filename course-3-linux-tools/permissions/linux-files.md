# Types of Files in Linux

In Linux, **everything is a file**.
However, files come in **different types**, which determine how the system treats them.

## Key Takeaways

✔ Linux has multiple file types, not just “files”
✔ Permissions control who can read, write, and execute
✔ `chmod`, `chown`, and `chgrp` manage access
✔ `umask` controls default permissions
✔ `setuid` grants elevated privileges — **dangerous if misused**

### Why Not setuid Scripts?

Linux **ignores setuid on shell scripts** for security reasons.
Only **compiled binaries** can safely use setuid.

---

## Viewing File Types

Run:

```bash
ls -lF
```

Example output:

```text
brw-r--r--  a_block_device_node
crw-r--r--  a_character_device_node
drwxrwxr-x  a_directory/
prw-rw-r--  a_fifo|
-rw-rw-r--  a_file
lrwxrwxrwx  a_symbolic_link_to_directory -> /usr/
srwxrwxr-x  a_socket
```

---

## Understanding `ls -l` Output

The **first character** shows the **file type**:

| Character | File Type         | Meaning                     |
| --------- | ----------------- | --------------------------- |
| `-`       | Regular file      | Text, binaries, images      |
| `d`       | Directory         | Folder                      |
| `l`       | Symbolic link     | Pointer to another file     |
| `p`       | Named pipe (FIFO) | Inter-process communication |
| `s`       | Socket            | IPC, networking             |
| `b`       | Block device      | Disks (HDD, SSD)            |
| `c`       | Character device  | Keyboards, terminals        |

### Example

```text
drwxrwxr-x
^
This "d" means directory
```

---

## The `file` Command

To find out **what a file really is**, use:

```bash
file filename
```

Example:

```bash
file *
```

Output:

```text
awkit.sh: Bourne-Again shell script text executable
blank:   JPEG image data
acpitool: ELF 64-bit executable
```

👉 Unlike `ls`, `file` looks at **file contents**, not just the name or permissions.

---

# File Permissions and Ownership

Each file has:

* **Owner (user)**
* **Group**
* **Others (world)**

And three permissions:

* **Read (r)**
* **Write (w)**
* **Execute (x)**

Example:

```text
-rw-rw-r--
```

| Part  | Meaning            |
| ----- | ------------------ |
| `rw-` | Owner permissions  |
| `rw-` | Group permissions  |
| `r--` | Others permissions |

---

## Changing Permissions with `chmod`

### Symbolic Method (Readable)

```bash
chmod uo+x,g-w a_file
```

Meaning:

* `u` → user (owner)
* `g` → group
* `o` → others
* `+` add permission
* `-` remove permission

Result:

```text
-rwxr--r-x
```

---

### Numeric (Octal) Method

Each permission has a value:

| Permission | Value |
| ---------- | ----- |
| Read       | 4     |
| Write      | 2     |
| Execute    | 1     |

Add them together:

| Number | Meaning |
| ------ | ------- |
| 7      | rwx     |
| 6      | rw-     |
| 5      | r-x     |
| 4      | r--     |

Example:

```bash
chmod 755 a_file
```

Means:

* Owner: rwx (7)
* Group: r-x (5)
* Others: r-x (5)

---

## Changing Ownership

### Change group

```bash
chgrp aproject a_file
```

### Change owner

```bash
chown coop a_file
```

### Change both

```bash
chown coop.aproject a_file
```

---

## Recursive Changes (`-R`)

Apply changes to a directory **and everything inside it**:

```bash
chown -R coop.aproject .
```

⚠️ You can only change:

* Files you own
* Groups you belong to
  Otherwise, you must use `sudo`.

---

# Default Permissions and `umask`

## Creating a File

```bash
touch afile
ls -l afile
```

```text
-rw-rw-r--
```

### Why not `rw-rw-rw-`?

By default, files are created with:

```text
0666 (rw-rw-rw-)
```

But **umask removes permissions**.

---

## Viewing the umask

```bash
umask
```

Output:

```text
0002
```

Calculation:

```text
0666 & ~0002 = 0664
```

Result:

```text
rw-rw-r--
```

---

## Changing umask

```bash
umask 0022
touch afile2

umask 0666
touch afile3

ls -l afile*
```

👉 `umask` affects **future files only**.

---

# Using `chmod` Symbolically (Lab)

Examples:

```bash
chmod u=r,g=w,o=x afile
chmod u=+w,g=-w,o=+rw afile
chmod ug=rwx,o=-rw afile
```

After each command:

```bash
ls -l afile
```

This method is often **clearer and safer** than numeric mode.

---

# setuid (Set User ID)

## What Is setuid?

Normally, programs run with **your privileges**.

With **setuid**, a program runs with the **owner’s privileges**.

### Example Use

* Allow users to perform **limited administrative tasks**
* Must be used **very carefully**

---

## Example: Why setuid Is Dangerous

Compile the program:

```bash
gcc -o writeit writeit.c
```

Try writing to a root-owned file:

```bash
sudo touch afile
./writeit afile
```

Output:

```text
wrote -1 bytes
```

Run as root:

```bash
sudo ./writeit afile
wrote 15 bytes
```

---

## setuid in Action

```bash
sudo chown root.root writeit
sudo chmod +s writeit
```

Now:

```bash
./writeit afile
wrote 15 bytes
```

👉 The program runs with **root privileges**.

---


