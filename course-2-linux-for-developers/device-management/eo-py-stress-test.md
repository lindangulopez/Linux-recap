# **log CPU, memory, and I/O metrics during the stress test and EO processing**

This lets you **see system behavior over time** while processing EO data under stress.

With this setup, you now have a **full workflow**:

1. Simulate heavy workloads (`stress`)
2. Process EO satellite images (Python NDVI)
3. Log CPU, memory, and disk I/O metrics to CSV
4. Plot and analyze system performance

---

## Step 1: Updated Bash Workflow (`stress_eo_log.sh`)

```bash
#!/bin/bash

# Duration of stress test in seconds
DURATION=120

# Log files
CPU_MEM_LOG="cpu_mem_log.csv"
IO_LOG="io_log.csv"

# Prepare log files with headers
echo "timestamp,usr,sys,idle,mem_free" > $CPU_MEM_LOG
echo "timestamp,tps,read_kB/s,write_kB/s" > $IO_LOG

# Start logging CPU & memory every 2 seconds
vmstat 2 $((DURATION/2)) | while read line; do
    # Skip headers
    [[ "$line" == pro* ]] && continue
    [[ "$line" == r* ]] && continue

    # Extract relevant columns
    ts=$(date +%s)
    usr=$(echo $line | awk '{print $13}')
    sys=$(echo $line | awk '{print $14}')
    idle=$(echo $line | awk '{print $15}')
    free_mem=$(echo $line | awk '{print $4}')
    
    echo "$ts,$usr,$sys,$idle,$free_mem" >> $CPU_MEM_LOG
done &

# Start logging I/O every 2 seconds
iostat -d 2 $((DURATION/2)) | while read line; do
    # Skip headers
    [[ "$line" == Device* ]] && continue
    [[ "$line" == avg* ]] && continue
    [[ -z "$line" ]] && continue

    ts=$(date +%s)
    tps=$(echo $line | awk '{print $2}')
    read_kb=$(echo $line | awk '{print $3}')
    write_kb=$(echo $line | awk '{print $4}')

    echo "$ts,$tps,$read_kb,$write_kb" >> $IO_LOG
done &

# Start stress test
echo "Starting stress test..."
stress -c 8 -i 4 -m 6 --vm-bytes 512M -t ${DURATION}s &

# Run EO processing
echo "Processing sample EO images..."
python3 process_ndvi.py

# Wait for background logging & stress test
wait
echo "Stress test and EO processing completed. Logs saved to $CPU_MEM_LOG and $IO_LOG"
```

**Notes:**

* `vmstat 2` logs CPU and memory every 2 seconds.
* `iostat -d 2` logs disk I/O every 2 seconds.
* Logs are saved to CSV for later analysis.

---

## Step 2: Python EO Workflow (`process_ndvi.py`)

Use the same script from before (NDVI processing). You can increase the number of images to simulate heavier workloads:

```python
images = [("B04.tif", "B08.tif")] * 5  # heavier load
```

---

## Step 3: Run the Workflow

```bash
chmod +x stress_eo_log.sh
./stress_eo_log.sh
```

While it runs:

* CPU, memory, and I/O metrics are continuously logged.
* NDVI images are processed in parallel.

---

## Step 4: Analyze Logs

After completion:

1. Open CSV files:

```bash
head cpu_mem_log.csv
head io_log.csv
```

2. You can plot metrics in Python:

```python
import pandas as pd
import matplotlib.pyplot as plt

# CPU & memory
cpu_mem = pd.read_csv("cpu_mem_log.csv")
plt.plot(cpu_mem['timestamp'], cpu_mem['usr'], label='usr')
plt.plot(cpu_mem['timestamp'], cpu_mem['sys'], label='sys')
plt.plot(cpu_mem['timestamp'], cpu_mem['idle'], label='idle')
plt.xlabel('Timestamp')
plt.ylabel('CPU %')
plt.legend()
plt.show()

# Memory free
plt.plot(cpu_mem['timestamp'], cpu_mem['mem_free'])
plt.xlabel('Timestamp')
plt.ylabel('Free Memory (kB)')
plt.show()

# Disk I/O
io = pd.read_csv("io_log.csv")
plt.plot(io['timestamp'], io['read_kB/s'], label='read')
plt.plot(io['timestamp'], io['write_kB/s'], label='write')
plt.xlabel('Timestamp')
plt.ylabel('KB/s')
plt.legend()
plt.show()
```



