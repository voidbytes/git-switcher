# 隐私政策 / Privacy Policy

生效日期（Effective Date）：2026-08-11

本政策适用于 Windows 应用 **Git Switcher（Git 账号切换器）**（以下简称"本应用"），发布方：voidbytes。

## 一、我们收集哪些信息

本应用**不收集、不存储、不上传**任何个人信息。本应用完全在您的设备本地运行，无账户系统、无登录、无分析统计 SDK、无广告 SDK，也不与任何服务器通信。

## 二、数据存储

本应用的配置数据与备份文件仅保存在您自己的设备上：

- 配置文件：`%USERPROFILE%\.git_switcher\config.json`
- 备份文件：`%USERPROFILE%\.git_switcher\backup\`

所有数据均保存在本地，不会传输到外部服务器。

## 三、对 Git 与 SSH 配置文件的访问

为了完成"账号切换"功能，本应用需要在您明确点击"切换"操作后，读写以下本地文件：

- `%USERPROFILE%\.gitconfig`（Git 全局用户配置）
- `%USERPROFILE%\.ssh\config`（SSH 客户端配置）

每次切换前，本应用会自动备份原文件到本地备份目录，您可以随时恢复。本应用不会在未经您操作的情况下修改这些文件，也不会读取您的 SSH 私钥内容。

## 四、权限说明

本应用仅申请运行所需的系统能力（完整信任以读写上述本地配置文件），不申请网络、摄像头、麦克风、通讯录等任何无关权限。

## 五、数据共享

本应用不与任何第三方共享您的数据。应用内无广告 SDK、无分析统计 SDK、无第三方支付，您的数据不会离开您的设备。

## 六、数据保留与您的权利

本应用保存的所有数据均在您自己的设备上，您可以随时查看或删除：卸载本应用或手动删除上述配置与备份文件，即完成数据清除，无需向我们提出请求。如您对数据处理有任何疑问或请求（包括查询、更正、删除），可通过下方联系方式联系我们，我们将在合理时间内处理。

## 七、第三方链接

本应用的"关于"页面包含项目主页（GitHub）链接，点击链接将打开您的默认浏览器，由此产生的行为由对应第三方服务商的政策约束。

## 八、未成年人

本应用面向开发者工具场景，不针对未成年人设计，也不会收集未成年人的任何信息。

## 九、政策变更

如本政策发生变更，我们会在本页面更新并修改"生效日期"。

## 十、联系我们

如有隐私相关问题，请联系：

- 发布方：voidbytes
- 邮箱：ryan.h.qin@gmail.com
- 项目地址：https://github.com/voidbytes/git-switcher

---

# Privacy Policy (English)

Effective Date: 2026-08-11

This policy applies to the Windows application **Git Switcher** (the "App"), published by voidbytes.

## 1. What information we collect

The App **does not collect, store, or upload any personal information**. The App runs entirely locally on your device. There is no account system, no analytics SDK, no advertising SDK, and no communication with any server.

## 2. Data storage

The App's configuration and backup files are stored only on your own device:

- Config file: `%USERPROFILE%\.git_switcher\config.json`
- Backups: `%USERPROFILE%\.git_switcher\backup\`

All data remains local and is never transmitted off-device.

## 3. Access to Git and SSH configuration files

To perform the "profile switching" feature, the App reads and writes the following local files only when you explicitly click "Switch":

- `%USERPROFILE%\.gitconfig` (Git global user configuration)
- `%USERPROFILE%\.ssh\config` (SSH client configuration)

Before every switch, the App automatically backs up the original files to the local backup directory, and you can restore them at any time. The App never modifies these files without your action, and never reads the content of your SSH private keys.

## 4. Permissions

The App only requests the capabilities needed to run (full trust for reading/writing the local config files listed above). It does not request network, camera, microphone, contacts, or any other unrelated permissions.

## 5. Data sharing

The App does not share your data with any third party. There is no advertising SDK, no analytics SDK, and no third-party payment in the App. Your data never leaves your device.

## 6. Data retention and your rights

All data saved by the App resides on your own device. You can review or delete it at any time: uninstalling the App or manually deleting the config and backup files mentioned above removes all data, with no need to contact us. If you have any questions or requests regarding data processing (including access, correction, or deletion), please contact us using the details below; we will respond within a reasonable time.

## 7. Third-party links

The "About" dialog contains links to the project page (GitHub). Clicking them opens your default browser; subsequent behavior is governed by the respective third-party providers' policies.

## 8. Children

The App is a developer tool and is not designed for children; it does not collect any information from children.

## 9. Policy changes

If this policy changes, we will update this page and revise the "Effective Date".

## 10. Contact

For privacy questions, please contact:

- Publisher: voidbytes (mainland China)
- Email: ryan.h.qin@gmail.com
- Project: https://github.com/voidbytes/git-switcher
