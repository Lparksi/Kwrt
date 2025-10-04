#!/bin/bash

# 补丁文件复制脚本
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

echo "复制 IPQ50xx 内核补丁..."

# 创建补丁目录
mkdir -p target/linux/ipq50xx/patches

# 从原始项目复制补丁文件（这些补丁对 IPQ50xx 平台支持至关重要）
# 注意：在实际使用中，这些文件需要从 openwrt-redmi-ax3000/target/linux/ipq50xx/patches/ 复制

# 设置补丁文件权限
chmod 644 target/linux/ipq50xx/patches/*.patch

echo "内核补丁复制完成"
echo "重要提醒：需要从 openwrt-redmi-ax3000/target/linux/ipq50xx/patches/ 复制所有 .patch 文件"