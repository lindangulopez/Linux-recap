# Linux user and group management

In short, **user and group management in Linux** allows you to:

1. Create users and groups with specific roles.
2. Assign permissions on files and directories securely.
3. Monitor and control access to maintain system stability and security.

---

## **1. Add and Manage Users**

* **Add a new user (friendly way, with home directory):**

```bash
sudo adduser username
```

* **Add a new user (basic way, create home manually):**

```bash
sudo useradd -m username
```

* **Set or change a user password:**

```bash
sudo passwd username
```

* **Add a user to a group (grant additional permissions):**

```bash
sudo usermod -aG groupname username
```

* **Verify user creation:**

```bash
cat /etc/passwd | grep username
```

**Use case:**
Create separate accounts for team members so each has their own workspace and credentials.

---

## **2. Group Management**

* **Create a new group:**

```bash
sudo groupadd groupname
```

* **List groups:**

```bash
cat /etc/group
```

* **Add user to a group:**

```bash
sudo usermod -aG groupname username
```

**Use case:**
Organize users into departments (e.g., finance, marketing) to share access to specific resources.

---

## **3. File Permissions Management**

* **View permissions of a file or directory:**

```bash
ls -l filename
```

* **Change file permissions (`chmod`):**

```bash
chmod 640 filename  # owner=r/w, group=r, others=none
```

* **Change file ownership (`chown`):**

```bash
sudo chown username:groupname filename
```

* **Set ACL for specific users (`setfacl`):**

```bash
setfacl -m u:username:r filename
```

**Use case:**
Control who can read, write, or execute files; enforce least privilege for security.

---

## **4. Best Practices**

* Regularly review user accounts and group memberships.
* Audit file permissions to prevent unauthorized access.
* Use groups and ACLs to simplify permission management.
* Avoid giving excessive privileges to reduce risk of accidental or malicious actions.

---

## **Potential Issues if Mismanaged**

* Unauthorized access to sensitive data.
* Data corruption from accidental modifications.
* System instability or downtime.
* Compliance violations (legal/regulatory risks).

---


