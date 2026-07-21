---
description: design-grill 서브에이전트로 발행 직전 글의 사실성·익명화·구조를 캐묻고 ADR로 박제한다
argument-hint: "[브랜치명]"
---

# /grill — 발행 전 캐묻기 (grill-with-docs)

`.claude/agents/design-grill.md` 의 design-grill 서브에이전트를 호출하여,
아직 push 안 된 변경(미푸시 커밋+미커밋+untracked)에 대해 **dod-checker(규칙 기계 검출)가
못 잡는 판단 차원의 질문**을 받는다. 답변은 ADR 로 박제해 의도부채를 막는다.

검수 범위 인자: $ARGUMENTS

## 실행 절차

1. **인자 파싱**:
   - `$ARGUMENTS` 가 비어 있으면 현재 브랜치 (`git rev-parse --abbrev-ref HEAD`)
   - 비어 있지 않으면 인자를 대상 브랜치명으로 해석

2. **에이전트 호출**: Agent 도구로 `subagent_type=design-grill` 실행.

   전달 프롬프트:
   ```
   대상 브랜치: <위에서 결정한 브랜치명>
   발행 경계(=아직 push 안 된 변경): origin/main..HEAD(미푸시 커밋) + 미커밋 + untracked.
   (origin/main 이 없으면 main 로 폴백.)

   .claude/agents/design-grill.md 의 질문 축을 따라 변경된 글/페이지에 대해서만
   구체적(파일:라인, 문장 인용) 질문을 생성하라.
   변경이 없는 축은 섹션 자체를 생략하라.
   자동 수정 금지, 점수화 금지. 추측 금지 — 실제 diff·본문에 근거한 질문만.
   사전에 .claude/rules/*.md 를 Read 로 로드하여 인용을 정확히 한다.
   특히 사실성(정량 수치·주장)과 익명화(사내 고유명사)를 우선 캐물어라.
   ```

3. **결과 처리**:
   - 에이전트 질문 목록을 사용자에게 그대로 전달
   - 사용자가 답하거나 보완한 후 다음 단계로 진행

4. **산출물 기록 (grill-with-docs)**:
   - 사용자가 질문에 답하면, 그 문답과 결정을 `docs/decisions/<브랜치>.md` 에 박제한다.
   - 파일이 없으면 `docs/decisions/_TEMPLATE.md` 를 복사해 생성, 있으면 append.
   - 기록 대상: 맥락 · 글의 핵심 주장과 근거 · 익명화 판단 · 확인한 사실 출처 · 만료 조건 · 문답 로그.
   - 목적: "왜 이렇게 썼나 / 어떤 수치를 어디서 확인했나"가 휘발되지 않게, 다음 세션이 재활용하게.
   - 기록 후 /dod 로 진행.

## /dod 와의 분담

| 도구 | 차원 | 결과 |
|---|---|---|
| `/grill` | 판단 (사실성·익명화·구조, Socratic) | 질문 목록 + ADR |
| `/dod` | 규칙 위반 (빌드·앰대시·프론트매터, 결정론) | PASS/FAIL/WARN |

권장 순서: **`/grill` → 보완 → docs/decisions 기록 → `/dod` → push(=발행)**
