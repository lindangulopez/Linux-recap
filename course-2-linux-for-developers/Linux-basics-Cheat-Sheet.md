# **Linux for Developers — Quick Cheat Sheet**

### **Linux Basics**

* Kernel = core of the system
* Distribution = kernel + utilities + package manager
* Everything is a file (almost!)

---

### **Command Line Essentials**

* Navigation: `ls`, `cd`, `pwd`
* File operations: `cp`, `mv`, `rm`, `mkdir`, `touch`
* Viewing text: `cat`, `less`, `grep`, `tail`, `head`
* Redirecting output: `>`, `>>`, `|` (pipes)

---

### **System Operations**

* Processes: `ps`, `top`, `htop`, `kill`
* Disk & memory: `df`, `du`, `free`
* System info: `uname`, `hostnamectl`, `dmesg`

---

### **Users & Permissions**

* Manage users/groups: `useradd`, `passwd`, `groupadd`
* View permissions: `ls -l`
* Change permissions/ownership: `chmod`, `chown`

---

### **Package Management**

* Install, update, remove packages
* Package managers vary by distro (apt, dnf, yum, pacman, etc.)

---

### **System Services**

* Using systemd:

  * Start/stop service: `systemctl start/stop service`
  * Check status: `systemctl status service`

---

### **Logs & Troubleshooting**

* Logs stored in `/var/log`
* Common tools: `journalctl`, `dmesg`, `tail`

---

### **Developer Awareness**

* Know difference between kernel contributions and user-space contributions
* Understand Linux’s open-source development model
* Use Git and CI/CD workflows for collaboration

