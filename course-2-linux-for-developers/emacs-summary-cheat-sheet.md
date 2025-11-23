# **Emacs**

`Emacs` is a powerful, extensible text editor. Commands often use the **Control (Ctl)** key and **Meta (M)** key (often `Alt` on modern keyboards). It has modes for editing text, navigating, searching, and managing files.

---

## **1. Starting, Exiting, Reading, and Writing Files**

| Command        | Purpose                                   |
| -------------- | ----------------------------------------- |
| `emacs myfile` | Start Emacs and edit `myfile`             |
| `Ctl-x i`      | Insert a file at the cursor position      |
| `Ctl-x s`      | Save the current file                     |
| `Ctl-x Ctl-w`  | Save current file with a new name         |
| `Ctl-x Ctl-s`  | Save all open files                       |
| `Ctl-x Ctl-c`  | Exit Emacs, prompts to save unsaved files |

**Tip:** `Ctl-x` is often used as a “prefix” for file management commands.

---

## **2. Moving Around**

| Command            | Purpose                        |
| ------------------ | ------------------------------ |
| Arrow keys         | Move cursor up/down/left/right |
| `Ctl-n`            | Move down one line             |
| `Ctl-p`            | Move up one line               |
| `Ctl-f`            | Move forward one character     |
| `Ctl-b`            | Move backward one character    |
| `Ctl-a`            | Beginning of line              |
| `Ctl-e`            | End of line                    |
| `M-f`              | Beginning of next word         |
| `M-b`              | Beginning of previous word     |
| `M-<`              | Beginning of file              |
| `M->`              | End of file                    |
| `M-x goto-line n`  | Go to line `n`                 |
| `Ctl-v` / PageDown | Forward one page               |
| `M-v` / PageUp     | Backward one page              |
| `Ctl-l`            | Refresh and center screen      |

---

## **3. Searching for Text**

| Command | Purpose                                      |
| ------- | -------------------------------------------- |
| `Ctl-s` | Search forward for text (incremental search) |
| `Ctl-r` | Search backward for text                     |

**Tip:** Press `Ctl-s` or `Ctl-r` repeatedly to find the next occurrence.

---

## **4. Editing Text**

| Command              | Purpose                              |
| -------------------- | ------------------------------------ |
| `Ctl-o`              | Insert a blank line below the cursor |
| `Ctl-d`              | Delete character at cursor           |
| `Ctl-k`              | Delete from cursor to end of line    |
| `Ctl-_` or `Ctl-x u` | Undo last operation                  |
| `Ctl-space`          | Set mark to begin selecting a region |
| `Ctl-w`              | Cut (kill) marked region             |
| `Ctl-y`              | Paste (yank) previously cut text     |

**Tip:** `Ctl-space` + movement selects text, which can then be cut/pasted.

---

## **Key Points**

* `Ctl-x` is a prefix for most file and buffer commands.
* `Ctl-` commands operate on the cursor position or current buffer.
* `M-` commands (Meta/Alt) are used for movement and other advanced operations.
* Text can be cut and pasted using a mark (`Ctl-space`) and kill/yank commands.
* Emacs has incremental search (`Ctl-s` / `Ctl-r`) for efficient navigation.

---

### **Emacs Cheat Sheet — Quick Reference**

```
# File Operations
emacs myfile      # open file
Ctl-x i           # insert file
Ctl-x s           # save file
Ctl-x Ctl-w       # save as new name
Ctl-x Ctl-s       # save all files
Ctl-x Ctl-c       # exit editor

# Movement
Ctl-n / Ctl-p     # down/up one line
Ctl-f / Ctl-b     # right/left one character
Ctl-a / Ctl-e     # beginning/end of line
M-f / M-b         # forward/back one word
M-< / M->         # beginning/end of file
M-x goto-line n   # go to line n
Ctl-v / M-v       # page down/up
Ctl-l              # refresh/center

# Search
Ctl-s             # search forward
Ctl-r             # search backward

# Editing
Ctl-o             # insert blank line
Ctl-d             # delete char
Ctl-k             # delete to end of line
Ctl-_ / Ctl-x u   # undo
Ctl-space         # mark text region
Ctl-w             # cut region
Ctl-y             # paste region
```

---
