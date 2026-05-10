# 🌿 `install_wallace.sh`

Copy everything below into a file named:

```bash
install_wallace.sh
```

---

## ✅ Full script

```bash id="sh1"
#!/usr/bin/env bash

set -e

echo "======================================"
echo " Wallace installation setup starting"
echo "======================================"

# 1. Update system
echo "[1/5] Updating system packages..."
sudo apt update

# 2. Install system dependencies
echo "[2/5] Installing system dependencies..."
sudo apt install -y \
  build-essential \
  cmake \
  default-jdk \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  libudunits2-dev \
  libfontconfig1-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libsqlite3-dev \
  libuv1-dev

# 3. Verify Java
echo "[3/5] Checking Java installation..."
java -version
javac -version
which java

# 4. Configure Java for R
echo "[4/5] Configuring Java for R (javareconf)..."
sudo R CMD javareconf

# 5. Final message
echo "[5/5] Done installing system dependencies."
echo ""
echo "Next step: open R and run:"
echo ""
echo "install.packages(c('rJava', 'fs', 's2', 'sf'))"
echo "install.packages('wallace', dependencies = TRUE)"
echo ""
echo "Then launch Wallace with:"
echo "library(wallace)"
echo "run_wallace()"

echo ""
echo "Installation script complete ✔"
```

---

# ▶️ How to run it

Make it executable:

```bash id="sh2"
chmod +x install_wallace.sh
```

Run it:

```bash id="sh3"
./install_wallace.sh
```

---

# 📦 After running the script (IMPORTANT)

Open R and run:

```r id="r1"
install.packages(c("rJava", "fs", "s2", "sf"))
install.packages("wallace", dependencies = TRUE)

library(wallace)
run_wallace()
```

---

# ⚠️ Notes (important for reproducibility)

* This script assumes **Ubuntu/Debian Linux**
* Requires sudo privileges
* Installs system libraries needed for:

  * `sf` (GIS stack)
  * `s2`
  * `fs`
  * Java (`rJava`)
* Does NOT install R itself (assumes R 4.5+ already installed)


