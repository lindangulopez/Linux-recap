# 🐍 Installation and Setting up the Environment (Ubuntu 20.04)

Many operating systems (including **Ubuntu 20.04**) come with Python preinstalled. However, working on projects often requires installing additional packages, which can lead to dependency conflicts.

A reliable solution is to use **Anaconda**, which manages Python versions and packages in isolated environments.

---

## 📥 1. Install Anaconda (Python ≥ 3.12 capable)

Open a **Terminal** and run:

```bash
cd ~/Downloads
wget https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh
```

Run the installer:

```bash
bash Anaconda3-latest-Linux-x86_64.sh
```

Follow the prompts:

* Press **Enter** to scroll
* Type **yes** to accept the license
* Press **Enter** to install in default directory:

  ```
  ~/anaconda3
  ```
* Type **yes** to initialize Anaconda

Then reload your shell:

```bash
source ~/.bashrc
```

---

## 🧠 Notes

* Linux installs are **per-user by default** (equivalent to “Just Me” on Windows)
* Avoid usernames with spaces or special characters if possible

---

## 🛠️ 2. Create a New Environment

It’s best practice to create a separate environment for each project.

Run:

```bash
conda create --name python_foundation
```

Press **y + Enter** to confirm.

---

## ▶️ 3. Activate the Environment

```bash
conda activate python_foundation
```

You should now see:

```bash
(python_foundation)
```

instead of `(base)` in your terminal.

---

## 📦 4. Install Required Packages

Install the required libraries using the **conda-forge** channel:

```bash
conda install --channel conda-forge geopandas geopy rioxarray matplotlib jupyterlab -y
```

This installs:

* geopandas
* geopy
* rioxarray
* matplotlib
* jupyterlab

---

## 🚀 5. Launch JupyterLab

Start JupyterLab:

```bash
jupyter-lab
```

👉 This will:

* Start a local server
* Open **JupyterLab** in your browser

⚠️ Keep the terminal open while using JupyterLab.

---

## 📁 6. Working with Files (Linux)

JupyterLab starts in the current folder. To access your data:

### Check mounted drives:

```bash
ls /media
```

### Navigate to your drive:

```bash
cd /media/<your-username>/<drive-name>
jupyter-lab
```

---

## ✅ 7. Test Your Setup

In JupyterLab:

1. Click **Python 3** notebook
2. Run:

```python
import geopandas
import geopy
import rioxarray
```

👉 If no errors appear, your setup is successful.

---

## 🎯 Done

You now have:

* Anaconda installed
* A dedicated environment (`python_foundation`)
* All required spatial packages
* JupyterLab ready to use


