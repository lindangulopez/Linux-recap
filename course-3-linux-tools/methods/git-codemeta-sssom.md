# Tools and Packages for the CodeMeta SSSOM Project

## 🧠 Notes

* CodeMeta provides **JSON-LD schemas** and crosswalks for metadata standards ([codemeta.github.io](https://codemeta.github.io/))
* Tools like **codemetapy** provide Python CLI utilities to work with CodeMeta metadata ([PyPI](https://pypi.org/project/CodeMetaPy/))

---

## 🧰 1. System Tools (Ubuntu CLI)

Install essential development tools:

```bash
sudo apt update
sudo apt install git build-essential
```

* **git** → to clone repositories
* **build-essential** → compilers and build utilities

### 🔑 Set Up Git Credentials

* verify your configuration:

```bash
git config --list
```

Configure your Git identity so commits are properly attributed:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```



If you plan to use GitHub over HTTPS, you can also cache your credentials:

```bash
git config --global credential.helper cache
```

Or, for SSH-based authentication, generate and add an SSH key:

```bash
ssh-keygen -t ed25519 -C "you@example.com"
cat ~/.ssh/id_ed25519.pub  # copy this to GitHub/GitLab
```

---

## 📦 2. Python Environment

CodeMeta projects are primarily **Python-based**, and SSSOM methodology likely requires Python tooling.

Install Python and environment management tools:

```bash
sudo apt install python3 python3-venv python3-pip
```

Create and activate a virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
```

Install the main CodeMeta CLI tool:

```bash
pip install codemetapy
```

> Optional: You can also install `codemetapy` system-wide (may require `sudo`), but using a virtual environment is recommended.

---

## 📁 3. JSON-LD & Metadata Support

CodeMeta uses **JSON-LD** for metadata. Install supporting Python libraries:

```bash
pip install pyld jsonschema
```

* **pyld** → JSON-LD processing
* **jsonschema** → validate JSON metadata

---

## 🛠 4. Optional: Node.js / Web Tools

If the project includes **client-side interfaces** (e.g., Codemeta Generator):

```bash
sudo apt install nodejs npm
```

Navigate to the directory containing `package.json` and install JavaScript dependencies:

```bash
cd path/to/project
npm install
```

> Only required if `package.json` exists in the repo.

---

## 📌 5. Inspecting the Repository

After cloning the repository:

```bash
git clone https://github.com/lindangulopez/codemeta.git
cd codemeta/sssom-methodology
ls -la
```

Check for files that define dependencies:

* `requirements.txt` → Python packages
* `pyproject.toml`, `setup.py` → Python packaging
* `environment.yml` → Conda environments
* `package.json` → Node.js tooling
* `Dockerfile` → OS-level dependencies

Install any packages listed in these files.

---

## 🧪 6. Quick Search for Dependency Files

```bash
find . -maxdepth 2 -type f \
  -name "requirements*.txt" -o \
  -name "pyproject.toml" -o \
  -name "package.json"
```

Install dependencies according to the files found.

---


