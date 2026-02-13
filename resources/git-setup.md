# log your **Git username** and **email address**

You’ll need to configure them in Git: 

### 1. Install Git

First, make sure Git is installed by running:

```bash
sudo apt update
sudo apt install git
```

### 2. Check if Git is installed

Once Git is installed, check its location by running:

```bash
which git
```

This should give you a path to where Git is installed, such as `/usr/bin/git`.

### 3. Verify Git installation

To confirm that Git is installed and working, you can also check the version:

```bash
git --version
```

If Git is properly installed, you should see the version number, like:

```bash
git version 2.x.x
```

### If Git is still not found:

* Ensure that `/usr/bin` or wherever Git is installed is included in your `$PATH` variable.
* You can check your `$PATH` by running `echo $PATH`.

Git uses this information to associate commits with your identity.


## HCommands to configure your **global** username and email:

### **Step 1: Set your Global Git Username**

The global username will be used for all repositories unless overridden locally in a specific repository.

```bash
git config --global user.name "Your Name"
```

### **Step 2: Set your Global Git Email**

Similarly, you can set your global email address:

```bash
git config --global user.email "your_email@example.com"
```

### **Step 3: Check Your Global Configuration**

To verify your global settings for username and email, you can run:

```bash
git config --global --list
```

This will show you your global configuration, including your username and email:

```bash
user.name=Your Name
user.email=your_email@example.com
```

### **Step 4: Configure Username and Email for a Specific Repository**

If you want to use a different username or email for a specific repository (e.g., if you use a different email for GitHub and GitLab), you can configure them locally for that repo.

1. **Navigate to the repository directory** (or clone the repo if you haven’t already).

2. Set the local username and email for this repository:

```bash
git config user.name "Another Name"
git config user.email "another_email@example.com"
```

This will override the global settings just for that specific repository.

### **Step 5: Verify Your Local Settings (if needed)**

You can check the settings for a specific repository by running:

```bash
git config --list
```

This will show both global and local settings (the local ones will take priority in that repo).

### **Recap of Key Commands:**

* **Global config for username**: `git config --global user.name "Your Name"`
* **Global config for email**: `git config --global user.email "your_email@example.com"`
* **Check global config**: `git config --global --list`
* **Set local username/email** (in a repo): `git config user.name "Another Name"` and `git config user.email "another_email@example.com"`

Let me know if you need help with any specific configurations!
