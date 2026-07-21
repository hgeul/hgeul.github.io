# 프론트매터 규칙 (content-frontmatter)

> 글 하나 = `src/content/blog/` 아래 마크다운 한 파일. 프론트매터 스키마를 지켜야 빌드가 통과한다.
> 진실 기준은 **코드**: `src/content.config.ts` 의 zod 스키마가 정답. 이 문서가 코드와 다르면 코드를 따른다.

## 적용 대상

- `src/content/blog/**/*.{md,mdx}`

## 규칙 (스키마: src/content.config.ts 기준)

| 필드 | 필수 | 타입 | 규칙 |
|---|---|---|---|
| `title` | ✅ | string | 비어 있으면 빌드 실패. 글의 핵심을 한 줄로. |
| `description` | 권장 | string | 목록 카드·메타·RSS·SEO 에 쓰인다. 없으면 WARN. 1~2문장. |
| `pubDate` | ✅ | date | `YYYY-MM-DD`. 파싱 실패 시 빌드 실패. 미래 날짜 주의. |
| `updatedDate` | 선택 | date | 큰 수정 시에만. |
| `tags` | 기본 `[]` | string[] | 기존 태그와 표기 일관성 유지(대소문자·언어). |
| `draft` | 기본 `false` | boolean | `true` 면 목록/빌드에서 제외. 발행 시 반드시 `false` 또는 제거. |

- **파일명 = slug = URL**. 영문 kebab-case 권장 (`rag-pipeline.md` → `/blog/rag-pipeline`). 발행 후 파일명 변경은 URL 파손이니 지양.
- 발행하려는 글에 `draft: true` 가 남아 있으면 = **FAIL** (실수 발행 방지).
- 초안 보관은 `draft: true` 로. 완성 전까지 브랜치가 아니라 draft 플래그로도 숨길 수 있다.

## 근거

- Astro content collection 이 빌드 시 zod 로 검증한다. `npm run build` 실패 = 프론트매터 오류가 가장 흔한 원인.
- URL 은 공유·검색 인덱싱의 진입점. 발행 후 slug 변경은 링크를 깬다.

## 관련

- 코드 기준점: `src/content.config.ts:8` (schema)
- 검증: dod-checker `[D]`(프론트매터)·`[F]`(draft 실수발행)·`[I]`(빌드)
- SSOT: `.claude/ssot-index.md` (프론트매터 스키마 도메인)
