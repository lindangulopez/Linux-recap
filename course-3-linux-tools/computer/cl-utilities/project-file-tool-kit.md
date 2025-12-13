# **project tool-kit**

These tools are essential for **navigating, auditing, and updating a project like CodeMeta efficiently**.

* **`find`** → Locate files based on attributes.
* **`locate`** → Fast file search using a pre-built database.
* **`grep`** → Search inside files for patterns.
* **`sed`** → Modify file contents on the fly.


## **1. Finding Files**

### **`find`**

The `find` command is extremely flexible for locating files **based on name, type, size, date, ownership, and more**. It searches directories recursively but **does not search file contents**.

**Syntax:**

```bash
find [location] [criteria] [actions]
```

* **location** – where to start searching (default: current directory `.`)
* **criteria** – conditions like file name, size, type, or modification date
* **actions** – what to do with the files found (default: list names)

**Examples:**

```bash
# Find all .conf files in /etc
find /etc -name "*.conf"

# Long listing of .conf files
find /etc -name "*.conf" -ls

# Find files in /tmp and /etc either ending in .conf or newer than a lock file
find /tmp /etc -name "*.conf" -or -newer /tmp/.X0-lock -ls

# Delete all backup files ending with ~
find . -name "*~" -exec rm {} \;

# Safe deletion of files with special characters
find . -name "*~" -print0 | xargs -0 rm
```

### **`locate`**

The `locate` command is much faster than `find` because it uses a pre-built **database of files**. The database is updated periodically by `updatedb`.

**Example:**

```bash
locate .conf
# Find all files containing ".conf"
```

**Note:** `locate` only finds files that existed the last time the database was updated.

---

## **2. Searching Inside Files**

### **`grep`**

`grep` searches for patterns **inside files** and can handle regular expressions, multiple search strings, and recursive searches.

**Basic Example:**

```bash
grep pig file
# Finds all lines containing "pig"
```

**Advanced Examples:**

```bash
# Ignore case and search for multiple strings recursively
grep -i -e pig -e dog -r .

# Lines starting with "dog"
grep "^dog" file

# Lines ending with "dog"
grep "dog$" file

# Lines containing letters a through p after 'd'
grep d[a-p] file
```

**Common options:**

| Option | Meaning                                 |
| ------ | --------------------------------------- |
| `-i`   | Ignore case                             |
| `-v`   | Invert match (lines that do NOT match)  |
| `-n`   | Print line numbers                      |
| `-H`   | Print filename                          |
| `-r`   | Recurse into subdirectories             |
| `-l`   | Print only filenames containing matches |
| `-c`   | Count matching lines                    |

---

## **3. Editing Files on the Fly**

### **`sed`**

`sed` (stream editor) modifies file content **without opening a text editor**. Commonly used for substitutions.

**Examples:**

```bash
# Replace first occurrence of "pig" with "cow" in each line
sed s/pig/cow/ file > newfile

# Replace all occurrences globally
sed s/pig/cow/g file > newfile

# Use a different delimiter (colon) if needed
sed s:pig:cow:g file > newfile

# Replace backslashes with forward slashes
sed s/'\\'/'\/'/g file > newfile

# Multiple substitutions in one pass
sed -e s/pig/cow/g -e s/dog/cat/g < file > newfile

# Apply sed to streamed input
echo hello | sed s/hello/goodbye/g
```

**Tip:** Use single quotes to prevent variable expansion, double quotes if you want variables expanded.

---

## **4. Real-World Example**

Suppose you are **working on the CodeMeta GitHub Pages project**:

* You want to **find all Markdown posts older than a certain date**:

```bash
find _posts/ -name "*.md" -mtime +365
```

* Search inside files for mentions of "license":

```bash
grep -i license _posts/*.md
```

* Replace all occurrences of "draft" with "final" in a Markdown file:

```bash
sed -i s/draft/final/g _posts/2025-01-01-example.md
```

* Quickly delete all backup files ending with `~` in the project directory:

```bash
find . -name "*~" -print0 | xargs -0 rm
```

---


