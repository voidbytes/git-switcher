# Git 账号切换器 (Git Switcher)

一款使用 Flutter 开发的跨平台 Git 账号和 SSH 配置快速切换工具，可以在多个 Git 账号（如个人账号、工作账号）之间高效、安全地进行切换。

## 核心功能

* **多配置管理**：轻松新建、修改、删除和查看多个 Git 账号配置。
* **一键快速切换**：在不同的 Git 和 SSH 配置之间实现一键切换，无需手动编辑文件。
* **自动备份与恢复**：
    * 每次切换配置时，自动备份当前的 `.gitconfig` 和 `.ssh/config` 文件。
    * 提供备份列表，可随时恢复到任一历史版本。
    * 可自定义是否启用备份及最大备份数量。
* **配置状态校验**：
    * 自动检测当前系统的 Git/SSH 配置与哪个预设的配置相匹配。
    * 切换前检查 SSH 配置冲突，并提供确认提示，防止误操作。
    * 校验 SSH 私钥文件的存在性和权限（在 Linux/macOS 下应为 600），确保配置的有效性。
* **跨平台支持**：兼容 Windows、macOS 和 Linux 操作系统
* **示例配置（无账号体验）**：首次启动引导页提供“体验示例配置”，一键导入 2 个内置示例配置，无需注册任何账号即可完整体验新建、切换、备份、恢复、查看差异、撤销等全部功能。
* **命令行工具 (CLI)**：附带与 GUI 功能一致的纯 Dart 命令行工具，支持 `--json` 结构化输出、`--home` 隔离目录、`--lang`、`--log-level`，便于脚本化与自动化测试（详见 `docs/product-tech-spec-v1.0.md` 第 15 章）。

## 如何使用

1.  **启动应用**：打开应用后，您会看到主界面。
2.  **创建配置**：
    * 点击右下角的“+”按钮，进入新建配置页面。
    * **配置名称**：为您的配置起一个易于识别的名称，如“工作账号”。
    * **Git 配置内容**：可以直接粘贴您的 `.gitconfig` 文件内容，或仅包含 `[user]` 部分的核心配置。
    * **启用 SSH** (可选)：
        * 如果您的 Git 仓库使用 SSH 协议，请勾选此项。
        * **主机名**：填写 Git 平台的主机名，如 `github.com`。
        * **SSH 私钥路径**：指定与该账号对应的 SSH 私钥文件路径，如 `~/.ssh/id_rsa_work`。您可以点击文件夹图标进行选择。
    * 点击“保存”。
3.  **切换配置**：
    * 在主界面列表中，找到您想切换到的配置。
    * 点击右侧的“切换”图标 ( ⇄ )。
    * 应用将自动完成备份和配置更新，并通过提示消息告知您结果。
4.  **备份管理**：
    * 点击主界面右下角的“备份”图标，进入备份管理页面。
    * 这里会按时间顺序列出所有的历史备份。
    * 您可以预览任一备份的内容，或选中某个版本进行恢复。
5.  **设置**：
    * 点击主界面右上角的“设置”图标。
    * 在这里您可以开关自动备份功能，并设置希望保留的备份文件数量。

## 数据存储

* **配置文件**：应用的所有配置都以 JSON 格式存储在您的用户主目录下的 `.git_switcher` 文件夹中。
    * **Windows**: `%USERPROFILE%\.git_switcher\config.json`
    * **Linux/macOS**: `~/.git_switcher/config.json`
* **备份文件**：所有的备份文件也存放在 `.git_switcher/backup` 目录下，并按 git 和 ssh 分类。
* **日志文件**：分级日志按天写入 `~/.git_switcher/logs/git-switcher-YYYY-MM-DD.log`。

## 命令行工具

项目附带纯 Dart 命令行工具 `bin/git_switcher.dart`，与 GUI 功能一致，无需 Flutter 环境即可编译运行。

```bash
# 构建（需要 Dart SDK）
./tool/build_cli.sh ./git-switcher

# 查看帮助
./git-switcher help

# 列出配置（JSON 格式）
./git-switcher --json list

# 一键切换（使用隔离目录，不碰真实 ~/.gitconfig）
./git-switcher --home /tmp/test-home switch work

# 撤销上次切换
./git-switcher undo

# 使用中文输出
./git-switcher --lang zh list

# 设置日志级别
./git-switcher --log-level debug list
```

完整子命令列表见 `docs/product-tech-spec-v1.0.md` 第 15 章。

## License

本软件使用 **GNU General Public License v2.0** 授权。

