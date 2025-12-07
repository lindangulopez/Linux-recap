# **How the OOM Killer decides which processes to kill first**. 

Linux doesn’t just randomly terminate processes—it uses a scoring system.

---

### **1. Badness Score**

Each process gets an **OOM “badness score”** calculated by the kernel. Factors include:

1. **Memory usage** – bigger memory consumers are more likely to be killed.

   * Virtual memory (`VmSize`) matters, not just resident memory.
2. **Process priority / importance** – processes running as `root` or with `oom_score_adj` set low are less likely to be killed.
3. **User vs system processes** – user processes are preferred targets; kernel threads are usually protected.
4. **Process age** – newer processes may be slightly more likely to be killed than long-lived ones, but memory usage dominates.

The kernel then **picks the process with the highest score** to terminate.

---

### **2. The role of `oom_score_adj`**

* Each process has a parameter called **`/proc/<pid>/oom_score_adj`**.
* It allows **adjusting the likelihood** of being killed:

  * `-1000` → almost never killed (protected, e.g., critical system processes)
  * `0` → default behavior
  * `+1000` → very likely to be killed first

You can inspect it with:

```bash
cat /proc/<pid>/oom_score_adj
```

---

### **3. What happens to the process that’s killed**

* The OOM Killer terminates the process immediately.
* Any allocated memory is freed back to the system.
* You’ll see a message in `dmesg`:

```
Out of memory: Kill process 1234 (lab_wastemem) score 500 or sacrifice child
Killed process 1234 (lab_wastemem) total-vm:...
```

* This message tells you **which process was chosen and why**.

---

### **4. Typical pattern**

In your lab:

* Running `lab_wastemem` multiple times with increasing memory allocation:

  * The **last instance allocating the most memory** is usually killed first.
  * Smaller or older processes may survive longer.

* If you watch `dmesg -w`, you’ll see multiple OOM events as memory keeps getting consumed.

---

✅ **Summary:**
The OOM Killer uses a combination of **memory usage, process importance, and adjustment scores** to pick the “best” process to sacrifice. This is why some processes survive while others die first.
