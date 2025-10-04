#!/bin/bash

# 最小化构建脚本 - 跳过硬件特定功能
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

echo "运行最小化 IPQ50xx ARM 配置..."

# 只执行基础配置
# 1. 平台配置
if [ -f "$SHELL_FOLDER/diy/2-platform-config.sh" ]; then
    bash $SHELL_FOLDER/diy/2-platform-config.sh
fi

# 基础设备修改
# 修改固件名称为 kwrt
if [ -f "target/linux/ipq50xx/image/Makefile" ]; then
    sed -i "s/openwrt-ipq50xx/kwrt-ipq50xx/g" target/linux/ipq50xx/image/Makefile
fi

# 移除 stock 后缀
if [ -d "target/linux/ipq50xx/base-files/" ]; then
    find target/linux/ipq50xx/base-files/ -type f -exec sed -i "s/-stock//g" {} \;
fi

# 设置基础 WiFi 配置 (不依赖特定固件)
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

append mac80211 "radio1" data
    option band '5g'
    option channel 'auto'
    option htmode 'VHT80'
    option noscan '1'
    option country 'CN'
    list ht_capab '[LDPC]'
    list ht_capab '[SHORT-GI-20]'
    list ht_capab '[SHORT-GI-40]'
    list ht_capab '[TX-STBC]'
    list ht_capab '[RX-STBC1]'
    list vht_capab '[MAX-MPDU-11454]'
    list vht_capab '[RXLDPC]'
    list vht_capab '[SHORT-GI-80]'
    list vht_capab '[TX-STBC-2BY1]'
EOF

echo "最小化配置完成！"
echo "注意: WiFi 功能可能受限，需要完整的设备树和固件文件"