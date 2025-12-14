# Mounting Filesystems in Linux

✔ Linux uses a single filesystem tree rooted at `/`
✔ Mounting attaches filesystems to directories
✔ `/etc/fstab` controls automatic mounts
✔ Filesystems can be local, network, or virtual
✔ LVM adds flexibility to storage management
✔ Loopback filesystems allow safe experimentation


## 1. The Linux Filesystem Tree

In Linux (and UNIX-like systems), **all files live in one single directory tree**, which starts at:

```text
/
```

Unlike Windows (C:, D:, etc.), Linux **does not use drive letters**.
Instead, **different disks and partitions are attached (mounted)** at specific directories called **mount points**.

Example:

* `/` → root filesystem
* `/home` → user data
* `/boot` → boot files
* `/usr/local` → locally installed software

---

## 2. What Does “Mounting” Mean?

**Mounting** = attaching a filesystem (disk, partition, network share, or file) to a directory in the filesystem tree.

Before mounting:

```text
/dev/sda8   → not accessible
```

After mounting:

```text
/dev/sda8 → available at /usr/local
```

---

## 3. The `mount` Command

### Full syntax

```bash
sudo mount [-t type] [-o options] device directory
```

### Simple example

```bash
sudo mount /dev/sda8 /usr/local
```

Explanation:

* `/dev/sda8` → partition or device
* `/usr/local` → mount point (must exist)

👉 In most cases, Linux automatically detects the filesystem type.

---

## 4. Filesystem Types

Linux supports many filesystem types:

* ext4
* xfs
* btrfs
* vfat
* ntfs
* nfs (network)
* proc, sysfs (virtual)

View supported filesystems:

```bash
cat /proc/filesystems
```

Some filesystems (like `xfs`) are loaded **dynamically** as kernel modules.

---

## 5. Mounting by Device, Label, or UUID

All the following are **equivalent ways** to mount `/boot`:

```bash
sudo mount /dev/sda2 /boot
sudo mount LABEL=boot /boot
sudo mount -L boot /boot
sudo mount UUID=26d58ee2-9d20-4dc7-b6ab-aa87c3cfb69a /boot
sudo mount -U 26d58ee2-9d20-4dc7-b6ab-aa87c3cfb69a /boot
```

### Why prefer UUID or LABEL?

* Device names (`/dev/sda2`) may change at boot
* UUIDs and labels are **stable**

---

## 6. Automatic Mounting: `/etc/fstab`

Filesystems mounted at boot are defined in:

```bash
/etc/fstab
```

Each line specifies:

1. Device (UUID / LABEL)
2. Mount point
3. Filesystem type
4. Mount options
5. Dump option
6. fsck order

Example:

```text
UUID=xxxx  /home  ext4  defaults  0  2
```

---

## 7. Viewing Mounted Filesystems

### Show mounted filesystems

```bash
mount
```

Example output:

```text
/dev/sda5 on / type ext3 (rw)
/dev/mapper/VGN-local on /usr/local type ext4 (rw)
proc on /proc type proc (rw)
```

### Disk usage

```bash
df -h
```

---

## 8. Important Mounting Behavior

### Hidden Contents

If you mount a filesystem on a directory:

```bash
sudo mount /dev/sdb1 /mnt
```

Anything previously in `/mnt` is **hidden** until you unmount it.

---

### Multiple Mount Points

The same filesystem **can be mounted in more than one place**, and changes are visible everywhere.

---

## 9. Network Filesystems (NFS)

You can mount remote filesystems:

```bash
sudo mount server:/export/home /mnt/home
```

This is common in enterprise environments.

---

# Dynamic Filesystem Recognition (Example: XFS)

### Create a filesystem container

```bash
dd if=/dev/zero of=junk bs=1M count=512
```

### Format as XFS

```bash
mkfs.xfs junk
```

### Mount it

```bash
sudo mount junk /mnt
```

Linux automatically:

* Recognizes XFS
* Loads the kernel module (`lsmod | grep xfs`)

---

# RAID and LVM (Concept Overview)

## RAID (Redundant Array of Independent Disks)

RAID combines multiple disks for:

* **Performance** (striping)
* **Redundancy** (mirroring)
* **Fault tolerance** (parity)

Common RAID levels:

* RAID 0 – speed
* RAID 1 – mirroring
* RAID 5 – parity

---

## LVM (Logical Volume Management)

LVM adds **flexibility** on top of disks.

Hierarchy:

```text
Disk → Physical Volume (PV)
PV → Volume Group (VG)
VG → Logical Volume (LV)
LV → Filesystem → Mount
```

Advantages:

* Resize filesystems easily
* Combine multiple disks
* Add storage without downtime

---

## Creating a Volume Group (Ubuntu 24 VM)

### Step 1: Identify disks

```bash
lsblk
```

### Step 2: Create Physical Volume

```bash
sudo pvcreate /dev/sdb
```

### Step 3: Create Volume Group

```bash
sudo vgcreate VG1 /dev/sdb
```

### Step 4: Create Logical Volume

```bash
sudo lvcreate -L 4G -n lvdata VG1
```

### Step 5: Format and mount

```bash
sudo mkfs.ext4 /dev/VG1/lvdata
sudo mount /dev/VG1/lvdata /mnt/data
```

---

# Loopback Filesystems (Lab)

## What Is a Loopback Filesystem?

A **loopback filesystem** treats a **regular file** as if it were a disk.

Useful for:

* Testing
* Containers
* Virtual machines

---

## Creating a Loopback Filesystem

### Step 1: Create a file

```bash
dd if=/dev/zero of=/tmp/part bs=1M count=500
```

### Step 2: Format it

```bash
mkfs.ext4 /tmp/part
```

### Step 3: Mount it

```bash
mkdir /tmp/mntpart
sudo mount -o loop /tmp/part /tmp/mntpart
```

Verify:

```bash
df -h
```

---

## Checking and Tuning

### Unmount

```bash
sudo umount /tmp/mntpart
```

### Check filesystem

```bash
fsck.ext4 -f /tmp/part
```

### Inspect metadata

```bash
dumpe2fs /tmp/part
```

### Tune filesystem

```bash
tune2fs /tmp/part
```

---

## Performance Note

Loopback filesystems:

* Are slower than real partitions
* Are still extremely useful for labs and testing

---

