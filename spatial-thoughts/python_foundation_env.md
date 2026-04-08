# **Setting up a Python Environment on Ubuntu 20.04**

It’s best to **create a separate Conda environment for each Python project**. An environment is an isolated space for your project’s packages, preventing conflicts with other projects.

We’ll create an environment, install required packages, and launch **JupyterLab**.

---

## **Step 1: Open a Terminal**

Press **Ctrl + Alt + T** to open a terminal window.

---

## **Step 2: Create a new environment**

Run:

```bash
conda create --name python_foundation python=3.11
```

* `python=3.11` ensures you have a modern Python version.
* Press **y + Enter** when prompted to confirm.

---

## **Step 3: Activate the environment**

```bash
conda activate python_foundation
```

* Your terminal prompt should change from `(base)` to `(python_foundation)`.
* This ensures all packages you install go into this environment.

---

## **Step 4: Install required packages**

```bash
conda install --channel conda-forge geopandas geopy rioxarray matplotlib jupyterlab ipykernel -y
```

* `--channel conda-forge` gives access to a wider range of packages.
* `-y` automatically confirms installation.
* `ipykernel` ensures JupyterLab can use this environment as a kernel.

---

## **Step 5: Register the environment as a Jupyter kernel**

```bash
python -m ipykernel install --user --name=python_foundation --display-name "Python (python_foundation)"
```

* This allows you to choose this environment in JupyterLab notebooks.

---

## **Step 6: Navigate to your data folder**

By default, JupyterLab serves files from the folder where you launch it.

* Example: if your data is in `~/Documents/MyData`:

```bash
cd ~/Documents/MyData
```

* External drives are usually mounted under `/media/<username>/<drive_name>`:

```bash
ls /media/linda
cd /media/linda/MyUSBDrive
```

---

## **Step 7: Launch JupyterLab**

From the folder containing your data:

```bash
jupyter-lab
```

* This opens JupyterLab in your default browser.
* **Keep the terminal open** while using JupyterLab; closing it stops the server.

---

## **Step 8: Test your environment**

1. In JupyterLab, create a new notebook.
2. Select the kernel **Python (python_foundation)**.
3. Run:

```python
import geopandas
import geopy
import rioxarray
import matplotlib.pyplot as plt

print("All packages loaded successfully!")
```

* **No errors** → environment is ready.
* **ModuleNotFoundError** → something went wrong with installation; repeat Step 4.

---

## **Step 9: Common Debugging**

### **A. Package Conflicts**

Older packages in `base` may cause conflicts. To fix:

```bash
conda deactivate
conda env remove -n python_foundation
conda update --all
```

Then repeat Steps 2–8.

---

### **B. GeoPandas / RTree Errors**

Errors like:

```
Could not find or load spatialindex_c-64.dll
```

usually indicate a corrupted environment. Fix it by removing and reinstalling:

```bash
conda deactivate
conda env remove -n python_foundation
```

Then repeat Steps 2–8.

---

✅ **Summary**

1. Create a Conda environment.
2. Install all required packages in that environment.
3. Register the environment as a Jupyter kernel.
4. Launch JupyterLab from the folder where your data lives.
5. Always activate your environment before installing or running packages.

---

