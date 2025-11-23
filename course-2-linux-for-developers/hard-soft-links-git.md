# **Hard vs Soft Links & Git Workflow Tutorial**

This tutorial covers **how to create links, inspect them, and manage them in Git** on your Ubuntu VM, with visual and practical guidance.

### **1. Hard Links**

* Two file names pointing to the **same inode**.
* Editing either updates the **same file content**.
* Deleting one name does **not** delete the content if another link exists.
* Limitation: cannot span different filesystems.

**Git Consideration:**

* Git **tracks file content**, not inodes.
* Adding a hard-linked file to a repo makes Git treat it as a **separate file**.
* Cloning or checkout creates new files, not hard links.

**Example:**

```bash
# Create a hard link
ln file1 file2
git add file2
git commit -m "Add hard linked file"
```

* Git stores `file2` as a normal file; internal deduplication may occur.

---

### **2. Soft (Symbolic) Links**

* A soft link is a **pointer to a file or directory**.
* Can link across filesystems.
* Can become **dangling** if the target is deleted.

**Git Consideration:**

* Git tracks the symlink itself, not the file content.
* Cloning a repo recreates the symlink pointing to the same relative path.
* Useful for shared files or directories without duplicating them.

**Example:**

```bash
ln -s ../shared/config.yaml config.yaml
git add config.yaml
git commit -m "Add symlink to shared config"
```

* Anyone cloning gets the **symlink**, not the file.

---

### **3. Visual Diagram**

```
[Hard Link]
file1 --------+
              |
file2 --------+----> [inode 84] ---> [file data]
Editing either file changes the same data

[Soft Link]
file1 ---> [inode 84] ---> [file data]
file2 ---> (pointer) ----> file1
Deleting file1 breaks file2 (dangling)
```

---

### **4. Ubuntu VM Git Workflow Example**

1. **Create a symlink to a shared folder:**

```bash
mkdir -p ~/projects/myrepo/shared
echo "config=1" > ~/projects/myrepo/shared/config.yaml
cd ~/projects/myrepo
ln -s shared/config.yaml config.yaml
```

2. **Add to Git:**

```bash
git add config.yaml
git commit -m "Add symlink to shared config"
git push
```

3. **Clone repo elsewhere:**

```bash
git clone ~/projects/myrepo ~/projects/myrepo_copy
ls -l ~/projects/myrepo_copy
# Symlink preserved
```

4. **Edit target file:**

```bash
echo "config=2" > ~/projects/myrepo/shared/config.yaml
cat config.yaml   # Shows updated content through symlink
```

---

### **5. Key Takeaways**

| Feature               | Hard Link | Soft Link / Symlink     | Git Behavior                     |
| --------------------- | --------- | ----------------------- | -------------------------------- |
| Points to inode       | Yes       | No, points to file name | Hard: normal file                |
| Can cross filesystems | No        | Yes                     | Symlink tracked as link          |
| Reflects changes      | Yes       | Yes (target)            | Symlink content not tracked      |
| Dangling on deletion  | No        | Yes                     | Symlink broken if target missing |

---


