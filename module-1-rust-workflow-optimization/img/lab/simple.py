import subprocess
import shlex
import json
import sys

VERSION = "1.1"


# create a function that runs subprocess and returns the output
def run_command(command):
    cmd = shlex.split(command)
    output = subprocess.check_output(cmd)
    return output


def run_lsblk(device):
    """
    Runs lsblk command and produces JSON output:

    lsblk -J -o NAME,SIZE,TYPE,MOUNTPOINT
    """
    command = "lsblk -J -o NAME,SIZE,TYPE,MOUNTPOINT"
    output = run_command(command)
    devices = json.loads(output)["blockdevices"]

    for parent in devices:
        if parent["name"] == device:
            return parent
        for child in parent.get("children", []):
            if child["name"] == device:
                return child

    return None


def main(device):
    result = run_lsblk(device)
    if result is None:
        print(f"No block device found named '{device}'")
    else:
        print(result)


if __name__ == "__main__":
    # Handle --help flag
    if "--help" in sys.argv:
        print(f"""
lsblk CLI Tool v{VERSION}

Usage:
  python simple.py <device>

Arguments:
  device     Name of the block device (e.g., vda, vda1)
  --help     Show this help message and exit

Description:
  Queries lsblk and returns JSON information for the specified device.
""")
        sys.exit(0)

    # Handle no arguments provided
    if len(sys.argv) < 2:
        print("No arguments provided. Please specify a device name.")
        print("Example: python simple.py vda")
        sys.exit(1)

    device = sys.argv[1]
    main(device)
