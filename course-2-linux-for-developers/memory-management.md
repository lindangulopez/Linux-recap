# 1️⃣ **Virtual Memory Basics**

Linux uses a **virtual memory system**, like all modern operating systems. Virtual memory gives each process its own private, protected address space and allows the system to use **more memory than physically installed** by combining RAM with **swap**.

Below is a clear breakdown of the key concepts.

### **Per-process virtual address space**

Every process gets its *own* virtual address space.
These addresses are **not** physical — the kernel translates them to actual RAM locations.

### **Kernel uses virtual addresses too**

The kernel also uses virtual addresses. Depending on the architecture, the mapping can be simple (like an offset) or more complex.

### **User vs kernel memory split**

On 32-bit systems:

* First **3 GB** → user space
* Upper **1 GB** → kernel space

On 64-bit systems, the virtual address space is enormous, so memory limits are far more flexible.

---

# 2️⃣ **How Linux Allocates Memory**

Linux tries to give each running process a *fair share* of memory. It also:

* Shares memory pages between processes when possible
* Uses memory-mapped files to map file contents directly into memory
* Protects some memory regions against writing or execution

This ensures performance and security.

---

# 3️⃣ **Page Cache and Buffers**

A large portion of “used” memory on Linux is actually **page cache**, which stores:

* File contents
* Directory metadata (dentries)
* Inodes

Caching makes repeated file and disk operations much faster.

### Example:

The `free -mt` command may show most memory as “used,” but much of that is reclaimable cache.

---

# 4️⃣ **Inspecting Memory Usage**

### **Using `free -mt`**

Displays:

* Total RAM
* Used/free memory
* Buffers/cache
* Available memory
* Swap usage

Linux might appear to “use” most of the RAM, but cached memory is available to applications when needed.

### **Clearing caches (for demonstration/testing)**

You can force Linux to drop caches:

```bash
sudo su
echo 3 > /proc/sys/vm/drop_caches
exit
```

* `1` → drop page cache
* `2` → drop dentries & inodes
* `3` → drop *all* of the above

After clearing caches, `free -mt` shows much more “free” memory — but performance may temporarily decline because Linux will need to rebuild the cache.

---

# 5️⃣ **Detailed Memory Information**

`/proc/meminfo` provides a detailed breakdown of memory state, such as:

* `MemTotal`, `MemFree`, `MemAvailable`
* `Buffers`, `Cached`
* `Active`, `Inactive`
* `SwapCached`

This file varies across kernel versions, so scripts should not rely on exact field names.

---

# 6️⃣ **Memory Limits on 32-bit vs 64-bit**

### **32-bit systems**

* Max 4 GB address space per process
* ~3 GB usable for applications
* Top 1 GB reserved for kernel
* Large RAM (over 4 GB) requires complex addressing hacks
* Rarely used today except in embedded systems

### **64-bit systems**

* Vast address space
* No practical per-process memory constraint for typical workloads
* Much simpler memory management

Modern systems overwhelmingly use 64-bit architecture.

---

# 7️⃣ **Caching and Disk Writes**

Applications **do not write directly to disk**.
Instead:

1. Data is written to the page cache.
2. Linux flushes cached data to disk when needed or when convenient.

This improves performance but means memory often appears heavily used by cache.

---

# 8️⃣ **Further Reading**

The course recommends Ulrich Drepper’s famous paper:

**“What Every Programmer Should Know About Memory”**
It explains:

* CPU caching
* NUMA
* Memory alignment
* Virtualization
* Hardware-level behavior

It’s considered essential reading for systems programmers.

---

# ✅ **Summary: What You Should Remember**

* Linux uses *virtual memory* to give each process a private address space.
* RAM and swap together form a larger virtual memory pool.
* Most RAM “usage” is often cache, which is good and improves performance.
* The kernel drops cache when needed or when explicitly told.
* `/proc/meminfo` shows the real picture of system memory.
* 32-bit memory handling is complex and outdated; 64-bit is the modern standard.
* Disk writes go through memory (cache) first.
