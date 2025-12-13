# **Linux Text-Processing Cheat Sheet**

*(Using `sed` and `awk` for file manipulation, filtering, and reporting)*

This cheat sheet can be **immediately used** on **CodeMeta project files**, whether `.json`, `.csv`, or log files, for tasks like:

* Updating versions
* Extracting author names
* Counting license types
* Monitoring logs during builds

---

## **1. `sed` (Stream Editor)**

`sed` is used for **substitutions, deletions, and text transformations** on files or streams.

### **Basic Syntax**

```bash
sed -e 'command' filename        # Specify command at the CLI
sed -f scriptfile filename       # Execute commands from a script file
```

### **Substitution Commands**

| Command                             | Description                                          |
| ----------------------------------- | ---------------------------------------------------- |
| `sed 's/pattern/replace/' file`     | Replace **first occurrence** of pattern in each line |
| `sed 's/pattern/replace/g' file`    | Replace **all occurrences** of pattern in each line  |
| `sed '1,3s/pattern/replace/g' file` | Replace pattern in lines 1 through 3                 |
| `sed -i 's/pattern/replace/g' file` | Replace pattern **in-place** in the file             |

### **Creating & Editing Files**

```bash
cat > newfile.txt
# Type content, press Ctrl-D to save

sed 's/old/new/g' file1 > file2   # Save changes to new file
mv file2 file1                    # Overwrite original if approved
```

### **Example: Updating CodeMeta Files**

Suppose you want to replace all `"v1.0"` with `"v1.1"` in metadata JSON files:

```bash
sed -i 's/"v1.0"/"v1.1"/g codemeta.json
```

---

## **2. `awk` (Text Processing & Reporting)**

`awk` processes **files line by line**, splitting each line into **fields**, and performs actions based on patterns.

### **Basic Syntax**

```bash
awk 'command' filename            # Command at CLI
awk -f scriptfile filename        # Execute commands from a script file
awk -F: '{ print $1 }' filename   # Specify custom field separator
```

### **Fields in `awk`**

| Variable | Description  |
| -------- | ------------ |
| `$0`     | Entire line  |
| `$1`     | First field  |
| `$2`     | Second field |
| `$NF`    | Last field   |

### **Examples**

Assume `users.txt` in project:

```
alice:x:1001:1001::/home/alice:/bin/bash
bob:x:1002:1002::/home/bob:/bin/zsh
carol:x:1003:1003::/home/carol:/bin/bash
```

* Print entire file:

```bash
awk '{ print $0 }' users.txt
```

* Print first and seventh fields (username & shell):

```bash
awk -F: '{ print $1, $7 }' users.txt
```

* Filter lines containing "bash":

```bash
awk -F: '/bash/ { print $1 }' users.txt
```

* Use `awk` for JSON/CSV extraction in CodeMeta:

```bash
awk -F',' '{ print $1, $3 }' codemeta.csv
```

---

## **3. Combining `sed` and `awk`**

You can **pipe commands together** for more advanced processing:

* **Example:** Replace a version string and extract author names:

```bash
sed 's/"v1.0"/"v1.1"/g' codemeta.json | awk -F: '/"author"/ { print $2 }'
```

* **Example:** Count number of occurrences of `"license"` in all JSON files:

```bash
awk '/"license"/ { count++ } END { print count }' codemeta.json
```

---

## **4. Working with Multiple Files**

* Replace a string across all `.json` files:

```bash
for f in *.json; do sed -i 's/"v1.0"/"v1.1"/g' "$f"; done
```

* Print first field of all `.csv` files:

```bash
awk -F',' '{ print $1 }' *.csv
```

---

## **5. Tips & Tricks**

* **Preview changes before applying**:

```bash
sed 's/old/new/g' file > preview.txt
```

* **Backup original files when using `-i`**:

```bash
sed -i.bak 's/old/new/g' file
```

* **Combine grep with awk**:

```bash
grep "John" codemeta.csv | awk -F',' '{ print $1, $3 }'
```

* **Monitor logs for CodeMeta builds**:

```bash
tail -f build.log | awk '/ERROR/ { print $0 }'
```

---

## **6. Quick Reference Table**

| Command                             | Purpose                      |
| ----------------------------------- | ---------------------------- |
| `sed 's/old/new/g' file`            | Replace text in file         |
| `sed -i 's/old/new/g' file`         | Replace in-place             |
| `awk '{ print $0 }' file`           | Print entire line            |
| `awk -F: '{ print $1, $7 }' file`   | Print specific fields        |
| `awk '/pattern/ { print $0 }' file` | Print lines matching pattern |
| `cat file`                          | View file                    |
| `tac file`                          | View file in reverse         |
| `head -n 5 file`                    | First 5 lines                |
| `tail -n 10 file`                   | Last 10 lines                |

---


