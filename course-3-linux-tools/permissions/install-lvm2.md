# ✅ Fix: Install LVM tools


## Quick summary

* Command missing → **install `lvm2`**
* Use `sudo` if needed
* Common in training environments


### On **Ubuntu / Debian**

```bash
sudo apt update
sudo apt install lvm2
```

### On **CentOS / RHEL / Rocky / Alma**

```bash
sudo yum install lvm2
```

or:

```bash
sudo dnf install lvm2
```

---

## ✅ After installing

Verify:

```bash
pvdisplay
```

or:

```bash
which pvdisplay
```

If it still fails, try:

```bash
sudo pvdisplay
```

---

## 🔎 Why this happens

* Minimal Linux installs (very common in **Coursera / Linux Foundation labs**) don’t include LVM tools by default
* `pvdisplay` lives in **`/sbin`**, which may not be in a normal user’s PATH

You can check directly:

```bash
ls /sbin/pvdisplay
```


