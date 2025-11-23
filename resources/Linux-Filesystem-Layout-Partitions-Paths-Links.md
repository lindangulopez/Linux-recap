# **Linux Filesystem Layout, Partitions, Paths, and Links**

This tutorial covers **filesystem layout, partitions, paths, and links** so you can confidently explore and configure your Linux system, including preparing for version control workflows with Git.

---

## **1. Linux Filesystem Layout**

Linux organizes files in a hierarchical tree starting from `/`. Some important directories include:

| Directory | Purpose                                                   |
| --------- | --------------------------------------------------------- |
| `/`       | Root of the filesystem                                    |
| `/bin`    | Essential binaries for single-user mode                   |
| `/boot`   | Bootloader and kernel files                               |
| `/dev`    | Device nodes for interacting with hardware                |
| `/etc`    | System-wide configuration files                           |
| `/home`   | User home directories                                     |
| `/lib`    | Libraries for binaries in `/bin` and `/sbin`              |
| `/media`  | Mount points for removable media (USB, CD, DVD)           |
| `/mnt`    | Temporary mount points for filesystems                    |
| `/opt`    | Optional application packages                             |
| `/proc`   | Virtual pseudo-filesystem with runtime system info        |
| `/run`    | System information since boot; cleared at reboot          |
| `/sbin`   | Essential system binaries                                 |
| `/tmp`    | Temporary files; often cleared on reboot                  |
| `/usr`    | Multi-user applications and shared data                   |
| `/var`    | Variable data that changes at runtime (logs, mail, spool) |

**Pseudo-filesystems** like `/proc` and `/sys` are empty when the system is not running, as they provide runtime information.

---

## **2. Partitions**

Linux disks are divided into **partitions**. Older systems used MBR (4 primary partitions + extended), while modern systems often use **GPT** (up to 128 partitions).

**Key commands:**

```bash
# List all partitions on the first hard disk
sudo fdisk -l /dev/sda

# Create or modify partitions interactively
sudo fdisk /dev/sda

# Format a partition with ext4
sudo mkfs.ext4 /dev/sda1
```

**Notes:**

* Resizing requires adjusting both the filesystem (`resize2fs`) and the partition table.
* Tools like `gparted` provide a GUI for partition management.

---

## **3. Paths and the PATH Variable**

The **PATH** variable determines where the shell looks for executables:

```bash
echo $PATH
```

Example output:

```
/usr/local/bin:/usr/bin:/bin:/home/student/bin
```

* **Prepending** a directory:

```bash
export PATH=$HOME/my_bin:$PATH
```

* **Appending** a directory:

```bash
export PATH=$PATH:$HOME/my_bin
```

**Special directories:**

* `.` → current directory
* `..` → parent directory
  Current directory is **not in PATH by default** for security reasons. Run files in the current directory as:

```bash
./my_script.sh
```

**CDPATH variable** can help when changing directories:

```bash
export CDPATH=/usr:$CDPATH
cd bin  # Searches /usr/bin as well
```

---

## **4. Hard Links vs Soft (Symbolic) Links**

### **Hard Links**

* Multiple filenames point to the same inode.
* Changes to one affect the other.
* Cannot cross filesystems.

**Commands:**

```bash
ln file1 file2      # Create a hard link
ls -li file1 file2  # Show inode numbers (they are identical)
```

### **Soft Links (Symlinks)**

* Pointer to a file or directory; can cross filesystems.
* Can become dangling if the target is deleted.

**Commands:**

```bash
ln -s file1 file2
ls -l file2         # Shows "file2 -> file1"
```

**Git Considerations:**

* Hard links: Git treats them as separate files.
* Soft links: Git tracks the symlink itself, not the content. Useful for shared configs or scripts.

---

## **5. Frequently Changing Directories**

Some directories contain dynamic data and are unsuitable for static partitions:

* `/var` → logs, mail, spool
* `/tmp` → temporary files
* `/home` → user files
* `/usr` → user-installed applications

---

## **6. Quick Ubuntu VM Practice**

1. **Check PATH:**

```bash
echo $PATH
```

2. **Add a directory to PATH:**

```bash
mkdir ~/my_bin
export PATH=$HOME/my_bin:$PATH
```

3. **Create hard and soft links:**

```bash
echo "Hello" > file1
ln file1 file2       # Hard link
ln -s file1 file3    # Soft link
ls -li file1 file2 file3
```

4. **Manage partitions:**

```bash
sudo fdisk -l /dev/sda
sudo mkfs.ext4 /dev/sda1
```

---

**Summary Table**

| Concept             | Example                          | Notes                               |
| ------------------- | -------------------------------- | ----------------------------------- |
| Hard link           | `ln file1 file2`                 | Shares inode; changes affect both   |
| Soft link (symlink) | `ln -s file1 file2`              | Points to filename; can be dangling |
| PATH variable       | `export PATH=$HOME/my_bin:$PATH` | Determines executable search order  |
| Dynamic dirs        | `/var, /tmp, /home, /usr`        | Not ideal for static partitions     |
| Partition info      | `sudo fdisk -l /dev/sda`         | Shows disk layout                   |

---

