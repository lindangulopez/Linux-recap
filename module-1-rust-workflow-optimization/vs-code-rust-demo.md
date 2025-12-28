# Demo: VS Code as a Key Component for Rust Development

```ubuntu24@ubuntu24:~$ code --version```
1.107.1
994fd12f8d3a5aa16f17d42c041e5809167e845a
x64

```ubuntu24@ubuntu24:~$ rustc --version```
rustc 1.92.0 (ded5c06cf 2025-12-08)

```ubuntu24@ubuntu24:~$ cargo --version```
cargo 1.92.0 (344c4567c 2025-10-21)



## Course Context

In this course, we combine **concepts, demonstrations, readings, and hands-on labs** to help you build practical Rust skills.

While you may use any text editor, **Visual Studio Code (VS Code)** is the **recommended development environment** because it closely matches the instructor’s setup and provides excellent Rust tooling support.

---

## Tools Used in This Course

* **Rust** – Installed using the official `rustup` toolchain manager
* **Visual Studio Code (VS Code)** – Primary code editor for demos and labs
* **GitHub Tools** *(optional but recommended)*:

  * **GitHub Copilot** – AI-assisted coding
  * **GitHub Codespaces** – Cloud-based development environments

> These tools are **not required**, but they significantly improve productivity and learning efficiency.

---

## Learning Approach

* Heavy emphasis on **hands-on labs**
* Step-by-step demos for:

  * Installing tools
  * Configuring the environment
  * Writing and running Rust code
* Clear instructions provided whenever a recommended tool is used

---

## Why Visual Studio Code?

### Purpose

* **Coding Environment**
  A clean, user-friendly editor for writing and managing Rust projects.

* **Tool Integration**
  Supports essential extensions such as:

  * **Rust Analyzer** (language intelligence)
  * **CodeLLDB** (debugging)

* **Learning Alignment**
  Matches the instructor’s setup, reducing confusion during demos.

### Potential Challenges (to be aware of)

* Initial extension configuration
* Performance on low-spec systems or virtual machines
* Learning curve with the VS Code interface
* Occasional extension compatibility issues

---

# Demo: Rust + VS Code Setup on Ubuntu 24.04

## Step 1: Install System Dependencies

```bash
sudo apt update
sudo apt install -y build-essential curl
```

---

## Step 2: Install Rust (Official Method)

We use **rustup**, which is the recommended way to install Rust.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

When prompted, choose:

```
1) Proceed with installation (default)
```

Activate Rust in the current shell:

```bash
source $HOME/.cargo/env
```

---

## Step 3: Verify Rust Installation

```bash
rustc --version
cargo --version
```

At this point, Rust is correctly installed.

---

# Demo: Installing VS Code on Ubuntu 24.04

On Ubuntu 24.04, you may see this message:

```
E: Unable to locate package code
```

This happens when the **VS Code APT repository has not been added yet**. This is expected and easy to fix.

---

## Option A (Recommended): Install VS Code via APT

### Step 1: Check for Existing VS Code Repo

```bash
ls /etc/apt/sources.list.d/ | grep vscode
```

If nothing appears, the repository is missing.

---

### Step 2: Add Microsoft’s GPG Key

```bash
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
| sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
```

---

### Step 3: Add the VS Code Repository

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" \
| sudo tee /etc/apt/sources.list.d/vscode.list
```

---

### Step 4: Update and Install VS Code

```bash
sudo apt update
sudo apt install -y code
```

---

### Step 5: Verify Installation

```bash
code --version
```

If the version prints successfully, VS Code is ready to use.

---

## Demo Wrap-Up

At this stage, you have:

* ✅ Rust installed via `rustup`
* ✅ VS Code installed via APT
* ✅ A development environment that matches the course demos

Next, we’ll install **VS Code Rust extensions** and create our first Rust project.

---


