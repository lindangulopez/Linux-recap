# 🌍 Install QGIS on Ubuntu 

This guide works for Ubuntu 20.04, 22.04, 24.04 and similar systems.

---

# 🧰 1. Install Required Tools

```bash
sudo apt update
sudo apt install gnupg software-properties-common
```

---

# 🔑 2. Add QGIS Signing Key

```bash
sudo mkdir -m755 -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
```

👉 This ensures packages from QGIS are trusted.

---

# 🧠 3. Find Your System Codename (IMPORTANT)

Run:

```bash
lsb_release -cs
```

👉 You’ll get something like:

| Ubuntu Version | Codename |
| -------------- | -------- |
| 20.04          | focal    |
| 22.04          | jammy    |
| 24.04          | noble    |

👉 **You must use this codename in the next step**

---

# 🗂️ 4. Add QGIS Repository

Open the file:

```bash
sudo nano /etc/apt/sources.list.d/qgis.sources
```

---

## ✍️ Paste this (REPLACE codename)

Example for Ubuntu 24.04 (`noble`):

```text
Types: deb deb-src
URIs: https://qgis.org/debian
Suites: noble
Architectures: amd64
Components: main
Signed-By: /etc/apt/keyrings/qgis-archive-keyring.gpg
```

👉 Replace `noble` with:

* `focal` (20.04)
* `jammy` (22.04)
* or whatever your system returned

---

## 💾 Save and exit

Inside nano:

* Press **Ctrl + O** → Enter (save)
* Press **Ctrl + X** (exit)

---

# 🔄 5. Update Package List

```bash
sudo apt update
```

---

# 📦 6. Install QGIS

```bash
sudo apt install qgis qgis-plugin-grass
```

---

## ➕ Optional: install server

```bash
sudo apt install qgis-server
```

---

# ▶️ 7. Launch QGIS

```bash
qgis
```

---

# ⚠️ Important Notes

### Ubuntu 20.04 (focal)

* Older system → newer QGIS (4.x) may not always work perfectly
* If issues occur:

  * Use **LTR version** (more stable)
  * Or upgrade Ubuntu (recommended long-term)

---

# 🔁 Alternative: Install QGIS LTR (More Stable)

Instead of the main repo, use:

```text
URIs: https://qgis.org/debian-ltr
Suites: focal
```

👉 LTR = more stable, fewer bugs (recommended for production)

---

# ⚡ Shortcut (no manual editing)

You can skip editing entirely:

```bash
echo -e "Types: deb deb-src\nURIs: https://qgis.org/debian\nSuites: $(lsb_release -cs)\nArchitectures: amd64\nComponents: main\nSigned-By: /etc/apt/keyrings/qgis-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/qgis.sources
```

---

# 🔗 Using QGIS with Anaconda

👉 Important:

* QGIS uses its **own Python**
* Anaconda uses a **separate environment**

---

## ✅ Recommended workflow

* Use Anaconda → data analysis (`geopandas`, etc.)
* Use QGIS → visualization & GIS tools

Exchange files:

* `.geojson`
* `.shp`
* `.tif`

---

## ⚙️ Optional (advanced)

Run QGIS inside conda:

```bash
conda activate python_foundation
qgis
```

If needed:

```bash
export PYTHONPATH=~/anaconda3/envs/python_foundation/lib/python3.12/site-packages:$PYTHONPATH
```

⚠️ May cause:

* GDAL conflicts
* crashes

---

# 🧪 Test Python in QGIS

Inside QGIS → Python Console:

```python
import geopandas
```

---

# 🎯 Final Result

You now have:

* Latest QGIS installed from official repo
* GRASS plugin enabled
* Clean setup compatible with your system
* Optional Anaconda workflow


