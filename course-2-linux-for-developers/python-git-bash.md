# **Enhanced `~/.bashrc` for Python Git projects**

This is **perfect for Python development**: you can immediately see the project, branch, and virtual environment without running extra commands.

```bash
# ~/.bashrc - Python & Git aware prompt

# -------------------
# Aliases
# -------------------
alias l='ls -laF'
alias dir='ls -latF'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -ipdv'
alias df='df -T'
alias gitstat='git status -uno'
alias diffside='diff --side-by-side --ignore-all-space'

# -------------------
# Environment Variables
# -------------------
export EDITOR=/usr/bin/emacs
export PATH=$HOME/bin:$PATH
export CD_PATH=$HOME:/tmp
export PAGER=/usr/bin/less
export HISTSIZE=1000
export NCPUS=$(grep processor /proc/cpuinfo | wc -l)
export XZ_OPT=-T7

# -------------------
# Functions
# -------------------
# Function to get current Git branch
git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo "($branch)"
    fi
}

# Function to show active Python virtual environment
python_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "(`basename $VIRTUAL_ENV`)"
    fi
}

# Quick cd and list
cdir() { cd "$1" && ls; }

# -------------------
# Prompt customization (PS1)
# -------------------
# Shows: [time] user@host:current_dir (git_branch) {python_venv}>
export PS1="\[\e[33m\][\t] \[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\] \$(git_branch) \$(python_venv)> "

# Explanation:
# \t -> current time HH:MM:SS
# \u -> username
# \h -> hostname
# \w -> current directory
# $(git_branch) -> shows Git branch if in a repo
# $(python_venv) -> shows active Python virtual environment
# Color codes: 33=yellow (time), 32=green (user@host), 34=blue (directory)
# \e[m resets color

# -------------------
# Source system-wide bashrc
# -------------------
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi
```

---

### **Usage**

1. Open your `.bashrc`:

```bash
nano ~/.bashrc
```

2. Paste the template above, save, and exit.
3. Reload:

```bash
source ~/.bashrc
```

4. Open a terminal in a Python Git project with an active virtual environment. Example prompt:

```
[14:45:12] coop@c7:/home/coop/myproject (main) (venv)>
```

* `[14:45:12]` → current time
* `coop@c7` → username@hostname
* `/home/coop/myproject` → current directory
* `(main)` → Git branch
* `(venv)` → active Python virtual environment

---

