# Walk through the `.bashrc` template

---

## **1. Aliases Section**

```bash
alias l='ls -laF'
alias dir='ls -latF'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -ipdv'
alias df='df -T'
alias gitstat='git status -uno'
alias diffside='diff --side-by-side --ignore-all-space'
```

**Explanation:**

* **Aliases** are shortcuts for commands.
* `l='ls -laF'` → `l` lists files with details, including hidden files.
* `rm='rm -i'` → safer remove; asks for confirmation.
* `gitstat='git status -uno'` → shortcut for Git status without untracked files.
* Use `unalias l` to remove any alias.

**Why important:**
Makes your command-line faster and safer.

---

## **2. Environment Variables Section**

```bash
export EDITOR=/usr/bin/emacs
export PATH=$HOME/bin:$PATH
export CD_PATH=$HOME:/tmp
export PAGER=/usr/bin/less
export HISTSIZE=1000
export NCPUS=$(grep processor /proc/cpuinfo | wc -l)
export XZ_OPT=-T7
```

**Explanation:**

* **EDITOR** → default text editor (used by Git, crontab, etc.)
* **PATH** → directories to search for commands; `$HOME/bin` added for personal scripts
* **CD_PATH** → custom path for quick navigation
* **PAGER** → default program for paging long outputs (`less`)
* **HISTSIZE** → how many commands your shell remembers
* **NCPUS** → number of CPU cores; can be used by parallel programs
* **XZ_OPT** → optimization for `xz` compression using multiple threads

**Why important:**
Environment variables configure how programs behave and help make your terminal more productive.

---

## **3. Functions Section**

```bash
git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo "($branch)"
    fi
}

python_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "(`basename $VIRTUAL_ENV`)"
    fi
}

cdir() { cd "$1" && ls; }
```

**Explanation:**

* `git_branch()` → detects current Git branch and prints it. If not in a Git repo, prints nothing.
* `python_venv()` → shows active Python virtual environment (useful for Python projects).
* `cdir()` → changes directory and immediately lists its contents.

**Why important:**

* Gives you contextual info in your prompt (branch, environment).
* Quick navigation functions save time.

---

## **4. Prompt Customization (PS1)**

```bash
export PS1="\[\e[33m\][\t] \[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\] \$(git_branch) \$(python_venv)> "
```

**Breakdown of PS1:**

| Part              | Meaning                           | Example Output         |
| ----------------- | --------------------------------- | ---------------------- |
| `\[\e[33m\][\t]`  | Yellow colored time               | `[14:45:12]`           |
| `\[\e[32m\]\u@\h` | Green username@hostname           | `coop@c7`              |
| `\[\e[34m\]\w`    | Blue current working directory    | `/home/coop/myproject` |
| `\$(git_branch)`  | Current Git branch                | `(main)`               |
| `\$(python_venv)` | Active Python virtual environment | `(venv)`               |
| `>`               | Prompt symbol                     | `>`                    |

**Why important:**

* Immediately shows **where you are**, **which user you are**, **Git branch**, **Python virtual environment**, and **current time**.
* Reduces mistakes, especially when running commands in multiple projects or as root.

---

## **5. Sourcing System-wide bashrc**

```bash
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi
```

**Explanation:**

* Checks if the **system-wide bashrc exists** and loads it.
* Ensures you still get default Ubuntu behaviors, like colors, aliases, and completions.

---

## **6. Reload Instructions**

```bash
# Reload manually with: source ~/.bashrc
```

**Explanation:**

* After editing `.bashrc`, run `source ~/.bashrc` to immediately apply changes.
* Without this, changes only take effect next time you open a terminal.

---

### **Summary of what this sheet gives you**

1. **Safe, efficient command shortcuts** with aliases.
2. **Configured environment variables** for Python development, shell behavior, and CPU optimization.
3. **Context-aware prompt** showing time, user, hostname, current directory, Git branch, and Python virtual environment.
4. **Quick functions** for directory navigation and Git info.
5. **Integration with system defaults** via `/etc/bash.bashrc`.

---

## Visual diagram of prompt

```
[HH:MM:SS] user@host:/current/directory (git_branch) (python_venv)>
 |       |      |          |          |         |
Time   Username Host  Current Dir   Git      Python
                               Branch   Virtual Env
                               (if in repo) (if activated)
```

### **Color coding**

* **Time `[HH:MM:SS]`** → Yellow (`\e[33m`)
* **Username@hostname** → Green (`\e[32m`)
* **Current directory** → Blue (`\e[34m]`)
* **Git branch** → Default terminal color (no special color code in template)
* **Python virtual environment** → Default terminal color
* **Prompt symbol `>`** → Default color

---

### **Example**

Suppose your terminal is in a Python Git project with a virtual environment called `venv` and Git branch `main`:

```
[14:45:12] coop@c7:/home/coop/myproject (main) (venv)>
```

* `[14:45:12]` → current time
* `coop@c7` → username and hostname
* `/home/coop/myproject` → working directory
* `(main)` → Git branch
* `(venv)` → active Python virtual environment

---

**Key points about this design:**

1. You immediately know **where you are** and **what environment you’re in**.
2. Helps avoid mistakes when working with multiple repos or as root.
3. Easy to read thanks to color coding.
4. Works dynamically — the Git branch and Python virtual environment update automatically as you move between projects.

---
