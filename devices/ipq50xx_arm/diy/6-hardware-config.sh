#!/bin/bash

# 硬件特定配置脚本
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

echo "配置硬件特定功能..."

# 创建基础文件目录结构
mkdir -p target/linux/ipq50xx/base-files/etc/board.d
mkdir -p target/linux/ipq50xx/base-files/etc/hotplug.d/firmware
mkdir -p target/linux/ipq50xx/base-files/etc/init.d

# 1. LED 配置
cat > target/linux/ipq50xx/base-files/etc/board.d/01_leds << 'EOF'
#!/bin/sh
# Copyright (C) 2024 OpenWrt.org

. /lib/functions.sh
. /lib/functions/leds.sh

board=$(board_name)

case "$board" in
redmi,ax3000|cmcc,rax3000q|xiaomi,cr881x)
	ucidef_set_led_netdev "wan" "WAN" "blue:wan" "eth1"
	;;
esac
EOF

# 2. 网络配置
cat > target/linux/ipq50xx/base-files/etc/board.d/02_network << 'EOF'
#!/bin/sh
# Copyright (C) 2024 OpenWrt.org

. /lib/functions.sh
. /lib/functions/uci-defaults.sh

board=$(board_name)

board_config_update

case "$board" in
redmi,ax3000|cmcc,rax3000q|xiaomi,cr881x)
	ucidef_set_interfaces_lan_wan "eth0" "eth1"
	ucidef_set_bridge_device switch lan
	ucidef_set_bridge_device wan
	;;
esac

board_config_flush
EOF

# 3. WiFi Board ID 配置
cat > target/linux/ipq50xx/base-files/etc/hotplug.d/firmware/10-ath11k-board_id << 'EOF'
#!/bin/sh
# Set board ID for ATH11K firmware

case "$DEVPATH" in
*/platform/soc@a000000/qdss*|*/platform/soc@a000000/ipq5018*|*/platform/soc@c000000/*)
    case "$BOARD" in
    redmi,ax3000|cmcc,rax3000q|xiaomi,cr881x)
        echo "board-qcn6122" > /tmp/board_id
        ;;
    esac
    ;;
esac
EOF

# 4. WiFi 校准数据配置
cat > target/linux/ipq50xx/base-files/etc/hotplug.d/firmware/11-ath11k-caldata << 'EOF'
#!/bin/sh
# Extract calibration data for ATH11K

[ "$ACTION" = "add" ] || exit 0

case "$DEVPATH" in
*/platform/soc@a000000/qdss*|*/platform/soc@a000000/ipq5018*|*/platform/soc@c000000/*)
    case "$BOARD" in
    redmi,ax3000|cmcc,rax3000q|xiaomi,cr881x)
        # Extract calibration data from appropriate MTD partitions
        [ -e /sys/class/mtd/mtd7/name ] && \
            [ "$(cat /sys/class/mtd/mtd7/name)" = "ART" ] && \
            mtd_debug read /dev/mtd7 0x1000 0x1000 /tmp/wifi.cal

        [ -e /tmp/wifi.cal ] && \
            mkdir -p /lib/firmware/ath11k/IPQ5018/ && \
            cp /tmp/wifi.cal /lib/firmware/ath11k/IPQ5018/board.bin
        ;;
    esac
    ;;
esac
EOF

# 5. U-Boot 环境管理脚本
cat > target/linux/ipq50xx/base-files/etc/init.d/uboot_env << 'EOF'
#!/bin/sh /etc/rc.common
# Copyright (C) 2024 OpenWrt.org

START=98
STOP=02

USE_PROCD=1

boot() {
    # Initialize U-Boot environment variables
    [ -e /dev/mtd10 ] || return 0

    # Set up dual-boot/OTA update variables
    fw_printenv -c /dev/mtd10 bootcount 2>/dev/null || fw_setenv -c /dev/mtd10 bootcount 0
    fw_printenv -c /dev/mtd10 bootpart 2>/dev/null || fw_setenv -c /dev/mtd10 bootpart 0

    # Configure network boot if needed
    fw_printenv -c /dev/mtd10 ipaddr 2>/dev/null || fw_setenv -c /dev/mtd10 ipaddr 192.168.1.1
    fw_printenv -c /dev/mtd10 serverip 2>/dev/null || fw_setenv -c /dev/mtd10 serverip 192.168.1.254
}

start_service() {
    # Runtime management of U-Boot environment
    return 0
}

stop_service() {
    # Cleanup before shutdown
    return 0
}
EOF

# 设置脚本权限
chmod +x target/linux/ipq50xx/base-files/etc/board.d/01_leds
chmod +x target/linux/ipq50xx/base-files/etc/board.d/02_network
chmod +x target/linux/ipq50xx/base-files/etc/hotplug.d/firmware/10-ath11k-board_id
chmod +x target/linux/ipq50xx/base-files/etc/hotplug.d/firmware/11-ath11k-caldata
chmod +x target/linux/ipq50xx/base-files/etc/init.d/uboot_env

echo "硬件特定配置完成"