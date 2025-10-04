#!/bin/bash

# IPQ50xx ARM 平台定制脚本
shopt -s extglob
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

# 应用通用内核配置
bash $SHELL_FOLDER/../common/kernel_6.6.sh

# 设备特定修改
# 修改固件名称为 kwrt
sed -i "s/openwrt-ipq50xx/kwrt-ipq50xx/g" target/linux/ipq50xx/image/Makefile

# 移除 stock 后缀
find target/linux/ipq50xx/base-files/ -type f -exec sed -i "s/-stock//g" {} \;

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

echo "IPQ50xx ARM 定制完成"