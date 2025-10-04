# IPQ50xx ARM 固件构建说明

## GitHub Actions 构建方式

### 专用构建 Workflow

我们创建了专门用于构建 IPQ50xx ARM 固件的 Workflow：`build-ipq50xx-arm.yml`

#### 触发方式

1. **手动触发构建**：
   - 进入 GitHub 仓库的 Actions 页面
   - 选择 "Build IPQ50xx ARM Firmware" workflow
   - 点击 "Run workflow"
   - 配置构建参数：
     - **释放磁盘空间**: 是否清理构建环境 (默认: true)
     - **上传到 Release**: 是否创建 GitHub Release (默认: false)
     - **上传到 Artifacts**: 是否上传到构建产物 (默认: true)
     - **上传到 WeTransfer**: 是否上传到 WeTransfer (默认: true)
     - **自定义版本号**: 可选的版本标识

#### 构建参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| free_up_disk | 释放磁盘空间，避免构建失败 | true |
| upload_release | 创建 GitHub Release，包含固件文件 | false |
| upload_artifact | 上传到 GitHub Actions Artifacts | true |
| upload_wetransfer | 上传到 WeTransfer 文件分享 | true |
| custom_version | 自定义版本标识 | 空字符串 |

#### 构建输出

- **Artifacts**: 在 Actions 页面下载，保留 30 天
- **Release**: 创建永久存储的 Release (如果启用)
- **WeTransfer**: 生成临时分享链接 (如果启用)

#### 支持的设备

- **Redmi AX3000** - 小米 AX3000 路由器
- **小米 CR880x** - M79/M81 版本
- **小米 CR881x** - CR881x 系列路由器
- **CMCC RAX3000Q** - 移动 RAX3000Q 路由器

#### 固件特性

- ✅ Linux 5.15 LTS 内核
- ✅ WiFi 6 (802.11ax) 支持
- ✅ 5G WiFi 160MHz 带宽
- ✅ NAND Flash 支持
- ✅ 完整的网络功能
- ❌ NSS 硬件加速 (不支持)
- ⚠️ 需要 160MHz WiFi 正确配置地区代码

### 构建时间

- **预计时间**: 1-3 小时
- **并行任务**: 单目标构建
- **磁盘空间**: 建议 25GB+

### 构建日志

构建过程中会显示详细的构建信息，包括：
- 内核编译进度
- 软件包安装状态
- 固件打包过程
- 上传结果

### 故障排除

1. **磁盘空间不足**: 启用 "释放磁盘空间" 选项
2. **网络问题**: GitHub Actions 会有自动重试机制
3. **编译失败**: 检查 OpenWrt 源码更新和依赖版本

### 本地构建

如需本地构建，请参考项目根目录的 README 文档，使用标准的 OpenWrt 构建流程。

## 自动化构建

此 workflow 还支持通过 API 触发自动化构建：

```bash
curl -X POST https://api.github.com/repos/[用户名]/Kwrt/dispatches \
  -H "Accept: application/vnd.github.everest-preview+json" \
  -H "Authorization: token [YOUR_TOKEN]" \
  -d '{
    "event_type": "build-ipq50xx-arm",
    "client_payload": {
      "target": "ipq50xx_arm",
      "upload_release": "true",
      "custom_version": "v1.0.0"
    }
  }'
```

---

**注意**: 首次构建前请确保已按照 README.md 中的说明复制了所有必要的设备树文件和内核补丁。