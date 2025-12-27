# Understanding the Commit Process
- When changes are made to files, a commit creates a commit object from the files in the index, which is then stored in the object store.
- New files lead to the creation of new blobs and directories, while unchanged objects are reused, keeping storage efficient.

Efficiency and Speed
- Git minimizes repository size and speeds up the commit process by comparing hexadecimal identifiers instead of examining blobs completely.
- If a directory's hash remains unchanged, it indicates that nothing in its subdirectories has changed.

Commit Structure and Bisection
- Commits are organized in a historical tree, allowing users to choose between many small commits or fewer large ones.
- Using the bisect tool helps identify when bugs or regressions were introduced, making it easier with smaller commits.

## Making commits in Git

Committing Changes
- You can commit changes to a specific file using the command: `$ git commit -s file1`.
- To commit all changes, you can use any of the following commands: `$ git commit -s`, `$ git commit ./ -s`, or `$ git commit -a -s`.

Understanding the Commit Process
- The command `git commit` creates a new commit object from the index and adds it to the commit chain.
- After committing, the `git diff` command will show no differences between the staged working directories and previously committed changes.

### Understanding Git Commits
- Each commit in Git is assigned a unique 160-bit hexadecimal hash value, which can be cumbersome to use.
- The `git log` command can be used to view the history of commits, but the long hash values can be impractical for referencing.

Creating and Using Tags
- Tags can be created to provide a simpler reference to commits, allowing users to avoid long hash strings.
- The `git tag` command can create a tag or an annotated tag, which is stored in the `.git/refs/tags` directory or as an object in the object store.

Reverting to a Tagged Commit
- To revert to a specific commit labeled by a tag, the `git checkout` command can be used with the tag name, making it easier to navigate through commit history.

### Customize the output of `git log`

Here are some common ways to do this:

1. **One-line Format:**
   ```bash
   git log --oneline
   ```
   - Displays each commit on a single line, showing the commit ID and message.

2. **Pretty Format:**
   ```bash
   git log --pretty=format:"%h - %an, %ar : %s"
   ```
   - This allows you to specify exactly what information to display. In this example:
     - `%h` is the abbreviated commit hash.
     - `%an` is the author name.
     - `%ar` is the time since the commit.
     - `%s` is the commit message.

3. **Graphical Representation:**
   ```bash
   git log --graph --oneline
   ```
   - This adds a graphical representation of the branch structure alongside the commit messages.

4. **Limiting the Number of Commits:**
   ```bash
   git log -n 5
   ```
   - Displays only the last 5 commits.

5. **Filtering by Author:**
   ```bash
   git log --author="Author Name"
   ```
   - Shows commits made by a specific author.

These options can be combined to create a customized view that suits your needs. For example:
```bash
git log --pretty=format:"%h - %an, %ar : %s" --graph -n 10
```
This command will show the last 10 commits in a graphical format with the specified details.

#### You can combine multiple `git log` options to create a more informative and tailored output. 

Here are some examples of how to do this:

1. **Graphical View with One-line Format:**
   ```bash
   git log --oneline --graph
   ```
   - This command displays a simple one-line summary of each commit along with a graphical representation of the branch structure.

2. **Custom Format with Limiting Commits:**
   ```bash
   git log -n 10 --pretty=format:"%h - %an, %ar : %s"
   ```
   - This shows the last 10 commits with a custom format that includes the abbreviated commit hash, author name, time since the commit, and the commit message.

3. **Filtering by Author with Graph:**
   ```bash
   git log --author="Author Name" --graph --oneline
   ```
   - This displays a graphical representation of commits made by a specific author in a concise one-line format.

4. **Combining Date Range and Custom Format:**
   ```bash
   git log --since="2 weeks ago" --until="1 week ago" --pretty=format:"%h - %an : %s"
   ```
   - This shows commits made within a specific date range with a custom format.

5. **Combining All Options:**
   ```bash
   git log --graph --oneline -n 5 --pretty=format:"%h - %an, %ar : %s"
   ```
   - This command combines a graphical view, limits the output to the last 5 commits, and uses a custom format for detailed information.

By combining these options, you can create a `git log` output that is both informative and easy to read, tailored to your specific needs.

