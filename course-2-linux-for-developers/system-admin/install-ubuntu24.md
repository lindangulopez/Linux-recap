# **Ubuntu 24.04 Desktop Installation Cheat Sheet**

This cheat sheet covers everything from **booting USB → installing Ubuntu → opening Bash → first system commands**.

---

## **Step 0: Preparation**

| Action              | Tip                                                             |
| ------------------- | --------------------------------------------------------------- |
| Update BIOS/UEFI    | Check manufacturer website for latest firmware.                 |
| Storage             | Prefer SSD for speed.                                           |
| Download ISO        | [Ubuntu 24.04 Desktop ISO](https://ubuntu.com/download/desktop) |
| Create Bootable USB | Use Rufus (Windows) or Etcher (Windows/Linux/macOS)             |

---

## **Step 1: Boot from USB**

1. Insert USB → Restart PC
2. Enter BIOS/UEFI (**F2**, **F12**, **Del**, or **Esc**)
3. Set **boot order**: USB first
4. Save & Exit → Boot to Ubuntu Live

Normally, your computer starts (boots) from the **internal hard drive or SSD**, where your operating system is installed.

When you **boot from USB**, you are telling your computer:

> “Ignore the internal disk for now. Start the system from this USB stick instead.”

This is essential for installing a new operating system like Ubuntu.

---

### **1. Prepare a Bootable USB**

* Download the **Ubuntu 24.04 Desktop ISO** from the official website.
* Use a tool to make it bootable:

  * **Windows:** Rufus, Balena Etcher
  * **Linux/macOS:** `dd` command or Etcher
* Make sure the USB has **at least 4 GB** and is formatted correctly.

---

### **2. Insert USB into Your PC**

* Plug the USB stick into a USB port.
* Keep it inserted before you turn on the computer.

---

### **3. Enter BIOS/UEFI**

* Restart the computer.
* Immediately press the key for BIOS/UEFI setup (common keys: **F2, F12, Del, Esc**).
* If you’re unsure, check your motherboard/laptop manual.

---

### **4. Set USB as First Boot Device**

* In BIOS/UEFI: find **Boot Order** or **Boot Priority**.
* Move the USB device to the **top of the list**.
* Save changes and exit (usually **F10**).

> 💡 Tip: Some computers have a **boot menu key** (like F12). Pressing it allows you to select the USB directly without changing the BIOS permanently.

---

### **5. Boot Into Ubuntu Live Mode**

* After restarting, the PC should boot from the USB.
* You’ll see a menu:

  * **Try Ubuntu** (run without installing)
  * **Install Ubuntu** (start installation)
* Choosing **Try Ubuntu** first lets you test hardware before installing.

---

### **Why This Step is Important**

* Allows you to install Ubuntu without touching your current system.
* Lets you check hardware compatibility (Wi-Fi, graphics, sound).
* Prepares your PC for partitioning and installation.

---

## **Step 2: Test Hardware in Live Mode**

* Test Wi-Fi, graphics, sound, keyboard, and mouse.
* Live mode does not modify your PC.

---

## **Step 3: Install Ubuntu**

| Step              | Action                                             |
| ----------------- | -------------------------------------------------- |
| Install           | Click **Install Ubuntu**                           |
| Language          | Select your language → Next                        |
| Keyboard          | Select layout → Next                               |
| Updates           | Normal installation + download updates             |
| Installation type | For only Ubuntu: **Erase disk and install Ubuntu** |
| Partition         | Automatic or manual if advanced                    |
| Time zone         | Select your region                                 |
| User account      | Enter name, username, password                     |
| Install           | Click **Install Now** → Wait                       |
| Restart           | Remove USB when prompted                           |

---

## **Step 4: First Login**

* Log in with your username/password
* Desktop environment: **GNOME** (default)

---

## **Step 5: Open Bash Terminal**

| Method               | Shortcut                                                 |
| -------------------- | -------------------------------------------------------- |
| Terminal             | **Ctrl + Alt + T**                                       |
| Full-screen terminal | **Ctrl + Alt + F3** → return GUI: **Ctrl + Alt + F2/F1** |
| Confirm Bash         | `echo $SHELL` → should show `/bin/bash`                  |

---

## **Step 6: First Commands in Bash**

| Task            | Command                                                       |
| --------------- | ------------------------------------------------------------- |
| Update packages | `sudo apt update`<br>`sudo apt upgrade -y`                    |
| Install tools   | `sudo apt install build-essential git curl wget -y`           |
| Hardware info   | `lshw`<br>`inxi -Fxz`                                         |
| Disk space      | `df -h`                                                       |
| Memory info     | `free -h`                                                     |
| Install apps    | `sudo apt install vlc firefox gimp -y`                        |
| Enable firewall | `sudo ufw enable`<br>`sudo ufw status`                        |
| GPU drivers     | `ubuntu-drivers devices`<br>`sudo ubuntu-drivers autoinstall` |

---

## **Step 7: Tips & Post-Installation**

* Enable **automatic updates** from Settings → Updates
* Use **Snap Store** for apps
* Regularly run:

```bash
sudo apt update && sudo apt upgrade -y
```

* Backup important data regularly

---

