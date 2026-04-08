# 🐍 1. Install Python 3.12 in Your Environment

Activate your environment (if not already):

```bash id="w9p8q1"
conda activate python_foundation
```

### Install Python 3.12

```bash id="o2k7sj"
conda install python=3.12
```

Confirm with **y**.

---

## ✅ Verify Python Version

```bash id="k2mz9n"
python --version
```

You should see something like:

```
Python 3.12.x
```

---

# 🔌 2. Install VS Code (if not already installed)

```bash id="3qz0k9"
sudo snap install code --classic
```

Launch it:

```bash id="6lq1tf"
code
```

---

# 🧩 3. Install Python Extension in VS Code

Inside **Visual Studio Code**:

1. Go to **Extensions (left sidebar)**
2. Search for **Python**
3. Install the one by **Microsoft**

---

# 🔗 4. Connect VS Code to Your Conda Environment

### Open your project folder:

```bash id="h9x3bt"
code .
```

Then in VS Code:

1. Press **Ctrl + Shift + P**
2. Type: `Python: Select Interpreter`
3. Choose:

   ```
   python_foundation (Anaconda)
   ```

If you don’t see it:

* Select **"Enter interpreter path"**
* Browse to:

  ```
  ~/anaconda3/envs/python_foundation/bin/python
  ```

---

# 🧪 5. Test in VS Code

Create a file: `test.py`

```python id="x7nd2k"
import geopandas
import geopy
import rioxarray

print("All packages working!")
```

Run it:

```bash id="6q4cpm"
python test.py
```

---

# 📓 6. Use Jupyter in VS Code (Optional but Recommended)

Since you installed **JupyterLab**, VS Code can also run notebooks:

1. Install **Jupyter extension** in VS Code
2. Create a `.ipynb` file
3. Select kernel → `python_foundation`

---

# 🎯 You’re Fully Set Up

You now have:

* Python **3.12** inside your environment
* Isolated project setup
* VS Code connected to Conda
* Jupyter notebooks working
* How to fix common Conda issues (very useful on Ubuntu 20.04)
* Or how to install QGIS + connect it with this Python setup