## How to manage commits in Git

Particularly when you need to back out changes.

Reverting Commits
- Use the command `$ git revert commit_name` to create a new commit that reverses changes from a specified commit.
- Commits can be identified using various references like HEAD, hash numbers, or tag names.

Resetting Commits
- The command `$ git reset HEAD~2` can be used to remove the last two commits without altering the working directory.
- Different options like --soft, --mixed, and --hard modify the index and working directory differently when resetting.

Creating a New Branch
- If you need to keep work in progress while reverting the main branch, create a new branch using `$ git branch work` and reset the main branch with `$ git reset --hard HEAD~3`.
- This allows you to continue working on the new branch while restoring the main branch to a previous state.

### Using `git reset` in a project can help you manage your commit history effectively.

Here’s how you might use it:

1. **Undoing Recent Commits**:
   - If you realize that the last few commits contain mistakes or are not ready to be shared, you can use:
     ```bash
     git reset HEAD~2
     ```
   - This command removes the last two commits from the current branch but keeps your working directory unchanged. You can then make necessary changes before committing again.

2. **Changing Commit History**:
   - If you want to modify the last commit (e.g., to change the commit message), you can use:
     ```bash
     git reset --soft HEAD~1
     ```
   - This moves the HEAD back by one commit but keeps the changes staged, allowing you to amend the commit.

3. **Discarding Changes**:
   - If you want to completely discard the last commit and its changes, you can use:
     ```bash
     git reset --hard HEAD~1
     ```
   - This command will remove the last commit and any changes made in that commit from your working directory.

4. **Creating a New Branch**:
   - If you want to keep your work but reset the main branch, you can create a new branch:
     ```bash
     git branch work
     git reset --hard HEAD~3
     ```
   - This allows you to continue working on the new branch while resetting the main branch to a previous state.

Using `git reset` effectively helps maintain a clean and organized commit history in your project.

### Using `git reset` on a shared repository can lead to several issues

Particularly if other collaborators have already pulled the commits you are trying to reset. Here are some potential consequences:

1. **Loss of Work**:
   - If you use `git reset --hard`, you will permanently remove commits and changes from the history. If others have based their work on those commits, they may lose their changes or face difficulties integrating their work.

2. **Conflicts**:
   - When you reset commits and others have already pulled those commits, it can create conflicts when they try to push their changes. They may need to resolve these conflicts manually.

3. **Inconsistent History**:
   - Resetting commits alters the commit history. This can confuse collaborators who expect the history to remain consistent. They may see different commit histories when they pull from the repository.

4. **Need for Force Push**:
   - After a reset, you will likely need to use `git push --force` to update the remote repository. This can overwrite changes made by others, leading to further complications.

To avoid these issues, it's generally recommended to use `git revert` instead of `git reset` in shared repositories. `git revert` creates a new commit that undoes the changes, preserving the commit history and avoiding conflicts.

## Using `git revert` in a project

Is a safe way to undo changes made by previous commits without altering the commit history. Here’s how you might use it:

1. **Reverting a Specific Commit**:
   - If you want to undo the changes made by a specific commit, you can use:
     ```bash
     git revert commit_name
     ```
   - Replace `commit_name` with the commit hash or reference (like HEAD~1 for the last commit). This creates a new commit that reverses the changes of the specified commit.

2. **Reverting Multiple Commits**:
   - If you need to revert multiple commits, you can specify a range:
     ```bash
     git revert HEAD~3..HEAD
     ```
   - This command will revert the last three commits, creating new commits for each reverted change.

3. **Handling Conflicts**:
   - If the changes being reverted conflict with the current state of the code, Git will prompt you to resolve these conflicts. You will need to manually fix the conflicts and then stage the changes:
     ```bash
     git add .
     git revert --continue
     ```

4. **Pushing Changes**:
   - After successfully reverting the commits, you can push the changes to the remote repository:
     ```bash
     git push origin branch_name
     ```
   - This ensures that all collaborators see the new commit that undoes the previous changes.

Using `git revert` is a collaborative-friendly way to manage changes in a shared repository, as it maintains the commit history and allows others to see what changes were undone.
