# 📘 Ubuntu 24 Tutorial

## Upgrading and Patching Software (Software Heritage–Style Operations)

> **Audience**: Developers, sysadmins, and contributors working on Software Heritage–like infrastructures
> **Platform**: Ubuntu 24.04 LTS
> **Scope**: Secure, reliable upgrades with minimal downtime

---

## 1. Why Upgrading Matters

Keeping a Linux system up to date is essential for:

* 🚀 **New features**
* ⚡ **Performance and optimization**
* 🐛 **Bug fixes**
* 🔐 **Security vulnerability mitigation**

In many operating systems, patching involves:

* Manual patch application
* Frequent reboots
* High operational risk on servers

Linux avoids most of these problems by design.

---

## 2. The Linux Upgrade Model (Key Concept)

Linux **does not patch binaries in place**.

Instead:

* A **complete new package** replaces the old one
* Dependency consistency is enforced
* Rollbacks and recovery are safer

This model is especially valuable for:

* Long-running services
* Distributed systems
* Large-scale infrastructures like **Software Heritage**

---

## 3. Ubuntu 24 Package Management Basics

Ubuntu uses **deb packages** and two main tools:

### Low-level (rarely used)

* `dpkg`
* No dependency resolution
* Manual and error-prone

```bash
sudo dpkg --install foo.deb
```

### High-level (recommended)

* `apt`
* Automatic dependency resolution
* Repository-based upgrades

```bash
sudo apt install foo
```

✅ **Always prefer `apt` for upgrades and patching**

---

## 4. Updating Packages on Ubuntu 24

### Update a Single Package

```bash
sudo apt install libaio-dev
```

APT will:

* Check if a newer version exists
* Download it
* Update dependencies if needed

---

### Update the Entire System (Recommended Workflow)

```bash
sudo apt update
sudo apt dist-upgrade
```

📌 Explanation:

* `apt update` → refreshes package lists
* `apt dist-upgrade` → upgrades everything, resolving dependency changes

This is the **standard Ubuntu 24 upgrade procedure**.

---

## 5. Automatic Updates (Ubuntu 24)

Ubuntu includes **unattended-upgrades**, which can:

* Automatically install security updates
* Reduce exposure to vulnerabilities
* Be tuned for servers vs desktops

Check status:

```bash
systemctl status unattended-upgrades
```

💡 **SWH practice**:
Enable automatic **security updates**, but perform **feature upgrades manually**.

---

## 6. Bandwidth Optimization (Delta Packages)

Some Linux distributions support **delta packages**, which download only the difference between versions.

Ubuntu typically downloads **full packages** instead.

✔ Faster on modern networks
✔ More predictable
✔ Simpler failure recovery

This aligns well with reproducible infrastructure practices.

---

## 7. Reboots: When Are They Required?

One of Linux’s most important features:

> **A reboot is only required when the kernel is updated.**

Check if a reboot is needed:

```bash
cat /var/run/reboot-required
```

Why this matters:

* Services continue running
* CI workers stay online
* Cassandra/PostgreSQL nodes can be upgraded one at a time

---

## 8. Command Reference (Ubuntu-Focused)

| Operation               | Ubuntu 24 Command      |
| ----------------------- | ---------------------- |
| Install package         | `apt install foo`      |
| Remove package          | `apt remove foo`       |
| Remove + config         | `apt purge foo`        |
| Update one package      | `apt install foo`      |
| Update system           | `apt dist-upgrade`     |
| List installed packages | `dpkg --list`          |
| Show package files      | `dpkg --listfiles foo` |
| Search packages         | `apt-cache search foo` |
| File → package          | `dpkg --search file`   |

---

## 9. Real-World Scenarios (Software Heritage Context)

### Scenario 1: Updating a CI Worker

```bash
sudo apt update
sudo apt dist-upgrade
sudo systemctl restart docker
```

✔ No reboot unless kernel updated
✔ Containers isolate runtime changes

---

### Scenario 2: PostgreSQL Security Update

```bash
sudo apt install postgresql
sudo systemctl restart postgresql
```

✔ Data untouched
✔ Minimal downtime

---

### Scenario 3: Cassandra Node Upgrade (Rolling)

1. Upgrade one node
2. Restart Cassandra
3. Wait for cluster to rebalance
4. Proceed to next node

✔ Zero global downtime
✔ Matches SWH distributed storage practices

---

### Scenario 4: Developer Laptop

```bash
sudo apt update
sudo apt dist-upgrade
rustup update
pip install --upgrade -r requirements.txt
```

✔ System + language stacks updated independently

---

## 10. Best Practices (SWH-Aligned)

✔ Use `apt` for system software
✔ Keep kernel upgrades scheduled
✔ Prefer containers for CI and services
✔ Enable automatic security updates
✔ Document upgrade procedures
✔ Avoid manual `.deb` installs

---

## 11. Hugo Documentation Version

### Save as:

```text
docs/content/operations/upgrading-and-patching.md
```

### Front matter (Hugo):

```markdown
---
title: "Upgrading and Patching on Ubuntu 24"
weight: 20
---

```

The rest of this document is **already valid Markdown** and Hugo-ready.

---

## 12. Summary

Ubuntu’s package-based upgrade model offers:

* High reliability
* Minimal downtime
* Strong security guarantees
* Excellent support for large infrastructures

This makes it ideal for **Software Heritage–style systems**, where long-running services, reproducibility, and operational safety are critical.

---

