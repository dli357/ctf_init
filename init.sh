# Setup 32-bit executions
dpkg --add-architecture i386
apt update
apt -y upgrade
apt -y autoremove
apt -y install build-essential
apt -y install libc6:i386
apt -y install libncurses5:i386
apt -y install libstdc++6:i386

# Set core pattern and core dump folder
syctl -w kernel.core_pattern=/tmp/core.%u.%e.%p

# Install some python3 dependencies
apt -y install python3-pip
python3 -m pip install pwntools
python3 -m pip install pycryptodome
python3 -m pip install pillow
python3 -m pip install z3-solver

# Setup pwndbg
cd ~
git clone https://github.com/pwndbg/pwndbg
cd ~/pwndbg
/bin/bash ./setup.sh

# Setup aslr toggleable using "aslr"
echo '' >> ~/.bashrc
echo '# ASLR toggle alias' >> ~/.bashrc
echo 'export aslr=2' >> ~/.bashrc
echo 'echo 2 | sudo tee /proc/sys/kernel/randomize_va_space > /dev/null' >> ~/.bashrc
echo 'aslr() {' >> ~/.bashrc
echo '    if [ $aslr == 2 ]; then' >> ~/.bashrc
echo '        echo 0 | sudo tee /proc/sys/kernel/randomize_va_space > /dev/null;' >> ~/.bashrc
echo '        export aslr=0;' >> ~/.bashrc
echo '        printf "\033[0;31mASLR has been turned off.\n\033[0m"' >> ~/.bashrc
echo '    else' >> ~/.bashrc
echo '        echo 2 | sudo tee /proc/sys/kernel/randomize_va_space > /dev/null;' >> ~/.bashrc
echo '        export aslr=2;' >> ~/.bashrc
echo '        printf "\033[0;31mASLR has been turned on.\n\033[0m"' >> ~/.bashrc
echo '    fi' >> ~/.bashrc
echo '}' >> ~/.bashrc

# Enable core dumps on all sessions
echo '' >> ~/.bashrc
echo '# Enable core dump' >> ~/.bashrc
echo 'ulimit -c unlimited' >> ~/.bashrc

source ~/.bashrc
