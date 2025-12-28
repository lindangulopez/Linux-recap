# Key Component vs-code

### Course Structure

* The course includes a mix of concepts, demonstrations, readings, and labs to enhance understanding and application of Rust programming.
* **Visual Studio Code (VS Code)** is recommended for coding, but learners can use any text editor of their choice.

### Tools and Resources

* Rust will be installed, and learners will be introduced to GitHub tools like **GitHub Copilot** (an AI coding assistant) and **Codespaces** (a cloud-based development environment).
* These tools are not mandatory but highly recommended for efficient learning and coding.

### Learning Approach

* Emphasis is placed on hands-on labs to practice concepts.
* Detailed instructions on using recommended tools are provided throughout the course.

---

## Visual Studio Code in the "Rust Fundamentals" Course

**Purpose:**

* **Coding Environment**: A user-friendly interface for writing and editing Rust code.
* **Tool Integration**: Supports extensions like Rust Analyzer and CodeLLDB.
* **Learning Alignment**: Mirrors the instructor’s coding environment for better understanding.

**Potential Challenges:**

* Configuration complexity for extensions
* Performance issues on low-spec systems
* Learning curve for interface and features
* Extension compatibility conflicts

---

## Installing Visual Studio Code on Ubuntu Linux

1. **Update packages**

```bash
sudo apt update
sudo apt upgrade
```

2. **Install dependencies**

```bash
sudo apt install software-properties-common apt-transport-https wget
```

3. **Import Microsoft GPG key**

```bash
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
```

4. **Enable VS Code repository**

```bash
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
```

5. **Install VS Code**

```bash
sudo apt update
sudo apt install code
```

6. **Launch VS Code**

```bash
code
```

---

## Configuring Visual Studio Code for Rust

1. **Install Extensions**

   * **Rust Analyzer**: code completion, error checking, etc.
   * **CodeLLDB**: debugging Rust applications

2. **Set Up Workspace**

   * `File > Add Folder to Workspace`
   * Organize project files logically

3. **Configure Settings**

   * `File > Preferences > Settings`
   * Adjust theme, font size, editor behavior

4. **Create Project-Specific Settings**

```json
.vscode/settings.json
{
  "rust-analyzer.cargo.runBuildScripts": true,
  "editor.formatOnSave": true
}
```

5. **Set Up Debugging**

* Create `.vscode/launch.json` for Rust debugging configurations

6. **Version Control Integration**

* Initialize Git: `git init`
* Use built-in source control to manage commits, branches, and merges

7. **Customize Keybindings**

* `File > Preferences > Keyboard Shortcuts`

---

## Integrating GitHub Tools with VS Code

1. **Install Git**

```bash
sudo apt install git
```

2. **Configure Git**

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

3. **Install GitHub Extension**

* VS Code Extensions view → **GitHub Pull Requests and Issues**

4. **Clone a Repository**

* `Ctrl + Shift + P` → `Git: Clone` → enter repository URL

5. **GitHub Copilot (Optional)**

* Install Copilot extension → Sign in to GitHub → Enable AI-assisted coding

6. **Source Control Management**

* Stage, commit, push, create branches, merge, and resolve conflicts

7. **Pull Requests**

* View, create, and manage PRs directly from VS Code

---

This section ensures learners have a fully configured development environment for Rust and GitHub, aligned with the course requirements and best practices.
