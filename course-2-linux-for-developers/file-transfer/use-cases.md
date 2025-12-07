# File transfer in Linux** 


## **Summary Table with Use Cases**

| Tool      | Secure? | Example Bash Command              | Use Case                    |
| --------- | ------- | --------------------------------- | --------------------------- |
| FTP       | ❌       | `ftp server`                      | Legacy transfers in LAN     |
| SFTP      | ✅       | `sftp user@host`                  | Secure interactive transfer |
| SCP       | ✅       | `scp file user@host:/path/`       | One-off secure file copy    |
| Rsync     | ✅       | `rsync -avz dir/ user@host:/dir/` | Incremental sync, backups   |
| Curl/Wget | ✅       | `wget https://example.com/file`   | Download/upload via URL     |


✅ **Key Recommendations:**

1. Use **SFTP, SCP, or Rsync over SSH** for secure transfers.
2. Use **wget/curl** for downloading from web URLs.
3. Avoid **FTP, rsh, rcp** for any sensitive or public network transfers.

## **1. FTP (Legacy, Insecure)**

**FTP** is an old protocol for transferring files between computers.
⚠️ **Insecure:** sends credentials and data in plaintext, not recommended for sensitive data.

### **Bash Commands:**

```bash
ftp ftp.example.com          # Connect to FTP server
# Once connected:
# username: your FTP username
# password: your FTP password
put localfile.txt            # Upload a file
get remotefile.txt           # Download a file
bye                          # Disconnect
```

### **Use Case:**

* Quick transfers in trusted, isolated networks.
* Legacy systems or archives that still use FTP.

**Better Alternative:** Use **SFTP** or **SCP** for security.

## **2. SFTP (Secure File Transfer Protocol)**

**SFTP** uses SSH encryption, making it secure.

### **Bash Commands:**

```bash
sftp user@remote_server
# Interactive session:
sftp> put localfile.txt         # Upload file
sftp> get remotefile.txt        # Download file
sftp> ls                        # List files on remote
sftp> exit                      # Close connection
```

**Non-interactive:**

```bash
sftp user@remote_server:/remote/path <<< $'put localfile.txt'
```

### **Use Case:**

* Uploading logs, backups, or configuration files to a remote server securely.
* Downloading files from remote servers without exposing credentials.

## **3. SCP (Secure Copy)**

**SCP** is simple for copying files over SSH, **non-interactive**.

### **Bash Commands:**

```bash
# Copy file to remote server
scp localfile.txt user@remote_server:/remote/path/

# Copy file from remote server to local machine
scp user@remote_server:/remote/path/remotefile.txt ./localfile.txt

# Copy entire directory
scp -r /local/dir user@remote_server:/remote/dir/
```

### **Use Case:**

* Quick one-off transfers.
* Backups or moving files between servers.

## **4. Rsync (Efficient Syncing)**

**Rsync** is faster and more efficient than SCP for large files or repeated transfers because it only sends **differences**.

### **Bash Commands:**

```bash
# Copy local dir to remote
rsync -avz /local/dir/ user@remote_server:/remote/dir/

# Copy remote dir to local
rsync -avz user@remote_server:/remote/dir/ /local/dir/

# Dry run to see what will be transferred
rsync -avzn /local/dir/ user@remote_server:/remote/dir/
```

**Flags:**

* `-a` → archive mode (preserve permissions, timestamps, symbolic links)
* `-v` → verbose
* `-z` → compress data during transfer
* `-n` → dry run

### **Use Case:**

* Regular backups to a remote server.
* Synchronizing a website directory between local and remote servers.
* Transferring large datasets incrementally.

## **5. Curl / Wget (HTTP, HTTPS, FTP)**

These tools are for **downloading files from URLs** and can also upload data in some cases.

### **Bash Commands:**

```bash
# Download file
wget https://example.com/file.tar.gz

# Download file using curl
curl -O https://example.com/file.tar.gz

# Upload a file to FTP (insecure)
curl -T localfile.txt ftp://user:password@ftp.example.com/

# Fetch multiple files from HTTP
wget -i filelist.txt
```

### **Use Case:**

* Downloading software packages or datasets from the Internet.
* Automating downloads in scripts.
* Fetching or uploading files from/to web servers.

---

## **6. Avoid Insecure Old Tools**

* `rsh`, `rcp` → old, unencrypted remote commands and file transfers.
* ⚠️ **Never use these** on public networks.

---

