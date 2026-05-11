# GNU Guix on Ubuntu 24.04 — Clean Install + Full Environment Setup

Real working environments for:

* PostgreSQL
* Julia
* R
* Python + Jupyter (`ipynb`)
* GIS stack
* QGIS

All on Ubuntu 24.04 + GNU Guix.


## 1. Install Dependencies (Ubuntu)

```bash
sudo apt update

sudo apt install -y \
  bash \
  gnupg \
  wget \
  curl \
  tar \
  xz-utils \
  uidmap
```

## 2. Download and Install Guix

```bash
cd /tmp

wget https://guix.gnu.org/guix-install.sh
chmod +x guix-install.sh

sudo ./guix-install.sh
```

## 3. Activate Guix (IMPORTANT STEP YOU MISSED)

Run:

```bash
GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
unset GUIX_PROFILE
```

Make it permanent:

```bash
echo 'GUIX_PROFILE="$HOME/.guix-profile"; . "$GUIX_PROFILE/etc/profile"; unset GUIX_PROFILE' >> ~/.bashrc
source ~/.bashrc
```

## 4. Verify Installation

```bash
guix --version
```

Expected:

```text
guix (GNU Guix) 1.x.x
```

## 5. FIRST TEST (VERY IMPORTANT)

Install and test Hello:

```bash
guix install hello
hello
```

Expected output:

```text
Hello, world!
```

If this works → Guix is correctly installed and activated.

## 6. FIXED WORKFLOW (Recommended)

Instead of `guix install`, prefer isolated environments:

```bash
guix shell hello
hello
```
# 7. Core Science + Dev Environments

Now we build proper reproducible environments.

# 🐘 PostgreSQL Environment

```bash
guix shell postgresql
```

Test:

```bash
psql --version
```

Optional Python bridge:

```bash
guix shell postgresql python python-psycopg2
```

---

# 🐍 Python + Jupyter (ipynb)

## Basic Python + Jupyter

```bash
guix shell python python-jupyter python-ipython python-numpy python-pandas
```

Start notebook:

```bash
jupyter notebook
```

or:

```bash
jupyter lab
```

---

# 🌍 GIS Stack (Python GIS)

```bash
guix shell \
  python \
  python-geopandas \
  python-shapely \
  python-fiona \
  python-rasterio \
  python-matplotlib
```

Test:

```bash
python -c "import geopandas as gpd; print(gpd.__version__)"
```

---

# 🗺️ QGIS Environment

```bash
guix shell qgis
```

Launch:

```bash
qgis
```

If GUI fails, ensure:

```bash
echo $DISPLAY
```

---

# 📊 R Environment

```bash
guix shell r r-ggplot2 r-dplyr r-tidyr
```

Start R:

```bash
R
```

Test:

```r
ggplot2::ggplot()
```

---

# 🧬 Julia Environment

```bash
guix shell julia
```

Start:

```bash
julia
```

Test:

```julia
println("Hello Julia")
```

---

# 🧪 Combined Data Science Stack

This is a powerful reproducible environment:

```bash
guix shell \
  python python-jupyter python-numpy python-pandas python-matplotlib \
  r r-ggplot2 \
  julia \
  postgresql
```

---

# 🧠 Recommended Workflow Model

## Option A (temporary environments — BEST)

```bash
guix shell python python-jupyter
```

## Option B (installed profile — older style)

```bash
guix install python
```

⚠️ Avoid heavy use of `guix install` for science stacks.

---

# 🔥 Common Fixes

## “command not found (hello, python, etc.)”

Fix:

```bash
. ~/.guix-profile/etc/profile
```

---

## GUI apps not opening (QGIS)

Check:

```bash
echo $DISPLAY
```

If empty, you are in non-GUI session.

---

## Substitutes slow

This is normal first time; later Guix caches binaries.

---

# 🚀 Recommended Final Setup

Add this to `.bashrc` (if not already):

```bash
GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
unset GUIX_PROFILE
```

---

# 🧭 What You Now Have

With this setup you can:

* Run reproducible Python GIS pipelines
* Use QGIS + Python together
* Run Jupyter notebooks
* Work with R statistical stacks
* Use Julia for scientific computing
* Run PostgreSQL locally for spatial databases

---

If you want next step, I can upgrade this into:

* 🔥 full **GeoData Science stack (PostGIS + QGIS + Python bridge)**
* 🚀 **reproducible research project template (Guix manifest.scm)**
* 🧪 or **multi-language notebook setup (Python + R + Julia in Jupyter)**
