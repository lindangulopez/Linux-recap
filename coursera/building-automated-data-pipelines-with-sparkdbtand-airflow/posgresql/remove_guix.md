# remove guix

If you've decided not to use Guix anymore, you can safely remove the leftover shell initialization lines that are causing those messages.

First, inspect which Guix-related lines are present:

```bash
grep -n guix ~/.bashrc
```

You will likely see something similar to:

```bash
source ~/.guix-profile/etc/profile
source ~/.config/guix/current/etc/profile
```

Open your `.bashrc`:

```bash
nano ~/.bashrc
```

Find those lines and either **comment them out** by adding `#` at the beginning:

```bash
# source ~/.guix-profile/etc/profile
# source ~/.config/guix/current/etc/profile
```

or **delete them** entirely if you no longer plan to use Guix.

Save and exit:

* **Ctrl+O** (write the file)
* **Enter**
* **Ctrl+X** (exit)

Reload your shell without opening a new terminal:

```bash
source ~/.bashrc
```

The messages:

```text
bash: /home/linda/.guix-profile/etc/profile: Aucun fichier ou dossier de ce nom
bash: /home/linda/.config/guix/current/etc/profile: Aucun fichier ou dossier de ce nom
```

should no longer appear.

### If you want to completely remove GuixAlmost. **Do not delete the last two `export PATH` lines**, because they are not part of the Guix initialization:

```bash
export PATH="$HOME/.juliaup/bin:$PATH"
export PATH=$PATH:/usr/sbin:/sbin
```

Instead, delete **only** this Guix block:

```bash
# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi

GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

source ~/.config/guix/current/etc/profile
```

Leave these lines in place:

```bash
export PATH="$HOME/.juliaup/bin:$PATH"
export PATH=$PATH:/usr/sbin:/sbin
```

Then:

1. Save (`Ctrl+O`, **Enter**)
2. Exit (`Ctrl+X`)
3. Reload:

```bash
source ~/.bashrc
```

If there are no error messages after `source ~/.bashrc`, you've successfully removed the Guix shell initialization. Then you can proceed with uninstalling the Guix daemon and deleting the Guix directories.
