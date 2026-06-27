import subprocess
import logging

logging.basicConfig(level=logging.INFO)

def run_command(command):
    try:
        result = subprocess.run(
            command,
            shell=True,
            check=True,
            capture_output=True,
            text=True
        )
        print(f"{command}")
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"ERROR: {command}, {e.stderr.strip()}")
        return False

# Exemple d'utilisation
if __name__ == "__main__":
    if not run_command("sudo apt update && sudo apt upgrade -y"):
        logging.error("Failed to install sudo apt update")
    # run_command("sudo apt upgrade -y")