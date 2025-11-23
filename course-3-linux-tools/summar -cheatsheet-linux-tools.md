## Linux Tools for Developers

This course teaches the essential Linux tools and utilities that developers need for day-to-day work. You build competence in using command-line tools, scripting with Bash to automate tasks, and managing files and filesystems. It also covers how to compile programs, debug them, and package software, giving you insight into both programming and system-level development on Linux. By the end, you’ll feel more comfortable writing scripts, manipulating the filesystem, and building and distributing Linux software.

The three main areas covered are:

1. **Command Line Tools** — mastering core Linux commands and text-processing utilities
2. **Files & Filesystems** — understanding file metadata, permissions, links, and how to navigate the directory structure
3. **Linux Developer Methods** — scripting, compiling with compilers like GCC, debugging, and package creation/management

Skills you gain include: Bash scripting, system programming, file management, package building, debugging, and using the command line effectively.

---

## Cheat Sheet — Linux Tools for Developers

* **Command-Line Essentials**

  * Navigate: `cd`, `ls`, `pwd`
  * File ops: `cp`, `mv`, `rm`, `mkdir`, `touch`
  * View content: `cat`, `less`, `head`, `tail`
  * Process text: `grep`, `wc`, `sort`, `awk`
  * Combine: use pipes (`|`) and redirection (`>`, `>>`)

* **Help & Documentation**

  * Manual pages: `man <command>`
  * Inline help: `<command> --help`

* **Bash Scripting**

  * Shebang: `#!/bin/bash`
  * Variables: `VAR=value`
  * Conditionals: `if …; then …; fi`
  * Loops: `for …; do …; done`, `while …; do …; done`
  * Functions: `my_func () { … }`

* **Filesystem & Permissions**

  * List permissions: `ls -l`
  * Change permissions: `chmod`
  * Change ownership: `chown`
  * Create symbolic links: `ln -s <target> <link_name>`

* **Compiling & Debugging**

  * Compile C: `gcc source.c -o output`
  * Debug: use `gdb` or simpler built-in diagnostics

* **Package & Build Tools**

  * Use build scripts or makefiles
  * Understand dependencies, build paths, and install locations

* **System Programming Concepts**

  * Use system calls in C for file handling and process control
  * Link libraries and understand how binary builds work
