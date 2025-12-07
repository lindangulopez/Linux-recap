# Linux Network Interfaces and Routing

A walk throuh **Networking and Network Interfaces in Linux** with **example commands with expected results**

## Diagrams: 

-----------------------------------------------------------
Linux Network Interfaces and Routing
-----------------------------------------------------------

                +-------------------+
                |    Loopback (lo)  |
                |  IP: 127.0.0.1    |
                +---------+---------+
                          |
                          | (internal packets)
                          v
                 +------------------+
                 | Local Applications|
                 +------------------+

-----------------------------------------------------------
External Network Interfaces (Ethernet/Wireless)
-----------------------------------------------------------

          +--------------------+
          |      eth0 / eno1   | <-- Physical NIC
          |  IP: 192.168.1.7   |
          |  MTU: 1500 bytes   |
          +---------+----------+
                    |
   +----------------+----------------+
   |                                 |
Packets to local LAN            Packets to Internet
   |                                 |
   v                                 v
192.168.1.0/24 network        Default gateway: 192.168.1.1
router/other hosts             ISP / router






## **1. Network Programming in Linux**

* Most Linux network programming is done using **sockets**.
* Programs using standard socket APIs (`socket()`, `bind()`, `connect()`, `send()`, `recv()`) are generally portable across Unix/Linux systems.
* Linux also adds **enhancements**, like:

  * **Netlink sockets**: allow communication between **kernel and user-space** programs. Used for firewalls, routing, network configuration, etc.

---

## **2. Network Interfaces**

### **Interface Names**

* Wired Ethernet: `eth0`, `eth1` (older), or `eno1`, `ens33` (newer predictable names).
* Wireless: `wlan0`, `wlan1`, etc.
* Loopback interface (internal traffic): `lo`.

---

### **3. Checking Network Interface Status**

**Using `ip` (modern)**:

```bash
$ ip -s link
```

**Example output:**

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast
    30112      403      0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    30112      403      0       0       0       0

2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:1a:2b:3c:4d:5e brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    1048576    1200     0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    2097152    1800     0       0       0       0
```

**Explanation:**

* `lo`: loopback interface, internal only.
* `eno1`: real network card.
* `RX`/`TX`: bytes and packets received/transmitted.
* `MTU`: Maximum Transmission Unit (max packet size).

---

### **4. Checking Interface Stats via `/sys`**

Each interface has a directory like `/sys/class/net/eno1/statistics`:

```bash
$ ls -l /sys/class/net/eno1/statistics
-r--r--r-- 1 root root 4096 Feb 10 11:55 collisions
-r--r--r-- 1 root root 4096 Feb 10 11:55 rx_bytes
-r--r--r-- 1 root root 4096 Feb 10 11:55 tx_bytes
-r--r--r-- 1 root root 4096 Feb 10 11:55 rx_errors
...
```

* Each file contains **one numeric value**: e.g., `rx_bytes` shows total received bytes.

---

## **5. Bringing Interfaces Up and Assigning IPs**

### **a) Using `ifconfig` (older tool)**

* Static IP:

```bash
$ sudo ifconfig eth0 up 192.168.1.100
```

* DHCP (dynamic IP):

```bash
$ sudo ifconfig eth0 up
$ sudo dhclient eth0
```

### **b) Using `ip` (modern tool, recommended)**

* Bring interface up:

```bash
$ sudo ip link set eth0 up
```

* Assign static IP:

```bash
$ sudo ip addr add 192.168.1.7/24 dev eth0
```

* Bring interface down:

```bash
$ sudo ip link set eth0 down
```

* Change MTU:

```bash
$ sudo ip link set eth0 mtu 1480
```

* Show interface info:

```bash
$ ip link show eth0
$ ip -s link show eth0
```

---

## **6. Routing**

* Add a route:

```bash
$ sudo ip route add 192.168.1.0/24 via 192.168.1.1 dev eth0
```

* This sets the route for all traffic to the `192.168.1.0/24` network through the gateway `192.168.1.1`.

* View routing table:

```bash
$ ip route show
```

**Example output:**

```
default via 192.168.1.1 dev eth0
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.7
```

---

## **7. Summary Table of Commands**

| Task                 | Command                                                     |
| -------------------- | ----------------------------------------------------------- |
| Show all interfaces  | `ip link`                                                   |
| Show detailed stats  | `ip -s link`                                                |
| Bring interface up   | `sudo ip link set eth0 up`                                  |
| Bring interface down | `sudo ip link set eth0 down`                                |
| Set static IP        | `sudo ip addr add 192.168.1.7/24 dev eth0`                  |
| Set MTU              | `sudo ip link set eth0 mtu 1480`                            |
| Add route            | `sudo ip route add 192.168.1.0/24 via 192.168.1.1 dev eth0` |
| DHCP IP              | `sudo dhclient eth0`                                        |

---

If you want, I can make a **diagram showing how `lo`, `eth0`, and routing interact**, including packets going through the interface and the effect of changing MTU or bringing interfaces up/down. It makes this much easier to visualize.

Do you want me to do that?
