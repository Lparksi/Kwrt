#!/bin/bash

# IPQ-WiFi 固件支持配置
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

echo "配置 IPQ-WiFi 固件支持..."

# 创建 WiFi 固件目录
mkdir -p package/firmware/ipq-wifi/src

# 添加 Redmi AX3000 到 IPQ-WiFi 支持列表
if [ -f "package/firmware/ipq-wifi/Makefile" ]; then
  if ! grep -q "redmi_ax3000" package/firmware/ipq-wifi/Makefile; then
    sed -i '/ipq5018-cmcc-rax3000q/a\\t$(call WifiFirmware,redmi_ax3000,IPQ5018,board-redmi_ax3000.ipq5018)' package/firmware/ipq-wifi/Makefile
    sed -i '/ipq5018-cmcc-rax3000q/a\\t$(call WifiFirmware,redmi_ax3000,QCN6122,board-redmi_ax3000.qcn6122)' package/firmware/ipq-wifi/Makefile
  fi
fi

# 创建 WiFi 固件文件占位符 (这些文件需要从原厂固件中提取)
echo "创建 WiFi 固件文件占位符..."
touch package/firmware/ipq-wifi/src/board-redmi_ax3000.ipq5018
touch package/firmware/ipq-wifi/src/board-redmi_ax3000.qcn6122

echo "IPQ-WiFi 固件支持配置完成"
echo "注意: 需要从原厂固件中提取实际的 WiFi 固件文件替换占位符文件"