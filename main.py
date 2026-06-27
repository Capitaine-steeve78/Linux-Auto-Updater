import logging
import os
import subprocess

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
        print(command)
        print(result.stdout)
        return True

    except subprocess.CalledProcessError as e:
        print(f"ERROR: {command}, {e.stderr.strip()}")
        return False


def print_and_log(message: str, level: int):
    print(message)
    if level == 1:
        logging.info(message)
    elif level == 3:
        logging.error(message)
    elif level == 2:
        logging.warning(message)
    elif level == 4:
        logging.critical(message)
    else:
        logging.debug(message)

# =========================
# GESTION SUDO AUTOMATIQUE
# =========================
def run_sudo_command(command):
    # si root → on enlève sudo
    if os.geteuid() == 0:
        command = command.replace("sudo ", "")

    return run_command(command)


# Exemple d'utilisation
if __name__ == "__main__":

    print_and_log("Updating...", 1)

    if not run_sudo_command("sudo apt update && sudo apt upgrade -y"):
        print("ERROR")
        # logging.error("Failed to install sudo apt update")
    # run_command("sudo apt upgrade -y")
    print("OK.")