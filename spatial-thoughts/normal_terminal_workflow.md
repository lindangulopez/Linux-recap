# Clean prompt

Set up a **normal terminal workflow on Ubuntu 20.04** where your prompt looks clean (no `(base)`), but you can still activate your Conda environment and run JupyterLab quickly.

---

## **1️⃣ Stop auto-activation of `(base)`**

Run this **once** in your terminal:

```bash
conda config --set auto_activate_base false
```

* Close your terminal and reopen it.
* Your prompt should now look normal:

```bash
linda@linda-HP-EliteBook-8-G1a-14-inch-Notebook-Next-Gen-AI-PC:~$
```

---

## **2️⃣ Activate your Python environment when needed**

Whenever you want to work on your Python project:

```bash
conda activate python_foundation
```

* Prompt changes to:

```bash
(python_foundation) linda@linda-HP-EliteBook-8-G1a-14-inch-Notebook-Next-Gen-AI-PC:~$
```

---

## **3️⃣ Launch JupyterLab**

From the same terminal, go to the folder containing your notebooks or data. Example:

```bash
cd ~/Bureau  # your Desktop folder
```

Then start JupyterLab:

```bash
jupyter-lab
```

* A browser window will open automatically showing JupyterLab.
* **Keep the terminal open** while using JupyterLab, or the server will stop.

---

## **4️⃣ Optional: Create a shortcut command**

You can make it even quicker by creating a terminal shortcut. Add this to your `~/.bashrc`:

```bash
# Quick launch JupyterLab in python_foundation environment
alias jlab='conda activate python_foundation && jupyter-lab'
```

* Save the file, then reload your shell:

```bash
source ~/.bashrc
```

* Now you can just type:

```bash
jlab
```

…and it will **activate your environment and start JupyterLab** in one step.

---

✅ **Summary**

* Terminal no longer shows `(base)` by default.
* You manually activate your environment when needed.
* JupyterLab can be started from anywhere with `cd <folder>` or the `jlab` alias.


