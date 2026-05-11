# GNU Guix Installation Guide for Ubuntu 24.04

This guide explains how to install and test **GNU Guix** on **Ubuntu 24.04 LTS** using the official binary installer.

It includes:

- Required dependencies
- Installation steps
- Common fixes
- Verification tests
- First package installation
- Updating Guix
- Uninstall instructions

---

# What is GNU Guix?

GNU Guix is a:

- Functional package manager
- Reproducible development environment system
- GNU/Linux distribution

Guix allows:

- Declarative environments
- Rollbacks
- Isolated package management
- Reproducible scientific workflows

Official website:

https://guix.gnu.org/

---

# Requirements

Ubuntu 24.04 requires several dependencies before installing Guix.

Install them with:

```bash
sudo apt update

sudo apt install -y \
  bash \
  gnupg \
  tar \
  wget \
  xz-utils \
  uidmap
```

---

# Why `uidmap` Is Required

The Guix installer needs:

```text
newgidmap
newuidmap
```

These commands come from the Ubuntu package:

```text
uidmap
```

Without it, installation fails with:

```text
[ FAIL ] Missing commands: newgidmap.
```

---

# Verify Dependencies

Run:

```bash
which bash
which gpg
which tar
which wget
which xz
which newgidmap
which newuidmap
```

Expected output:

```text
/usr/bin/bash
/usr/bin/gpg
/usr/bin/tar
/usr/bin/wget
/usr/bin/xz
/usr/bin/newgidmap
/usr/bin/newuidmap
```

---

# Download the Installer

Move into the temporary directory:

```bash
cd /tmp
```

Verify location:

```bash
pwd
```

Expected:

```text
/tmp
```

Download the installer:

```bash
wget https://guix.gnu.org/guix-install.sh
```

Make it executable:

```bash
chmod +x guix-install.sh
```

Verify:

```bash
ls -lh guix-install.sh
```

---

# Run the Installer

Run as root:

```bash
sudo ./guix-install.sh
```

The installer will:

1. Download the Guix binary tarball
2. Install Guix
3. Configure the Guix daemon
4. Create required users/groups
5. Configure substitute servers
6. Enable Guix for non-root users

---

# During Installation

You may see:

```text
Press return to continue...
```

Press:

```text
Enter
```

The installer can take several minutes.

---

# Verify Installation

After installation completes:

```bash
guix --version
```

Expected:

```text
guix (GNU Guix) 1.x.x
```

---

# Configure Your Shell

Add Guix to your environment:

```bash
source ~/.config/guix/current/etc/profile
```

To make it permanent:

```bash
echo 'source ~/.config/guix/current/etc/profile' >> ~/.bashrc
```

Reload shell:

```bash
source ~/.bashrc
```

---

# Test Guix

## Search for a package

```bash
guix search hello
```

---

## Install a package

```bash
guix install hello
```

---

## Run the package

```bash
hello
```

Expected:

```text
Hello, world!
```

---

# Test Installed Packages

List installed packages:

```bash
guix package --list-installed
```

---

# Test the Daemon

Ubuntu 24.04 uses systemd.

Check daemon status:

```bash
systemctl status guix-daemon
```

Expected:

```text
active (running)
```

---

# Test Pulling Updates

Update Guix:

```bash
guix pull
```

Refresh shell hash:

```bash
hash guix
```

---

# Authorize Substitute Servers

Guix downloads pre-built binaries called substitutes.

Authorize official servers:

```bash
sudo guix archive --authorize < \
  ~root/.config/guix/current/share/guix/bordeaux.guix.gnu.org.pub

sudo guix archive --authorize < \
  ~root/.config/guix/current/share/guix/ci.guix.gnu.org.pub
```

Without substitutes, Guix compiles everything from source.

---

# Create a Development Environment

Example temporary environment:

```bash
guix shell python python-pandas python-geopandas
```

This launches an isolated shell with GIS tooling.

---

# Example Scientific Environment

```bash
guix shell \
  python \
  python-numpy \
  python-scipy \
  python-pandas \
  python-matplotlib \
  python-jupyter
```

---

# Example PostgreSQL Environment

```bash
guix shell \
  postgresql \
  python \
  python-psycopg2
```

---

# Common Commands

## Search

```bash
guix search geopandas
```

---

## Install

```bash
guix install python python-geopandas
```

---

## Remove

```bash
guix remove python-geopandas
```

---

## Upgrade Packages

```bash
guix upgrade
```

---

## Roll Back

```bash
guix package --roll-back
```

---

# Common Errors

---

## Error: `newgidmap missing`

Fix:

```bash
sudo apt install uidmap
```

---

## Error: `guix command not found`

Fix:

```bash
source ~/.config/guix/current/etc/profile
```

---

## Error: daemon not running

Start daemon:

```bash
sudo systemctl start guix-daemon
```

Enable at boot:

```bash
sudo systemctl enable guix-daemon
```

---

# Uninstall Guix

Go back to installer directory:

```bash
cd /tmp
```

Run:

```bash
sudo ./guix-install.sh --uninstall
```

Warning:

This permanently removes:

- Guix packages
- Profiles
- Configuration
- Build caches
- Daemon services

---

# Recommended Next Steps

For scientific and GIS workflows:

Install:

```bash
guix install \
  python \
  python-geopandas \
  python-rasterio \
  python-shapely \
  python-jupyter
```

For biodiversity workflows:

```bash
guix search qgis
guix search postgresql
guix search gdal
```

---

# Useful Resources

## Official Documentation

https://guix.gnu.org/manual/

---

## Getting Started

https://guix.gnu.org/manual/en/html_node/Getting-Started.html

---

## Package Search

https://packages.guix.gnu.org/

---

## Guix Source Code

https://git.savannah.gnu.org/cgit/guix.git

---

# Recommended Ubuntu 24.04 Packages

Useful host-system tools:

```bash
sudo apt install -y \
  git \
  curl \
  build-essential \
  htop \
  tmux \
  tree \
  jq
```

---

# Final Verification Checklist

```bash
guix --version
guix search hello
guix install hello
hello
systemctl status guix-daemon
guix pull
```

If all commands succeed, Guix is fully operational.

---
