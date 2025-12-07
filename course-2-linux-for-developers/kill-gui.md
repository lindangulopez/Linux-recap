# 🧑‍💻 Why kill GUI

As someone learning Linux (especially “for developers”):

* It helps you understand underlying Linux architecture: GUI is a layer — not mandatory — and Linux works fine without it. Good for servers, minimal setups, remote work, virtualization.
* Familiarizes you with systemd or init-based system controls — skillful use of system services and targets is essential for sysadmin tasks.
* Prepares you for real-world situations: headless servers, docker containers, remote SSH access, resource-constrained environments, automation — where GUIs are often disabled.
* Makes you comfortable with CLI-based workflows, which tend to be more predictable and scriptable than GUI-based ones.



## 🎯 What does “Killing the Graphical User Interface (GUI)” mean — and why do it

* In Linux, a **GUI** (graphical user interface) — e.g. a desktop environment with windows, icons, a login screen — is typically provided by a combination of a *display server* (like Xorg / X11 or a Wayland server) and a *display/login manager* (e.g. GDM, LightDM, or other) that launches the desktop environment at boot/login.
* “Killing the GUI” means stopping those services so that your system drops to a **text-mode console (terminal)** instead of showing a graphical desktop. This can be useful for:

  * Saving resources (memory, CPU) if you don’t need the GUI (useful on servers or lightweight setups).
  * Doing system maintenance (e.g. configuring low-level settings, installing drivers like GPU drivers) where GUI or X may interfere. (Indeed, some user reports mention needing to stop Xorg for such tasks.) 
  * Learning how Linux works under the hood — the GUI is just a layer on top of core Linux, and by “killing” it you see the OS in a more minimal, controlled state (terminal, services only). That seems to match the pedagogical idea of the lab in the “Linux for Developers” course.

---

## ✅ How it’s typically done on **Ubuntu 24.04**

Ubuntu 24.04 uses **systemd** and the **GDM** display manager (by default with GNOME).
So stopping/starting the GUI means controlling the **gdm.service**.

### **🔹 Stop the GUI (drop to text-mode console)**

```bash
sudo systemctl stop gdm
```

This immediately ends the graphical session and returns you to a TTY (e.g., `Ctrl+Alt+F3`).

> Tip: If you’re currently in the GUI, switch to a console before stopping it:
> **Ctrl + Alt + F3** → login → run the command.

---

### **🔹 Start the GUI again**

```bash
sudo systemctl start gdm
```

This restarts the display manager and brings back the login screen / desktop.

---

### **🔹 Disable GUI on boot (boot into CLI by default)**

```bash
sudo systemctl set-default multi-user.target
```

After reboot, Ubuntu will start in text mode only.

---

### **🔹 Re-enable GUI on boot (restore normal behavior)**

```bash
sudo systemctl set-default graphical.target
```

After reboot, the desktop environment loads normally again.

---

### **🔹 Alternative: Use systemd "isolate" to switch modes immediately**

Switch immediately to text mode:

```bash
sudo systemctl isolate multi-user.target
```

Switch immediately back to graphical mode:

```bash
sudo systemctl isolate graphical.target
```


