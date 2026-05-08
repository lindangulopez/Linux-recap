# Installation and Setting Up the `cao_valley` Environment

Python can be installed in many ways, and some operating systems already come with it pre-installed. Tools like QGIS also include their own Python versions. However, working on Python projects often requires additional third-party packages, which can have conflicting dependencies and cause errors if installed in the same environment.

A reliable way to manage Python and packages is **Anaconda**. For this course, we will use **Anaconda3 Individual Edition** to install Python and the required spatial analysis packages.

---

## Step 1: Install Anaconda

1. Download the **Anaconda installer for Python 3.12 or higher** for your operating system.
2. Run the installer and follow the default prompts:

   * Choose “Just Me”
   * Install in the default directory (avoid usernames with spaces or non-English characters; if needed, use `C:\anaconda`)

---

## Step 2: Open the Command Interface

* **Windows:** Search for **Anaconda Prompt** and open it
* **Mac/Linux:** Open a **Terminal** window

---

## Step 3: Create a New Environment

It’s best practice to create a **separate environment for each project** to avoid package conflicts. We will create an environment called `cao_valley`.

```bash
conda create --name cao_valley
```

When prompted, type `y` and press Enter to proceed.

---

## Step 4: Activate the Environment

```bash
conda activate cao_valley
```

Once activated, your prompt should show `(cao_valley)` instead of `(base)`.

---

## Step 5: Install Required Packages

We will install all necessary packages for spatial analysis using the `conda-forge` channel:

```bash
conda install --channel conda-forge geopandas geopy rioxarray matplotlib jupyterlab -y
```

Wait for the installation to finish.

---

## Step 6: Launch JupyterLab

JupyterLab is the interface we will use to run Python code. Start it from your active environment:

```bash
jupyter-lab
```

**Notes:**

* Keep the terminal or Anaconda Prompt open while using JupyterLab.
* JupyterLab can only access files on the drive where it was launched. If your data is on a different drive:

**Windows:**

```bash
D:
jupyter-lab
```

**Mac/Linux:**

```bash
ls /Volumes        # List drives
cd /Volumes/<YourDriveName>
jupyter-lab
```

Once opened, click **Python 3** under Notebook to start coding.

---

## Step 7: Test Your Installation

Enter the following in the first JupyterLab cell and run it:

```python
import geopandas
import geopy
import rioxarray
```

If there are no errors, your environment is ready. If you see an `ImportError`, repeat the installation steps carefully.

---

## Step 8: Troubleshooting Common Errors

### Package Conflicts

Older packages in the base environment may cause issues. To fix:

```bash
conda deactivate
conda env remove -n cao_valley
conda update --all
```

Then, repeat the environment creation steps.

### OpenSSL Errors (Windows)

If you see `CondaSSLError: OpenSSL appears to be unavailable`, install the Win32/Win64 OpenSSL packages and try again. If needed, manually copy the required DLLs.

### RTree / spatialindex Errors

If importing GeoPandas shows `Could not find or load spatialindex_c-64.dll`, it usually means a corrupted installation. Fix it by:

```bash
conda deactivate
conda env remove -n cao_valley
```

Then reinstall the environment and packages.

---

Your `cao_valley` environment is now ready for all spatial Python tasks in this course.

---
