# Linux environment map

1. **Filesystem hierarchy:** Know what directories exist and their roles.
2. **Partitions:** Understand root, boot, and optional partitions.
3. **PATH:** How the shell finds commands and how to modify search paths.
4. **Command flow:** From typing a command to execution and redirection.
5. **Navigation:** Absolute vs relative paths and CDPATH usage.

Here’s a **combined Linux environment map** integrating **filesystem layout, partitions, and PATH** for a complete overview of your Linux system:

---

```
[Partitions / Disks]
┌─────────────────────────────┐
│ /dev/sda (GPT/MBR)          │
│ ├─ /dev/sda1 → /boot        │ Bootloader & kernel
│ ├─ /dev/sda2 → /            │ Root filesystem
│ │   ├─ bin, sbin, lib       │ Essential binaries & libraries
│ │   ├─ etc                   │ System configs
│ │   ├─ root                  │ Root user's home
│ │   ├─ home                  │ User home directories
│ │   ├─ tmp                   │ Temporary files (cleared on reboot)
│ │   ├─ var                   │ Variable data (logs, mail, runtime info)
│ │   └─ usr                   │ Non-essential apps, libraries, shared data
│ │       ├─ bin, sbin         │ User & system binaries
│ │       ├─ lib, lib64        │ Libraries
│ │       ├─ include           │ Header files
│ │       ├─ share             │ Architecture-independent data
│ │       └─ local             │ Host-specific programs & data
│ └─ /dev/sda3 → optional       │ e.g., /opt or extra storage
└─────────────────────────────┘

> a concise summary of the filesystem layout, partitions, and path concepts

## **1. Linux Filesystem Layout**

### **Key Directories Under `/`**

| Directory | Purpose                                               |
| --------- | ----------------------------------------------------- |
| `/`       | Root of the filesystem                                |
| `/bin`    | Essential binaries needed in single-user mode         |
| `/sbin`   | Essential system binaries for root                    |
| `/boot`   | Bootloader, kernel, initrd/initramfs                  |
| `/dev`    | Device files for hardware and virtual devices         |
| `/etc`    | System-wide configuration files                       |
| `/home`   | User home directories and personal files              |
| `/lib`    | Libraries for binaries in `/bin` and `/sbin`          |
| `/lib64`  | 64-bit libraries for systems with multi-arch support  |
| `/media`  | Mount points for removable media (CD, USB)            |
| `/mnt`    | Temporary mount points                                |
| `/opt`    | Optional software packages                            |
| `/proc`   | Virtual filesystem with system/process info           |
| `/run`    | Runtime system info since boot                        |
| `/sys`    | Pseudo-filesystem for system and device info          |
| `/root`   | Root user’s home directory                            |
| `/srv`    | Site-specific data served by system                   |
| `/tmp`    | Temporary files (often cleared on reboot)             |
| `/usr`    | Multi-user applications and utilities (non-essential) |
| `/var`    | Variable files that change during operation           |

> **Minimal boot system:** `/bin`, `/sbin`, `/etc`, `/lib`, `/root` (with `/boot` required for kernel and bootloader).

---

### **Subdirectories in `/usr`**

| Directory      | Purpose                                              |
| -------------- | ---------------------------------------------------- |
| `/usr/bin`     | User applications not needed for single-user mode    |
| `/usr/sbin`    | Non-essential system binaries/daemons                |
| `/usr/lib`     | Libraries for programs in `/usr/bin` and `/usr/sbin` |
| `/usr/include` | Header files for compiling programs                  |
| `/usr/share`   | Architecture-independent shared data                 |
| `/usr/src`     | Source code (usually kernel)                         |
| `/usr/local`   | Host-specific local programs and data                |

---

### **Subdirectories in `/var`**

| Directory    | Purpose                                      |
| ------------ | -------------------------------------------- |
| `/var/lib`   | Persistent program data                      |
| `/var/log`   | Log files                                    |
| `/var/mail`  | User mailboxes                               |
| `/var/run`   | Runtime system info since last boot          |
| `/var/spool` | Spool directories (print queues, mail, etc.) |
| `/var/tmp`   | Temporary files preserved across reboots     |
| `/var/www`   | Web server root directories                  |

---

## **2. Partitions**

* **Primary partitions:** Up to 4 on MBR disks.
* **Extended partitions:** Can hold multiple logical partitions.
* **GPT (UEFI):** Up to 128 partitions, more modern/flexible.
* Linux kernel detects disks at boot; hotplugged disks detected by `udev`.
* **Commands:**

  * List partitions: `$ sudo fdisk -l`
  * Format partition: `$ sudo mkfs -t ext4 /dev/sdaX`

> **Note:** Resizing requires adjusting both the filesystem and the partition.

---

## **3. Paths and PATH Variable**

* **PATH** defines directories searched for executables.
* **Check PATH:**

```bash
echo $PATH
```

* **Add directories:**

```bash
MY_BIN_DIR=$HOME/my_bin_dir
export PATH=$MY_BIN_DIR:$PATH   # prepend
export PATH=$PATH:$MY_BIN_DIR   # append
```

* **Absolute vs relative paths:**

  * Absolute: starts with `/` → full filesystem location
  * Relative: relative to current directory → `./program` to run in current dir

* **CDPATH:** Paths searched by `cd` for directory changes:

```bash
export CDPATH=/usr:$CDPATH
```

* **`which` command:** Shows which executable is used:

```bash
which --skip-alias emacs
```

---

### **Key Takeaways**

1. `/` is root; essential directories for booting are `/bin`, `/sbin`, `/etc`, `/lib`, `/root`, `/boot`.
2. `/usr` contains non-essential binaries, libraries, and shared data.
3. `/var` holds variable system data like logs, mail, and runtime info.
4. Partitions can be primary, extended, or GPT-based; formatting uses `mkfs`.
5. PATH determines which directories are searched for commands; prepend to prioritize, append to keep default priority.
6. CDPATH simplifies directory navigation.

---

