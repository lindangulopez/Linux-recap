# Troubleshooting `pgadmin4` Installation and DNS Issues

During the installation of **pgAdmin 4**, the installation initially failed because the computer could not resolve the Snap server address—not because pgAdmin itself was broken.

The error was:

```text
dial tcp: lookup api.snapcraft.io on 127.0.0.53:53: read udp ... i/o timeout
```

This indicates that the local DNS resolver (`systemd-resolved` at `127.0.0.53`) timed out while attempting to resolve the Snap server. In other words, the Internet connection was available, but DNS name resolution temporarily failed.

Additionally, the following messages appeared:

```text
bash: /home/linda/.guix-profile/etc/profile: Aucun fichier ou dossier de ce nom
bash: /home/linda/.config/guix/current/etc/profile: Aucun fichier ou dossier de ce nom
```

These messages are unrelated to the pgAdmin installation. They indicate that `.bashrc` is attempting to source Guix profile files that no longer exist.

---

# 1. Diagnose the DNS Problem

First, verify that the Internet connection is working.

Test connectivity by IP address:

```bash
ping -c 3 8.8.8.8
```

If that succeeds, test DNS resolution:

```bash
ping -c 3 google.com
```

If the first command works but the second fails, the problem is DNS.

Restart the local DNS resolver:

```bash
sudo systemctl restart systemd-resolved
```

Verify that it is running:

```bash
systemctl status systemd-resolved
```

Then retry the installation:

```bash
sudo snap install pgadmin4
```

---

# 2. Configure DNS Servers (if the problem persists)

If DNS resolution continues to fail, configure reliable public DNS servers.

Edit:

```bash
sudo nano /etc/systemd/resolved.conf
```

Set:

```ini
[Resolve]
DNS=1.1.1.1 8.8.8.8
FallbackDNS=1.0.0.1 8.8.4.4
```

Save the file and restart the resolver:

```bash
sudo systemctl restart systemd-resolved
```

Verify the active DNS servers:

```bash
resolvectl status
```

Expected output:

```text
DNS Servers: 1.1.1.1 8.8.8.8
```

---

# 3. Installation Outcome

After restarting `systemd-resolved`, the installation succeeded:

```text
pgadmin4 9.15 from Bruno Enten (brunoenten) installed
```

This confirms that the problem was a temporary DNS resolution issue rather than a problem with pgAdmin itself.

Launch pgAdmin:

```bash
pgadmin4
```

If that does not start the application:

```bash
snap run pgadmin4
```

Depending on the Snap package, pgAdmin may open either:

* as a desktop application, or
* in a browser at approximately:

```text
http://127.0.0.1:5050
```

---

# 4. Connect pgAdmin to the PostgreSQL GIS Database

Within pgAdmin:

1. Right-click **Servers**.
2. Select **Register → Server**.

### General

**Name**

```text
Local GIS PostgreSQL
```

### Connection

**Host**

```text
localhost
```

**Port**

```text
5432
```

**Maintenance database**

```text
gis_database
```

**Username**

```text
gisuser
```

**Password**

```text
your_password
```

Click **Save**.

---

# 5. Snap vs. Official PostgreSQL Repository

The original GIS workstation installation guide recommends installing pgAdmin from the official PostgreSQL APT repository:

```bash
sudo apt update
sudo apt install curl wget gnupg ca-certificates lsb-release -y
```

Import the repository key:

```bash
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | \
sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
```

Add the repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | \
sudo tee /etc/apt/sources.list.d/pgadmin4.list
```

Install:

```bash
sudo apt update
sudo apt install pgadmin4-desktop -y
```

Launch:

```bash
pgadmin4
```

This method is generally preferred on Ubuntu/Debian because it integrates more cleanly with PostgreSQL and avoids some Snap confinement limitations.

However, since the Snap installation completed successfully, there is no immediate need to reinstall using the APT repository unless you later encounter issues with desktop integration, local file access, or PostgreSQL connectivity.

---

# 6. Clean Up the Guix Warnings (Optional)

The startup warnings originate from obsolete Guix initialization commands in `.bashrc`.

Locate them:

```bash
grep guix ~/.bashrc
```

You will likely see:

```bash
source ~/.guix-profile/etc/profile
source ~/.config/guix/current/etc/profile
```

Edit `.bashrc`:

```bash
nano ~/.bashrc
```

Comment out the obsolete lines:

```bash
# source ~/.guix-profile/etc/profile
# source ~/.config/guix/current/etc/profile
```

Reload the shell:

```bash
source ~/.bashrc
```

The Guix warning messages should no longer appear when opening a terminal.

---

# Summary

The installation issue was caused by a temporary DNS resolution failure involving `systemd-resolved`. Restarting the DNS resolver restored network name resolution, allowing the Snap installation to complete successfully:

```text
pgadmin4 9.15 from Bruno Enten (brunoenten) installed
```

