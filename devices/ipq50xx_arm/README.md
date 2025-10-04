# IPQ50xx ARM 平台支持

## ⚠️ 重要：编译前必须准备文件

**当前状态**: 需要准备额外文件才能编译

- ✅ **基础编译**: 可以进行最小化编译 (功能受限)
- ❌ **完整编译**: 需要准备设备树、补丁和 WiFi 固件文件

📖 **详细准备指南**: 参见 [PREPARE.md](./PREPARE.md)

## 支持的设备

- **Redmi AX3000** (小米 AX3000 路由器)
- **小米 CR880x** (M79/M81 版本)
- **小米 CR881x**
- **CMCC RAX3000Q**

## 🚀 编译选项

### 选项 1: 最小化编译 (推荐用于测试)

1. 使用最小化配置:
   ```bash
   cp .config.minimal .config
   ```

2. 修改 settings.ini 使用最小脚本:
   ```ini
   DIY_SH="diy/0-minimal.sh"
   ```

3. 运行 GitHub Actions 或本地编译

**限制**:
- ❌ WiFi 功能受限 (VHT80 而非 HE160)
- ❌ 无硬件特定 LED 控制
- ❌ 无 OTA 更新支持

### 选项 2: 完整编译 (需要准备文件)

按照 [PREPARE.md](./PREPARE.md) 准备所有必需文件后，进行完整编译。

**支持**:
- ✅ 完整 WiFi 6E 功能 (HE160)
- ✅ 硬件 LED 控制
- ✅ OTA 更新
- ✅ U-Boot 环境管理

## 移植说明

### 文件结构

```
ipq50xx_arm/
├── .config              # 设备配置文件
├── diy.sh              # 主定制脚本
├── diy/
│   ├── 1-device-tree.sh      # 设备树文件复制脚本
│   ├── 2-platform-config.sh  # 平台配置脚本
│   └── 3-patches.sh          # 补丁复制脚本
└── patches/            # 存放补丁文件
```

### 手动需要复制的文件

为了完成移植，需要从 `openwrt-redmi-ax3000` 项目手动复制以下文件：

1. **设备树文件** (运行 `diy/1-device-tree.sh` 前需要复制)：
   ```
   openwrt-redmi-ax3000/target/linux/ipq50xx/dts/* → target/linux/ipq50xx/dts/
   ```

2. **内核补丁文件** (运行 `diy/3-patches.sh` 前需要复制)：
   ```
   openwrt-redmi-ax3000/target/linux/ipq50xx/patches/* → target/linux/ipq50xx/patches/
   ```

3. **WiFi 固件文件** (运行 `diy/4-wifi-firmware.sh` 后需要替换)：
   ```
   从原厂固件提取:
   - board-redmi_ax3000.ipq5018 → package/firmware/ipq-wifi/src/
   - board-redmi_ax3000.qcn6122 → package/firmware/ipq-wifi/src/
   ```

4. **基础文件**：
   ```
   openwrt-redmi-ax3000/target/linux/ipq50xx/base-files/* → target/linux/ipq50xx/base-files/
   ```

### WiFi 配置

- 2.4G: HT40 模式，自动信道
- 5G: HE160 模式，需要设置正确的国家代码、信道和带宽
- 160MHz 需要等待 1 分钟雷达检测

### 特性支持

- ✅ Boot 启动 (支持双分区 OTA 更新)
- ✅ 网络交换 (IPQ ESS 交换芯片)
- ✅ CPU 以太网 (千兆网口)
- ✅ LED 控制 (WAN 状态指示)
- ✅ U-Boot 环境管理
- ✅ WiFi 固件支持 (IPQ5018 + QCN6122)
- ❌ NSS NAT (不支持)
- ⚠️ 2.4G WiFi (无 NSS 卸载，需要提取固件)
- ⚠️ 5G WiFi (无 NSS 卸载，需要提取固件和正确配置)

### 构建配置

- 内核版本：Linux 5.15 LTS
- CPU：Cortex-A53
- 存储：NAND Flash
- 文件系统：SquashFS

### 注意事项

1. 首次构建前需要确保所有必要文件已复制
2. 5G WiFi 160MHz 需要正确设置地区代码和信道
3. 该平台不支持 NSS 硬件加速功能