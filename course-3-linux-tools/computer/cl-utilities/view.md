# **View file**

* **`cat`/`tac`** → View and combine files.
* **`echo`** → Display text or variables; write to files.
* **`head`** → See the beginning of a file.
* **`tail`** → See the end of a file; monitor logs in real-time.
* **`z`-commands** → Work with compressed files without decompressing manually.

---

## **1. `cat` (concatenate)**

* **Purpose:** View file contents, combine multiple files, or create new files.
* **Usage Examples:**

  ```bash
  cat file1 file2           # Display files one after another
  cat file1 file2 > newfile # Combine files into a new file
  cat file >> existingfile  # Append to an existing file
  cat > file                # Create a new file interactively
  tac file                  # Display file lines in reverse order
  ```
* **Notes:** Press **Ctrl-D** to end interactive input. Can also use `<<EOF` to create files with a marker for the end.

---

## **2. `echo`**

* **Purpose:** Display text or environment variable values; write strings to files.
* **Usage Examples:**

  ```bash
  echo "Hello world"             # Print to terminal
  echo "Hello" > newfile         # Write string to a new file
  echo "Hello" >> existingfile   # Append string to an existing file
  echo $USERNAME                 # Display the value of an environment variable
  echo -e "Line1\nLine2\tTab"   # Use special characters (\n newline, \t tab)
  ```

---

## **3. `head`**

* **Purpose:** Display the first few lines of a file (default 10).
* **Usage Examples:**

  ```bash
  head file.txt          # First 10 lines
  head -n 5 file.txt     # First 5 lines
  head -5 file.txt       # Shortcut for first 5 lines
  ```

---

## **4. `tail`**

* **Purpose:** Display the last few lines of a file (default 10). Useful for logs.
* **Usage Examples:**

  ```bash
  tail file.txt          # Last 10 lines
  tail -n 15 file.log    # Last 15 lines
  tail -f file.log       # Monitor file in real-time as new lines are added
  tail -15 file.log      # Shortcut for last 15 lines
  ```

---

## **5. Viewing Compressed Files (`z`-utilities)**

* **Purpose:** Work with gzip-compressed files directly.
* **Common Commands:**

  ```bash
  zcat file.gz        # View compressed file
  zless file.gz       # Page through compressed file
  zmore file.gz       # Another pager for compressed file
  zgrep pattern file.gz # Search inside compressed file
  zdiff file1.gz file2.gz # Compare two compressed files
  ```
* **Notes:** Works with gzip by default. Equivalent tools exist for other compression formats, e.g., `bzcat`/`bzless` (bzip2), `xzcat`/`xzless` (xz).



Do you want me to do that?
