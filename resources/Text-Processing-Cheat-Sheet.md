# **Linux Text-Processing Cheat Sheet for CodeMeta**

This cheat sheet covers **file viewing, searching, editing, and parsing** utilities that are essential for inspecting CodeMeta JSON files, metadata, and documentation.

---

## **1. Viewing and Combining Files**

### `cat` – Concatenate and display files

```bash
# View a file
cat codemeta.github.io/codemeta.json

# Concatenate multiple files
cat codemeta.github.io/*.json > all_metadata.json

# Append output to existing file
cat new_file.json >> all_metadata.json
```

### `tac` – Display lines in reverse order

```bash
tac codemeta.github.io/codemeta.json
```

### `head` / `tail` – View first or last lines

```bash
head -n 10 codemeta.github.io/codemeta.json   # First 10 lines
tail -n 10 codemeta.github.io/codemeta.json   # Last 10 lines
tail -f codemeta.github.io/codemeta.json      # Watch growing files
```

---

## **2. Searching Files**

### `grep` – Pattern matching

```bash
# Search for "license" field in all JSON files
grep '"license"' codemeta.github.io/*.json

# Case-insensitive search for "author"
grep -i '"author"' codemeta.github.io/*.json

# Search with line numbers
grep -n '"deprecated": true' codemeta.github.io/*.json

# Search for lines not containing "MIT"
grep -v '"MIT"' codemeta.github.io/*.json
```

---

### `strings` – Extract human-readable text (from binaries)

```bash
strings some_binary_file | grep "metadata"
```

---

## **3. Editing Files**

### `sed` – Stream editor

```bash
# Replace "old_license" with "new_license" in JSON files (output to terminal)
sed 's/old_license/new_license/g' codemeta.github.io/codemeta.json

# Save changes to a new file
sed 's/old_license/new_license/g' codemeta.github.io/codemeta.json > codemeta_new.json

# In-place replacement (use with caution!)
sed -i 's/old_license/new_license/g' codemeta.github.io/codemeta.json
```

**Practical CodeMeta Example:**

```bash
# Replace deprecated "author" field values
sed -i 's/"author": "Unknown"/"author": "TBD"/g' codemeta.github.io/*.json
```

---

### `awk` – Column/field processing

```bash
# Print entire file
awk '{print $0}' codemeta.github.io/codemeta.json

# Extract the value of the 4th field in a colon-delimited file
awk -F: '{print $4}' /etc/passwd

# Extract "author" field values from JSON files
awk -F'"' '/"author"/ {print $4}' codemeta.github.io/*.json

# Extract "license" field values, then sort uniquely
awk -F'"' '/"license"/ {print $4}' codemeta.github.io/*.json | sort -u
```

---

### `cut` – Extract specific columns

```bash
# Extract 3rd column using space as delimiter
ls -l | cut -d" " -f3

# For CSV or tab-delimited CodeMeta data
cut -d',' -f2 codemeta.csv
```

---

## **4. Sorting and Deduplication**

### `sort` – Sort lines

```bash
# Sort JSON filenames alphabetically
ls codemeta.github.io/*.json | sort

# Sort descending
ls codemeta.github.io/*.json | sort -r

# Sort by a specific field (e.g., 3rd field in CSV)
sort -k 3 codemeta.csv
```

### `uniq` – Remove duplicate consecutive lines

```bash
# Remove duplicates from sorted list
awk -F'"' '/"license"/ {print $4}' codemeta.github.io/*.json | sort | uniq

# Count occurrences
awk -F'"' '/"license"/ {print $4}' codemeta.github.io/*.json | sort | uniq -c
```

---

## **5. Character Transformation**

### `tr` – Translate or delete characters

```bash
# Convert lowercase to uppercase
cat codemeta.github.io/codemeta.json | tr a-z A-Z

# Replace braces with parentheses
tr '{}' '()' < input.json > output.json

# Squeeze multiple spaces into one
echo "a   b  c" | tr -s ' '

# Delete a specific character
echo "test data" | tr -d 't'
```

---

## **6. Stream Duplication and Logging**

### `tee` – Save output while displaying it

```bash
# Save directory listing while viewing
ls -l codemeta.github.io | tee codemeta_dir.txt

# Log results of a validation script
python validate_codemeta.py | tee validation_log.txt
```

---

## **7. Counting Lines, Words, and Characters**

### `wc` – Word/line/byte count

```bash
# Count lines, words, and bytes
wc codemeta.github.io/*.json

# Count only lines
wc -l codemeta.github.io/*.json

# Count only words
wc -w codemeta.github.io/*.json
```

---

## **8. File Splitting and Joining**

### `paste` – Combine lines from files

```bash
paste file1.txt file2.txt
paste -d',' file1.txt file2.txt
```

### `join` – Combine files on a common field

```bash
join file1.csv file2.csv
```

### `split` – Split large files into smaller chunks

```bash
split large_metadata.json chunk_
```

---

## **Practical Use Case: Handling a CodeMeta Issue**

Suppose a GitHub issue asks:
**"List all unique licenses and authors in CodeMeta JSON files, log them, and count occurrences."**

```bash
# Step 1: Extract licenses and authors
awk -F'"' '/"license"/ {print $4}' codemeta.github.io/*.json | sort -u > licenses.txt
awk -F'"' '/"author"/ {print $4}' codemeta.github.io/*.json | sort -u > authors.txt

# Step 2: Count occurrences
awk -F'"' '/"license"/ {print $4}' codemeta.github.io/*.json | sort | uniq -c > license_counts.txt

# Step 3: View and log output simultaneously
cat licenses.txt | tee licenses_report.txt
cat authors.txt | tee authors_report.txt

# Step 4: Verify file statistics
wc -l licenses.txt authors.txt
```

✅ Now you have **ready-to-analyze data** that can be reported directly in the GitHub issue.

---

