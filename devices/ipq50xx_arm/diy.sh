#!/bin/bash

# IPQ50xx ARM 平台定制脚本
shopt -s extglob
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

echo "开始 IPQ50xx ARM 平台定制..."

# 应用通用内核配置
if [ -f "$SHELL_FOLDER/../common/kernel_6.6.sh" ]; then
    bash $SHELL_FOLDER/../common/kernel_6.6.sh
fi

# 执行设备树文件配置
if [ -f "$SHELL_FOLDER/diy/1-device-tree.sh" ]; then
    bash $SHELL_FOLDER/diy/1-device-tree.sh
fi

# 执行平台配置
if [ -f "$SHELL_FOLDER/diy/2-platform-config.sh" ]; then
    bash $SHELL_FOLDER/diy/2-platform-config.sh
fi

# 应用补丁
if [ -f "$SHELL_FOLDER/diy/3-patches.sh" ]; then
    bash $SHELL_FOLDER/diy/3-patches.sh
fi

# 配置 WiFi 固件支持
if [ -f "$SHELL_FOLDER/diy/4-wifi-firmware.sh" ]; then
    bash $SHELL_FOLDER/diy/4-wifi-firmware.sh
fi

# 配置 U-Boot 环境
if [ -f "$SHELL_FOLDER/diy/5-uboot-env.sh" ]; then
    bash $SHELL_FOLDER/diy/5-uboot-env.sh
fi

# 配置硬件特定功能
if [ -f "$SHELL_FOLDER/diy/6-hardware-config.sh" ]; then
    bash $SHELL_FOLDER/diy/6-hardware-config.sh
fi

# 设备特定修改
# 修改固件名称为 kwrt
if [ -f "target/linux/ipq50xx/image/Makefile" ]; then
    sed -i "s/openwrt-ipq50xx/kwrt-ipq50xx/g" target/linux/ipq50xx/image/Makefile
fi

# 移除 stock 后缀
if [ -d "target/linux/ipq50xx/base-files/" ]; then
    find target/linux/ipq50xx/base-files/ -type f -exec sed -i "s/-stock//g" {} \;
fi

# 设置默认 WiFi 配置
mkdir -p package/kernel/mac80211/files/lib/wifi
cat > package/kernel/mac80211/files/lib/wifi/mac80211.sh << 'EOF'
append mac80211 "radio0" data
    option band '2g'
    option channel 'auto'
    option htmode 'HT40'
    option noscan '1'
    list ht_capab '[LDPC]'
    list ht_capab '[SHORT-GI-20]'
    list ht_capab '[SHORT-GI-40]'
    list ht_capab '[TX-STBC]'
    list ht_capab '[RX-STBC1]'
    list ht_capab '[DSSS_CCK-40]'

append mac80211 "radio1" data
    option band '5g'
    option channel 'auto'
    option htmode 'HE160'
    option noscan '1'
    option country 'CN'
    list ht_capab '[LDPC]'
    list ht_capab '[SHORT-GI-20]'
    list ht_capab '[SHORT-GI-40]'
    list ht_capab '[TX-STBC]'
    list ht_capab '[RX-STBC1]'
    list ht_capab '[DSSS_CCK-40]'
    list vht_capab '[MAX-MPDU-11454]'
    list vht_capab '[RXLDPC]'
    list vht_capab '[SHORT-GI-80]'
    list vht_capab '[TX-STBC-2BY1]'
    list vht_capab '[SU-BEAMFORMER]'
    list vht_capab '[SU-BEAMFORMEE]'
    list vht_capab '[MU-BEAMFORMER]'
    list vht_capab '[MU-BEAMFORMEE]'
    list vht_capab '[RX-ANTENNA-PATTERN]'
    list vht_capab '[TX-ANTENNA-PATTERN]'
    list he_capab '[HE-LTF-GI-4X]'
    list he_capab '[HE-PPDU-20US-IN-2G]'
    list he_capab '[HE-TWT]'
EOF

echo "IPQ50xx ARM 定制完成！"
echo "支持的设备: Redmi AX3000, 小米 CR880x, CR881x, CMCC RAX3000Q"