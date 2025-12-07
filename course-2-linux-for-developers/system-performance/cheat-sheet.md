# **Ubuntu 24 – System Monitoring Utilities Cheat Sheet**

This one-page cheat sheet covers **all major CLI system monitoring utilities in Ubuntu 24**, including commands and practical use cases for quick reference.

## **Tips for Quick Reference**

* **Real-time monitoring:** `top`, `htop`, `iotop`, `iptraf`.
* **Snapshots / Logs:** `ps`, `pmap`, `sar`, `iostat`.
* **Network troubleshooting:** `netstat`, `tcpdump`, `wireshark`.
* **Memory checks:** `free -h`, `vmstat`, `pmap`.
* **Enable sysstat for logging:**

```
+--------------------+-----------------------------+-----------------------------+-----------------------------------------+
| Category           | Utility                     | Command Example             | Use Case                                 |
+--------------------+-----------------------------+-----------------------------+-----------------------------------------+
| Process & CPU      | top                         | top                         | Live view of processes & CPU/mem usage  |
| Monitoring         | htop                        | htop                        | Interactive, colorized top              |
|                    | ps                          | ps aux                      | Snapshot of all running processes       |
|                    | pstree                      | pstree -p                   | Visual tree of processes                |
|                    | uptime                      | uptime                      | Check system uptime & load average      |
|                    | mpstat                      | mpstat -P ALL 2             | CPU usage per core                       |
+--------------------+-----------------------------+-----------------------------+-----------------------------------------+
| Memory             | free                        | free -h                     | Summary of RAM and swap usage           |
| Monitoring         | vmstat                      | vmstat 2 5                  | Dynamic memory, CPU & I/O stats         |
|                    | pmap                        | pmap -x <PID>               | Memory map of a process                  |
+--------------------+-----------------------------+-----------------------------+-----------------------------------------+
| Disk / I/O         | iostat                      | iostat -xz 2                | CPU & disk I/O statistics               |
| Monitoring         | iotop                       | sudo iotop                  | Live I/O usage per process              |
|                    | vmstat                      | vmstat 2 5                  | Block I/O, memory, CPU                  |
|                    | sar                         | sar -d 2 5                  | Historical I/O & performance logging   |
+--------------------+-----------------------------+-----------------------------+-----------------------------------------+
| Network            | netstat                     | netstat -tulnp              | Active connections & listening ports    |
| Monitoring         | iptraf                      | sudo iptraf                 | Real-time interface stats                |
|                    | tcpdump                     | sudo tcpdump -i eth0        | Capture & analyze network packets      |
|                    | wireshark                   | sudo wireshark              | Graphical detailed network analysis    |
+--------------------+-----------------------------+-----------------------------+-----------------------------------------+
| Logging / Reports  | sar                         | sar -u 2 10 > cpu_log.txt   | Log CPU usage over time                  |
|                    | sar                         | sar -d 2 10 > io_log.txt    | Log disk I/O usage over time             |
+--------------------+-----------------------------+-----------------------------+-----------------------------------------+
```

---

## Use Cases recap: 

* **Run as root** for full visibility (`sudo` needed for `iotop`, `tcpdump`, `iptraf`, etc.).

```bash
sudo apt install sysstat
sudo systemctl enable sysstat
sudo systemctl start sysstat
```

## **1. Process and Load Monitoring**

These tools help you see **which processes are running, their resource usage, and overall system load**.

**Use Cases:**

* Detect high CPU or memory usage.
* Identify runaway processes.
* Monitor multi-core CPU usage.

---

## **2. Memory Monitoring**

These utilities track **RAM and swap usage** and help detect memory bottlenecks.

**Use Cases:**

* Check available RAM and swap.
* Identify processes consuming excessive memory.
* Monitor memory allocation dynamically.

---

## **3. I/O Monitoring**

These tools monitor **disk activity** and **input/output operations**.

**Use Cases:**

* Detect slow disks or I/O bottlenecks.
* Identify processes causing high disk load.
* Analyze performance trends over time.

---

## **4. Network Monitoring**

These utilities help track **network connections and traffic**.

**Use Cases:**

* Check which services are listening on ports.
* Monitor live network traffic.
* Debug connectivity issues or packet loss.

---

## **5. Installing Useful Monitoring Tools**

On Ubuntu 24, some of these tools may not be installed by default. You can install them:

```bash
# Update package list
sudo apt update

# Process monitoring
sudo apt install htop pstree sysstat iotop

# Network monitoring
sudo apt install iptraf wireshark

# Enable sysstat for sar
sudo systemctl enable sysstat
sudo systemctl start sysstat
```

---

## **6. Practical Usage Examples**

1. **Monitor CPU and processes live**

```bash
top
htop
```

2. **Check memory usage**

```bash
free -h
vmstat 2 5
pmap -x 1234  # replace 1234 with a process PID
```

3. **Monitor disk I/O**

```bash
sudo iotop
iostat -xz 2
```

4. **Check network activity**

```bash
netstat -tulnp
sudo iptraf
sudo tcpdump -i eth0
```

5. **Log historical data**

```bash
sar -u 2 10 > cpu_log.txt   # CPU usage every 2 seconds, 10 times
sar -d 2 10 > io_log.txt    # Disk I/O logging
```

---



