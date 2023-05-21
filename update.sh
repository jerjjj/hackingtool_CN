#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'

echo "███████╗██╗  ██╗███╗   ██╗███████╗██╗   ██╗    ";
echo "╚══███╔╝██║  ██║████╗  ██║╚══███╔╝██║   ██║    ";
echo "  ███╔╝ ███████║██╔██╗ ██║  ███╔╝ ██║   ██║    ";
echo " ███╔╝  ╚════██║██║╚██╗██║ ███╔╝  ██║   ██║    ";
echo "███████╗     ██║██║ ╚████║███████╗╚██████╔╝    ";
echo "╚══════╝     ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝     ";
echo "                                               ";

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[ERROR]\e[0m 这个脚本必须以root运行"
   exit 1
fi

install_dir="/usr/share/hackingtool"
# Change to the directory containing the install.sh script
cd $install_dir || { echo -e "${RED}[ERROR]\e[0m 无法更改为包含install.sh的目录."; exit 1; }
echo -e "${YELLOW}[*] Checking Internet Connection ..${NC}"
echo "";
if curl -s -m 10 https://www.google.com > /dev/null || curl -s -m 10 https://www.github.com > /dev/null; then
    echo -e "${GREEN}[✔] 网络连接正常 [✔]${NC}"
    echo ""
else
    echo -e "${RED}[✘] 请检查你的网络连接是否通畅[✘]"
    echo ""
    exit 1
fi
echo -e "[*]将hackingtool目录标记为安全目录"
git config --global --add safe.directory $install_dir
# Update the repository and the tool itself
echo -e "${BLUE}[INFO]\e[0m 升级工具中..."
if ! sudo git pull; then
    echo -e "${RED}[ERROR]\e[0m 升级工具失败."
    exit 1
fi

# Re-run the installation script
echo -e "${GREEN}[INFO]\e[0m 运行安装脚本..."
if ! sudo bash install.sh; then
    echo -e "${RED}[ERROR]\e[0m 运行安装脚本失败."
    exit 1
fi

echo -e "${GREEN}[SUCCESS]\e[0m 工具升级成功."
