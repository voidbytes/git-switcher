#!/bin/bash
# 远程回归测试：Git Switcher CLI 全功能验证（含微软商店示例配置 demo 场景）
#
# 用法：bash regress_demo.sh <CLI二进制路径>
# 每组用例用独立 --home 目录隔离，互不干扰（遵循 docs/remote-build-test-guide.md）。
#
# 注意：CLI 日志输出到 stderr，--json 模式 stdout 仅输出 JSON。
#       因此 JSON 断言只捕获 stdout 并提取首个 '{' 开头的行。

set -e

CLI="$1"
if [ -z "$CLI" ]; then
  echo "用法: bash regress_demo.sh <CLI二进制路径>"
  exit 1
fi

DATA_DIR="/tmp/git-sw-regress-data"
rm -rf "$DATA_DIR"
mkdir -p "$DATA_DIR"

echo "================================================"
echo " Git Switcher CLI 全功能回归测试"
echo " CLI: $CLI"
echo " DATA: $DATA_DIR"
echo "================================================"

PASS=0
FAIL=0

# 断言命令退出码。
assert_exit() {
  local desc="$1"
  local expected="$2"
  shift 2
  local output actual
  if output=$("$@" 2>&1); then
    actual=0
  else
    actual=$?
  fi
  if [ "$actual" = "$expected" ]; then
    echo "  PASS: $desc (exit=$actual)"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (expected exit=$expected, got=$actual)"
    echo "    output: $output"
    FAIL=$((FAIL + 1))
  fi
}

# 提取 stdout 中首个 JSON 行（对象以 { 开头，数组以 [ 开头）。
json_line_of() {
  echo "$1" | grep -m1 '^[{[]' || echo ""
}

