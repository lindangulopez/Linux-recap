# **Bash script** to set up a Linux environment for **QGIS development with PyQt and R**

* With **step-by-step explanations** embedded as comments. This script is written for Debian/Ubuntu-based systems.

### **What this script does**

1. **Updates your system** to ensure the latest versions of packages.
2. **Installs build tools** like `gcc`, `make`, and Python headers needed for compiling libraries.
3. **Installs PyQt5 and SIP** for GUI development with Python.
4. **Adds the official QGIS repository** and installs QGIS along with Python bindings and GRASS plugin.
5. **Installs R** and development headers so you can build additional R packages.
6. **Installs commonly used R spatial packages** like `sf` and `rgdal`.
7. **Creates a Python virtual environment** (`~/qgis-dev`) to isolate QGIS/PyQt packages.
8. **Verifies the installation** of PyQt5, QGIS Python bindings, and R.
9. **Optionally installs GNOME Software and Synaptic** for GUI-based package management.

---

```bash
#!/bin/bash

# ======================================================
# QGIS + PyQt + R Development Environment Setup Script
# ======================================================

# Exit immediately if a command exits with a non-zero status
set -e

# -----------------------------
# Step 1: Update system packages
# -----------------------------
# Always start by updating the package list and upgrading existing packages.
echo "Updating system..."
sudo apt update
sudo apt upgrade -y

# -----------------------------
# Step 2: Install core development tools
# -----------------------------
# These tools are needed to compile and build Python packages, QGIS, and other dependencies.
echo "Installing development tools..."
sudo apt install -y build-essential cmake git python3-dev python3-pip python3-venv

# -----------------------------
# Step 3: Install PyQt5 and SIP
# -----------------------------
# PyQt5 is required for GUI applications, SIP is needed for Python bindings.
echo "Installing PyQt5 and SIP..."
sudo apt install -y python3-pyqt5 python3-pyqt5.qtsvg python3-sip pyqt5-dev-tools

# -----------------------------
# Step 4: Add QGIS repository and install QGIS
# -----------------------------
# Installing QGIS from the official repository ensures you get the latest stable version.
echo "Adding QGIS repository..."
sudo apt install -y gnupg software-properties-common
sudo wget -qO - https://qgis.org/downloads/qgis-2025.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/qgis-archive-keyring.gpg
sudo add-apt-repository "deb [signed-by=/usr/share/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntu $(lsb_release -c -s) main"

echo "Installing QGIS and plugins..."
sudo apt update
sudo apt install -y qgis python3-qgis qgis-plugin-grass

# -----------------------------
# Step 5: Install R and R development packages
# -----------------------------
# R is widely used for spatial data analysis; r-base-dev includes development headers for compiling R packages.
echo "Installing R..."
sudo apt install -y r-base r-base-dev

# -----------------------------
# Step 6: Install useful R spatial packages
# -----------------------------
# These are commonly used for geospatial analysis in R.
echo "Installing R spatial packages..."
sudo R --vanilla << EOF
install.packages(c("sp", "rgdal", "rgeos", "sf", "ggplot2"), repos="https://cloud.r-project.org/")
EOF

# -----------------------------
# Step 7: Set up a Python virtual environment
# -----------------------------
# Virtual environments prevent conflicts between system Python and project packages.
echo "Creating Python virtual environment at ~/qgis-dev..."
python3 -m venv ~/qgis-dev
source ~/qgis-dev/bin/activate

# Upgrade pip and install Python packages for QGIS development
echo "Installing Python packages in virtual environment..."
pip install --upgrade pip
pip install PyQt5 pyqt5-tools qgis

# -----------------------------
# Step 8: Verify installation
# -----------------------------
echo "Verifying PyQt5 installation..."
python3 -c "import PyQt5; print('PyQt5 OK')"

echo "Verifying QGIS Python bindings..."
python3 -c "import qgis; print('QGIS Python bindings OK')"

echo "Verifying R installation..."
R --version

# -----------------------------
# Step 9: Optional GUI package managers
# -----------------------------
# Install GNOME Software and Synaptic for graphical package management if desired.
echo "Installing optional GUI package managers..."
sudo apt install -y gnome-software synaptic

# -----------------------------
# Done
# -----------------------------
echo "✅ Environment setup complete!"
echo "To activate your Python environment, run: source ~/qgis-dev/bin/activate"
```

---

### GNOME Software

GNOME Software is a user-friendly graphical application for managing software packages on Linux. Its main functions for a QGIS development setup include:

* **Install Software**: Easily install Python, PyQt, QGIS, and R packages without manually typing commands.
* **Remove Software**: Uninstall tools you no longer need.
* **Update Software**: Keep your system, QGIS, and PyQt libraries up-to-date.
* **Search Functionality**: Quickly find packages such as `python3-pyqt5`, `qgis`, or `r-base`.

### Synaptic Package Manager

Synaptic is a more advanced graphical package manager that allows finer control over software installation. Its key uses in a QGIS + PyQt development environment include:

* **Install Packages with Dependencies**: Ensures libraries like `PyQt5`, `SIP`, or `GDAL` required for QGIS development are installed automatically.
* **Remove Packages**: Safely uninstall development tools or unnecessary dependencies.
* **Manage Dependencies**: Understand and control which packages are required for QGIS plugins or PyQt applications.
* **Search and Filter**: Locate packages such as `qgis-plugin-grass` or `r-cran-ggplot2` with ease.
* **View Package Details**: Check version numbers, descriptions, and origins—important when working on a development environment where compatibility matters.

### Managing Dependencies in Synaptic for QGIS + PyQt + R

1. **Open Synaptic**: Launch Synaptic Package Manager from your applications menu.
2. **Search for a Package**: For example, search `python3-pyqt5`, `qgis`, or `r-base`.
3. **Mark for Installation**: Synaptic will automatically identify any required dependencies (e.g., PyQt5 needs SIP, QGIS may require GDAL, R may need supporting libraries).
4. **Review Dependencies**: Check the list of additional packages to ensure nothing critical is missing.
5. **Mark Dependencies**: Adjust selections if needed. For example, you might include optional R packages for spatial analysis.
6. **Apply Changes**: Synaptic will install the selected packages along with all necessary dependencies.

### Why Managing Dependencies Matters

Ignoring dependencies can cause several issues in your QGIS + PyQt + R environment:

* **Incomplete Functionality**: QGIS plugins or PyQt applications may fail to run if required libraries are missing.
* **Error Messages**: Missing dependencies can result in errors when launching QGIS, Python scripts, or R functions.
* **System Instability**: Conflicting or missing packages can destabilize your development environment.
* **Manual Fixes**: You may need to track down and install missing libraries manually, which is time-consuming.

By carefully using Synaptic or GNOME Software, you ensure that all necessary tools, libraries, and dependencies for QGIS development with PyQt and R are installed and working correctly.




