# **Linux Text Processing Utilities**

---

✅ **I want to**: **Analyze, clean, and update project files** efficiently using these tools, and then report findings or submit fixes directly to a GitHub issue.



### **1. `tr` (translate)**

* Translates, deletes, or squeezes characters in text.
* Syntax: `$ tr [options] set1 [set2]`
* Examples:

```bash
cat city | tr a-z A-Z                 # Convert lowercase to uppercase
echo "test {example}" | tr '{}' '()' # Replace braces with parentheses
echo "text" | tr -d 't'               # Delete 't' characters
echo "123 abc" | tr -cd [:digit:]     # Keep only digits
tr -s '\n' ' ' < file.txt             # Join lines into a single line
```

---

### **2. `tee`**

* Sends command output to **both terminal and a file**.

```bash
ls -l | tee output.txt                 # Display and save directory listing
cat output.txt                          # View saved output
```

---

### **3. `wc` (word count)**

* Counts lines, words, and characters in a file.

```bash
wc filename                             # Count lines, words, bytes
wc -l filename                          # Only lines
wc -w filename                          # Only words
wc -c filename                          # Only bytes
```

---

### **4. `cut`**

* Extracts **specific columns** from column-based files.

```bash
ls -l | cut -d" " -f3                   # Display 3rd column (owner)
cut -d: -f1 /etc/passwd                 # Display first field of /etc/passwd
```

---

### **5. `sed` (stream editor)**

* Performs **substitutions and modifications** in files.
* Examples:

```bash
# Replace /sbin/nologin with /bin/bash, display output
sed s:/sbin/nologin:/bin/bash:g /etc/passwd

# Save output to new file
sed s:/sbin/nologin:/bin/bash:g /etc/passwd > passwd_new
```

---

# **Practical Use Case for CodeMeta GitHub Issues**

Suppose there’s an issue asking you to **normalize file formatting, extract authors, and clean text in JSON or markdown files** for the CodeMeta project.

1. **Convert all text to uppercase** (normalize case for tags):

```bash
cat codemeta.json | tr a-z A-Z > codemeta_upper.json
```

2. **Extract unique authors from JSON files**:

```bash
grep '"author"' codemeta.github.io/*.json | awk -F'"' '{print $4}' | sort -u > authors.txt
```

3. **Count lines and words in a file for metadata verification**:

```bash
wc codemeta.json
wc -l authors.txt
```

4. **Combine multiple metadata files** into one for analysis:

```bash
cat *.json | tr -d '\n' > combined_metadata.json
```

5. **Save and view logs simultaneously** (e.g., output of a script that checks licenses):

```bash
./check_licenses.sh | tee license_report.txt
```

6. **Edit strings in multiple files with `sed`** (e.g., replace deprecated fields):

```bash
sed -i 's/"oldField"/"newField"/g' codemeta.github.io/*.json
```


