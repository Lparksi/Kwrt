# IPQ50xx ARM 平台支持

## 支持的设备

- **Redmi AX3000** (小米 AX3000 路由器)
- **小米 CR880x** (M79/M81 版本)
- **小米 CR881x**
- **CMCC RAX3000Q**

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

3. **基础文件**：
   ```
   openwrt-redmi-ax3000/target/linux/ipq50xx/base-files/* → target/linux/ipq50xx/base-files/
   ```

### WiFi 配置

- 2.4G: HT40 模式，自动信道
- 5G: HE160 模式，需要设置正确的国家代码、信道和带宽
- 160MHz 需要等待 1 分钟雷达检测

### 特性支持

- ✅ Boot 启动
- ✅ 网络交换
- ✅ CPU 以太网
- ❌ NSS NAT (不支持)
- ⚠️ 2.4G WiFi (无 NSS 卸载)
- ⚠️ 5G WiFi (无 NSS 卸载，需要正确配置)

### 构建配置

- 内核版本：Linux 5.15 LTS
- CPU：Cortex-A53
- 存储：NAND Flash
- 文件系统：SquashFS

### 注意事项

1. 首次构建前需要确保所有必要文件已复制
2. 5G WiFi 160MHz 需要正确设置地区代码和信道
3. 该平台不支持 NSS 硬件加速功能