# 断言 JSON 输出中某字段等于期望值。
assert_json_field() {
  local desc="$1"
  local expected="$2"
  local field="$3"
  shift 3
  local output json_line got
  output=$("$@" 2>/dev/null) || true
  json_line=$(json_line_of "$output")
  got=$(echo "$json_line" | python3 -c "
import sys, json
try:
    print(json.load(sys.stdin).get('$field', '__MISSING__'))
except Exception:
    print('__PARSE_ERR__')
")
  if [ "$got" = "$expected" ]; then
    echo "  PASS: $desc (json.$field=$expected)"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (json.$field expected=$expected, got=$got)"
    echo "    raw: $json_line"
    FAIL=$((FAIL + 1))
  fi
}

# 断言 JSON 数组输出长度。
assert_json_array_len() {
  local desc="$1"
  local expected_len="$2"
  shift 2
  local output json_line got
  output=$("$@" 2>/dev/null) || true
  json_line=$(json_line_of "$output")
  got=$(echo "$json_line" | python3 -c "
import sys, json
try:
    print(len(json.load(sys.stdin)))
except Exception:
    print('__PARSE_ERR__')
")
  if [ "$got" = "$expected_len" ]; then
    echo "  PASS: $desc (len=$expected_len)"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (expected len=$expected_len, got=$got)"
    echo "    raw: $json_line"
    FAIL=$((FAIL + 1))
  fi
}

# --------------------------------------------------------------------------
# Step 0: 准备示例 gitconfig 文件
# --------------------------------------------------------------------------
echo ""
echo "--- Step 0: 准备示例 gitconfig 文件 ---"

cat > "$DATA_DIR/gitconfig_work.txt" << 'EOF'
[user]
    name = Alex Johnson
    email = alex.johnson@company.example.com
EOF

cat > "$DATA_DIR/gitconfig_personal.txt" << 'EOF'
[user]
    name = Alex
    email = alex.personal@gmail.com
EOF

echo "  文件就绪"

# --------------------------------------------------------------------------
# 1. help / version
# --------------------------------------------------------------------------
echo ""
echo "--- Test 1: help / version ---"
H1="$DATA_DIR/t1"
assert_exit "help" 0 "$CLI" --home "$H1" help
assert_exit "version" 0 "$CLI" --home "$H1" version
assert_json_field "version --json" "1.0.0" "version" "$CLI" --home "$H1" --json version

# --------------------------------------------------------------------------
# 2. add（添加两个示例 Profile）
# --------------------------------------------------------------------------
echo ""
echo "--- Test 2: add profiles ---"
H2="$DATA_DIR/t2"
mkdir -p "$H2"
assert_exit "add work" 0 "$CLI" --home "$H2" add work --git "$DATA_DIR/gitconfig_work.txt"
assert_exit "add personal" 0 "$CLI" --home "$H2" add personal --git "$DATA_DIR/gitconfig_personal.txt"
assert_exit "add duplicate name" 1 "$CLI" --home "$H2" add work --git "$DATA_DIR/gitconfig_work.txt"
assert_json_field "add --json success" "True" "success" "$CLI" --home "$H2" --json add newone --git "$DATA_DIR/gitconfig_work.txt"

# --------------------------------------------------------------------------
# 3. list
# --------------------------------------------------------------------------
echo ""
echo "--- Test 3: list ---"
H3="$DATA_DIR/t3"
mkdir -p "$H3"
"$CLI" --home "$H3" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
"$CLI" --home "$H3" add personal --git "$DATA_DIR/gitconfig_personal.txt" >/dev/null 2>&1
assert_exit "list" 0 "$CLI" --home "$H3" list
assert_json_array_len "list --json len=2" "2" "$CLI" --home "$H3" --json list

# --------------------------------------------------------------------------
# 4. switch
# --------------------------------------------------------------------------
echo ""
echo "--- Test 4: switch ---"
H4="$DATA_DIR/t4"
mkdir -p "$H4"
"$CLI" --home "$H4" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
"$CLI" --home "$H4" add personal --git "$DATA_DIR/gitconfig_personal.txt" >/dev/null 2>&1
assert_exit "switch to work" 0 "$CLI" --home "$H4" switch work
assert_json_field "switch to work --json" "True" "success" "$CLI" --home "$H4" --json switch work
assert_json_field "status active=work" "work" "activeProfileName" "$CLI" --home "$H4" --json status

# 验证切换确实写入了隔离目录的 .gitconfig（此时应为 work 内容）
if grep -q "alex.johnson@company.example.com" "$H4/.gitconfig" 2>/dev/null; then
  echo "  PASS: .gitconfig written in isolated home"
  PASS=$((PASS + 1))
else
  echo "  FAIL: .gitconfig not written in isolated home"
  FAIL=$((FAIL + 1))
fi

assert_exit "switch to personal" 0 "$CLI" --home "$H4" switch personal
assert_exit "switch nonexistent" 1 "$CLI" --home "$H4" switch nonexistent

# 切到 personal 后 .gitconfig 应为 personal 内容
if grep -q "alex.personal@gmail.com" "$H4/.gitconfig" 2>/dev/null; then
  echo "  PASS: .gitconfig updated to personal after switch"
  PASS=$((PASS + 1))
else
  echo "  FAIL: .gitconfig not updated to personal after switch"
  FAIL=$((FAIL + 1))
fi

# --------------------------------------------------------------------------
# 5. undo
# --------------------------------------------------------------------------
echo ""
echo "--- Test 5: undo ---"
H5="$DATA_DIR/t5"
mkdir -p "$H5"
"$CLI" --home "$H5" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
"$CLI" --home "$H5" add personal --git "$DATA_DIR/gitconfig_personal.txt" >/dev/null 2>&1
"$CLI" --home "$H5" switch work >/dev/null 2>&1
"$CLI" --home "$H5" switch personal >/dev/null 2>&1
assert_json_field "undo --json done=true" "True" "done" "$CLI" --home "$H5" --json undo
assert_exit "undo again" 0 "$CLI" --home "$H5" undo
assert_json_field "undo again --json done=false" "False" "done" "$CLI" --home "$H5" --json undo

# --------------------------------------------------------------------------
# 6. show
# --------------------------------------------------------------------------
echo ""
echo "--- Test 6: show ---"
H6="$DATA_DIR/t6"
mkdir -p "$H6"
"$CLI" --home "$H6" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
"$CLI" --home "$H6" add personal --git "$DATA_DIR/gitconfig_personal.txt" >/dev/null 2>&1
"$CLI" --home "$H6" switch work >/dev/null 2>&1
assert_exit "show by name" 0 "$CLI" --home "$H6" show work
assert_exit "show active" 0 "$CLI" --home "$H6" show
assert_json_field "show --json name=work" "work" "name" "$CLI" --home "$H6" --json show work
assert_exit "show nonexistent" 1 "$CLI" --home "$H6" show nonexistent
assert_json_field "show nonexistent --json" "False" "success" "$CLI" --home "$H6" --json show nonexistent

# --------------------------------------------------------------------------
# 7. backup
# --------------------------------------------------------------------------
echo ""
echo "--- Test 7: backup ---"
H7="$DATA_DIR/t7"
mkdir -p "$H7"
"$CLI" --home "$H7" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
"$CLI" --home "$H7" switch work >/dev/null 2>&1
assert_exit "backup" 0 "$CLI" --home "$H7" backup

# --------------------------------------------------------------------------
# 8. remove / delete
# --------------------------------------------------------------------------
echo ""
echo "--- Test 8: remove ---"
H8="$DATA_DIR/t8"
mkdir -p "$H8"
"$CLI" --home "$H8" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
"$CLI" --home "$H8" add personal --git "$DATA_DIR/gitconfig_personal.txt" >/dev/null 2>&1
assert_exit "remove work" 0 "$CLI" --home "$H8" remove work
assert_exit "delete personal" 0 "$CLI" --home "$H8" delete personal
assert_exit "remove nonexistent" 1 "$CLI" --home "$H8" remove nonexistent
assert_json_array_len "list after remove len=0" "0" "$CLI" --home "$H8" --json list

# --------------------------------------------------------------------------
# 9. update
# --------------------------------------------------------------------------
echo ""
echo "--- Test 9: update ---"
H9="$DATA_DIR/t9"
mkdir -p "$H9"
"$CLI" --home "$H9" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
assert_exit "update" 0 "$CLI" --home "$H9" update work --git "$DATA_DIR/gitconfig_personal.txt"
assert_exit "update nonexistent" 1 "$CLI" --home "$H9" update foo --git "$DATA_DIR/gitconfig_personal.txt"

# --------------------------------------------------------------------------
# 10. templates
# --------------------------------------------------------------------------
echo ""
echo "--- Test 10: templates ---"
H10="$DATA_DIR/t10"
assert_exit "templates" 0 "$CLI" --home "$H10" templates
if "$CLI" --home "$H10" --json templates 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); assert 'github_direct' in d and 'Host' in d['github_direct']"; then
  echo "  PASS: templates --json contains github_direct with Host"
  PASS=$((PASS + 1))
else
  echo "  FAIL: templates --json structure invalid"
  FAIL=$((FAIL + 1))
fi

# --------------------------------------------------------------------------
# 11. verify
# --------------------------------------------------------------------------
echo ""
echo "--- Test 11: verify ---"
H11="$DATA_DIR/t11"
mkdir -p "$H11"
"$CLI" --home "$H11" add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
"$CLI" --home "$H11" switch work >/dev/null 2>&1
assert_exit "verify" 0 "$CLI" --home "$H11" verify
assert_exit "verify nonexistent" 1 "$CLI" --home "$H11" verify nonexistent

# --------------------------------------------------------------------------
# 12. JSON 错误输出
# --------------------------------------------------------------------------
echo ""
echo "--- Test 12: json error handling ---"
H12="$DATA_DIR/t12"
assert_exit "unknown command" 2 "$CLI" --home "$H12" foobar
assert_json_field "unknown command --json" "False" "success" "$CLI" --home "$H12" --json foobar
assert_json_field "switch nonexistent --json" "False" "success" "$CLI" --home "$H12" --json switch nonexistent

# --------------------------------------------------------------------------
# 13. 中文 locale
# --------------------------------------------------------------------------
echo ""
echo "--- Test 13: Chinese locale ---"
H13="$DATA_DIR/t13"
mkdir -p "$H13"
"$CLI" --home "$H13" --lang zh add work --git "$DATA_DIR/gitconfig_work.txt" >/dev/null 2>&1
assert_exit "list --lang zh" 0 "$CLI" --home "$H13" --lang zh list

# --------------------------------------------------------------------------
# 14. log-level
# --------------------------------------------------------------------------
echo ""
echo "--- Test 14: log level ---"
H14="$DATA_DIR/t14"
assert_exit "log-level trace" 0 "$CLI" --home "$H14" --log-level trace list
assert_exit "log-level error" 0 "$CLI" --home "$H14" --log-level error list

# --------------------------------------------------------------------------
# 15. 完整 demo 场景（模拟微软商店测试流程）
# --------------------------------------------------------------------------
echo ""
echo "--- Test 15: 完整 demo 场景 ---"
H15="$DATA_DIR/t15"
mkdir -p "$H15"

# 15a: 空列表
assert_json_array_len "empty list" "0" "$CLI" --home "$H15" --json list

# 15b: 添加两个示例 Profile
assert_exit "demo add Demo Work" 0 "$CLI" --home "$H15" add "Demo Work" --git "$DATA_DIR/gitconfig_work.txt"
assert_exit "demo add Demo Personal" 0 "$CLI" --home "$H15" add "Demo Personal" --git "$DATA_DIR/gitconfig_personal.txt"
assert_json_array_len "demo list len=2" "2" "$CLI" --home "$H15" --json list

# 15c: 切换
assert_exit "demo switch to Demo Work" 0 "$CLI" --home "$H15" switch "Demo Work"
assert_json_field "demo status active" "Demo Work" "activeProfileName" "$CLI" --home "$H15" --json status

# 15d: 切换/撤销/备份/删除
assert_exit "demo switch to Demo Personal" 0 "$CLI" --home "$H15" switch "Demo Personal"
assert_exit "demo undo" 0 "$CLI" --home "$H15" undo
assert_exit "demo backup" 0 "$CLI" --home "$H15" backup
assert_exit "demo remove Demo Personal" 0 "$CLI" --home "$H15" remove "Demo Personal"
assert_json_array_len "demo list len=1" "1" "$CLI" --home "$H15" --json list

echo ""
echo "================================================"
echo " 测试完成: PASS=$PASS  FAIL=$FAIL"
echo "================================================"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0