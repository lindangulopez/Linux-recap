# Linux User and Group Management 

### 1. Users and User IDs (UIDs)

* Each Linux user has a **unique UID**:

  * Normal users: starting from 1000
  * Superuser (root): UID 0
* User information is primarily stored in `/etc/passwd`.

---

### 2. The `/etc/passwd` File

* Purpose: Stores user account information for authentication and system management.
* Key fields:

  1. **Username** – login name
  2. **Password placeholder** – usually `x` (actual password stored in `/etc/shadow`)
  3. **UID** – unique user identifier
  4. **GID** – primary group ID
  5. **Full Name** – descriptive name
  6. **Home Directory** – default user folder
  7. **Default Shell** – shell assigned to the user
* Contains both regular and system users; some system accounts have no login shell.

---

### 3. Groups and Group IDs (GIDs)

* Groups allow users to **share resources** (files, projects, permissions).
* Each user has:

  * A **primary group** (usually same as UID)
  * Optional **secondary groups**, listed in `/etc/group`.

---

### 4. Viewing `/etc/passwd`

* Commands to inspect the file:

  ```bash
  cat /etc/passwd   # Show full contents
  less /etc/passwd  # Paginated view
  more /etc/passwd  # Another paginated view
  ```

---

### 5. Importance and Risks

* Essential for:

  * User authentication
  * Access control
  * System stability
* **If deleted**:

  * Users cannot log in
  * Authentication fails
  * Dependent system processes may break
  * Manual recovery is required

---



