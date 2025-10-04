#!/bin/bash

# U-Boot 环境配置
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

echo "配置 U-Boot 环境变量..."

# 创建 U-Boot 环境配置目录
mkdir -p package/boot/uboot-envtools/files

# 创建 IPQ50xx U-Boot 环境配置
cat > package/boot/uboot-envtools/files/ipq50xx << 'EOF'
# MTD device name   Device offset   Env. size   Flash sector size   Number of sectors
/dev/mtd10         0x0            0x10000      0x10000               1
EOF

echo "U-Boot 环境配置完成"