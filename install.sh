#!/bin/bash

set -e

clear

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}这个脚本必须以root权限运行"
   exit 1
fi

COLOR_NUM=$((RANDOM % 7))
# Assign a color variable based on the random number
case $COLOR_NUM in
    0) COLOR=$RED;;
    1) COLOR=$GREEN;;
    2) COLOR=$YELLOW;;
    3) COLOR=$BLUE;;
    4) COLOR=$CYAN;;
    5) COLOR=$ORANGE;;
    *) COLOR=$WHITE;;
esac

echo -e "${COLOR}"
echo ""
echo "   ▄█    █▄       ▄████████  ▄████████    ▄█   ▄█▄  ▄█  ███▄▄▄▄      ▄██████▄           ███      ▄██████▄   ▄██████▄   ▄█       ";
echo "  ███    ███     ███    ███ ███    ███   ███ ▄███▀ ███  ███▀▀▀██▄   ███    ███      ▀█████████▄ ███    ███ ███    ███ ███       ";
echo "  ███    ███     ███    ███ ███    █▀    ███▐██▀   ███▌ ███   ███   ███    █▀          ▀███▀▀██ ███    ███ ███    ███ ███       ";
echo " ▄███▄▄▄▄███▄▄   ███    ███ ███         ▄█████▀    ███▌ ███   ███  ▄███                 ███   ▀ ███    ███ ███    ███ ███       ";
echo "▀▀███▀▀▀▀███▀  ▀███████████ ███        ▀▀█████▄    ███▌ ███   ███ ▀▀███ ████▄           ███     ███    ███ ███    ███ ███       ";
echo "  ███    ███     ███    ███ ███    █▄    ███▐██▄   ███  ███   ███   ███    ███          ███     ███    ███ ███    ███ ███       ";
echo "  ███    ███     ███    ███ ███    ███   ███ ▀███▄ ███  ███   ███   ███    ███          ███     ███    ███ ███    ███ ███▌    ▄ ";
echo "  ███    █▀      ███    █▀  ████████▀    ███   ▀█▀ █▀    ▀█   █▀    ████████▀          ▄████▀    ▀██████▀   ▀██████▀  █████▄▄██ ";
echo "                                         ▀                                                                            ▀         ";

echo -e "${BLUE}                                    https://github.com/Z4nzu/hackingtool ${NC}"
echo -e "${RED}                                     [!] 这个工具必须以root运行 [!]${NC}\n"
echo -e "${CYAN}              选择合适的选项 : \n"
echo -e "${WHITE}              [1] Kali Linux / Parrot-Os (apt)"
echo -e "${WHITE}              [2] Arch Linux (pacman)" # added arch linux support because of feature request #231
echo -e "${WHITE}              [0] 退出 "

echo -e "${COLOR}┌──($USER㉿$HOST)-[$(pwd)]"
read -p "└─$>>" choice


# Define installation directories
install_dir="/usr/share/hackingtool"
bin_dir="/usr/bin"

# Check if the user chose a valid option and perform the installation steps
if [[ $choice =~ ^[1-2]+$ ]]; then
    echo -e "${YELLOW}[*] 检查网络连接 ..${NC}"
    echo "";
    if curl -s -m 10 https://www.google.com > /dev/null || curl -s -m 10 https://www.github.com > /dev/null; then
        echo -e "${GREEN}[✔] 网络连接正常 [✔]${NC}"
        echo "";
        echo -e "${YELLOW}[*] 正在更新程序包列表 ..."
        # Perform installation steps based on the user's choice
        if [[ $choice == 1 ]]; then
            sudo apt update -y && sudo apt upgrade -y
            sudo apt-get install -y git python3-pip figlet boxes php curl xdotool wget -y ;
        elif [[ $choice == 2 ]]; then
            sudo pacman -Suy -y
            sudo pacman -S python-pip -y  
        else
            exit
        fi
        echo "";
        echo -e "${YELLOW}[*] 正在检查目录...${NC}"
        if [[ -d "$install_dir" ]]; then
            echo -e -n "${RED}[!] 目录 $install_dir 已经存在. 你想要替换他吗？? [y/n]: ${NC}"
            read input
            if [[ $input == "y" ]] || [[ $input == "Y" ]]; then
                echo -e "${YELLOW}[*]正在删除现有模块.. ${NC}"
                sudo rm -rf "$install_dir"
            else
                echo -e "${RED}[✘]不需要安装[✘] ${NC}"
                exit
            fi
        fi
        echo "";
        echo -e "${YELLOW}[✔] 下载中...${NC}"
        if sudo git clone https://github.com/Z4nzu/hackingtool.git $install_dir; then
            # Install virtual environment
            echo -e "${YELLOW}[*] 安装虚拟环境...${NC}"
            if [[ $choice == 1 ]]; then
              sudo apt install python3-venv -y
            elif [[ $choice == 2 ]]; then
              echo "Python 3.3+附带了一个名为venv的模块.";
            fi
            echo "";
            # Create a virtual environment for the tool
            echo -e "${YELLOW}[*] 创建虚拟环境..."
            sudo python3 -m venv $install_dir/venv
            source $install_dir/venv/bin/activate
            # Install requirements
            echo -e "${GREEN}[✔] 虚拟环境就绪 [✔]${NC}";
            echo "";
            echo -e "${YELLOW}[*] 安装必要的python鸡...${NC}"
            if [[ $choice == 1 ]]; then
                pip3 install -r $install_dir/requirements.txt
                sudo apt install figlet -y
            elif [[ $choice == 2 ]]; then
                pip3 install -r $install_dir/requirements.txt
                sudo -u $SUDO_USER git clone https://aur.archlinux.org/boxes.git && cd boxes
                sudo -u $SUDO_USER makepkg -si
                sudo pacman -S figlet -y
            fi
            # Create a shell script to  the tool
            echo -e "${YELLOW}[*] 创建一个shell脚本来启动该工具。.."
#            echo '#!/bin/bash' > hackingtool.sh
            echo '#!/bin/bash' > $install_dir/hackingtool.sh
            echo "source $install_dir/venv/bin/activate" >> $install_dir/hackingtool.sh
            echo "python3 $install_dir/hackingtool.py \$@" >> $install_dir/hackingtool.sh
            chmod +x $install_dir/hackingtool.sh
            sudo mv $install_dir/hackingtool.sh $bin_dir/hackingtool
            echo -e "${GREEN}[✔] 脚本创建成功 [✔]"
        else
            echo -e "${RED}[✘] 下载失败 [✘]"
            exit 1
        fi

    else
       echo -e "${RED}[✘] 网络连接错误 [✘]${NC}"
       exit 1
    fi

    if [ -d $install_dir ]; then
        echo "";
        echo -e "${GREEN}[✔] 安装成功 [✔]";
        echo "";
        echo "";
        echo -e  "${ORANGE}[+]+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++[+]"
        echo     "[+]                                                             [+]"
        echo -e  "${ORANGE}[+]     ✔✔✔ Now Just Type In Terminal (hackingtool) ✔✔✔      [+]"
        echo     "[+]                                                             [+]"
        echo -e  "${ORANGE}[+]+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++[+]"
    else
        echo -e "${RED}[✘] 安装失败 !!! [✘]";
        exit 1
    fi

elif [[ $choice == 0 ]]; then
    echo -e "${RED}[✘] 退出工具 [✘]"
    exit 1
else
    echo -e "${RED}[!] 选择有效选项 [!]"
fi
