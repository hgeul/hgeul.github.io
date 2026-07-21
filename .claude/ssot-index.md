# SSOT 인덱스 (최한글 블로그) [PROJECT overlay]

이 블로그의 "진실 원천" 등록부. 흩어진 진실(코드/설정/규칙/정책)을 한 장에 매핑하고,
각각을 무엇으로 검증하는지 적는다. `/drift`·dod `[N]` 의 점검 대상 목록이다.

## 진실 기준 원칙

- 내부 동작·설정의 진실 = **코드/설정**. 문서가 어긋나면 코드가 정답, 문서를 고친다.
- 외부(라이브러리) 계약의 진실 = 공식 문서. 우리 코드가 따라간다.
- marker 블록으로 외부 도구가 관리하는 영역은 그 도구가 주인. 드리프트 검사 제외(INFO).

## 등록부

| 진실 도메인 | 권위 원천(문서) | 진실 기준(코드/설정) | 검증 방법 |
|---|---|---|---|
| 프론트매터 스키마 | `.claude/rules/content-frontmatter.md` | `src/content.config.ts` (zod) | `npm run build` + 표↔스키마 대조 |
| 글쓰기 규칙 | `.claude/rules/writing-style.md` | 글로벌 CLAUDE.md + 본문 | dod `[E]`(앰대시)·`[G]`(사실) |
| 발행 안전(익명화) | `.claude/rules/publish-safety.md` | 발행 본문 + `.claude/sensitive-terms.local` | dod `[M]` + pre-commit 훅 |
| 사이트 메타 | `src/consts.ts` 자체 | `src/consts.ts`, `astro.config.mjs` | 헤더/푸터/RSS 렌더 결과 |
| 커밋/워크플로 | `CLAUDE.md`, `HARNESS.md` | `.claude/hooks/pre-commit-check.sh`(실행) | 훅 정규식이 실제 게이트 |
| 배포 흐름 | `README.md` | `.github/workflows/deploy.yml` | Actions 실행 로그 |

## 알려진 드리프트 (해소 대기)

- (발견되는 대로 한 줄씩)

## 갱신 규칙

- 새 진실 도메인(새 규칙, 새 설정 파일)이 생기면 여기 한 줄 추가.
- 권위 원천 파일을 옮기거나 이름 바꾸면 여기부터 고친다.
