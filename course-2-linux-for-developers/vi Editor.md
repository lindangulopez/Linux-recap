# **vi Editor — Summary and Key Commands**

`vi` is a powerful text editor in Linux/Unix. It has two main modes: **command mode** (for navigation and editing commands) and **insert mode** (for typing text).

---

## **1. Starting, Exiting, Reading, and Writing Files**

| Command        | Purpose                             |
| -------------- | ----------------------------------- |
| `vi myfile`    | Open or create `myfile` for editing |
| `vi -r myfile` | Recover file after a crash          |
| `:r file2`     | Insert content of `file2` at cursor |
| `:w`           | Save (write) current file           |
| `:w myfile`    | Save as `myfile`                    |
| `:w! file2`    | Force overwrite of `file2`          |
| `:x` or `:wq`  | Save changes and exit               |
| `:q`           | Quit (fails if unsaved changes)     |
| `:q!`          | Quit without saving changes         |

**Tip:** `:` commands are typed in command mode.

---

## **2. Moving Around**

| Command           | Purpose                        |
| ----------------- | ------------------------------ |
| Arrow keys        | Move cursor up/down/left/right |
| `h` / `l`         | Left / right one character     |
| `j` / `k`         | Down / up one line             |
| `0`               | Beginning of line              |
| `$`               | End of line                    |
| `w`               | Start of next word             |
| `b`               | Beginning of previous word     |
| `:0` / `1G`       | Go to beginning of file        |
| `:n` / `nG`       | Go to line `n`                 |
| `:$` / `G`        | Go to last line                |
| `^f` / `PageDown` | Forward one page               |
| `^b` / `PageUp`   | Back one page                  |
| `^l`              | Refresh and center screen      |

---

## **3. Searching for Text**

| Command    | Purpose                             |
| ---------- | ----------------------------------- |
| `/pattern` | Search forward for `pattern`        |
| `n`        | Repeat search in same direction     |
| `?pattern` | Search backward for `pattern`       |
| `N`        | Repeat search in opposite direction |

---

## **4. Editing Text**

| Command | Purpose                               |
| ------- | ------------------------------------- |
| `i`     | Insert before cursor                  |
| `I`     | Insert at beginning of line           |
| `a`     | Append after cursor                   |
| `A`     | Append at end of line                 |
| `o`     | Open new line below current           |
| `O`     | Open new line above current           |
| `r`     | Replace character at cursor           |
| `R`     | Enter replace mode starting at cursor |
| `x`     | Delete character at cursor            |
| `Nx`    | Delete `N` characters                 |
| `dw`    | Delete word at cursor                 |
| `D`     | Delete to end of line                 |
| `dd`    | Delete current line                   |
| `Ndd`   | Delete `N` lines                      |
| `u`     | Undo last operation                   |
| `yy`    | Yank (copy) current line              |
| `Nyy`   | Yank `N` lines                        |
| `p`     | Paste yanked text after cursor        |

---

### **Key Points**

* Use **insert mode** (`i`, `a`, `o`, etc.) to type text. Exit with **Esc**.
* Use **command mode** for navigation, searching, deleting, yanking, and saving.
* Combine commands with counts (`3dd` deletes 3 lines, `5yy` yanks 5 lines).
* Searching (`/` or `?`) makes finding text fast and efficient.

---
