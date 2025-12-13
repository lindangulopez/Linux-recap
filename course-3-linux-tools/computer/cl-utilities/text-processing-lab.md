# **Linux Text-Processing Labs: Summary**

### **1. Parsing Files with `awk` + `sort` + `uniq`**

* Goal: Extract fields from column-based files and produce unique lists.
* Example: List unique shells in `/etc/passwd`:

```bash
# Field 7 in /etc/passwd holds the shell
awk -F: '{print $7}' /etc/passwd | sort -u
# Or using uniq
awk -F: '{print $7}' /etc/passwd | sort | uniq
```

* Output:

```
/bin/bash
/sbin/nologin
/sbin/shutdown
```

**Use for CodeMeta:** Extract unique authors, licenses, or file types from JSON metadata:

```bash
awk -F'"' '/"author"/ {print $4}' codemeta.github.io/*.json | sort -u > unique_authors.txt
```

---

### **2. Using `grep`**

* Goal: Search files for patterns, with options for line numbers, context, and inverse matching.
* Examples:

```bash
grep your-username /etc/passwd          # Search for your username
grep ftp /etc/services                   # Find lines with 'ftp'
grep ftp /etc/services | grep tcp        # Only those using tcp
grep -n ftp /etc/services | grep -v tcp  # Exclude tcp lines, print line numbers
grep ^ts /etc/services                   # Lines starting with 'ts'
grep st$ /etc/services                   # Lines ending with 'st'
```

**Use for CodeMeta:** Search JSON/markdown files for specific properties or patterns:

```bash
grep '"license"' codemeta.github.io/*.json
grep -n '"deprecated": true' codemeta.github.io/*.json
```

---

### **3. Using `tee`**

* Goal: Save command output while still viewing it on the terminal.
* Example:

```bash
ls -l /etc | tee etc_listing.txt
```

**Use for CodeMeta:** Log output of validation or formatting scripts:

```bash
python validate_codemeta.py | tee validation_log.txt
```

---

### **4. Using `wc` (word count)**

* Goal: Count lines, words, and characters in files.
* Example: Count `.log` files in `/var/log`:

```bash
wc /var/log/*.log
wc -l /var/log/*.log  # Only lines
wc -w /var/log/*.log  # Only words
```

**Use for CodeMeta:** Count lines in JSON files or markdown documentation:

```bash
wc -l codemeta.github.io/*.json
wc -w codemeta.github.io/*.md
```

---

# **Practical Workflow for a CodeMeta Issue**

Suppose an issue asks you to **list all unique licenses used in project JSON files**:

1. **Extract license field using `awk`**:

```bash
awk -F'"' '/"license"/ {print $4}' codemeta.github.io/*.json
```

2. **Sort and remove duplicates**:

```bash
awk -F'"' '/"license"/ {print $4}' codemeta.github.io/*.json | sort -u > licenses.txt
```

3. **Count total entries**:

```bash
wc -l licenses.txt
```

4. **View and save the output simultaneously**:

```bash
cat licenses.txt | tee licenses_report.txt
```


