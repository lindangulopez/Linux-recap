# ✅ Fix: Install `xfsprogs`

## Quick summary

* Error = tool not installed
* Package needed = **xfsprogs**
* Install it → command will work

### On **Ubuntu / Debian**

```bash
sudo apt update
sudo apt install xfsprogs
```

### On **CentOS / RHEL / Rocky / Alma**

```bash
sudo yum install xfsprogs
```

or (newer systems):

```bash
sudo dnf install xfsprogs
```

---

## ✅ After installing

Run:

```bash
mkfs.xfs -V
```

If it prints a version, it’s installed correctly.

You can then use:

```bash
sudo mkfs.xfs /dev/sdX
```

⚠️ **Warning:** This erases all data on the device.

---

## 🔎 Why `/sbin/mkfs.xfs` specifically failed

* The binary may not exist yet (not installed), **or**
* `/sbin` is not in your PATH (common for non-root users)

Try:

```bash
which mkfs.xfs
```

or:

```bash
sudo mkfs.xfs /dev/sdX
```

---


