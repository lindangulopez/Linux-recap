# **1. Enable Shared Clipboard in VirtualBox**

1. **Shut down your Ubuntu VM** (it must be powered off).
2. Open **Oracle VM VirtualBox Manager** on Windows.
3. Select your **Ubuntu VM** → click **Settings** → **General → Advanced**.
4. Find **Shared Clipboard** and set it to **Bidirectional**.

   * This lets you copy from Windows → Ubuntu and vice versa.
5. (Optional) Set **Drag’n’Drop → Bidirectional** to drag files between host and VM.
6. Click **OK** and **start your Ubuntu VM** again.

> Until you do this in VirtualBox Manager, copying and pasting between Windows and the Ubuntu VM terminal won’t work.

---

### **2. Pasting into Ubuntu Terminal (GUI)**

* Open the terminal in Ubuntu.
* Copy text from Windows (**Ctrl + C**).
* In the Ubuntu terminal, press **Ctrl + Shift + V** to paste.
* Or right-click in the terminal → **Paste**.

> **Ctrl + V alone won’t work** in the Ubuntu terminal.

---

### **3. Quick Test**

```bash
echo "Clipboard working!"
```

* Copy this from Windows and paste it into the Ubuntu terminal.
* If you see `Clipboard working!`, it’s working.

---

If you want, I can now create a **ready-to-paste block** for your Ubuntu 24 VM that:

1. Installs **Git** and sets your Git credentials
2. Installs **Python + CodeMetaPy**
3. Installs optional **Node.js/npm**

That way you can paste it all at once safely.

Do you want me to make that for you?
