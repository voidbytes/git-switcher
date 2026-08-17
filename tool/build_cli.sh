#!/bin/bash
# 构建纯 Dart 命令行工具（git-switcher CLI）。
#
# 说明：仓库根 pubspec.yaml 依赖 Flutter SDK，`dart pub get` 在无 Flutter 的环境会失败。
# 本脚本临时用纯 Dart pubspec 生成 package_config（仅依赖 uuid），
# 随后恢复原 pubspec 并 `dart compile exe` 产出独立二进制。
#
# 用法：
#   tool/build_cli.sh [输出路径]     # 默认输出到 repo 根目录 ./git-switcher
set -e
cd "$(dirname "$0")/.."

OUT="${1:-$(pwd)/git-switcher}"

echo "==> 备份原 pubspec.yaml"
cp pubspec.yaml .pubspec.full.yaml
trap 'mv -f .pubspec.full.yaml pubspec.yaml 2>/dev/null || true' EXIT

echo "==> 写入纯 Dart pubspec（仅依赖 uuid）"
cat > pubspec.yaml <<'EOF'
name: git_switcher
description: Git Switcher core (pure Dart build for CLI).
publish_to: none
version: 1.0.0+1
environment:
  sdk: ^3.9.0
dependencies:
  uuid: ^4.5.1
EOF

echo "==> dart pub get"
dart pub get

echo "==> 恢复原 pubspec.yaml"
mv .pubspec.full.yaml pubspec.yaml

echo "==> dart compile exe -> $OUT"
dart compile exe bin/git_switcher.dart -o "$OUT"

echo "==> 构建完成: $OUT"
ls -la "$OUT"