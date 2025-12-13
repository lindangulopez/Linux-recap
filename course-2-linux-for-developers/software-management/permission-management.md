# Linux User, Group, and Permission Management

✅ **Key Takeaways**:

* Only root or sudo-enabled users can manage accounts and groups
* Proper permissions and group memberships are critical for security
* `sudo` is the recommended method for temporary privilege escalation
* Understanding `/etc/passwd`, `/etc/group`, and permissions is essential for Linux administration


## 1. Adding and Removing Users

* **Add a user**:

```bash
sudo useradd username
```

* Creates home directory (e.g., `/home/username`)
* Copies default files from `/etc/skel`
* Sets default shell (usually `/bin/bash`)
* **Set password**:

```bash
sudo passwd username
```

* **Remove a user**:

```bash
sudo userdel username        # leaves home directory
sudo userdel -r username     # removes home directory as well
```

* **Modify user properties**:

```bash
sudo usermod -d /new/home -p newpassword username
```

---

## 2. Groups

* **Add a group**:

```bash
sudo groupadd groupname
```

* **Delete a group**:

```bash
sudo groupdel groupname
```

* **Add user to a group**:

```bash
sudo usermod -aG groupname username
```

* **Remove user from a group**: requires specifying all remaining groups with `-G`.

* **Check groups**:

```bash
groups username
```

* **Quick user info**:

```bash
id username
```

---

## 3. File Permissions

* **Ownership**: user, group, world
* **Permission structure**: read (r), write (w), execute (x)

```text
-rwxr-x--x
```

* Owner: rwx
* Group: r-x
* Others: --x
* **Commands**:

  * Change permissions: `chmod`
  * Change ownership: `chown`
* **Root user** has access to all files.
* **POSIX ACLs** allow more granular access control per user or group.

---

## 4. Root Privileges, `su`, and `sudo`

* **Switch user**:

```bash
su username
su -     # login shell
```

* **Execute single command as another user**:

```bash
su -c 'command' username
```

* **Temporary root access with sudo**:

```bash
sudo command
sudo -u username command
```

* **sudo vs su**:

  * `su` requires target user’s password (often root)
  * `sudo` uses **your own password** and is safer

* **Grant sudo privileges**:

  * Add line to `/etc/sudoers` or `/etc/sudoers.d/username`:

    ```
    username ALL=(ALL) ALL
    ```
  * Use `visudo` or `sudoedit` to safely edit

* **Special cases**:

  * Ubuntu disables direct root login by default
  * Use `sudo su` for root shell

---

## 5. Lab / Practice Tasks

1. Create users:

   ```bash
   sudo useradd user1
   sudo passwd user1
   ```
2. Test login via SSH or su
3. Inspect `/etc/passwd` and `/etc/group` for new entries
4. Explore defaults:

   * `/etc/default/useradd`
   * `/etc/login.defs`
5. Create a user with a specific shell:

   ```bash
   sudo useradd -s /bin/ksh user2
   sudo passwd user2
   ```

---


