# 1️⃣ What Swap Is & Why Linux Uses It

Linux uses **virtual memory**, which allows the system to act as if it has more RAM than physically installed.
Swap is a crucial part of this system, giving the kernel room to move inactive memory pages to disk.

Linux employs **virtual memory overcommitment**—programs are allowed to reserve more memory than the system physically has.

Linux can do this because:

### ✔ 1. Programs rarely use all memory they are allocated

Even when a program allocates memory:

* Much may stay unused.
* Child processes start with Copy-On-Write (COW):
  They share memory pages with the parent until one modifies a page.
  This saves huge amounts of RAM.

### ✔ 2. Inactive memory can be moved out of RAM

When RAM becomes tight, Linux swaps out least-used pages to disk.
These pages are loaded back only if accessed again.

Swap provides:

* Extra breathing room
* Protection against crashes
* Ability to run more applications
* More stable behavior under memory spikes

---

# 2️⃣ Where Swap Lives

Swap exists in one or more:

* **Swap partitions**
* **Swap files**
* **zram devices** (compressed RAM swap, common on Ubuntu)

Linux supports multiple swap areas, each with a **priority**.
Higher priority = used first.

---

# 3️⃣ Check Whether Swap Is Enabled

You can verify swap usage with any of these commands:

### **Method A — `/proc/swaps`**

```bash
cat /proc/swaps
```

Shows all active swap areas in detail.

---

### **Method B — `swapon --show` (recommended)**

```bash
swapon --show
```

A cleaner, modern way to view swap devices.

---

### **Method C — `free -h`**

```bash
free -h
```

Look at the **Swap** row:

```
Swap:  2.0G   0B   2.0G
```

---

# 4️⃣ Understanding `/proc/swaps`

`/proc/swaps` is a **virtual kernel file** listing active swap areas.

Example:

```
Filename            Type        Size       Used    Priority
/dev/sda9           partition   4193776    0       -1
/swapfile           file        1048576    0       -2
```

Column meanings:

| Column       | Meaning                         |
| ------------ | ------------------------------- |
| **Filename** | Swap device or file path        |
| **Type**     | partition / file / zram         |
| **Size**     | Total swap space (KB)           |
| **Used**     | How much swap is currently used |
| **Priority** | Higher = used first             |

Yes, **`/proc/swaps` always exists**, even with swap disabled.

---

# 5️⃣ Recommended Swap Size

A common general rule:

* **Swap ≈ size of RAM**

But depend on workload:

* Heavy workloads, VMs, editing large files → more swap
* Tiny systems (Raspberry Pi, old laptops) → prioritize using **zram**

---

# 6️⃣ The Only Real Swap Commands

Linux uses just **three tools** for swap administration:

### 1. Create a swap area:

```bash
mkswap /dev/sdXN
```

or for a swap file:

```bash
mkswap /swapfile
```

### 2. Enable swap:

```bash
swapon /dev/sdXN
```

### 3. Disable swap:

```bash
swapoff /dev/sdXN
```

---

# 7️⃣ How to Create a New Swap File (Most Common Task)

Here is the safe, standard method to create a **2 GB swap file**.

### **Step 1 — Create the file**

```bash
sudo fallocate -l 2G /swapfile
```

(Use `dd` if fallocate does not work.)

---

### **Step 2 — Secure the file**

Swap must not be readable by others:

```bash
sudo chmod 600 /swapfile
```

---

### **Step 3 — Format it as swap**

```bash
sudo mkswap /swapfile
```

---

### **Step 4 — Enable it immediately**

```bash
sudo swapon /swapfile
```

Verify:

```bash
swapon --show
```

---

### **Step 5 — Make it permanent**

Add to `/etc/fstab`:

```
/swapfile   none   swap   sw   0   0
```

Done — your system now has additional swap space.

---

# 8️⃣ Swap Priorities

If multiple swap areas exist, Linux chooses by **priority**:

* Higher number = used first
* Lower number = used later

You can set priority in `/etc/fstab`:

```
/fastswap   none   swap   pri=10   0 0
/slowswap   none   swap   pri=1    0 0
```

Usually:

* SSD swap → higher priority
* HDD swap → lower priority

---

# 9️⃣ What Can Be Swapped — and What Cannot

### ✔ Application memory

Yes — swapped when inactive.

### ✔ Anonymous memory (malloc, stacks)

Yes — swap is their only backing store.

### ❌ File-backed cache

Never swapped.
Because the data already exists on disk, Linux simply discards it instead of swapping.

### ❌ Kernel memory

Never swapped.
Critical for stability.

---

# 🔟 Summary Cheat Sheet

### Swap is:

* Extra virtual memory on disk
* Used when RAM is full or under pressure
* Essential for system stability

### Key commands:

```bash
cat /proc/swaps
swapon --show
free -h

mkswap /swapfile
swapon /swapfile
swapoff /swapfile
```

### Good practices:

* Use at least some swap on most systems
* Use swap files instead of partitions (more flexible)
* Use zram on low-RAM systems
* Set priorities for multiple swap sources

