**Install Positron on Ubuntu 22.04 (Reminder)**

1. Check my system architecture:

   ```bash
   uname -m
   ```

   * If it says `x86_64` → I need the **x64 (.deb)** version
   * If it says `aarch64` → I need the **arm64 (.deb)** version

2. Download the correct file (most likely):

   * `Positron-2026.04.1-10-x64.deb`

3. Go to the download folder:

   ```bash
   cd ~/Téléchargements
   ```

4. Install it:

   ```bash
   sudo apt install ./Positron-2026.04.1-10-x64.deb
   ```

5. Launch:

   ```bash
   positron
   ```

⚠️ Important:

* Don’t mix **arm64** and **x64** versions
* If installation fails, double-check filename with:

  ```bash
  ls
  ```
