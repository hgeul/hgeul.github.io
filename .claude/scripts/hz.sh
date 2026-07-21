#!/usr/bin/env bash
# 평행 git-dir 래퍼 (로컬 전용 하네스 저장소) [BASE — 완전 범용]
#
# 하네스 파일(.claude, docs, CLAUDE.md)만 추적하는 별도 git 저장소를 다룬다.
# 프로젝트 git 과 완전히 분리되며 remote 가 없어 push 자체가 불가능하다.
# git-dir 은 $HOME/.<프로젝트명>-harness.git, 작업트리는 이 repo 루트.
#
# 이 블로그는 공개 저장소라 .claude/docs/CLAUDE.md 를 그대로 커밋해도 안전하다.
# hz.sh 는 선택 사항 — 하네스 이력을 코드와 분리하고 싶을 때만 쓴다.
#
# 사용 (프로젝트 어디서 실행해도 경로는 루트 기준):
#   bash .claude/scripts/hz.sh status
#   bash .claude/scripts/hz.sh add .claude docs CLAUDE.md
#   bash .claude/scripts/hz.sh commit -m "harness: ..."
#   bash .claude/scripts/hz.sh log --oneline
#
# 환경변수 HARNESS_GIT_DIR 로 git-dir 위치를 덮어쓸 수 있다.

set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_TREE="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROJ="$(basename "$WORK_TREE")"
GIT_DIR="${HARNESS_GIT_DIR:-$HOME/.${PROJ}-harness.git}"

if [ ! -d "$GIT_DIR" ]; then
  echo "하네스 저장소가 없습니다: $GIT_DIR" >&2
  echo "최초 1회 부트스트랩:" >&2
  echo "  git init --bare \"$GIT_DIR\"" >&2
  echo "  printf '/*\\n!/.claude\\n!/docs\\n!/CLAUDE.md\\n' > \"$GIT_DIR/info/exclude\"" >&2
  echo "  bash .claude/scripts/hz.sh config status.showUntrackedFiles no" >&2
  echo "  bash .claude/scripts/hz.sh add .claude docs CLAUDE.md" >&2
  echo "  bash .claude/scripts/hz.sh commit -m \"harness: 초기 스냅샷\"" >&2
  exit 1
fi

cd "$WORK_TREE" || exit 1
exec git --git-dir="$GIT_DIR" --work-tree="$WORK_TREE" "$@"
