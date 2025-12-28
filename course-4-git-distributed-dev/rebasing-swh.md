# Consequences of Merging and Rebasing for the Software Heritage Project

Below is a **Software Heritage–focused explanation** of the consequences of **merging vs. rebasing**.

## Software Heritage’s Core Goal

**Software Heritage (SWH)** aims to **archive, preserve, and make reproducible the complete history of software development**. This includes:

* Commits and their relationships
* Branches and merges
* Authorship and timestamps
* The *true sequence* of development events

Because of this mission, the choice between **merging** and **rebasing** has important consequences for what Software Heritage can preserve and how accurately it can represent history.

| Aspect                       | Merging | Rebasing        |
| ---------------------------- | ------- | --------------- |
| Preserves true history       | ✅ Yes   | ❌ No            |
| Shows parallel development   | ✅ Yes   | ❌ Often lost    |
| Captures conflict resolution | ✅ Yes   | ❌ Mostly hidden |
| Stable commit identifiers    | ✅ Yes   | ❌ Rewritten     |
| Archival clarity             | High    | Lower           |

### Final Takeaway

For Software Heritage, **merging strengthens historical preservation**, while **rebasing—especially on shared branches—can obscure or distort the historical record**.
What may look like a “clean history” for developers can become a **loss of valuable historical information** for long-term software preservation.


---

## Merging: Consequences for Software Heritage

### What Merging Preserves Well

When developers use **merging**:

* Commit history remains intact
* Branches and merge commits are explicitly recorded
* Parallel development paths are visible

**For Software Heritage, this is ideal**, because:

* Merge commits document *when and how* independent lines of work were combined
* Conflicts and their resolutions are preserved as historical decisions
* The development graph accurately reflects collaboration

### Long-Term Impact

* Researchers can study collaboration patterns
* The evolution of features and bug fixes is traceable
* No historical information is lost

✅ **Merging aligns strongly with Software Heritage’s archival and historical goals**

---

## Rebasing: Consequences for Software Heritage

### History Rewriting and Its Effects

Rebasing **rewrites commit history** by:

* Creating new commits with new identifiers
* Removing the original branching structure
* Making development appear more linear than it actually was

For Software Heritage, this has serious implications:

#### 1. Loss of Historical Authenticity

* Original commits still exist *somewhere*, but are no longer referenced
* The visible history no longer reflects how development actually happened
* Parallel work and integration points may disappear

#### 2. Reduced Traceability

* It becomes harder to understand:

  * When changes were originally made
  * Which commits were developed in parallel
  * How conflicts emerged and were resolved

#### 3. Fragmentation of Archived History

If rebased commits are published:

* Software Heritage may archive **both versions**
* This creates multiple, disconnected histories of the “same” change
* Researchers must infer relationships instead of relying on explicit links

---

## Rebasing Shared Branches: A Major Problem for Preservation

Rebasing shared branches causes:

* Diverging commit histories between developers
* Confusion about which commits are authoritative
* Increased risk of “lost” historical context

For Software Heritage:

* The archive may contain **multiple incompatible development graphs**
* Authorship and temporal order become harder to analyze
* Reconstructing the true development process becomes more complex

⚠️ **This directly conflicts with Software Heritage’s goal of clear, reproducible history**

---

## Conflict Resolution During Rebase: Another Archival Issue

During rebasing:

* Conflicts are resolved *commit by commit*
* The final history hides the fact that conflicts occurred at all

As a result:

* Software Heritage archives the final state
* But loses visibility into *where* and *why* conflicts arose
* Important collaboration insights are erased

In contrast, merge commits naturally preserve this context.

---

## Recommended Practices from a Software Heritage Perspective

While rebasing is useful locally, from an archival standpoint:

* ✅ **Merging is preferable for shared and published branches**
* ⚠️ **Rebasing should be limited to private, short-lived branches**
* ❌ **Avoid rebasing branches that are already public or archived**

These practices result in:

* Clearer development graphs
* More accurate historical records
* Better long-term research value

---

