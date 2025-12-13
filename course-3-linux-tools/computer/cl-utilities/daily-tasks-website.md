# File and Directory Management Tools

✅ **Key Takeaway:**
These commands form the foundation of Linux file management. Once mastered, you can efficiently navigate, organize, and manipulate files without a graphical interface, which is crucial for development, scripting, and server administration.

Linux provides a set of **command-line utilities** to view, create, delete, and manipulate files and directories. These are essential for daily tasks and scripting.

| Command | Purpose                                 |
| ------- | --------------------------------------- |
| `ls`    | List files and directories              |
| `cat`   | Display the contents of files           |
| `rm`    | Remove files                            |
| `mv`    | Rename or move files                    |
| `mkdir` | Create directories                      |
| `rmdir` | Remove empty directories                |
| `file`  | Identify file types                     |
| `ln`    | Create symbolic or hard links           |
| `tail`  | View the end of a file                  |
| `head`  | View the beginning of a file            |
| `less`  | View a file one page at a time          |
| `more`  | Another pager for viewing files         |
| `touch` | Create empty files or update timestamps |
| `wc`    | Count lines, words, and bytes in a file |

---

### Real-World Example

Suppose you are a developer working on a **website project**:

1. **List project files**:

```bash
ls -l ~/website
```

2. **Create a new directory for images**:

```bash
mkdir ~/website/images
```

3. **Add a new HTML file**:

```bash
touch ~/website/index.html
```

4. **View the first few lines of your HTML file**:

```bash
head ~/website/index.html
```

5. **Check the file type**:

```bash
file ~/website/index.html
```

6. **Rename the HTML file**:

```bash
mv ~/website/index.html ~/website/home.html
```

7. **Count the words in the file**:

```bash
wc ~/website/home.html
```

8. **Delete a temporary file**:

```bash
rm ~/website/temp.txt
```

## Working with the CodeMeta GitHub Pages Project – Practical Linux Commands

These Linux commands allow you to:

* Navigate the project
* Organize content in directories
* Quickly inspect, edit, and maintain files
* Keep your local repository ready for commits and pushes to GitHub

---
Assume you have cloned the repository locally:

```bash
git clone https://github.com/codemeta/codemeta.github.io.git
cd codemeta.github.io
```

---

### 1. **List Files**

See the project structure:

```bash
ls -l
```

* Shows all files like `index.html`, `_config.yml`, directories like `_posts`, `_layouts`, etc.

---

### 2. **Create a New Directory**

Suppose you want a directory for new assets:

```bash
mkdir assets
```

* This creates `codemeta.github.io/assets/` for images, CSS, or JS files.

---

### 3. **Add or Edit Files**

* **Create a new HTML or Markdown file**:

```bash
touch about.md
```

* **View the beginning of a file**:

```bash
head index.html
```

* **View the end of a file**:

```bash
tail _config.yml
```

* **View a file one screen at a time**:

```bash
less _posts/2025-01-01-welcome.md
```

---

### 4. **Rename or Move Files**

Suppose you want to rename `about.md` to `about_us.md`:

```bash
mv about.md about_us.md
```

---

### 5. **Check File Types**

```bash
file about_us.md
```

* Confirms it is a Markdown text file.

---

### 6. **Create Links**

* Create a symbolic link to a frequently used file:

```bash
ln -s _config.yml config-link.yml
```

---

### 7. **Update File Timestamps**

```bash
touch new-post.md
```

* Creates an empty file or updates modification time if it already exists.

---

### 8. **Count Lines, Words, Bytes**

```bash
wc _posts/2025-01-01-welcome.md
```

* Useful to see file size and content quickly.

---

### 9. **Remove Unneeded Files**

```bash
rm old-post.md
```

---

---



## **Linux & Git Cheat Sheet for CodeMeta Website Contributions**

This cheat sheet combines **Linux file commands + editing + Git** into a single workflow for real-world contributions to **CodeMeta**.

---

I can also make a **visual flow diagram** showing the **exact sequence of commands from forking the repo to opening a pull request**, which is handy for beginners.

Do you want me to do that?

### **1. Navigate & Explore the Repository**

```bash
cd ~/projects/codemeta.github.io     # Enter your local repo
ls -l                                # List files with details
tree                                  # Show directory tree (if installed)
file _config.yml                      # Check file type
```

---

### **2. View File Contents**

```bash
cat _posts/2025-12-13-example.md     # Print entire file
less _config.yml                      # Scroll through long files
more _posts/*.md                      # Another pager option
head _posts/2025-12-13-example.md    # View first 10 lines
tail _posts/2025-12-13-example.md    # View last 10 lines
```

---

### **3. Create, Rename, and Remove Files**

```bash
touch _posts/2025-12-13-new-post.md  # Create a new Markdown file
mv draft.md _posts/2025-12-13-final.md  # Rename/move a file
rm _posts/2025-01-01-old-post.md     # Delete a file
```

---

### **4. Create and Remove Directories**

```bash
mkdir assets                          # Create a new folder
rmdir old-assets                      # Remove an empty folder
```

---

### **5. Edit Files**

```bash
nano _posts/2025-12-13-new-post.md    # Open file in Nano
vim _config.yml                        # Open file in Vim
```

---

### **6. Link Files**

```bash
ln -s _config.yml _config-test.yml    # Create symbolic link
```

---

### **7. Analyze Files**

```bash
wc _posts/2025-12-13-new-post.md      # Count lines, words, bytes
```

---

### **8. Git Workflow**

#### **Check status and branches**

```bash
git status                             # See changes
git branch                             # Show local branches
git checkout -b issue-5-fix           # Create branch for a GitHub issue
```

#### **Stage & Commit Changes**

```bash
git add _posts/2025-12-13-new-post.md  # Stage file
git commit -m "Fix issue #5: add new post"  # Commit with message
```

#### **Push Branch & Open Pull Request**

```bash
git push origin issue-5-fix             # Push branch to your fork
# Then go to GitHub and open PR linking to the issue
```

#### **Update Fork**

```bash
git fetch upstream                     # Get latest from main repository
git checkout main
git merge upstream/main                 # Merge updates into local main
```

---

### **9. Quick Tips**

* Always work on a **separate branch** for each issue.
* Preview Markdown posts using `less` or a browser for GitHub Pages.
* Use `tail -f` on logs if testing Jekyll locally:

```bash
bundle exec jekyll serve
tail -f _site/logs/development.log
```

* Use `chmod 644` for posts if permissions are an issue.

---


