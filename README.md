<p align="center"><img src="public/tokenxiu.png" alt="TokenXiu Connect" width="96"></p>

# TokenXiu Connect

TokenXiu 的 Claude 和 Codex 本地 API 配置工具。默认连接 [TokenXiu](https://tokenxiu.com)，也可以添加其他兼容的中转站。

## 下载与安装

在 [Releases](https://github.com/xjoey1957/tokenxiu-connect/releases/latest) 下载适合电脑的软件：

| 系统 | 软件 | 使用方法 |
| --- | --- | --- |
| Windows 10 / 11 x64 | [Windows x64 portable ZIP](https://github.com/xjoey1957/tokenxiu-connect/releases/download/tokenxiu-v0.1.6/TokenXiu-Connect-0.1.6-Windows-x64-portable.zip) | 将压缩包完整解压，双击 `TokenXiu Connect.exe` |
| macOS Apple Silicon | [macOS arm64 ZIP](https://github.com/xjoey1957/tokenxiu-connect/releases/download/tokenxiu-v0.1.6/TokenXiu-Connect-0.1.6-macOS-arm64.zip) | 解压后打开 `TokenXiu Connect.app`，也可以拖到“应用程序” |

Mac 版本支持 Apple Silicon，不支持 Intel Mac。Windows 需要 WebView2 Runtime；如果电脑缺少，请从 [Microsoft 官方页面](https://developer.microsoft.com/microsoft-edge/webview2/)安装。运行软件无需安装 Node.js 或 Rust。Windows 软件未进行发布者签名，macOS 软件仅使用 ad-hoc 签名、未经过 Apple 公证，系统可能显示安全提示。Release 中的 `SHA256SUMS.txt` 可用于检查下载完整性。

## 接入 TokenXiu

1. 在 [TokenXiu](https://tokenxiu.com) 获取自己的 API Key，并确认账号有可用额度与模型权限。
2. 打开软件，选择默认的 **TokenXiu**，或者自行添加兼容站点。TokenXiu API 地址为 `https://tokenxiu.com/v1`。
3. 选择 Claude 或 Codex 及相应客户端，输入 TokenXiu 的 API Key，点击获取模型。
4. 勾选需要的模型，选择默认模型，检查导入预览并点击导入。
5. 完全退出客户端后重新打开，新建会话并发送测试消息。Claude 桌面版可能仍在系统托盘中，需从托盘退出。
6. 如需撤回，在软件中选择“恢复原配置”。恢复记录可能含有原凭据，请勿分享。

软件支持 Claude 桌面版、Claude Code 终端版和 VS Code 扩展，以及 Codex 桌面版和终端版；客户端须另行安装。具体可用性取决于客户端版本、站点支持的协议、模型和账号权限。获取模型列表或导入成功不代表对话、图片和工具调用已在你的线路上验证。

程序只保存站点名称和地址；密钥在导入时写入目标客户端所需的本地配置。修改前会备份，恢复记录保存在用户目录的 `.tokenxiu-connect`。恢复操作针对本地文件，不会撤销服务端密钥。不要在反馈中提供 API Key 或认证文件。

## 开发与构建

需要 Node.js 22+、pnpm 10 和稳定版 Rust。Windows 需要 MSVC Build Tools、Windows SDK；macOS 需要 Xcode Command Line Tools。

```sh
pnpm install --frozen-lockfile
pnpm test:ui
pnpm build:web
cargo test --manifest-path src-tauri/Cargo.toml --no-default-features --locked
# 在 Windows 上构建免安装 ZIP
pnpm build:windows
# 在 macOS 上构建 Apple Silicon ZIP
rustup target add aarch64-apple-darwin
pnpm build:macos
```

构建产物位于 `release/`。跨平台验证与打包由 GitHub Actions 在对应系统执行。

## 开源来源

本项目基于 CC Switch 的部分代码。原作者的版权及 MIT 许可保留在 [LICENSE](LICENSE) 和 [licenses](licenses/) 中，来源详见 [UPSTREAM.md](UPSTREAM.md)。本项目与 Claude、Codex 官方无关联。
