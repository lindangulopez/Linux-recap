# Ubuntu 24 Software Heritage Development Setup 

## 10. Minimal Checklist

* ✅ apt-based system packages
* ✅ Rust via rustup
* ✅ PostgreSQL running
* ✅ Cassandra running
* ✅ Git + Hugo installed

### 1. Package Management Rule (Foundation)

* Use **APT (`apt`)** for all system software.
* Avoid `dpkg` unless explicitly required.
* Always start with:

```bash
sudo apt update
sudo apt upgrade
```

---

## 2. Core Development Tools

Install essential build and VCS tooling (used by GitHub, GitLab, Hugo, and metadata tools):

```bash
sudo apt install -y \
  build-essential \
  git \
  curl \
  wget \
  pkg-config \
  ca-certificates \
  software-properties-common
```

---

## 3. Rust (for modern tooling and services)

**Recommended approach: rustup** (not apt), as it provides up-to-date Rust and easy toolchain management.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

Verify:

```bash
rustc --version
cargo --version
```

Why rustup?

* Matches upstream Rust expectations
* Required by many modern SWH-related tools
* Avoids outdated distro packages

---

## 4. PostgreSQL (relational database)

Ubuntu 24 ships with a supported PostgreSQL version suitable for development.

```bash
sudo apt install -y postgresql postgresql-contrib
```

Basic setup:

```bash
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

Create a dev user/db:

```bash
sudo -u postgres createuser --interactive
sudo -u postgres createdb swh_dev
```

Used by:

* Software Heritage storage & indexing services
* Metadata and API backends

---

## 5. Cassandra (distributed storage)

Ubuntu repositories include Cassandra, but **Apache Cassandra packages are preferred** for compatibility.

### Install Java (required)

```bash
sudo apt install -y openjdk-11-jdk
```

### Install Cassandra

```bash
sudo apt install -y cassandra
```

Enable and start:

```bash
sudo systemctl enable cassandra
sudo systemctl start cassandra
```

Check status:

```bash
nodetool status
```

Used by:

* Large-scale object storage
* Event and graph-like data in SWH infrastructure

---

## 6. Hugo (documentation & sites)

Install extended version (needed for SCSS):

```bash
sudo apt install -y hugo
```

Or use upstream binary if you need the **extended** build explicitly.

Used for:

* Documentation sites
* Metadata portals
* Project websites

---

## 7. GitHub / GitLab Integration

```bash
sudo apt install -y git git-lfs
```

Optional helpers:

```bash
sudo apt install -y gh   # GitHub CLI
```

(GitLab CLI is optional and often not required locally.)

---

## 8. Python & Metadata Tooling (CodeMeta, COAR Notify)

```bash
sudo apt install -y \
  python3 \
  python3-venv \
  python3-pip
```

Best practice:

```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
```

Used for:

* CodeMeta generation/validation
* COAR Notify clients/services
* Software Heritage APIs

---

## 9. Key Best Practices

* Prefer **APT for system services**, **language-native installers** for languages (Rust).
* Keep databases running as system services.
* Use **virtual environments** (Python) and **rustup toolchains** for reproducibility.
* Document versions in a `README` or setup script.

---


* ✅ Python venv for metadata tools

