# **Text Utilities**

✅ **I want to have**: A **clean, sorted list of authors associated with MIT-licensed files**, to post as a comment in the issue or use to update metadata.

### **1. `sort`**

* Rearranges lines in a file (ascending or descending).
* Can sort by **specific fields**.
* Examples:

```bash
sort codemeta.json                   # Sort lines alphabetically
sort -r codemeta.json                # Sort in reverse order
sort -k 3 codemeta.csv               # Sort by 3rd column (field)
sort -u codemeta.json                # Sort and remove duplicates
```

### **2. `uniq`**

* Removes **duplicate consecutive lines**.
* Often used after `sort` to clean up data.

```bash
sort codemeta.json | uniq > cleaned.json
uniq -c codemeta.json                # Count duplicate lines
```

### **3. `paste`**

* Combines lines from multiple files **horizontally** (side by side).
* Example:

```bash
paste file1.txt file2.txt            # Combine line 1 from both, line 2 from both, etc.
paste -d, file1.csv file2.csv        # Use comma as delimiter
```

### **4. `join`**

* Combines two files **based on a common field**.
* Example: Merge contributors with commits:

```bash
join contributors.txt commits.txt
```

### **5. `split`**

* Splits large files into smaller chunks.
* Example:

```bash
split codemeta.json codemeta_part_  # Creates codemeta_part_aa, codemeta_part_ab, etc.
```

### **6. `grep`**

* Searches for **patterns in files**.
* Examples:

```bash
grep "license" codemeta.json             # Lines containing "license"
grep -v "deprecated" codemeta.json       # Lines NOT containing "deprecated"
grep -C 3 "author" codemeta.json         # Show 3 lines before and after "author"
```

### **7. `strings`**

* Extracts **printable text** from binaries.
* Example:

```bash
strings codebase_file | grep "GPL"
```

---

# **Practical Example: Using These Tools for a CodeMeta Issue**

Suppose there is an issue on [CodeMeta GitHub](https://github.com/codemeta/codemeta.github.io/issues) asking you to **find all files mentioning "MIT License" and generate a list of authors**.

You could do this step by step:

1. **Search for MIT License references**:

```bash
grep -r "MIT License" codemeta.github.io/
```

2. **Sort and remove duplicates** (if multiple references appear in different files):

```bash
grep -r "MIT License" codemeta.github.io/ | sort | uniq
```

3. **Extract authors from those files** (assuming JSON format):

```bash
grep -r "MIT License" codemeta.github.io/ | awk -F'"' '/"author"/ {print $4}' | sort -u
```

4. **Optional: Combine results into a file to submit as a comment for the issue**:

```bash
grep -r "MIT License" codemeta.github.io/ | awk -F'"' '/"author"/ {print $4}' | sort -u > mit_authors.txt
```

5. **If files are large, split into chunks for easier processing**:

```bash
split mit_authors.txt authors_chunk_
```

---

