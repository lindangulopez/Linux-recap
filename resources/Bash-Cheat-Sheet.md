# **Bash Cheat Sheet**

This shows **the flow from typing a command to executing it**, including aliases, PATH lookup, environment variables, and redirection.

## **1. PATH Environment Variable**

**Purpose:** Determines where the shell looks for executable files.

* **View current PATH**

```bash
echo $PATH
```

* **Add a directory temporarily**

```bash
PATH=$HOME/newbin:$PATH   # prepend newbin to PATH
PATH=$PATH:$HOME/newbin   # append newbin to PATH
```

* **Explanation:**

  * Prepending makes your directory searched **first**.
  * Appending makes it searched **last**.
  * `$HOME` refers to your home directory.

---

## **2. Environment Variables for Single Command**

**Purpose:** Set a variable for one command only.

```bash
VAR=value ./foobar
```

* **Explanation:**

  * `VAR=value` only applies to `./foobar`.
  * Other shell commands won’t be affected.

**Persistent export for all commands in the session:**

```bash
export VAR=value
```

---

## **3. Arithmetic in Bash**

**Purpose:** Perform calculations inside scripts or command line.

* **Using expr**

```bash
x=10
echo $(expr $x - 3)
```

* **Using arithmetic expansion**

```bash
echo $(($x - 3))
```

* **Explanation:**

  * `$x` is a variable reference.
  * Spaces around operators are needed for `expr`.
  * Arithmetic expansion `$(( ))` is simpler and preferred.

---

## **4. Output Redirection**

**Purpose:** Save command outputs to files or handle errors.

* **Redirect standard output (stdout)**

```bash
prog > file
```

* **Redirect error output (stderr)**

```bash
prog 2> file
```

* **Redirect both stdout and stderr**

```bash
prog > file 2>&1
# or equivalently
prog >& file
```

* **Append output instead of overwriting**

```bash
prog >> file
```

* **Explanation:**

  * `>` overwrites, `>>` appends.
  * `2>&1` merges error messages with normal output.

---

## **5. Aliases**

**Purpose:** Create shortcuts for long or frequently used commands.

* **Create an alias**

```bash
alias ll='ls -laF'
alias doitall="make clean; make all; evince output.pdf"
```

* **Remove an alias**

```bash
unalias ll
```

* **Explanation:**

  * Aliases make repetitive commands easier to type.
  * Use quotes if the command contains multiple parts separated by semicolons.

---

## **6. Quick Reference Symbols**

| Symbol       | Meaning                                      |
| ------------ | -------------------------------------------- |
| `$VAR`       | Reference variable `VAR`                     |
| `$HOME`      | Home directory path                          |
| `>`          | Redirect stdout to file                      |
| `2>`         | Redirect stderr to file                      |
| `2>&1`       | Merge stderr into stdout                     |
| `>>`         | Append output to file                        |
| `alias`      | Define command shortcuts                     |
| `unalias`    | Remove alias                                 |
| `export`     | Make a variable available to child processes |
| `$(( ))`     | Arithmetic expansion                         |
| `$(command)` | Command substitution                         |

---

### **Tips for Practice**

1. Always test PATH changes in a single terminal before making them permanent.
2. Use temporary environment variables to avoid affecting your entire session.
3. Use aliases for commands you run frequently.
4. Remember `2>&1` when logging programs to capture errors too.
5. Arithmetic expansion `$(( ))` is safer than `expr`.

---
## **visual diagram showing how PATH, aliases, environment variables, and redirection work together in Bash**.

---

```
                  +-----------------+
                  |  Command typed  |
                  +-----------------+
                           |
            +--------------+---------------+
            |                              |
        Is it an alias?                  Not an alias
            |                              |
      +-----+-----+                        |
      | Execute   |                        |
      | alias cmd |                        |
      +-----------+                        |
                                           |
                      +--------------------+--------------------+
                      |                                         |
                  Search PATH for executable             Could be a shell builtin
                      |                                         |
              +-------+--------+                        +-------+--------+
              | Found in dir?  |                        | Execute builtin|
              +-------+--------+                        +----------------+
                      |
        +-------------+--------------+
        |                            |
     Execute file                 Command not found
        |
        v
  +----------------+
  | Outputs result |
  +----------------+
        |
        v
  +-------------------------+
  | Redirection? (>, >>, 2>)|
  +-------------------------+
        |
   +----+----+
   |         |
Redirect   Display on
to file     terminal
```

### **Legend / Notes**

* **Aliases**: Shortcuts that replace the command before searching PATH.
* **PATH**: List of directories the shell searches to find executables.
* **Environment Variables**: Control behavior of commands and scripts (like `$EDITOR` or `$HOME`).
* **Redirection (`>`, `>>`, `2>`, `2>&1`)**: Determines where command output goes—terminal or file.

---


