# Authentication, Tokens, and the Archive

An important distinction exists between **access control today** and **long-term preservation**:

* **Git tokens, SSH keys, and passwords** determine *who can access a repository right now*.
* **SWHIDs and the Software Heritage archive** ensure *anyone can access preserved public code in the future*.

Once a repository is archived:

* Access no longer depends on GitHub tokens.
* SSH configuration is no longer a requirement.
* The original hosting service is no longer needed.

This separation is **crucial for long-term digital preservation**, guaranteeing that public code remains retrievable decades from now.

## Big Picture: Why This Matters

Together, these concepts show how Git workflows and Software Heritage interact:

* Git workflows generate software history.
* Software Heritage preserves that history permanently.
* **SWHIDs make the history referencable.**
* **SWHID iframes make the history reusable.**

👉 **SWHIDs transform software into a citable, permanent cultural artifact**, while the iframe makes it visible and usable wherever knowledge is shared.

---

## SWHIDs: Permanent, Citable References

A **Software Heritage persistent identifier (SWHID)** is a stable reference to **a specific object in the archive**, such as:

* A single file
* A directory
* A commit or revision
* A release
* An entire repository snapshot

SWHIDs guarantee that:

* The content is **exactly the same** as when it was archived.
* References are **stable**, surviving deletions, renames, or platform changes.
* Software can be **cited reliably** in research, documentation, or teaching.

---

## The SWHID iframe: Making History Reusable

The **SWHID iframe** allows developers, educators, and researchers to **embed archived code directly into web pages**.

Benefits:

* Provides a **live, read-only view** of the archived content.
* Ensures the embedded code **cannot change** or disappear.
* Supports reproducibility and educational use, by embedding **exact versions** of source code.

Use cases include:

* Teaching and course materials
* Research publications and experiments
* Documentation, blogs, and tutorials
* Exhibiting historical or culturally important software

The iframe demonstrates that Software Heritage is not just about *archiving code*, but also about **making preserved software accessible, referencable, and reusable**.

---




