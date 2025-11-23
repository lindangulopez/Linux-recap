# Using Git for Distributed Development — Summary & Cheat Sheet

---

## **Summary**

This course teaches how to use Git effectively in a distributed, open-source development environment. You’ll learn to set up Git, perform basic and advanced Git operations, and collaborate with other developers on shared repositories. Key topics include branching and merging strategies, remote repository workflows, conflict resolution, and best practices for contributing to open-source projects. By the end, you should feel comfortable using Git in real-world team settings, understanding how to work with upstream/downstream, and managing code reviews and patches.

---

## **Module-by-Module Notes**

**Module 1: Git and Git Installation**

* Introduction to Git and why it’s designed for distributed development
* Installing Git and configuring your local environment (username, email)
* Git architecture: how commits, branches, and objects are stored
* Setting up a repository: creating new repos, cloning existing ones
* Basic Git commands: `git init`, `git clone`, `git add`, `git commit`, `git status`

---

**Module 2: Working with Git**

* Understanding and using the staging area (index)
* Committing changes, viewing history, exploring differences (`git diff`, `git log`)
* Branching: creating, switching, deleting branches
* Merging strategies: fast-forward, three-way merge, resolving conflicts
* Rebasing for cleaner history
* Using remote repositories: `git remote`, `git fetch`, `git pull`, `git push`

---

**Module 3: Working with Other Developers**

* Collaboration workflows for distributed teams
* Managing shared repositories and contribution models (forks, pull requests)
* Code review and patch management
* Handling conflicts and concurrent contributions
* Best practices: commit messages, maintainable branching, clean histories, submitting high-quality diffs

---

## **Cheat Sheet — Using Git for Distributed Development**

### Setup & Configuration

* `git config --global user.name "Your Name"`
* `git config --global user.email "you@example.com"`
* Initialize repo: `git init`
* Clone repo: `git clone <url>`

### Basic Workflow

* Stage changes: `git add <file>`
* Commit: `git commit -m "Message"`
* Check status: `git status`
* View differences: `git diff`

### Branching & Merging

* Create branch: `git branch <branch>`
* Switch branch: `git checkout <branch>`
* Delete branch: `git branch -d <branch>`
* Merge: `git merge <branch>`
* Rebase: `git rebase <branch>`

### Working Remotely

* List remotes: `git remote -v`
* Fetch: `git fetch origin`
* Pull: `git pull origin <branch>`
* Push: `git push origin <branch>`

### History & Review

* Show log: `git log --oneline --graph --decorate`
* Detailed log: `git log -p`
* View commit: `git show <commit-hash>`

### Collaboration

* Create patch: `git format-patch`
* Apply patch: `git am <patch-file>`
* Resolve conflicts: edit → `git add` → `git commit`
* Use meaningful commit messages

### Best Practices

* Commit small, logical units
* Write clear commit messages
* Keep branch structure clean
* Frequently pull from upstream
* Use code reviews or patches for collaboration
