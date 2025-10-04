# IPQ50xx ARM 构建准备指南

## ❗ 重要：必须先准备这些文件才能编译

### 📋 必需文件清单

#### 1. 设备树文件 (DTS) - 从 openwrt-redmi-ax3000 获取

```bash
# 克隆源项目
git clone https://github.com/hzyitc/openwrt-redmi-ax3000.git

# 复制设备树文件到 Kwrt 工作目录
cp -r openwrt-redmi-ax3000/target/linux/ipq50xx/dts/* Kwrt/openwrt/target/linux/ipq50xx/dts/
```

#### 2. 内核补丁文件 - 从 openwrt-redmi-ax3000 获取

```bash
# 复制补丁文件
cp -r openwrt-redmi-ax3000/target/linux/ipq50xx/patches/* Kwrt/openwrt/target/linux/ipq50xx/patches/
```

#### 3. WiFi 固件文件 - 从原厂固件提取

**方法 1: 从原厂固件提取**
```bash
# 下载 Redmi AX3000 原厂固件
# 解压固件，从 /firmware 分区提取以下文件：
# - board-redmi_ax3000.ipq5018
# - board-redmi_ax3000.qcn6122

# 复制到固件目录
cp board-redmi_ax3000.ipq5018 Kwrt/openwrt/package/firmware/ipq-wifi/src/
cp board-redmi_ax3000.qcn6122 Kwrt/openwrt/package/firmware/ipq-wifi/src/
```

**方法 2: 使用在线资源**
```bash
# 从固件数据库下载（如果可用）
wget -O Kwrt/openwrt/package/firmware/ipq-wifi/src/board-redmi_ax3000.ipq5018 [URL]
wget -O Kwrt/openwrt/package/firmware/ipq-wifi/src/board-redmi_ax3000.qcn6122 [URL]
```

#### 4. 基础文件 (推荐)

```bash
# 复制基础文件
cp -r openwrt-redmi-ax3000/target/linux/ipq50xx/base-files/* Kwrt/openwrt/target/linux/ipq50xx/base-files/
```

### 🔧 自动化准备脚本

创建一个准备脚本来自动复制文件：

```bash
#!/bin/bash
# prepare-ipq50xx.sh

echo "准备 IPQ50xx ARM 构建文件..."

# 检查 openwrt-redmi-ax3000 目录
if [ ! -d "openwrt-redmi-ax3000" ]; then
    echo "克隆 openwrt-redmi-ax3000 项目..."
    git clone https://github.com/hzyitc/openwrt-redmi-ax3000.git
fi

# 检查 Kwrt 工作目录
if [ ! -d "Kwrt/openwrt" ]; then
    echo "错误: 请先运行 Kwrt 构建流程生成 openwrt 目录"
    exit 1
fi

# 复制设备树文件
echo "复制设备树文件..."
cp -r openwrt-redmi-ax3000/target/linux/ipq50xx/dts/* Kwrt/openwrt/target/linux/ipq50xx/dts/

# 复制补丁文件
echo "复制内核补丁..."
cp -r openwrt-redmi-ax3000/target/linux/ipq50xx/patches/* Kwrt/openwrt/target/linux/ipq50xx/patches/

# 复制基础文件
echo "复制基础文件..."
cp -r openwrt-redmi-ax3000/target/linux/ipq50xx/base-files/* Kwrt/openwrt/target/linux/ipq50xx/base-files/

echo "基础文件准备完成！"
echo ""
echo "⚠️  还需要手动获取 WiFi 固件文件："
echo "   - board-redmi_ax3000.ipq5018"
echo "   - board-redmi_ax3000.qcn6122"
echo ""
echo "请将这两个文件复制到: Kwrt/openwrt/package/firmware/ipq-wifi/src/"
```

### 🚀 构建流程

#### 准备阶段：
1. 克隆 Kwrt 项目
2. 运行 GitHub Actions 或本地构建生成 OpenWrt 源码
3. 执行上述准备脚本复制必要文件
4. 获取 WiFi 固件文件

#### 编译阶段：
1. 重新运行构建流程
2. 设备树和补丁会自动应用
3. WiFi 固件会自动打包

### 🔍 验证文件完整性

编译前检查这些文件是否存在：

```bash
# 设备树文件
ls -la Kwrt/openwrt/target/linux/ipq50xx/dts/ipq5018.dtsi
ls -la Kwrt/openwrt/target/linux/ipq50xx/dts/ipq5000-ax3000.dts

# 补丁文件数量
ls Kwrt/openwrt/target/linux/ipq50xx/patches/ | wc -l  # 应该有 45+ 个文件

# WiFi 固件文件
ls -la Kwrt/openwrt/package/firmware/ipq-wifi/src/board-redmi_ax3000.ipq5018
ls -la Kwrt/openwrt/package/firmware/ipq-wifi/src/board-redmi_ax3000.qcn6122
```

### ⚠️ 常见问题

1. **WiFi 固件缺失** - 固件编译会失败，找不到 WiFi 芯片支持
2. **设备树缺失** - 设备无法启动，硬件配置错误
3. **补丁缺失** - 内核可能缺少 IPQ50xx 特定支持

### 📞 获取帮助

- **设备树问题**: 参考 openwrt-redmi-ax3000 项目的设备树配置
- **WiFi 固件**: 查看 OpenWrt Wiki 或固件提取教程
- **内核补丁**: 检查 Linux 内核 IPQ50xx 支持状态

---

**总结**: 必须先获取这些文件才能成功编译，建议使用自动化准备脚本简化流程。