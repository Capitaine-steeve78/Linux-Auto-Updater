import subprocess

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
    run_command("sudo apt update && sudo apt upgrade -y")
    # run_command("sudo apt upgrade -y")