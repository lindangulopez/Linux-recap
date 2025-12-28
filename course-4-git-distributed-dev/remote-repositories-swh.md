## Working with others in Git 

Determines not only how software is developed, but also **how its history survives**.

For Software Heritage:

* Collaboration workflows define the *structure* of archived history
* Development artifacts become historical evidence
* Preservation depends on understanding and respecting distributed development

👉 *How we collaborate today determines how software history will be understood decades from now.*

Here is a **focused and expanded explanation**, staying tightly centered on **Software Heritage** and its preservation mission.

---

## What This Means for Software Heritage

From the perspective of **Software Heritage (SWH)**, collaborative Git workflows are not just development techniques — they are **sources of historical knowledge** that must be preserved accurately and completely.

### Remote Repositories as Distributed Historical Sources

Remote repositories are more than mirrors of the same codebase:

* They may contain **unique commits**, abandoned experiments, or alternative implementations
* Forks and personal repositories often preserve work that never reaches the “official” project
* Some remotes survive even when the original repository disappears

For Software Heritage, this means:

* Software history is **distributed by nature**
* Archiving only one repository is insufficient
* Preserving multiple remotes ensures **redundancy, completeness, and resilience**

---

### Patches and Emails as Development Artifacts

Before (and sometimes instead of) pull requests:

* Changes were shared as **patch files**
* Discussions happened on **mailing lists**

These artifacts:

* Capture *intent*, *discussion*, and *alternative solutions*
* Preserve contributions that were rejected, revised, or postponed
* Document how decisions were made, not just what was decided

Software Heritage treats patches and related metadata as **first-class historical objects**, essential to understanding software evolution.

---

### Complex Workflows Explain the Shape of History

Non-linear commit graphs, rebases, cherry-picks, and review systems can make history appear messy or fragmented.

From an archival perspective:

* This complexity reflects **real human collaboration**
* Clean, linear history is often an *illusion*
* The shape of the commit graph tells a story about:

  * Team structure
  * Review practices
  * Release pressure
  * Governance models

Software Heritage preserves this structure so future users can understand *why* software evolved the way it did.

---

### Merge Conflicts and Branches as Evidence of Collaboration

Merge conflicts and branching are often seen as problems to eliminate, but historically they are **valuable signals**:

* They show where parallel work occurred
* They highlight areas of contention or rapid change
* Their resolution records human decision-making and compromise

Software Heritage preserves merges and branch relationships because they document **collaborative problem-solving**, not just technical outcomes.

---

### Good Git Practices Improve Long-Term Preservation

Practices such as:

* Meaningful commit messages
* Clear branching strategies
* Avoiding unnecessary history rewriting
* Using merges for shared work

Have consequences beyond the immediate project:

* They produce clearer, more reliable archival records
* They make software history easier to study, reproduce, and verify
* They reduce ambiguity in authorship and timelines

In other words, **today’s Git practices shape tomorrow’s software heritage**.

---


