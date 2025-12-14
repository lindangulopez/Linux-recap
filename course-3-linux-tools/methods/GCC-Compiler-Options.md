# **GCC Compiler Options**

* **Output Formats:** Default is ELF; older a.out rarely used.
* **Compiler Path Options:** `-I dir`, `-L dir`, `-lfoo`
* **Preprocessor Options:** `-M`, `-H`, `-E`, `-D def`, `-U def`, `-d`
* **Warning Options:** `-v`, `-pedantic`, `-w`, `-Wall`
* **Debugging & Profiling:** `-g`, `-pg`
* **Input/Output Options:** `-c`, `-o file`, `-x lang`
* **Control & Optimization:** `-ansi`, `-pipe`, `-static`, `-O[0-3]`, `-Os`
* **Recommended:** `-O2 -Wall -pedantic` (avoid `-pedantic` for Linux kernel code).

---

### **Static Libraries (.a)**

* Contain full copies of routines.
* Tools: `ar`, `ranlib`, `nm`
* Useful for early startup programs or self-contained applications.

---

### **Shared Libraries (.so)**

* Single copy can be used by multiple programs → saves memory.
* Versioning: `libname.so.x.y` (actual), `libname.so.x` (soname), `libname.so` (link-time).
* Steps to create: `-fPIC` → `-shared -Wl,-soname` → symbolic links.
* Tools: `ldd`, `ldconfig`, `LD_LIBRARY_PATH`
* Default search paths: `/usr/lib`, `/lib`
* Link with `gcc -o foo foo.c -L/mypath/lib -lfoolib`

---

### **Stripping and Debugging**

* `strip foobar` → remove symbols, reduce size (don’t use on kernel/modules)
* `LD_DEBUG` → environment variable for library and symbol debugging

---

### **GDB Debugger**

* Supports C, C++, Fortran, Ada, multi-threaded programs
* Features: breakpoints, stepping, inspecting variables
* Graphical front-ends: `ddd`, Eclipse IDE

---

### **Shared Libraries Lab (Exercise)**

1. **Check libraries used by vim:**

   ```bash
   $ ldd /usr/bin/vim
   ```

   → Shows full library names and filesystem locations.

2. **Inspect actual memory segments of vim:**

   * Start vim in background:

     ```bash
     $ vim &
     [1] 25716   # PID is 25716
     ```
   * Use either:

     ```bash
     $ cat /proc/25716/maps
     ```

     or

     ```bash
     $ pmap -d 25716
     ```

3. **Try the same for vi** (usually `/bin/vi`) to see differences.

---


