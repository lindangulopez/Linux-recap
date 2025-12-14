# Creating and Understanding a Bash Script

## Summary

You learned how to:
✔ Create and run scripts
✔ Use arguments and `shift`
✔ Debug scripts
✔ Write conditionals, loops, and functions
✔ Build a real utility

## 1. Creating Your First Script

A **script** is simply a text file that contains commands executed by a shell.

### Step 1: Create a file

```bash
nano myscript.sh
```

(or use `vim`, `code`, or any editor you like)

### Step 2: Add the shebang

```bash
#!/bin/bash
```

👉 This line tells the system **which shell** should run the script.

---

## 2. Writing Simple Commands

Add the following lines:

```bash
#!/bin/bash
echo "Hello, world!"
```

To **save and exit in nano**, do this:

1. **Save (write out) the file**

   * Press **`Ctrl + O`**
   * Nano will ask for the filename → just press **`Enter`** to confirm

2. **Exit nano**

   * Press **`Ctrl + X`**

### Explanation

* `echo` prints text to the terminal
* Everything inside quotes is printed as-is

---

## 3. Making the Script Executable

By default, scripts are **not executable**.

```bash
chmod +x myscript.sh
```

Run it:

```bash
./myscript.sh
```

---

## 4. Script Name and Arguments

Create a new script:

```bash
nano foobar.sh
```

```bash
#!/bin/bash

echo "0 = $0"
echo "1 = $1"
echo "* = $*"
```

Run it with arguments:

```bash
./foobar.sh a b c d e
```

### Output

```text
0 = ./foobar.sh
1 = a
* = a b c d e
```

### Explanation

* `$0` → script name
* `$1` → first argument
* `$*` → all arguments

---

## 5. Shifting Arguments (`shift`)

Inside a script:

```bash
shift 2
```

This removes the first **two arguments**, shifting others left.

Example:

```bash
echo "Before shift: $*"
shift 1
echo "After shift:  $*"
```

---

## 6. Including Another Script

You can reuse code from another script.

```bash
source helpers.sh
```

or

```bash
. helpers.sh
```

👉 Both run the included script **in the same shell**.

---

## 7. Debugging a Script

### Enable debugging inside a script

```bash
set -x   # show executed commands
set -e   # exit on error
set -u   # error on unset variables
```

Disable debugging:

```bash
set +x
```

### Check syntax only

```bash
bash -n myscript.sh
```

---

## 8. Using Conditions (`if`)

Basic structure:

```bash
if [[ condition ]]; then
    commands
else
    commands
fi
```

Example:

```bash
if [[ -f "/etc/passwd" ]]; then
    echo "File exists"
else
    echo "File not found"
fi
```

### Why `[[ ... ]]`?

It is safer than `[ ... ]` and avoids many syntax errors.

---

## 9. File Tests (Common)

| Test      | Meaning      |
| --------- | ------------ |
| `-e file` | exists       |
| `-d file` | directory    |
| `-f file` | regular file |
| `-r file` | readable     |
| `-w file` | writable     |
| `-x file` | executable   |

---

## 10. String Comparisons

```bash
NAME="linux"

if [[ "$NAME" == "linux" ]]; then
    echo "Correct password"
fi
```

Common operators:

* `==` equal
* `!=` not equal
* `-z` empty string
* `-n` not empty

---

## 11. Arithmetic Comparisons

```bash
COUNT=5

if [[ $COUNT -gt 3 ]]; then
    echo "Greater than 3"
fi
```

Operators:
`-eq -ne -gt -ge -lt -le`

---

## 12. Logical Operators (`&&` and `||`)

```bash
make && make install
```

* `&&` → run next command only if previous succeeded
* `||` → run next command only if previous failed

Example:

```bash
[[ -f config.conf ]] || echo "default" > config.conf
```

---

## 13. Case Statement

```bash
echo "Enter y or n:"
read answer

case "$answer" in
    y|Y) echo "Yes selected" ;;
    n|N) echo "No selected" ;;
    *)   echo "Invalid choice" ;;
esac
```

---

## 14. Loops

### `for` Loop

```bash
for file in *.txt; do
    echo "File: $file"
done
```

### `while` Loop

```bash
COUNT=1

while [[ $COUNT -le 3 ]]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

### `until` Loop

```bash
COUNT=1

until [[ $COUNT -gt 3 ]]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

---

## 15. Functions

```bash
my_function() {
    echo "Hello from function"
}

my_function
```

Functions help **reuse code** and keep scripts clean.

---

## 16. Practical Example: Counting Processes

Create `nproc`:

```bash
#!/bin/sh

echo "You are running $(( $(ps | wc -l) - 1 )) processes"
```

Make executable and run:

```bash
chmod +x nproc
./nproc
```

---

