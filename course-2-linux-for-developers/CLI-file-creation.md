# **Creating Files from the Command Line**

### **1. Using `echo`**

* `echo` prints text to the terminal.
* Redirect output to a file using `>` (create/overwrite) or `>>` (append).
* Example:

```bash
echo line one > myfile
echo line two >> myfile
echo line three >> myfile
```

* Resulting file `myfile` contains:

```
line one
line two
line three
```

* Often used in scripts for simple file creation.

### **2. Using `cat` with a Here-Document**

* `cat` can read multiple lines from standard input and redirect to a file.
* Example:

```bash
cat << EOF > myfile
line one
line two
line three
EOF
```

* Produces the same content as above.

**Key Point:** Both methods allow creating and filling a file directly from the command line without opening an editor.

---

If you want, I can also make a **one-line cheat-sheet version** for `echo` and `cat`. Do you want me to do that?
