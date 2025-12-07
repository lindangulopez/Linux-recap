# Monitoring and performance utilities

**Summary of Practical Usage**

| Task                | Recommended Tools        | Bash Example                |
| ------------------- | ------------------------ | --------------------------- |
| Check CPU usage     | top, mpstat, sar         | `top`                       |
| Check memory        | free, vmstat, pmap       | `free -h`                   |
| Monitor disk I/O    | iostat, iotop, vmstat    | `sudo iotop`                |
| Monitor network     | netstat, iptraf, tcpdump | `netstat -tulnp`            |
| Log stats over time | sar                      | `sar -u 2 50 > cpu_log.txt` |


## **1. Checking Processes and CPU Usage**

* **Goal:** See which processes are consuming CPU or memory.

**Commands:**

```bash
top             # Dynamic, real-time process monitor
ps aux          # Snapshot of all processes with details
pstree -p       # Shows process hierarchy with PIDs
mpstat -P ALL 2 # CPU usage per core, updates every 2 seconds
```

**Use Cases:**

* Identify a process that’s consuming too much CPU.
* Check if multiple cores are under load.
* Visualize process hierarchy to see which process spawned others.

---

## **2. Monitoring Memory**

* **Goal:** Track RAM and swap usage.

**Commands:**

```bash
free -h         # Human-readable summary of RAM and swap
vmstat 2 5      # Updates every 2 seconds, 5 times
pmap -x <PID>   # Memory map of a specific process
```

**Use Cases:**

* Detect if your system is running out of memory.
* Identify which process is using the most RAM.
* Monitor swap activity to prevent memory bottlenecks.

---

## **3. Disk and I/O Monitoring**

* **Goal:** Find disk bottlenecks or high I/O usage.

**Commands:**

```bash
iostat -xz 2    # CPU and disk I/O stats, updated every 2 seconds
sudo iotop      # Live I/O per process (requires root)
vmstat 2 5      # Also shows block I/O along with memory and CPU
```

**Use Cases:**

* See which process is writing/reading heavily to disk.
* Monitor overall disk performance and identify slow devices.
* Detect if high I/O is slowing down the system.

---

## **4. Network Monitoring**

* **Goal:** Check network connections, traffic, and troubleshoot issues.

**Commands:**

```bash
netstat -tulnp           # Check listening ports and active connections
sudo iptraf              # Real-time interface statistics
sudo tcpdump -i eth0     # Capture and analyze packets on eth0
wireshark                # GUI for detailed network packet analysis
```

**Use Cases:**

* Identify which process is listening on a port.
* Monitor live traffic for security or performance analysis.
* Debug network problems like packet drops or suspicious connections.

---

## **5. Collecting Historical Data**

* Some tools let you **log performance over time**:

```bash
sar -u 2 50 > cpu_log.txt   # Collect CPU stats every 2 sec, 50 times
sar -d 2 50 > io_log.txt    # Collect I/O stats
```

**Use Cases:**

* Track system performance trends.
* Analyze spikes in CPU, memory, or disk usage.
* Provide logs for troubleshooting or capacity planning.

---

## **6. Tips for Effective Use**

1. **Combine tools with grep/awk** to filter output:

```bash
ps aux | grep firefox
iostat -xz 2 | grep sda
```

2. **Use watch** for periodic monitoring:

```bash
watch -n 2 'free -h'
watch -n 2 'iostat -xz'
```

3. **Run as root** for full visibility:

* Some tools like `iotop`, `tcpdump`, and `iptraf` require root privileges.

4. **Use GUI tools** if you prefer visuals:

* GNOME System Monitor, KSysGuard, Wireshark.



