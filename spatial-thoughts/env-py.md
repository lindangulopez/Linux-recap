# **clean, step-by-step reinstall of Anaconda3** s

> everything works correctly. I’ll include fixes for **corrupted download** and **spaces in paths**.

---

## **Step 1: Remove any old/corrupted installers and previous Anaconda installs**

```bash
# Remove corrupted installer if it exists
rm -f ~/Anaconda3-2025.12-2-Linux-x86_64.sh*

# Remove previous failed Anaconda installation (optional)
rm -rf ~/anaconda3
rm -rf ~/anaconda3-install
```

This ensures a **fresh start**.

---

## **Step 2: Download Anaconda3 safely**

Use `wget -c` to resume if interrupted:

```bash
wget -c https://repo.anaconda.com/archive/Anaconda3-2025.12-2-Linux-x86_64.sh
```

---

## **Step 3: Verify the MD5 checksum**

```bash
md5sum Anaconda3-2025.12-2-Linux-x86_64.sh
```

Expected value:

```
c9b4da1b9bdf3a7717bc2ec07d89614e
```

✅ Only proceed if it matches.

---

## **Step 4: Run the installer in a path without spaces**

Linux paths with spaces **break the installer**, so choose a simple path:

```bash
bash Anaconda3-2025.12-2-Linux-x86_64.sh
```

* Press **ENTER** to continue past the license.
* Type `yes` to accept the license.
* When asked for installation location, **use a path without spaces**, e.g.:

```
/home/linda/anaconda3-install
```

Press **ENTER**.

---

## **Step 5: Initialize Anaconda**

At the end of installation, if prompted:

```bash
Do you wish the installer to initialize Anaconda3 by running conda init? [yes|no]
```

Type: `yes`

Then reload your shell:

```bash
source ~/.bashrc
```

---

## **Step 6: Verify Conda works**

```bash
conda --version
```

Expected output:

```
conda 25.12
```

---

## **Step 7: Optional - Update Conda packages**

```bash
conda update conda
conda update --all
```

---

💡 **Tips:**

* Always use **paths without spaces** for Python/Conda installations.
* If download fails repeatedly, try using `curl -O` or a more stable network.
* “Reload your shell” just means **make your current terminal session read the updated configuration** so `conda` works immediately, without opening a new terminal.

The command:

```bash
source ~/.bashrc
```

does exactly that:

* `source` tells the terminal: “run all the commands in this file right now.”
* `~/.bashrc` is the configuration file for your bash shell.

After this, if you type:

```bash
conda --version
```

you should see something like:

```
conda 25.12
```

If you **skip this step**, your terminal might say `conda: command not found` even though it’s installed.

💡 Alternative: You can also **close the terminal and open a new one**, which automatically loads the updated `.bashrc`.



