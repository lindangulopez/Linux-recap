# Gerrit Overview for Codemeta & Software Heritage

The Codemeta project promotes structured code and metadata review to ensure software preservation quality. Even if a Gerrit server isn’t available for hands-on exercises, understanding the workflow is useful for effective collaboration.

Key Steps in Using Gerrit:

* Typical workflow: making a change, creating a review, reviewing the change, reworking the change, verifying the change, and submitting the change.
* Contributors are encouraged to follow a demo or walkthrough to familiarize themselves with the process.

---

## Gerrit Walkthrough Demo (Codemeta Example)

This demo imagines **Alice** and **Bob** contributing to the `Codemeta` repository in the context of Software Heritage.

### 1. Making the Change

* Alice clones the Codemeta repository:

```bash
git clone ssh://gerrithost:29418/Codemeta.git
```

* She sets up the commit-msg hook to generate a Change-Id for Gerrit:

```bash
scp -p -P 29418 gerrithost:hooks/commit-msg Codemeta/.git/hooks/
chmod u+x .git/hooks/commit-msg
```

* Alice edits the `codemeta.json` schema or code files and commits her changes.

---

### 2. Creating the Review

* Push changes to Gerrit for review:

```bash
git push origin HEAD:refs/for/main
```

* Gerrit automatically generates a review page.
* Alice can add reviewers (e.g., Bob), view diffs, and leave comments.

---

### 3. Reviewing the Change

* Bob receives a notification and opens the review in Gerrit.
* He can view changes, add inline comments, and vote:

  * `+2` Approved
  * `+1` Looks good, needs another approval
  * `0` No score
  * `-1` Needs improvement
  * `-2` Must not be submitted

---

### 4. Reworking the Change

* Alice addresses Bob’s feedback by amending her commit:

```bash
git commit --amend
git push origin HEAD:refs/for/main
```

* Gerrit links the updated commit to the existing Change-Id.

---

### 5. Verifying & Submitting

* Automated tests or validation scripts for Codemeta ensure the change is correct.
* Once verified and approved (`+2`, no `-2`), the change can be merged into `main`.

---

**Key Points for Codemeta:**

* Gerrit **Change-Ids** track revisions and link multiple iterations of the same change.
* Reviews combine **human feedback** and **automated validation**, maintaining metadata quality.
* Inline comments and structured voting make collaboration efficient.

---

## Applying Gerrit in Codemeta or Software Heritage Projects

1. **Set Up Gerrit**: Ensure your project has a Gerrit server for code reviews.
2. **Make Changes**: Create a new branch and update code or metadata files.
3. **Commit Changes**: Use clear, descriptive commit messages.
4. **Push for Review**:

```bash
git push origin HEAD:refs/for/main
```

5. **Create a Review**: Gerrit will generate a review request.
6. **Review Process**: Team members can comment, suggest improvements, and vote.
7. **Rework Changes**: Amend commits to address feedback.
8. **Verify Changes**: Ensure tests pass and metadata standards are met.
9. **Submit Changes**: Merge approved changes to the main branch.

This workflow ensures Codemeta contributors maintain **high-quality software metadata** and collaborate smoothly with the Software Heritage archive.

---


