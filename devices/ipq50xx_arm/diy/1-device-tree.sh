#!/bin/bash

# 设备树文件复制脚本
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

# 创建目标目录
mkdir -p target/linux/ipq50xx/dts

# 复制设备树文件源
echo "复制 IPQ50xx 设备树文件..."

# 从原始项目复制设备树文件（假设这些文件会被手动复制或通过脚本获取）
# 注意：在实际使用中，这些文件需要从 openwrt-redmi-ax3000 项目复制

# 设置设备树文件权限
chmod 644 target/linux/ipq50xx/dts/*.dts*
chmod 644 target/linux/ipq50xx/dts/*.dtsi

echo "设备树文件复制完成"