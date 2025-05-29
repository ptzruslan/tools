# Server Installation and Configuration Check

This script helps students verify if they have correctly configured their server after renting it. It checks for user existence, installed packages, SSH configuration, as well as the correct installation of Go and environment variables.

## 🔧 What Should the Student Do?

1.  **Connect to the server via SSH**:
    ```bash
    ssh <username>@<server_ip>    # Example: root@192.168.208.11
    ```
    *Important: Password input in the console IS NOT DISPLAYED!!!*

2.  **Create a new user and grant them sudo privileges**:
    ```bash
    sudo adduser <username>   # Example: sudo adduser superman
    sudo usermod -aG sudo <username>    # Example: sudo usermod -aG sudo superman
    ```

3.  **Switch to the new user**:
    ```bash
    su <username> # Example: su superman
    ```

4.  **Update the system and install necessary packages**:
    ```bash
    sudo apt update && sudo apt upgrade -y
    sudo apt install mc btop nano screen git make build-essential jq lz4 -y
    ```

5.  **Disable root login via SSH**:
    * Edit the SSH configuration file:
        ```bash
        sudo nano /etc/ssh/sshd_config
        ```
    * Set the parameter:
        ```
        PermitRootLogin no
        ```
    * Restart SSH:
        ```bash
        sudo systemctl restart sshd 2>/dev/null || sudo systemctl restart ssh
        ```

6.  **Install Go**:
    ```bash
    sudo rm -rvf /usr/local/go/
    wget https://golang.org/dl/go1.23.4.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
    rm go1.23.4.linux-amd64.tar.gz
    ```

7.  **Set Go environment variables** (e.g., in `~/.profile`):
    ```bash
    nano ~/.profile
    ```
    ```bash
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export GO111MODULE=on
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    ```
    Apply the variables (if in `~/.profile`):
    ```bash
    source ~/.profile
    ```

## 📥 How to Download and Run the Verification Script?

1.  **Install wget (if not already installed)**:
    ```bash
    sudo apt install wget -y
    ```

2.  **Download the script from GitHub**:
    ```bash
    wget https://raw.githubusercontent.com/ptzruslan/tools/refs/heads/main/validator/tech02/practice_tech_02_eng.sh -O practice_tech_02.sh
    ```

3.  **Give the script execution permissions**:
    ```bash
    chmod +x practice_tech_02.sh
    ```

4.  **Run the script (specifying the created username)**:
    ```bash
    bash practice_tech_02.sh <username> # Example: bash practice_tech_02.sh superman
    ```

## 📌 What Does the Script Check?
* Whether the user is created and has sudo privileges
* Whether the system is updated
* Whether the necessary packages are installed
* Whether root access via SSH is disabled
* Whether SSH is working
* Whether Go is installed and environment variables are set correctly

If everything is done correctly, the student will see ✅ in the console. If errors are found, ❌ or ⚠️ will appear with recommendations.
