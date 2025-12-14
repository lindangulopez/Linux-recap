# **Step 1: Install RPM Build Tools on Ubuntu**

Even on Ubuntu, you can build RPM packages from source by:

1. Installing RPM build tools
2. Setting up the RPM build tree
3. Downloading or moving a `.src.rpm` to `SRPMS`
4. Running `rpmbuild --rebuild`
5. Collecting the binaries from `RPMS/`

Here’s a demonstration of how the process of building a binary RPM from a source RPM works, adapted for **Ubuntu 24**, which normally uses DEB packages but can still build RPMs if you install the necessary tools:

Ubuntu does not include RPM tools by default, so install them:

```bash
sudo apt update
sudo apt install rpm build-essential rpmdevtools wget
```

* `rpm` → for querying and managing RPMs
* `rpmdevtools` → provides helpers like `rpmdev-setuptree`
* `build-essential` → compilers needed for building

---

### **Step 2: Set Up RPM Build Environment**

```bash
rpmdev-setuptree
```

* This creates the standard RPM build directories in your home folder:

```
~/rpmbuild/
├── BUILD
├── RPMS
├── SOURCES
├── SPECS
└── SRPMS
```

---

### **Step 3: Download a Source RPM**

Since `yumdownloader` is not available on Ubuntu, we can use `wget` to fetch a source RPM. For example:

```bash
wget http://mirror.centos.org/centos/8/BaseOS/source/SRPMS/gzip-1.10-4.el8.src.rpm
```

* Save the `.src.rpm` file to a convenient location, e.g., `~/Downloads`.

---

### **Step 4: Rebuild the Binary RPM**

Move the source RPM to the `SRPMS` directory:

```bash
mv gzip-1.10-4.el8.src.rpm ~/rpmbuild/SRPMS/
```

Rebuild the binary RPM:

```bash
rpmbuild --rebuild ~/rpmbuild/SRPMS/gzip-1.10-4.el8.src.rpm
```

* This will compile the software and generate `.rpm` binaries in:

```
~/rpmbuild/RPMS/x86_64/  # or your architecture
```

---

### **Step 5: Optional: Customizing the Build**

You can modify the command with additional options:

```bash
rpmbuild --rebuild --define "_topdir $HOME/rpmbuild" ~/rpmbuild/SRPMS/gzip-1.10-4.el8.src.rpm
```

* `--define "_topdir ..."` → specify a custom RPM build root
* `--target x86_64` → build for a specific architecture
* `--clean` → clean build directories before building

---

### **Step 6: Notes on Common Mistakes**

* **Forgetting `--rebuild`:**

  * RPM will not correctly rebuild the source RPM. You may get errors or incomplete packages.
* Always use `--rebuild` when converting a source RPM into a binary RPM.

---

If you want, I can also provide a **step-by-step graphical diagram showing the flow from source RPM → rpmbuild → binary RPM**, which makes this process much easier to understand visually. Do you want me to do that?
