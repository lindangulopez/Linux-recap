# Lab: Installing and Running Rust on Linux

## Learning Objectives

By the end of this lab, students will be able to:

* Install Rust on a Linux system
* Configure their environment correctly
* Verify the installation
* Create and run a simple Rust program using Cargo

---

## Estimated Time

**20–30 minutes**

---

## ✅ Prerequisites

* A Linux machine (or VM)
* Internet connection
* Access to a terminal
* Basic familiarity with terminal commands (`cd`, `ls`)

---

## Part 1: Install Rust

### Step 1: Open the Terminal

Open a terminal window using your desktop menu or shortcut (often **Ctrl + Alt + T**).

---

### Step 2: Download and Run the Rust Installer

Copy and paste the following command into the terminal:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

When prompted:

* Press **Enter** to select the default installation.

⏳ The installer will download and set up Rust and its tools.

---

## Part 2: Configure the Environment

### Step 3: Source the Rust Environment

After installation completes, run:

```bash
source $HOME/.cargo/env
```

 This step updates your PATH so the system can find Rust commands.

---

## Part 3: Verify the Installation

### Step 4: Check the Rust Compiler

Run:

```bash
rustc --version
```

✔️ You should see the installed Rust version.

---

### Step 5: Check Cargo (Rust’s Package Manager)

Run:

```bash
cargo --version
```

✔️ This confirms Cargo is installed and ready.

---

## Part 4: Create and Run a Demo Program

### Step 6: Create a New Rust Project

Use Cargo to create a demo project:

```bash
cargo new rust_demo
```

---

### Step 7: Move Into the Project Folder

```bash
cd rust_demo
```

---

### Step 8: Run the Program

```bash
cargo run
```

🖥️ Output should look like:

```
Hello, world!
```

🎉 Congratulations! You’ve successfully built and run a Rust program.

---

## 🧩 Part 5: Understanding Common Issues

### ❌ Problem: `command not found`

If you see something like:

```bash
rustc: command not found
```

✅ Solution:
Run the following command again:

```bash
source $HOME/.cargo/env
```

Or restart the terminal.

---

## 📝 Lab Checklist (Student Self-Check)

☐ Rust installed without errors
☐ PATH sourced successfully
☐ `rustc --version` works
☐ `cargo --version` works
☐ Demo project created
☐ Program runs and prints “Hello, world!”

---

## 💬 Reflection Questions (Optional)

1. What is Cargo used for in Rust?
2. Why is updating the PATH necessary after installation?
3. What happens when you run `cargo run`?

---

## 🧠 Extension (Optional Challenge)

Try editing the program:

1. Open `src/main.rs`
2. Change the message inside `println!`
3. Run `cargo run` again and observe the output

---

