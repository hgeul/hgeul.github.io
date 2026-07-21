# 최한글 블로그 (hgeul.github.io) 작업 지침

> 이 파일은 매 턴 자동 로드된다. 절마다 [BASE] = 하네스 골격(그대로 둠), [PROJECT] = 이 블로그 고유.
> 하네스 이식 구조·공유 경계는 `HARNESS.md` 참고.
> 이 저장소는 **공개**다. `main` push = `hgeul.github.io` 자동 배포.

## 이 프로젝트가 무엇인가 [PROJECT]

- Astro 정적 사이트 + GitHub Pages. 글 하나 = `src/content/blog/` 아래 마크다운 한 파일.
- `main` 브랜치 push → GitHub Actions(`.github/workflows/deploy.yml`) → Pages 배포.
- 목적: 백엔드·AI 시스템을 만들며 얻은 **결정·교훈·트러블슈팅**을 기록. 코드가 아니라 판단을 남긴다.

## 워크플로 [BASE + PROJECT]

생산(초안)은 AI가 한다. 사람의 메인 작업은 검증과 판단이다.
솔로 블로그라 `main` 에서 직접 작업·커밋한다. **발행 게이트는 브랜치가 아니라 `git push` 직전의 `/dod` 다.**

1. 글 작성. 실험·구현을 글로 바꿀 땐 `build-to-blog` 스킬 사용 (조사 → 구현 → 검증 → 공식소스 대조 → 초안)
2. `/grill`: 발행 전 캐묻기(사실정확성·익명화·구조) + 답을 `docs/decisions/<슬러그>.md` 에 박제
3. 보완
4. `/dod`: 규칙 결정론 검수 (빌드·앰대시·프론트매터·민감어) PASS/FAIL/WARN
5. `git commit` → `git push` → 자동 배포(=발행)

**발행 경계 = 아직 push 안 된 변경**: `origin/main..HEAD`(미푸시 커밋) + 미커밋 + untracked.
`/grill`·`/dod` 는 이 범위를 검수한다. 그래서 커밋을 먼저 해도 push 전이면 계속 검수된다.
초안을 잠시 숨기려면 브랜치 대신 프론트매터 `draft: true` 를 쓴다. (큰 사이트 개편처럼 격리가 필요하면 브랜치를 써도 된다.)

## 커밋 메시지 [PROJECT]

컨벤셔널 커밋: `<type>(<scope 선택>): <설명>`

- `type`: `post`(새 글) · `edit`(기존 글 수정) · `feat`(사이트 기능/디자인) · `fix`(버그) · `style`(CSS/디자인) · `chore`(설정/빌드) · `docs`(저장소 문서)
- 예: `post: RAG 검색 파이프라인 회고`, `style: 다크모드 대비 개선`, `chore: 배포 워크플로 노드 버전 상향`
- 토큰은 `.claude/hooks/pre-commit-check.sh` CONFIG 블록과 일치시킬 것.
- **AI 도구 언급·공동저자 트레일러 금지** (훅이 차단).

## 코드/글 작성 시 자동 적용 규칙 [PROJECT overlay]

아래 규칙은 매칭 파일을 수정하기 **전에** 따른다. 생성 단계에서 기술부채·유출을 차단한다.

@.claude/rules/writing-style.md
@.claude/rules/content-frontmatter.md
@.claude/rules/publish-safety.md

## 검증 우선순위 [BASE] (인지부채 관리)

다 검증하려 하면 지친다. **경계를 넘는 결과물**부터 철저히 본다.
이 블로그에서 "경계를 넘는 것" = **공개 발행되는 텍스트**.

- 철저 검증: 발행 본문의 사실 정확성(정량 수치·주장), 민감정보 익명화, 프론트매터(빌드 파손), 앰대시.
- 가벼운 검증: 내부 컴포넌트·스타일 미세조정.

가능하면 자동화한다 (`npm run build`, dod 정적검출). 사람 확인은 사실성·익명화에 집중.

## 의도·결정 기록 [BASE] (의도부채 관리)

"왜 이렇게 만들었나 / 왜 이렇게 썼나"가 휘발되지 않게 박제한다.

- 이번 작업의 결정: `docs/decisions/<브랜치>.md` (ADR, 템플릿 `docs/decisions/_TEMPLATE.md`)
- 블로그 운영 정책·글쓰기 회색지대: `docs/policy/`

진실 원천 지도는 `.claude/ssot-index.md`. `/drift` 가 이걸 기준으로 코드·설정·글과의 괴리를 점검한다.
