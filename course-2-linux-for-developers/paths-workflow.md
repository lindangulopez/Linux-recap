# **Linux Paths and Command Workflow**

This etup ensures you can **run your own scripts easily, navigate the system efficiently, and manage your Git projects** directly from your Ubuntu VM.

---

## **1. Check Your Current PATH**

The PATH variable defines which directories the shell searches for executables. To check it:

```bash
echo $PATH
```

Example output:

```
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/student/bin
```

* Directories are searched **from left to right**.
* The first executable found is the one that will run.
* Use `which` to see which executable will run for a command:

```bash
which --skip-alias emacs
```

---

## **2. Create a Custom Directory for Your Scripts**

It’s common to have a personal bin directory for your scripts:

```bash
mkdir -p $HOME/my_bin_dir
```

* Put your scripts or programs here.
* Make them executable:

```bash
chmod +x $HOME/my_bin_dir/myscript.sh
```

---

## **3. Add Your Directory to PATH**

You can **prepend** (take priority) or **append** (run after system binaries) your directory:

* Prepend (your scripts have priority):

```bash
export PATH=$HOME/my_bin_dir:$PATH
```

* Append (system binaries have priority):

```bash
export PATH=$PATH:$HOME/my_bin_dir
```

Verify your PATH:

```bash
echo $PATH
```

---

## **4. Run Programs in the Current Directory**

Linux does **not** include `.` (current directory) in PATH by default. To run a script in the current directory:

```bash
./myscript.sh
```

* `./` tells the shell to look in the current directory.

---

## **5. Make PATH Changes Permanent**

Add PATH changes to your shell initialization file (`.bashrc`) so they persist across sessions:

```bash
nano ~/.bashrc
```

Add the following lines at the bottom:

```bash
# Custom bin directory
export PATH=$HOME/my_bin_dir:$PATH

# Optional: Add frequently used directories for cd
export CDPATH=/usr:$HOME:$CDPATH
```

Reload `.bashrc` to apply changes:

```bash
source ~/.bashrc
```

---

## **6. Using CDPATH for Easier Navigation**

CDPATH defines directories searched by the `cd` command:

```bash
export CDPATH=/usr:$HOME:$CDPATH
cd bin
```

* Searches `/usr/bin` and `$HOME/bin` automatically.
* If a directory exists in CDPATH, `cd <dir>` takes you there without typing the full path.

---

## **7. Absolute vs Relative Paths**

* **Absolute path:** Full path starting with `/`

```bash
cd /usr/local/bin
```

* **Relative path:** Relative to current directory

```bash
cd ./scripts      # in current directory
cd ../parentdir   # up one level
```

---

## **8. Integrating with Git**

If you work with Git repositories:

1. **Clone a repository**:

```bash
cd $HOME
git clone https://github.com/yourusername/yourrepo.git
cd yourrepo
```

2. **Run scripts from your repo**:

* Either run with relative path:

```bash
./myscript.sh
```

* Or add your repo’s `bin` directory to PATH to run scripts from anywhere:

```bash
export PATH=$HOME/yourrepo/bin:$PATH
echo 'export PATH=$HOME/yourrepo/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

3. **Committing your scripts**:

```bash
git add myscript.sh
git commit -m "Add myscript"
git push
```

---

## **9. Visual Overview of PATH and Command Execution**

```
User types command
        │
        ▼
   Alias exists? → Yes → Run alias
        │
        No
        ▼
  Shell searches $PATH (left to right)
        │
Executable found? ──> Yes → Run it
        │
        No → Command not found
```

* Prepend your directories to PATH to prioritize your scripts.
* Use `./` to run programs in the current directory.
* CDPATH simplifies navigation.

---

### **Key Tips for Ubuntu VM**

* Always create a `bin` directory in your home for personal scripts.
* Keep `$HOME/bin` in your PATH permanently via `.bashrc`.
* Use Git to version-control your scripts and share across systems.
* Make scripts executable with `chmod +x script.sh`.
* Use CDPATH to quickly `cd` into frequently accessed directories.

---

