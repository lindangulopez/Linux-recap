# **1. Launching a Shell**

* Any shell (bash, zsh, etc.) can be started by typing its name:

  ```bash
  $ bash
  ```
* Your **default shell** can be changed with:

  ```bash
  $ chsh
  ```

  This will prompt you to enter a new shell path (e.g., `/bin/bash` or `/bin/zsh`).

---

## **2. Types of Shells**

1. **Login shell** – You enter your username and password (e.g., logging in via console, SSH, or virtual terminal).
2. **Interactive shell** – Shell has input/output connected to a terminal. You can type commands and see results.
3. **Non-interactive shell** – Usually used to run scripts or commands without a terminal. Input/output might be a file or another process.

---

## **3. Initialization Files in Bash**

Bash reads different files depending on **login vs. non-login** and **interactive vs. non-interactive**.

### **Login Shells**

When you log in:

1. Bash looks for **system-wide configuration**:

   ```bash
   /etc/profile
   ```

   If it exists, bash sources it.
2. Then it looks for **user-specific files** in this order:

   * `~/.bash_profile` → most common
   * `~/.bash_login` → if `.bash_profile` doesn’t exist
   * `~/.profile` → fallback

**On logout:**

* Bash runs `~/.bash_logout` if it exists.

---

### **Non-login Interactive Shells**

* Bash looks for `~/.bashrc` and sources it.
* Usually, `~/.bashrc` also sources a **system-wide file**, often `/etc/bash.bashrc`, so you inherit global settings.

---

### **Non-interactive Shells**

* Typically, used to run scripts:

  ```bash
  $ bash script.sh
  ```
* Even though `man bash` may seem confusing, in practice, these shells behave like interactive ones regarding initialization (often they still read some environment files).

---

## **4. What You Should Do on Ubuntu VM**

On your Ubuntu VM:

1. **Check your default shell:**

   ```bash
   $ echo $SHELL
   ```

2. **Change your shell if needed:**

   ```bash
   $ chsh -s /bin/bash
   ```

3. **Inspect or edit initialization files**:

   ```bash
   $ ls -a ~
   ```

   Look for:

   * `.bashrc` → configuration for interactive shells
   * `.bash_profile`, `.profile` → configuration for login shells
   * `.bash_logout` → commands to run on logout

4. **Edit `.bashrc`** to customize your shell (aliases, environment variables, prompt):

   ```bash
   $ nano ~/.bashrc
   ```

   Example:

   ```bash
   alias ll='ls -alF'
   export PATH=$PATH:~/bin
   ```

   Save and reload:

   ```bash
   $ source ~/.bashrc
   ```

5. **Understand the flow**:

   * Login shell → `/etc/profile` → user files
   * Non-login interactive shell → `~/.bashrc`
   * Scripts → can source `.bashrc` if needed

---
