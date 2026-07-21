#!/bin/bash
#
# Claude Code PreToolUse Hook - 커밋 전 게이트 [BASE + 블로그]
#
# 프로젝트별로 고칠 것은 아래 CONFIG 블록과 print_checklist() 뿐이다.
# .claude/settings.json 의 PreToolUse(Bash) 훅으로 연결된다.
#
# 흐름:
#   1. JSON 입력에서 tool_input.command 추출
#   2. 토큰 단위로 'git commit' 아니면 즉시 통과
#   3. 보호 브랜치면 차단 (기본 off: 솔로 블로그는 main 직접 커밋 허용). CONFIG 로 재활성화 가능.
#   4. 메시지: AI 도구 언급 차단 + 컨벤셔널 커밋 형식 검증
#   5. 통과하면 체크리스트 출력 (soft reminder)

# ── CONFIG [PROJECT] ──────────────────────────────────────────────
PROTECTED_BRANCHES=""                                  # 솔로 블로그: main 직접 커밋 허용. 발행 게이트는 push 전 /dod.
# 컨벤셔널 커밋 타입 (dod-checker [C] / CLAUDE.md 와 일치시킬 것)
MSG_TYPES="post|edit|feat|fix|style|chore|docs|refactor"
# ──────────────────────────────────────────────────────────────────

input=$(cat)

# ── 1. JSON에서 command 추출 ──
if command -v jq > /dev/null 2>&1; then
  command_str=$(echo "$input" | jq -r '.tool_input.command // empty')
else
  command_str=$(echo "$input" | python -c 'import sys, json
try:
    print(json.loads(sys.stdin.read()).get("tool_input", {}).get("command", ""))
except Exception:
    pass' 2>/dev/null)
fi
[ -z "$command_str" ] && exit 0

# ── 2. git commit 호출 여부 (토큰 단위) ──
if ! echo "$command_str" | grep -qE '(^|[[:space:]]|;|&&|\|\|)git[[:space:]]+commit([[:space:]]|$)'; then
  exit 0
fi

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# ── 3. 보호 브랜치 직접 커밋 차단 (PROTECTED_BRANCHES 비어 있으면 no-op) ──
for b in $PROTECTED_BRANCHES; do
  if [ "$branch" = "$b" ]; then
    echo "[BLOCKED] '$branch' 브랜치에 직접 커밋할 수 없습니다."
    echo ""
    echo "작업용 브랜치를 먼저 만드세요:"
    echo "  git checkout -b <작업-브랜치>"
    exit 2
  fi
done

# ── 4. 커밋 메시지 추출 (heredoc / 큰따옴표 / 작은따옴표) ──
extract_commit_msg() {
  CMD_INPUT="$1" python <<'PYEOF' 2>/dev/null
import os, re
cmd = os.environ.get("CMD_INPUT", "")
heredoc = re.search(r"<<\s*['\"]?([A-Za-z_][A-Za-z0-9_]*)['\"]?\s*\n(.*?)\n\s*\1\s*", cmd, re.S)
if heredoc:
    print(heredoc.group(2))
else:
    m = re.search(r'-m\s+"((?:[^"\\]|\\.)*)"', cmd)
    if m: print(m.group(1))
    else:
        m = re.search(r"-m\s+'([^']*)'", cmd)
        if m: print(m.group(1))
PYEOF
}

commit_msg=$(extract_commit_msg "$command_str")

if [ -n "$commit_msg" ]; then
  # ── 4a. AI 도구 / 공동저자 / 이모지 차단 (합법 참조는 정제 후 검사) ──
  msg_for_scan=$(echo "$commit_msg" \
    | sed -E 's/CLAUDE\.md//gI' \
    | sed -E 's|\.claude/[A-Za-z0-9_./-]*||gI' \
    | sed -E 's/\.claude\b//gI')
  if echo "$msg_for_scan" | grep -iE 'Co-Authored-By:|generated with|🤖|Claude|ChatGPT|Copilot' > /dev/null; then
    echo "[BLOCKED] 커밋 메시지에 AI 도구 언급 또는 공동저자 트레일러가 포함되어 있습니다."
    echo "  - AI 도구 언급 / Co-Authored-By / 이모지 제거 후 다시 커밋"
    exit 2
  fi

  # ── 4b. 앰대시(—) 차단 (글로벌 규칙) ──
  if printf '%s' "$commit_msg" | grep -qP '\x{2014}'; then
    echo "[BLOCKED] 커밋 메시지에 앰대시(—)가 있습니다. 콜론(:)/쉼표(,)/마침표(.)로 바꾸세요. (글로벌 규칙)"
    exit 2
  fi

  # ── 4c. 컨벤셔널 커밋 형식 검증 ──
  first_line=$(echo "$commit_msg" | head -1)
  if ! echo "$first_line" | grep -qE "^(${MSG_TYPES})(\([^)]+\))?: .+"; then
    echo "[BLOCKED] 커밋 메시지 형식이 올바르지 않습니다."
    echo ""
    echo "현재 첫 줄: $first_line"
    echo "필수 형식: <type>(<scope 선택>): <설명>"
    echo "type: ${MSG_TYPES}"
    echo "예: post: RAG 검색 파이프라인 회고"
    exit 2
  fi
fi

# ── 5. 체크리스트 (soft reminder) ──
print_checklist() {
  echo "======================================"
  echo " 커밋 전 체크리스트  (브랜치: $branch)"
  echo "======================================"
  echo "[공통 비협상]"
  echo "  □ 앰대시(—) 없음 / AI 도구 언급·Co-Authored-By·이모지 없음"
  echo "  □ 하드코딩된 시크릿·토큰 없음"
  echo ""
  echo "[발행 안전 — 이 repo 는 공개다]"
  echo "  □ 사내 프로젝트명·고객사·동료 실명·내부 호스트 익명화됨"
  echo "  □ 본문의 정량 수치·버전 주장 → 공식 소스로 확인됨"
  echo ""
  echo "[콘텐츠]"
  echo "  □ 프론트매터 title/pubDate 있음, 발행 글은 draft:true 아님"
  echo "  □ push(발행) 직전 → /grill (판단) → /dod (규칙) 실행"
  echo "======================================"
}
print_checklist

exit 0
