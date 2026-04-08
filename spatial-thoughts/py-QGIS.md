# 🌍 Install QGIS on Ubuntu 20.04 (Focal)

## 🧰 1. Install Required Tools

```bash id="v3n8q2"
sudo apt update
sudo apt install gnupg software-properties-common
```

---

## 🔑 2. Add QGIS Signing Key

```bash id="j4r7ks"
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
```

---

## 🗂️ 3. Add QGIS Repository (IMPORTANT)

Ubuntu 20.04 codename = **focal**

Check it (optional):

```bash id="0s9m3c"
lsb_release -cs
```

Now create the repo file:

```bash id="3e9l1a"
sudo nano /etc/apt/sources.list.d/qgis.sources
```

Paste this:

```text id="nq1y3x"
Types: deb deb-src
URIs: https://qgis.org/debian
Suites: focal
Architectures: amd64
Components: main
Signed-By: /etc/apt/keyrings/qgis-archive-keyring.gpg
```

Save:

* Ctrl + O → Enter
* Ctrl + X

---

## 🔄 4. Update Package List

```bash id="k8p2zx"
sudo apt update
```

---

## 📦 5. Install QGIS

```bash id="g5v0md"
sudo apt install qgis qgis-plugin-grass
```

Optional (server component):

```bash id="l2b7xy"
sudo apt install qgis-server
```

---

## ▶️ 6. Launch QGIS

```bash id="o9r4yt"
qgis
```

---

# ⚠️ Important Notes (Ubuntu 20.04)

* Ubuntu 20.04 is **older (LTS)** → newer QGIS versions may not always be fully supported
* If something breaks:

  * Use **LTR (Long Term Release)** repository instead
  * Or upgrade OS (recommended long-term)

---

# 🔁 Alternative: Install QGIS LTR (More Stable)

Use this repo instead of the main one:

```text id="zz4gq8"
URIs: https://qgis.org/debian-ltr
Suites: focal
```

👉 LTR example: **3.44.x (Solothurn)** → more stable for production

---

# 🔗 Connecting QGIS with Your Anaconda Setup

As mentioned before:

👉 **QGIS has its own Python**
👉 Your **Anaconda** environment is separate

---

## ✅ Recommended Workflow (Best Practice)

Use:

* Anaconda → analysis (`geopandas`, `rioxarray`)
* QGIS → visualization

Exchange files:

* `.geojson`
* `.shp`
* `.tif`

---

## ⚙️ Optional (Advanced Integration)

Run QGIS inside your conda environment:

```bash id="s6k1zp"
conda activate python_foundation
qgis
```

If needed, expose packages:

```bash id="u8w2mf"
export PYTHONPATH=~/anaconda3/envs/python_foundation/lib/python3.12/site-packages:$PYTHONPATH
```

⚠️ This may cause:

* GDAL conflicts
* Crashes

---

# 🧪 Test Python in QGIS

Inside QGIS:

* Open **Python Console**
* Run:

```python id="a1v9cx"
import geopandas
```

---

# 🎯 Final Setup

You now have:

* QGIS installed via official repo
* GRASS plugin included
* Anaconda Python 3.12 environment
* A clean, professional GIS workflow


