#!/bin/bash

# 1. Script version
#-------------------------------------------------------------------------------------------------------------
Version="V1.x.x_20250902"
echo "Script Programming Tools :: $Version"
#--------------------------------------------------------------------------------------------------------------

# 2. Install nodejs
echo "Installing nodejs automatically..."

sudo apt clean
sudo apt update --fix-missing -qq
sudo apt install -y nodejs npm

# 3. Download pyenv (Python version management)
platformCPU=$(uname -m)
pyVERSION="3.12.0"

PYENV_NAME="pyenv_${platformCPU}_${pyVERSION}"

if ! command -v pyenv >/dev/null 2>&1; then
    echo "pyenv not found. Installing pyenv automatically..."
    curl https://pyenv.run | bash

    # make pyenv available in this script immediately
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    
    # optional: add to .bashrc for interactive shells later
    bashrc_file="$HOME/.bashrc"
    if ! grep -q 'pyenv init -' "$bashrc_file"; then
        echo -e '\n# >>> pyenv setup (interactive shell) >>>' >> "$bashrc_file"
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$bashrc_file"
        echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> "$bashrc_file"
        echo 'eval "$(pyenv init -)"' >> "$bashrc_file"
        echo 'eval "$(pyenv virtualenv-init -)"' >> "$bashrc_file"
        echo '# <<< pyenv setup (interactive shell) <<<' >> "$bashrc_file"
    fi
    
    pyenv rehash
    echo "pyenv installation complete."
else
    echo "pyenv is already installed."
fi

echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "pyenv version: $(pyenv --version)"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"

if ! pyenv install -l | grep -q "$pyVERSION$"; then
    echo "Python version $pyVERSION is not available for installation."
    read -p "Press Enter to exit..."
    exit 1
fi

# 4. Google drive file stream

pathCD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # pathCD = current dir
HOME_DIR="$pathCD/ROOT_HOME"
mkdir -p "$HOME_DIR"

pathCONF="$pathCD/.__conf_ini"
mkdir -p "$pathCONF"
chmod 700 "$pathCONF" 

#~ # find mount path (google drive file stream) 
#~ MyDrive=""
#~ SharedDrives=""
#~ for mount in /mnt/* /media/* "$HOME"; do
    #~ [[ -d "$mount/My Drive" ]] && MyDrive="$mount/My Drive"
    #~ [[ -d "$mount/Shared drives" ]] && SharedDrives="$mount/Shared drives"
#~ done

#~ echo "MyDrive = $MyDrive"
#~ echo "SharedDrives= $SharedDrives"

# 5. Create virtual environment using pyenv
# echo "Installing python3-picamera2"
# sudo apt install -y python3-picamera2
echo "Installing system dependencies for building Python..."
sudo apt clean
sudo apt update --fix-missing -qq
sudo apt install -y -qq make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# install python version if not exist
pyenv install -s "$pyVERSION"

# check if virtualenv exists, create if not
if ! pyenv versions --bare | grep -qx "$PYENV_NAME"; then
    echo "Creating virtualenv $PYENV_NAME..."
    pyenv virtualenv "$pyVERSION" "$PYENV_NAME"
else
    echo "Virtualenv $PYENV_NAME already exists."
fi

# activate environment
pyenv activate "$PYENV_NAME"
echo "Python path: $(which python)"

if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "⚠ Virtualenv not active."
    echo "To activate the virtual environment, run: pyenv activate \"$pyVERSION/envs/$PYENV_NAME\""
    read -p "Press [Enter] to exit..."
    exit 1
else
    echo "✅ Virtual environment detected: $VIRTUAL_ENV"
    echo "Using pip in $(which pip)"
    
    python -m pip install --upgrade pip --cache-dir "$pathCONF/cache" # $HOME/Desktop/.__conf_ini/cache
    python -m pip install jupyter notebook
    python -m pip install matplotlib plotting plotly pandas

    python -m pip install scikit-learn scikit-image opencv-python # or opencv-python-headless
    python -m pip install pyinstaller speedtest-cli pythonping
    python -m pip install nbtutor
    
    python -m pip install numpy tensorflow torch torchvision torchaudio tensorboard
    
    python -m pip install yolov10
    
    # python -m pip install fastapi uvicorn # api
    python -m pip install RPi.GPIO pigpio gpiozero # for using rasberry pi as a main
    # python -m pip install platformio # ardunio on jupyterlab
    # python -m pip install websockets # websockets for using pi as a wss
    python -m pip install jupyterhub # multi-user
    # python -m pip install dockerspawner # docker user
    sudo npm install -g configurable-http-proxy
    
    echo "Jupyter path: $(which jupyter)"
    # jupyter nbextension install --py nbtutor --sys-prefix
    # jupyter nbextension enable --py nbtutor --sys-prefix
    
    # pyenv deactivate
    echo "Python path: $(which python)"
    echo "Installation completed successfully."
fi

# 8. Guide

# Launch JupyterLab with the following options:
# jupyter password          : To set password for other device on network
# --ip=0.0.0.0              : Bind JupyterLab to all network interfaces (allows remote access)
# --port=8888               : Run JupyterLab on port 8888 (default is also 8888)
# --no-browser              : Do not open a web browser on startup (useful for headless or remote systems)
# --NotebookApp.token=""    : Disable the token-based authentication (⚠️ not secure for public networks)
# jupyter password
# jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token=""

# exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token=""
jupyterhub -f /home/admin/Desktop/jupyterhub_config.py
