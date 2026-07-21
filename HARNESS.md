# 하네스 구조 (이 블로그 = harness-base overlay)

이 하네스는 로컬 `harness-base` 저장소의 BASE 골격 위에 **블로그 도메인 overlay** 를 얹은 것이다.
BASE = 만드는 방법(절차·엔진). overlay = 이 블로그에서 "무엇이 옳은가"(글쓰기·발행 판단).

## harness-base 와 다른 점 (공유 경계가 반전된다)

| | harness-base (엔터프라이즈) | 이 블로그 |
|---|---|---|
| 저장소 | push 금지 (고객 기밀 포함) | **공개**. `main` push = 자동 배포 |
| 최대 리스크 | 저장소 유출 | **공개 글에 사내 기밀이 새는 것** |
| 도메인 | 코드 정확성(DTO·격리·마이그레이션) | 글 품질(사실성·구조) + 발행 안전(익명화) |
| 커밋 형식 | `[채널][분류]` | 컨벤셔널 커밋 |

핵심 반전: harness-base 는 "이 repo 를 밖으로 내보내지 마라". 이 블로그는 "이 repo 로 밖의 기밀을 들여오지 마라".
그래서 민감어 denylist(`.claude/sensitive-terms.local`)는 **저장소에 커밋하지 않는다** (그 자체가 유출이므로).

## BASE (harness-base 에서 그대로 이식 — 골격)

| 파일 | BASE 부분 |
|---|---|
| `CLAUDE.md` | 워크플로 / 검증 우선순위 / 의도·결정 기록 절 |
| `.claude/commands/grill.md`, `dod.md`, `drift.md` | 호출부 + 실행 절차 |
| `.claude/agents/design-grill.md` | 역할·스캔범위·출력형식·행동원칙 골격 |
| `.claude/agents/dod-checker.md` | 검수 범위·출력형식·행동원칙 + 범용 항목(A/B/C/K/N) |
| `.claude/agents/drift-detector.md` | 진실기준 원칙·Tier1~3 절차·출력형식 |
| `.claude/scripts/drift-anchors.sh` | Tier1 앵커 무결성 (DOC_TARGETS/SRC 만 조정) |
| `.claude/scripts/hz.sh` | 평행 git-dir 래퍼 (완전 범용, 이 공개 repo 에선 선택) |
| `.claude/hooks/pre-commit-check.sh` | 게이트 로직 (CONFIG 블록·검사만 블로그화) |
| `docs/decisions/_TEMPLATE.md` | ADR 템플릿 |
| `docs/policy/README.md` | 정책 위키 운영 규칙 |

## PROJECT overlay (이 블로그 고유 — 새로 작성)

| 파일 | PROJECT 부분 |
|---|---|
| `CLAUDE.md` | 커밋 토큰 / 규칙 import / 블로그 워크플로 |
| `.claude/rules/writing-style.md` | 앰대시 금지·OREO·표우선·검증된 사실만 |
| `.claude/rules/content-frontmatter.md` | 프론트매터 스키마(코드 기준) |
| `.claude/rules/publish-safety.md` | 익명화·시크릿 금지·denylist 운영 |
| `.claude/agents/dod-checker.md` | PROJECT 검증항목(D~M) |
| `.claude/agents/design-grill.md` | 질문 축(사실성·익명화·구조·제목·태그) |
| `.claude/ssot-index.md` | 진실 원천 등록부 |
| `.claude/scripts/drift-anchors.sh` | `DOC_TARGETS`/`SRC_EXT`/`SRC_ROOT` |
| `.claude/hooks/pre-commit-check.sh` | CONFIG(커밋 토큰·보호 브랜치) + 앰대시·민감어 검사 |
| `.claude/sensitive-terms.local` | 민감 고유명사 목록. **gitignored, 각자 채움** |

## 삭제한 BASE (블로그에 안 맞아 제외)

- `docs/feature/`, `docs/spec/`, `docs/reference/`: 기능개발서·스펙·외부계약. 블로그는 "기능"을 배포하지 않으므로 제외. 필요해지면 harness-base 에서 다시 가져온다.

## 하네스 이력을 코드와 분리하려면 (선택)

이 저장소는 공개이고 `.claude`·`docs`·`CLAUDE.md` 를 그대로 커밋해도 안전하다(고객 기밀 없음, denylist 제외).
굳이 분리 이력을 원하면 `hz.sh` 평행 git-dir 사용 가능하나, 공개 블로그에선 대개 불필요하다.
